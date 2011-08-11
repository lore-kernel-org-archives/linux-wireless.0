Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58575 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1HKORx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 10:17:53 -0400
Received: by fxh19 with SMTP id 19so1694353fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 07:17:52 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] wireless: Introduce defines for BAR TID_INFO & MULTI_TID fields
Date: Thu, 11 Aug 2011 16:17:41 +0200
Message-Id: <1313072262-25413-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110811_161756_600538_086E2A27)
In-Reply-To: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
References: <1313053697-19544-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While at it also fix the indention of the other IEEE80211_BAR_CTRL_ defines.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 include/linux/ieee80211.h |    8 +++++---
 net/mac80211/agg-tx.c     |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 54c8789..5286de5 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -816,9 +816,11 @@ struct ieee80211_bar {
 } __attribute__((packed));
 
 /* 802.11 BAR control masks */
-#define IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL     0x0000
-#define IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA  0x0004
-
+#define IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL	0x0000
+#define IEEE80211_BAR_CTRL_MULTI_TID		0x0002
+#define IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA	0x0004
+#define IEEE80211_BAR_CTRL_TID_INFO_MASK	0xf000
+#define IEEE80211_BAR_CTRL_TID_INFO_SHIFT	12
 
 #define IEEE80211_HT_MCS_MASK_LEN		10
 
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index b7075f3..018108d 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -128,7 +128,7 @@ void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u1
 	memcpy(bar->ta, sdata->vif.addr, ETH_ALEN);
 	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
 	bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
-	bar_control |= (u16)(tid << 12);
+	bar_control |= (u16)(tid << IEEE80211_BAR_CTRL_TID_INFO_SHIFT);
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-- 
1.7.3.4

