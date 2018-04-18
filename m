Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35964 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752727AbeDRKFP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 06:05:15 -0400
Received: by mail-pf0-f194.google.com with SMTP id g14so668654pfh.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 03:05:15 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [RESEND][PATCH 1/4] NFC: st21nfca: Fix out of bounds kernel access when handling ATR_REQ
Date: Wed, 18 Apr 2018 15:35:01 +0530
Message-Id: <1524045904-7005-2-git-send-email-amit.pundir@linaro.org> (sfid-20180418_120644_206792_A54C60F1)
In-Reply-To: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

Out of bounds kernel accesses in st21nfca's NFC HCI layer
might happen when handling ATR_REQ events if user-specified
atr_req->length is bigger than the buffer size. In
that case memcpy() inside st21nfca_tm_send_atr_res() will
read extra bytes resulting in OOB read from the kernel heap.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 drivers/nfc/st21nfca/dep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index fd08be2917e6..3420c5104c94 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -217,7 +217,8 @@ static int st21nfca_tm_recv_atr_req(struct nfc_hci_dev *hdev,
 
 	atr_req = (struct st21nfca_atr_req *)skb->data;
 
-	if (atr_req->length < sizeof(struct st21nfca_atr_req)) {
+	if (atr_req->length < sizeof(struct st21nfca_atr_req) ||
+	    atr_req->length > skb->len) {
 		r = -EPROTO;
 		goto exit;
 	}
-- 
2.7.4
