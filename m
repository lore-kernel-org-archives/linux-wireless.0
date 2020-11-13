Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579FCC63699
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1735E2224D
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 21:32:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ehrIKy5N";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dBqDuqdq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgKMVcV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 16:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgKMVbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF664C061A49
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2020 13:23:14 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605302593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTlK+wxb7+GqgHMp0D3LzJZ+UN4nLjQ2iluivJmpkdY=;
        b=ehrIKy5N09vrp8O0TcD6N/wXBU1zpXiVlYLKDoZaOWURQg1X/XYgl5WFUb5Eo1NUqm3lun
        OdMsp95Bq5x8a/g3ggyAaMGFFnIvq/O6ustKkEHjdpQ38EY/P+PzqnU9vMLnxU/CXA826A
        7iLFohsm80ZfLP6X5H25mBujQh/ejitSCqbsLzApnpRIZs9+Da3qYhAodXo4mdHqzCQasF
        l8ePULuuKyKtaFARtlb1UCVyoOSyULfZY2b7CXQIa00AmLrwe1jh6dTvfCDfMyAd1FhV4w
        Yo1HLp8GpSGhFzCEBNT90P2JadvKAozaji2jRCwHJ8F5/4tCqAyRV/07e/UECQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605302593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTlK+wxb7+GqgHMp0D3LzJZ+UN4nLjQ2iluivJmpkdY=;
        b=dBqDuqdqBeMratg7FLrxvq1dsPfxMqaPEE8/QkPYN0+wM0lLa4+oPB68dUrD9VVCQPjpWc
        WBZiuqPWiYebw9Bg==
To:     linux-wireless@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/10] orinoco: Annotate ezusb_read_pda()
Date:   Fri, 13 Nov 2020 22:22:48 +0100
Message-Id: <20201113212252.2243570-7-bigeasy@linutronix.de>
In-Reply-To: <20201113212252.2243570-1-bigeasy@linutronix.de>
References: <20201113212252.2243570-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ezusb_read_pda() is invoked via ->read_pda() while firmware is loaded in
preemtible context.

Use ezusb_req_ctx_wait_compl() in ezusb_read_pda().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/=
net/wireless/intersil/orinoco/orinoco_usb.c
index 2c9c55569e8f4..7178889f9ec4c 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1157,7 +1157,7 @@ static int ezusb_read_pda(struct hermes *hw, __le16 *=
pda,
=20
 	return ezusb_access_ltv(upriv, ctx, sizeof(data), &data,
 				EZUSB_FRAME_CONTROL, &pda[2], pda_len - 4,
-				NULL, ezusb_req_ctx_wait);
+				NULL, ezusb_req_ctx_wait_compl);
 }
=20
 static int ezusb_program_init(struct hermes *hw, u32 entry_point)
--=20
2.29.2

