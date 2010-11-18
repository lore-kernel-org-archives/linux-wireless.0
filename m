Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59917 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab0KRIrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 03:47:46 -0500
Received: by fxm6 with SMTP id 6so1366500fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 00:47:45 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: GTK issues wrt dynamic VLAN tagging with hostapd + mac80211
Date: Thu, 18 Nov 2010 09:44:59 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011180944.59216.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm just playing with dynamic VLAN tagging using hostapd + mac80211 +
rt2800pci. It looks very promising so far, hostapd automatically creates
the according vlan interfaces (wlan0.100, wlan0.101, ...) on top of wlan0
as soon as a client associates. The wireless traffic appears on the correct
interface for each station but there's a problem with broadcast traffic.

Hostapd generates per default one GTK for each VLAN interface. That means
wlan0.100 and wlan0.101 get different GTKs (that's also what I've expected
since each VLAN should be in its own broadcast domain).

However, mac80211 will configure the GTK to the hw as follows:

static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
{
	[...]

        /*  
         * If this is a per-STA GTK, check if it
         * is supported; if not, return.
         */
        if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
            !(key->local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK))
                goto out_unsupported;

        sdata = key->sdata;
        if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
                sdata = container_of(sdata->bss,
                                     struct ieee80211_sub_if_data,
                                     u.ap);

        ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);

So, on a VLAN interface it will tell the driver to set the key as if it was
meant for the subjacent AP mode interface.

As a result when the first client ends up on wlan0.100, the GTK for VLAN 100
gets configured to the hw. When a second client ends up on wlan0.101, the GTK
for VLAN 101 gets configured to the hw but the driver has no chance to
distinguish the both GTKs as both are configured for the same interface.
In case of rt2x00 that means the GTK gets overwritten and the client that
associated first won't be able to decrypt any broadcast frames anymore since
they are encrypted with the GTK for VLAN 101.

To fix this issue we could disable hw crypto by default on VLAN interfaces or
we could configure the GTK as a special form of per station GTKs.

For rt2x00 we definitely need to fall back to sw crypto since the hw only
allows 4 GTKs (index 0..3) per bssid and no per-station GTKs.

Are there any drivers that could make use of per-VLAN GTKs? In that case we
need to make the driver aware of the different GTKs and would need a flag if
the driver supports different GTKs for VLANs on one BSSID.

Thanks,
Helmut

Using this patch broadcast traffic on VLAN interfaces will always fall back
to sw crypto and fixes this problem for me.

Any objections?

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ccd676b..2ddd767 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -85,9 +85,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	sdata = key->sdata;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
-				     u.ap);
+		goto out_unsupported;
 
 	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
 
@@ -135,9 +133,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sdata = key->sdata;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
-				     u.ap);
+		return;
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta, &key->conf);
