Return-Path: <SRS0=z9X+=PU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3ECC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jan 2019 21:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DAE2084C
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jan 2019 21:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlUi00hc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfALVf0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 12 Jan 2019 16:35:26 -0500
Received: from mail-ua1-f46.google.com ([209.85.222.46]:40602 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfALVf0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Jan 2019 16:35:26 -0500
Received: by mail-ua1-f46.google.com with SMTP id n7so5882640uao.7
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2019 13:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tdhERbH3og20xP0v9oZ0pywLlp4gYQ4rQv7i+MamdGU=;
        b=JlUi00hcuqRpYUP3u4vBU7WPr9kQVUpKHBHnC7sEbqb4A4yHz7sDnOUXT7jq+mapXH
         C/rdeC80LJ8lEddiDaAlsAR/YnSBViesqmldYmSWmg3hoSIy5cGf05dEIPlxPBcvjA++
         Q2TltIV2e/oaPf0RdMljpBWqCQ2K6tOV8k2kuj+GSx1pc0SBvf23twwI9DND1tWqyh9h
         bUxL4Rhqj4XlcsPvwIzKmK2RyrfFSrV2ODn9Oy5FlHzO/qoQLdjOlTb+OvXuyXPogGfj
         VcrqemzNM15sgj54E9/BGrB+ZCIJxHbNi3/GRfdoh9AEMzsEq1e90yfPM163SXeBChVK
         KSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tdhERbH3og20xP0v9oZ0pywLlp4gYQ4rQv7i+MamdGU=;
        b=AePblaHwWMEk1rJu6ngvsdXV/ae90X724XCKPVLBrz2mjDcJSmZGWrgkZkHLSxF2iE
         2ZF7TVKiSzxtM4OjSLru9FyvDdY3GJgiBsfmK/PYB0Ibh4BwioufW5TH3N1Lk/rLBdOf
         ReWXHQ2ukTxSjw3eTiyDjxefwQkPMhyJwaXdC2TPHNdkgd6oTN0aMGohLgUBCF8MgWKO
         84Gc0FgVRw8DSVeEMJ2hOXOIUgRkz2TWagpbxa3cxNB2+UVgj3US/4Pn1Jj2ZK/oC1ao
         WeDAEqb55prSH9iBHtAuIp+WPslUOo0e3cg94xaWcDmUvFqZWj2IoTRrrsIEGDPFd8Tp
         pxOA==
X-Gm-Message-State: AJcUukf6Gliw/C2utlfJFr1l6ANMyStcGL6zLBCMP14WkI3rGpYNpI02
        5upVCQ0+E1idjktLFubCslJXocXlr3hxb3B7Pw==
X-Google-Smtp-Source: ALg8bN51N78BFIHovCBrHtGibmMcplvXwvUrvPvSyufJ8ogpS+ETz7sVCng6M4xMbuI/ATq8NqXBwBJCXG9pomvWecw=
X-Received: by 2002:ab0:6190:: with SMTP id h16mr7467670uan.94.1547328924954;
 Sat, 12 Jan 2019 13:35:24 -0800 (PST)
MIME-Version: 1.0
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Sat, 12 Jan 2019 21:35:11 +0000
Message-ID: <CALjTZvZ6gAVH17fZwzM=PeO6CjtQCGoep=bqi6yYb6TJ6u5nfg@mail.gmail.com>
Subject: [PATCH] wireless-regdb: Add 5725-5875 MHz rule for Portugal (PT)
To:     seth.forshee@canonical.com
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

According to [1], SRD devices in this range are allowed in Portugal, as
specified in this document (page 56), and in compliance with ETSI EN 300 440-1.

[1] https://www.anacom.pt/streaming/25.5_10.000mhz.pdf?contentId=271706&field=ATTACHED_FILE

Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>

---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index fa5c0e0..66751f0 100644
--- a/db.txt
+++ b/db.txt
@@ -1044,6 +1044,8 @@ country PT: DFS-ETSI
  (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
  (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
  (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
+ # short range devices (ETSI EN 300 440-1)
+ (5725 - 5875 @ 80), (25 mW)
  # 60 GHz band channels 1-4, ref: Etsi En 302 567
  (57000 - 66000 @ 2160), (40)

-- 
2.20.1
