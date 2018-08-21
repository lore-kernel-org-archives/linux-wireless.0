Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbeHULNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 07:13:13 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Vidya Dharmaraju <vidyad@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/2] mwifiex: do no submit URB in suspended state
Date: Tue, 21 Aug 2018 13:23:01 +0530
Message-ID: <1534837982-31206-1-git-send-email-gbhat@marvell.com> (sfid-20180821_095412_077232_525AD007)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a possible race between USB suspend and main thread:

1. After processing the command response, main thread will submit
rx_cmd URB back so as to process next command response, by
calling mwifiex_usb_submit_rx_urb.

2. During USB suspend, the suspend handler will check if rx_cmd
URB is pending(submitted) and if true, kill this URB.

There is a possible race between #1 and #2, where rx_cmd URB will
be submitted by main thread(#1) after the suspend handler check
in #2.

To fix this, check if device is already suspended in
mwifiex_usb_submit_rx_urb, in which case do not submit the URB.

Signed-off-by: Vidya Dharmaraju <vidyad@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 433c6a16..76d80fd 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -298,6 +298,13 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	struct mwifiex_adapter *adapter = ctx->adapter;
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
+	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: card removed/suspended, EP %d rx_cmd URB submit skipped\n",
+			    __func__, ctx->ep);
+		return -1;
+	}
+
 	if (card->rx_cmd_ep != ctx->ep) {
 		ctx->skb = dev_alloc_skb(size);
 		if (!ctx->skb) {
-- 
1.9.1
