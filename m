Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01352C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 19:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6B02077C
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 19:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I7lgrCGd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC6B02077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbeKRF2I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Nov 2018 00:28:08 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:34446 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725731AbeKRF2I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Nov 2018 00:28:08 -0500
Received: by mail-oi1-f177.google.com with SMTP id h25so3978483oig.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2018 11:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t88tCrJobttIinrMzYcCNb1m095VHunO5cHJS/kyDKM=;
        b=I7lgrCGdhMcWpI5MVMGbgoibncqmGb3QbSInCIYdDuXae/F+woHUpre93xVRUSSLWV
         fO9+ojYMhNVUjvx+JfRqqnV4fvNfSidCHp7at8fM4leaEOuf1htqTz8VjW72uGl8cn+i
         VqXAaaMwgsPL2Bq/Uahr19EyZ5IUoqnbZqQvzIfv0Wq7a5Vo6M8r8Ab/Gxi669udjtyw
         R8P808mgBB8iX9gFlmg4o2rTjsrG+ffMo5RokGPBCJSBA5TS3OJ51RJrLgqDX5eKq5pk
         DE5X46EtIto53mrostWGD6V+FLrkVZGKoQ+br0a+gWYpru+/x93e7SM02lmd71CtXnP5
         rFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t88tCrJobttIinrMzYcCNb1m095VHunO5cHJS/kyDKM=;
        b=SxP1+jZRFHxOwaQ1N4qo1VruXhZ84Aly4G29aHkn7MFbnck6RzglwXMKekHSBfs5v2
         FZi0kPq/AE7Z95QFpNicVheo6jXzldwFnPJmcwDyVBrRPhsXScCaadHvfaYzNDIrhFgm
         Cb+BYsm0JvDTtFsXPeMRHQwyi/zljqwSt3dSRGQNfpMA2YyNn0FxLDvHd0X1WMBDzJ/P
         BZoTTlHb+ZvonYiD0xo8NEvfMQpi5QZLytHk8zMtjTQeuuyiwCbu7udO02awHnZUOhJ3
         ZBRGZDAfXHonB1P+S4J1/YDwVb8A+oJORsstDlhOlkw0ZgqDfbpyNJGEvNS/hk3DT5MD
         xUYg==
X-Gm-Message-State: AGRZ1gLy7otkb0UN3CIhMKG2lwgbmBaeZH55Wym2yhEofcgYvVzHgPln
        ZQI5zoSXjKKR6XG1E7aLL4kvnFji/tcSaDnYTx0=
X-Google-Smtp-Source: AFSGD/UobQkXgSjWP/SggIIdJBO271Sxk+ETE5JbdEWs/wXxBAl2aacZaX8p5HT+19PLLlqoZOg9j1MqiYuSFc9QdoY=
X-Received: by 2002:aca:3011:: with SMTP id w17mr3856867oiw.342.1542481830793;
 Sat, 17 Nov 2018 11:10:30 -0800 (PST)
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
In-Reply-To: <CAHWfWzm8Zwjc2tBQWVqpaa-cMYyEPWmUKYN7rspyb9W9spx2iQ@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 17 Nov 2018 17:10:34 -0200
Message-ID: <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
Subject: Re: AP6335 with mainline kernel
To:     cameron@paloaltoinnovation.com
Cc:     Vanessa Ayumi Maegima <van.ayumi@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Vanessa Maegima <vanessa.maegima@nxp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        embed3d@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Cameron,

On Fri, Nov 16, 2018 at 5:59 PM Cameron Kellough
<cameron@paloaltoinnovation.com> wrote:
>
> I did a quick review of the Technexion dts file and it looks like they setup the iomux so that the clock Arend mentioned is needed actually gets muxed out to GPIO1_IO03.
>
> From the technexion imx7d-pico.dtsi under the iomuxc_lpsr group:
>
>     pinctrl_hog_2: hoggrp-2 {
>             fsl,pins = <
>                 MX7D_PAD_GPIO1_IO03__CCM_CLKO2     0x7d /* wifi LPO 32K Hz clock */
>                 MX7D_PAD_GPIO1_IO07__GPIO1_IO7     0x59 /* pmic sd_vel pin*/
>             >;
>         };

Could you please test the following patch against mainline that
implements this suggestion?
http://dark-code.bulix.org/4m18pb-507579

Thanks,

Fabio Estevam
