Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F46C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 16:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C1E2086B
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 16:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="odaV5HVU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17C1E2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbeK2D0G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:26:06 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:45066 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbeK2D0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 22:26:06 -0500
Received: by mail-oi1-f176.google.com with SMTP id b141so23026983oii.12
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 08:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0mKmQl7EZtUVJ9cZl01dqRiU/qBmxIrcOm3xLOxxfnQ=;
        b=odaV5HVUae75jGt73QZfUnoFx1wiU9Bs2PXnVevyw22P+qz7H6t7C079u3HelIdVz/
         +wnzaUNqW3LYqKOrwY5APjTyhTi2qXGATIOWIYr0Pd5JqgvrQhJ4Ngho7n96q264Jl/3
         c+chVCXaAJkU7Tj1fL5G6CfHy8FAtaxTWRxLutJTkTsrPHDZAzQ04POGwfY5D4OLB3Sz
         TogLCOi9ZjmSsIqApftVebOZnufEf1vx48SSz899nBPi/wqqn7SWvbpO2Z4dkd4/M1hX
         2KoBI/1UgvIh/yDQ/kiUGh65nxoat31ikvGWEs4RxrC8OvsgztKraWD04vuoJBSrVjuv
         sP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0mKmQl7EZtUVJ9cZl01dqRiU/qBmxIrcOm3xLOxxfnQ=;
        b=JcUu5xrHUpyUwswbyV7ix4zXq7wbvl1K2CxWnVnskYGrv5Orq0omkb8dJBj3d7OOc5
         Qvp2qgN+I1EKrBqBmW3gyRfxFSUDF2ITiN3CvAzdsFt9Ban/6cP/xd8br8RVi5mxeyNh
         BPj25QqOSB8NPRTUvOlAIEUQ0F7xwd599BEauoUsScCpUDR6aAuM5e9plitOtFzRIInj
         g9HNNjkDfZdf4EaMbMYj07BUYO+VSvg1H5Bju6N5XiHkj/ynlJrpqa0B1EzuAX0tEG/C
         VHPFrQukmQ7/V+HtAi6rcwTjgnN5Gh3tPG4PZ0KfvtGkc9SV6LuMX6cpvi7w63618YMC
         5j/w==
X-Gm-Message-State: AGRZ1gJxM+GBUkBiZ3AUCtROjItIj6YYO+jO0UmSgUJpC6zuYlZmfcSp
        WvsACeMFf9GrMWgcgMRoCpZbYM/kX911+V6TQ/m/2xzA
X-Google-Smtp-Source: AJdET5dEjhlrI51O6Ulqv9KpRGqMJDW1vaSd7DmQsQEjZ62CTyZmrc6zOzKeJ+I08alNVeLwg5xNyPVQi+NllPu3Fbc=
X-Received: by 2002:aca:cdd0:: with SMTP id d199mr22198852oig.266.1543422233494;
 Wed, 28 Nov 2018 08:23:53 -0800 (PST)
MIME-Version: 1.0
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com> <1510916848.26896.2.camel@nxp.com>
 <5A0EDC25.7030505@broadcom.com> <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com> <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com> <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com> <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
 <5AB4C8D5.40203@broadcom.com> <1521810882.19239.1.camel@nxp.com>
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com>
 <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com> <CABACg+wyLwYQna+HDJyjNA8V1_3cSoMRDyiBpq=K+UXVXDrtBQ@mail.gmail.com>
 <CAHWfWzm8Zwjc2tBQWVqpaa-cMYyEPWmUKYN7rspyb9W9spx2iQ@mail.gmail.com>
 <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
 <CAOMZO5DtqVBkWuD0iR5JHEG4G-MoWYYxU8aSu99rW8mpd3+PYQ@mail.gmail.com> <CAF7Mx6p1DpRieCKy_1qOE5YT4_76UO8vhLMBFUD2B0FrQ9BJGw@mail.gmail.com>
In-Reply-To: <CAF7Mx6p1DpRieCKy_1qOE5YT4_76UO8vhLMBFUD2B0FrQ9BJGw@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 28 Nov 2018 14:23:45 -0200
Message-ID: <CAOMZO5Ah9CLGud3seRcru8Roy3-ChSVDRhiM4ojvMh1XrcDUOg@mail.gmail.com>
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

On Wed, Nov 28, 2018 at 2:11 PM Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:

> Does it mean there is a regression in 4.20 for this board?

I haven't tested it with 4.20 yet.

>> Only change I needed was the one suggested by Arend in the nvram file:
>> changed boardflags3 entry.from 0x08101188 to 0x101188.
>
>
> Yes. That is understood. However, an external LPO clock may be more reliable than using the internal, which is consequence of changing boardflags3.

Just to make sure I understand the change:

boardflags3 0x08101188 --> Wifi uses an external clock
boardflags3 0x101188 ---> Wifi uses an internal clock

Current dts does not output the 32kHz from MX7D to the Wifi chip, so I
guess the below is correct.

> So can the signal be measured with a scope to confirm it provides 32kHz?

I am not sure if I can access this signal via scope.

Thanks
