Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56350 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbeHULOU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 07:14:20 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Vidya Dharmaraju <vidyad@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/2] mwifex: free rx_cmd skb in suspended state
Date: Tue, 21 Aug 2018 13:23:02 +0530
Message-ID: <1534837982-31206-2-git-send-email-gbhat@marvell.com> (sfid-20180821_095518_259161_D7EA088C)
In-Reply-To: <1534837982-31206-1-git-send-email-gbhat@marvell.com>
References: <1534837982-31206-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB suspend handler will kill the presubmitted rx_cmd URB. This
triggers a call to the corresponding URB complete handler, which
will free the rx_cmd skb, associated with rx_cmd URB. Due to a
possible race betwen suspend handler and main thread, depicted in
'commit bfcacac6c84b ("mwifiex: do no submit URB in suspended
state")', it is possible that the rx_cmd skb will fail to get
freed. This causes a memory leak, since the resume handler will
always allocate a new rx_cmd skb.

To fix this, free the rx_cmd skb in mwifiex_usb_submit_rx_urb, if
the device is in suspended state.

Signed-off-by: Vidya Dharmaraju <vidyad@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 76d80fd..d445acc 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -299,6 +299,12 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
 	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+		if (card->rx_cmd_ep == ctx->ep) {
+			mwifiex_dbg(adapter, INFO, "%s: free rx_cmd skb\n",
+				    __func__);
+			dev_kfree_skb_any(ctx->skb);
+			ctx->skb = NULL;
+		}
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: card removed/suspended, EP %d rx_cmd URB submit skipped\n",
 			    __func__, ctx->ep);
-- 
1.9.1
