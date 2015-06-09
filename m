Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33496 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbbFIFfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 01:35:52 -0400
Received: by pdjn11 with SMTP id n11so7189061pdj.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 22:35:52 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the beacon csa counter for mesh and ibss
Date: Tue,  9 Jun 2015 13:35:33 +0800
Message-Id: <1433828133-6904-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150609_073556_059012_196FB461)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The csa counter has moved from sdata to beacon/presp but
it is not updated accordingly for mesh and ibss. Fix this.

This regression is introduced by the following patch:
mac80211: move csa counters from sdata to beacon/presp

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c  | 1 +
 net/mac80211/ibss.c | 1 +
 net/mac80211/mesh.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bb9f836..0fdfc20 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3443,6 +3443,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	/* Update CSA counters */
 	if (sdata->vif.csa_active &&
 	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
 	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
 	    params->n_csa_offsets) {
 		int i;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 21716af..7f72bc9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -146,6 +146,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 				csa_settings->chandef.chan->center_freq);
 		presp->csa_counter_offsets[0] = (pos - presp->head);
 		*pos++ = csa_settings->count;
+		presp->csa_current_counter = csa_settings->count;
 	}
 
 	/* put the remaining rates in WLAN_EID_EXT_SUPP_RATES */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d468424..817098a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -680,6 +680,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		*pos++ = 0x0;
 		*pos++ = ieee80211_frequency_to_channel(
 				csa->settings.chandef.chan->center_freq);
+		bcn->csa_current_counter = csa->settings.count;
 		bcn->csa_counter_offsets[0] = hdr_len + 6;
 		*pos++ = csa->settings.count;
 		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
-- 
2.3.0

