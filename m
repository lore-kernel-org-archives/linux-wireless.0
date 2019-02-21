Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4301EC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 05:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 041072086C
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 05:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BI3kvEW2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfBUFGO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:06:14 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35654 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfBUFGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 00:06:13 -0500
Received: by mail-yb1-f193.google.com with SMTP id n84so6711971yba.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 21:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XpPY2iqZnYH295Z7oF9vJ6cXJT9FWifD/NJcNvGBaBc=;
        b=BI3kvEW2tpKOgr9GUlpskNDkRbCZYSFt+9EwiK8GC/eiqKZxWxlcj9CAct9nop0BEr
         ulA6VgNyISouxm9vRzYqcgHveCEJyHIyrRsnqhTy1sii/1pFgXwxlvktRSo3PfbKXoZu
         jxkm7sxzd/OaCR1gsbO604pcopK//ypqGvafYU4tdqBOsH7uuKLV7GDp1LxFb1gTZuM1
         CJVE/GREqBN6wM5w66N76UDCQ7grEn468CAYobKmkq6ixnlHpqa+bx9nUfkzvCAFNSes
         HQDjqd2g9x/TmaQxPPbJI0d4eih5UOfer0L+fE6t6BoqGC1+3dMvkOihIQ7P0I//pWlc
         KJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XpPY2iqZnYH295Z7oF9vJ6cXJT9FWifD/NJcNvGBaBc=;
        b=cn4bWurOWWQ0qW0+4fanrz9VDQs3Lde8no8qlyBgtbTcjKCFFAwCmGJUbsQ1GS/f2a
         SIht7p7dEX7NgL1hQeE6iwTPlBYoauKgqvQZDpkKC1zBT7cZMX1jOkAwXOzlgkSSJLtq
         mVLOxdHuQOva7Ih4R+V+Xz0BK+X8sdQnZvzjcWhV5oTyFCtF88rDlw8PsE1ZHOSdEdag
         ZzS+MYd2+gc3gDGM4Fng2Fuudr55C9X5HzFskJuaDV+F74F1qn+y2i22P6ghqKip1UH8
         sOm/5KcyKWbfi3wHkICbrKZGvd8A3ob8WLhBsQnhKxUnmPqsB4piMrsDg4y9b/b72eo2
         MYJw==
X-Gm-Message-State: AHQUAub7XvV6XBhakNpsXclKA1mcLR52sLMDsVahpXQRrZ7jjI4kus59
        Gf2XvYJ5to9JtEQdWH31V5XkWyZxISgDhxMmUrfGonGsAw==
X-Google-Smtp-Source: AHgI3IbY5zadu6xlNOmHeT+xNLLfOpNquOHaTqVcbBxouXuV92qil104hn7/Q9drjDKnSoLHcv/SUnvIQCYQr+hM99A=
X-Received: by 2002:a25:c1c6:: with SMTP id r189mr31657059ybf.109.1550725572702;
 Wed, 20 Feb 2019 21:06:12 -0800 (PST)
MIME-Version: 1.0
From:   Turritopsis Dohrnii Teo En Ming <tdteoenming@gmail.com>
Date:   Thu, 21 Feb 2019 13:05:43 +0800
Message-ID: <CANnei0E3kjvSEz2_7AxNhMVBfqEy76=3o05j9ogLvvj-04MCww@mail.gmail.com>
Subject: Does Linux Kernel 5.0-rc7 Support High Efficiency Wireless IEEE
 802.11ax and IEEE 802.11ay (Wi-Fi Alliance Wi-Fi 6)?
To:     linux-wireless@vger.kernel.org
Cc:     Turritopsis Dohrnii Teo En Ming <tdteoenming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Good afternoon from Singapore,

Does Linux Kernel 5.0-rc7 Support High Efficiency Wireless IEEE
802.11ax and IEEE 802.11ay (Wi-Fi Alliance Wi-Fi 6)?

Thank you.

===BEGIN EMAIL SIGNATURE===

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link: https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwave.html

********************************************************************************************

Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic
Qualifications as at 14 Feb 2019

[1] https://tdtemcerts.wordpress.com/

[2] https://tdtemcerts.blogspot.sg/

[3] https://www.scribd.com/user/270125049/Teo-En-Ming

===END EMAIL SIGNATURE===
