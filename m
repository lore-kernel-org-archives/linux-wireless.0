Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58299 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1HLCf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:35:29 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so609089iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:35:28 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v3 2/6] ieee80211: introduce Self Protected Action codes
Date: Thu, 11 Aug 2011 19:35:11 -0700
Message-Id: <1313116515-26166-2-git-send-email-thomas@cozybit.com> (sfid-20110812_043531_478127_233015BB)
In-Reply-To: <1313116515-26166-1-git-send-email-thomas@cozybit.com>
References: <1313116515-26166-1-git-send-email-thomas@cozybit.com>
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
1.7.4.1

