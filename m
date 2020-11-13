Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E677C55ABD
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B27412224D
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="R88burXm";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ltK3DnD0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKMVcP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 16:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgKMVbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3DDC061A4A
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2020 13:23:15 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605302593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RbJeR7xKCajSFXSDs/Xww4s/6y+tzibSrLUTKbsR+8=;
        b=R88burXmu8ngTXsVVzc/FyG14S0dLuajBhOaeQprRQs8xZDlH0BltnNzV+gDuOu2Cxpa16
        rFxfBVrEz1w90EadZuChguhQs+qVwcYeO3k83/dzSLgvYqlZiLbCo/VjHWp4o616WpNT48
        iOBSwNbP/ia8YF2KDQt88qjOv4K/QbaWE17prCsoDqgds/gQSrCcD1/cmFPKJVQY/QB96X
        +BcrT533ywOM0g/0Fq0J7Sj7yY/tVvEQbLuXo9+2SZGDw5q0kPBuqOdyy4ZR1B/BhPMCUy
        n8e9zM3uy0CPNvKZ38HGOu5yFJmY1866zf6ximI51rmBKOelguePzKJKiXMOfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605302593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RbJeR7xKCajSFXSDs/Xww4s/6y+tzibSrLUTKbsR+8=;
        b=ltK3DnD0d59U9wxxqG4sF8bLP9wKaEHvFzPlonEbeMoCURH/9AN1BdmlIoQeyvc6Wz4Uya
        Mf/sOBIJdSYJloDA==
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 09/10] orinoco: Annotate ezusb_docmd_wait()
Date:   Fri, 13 Nov 2020 22:22:51 +0100
Message-Id: <20201113212252.2243570-10-bigeasy@linutronix.de>
In-Reply-To: <20201113212252.2243570-1-bigeasy@linutronix.de>
References: <20201113212252.2243570-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

All invocations of ezusb_docmd_wait() happen via ->cmd_wait(). This
callback is always invoked under the orinoco_lock() which disables BH.

Use ezusb_req_ctx_wait_poll() for ezusb_docmd_wait() because it must not
sleep.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/=
net/wireless/intersil/orinoco/orinoco_usb.c
index c8508a3d652b0..4c60b48214637 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1082,7 +1082,7 @@ static int __ezusb_docmd_wait(struct hermes *hw, u16 =
cmd, u16 parm0,
 static int ezusb_docmd_wait(struct hermes *hw, u16 cmd, u16 parm0,
 			    struct hermes_response *resp)
 {
-	return __ezusb_docmd_wait(hw, cmd, parm0, resp, ezusb_req_ctx_wait);
+	return __ezusb_docmd_wait(hw, cmd, parm0, resp, ezusb_req_ctx_wait_poll);
 }
=20
 static int ezusb_bap_pread(struct hermes *hw, int bap,
--=20
2.29.2

