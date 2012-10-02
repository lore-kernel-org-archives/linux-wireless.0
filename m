Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:32540 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2JBIdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 04:33:04 -0400
Date: Tue, 2 Oct 2012 11:32:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] orinoco_usb: clean up some signedness issues
Message-ID: <20121002083234.GL12398@elgon.mountain> (sfid-20121002_103316_061642_628238E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ezusb_read_ltv() we had a comparison "(bufsize < 0)" which was never
true because bufsize was unsigned.  I looked at the implications of
that.  If we passed a negative number to ezusb_access_ltv() then it
would be used as the size parameter of the memcpy() because that
function uses min_t(int, exp_len, ans_size).

But fortunately when I looked at the callers, bufsize is not controlled
by the user and it's never negative.  So these signedness mistakes have
no impact.

I removed the always false check from ezusb_read_ltv() and I changed the
types in ezusb_access_ltv() and made the variables unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 7f53cea2..01624dc 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -865,7 +865,7 @@ static int ezusb_firmware_download(struct ezusb_priv *upriv,
 static int ezusb_access_ltv(struct ezusb_priv *upriv,
 			    struct request_context *ctx,
 			    u16 length, const void *data, u16 frame_type,
-			    void *ans_buff, int ans_size, u16 *ans_length)
+			    void *ans_buff, unsigned ans_size, u16 *ans_length)
 {
 	int req_size;
 	int retval = 0;
@@ -933,7 +933,7 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 	}
 	if (ctx->in_rid) {
 		struct ezusb_packet *ans = ctx->buf;
-		int exp_len;
+		unsigned exp_len;
 
 		if (ans->hermes_len != 0)
 			exp_len = le16_to_cpu(ans->hermes_len) * 2 + 12;
@@ -949,8 +949,7 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 		}
 
 		if (ans_buff)
-			memcpy(ans_buff, ans->data,
-			       min_t(int, exp_len, ans_size));
+			memcpy(ans_buff, ans->data, min(exp_len, ans_size));
 		if (ans_length)
 			*ans_length = le16_to_cpu(ans->hermes_len);
 	}
@@ -995,7 +994,7 @@ static int ezusb_read_ltv(struct hermes *hw, int bap, u16 rid,
 	struct ezusb_priv *upriv = hw->priv;
 	struct request_context *ctx;
 
-	if ((bufsize < 0) || (bufsize % 2))
+	if (bufsize % 2)
 		return -EINVAL;
 
 	ctx = ezusb_alloc_ctx(upriv, rid, rid);
