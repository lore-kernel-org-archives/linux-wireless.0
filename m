Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB4CC5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 15:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9660F2098A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 15:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2cWZc7aF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9660F2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbeJRXM1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 19:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbeJRXM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 19:12:27 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E958821477
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539875460;
        bh=DqK2UxlfhBWloLr1KxdVwjH2lofCmNysORUBokSZznM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2cWZc7aFFH8SD/Vam6BTx3P1UNWLZ+6+GEYcAfva4O29KT2TMJiQmnvrx8PO0yRSF
         rklJkHLmZ5zai8F23y09u+airni6j0wv6jDvf2mPXLpnJoMVJsRCB238KRgdm5BqXh
         3sn8o/GT8Yd7GePi1f5BkXF4GkX6ZlYlfpfpMAwo=
Received: by mail-qk1-f181.google.com with SMTP id p6-v6so19012821qkg.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 08:10:59 -0700 (PDT)
X-Gm-Message-State: ABuFfogGM/5KPUwseWamSbUaedA/IWcLQGH+52vacy/SV7TREq1Q9e46
        7pMFh5bbRlfD+ISapPuANKe8YIg9rwHHovJ8izU=
X-Google-Smtp-Source: ACcGV63AWbUzZDd1pXPjjKH3Au99imIf1bmJk3KcyHXAvhTRg+DyEcbeCGDIDpwCVhMUU9CI56DRl3qb/I4BDOScC6M=
X-Received: by 2002:a37:6882:: with SMTP id d124-v6mr28086090qkc.96.1539875459156;
 Thu, 18 Oct 2018 08:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539421123.git.lorenzo.bianconi@redhat.com> <54125c5d41740706aa530a77cf7df48fec129c3b.1539421123.git.lorenzo.bianconi@redhat.com>
In-Reply-To: <54125c5d41740706aa530a77cf7df48fec129c3b.1539421123.git.lorenzo.bianconi@redhat.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Thu, 18 Oct 2018 11:10:47 -0400
X-Gmail-Original-Message-ID: <CA+5PVA7jMmf9HBjpZ9mioGCiku-T2Q-=0eLYcUxN90MWJb-ufg@mail.gmail.com>
Message-ID: <CA+5PVA7jMmf9HBjpZ9mioGCiku-T2Q-=0eLYcUxN90MWJb-ufg@mail.gmail.com>
Subject: Re: [PATCH] linux-firmware: add firmware for mt7610e
To:     lorenzo.bianconi@redhat.com
Cc:     Linux Firmware <linux-firmware@kernel.org>, sean.wang@mediatek.com,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 13, 2018 at 5:06 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> Add binary firmware for mt7610e based devices
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  WHENCE               |   3 ++-
>  mediatek/mt7610e.bin | Bin 0 -> 80680 bytes
>  2 files changed, 2 insertions(+), 1 deletion(-)
>  create mode 100644 mediatek/mt7610e.bin

Applied and pushed out.

josh
