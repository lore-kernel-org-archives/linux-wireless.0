Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF767C55ABD
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 569C32224F
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HcZVkmgT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="K4Ei/2VP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgKMVbz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 16:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgKMVbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC55C061A04
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2020 13:23:13 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605302592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPMvTSiKcX8sym58YGrVjaQxnDkrsZmdyt0RYQJzN18=;
        b=HcZVkmgTBNVJrtFz5mau+I4j+BiVlmkGcexS3kDXZ+/YyNZHXOEfH+32rT47HNQUX8vo1B
        WepQXD9MrMo+/xqqQKKl4Pwnn0rwUW4Dh/XsKOicBLfe0HqgKz07BlZ4ut85To0pUceDgA
        kmr4VzKwC2AN+osf1+3YevJIjIYALl7hkohmfKPRZdzsZ6tUSSyNyDUtdM8SiqNUUDVp69
        Kct9yy0rjK4ewRdTJL9/F3tSx9nh5Yc/YqVWtCy8mg+BVQU9Mp0cDTS2Ve3HFpS7NODQzE
        nBdZyer3gSYMfJM6jiZaGSPZIGuLp6/GobLCyda8JS2fyi1E8ELa0WHJ+pCR8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605302592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPMvTSiKcX8sym58YGrVjaQxnDkrsZmdyt0RYQJzN18=;
        b=K4Ei/2VPHqqcwygpr7CJYF/KwKYbUqj3G/9dKFpXlAzyACpSGU8IsZMTKWcp5BqIDa3YBi
        MiIB58ySrBhQFtAA==
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 03/10] orinoco: Annotate ezusb_xmit()
Date:   Fri, 13 Nov 2020 22:22:45 +0100
Message-Id: <20201113212252.2243570-4-bigeasy@linutronix.de>
In-Reply-To: <20201113212252.2243570-1-bigeasy@linutronix.de>
References: <20201113212252.2243570-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ezusb_xmit() sets ->in_rid in its request which means it does not wait
for an answer.

Use the ezusb_req_ctx_wait_skip() to denote that an answer is not
expected.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/=
net/wireless/intersil/orinoco/orinoco_usb.c
index 6642948809e1c..66d77af91d22c 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1319,7 +1319,7 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, st=
ruct net_device *dev)
=20
 	err =3D ezusb_access_ltv(upriv, ctx, tx_size, NULL,
 			       EZUSB_FRAME_DATA, NULL, 0, NULL,
-			       ezusb_req_ctx_wait);
+			       ezusb_req_ctx_wait_skip);
=20
 	if (err) {
 		netif_start_queue(dev);
--=20
2.29.2

