Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1EFC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 17:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B0720675
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 17:40:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r/p2xcF5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfAPRkr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 12:40:47 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43176 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbfAPRkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 12:40:46 -0500
Received: by mail-oi1-f195.google.com with SMTP id u18so3844350oie.10
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 09:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWCSaVNUX4icsY1rThsGj6gMmm7ggQ8n9uD2xiygt2g=;
        b=r/p2xcF5MeKwxRlT5gmuyLium8tz1MvgfHrPZ7zZjjAYfpk5uVhfZC+Nef61aa60du
         88y3qDPk2Yq70D4RtZz59C7tmDwFuNVK4U4ct7qfnRlYJcLGCHXo4Cug0aglLjuYSgA3
         H9z+tsd+G2MC489ta4AbC5Dp9Qys7Xj0ijY/HSQFsAGcOTr17qJpbiBPTiRaM9q8m89H
         iT+O7Fs7sKk96rmZfLh3CX7GAuk58DbidKjxyYP5xkCsd9Pgefd0SRRbQdT60Sz68qHh
         NTYYYc8lm2pOuIGyd6vd3cuOdPtTffWQpY1WAkRQi2Bcf7HhRhaUP6eVHStvCxrv6GOe
         UPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWCSaVNUX4icsY1rThsGj6gMmm7ggQ8n9uD2xiygt2g=;
        b=bbvJRG5TvJHJNi5h+VJEUTquUQE1zJ2+wx/hu3sEFjHYmlCta7ZmclYq+cte4dqaQq
         6tFSC5uMUoCNbf+HsiVgTUcLdc+1s67MLktF0wsUzVYyqnW8jpfhYHvcAMT4L/Msz1Lr
         MXqS5wykUozje/TK/1kG1vUlsNO/3PHxEWH08namuwpBFRuk31ujw4AaGIursdUEUSE8
         dgWFC7CfJ4wVNeray/m5o9pBKz1zEOxP6yjNvayMboiVwuxkGl/9xz7z2jJtlMH8+CBQ
         ox0vThgPbez5YocY+a8zYDhu4etnvIcqFnCLiVKDxBAoJyLLMmQqXaNqa8WWJpQpcais
         Lcfg==
X-Gm-Message-State: AJcUukeEqKVAuKQvZb8/oJK4iM4g22ui+oGPISDh2qZfRFG/hGzJikJb
        gR8joTtnaEl/cf1bKyhOsZrrV8fo6UHlImM7WIQ=
X-Google-Smtp-Source: ALg8bN4KkybBnh0XWPjtsS/GoQ1N7t/dmVnEoJ3+lL0318279+ej2g7GOZjgetXnpMieNq5I8IYnT8lvjjHuoIkBFIg=
X-Received: by 2002:aca:4ed8:: with SMTP id c207mr3778588oib.276.1547660445674;
 Wed, 16 Jan 2019 09:40:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com> <20190115154746.GA30564@localhost.localdomain>
In-Reply-To: <20190115154746.GA30564@localhost.localdomain>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Wed, 16 Jan 2019 09:40:34 -0800
Message-ID: <CAKxU2N_RZ56DFD2TvmyV_4q628fMuQmy9+0Bptw0zoG5U=4egw@mail.gmail.com>
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb controller
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 15, 2019 at 7:47 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Tue, Jan 15, 2019 at 01:33:41PM +0100, Lorenzo Bianconi wrote:
> > > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > > {tx,rx} datapath if the usb controller has sg data length constraints.
> > > Moreover add disable_usb_sg module parameter in order to explicitly
> > > disable scatter-gather. Some users have reported sg issues on AMD IOMMU
>
> Hi Stanislaw,
>
> >
> > Not sure what is the problem , but this patch set look like a workaround
> > not fix. If this an issue with IOMMU and sg, seems there is something wrong
> > in sg page mappings eigher on mt76 dirver or IOMMU driver.
>
> The main point here I guess is we do not need sg if fragment number is one (e.g
> usb2.0). Moreover this can fix IOMMU reported issues.
>
> @Rosen: could you please try this series enabling IOMMU?
I will try it later today.

Note that the same behavior occurs with USB 2.0 ports as well. I do
feel that the actual bug is in the IOMMU driver.
>
> >
> > If things need to be fixed in mt76 I whould check if page mappings for
> > sg are correct. Or remove sg usage from mt76_usb completly, mt76 MMIO
> > version do not use sg for framgments, so most likely USB don't need it
> > as well.
>
> usb scatter-gather is used to properly support non-linear skbs (A-MSDU,
> with usb3.0) since the hw (unlike pci counterpart) does not support it,
> so we need it.
>
> Regards,
> Lorenzo
>
> >
> > Thanks
> > Stanislaw
