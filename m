Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52637 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1HITvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:51:25 -0400
Received: by ywf7 with SMTP id 7so245905ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 12:51:25 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 2/6] ieee80211: introduce Self Protected Action codes
Date: Tue,  9 Aug 2011 12:50:14 -0700
Message-Id: <1312919418-32196-3-git-send-email-thomas@cozybit.com> (sfid-20110809_215129_293975_7135209A)
In-Reply-To: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
References: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11s introduces a new action frame category, add action codes as well
as an entry in ieee80211_mgmt.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/ieee80211.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 54c8789..5c00a63 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -749,6 +749,10 @@ struct ieee80211_mgmt {
 					 */
 					u8 variable[0];
 				} __attribute__((packed)) plink_action;
+				struct {
+					u8 action_code;
+					u8 variable[0];
+				} __attribute__((packed)) self_prot;
 				struct{
 					u8 action_code;
 					u8 variable[0];
@@ -1309,6 +1313,16 @@ enum ieee80211_ht_actioncode {
 	WLAN_HT_ACTION_ASEL_IDX_FEEDBACK = 7,
 };
 
+/* Self Protected Action codes */
+enum ieee80211_self_protected_actioncode {
+	WLAN_SP_RESERVED = 0,
+	WLAN_SP_MESH_PEERING_OPEN = 1,
+	WLAN_SP_MESH_PEERING_CONFIRM = 2,
+	WLAN_SP_MESH_PEERING_CLOSE = 3,
+	WLAN_SP_MGK_INFORM = 4,
+	WLAN_SP_MGK_ACK = 5,
+};
+
 /* Security key length */
 enum ieee80211_key_len {
 	WLAN_KEY_LEN_WEP40 = 5,
-- 
1.7.6

