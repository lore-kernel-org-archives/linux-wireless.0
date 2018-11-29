Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9092DC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 00:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6C320645
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 00:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RX+SY8Pt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D6C320645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeK2LQB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 06:16:01 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37246 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbeK2LQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 06:16:01 -0500
Received: by mail-oi1-f195.google.com with SMTP id y23so122690oia.4
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 16:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92mGcPmbUiv3ZCaheIHIcFIL3nsv//W+1j5sVWbxI3U=;
        b=RX+SY8PtNrdqrnK1gtulrKyIzwbKUDQp1WdoafJg6HCoHhexCI9sY5kYX8Lo37xchf
         K/BDPdbOri12PNx4jGUqD70h0HPonDqc2BCKdR8D7t4QPt3v1iLEFDLR0l5fyIYAY4Bf
         zB6GdNKv/tzT8m/LXt1rdV+HtO0BZasB23p+DZKW4BwWF2CBWUJ3nRh7TSmN3E2SqzsK
         cx0PCxqy93+q06eFZquhKqWawybDuzEPzMb97VrZhPk9Nd2ZCzKKyhT2yPZ/Umy+dp3p
         puyEst+dlXHtI8rBSceTNyAlHXTxyp/A6eBiEXx2W9owRtDSiC0r6SFq53Zz6lf5ZGfm
         yhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92mGcPmbUiv3ZCaheIHIcFIL3nsv//W+1j5sVWbxI3U=;
        b=F18To7+8564JbIWGTloKss+g8Yvva5/IflCcuLPzxuUhVtQ0JWy0p7KTE1/N7LfJmx
         RiW4CYQ2EDbx3iSEVitTC/AkhaUmk/wp6TsUoadGphutbV0BUPHX4+sz2L7jFF44JDFz
         xLJ90chp97R5n+jdXNHlMc7ur48GOeL/t2f38uHWFO+1LfwitZLlnrE1zUt4wQ7Toss7
         pXtz/KDrCByklwdGh5sQI/AH2uUSdlB3CnAtPXr/ywxM+G48P6McNJ6bYO/gmTU89Ovu
         Bx3zYBCAy2o+LIkxR8EKVFzEiTj1CP3A+/3XBXWLXFscp96WXiBqEZ8xRSw840teGKpx
         0Gzg==
X-Gm-Message-State: AGRZ1gLS8/RdSX1I8zENoO9ERswx5Sp53d1BWU7Cm3ALcCDoalifyFh1
        EItfrjO7IGxIx/+May+CJQ6CC45lKzUPitVey6I=
X-Google-Smtp-Source: AJdET5crFAFAp6S1ls3CbxzN9InHHRvYB1BWP5DxOsw83SpoR+SkZKu3y5grchCLPjvXXU3h+gk7KnfDDz10gno5n6o=
X-Received: by 2002:aca:4d47:: with SMTP id a68mr20631049oib.43.1543450355860;
 Wed, 28 Nov 2018 16:12:35 -0800 (PST)
MIME-Version: 1.0
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com> <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
 <5AB4C8D5.40203@broadcom.com> <1521810882.19239.1.camel@nxp.com>
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com>
 <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com> <CABACg+wyLwYQna+HDJyjNA8V1_3cSoMRDyiBpq=K+UXVXDrtBQ@mail.gmail.com>
 <CAHWfWzm8Zwjc2tBQWVqpaa-cMYyEPWmUKYN7rspyb9W9spx2iQ@mail.gmail.com>
 <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
 <CAOMZO5DtqVBkWuD0iR5JHEG4G-MoWYYxU8aSu99rW8mpd3+PYQ@mail.gmail.com>
 <CAF7Mx6p1DpRieCKy_1qOE5YT4_76UO8vhLMBFUD2B0FrQ9BJGw@mail.gmail.com>
 <CAOMZO5Ah9CLGud3seRcru8Roy3-ChSVDRhiM4ojvMh1XrcDUOg@mail.gmail.com>
 <CAOMZO5D3d3ocHLkoQXTA+aSW=84X8CFN+xWTdZNuHasDqF8Azg@mail.gmail.com> <d36ab72c-a30e-deec-7fef-2127afcccef0@broadcom.com>
In-Reply-To: <d36ab72c-a30e-deec-7fef-2127afcccef0@broadcom.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 28 Nov 2018 22:12:28 -0200
Message-ID: <CAOMZO5DujdsNzs4iTB15HJ=-rWv26t44Nnyw+5EGd8gufjKLYg@mail.gmail.com>
Subject: Re: AP6335 with mainline kernel
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     cameron@paloaltoinnovation.com,
        Vanessa Ayumi Maegima <van.ayumi@gmail.com>,
        Vanessa Maegima <vanessa.maegima@nxp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        embed3d@gmail.com, John Weber <john.weber@technexion.com>,
        Otavio Salvador <otavio@ossystems.com.br>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,

On Wed, Nov 28, 2018 at 6:13 PM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:

> Nice. Regarding your question in the earlier email, bit 27 in
> boardflags3 forces the device to always select external LPO signal. When
> the bit is not set it will select either internal or external. I don't
> know what the criteria for that selection are.

Thanks for your explanation and for the excellent hint on the lack of
32kHz support in the device tree.

Really appreciate it!

To close this thread, here is the dts patch that allows Wifi to work
om the imx7d-pico-pi board:
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-November/616048.html

Thanks,

Fabio Estevam
