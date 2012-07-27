Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38473 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2G0SQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 14:16:15 -0400
Received: by yhmm54 with SMTP id m54so3499362yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 11:16:15 -0700 (PDT)
From: Javier Lopez <jlopex@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, chunkeey@googlemail.com,
	Javier Lopez <jlopex@cozybit.com>
Subject: [PATCH v2] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
Date: Fri, 27 Jul 2012 11:16:04 -0700
Message-Id: <1343412964-3675-1-git-send-email-jlopex@cozybit.com> (sfid-20120727_201619_039200_CFA75975)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains following modifications:

- Add mesh capabilities on fw.c to permit creation of mesh
  interfaces using this driver.

- Modify carl9170_set_operating_mode, to use AP-style beaconing
  with mesh interfaces.

- Allow beacon updates for NL80211_IFTYPE_MESH_POINT type in
  carl9170_handle_command_response.

- Add NL80211_IFTYPE_MESH_POINT case on carl9170_op_add_interfaces to
  support mesh/ap/sta virtual interface combinations.

Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
v2: support mesh/ap/sta vif combinations (Christian)

 drivers/net/wireless/ath/carl9170/fw.c  |    1 +
 drivers/net/wireless/ath/carl9170/mac.c |    2 +-
 drivers/net/wireless/ath/carl9170/rx.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index cba9d04..b03d7bf 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -304,6 +304,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		if (SUPP(CARL9170FW_WLANTX_CAB)) {
 			if_comb_types |=
 				BIT(NL80211_IFTYPE_AP) |
+				BIT(NL80211_IFTYPE_MESH_POINT) |
 				BIT(NL80211_IFTYPE_P2P_GO);
 		}
 	}
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index dfda919..a5f5fa0 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -318,10 +318,10 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
 		bssid = common->curbssid;
 
 		switch (vif->type) {
-		case NL80211_IFTYPE_MESH_POINT:
 		case NL80211_IFTYPE_ADHOC:
 			cam_mode |= AR9170_MAC_CAM_IBSS;
 			break;
+		case NL80211_IFTYPE_MESH_POINT:
 		case NL80211_IFTYPE_AP:
 			cam_mode |= AR9170_MAC_CAM_AP;
 
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index dc99030..3be2130 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -206,6 +206,7 @@ void carl9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
 			carl9170_update_beacon(ar, true);
 			break;
 
-- 
1.7.9.5

