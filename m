Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51830 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1DGTKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 15:10:09 -0400
Received: by fxm17 with SMTP id 17so1885673fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 12:10:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jason Conti <jason.conti@gmail.com>
Subject: [PATCH -stable] p54: Initialize extra_len in p54_tx_80211
Date: Thu, 7 Apr 2011 21:09:57 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <BANLkTimL90zWhpHPzODNAWXKtVVtWFfdmQ@mail.gmail.com>
In-Reply-To: <BANLkTimL90zWhpHPzODNAWXKtVVtWFfdmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104072109.57577.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Conti <jason.conti@gmail.com>

This patch fixes a very serious off-by-one bug in
the driver, which could leave the device in an
unresponsive state.

The problem was that the extra_len variable [used to
reserve extra scratch buffer space for the firmware]
was left uninitialized. Because p54_assign_address 
later needs the value to reserve additional space,
the resulting frame could be to big for the small
device's memory window and everything would
immediately come to a grinding halt.

Reference: https://bugs.launchpad.net/bugs/722185

Cc: <stable@kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com> 
Signed-off-by: Jason Conti <jason.conti@gmail.com>
---
Janson Conti,

I hope you don't mind the "pretty-printing", right?
But, this is not a problem of gcc or debug options
and therefore I had to rewrite a few parts to make
it clear why this is a "-stable" patch.

Thanks for the patch, your work is highly appreciated!

Best Regards,
	Christian
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 3a93162..4d28b52 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -703,7 +703,7 @@ void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct p54_tx_info *p54info;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	unsigned int padding, len, extra_len;
+	unsigned int padding, len, extra_len = 0;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue = 0, crypt_offset = 0;
