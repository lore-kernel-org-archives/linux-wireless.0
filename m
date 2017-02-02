Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33166 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdBBAGA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 19:06:00 -0500
Received: by mail-pg0-f66.google.com with SMTP id 194so33984pgd.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 16:05:38 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Remove VHT Capabilities/Operation IEs from mesh beacon if VHT was disabled
Date: Thu,  2 Feb 2017 09:05:28 +0900
Message-Id: <1485993928-3822-1-git-send-email-masashi.honma@gmail.com> (sfid-20170202_010830_234400_9D5F5AB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wpa_supplicant.conf includes disable_ht=1, the beacon of the mesh
node does not have HT Capabilities/Operation IEs. However, the beacon
of the mesh node has VHT Capabilities/Operation IEs even though
wpa_supplicant.conf includes disable_vht=1.

This patch removes VHT Capabilities/Operation IEs when the
wpa_supplicant.conf includes disable_vht=1. We recognize the local peer
as 11ac ready, when it has more than 80MHz band width. Because
net/mac80211/util.c#ieee80211_build_preq_ies_band() uses 80MHz threshold
for VHT Capabilities IE inclusion.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/mesh.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9c23172..a30be19 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -469,9 +469,9 @@ int mesh_add_vht_cap_ie(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[band];
 	if (!sband->vht_cap.vht_supported ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
+	    !(sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_80 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_80P80 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_160))
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_vht_cap))
@@ -506,9 +506,9 @@ int mesh_add_vht_oper_ie(struct ieee80211_sub_if_data *sdata,
 	vht_cap = &sband->vht_cap;
 
 	if (!vht_cap->vht_supported ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
+	    !(sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_80 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_80P80 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_160))
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_vht_operation))
-- 
2.7.4
