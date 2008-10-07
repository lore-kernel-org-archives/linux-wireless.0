Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49883 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYJGTrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 15:47:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC PATCH] rtl8187: do not report ACKs if USB Tx status is non-zero
Date: Tue,  7 Oct 2008 15:18:18 -0400
Message-Id: <1223407098-23060-1-git-send-email-linville@tuxdriver.com> (sfid-20081007_214742_308770_3C062848)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vendor-supplied driver treats a USB Tx failure as an un-ACKed frame.
I don't see why we shouldn't do the same thing -- hopefully this makes
rate-scaling algorithms behave sanely with the rtl8187 driver.

Thanks to Felix Fietkau <nbd@openwrt.org> for suggesting this as an
option.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This is currently untested -- anyone with rtl8187 bored enough to try
it? :-)

 drivers/net/wireless/rtl8187_dev.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index ca5deb6..ae21191 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -164,7 +164,12 @@ static void rtl8187_tx_cb(struct urb *urb)
 	skb_pull(skb, priv->is_rtl8187b ? sizeof(struct rtl8187b_tx_hdr) :
 					  sizeof(struct rtl8187_tx_hdr));
 	memset(&info->status, 0, sizeof(info->status));
-	info->flags |= IEEE80211_TX_STAT_ACK;
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+		if (!urb->status)
+			info->flags |= IEEE80211_TX_STAT_ACK;
+		else /* assume ACK not received */
+			info->status.excessive_retries = 1;
+	}
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-- 
1.5.4.3

