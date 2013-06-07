Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57603 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757026Ab3FGSOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:25 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net, bvahl@net.t-labs.tu-berlin.de
Subject: [PATCH 1/3] mac80211: restructure tx_control_flag handling in ieee80211_tx_info
Date: Fri,  7 Jun 2013 20:13:21 +0200
Message-Id: <1370628803-28785-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130607_201438_956062_188A0359)
In-Reply-To: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All usable  bits in enum mac80211_tx_control_flags are depleted. In
order to allow aditional control flag assigments, we introduce a
new u16 variable ieee8011_tx_info->control.flags2 with its
corresponding enum mac80211_tx_control_flags2. Such tx control flags
within ieee80211_tx_info->flags that are only used in the tx path
while ieee80211_tx_info->control is valid can be moved to
ieee80211_tx_control->control.flags2.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 include/net/mac80211.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a405a7a..2d8e461 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -500,6 +500,15 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(31),
 };
 
+/**
+ * enum mac80211_tx_control_flags2 - control related flags to describe transmission information/status
+ *
+ * These flags are used with the @flags2 member of &ieee80211_tx_info inside control
+ * and are only available within the tx path where tx_info->control is valid.
+ */
+enum mac80211_tx_control_flags2 {
+};
+
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
 
 /*
@@ -675,7 +684,8 @@ struct ieee80211_tx_info {
 			/* NB: vif can be NULL for injected frames */
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
-			/* 8 bytes free */
+			u16 flags2;
+			/* 6 bytes free */
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
-- 
1.7.9.5

