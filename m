Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D812C63699
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C712224D
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="n9vmMfhv";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CzjsxH89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKMVcQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 16:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgKMVbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB46C0617A6
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2020 13:23:13 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605302591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1lFN53uaJsJ9EXNYctCqaDakevX+QbjmQnkdsgnJ6/U=;
        b=n9vmMfhvfNgLFcQSSD7t680Ya/GvaoeBhJOu36LflXomLrWEPpvFhC9VkTdEdhh8beLnOj
        grwxwWiFHJ9n0fLTVOSgNEhyZCiQc56LXAp/2wNbRKnaNo3E7zGEnxTwaVKtQYcZyC31NR
        t7Ibcz5b3hzR+KturePtlQEcddwvoOi0QY93Cc+qq60A3ovLukBQcY7aY/1wGy8uXudPWk
        7/1kFPJQwwRluQMHGeALDLXfwTyOOIOq357tu9JyJJ/rCvNiW/qiW/GpoSgWxWTkqKGwp6
        s7DyGMbpv4a3ll9y7K3hBTFPJZOSJdH89FxASfUla5WvcScxgKBv6n7SmO0VWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605302591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1lFN53uaJsJ9EXNYctCqaDakevX+QbjmQnkdsgnJ6/U=;
        b=CzjsxH89aVTodVbhSiA/k7IBsggAQ/BVW/is9bEGWYIkxE3qU4+I0+WzpdHa8LVBUJJi5O
        +IIWlPBrf7xGECCQ==
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/10] orinoco: Move context allocation after processing the skb
Date:   Fri, 13 Nov 2020 22:22:43 +0100
Message-Id: <20201113212252.2243570-2-bigeasy@linutronix.de>
In-Reply-To: <20201113212252.2243570-1-bigeasy@linutronix.de>
References: <20201113212252.2243570-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ezusb_xmit() allocates a context which is leaked if
orinoco_process_xmit_skb() returns an error.

Move ezusb_alloc_ctx() after the invocation of
orinoco_process_xmit_skb() because the context is not needed so early.
ezusb_access_ltv() will cleanup the context in case of an error.

Fixes: bac6fafd4d6a0 ("orinoco: refactor xmit path")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../net/wireless/intersil/orinoco/orinoco_usb.c    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/=
net/wireless/intersil/orinoco/orinoco_usb.c
index 046f2453ad5d9..8419e13a79e2a 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1221,13 +1221,6 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, s=
truct net_device *dev)
 	if (skb->len < ETH_HLEN)
 		goto drop;
=20
-	ctx =3D ezusb_alloc_ctx(upriv, EZUSB_RID_TX, 0);
-	if (!ctx)
-		goto busy;
-
-	memset(ctx->buf, 0, BULK_BUF_SIZE);
-	buf =3D ctx->buf->data;
-
 	tx_control =3D 0;
=20
 	err =3D orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
@@ -1235,6 +1228,13 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, s=
truct net_device *dev)
 	if (err)
 		goto drop;
=20
+	ctx =3D ezusb_alloc_ctx(upriv, EZUSB_RID_TX, 0);
+	if (!ctx)
+		goto drop;
+
+	memset(ctx->buf, 0, BULK_BUF_SIZE);
+	buf =3D ctx->buf->data;
+
 	{
 		__le16 *tx_cntl =3D (__le16 *)buf;
 		*tx_cntl =3D cpu_to_le16(tx_control);
--=20
2.29.2

