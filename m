Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A1BC55ABD
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50AEB2224D
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="a5cb3x2t";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="o6jTpDii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgKMVb4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 16:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgKMVbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D94EC061A4C
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2020 13:23:15 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605302593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=csRVbl9e2h+sQUR2GrwXnKz/Z1OkSVsfi8ik8znFh+Y=;
        b=a5cb3x2tKSZsYxHewft6SymZOSxbMR++jUvhE8G5gBmtuxQ/phdBhuSwaY5nr4oi2nw3ri
        kJDNuG0e0+fcIQQtXgL0oZYF8kuHFwlNRPQB/Z2OXy6OO/pkd3QZMQ2/T+ud21o+ayP1Dd
        tRzIHh0qoVFnHyO2/vyZV037uyo9gbopOvzwYQwrOkIaTMtBhVAJGXce11Vxz4AofMjRQX
        81wFr6NX6V2G6e7j7jKnu1rSZP1ExYldFvXaMetdI1K3JHVSEkNE5BtJB5r6Le62XIfzE5
        8EX2NX1/kkHm2ImhRGA+HrIIgdx6jEt+fAAQRJDEQXJQVDV3+7ImGfKYG7Aa8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605302593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=csRVbl9e2h+sQUR2GrwXnKz/Z1OkSVsfi8ik8znFh+Y=;
        b=o6jTpDiiCFowjpywUBBEKi5EbgFVK4jgX1OwSiaxigM+xDmQOg/SEKX2TOlnT6Ga0fFtiJ
        DkwnNWzIaJ0ClGBg==
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/10] orinoco: Remove ezusb_doicmd_wait()
Date:   Fri, 13 Nov 2020 22:22:50 +0100
Message-Id: <20201113212252.2243570-9-bigeasy@linutronix.de>
In-Reply-To: <20201113212252.2243570-1-bigeasy@linutronix.de>
References: <20201113212252.2243570-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ezusb_doicmd_wait() is invoked via ->init_cmd_wait() callback.
This callback is only invoked hermesi_program_init() and
hermesi_program_end() which are the ->program_init() and ->program_end()
callbacks as assigned by `hermes_ops_local'. They are never used by the
USB interface since the USB interface provides its own set of callbacks
by `ezusb_ops'.

Replace ezusb_doicmd_wait() with a warning in case I missed the obvious.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../wireless/intersil/orinoco/orinoco_usb.c   | 21 ++-----------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/=
net/wireless/intersil/orinoco/orinoco_usb.c
index d12bd5be4cde6..c8508a3d652b0 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1052,25 +1052,8 @@ static int ezusb_read_ltv(struct hermes *hw, int bap=
, u16 rid,
 static int ezusb_doicmd_wait(struct hermes *hw, u16 cmd, u16 parm0, u16 pa=
rm1,
 			     u16 parm2, struct hermes_response *resp)
 {
-	struct ezusb_priv *upriv =3D hw->priv;
-	struct request_context *ctx;
-
-	__le16 data[4] =3D {
-		cpu_to_le16(cmd),
-		cpu_to_le16(parm0),
-		cpu_to_le16(parm1),
-		cpu_to_le16(parm2),
-	};
-	netdev_dbg(upriv->dev,
-		   "0x%04X, parm0 0x%04X, parm1 0x%04X, parm2 0x%04X\n", cmd,
-		   parm0, parm1, parm2);
-	ctx =3D ezusb_alloc_ctx(upriv, EZUSB_RID_DOCMD, EZUSB_RID_ACK);
-	if (!ctx)
-		return -ENOMEM;
-
-	return ezusb_access_ltv(upriv, ctx, sizeof(data), &data,
-				EZUSB_FRAME_CONTROL, NULL, 0, NULL,
-				ezusb_req_ctx_wait);
+	WARN_ON_ONCE(1);
+	return -EINVAL;
 }
=20
 static int __ezusb_docmd_wait(struct hermes *hw, u16 cmd, u16 parm0,
--=20
2.29.2

