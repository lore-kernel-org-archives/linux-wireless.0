Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34487 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0DSHf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:35:58 -0400
Received: by mail-wy0-f174.google.com with SMTP id 39so2304576wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:35:58 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 5/5] orinoco_usb: avoid in_atomic
Date: Mon, 19 Apr 2010 08:35:22 +0100
Message-Id: <1271662522-29119-6-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
References: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We expect to be either in process contect or soft interrupt context. So
use in_softirq instead.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index eaec04e..1abc303 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -701,7 +701,7 @@ static void ezusb_req_ctx_wait(struct ezusb_priv *upriv,
 	case EZUSB_CTX_REQ_SUBMITTED:
 	case EZUSB_CTX_REQ_COMPLETE:
 	case EZUSB_CTX_RESP_RECEIVED:
-		if (in_atomic()) {
+		if (in_softirq()) {
 			/* If we get called from a timer, timeout timers don't
 			 * get the chance to run themselves. So we make sure
 			 * that we don't sleep for ever */
-- 
1.6.4.4

