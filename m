Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35636 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756207AbdLTTvf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 14:51:35 -0500
Received: by mail-pf0-f194.google.com with SMTP id j124so12995288pfc.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 11:51:35 -0800 (PST)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 1/4] NFC: st21nfca: Fix out of bounds kernel access when handling ATR_REQ
Date: Thu, 21 Dec 2017 01:21:21 +0530
Message-Id: <1513799484-12505-2-git-send-email-amit.pundir@linaro.org> (sfid-20171220_205252_079771_E58F3904)
In-Reply-To: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org>
References: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org>
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
