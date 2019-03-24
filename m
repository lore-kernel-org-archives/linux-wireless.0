Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59883C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 12:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217AD222D0
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 12:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YCrYe395"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfCXMc3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 08:32:29 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34633 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfCXMc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 08:32:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id n68so3810095qka.1;
        Sun, 24 Mar 2019 05:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1oeOlYViFEt64dYVsfhCV9Mtb717mMqSiOiE0dp7Oo=;
        b=YCrYe395JGDGZX+g/hZaiv2W8ffslDViGj1d8PvJsKKtWJl+REW1Qg7aSH82f03+9B
         elKNtLgjDYkDB708aCXlTIF4xXEgmN0Uu9SAZgU3rq0pwY61Dwl1ddNlpT/5c2NcCWn6
         uDZFONQhd0qj5m3zAHnZVc7fBDgSWbIFhOVtSz3Y5sUZD3WJX0OvX35KrN5/FSFQl8tY
         YcDqs3Q5EmGBx9KWkBsQVNg1bRPiYz76X4vzQoo5S2t3bjBm2kahe0/5TDGlsv6F9FDa
         0CqE2B/XSoaNVxF7MPaMoiWVhySZ3UeWOshWIQUVgfBCp8B3HhZrJVb+uSamqJ/RgVJ0
         /U6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1oeOlYViFEt64dYVsfhCV9Mtb717mMqSiOiE0dp7Oo=;
        b=nW/i/hBm3JCyQ9PbqZy0I80VWrirOp7gjIm2ztZOdyvS4zSvOQuku/jK6pVq737np9
         t8jtdC4X6Bp1IS+t53m2cmBa/L9Q3koBqCCql7ZQvCWUkhSPPgCZx9yImaqP+Fnx4QVw
         ILydmVPgRwGkQDLSlj8xVxgd8zwtWONGDFIqDElGfEx7FqiRgLjIa95dM3AcRovsXXel
         pX8zr8kMGRVqwz7h4UdekU2zhnwTKlRSwX0WRYGHHJ/z+vnsHVuhZvn/kmLHqG8FANKl
         ZFJgLqzInWWnKzZCBRWk6S9mR0tuKdaY6p521klUF+cmVxuv9+1yL7+vOrTtPZBRww/W
         jmFg==
X-Gm-Message-State: APjAAAXfwUNBGAcZ72pjQTzIbTjxr51bd4VRN98xHPg+4I7N2tnHEQKg
        6I25d7zs4SGJs24o+tqz6MMIy/IGVHsljw7uNm4=
X-Google-Smtp-Source: APXvYqyMPHAN4KuBOygLw18xpQwuBElDXKHa0pmTrd2f49+OdnRgAFOYu0W5gdNsgum5pWVi2CL/5kID4hil3SbgR2A=
X-Received: by 2002:ae9:de87:: with SMTP id s129mr15279572qkf.178.1553430747535;
 Sun, 24 Mar 2019 05:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAOX2RU5igDk_nkj74i-1_hoC4JbSSK3w1_-DyH+3EzyeMHnMcw@mail.gmail.com>
 <0aabbc6e74fefa8bd5a094dc84b1f87c@codeaurora.org> <CAOX2RU6wFpaP7Zm1MmvJTkxXL12Cz9VcWFvYTJzn=1=9g3wj9Q@mail.gmail.com>
 <64d97528f4fb088830a5dbcd8b74e934@codeaurora.org>
In-Reply-To: <64d97528f4fb088830a5dbcd8b74e934@codeaurora.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Sun, 24 Mar 2019 13:32:15 +0100
Message-ID: <CAOX2RU42VCwyizo5Y-23___i-1jLngegRadfjPwp0JaPLz73QQ@mail.gmail.com>
Subject: Re: wil6210 firmware version
To:     merez@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Well, that was not noted anywhere.
I am sure that there are also other interesting things in newer
firmware, especially since the device that I am working on is using
6.2 FW itself in stock firmware.

On Sun, 24 Mar 2019 at 13:30, <merez@codeaurora.org> wrote:
>
> On 2019-03-14 12:05, Robert Marko wrote:
> > Biggest thing would be Channel 4 support as it is supported by driver
> > but requires FW support also.
> > But I would also like 20 station limit instead of 8.
> >
> > Cheers
> > Robert Marko
>
> Those features are supported only on Talyn device (latest wil6210 HW),
> which is not available in market yet.
>
> Thanks,
> Maya
>
> >
> > On Thu, 14 Mar 2019 at 11:03, <merez@codeaurora.org> wrote:
> >>
> >> On 2019-03-14 11:07, Robert Marko wrote:
> >> > Hi,
> >> > I am working on OpenWrt support for device using wil6210 card.
> >> > I am using firmware and board file provided in linux-firmware for its
> >> > development but it appears tha most of newer features that driver
> >> > enables are firmware dependant and version 5.2 in linux-firmware is
> >> > too old to expose those.
> >> >
> >> > Is there any chance of QCA pushing updated version to linux-firmware?
> >> >
> >> > Thanks
> >> > Robert Marko
> >>
> >> Is there any specific feature you are interested in?
> >>
> >> --
> >> Maya Erez
> >> Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
> >> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> >> a
> >> Linux Foundation Collaborative Project
>
> --
> Maya Erez
> Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project
