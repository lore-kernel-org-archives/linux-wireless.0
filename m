Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F42C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 17:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 358CF2089D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 17:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEH8CvjV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 358CF2089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388088AbeKPDNC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 22:13:02 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36772 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbeKPDNC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 22:13:02 -0500
Received: by mail-vs1-f66.google.com with SMTP id v205so12097101vsc.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2018 09:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gn6fDhK5e57LVAYxuH+f1me32wxGVq6YtZf0nPBMXII=;
        b=FEH8CvjV0nf75H/m/wPXw0Thp0Qbia+a8mhmUI0dUrFvK55Kg0VSm5Xx0hWLkvP4xf
         dxno61XsM0Upfuwh+qqFhOJptIzEi3ZrPpSqG2jrdThgma8o1CpXNLAsfs4Ph2ZKUi4b
         0rCLVPY5nrcmuamy6++alu3rR2LO/ZvpdCxQavmWaRgdCahQCSP08EEVK6VBh42EW45q
         vccPvHDqOzLEqqLBVwTm0yKOs5l6ipCXZ94CwBmwasDAZKxD61SnForUyq+bibiyY8Kn
         x6KrZh1YAtUSRMjgbJAuQUXctCPgQzkAhdpikljo4IqbCVcQKiGg28FLMkcGDNkOm6+q
         w7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gn6fDhK5e57LVAYxuH+f1me32wxGVq6YtZf0nPBMXII=;
        b=EOPXKouhM4+3ITUSjg/0zXMQ6Ek+wOC3cABas7061Bbw0oIhR/x4Z28VJqzRoKrEGE
         MOPv8pRx3ep9JP31EunYAfvLIrKfE7LT5tmdYRNRXReibpsx8bDJxX1Uc1294T9iggXg
         8dLJOdLrdQO1avqO45QB4flZYMXokdXSDszwWhK5PE/aCGCB0gv1BvLQw+U/8Emqm4FB
         rd+UljwtIx48pv9kguIgWmOyfuhPlWnW4GjmMFt8ZhbVbTKvXNZTHiualdZXFpnUfaDq
         tGJ4hsuW2p9Q3yYot+fusHEYyxoAidtFQXufKUH1WVWUIwaWuCe0TpoDLpbPQzkejmJp
         1RRw==
X-Gm-Message-State: AGRZ1gIe1aeZxNMuUuSlKRR93cq/uFP+/JB+F2swJPGvO10FNtYVfz6V
        8ygugt7RDqD3Rafyw7Emy+l8HKhhL+iaMYSdD1Q=
X-Google-Smtp-Source: AJdET5chbZ1GnTQw2Kf6UeXoBL5jIap1cTNkGwBvzd0hgsO9i2hzwhpdS6oSyHWqHJs3xtDs05b8CGNu4L5HgMEl2Bg=
X-Received: by 2002:a67:4441:: with SMTP id r62mr3036461vsa.38.1542301463061;
 Thu, 15 Nov 2018 09:04:23 -0800 (PST)
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
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com> <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com>
In-Reply-To: <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com>
From:   Vanessa Ayumi Maegima <van.ayumi@gmail.com>
Date:   Thu, 15 Nov 2018 15:04:11 -0200
Message-ID: <CABACg+wyLwYQna+HDJyjNA8V1_3cSoMRDyiBpq=K+UXVXDrtBQ@mail.gmail.com>
Subject: Re: AP6335 with mainline kernel
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Vanessa Maegima <vanessa.maegima@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        linux-wireless@vger.kernel.org, embed3d@gmail.com,
        cameron@paloaltoinnovation.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Arend,
On Wed, Nov 14, 2018 at 9:41 AM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> + Cameron
>
> On 3/26/2018 3:34 PM, Vanessa Maegima wrote:
> > On Seg, 2018-03-26 at 09:24 -0300, Vanessa Maegima wrote:
> >> Hi Arend,
> >>
> >>>
> >>> Here's the hexdump: http://code.bulix.org/trv3o7-306254
> >>>
> >> The link above provides the hexdump from the html nvram, which makes
> >> wifi work on pico-imx7d.
> >>
> >> I also got the hexdump of the nvram file provided by TechNexion for
> >> comparison, which returns the error "brcmfmac: brcmf_sdio_htclk: HT
> >> Avail timeout (1000000): clkctl 0x50": http://code.bulix.org/mw4x62-3
> >> 09
> >> 095
> >
> > Fixing second URL: http://code.bulix.org/mw4x62-309095
>
> Hi Vanessa,
>
> It has been a while, but recently I was contacted by Cameron who was
> facing same/similar issue. After some email exchanges with him he
> uncovered that the problem with the TechNexion nvram file is with the
> boardflags3 entry. On my suggestion he change the value from 0x08101188
> to 0x101188. The dropped bit forces the clock hierarchy in the chip to
> select external LPO. I found some schematics showing a 32kHz signal
> hooked up to the LPO input coming from GPIO1_IO03. Could it be that it
> is not properly setup? Devicetree maybe?
>
> Regards,
> Arend
>

Thanks for the suggestion. I will investigate this on my side next
week when I have my Pico board and I will let you know any feedback.

Best Regards,
Vanessa
