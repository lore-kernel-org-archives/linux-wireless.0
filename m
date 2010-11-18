Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41392 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0KRPgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 10:36:52 -0500
Received: by yxf34 with SMTP id 34so1889091yxf.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 07:36:51 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Use sw crypto for GTKs on AP VLAN interfaces
Date: Thu, 18 Nov 2010 16:36:27 +0100
Message-Id: <1290094587-5387-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using AP VLAN interfaces, each VLAN interface should be in its own
broadcast domain. Hostapd achieves this by assigning different GTKs to
different AP VLAN interfaces.

However, mac80211 drivers are not aware of AP VLAN interfaces and as
such mac80211 sends the GTK to the driver in the context of the base AP
mode interface. This causes problems when multiple AP VLAN interfaces
are used since the driver will use the same key slot for the different
GTKs (there's no way for the driver to distinguish the different GTKs
from different AP VLAN interfaces). Thus, only the clients associated
to one AP VLAN interface (the one that was created last) can actually
use broadcast traffic.

Fix this by not programming any GTKs for AP VLAN interfaces into the hw
but fall back to using software crypto. The GTK for the underlying AP
interface is still sent to the driver.

That means, broadcast traffic to and from stations associated to an AP
VLAN interface is encrypted and decrypted in software whereas broadcast
traffic to and from stations associated to the non-VLAN AP interface is
encrypted end decrypted in hardware.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

This incidentally also fixes the mac8011 oops related to AP VLAN
interfaces I've reported earlier.

If we want to support hardware crypto for broadcast traffic on AP VLAN
interfaces we'd either need to switch to per station GTKs or need to
make drivers aware of VLAN interfaces. Not sure if it's worth it.

At least current rt2x00 devices won't be able to support that due to
the limited amount of available key space.

 net/mac80211/key.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ccd676b..72df1ca 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -84,10 +84,17 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		goto out_unsupported;
 
 	sdata = key->sdata;
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		/*
+		 * The driver doesn't know anything about VLAN interfaces.
+		 * Hence, don't send GTKs for VLAN interfaces to the driver.
+		 */
+		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			goto out_unsupported;
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data,
 				     u.ap);
+	}
 
 	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
 
-- 
1.7.1

