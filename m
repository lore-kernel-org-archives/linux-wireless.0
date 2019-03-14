Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146DBC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 10:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D154920854
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 10:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o/DKZ0LI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfCNKF4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:05:56 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33704 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfCNKF4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 06:05:56 -0400
Received: by mail-qk1-f193.google.com with SMTP id x9so2940254qkf.0;
        Thu, 14 Mar 2019 03:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CRIfD3srqh/rjIqD1t+p4mGtPnPHODDhlRPojg/Oew8=;
        b=o/DKZ0LIEcRDS1WwWwp3+f14BY05lY1qHslwnTE4ZNaevh6n8p7wMEgqbpfnGiygnq
         Kak6gjIv0HXwmeEv1UB+3LlbN131DLrmWEVU81EBfVFynnfzl4mKBX7k0+Mq6gnZjZ5d
         CpQhGnn0FrpuzxJWI5OV87bHZYpL4K4hw63PZ+G8VVf8DzhGpj7fRIcVPc+wFALO2LSl
         HABSZowq93Q23Q6Xtf3B5bTR1G8KuC4Xl+jPVRskPdiJ4PQ1J+2sEt6W6P17AulCbqAD
         5dLttTm7FeNfvY5LMheTpwpovS5S1J7oyYojoUP8hpHD9Oq1jh6UiCrCSJ7f8CRJZHw3
         du/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CRIfD3srqh/rjIqD1t+p4mGtPnPHODDhlRPojg/Oew8=;
        b=fLUHjW4rl50WBuTydgnde6EcbTrYwRnt2AF55/z1RmF5lTf2B3DTCirWacDwN7sRa2
         8D/qs/dsYT5VzSTX5uUqkPlrcQZX7TEr4LfmIKGGzllPPr+LgdyMoJt67xj2iNbenkXo
         lEAs/GFMBdmr0nvhw2hVZC7HCxrPvrmN93Sy0hAXT6UyaH3qwcq5220+Ta9u0OhO7+Bc
         98hTwicx9qjkpEkgui7fDt1p4GN9Bvc+4t98L47VRWrkceVnVwoBTqvT3KyN/nVjcV/C
         YCQ0zXYX6ngPVlFIQMVPBWiJ3G2SaXA53/IzyCHCtHX0TTr0+iD44Fe+qEK11Sp3Pd9O
         h+aQ==
X-Gm-Message-State: APjAAAWhHYpqYWE5Wt84+QgYDUk3qU+ZUFXl194VeXssY3pGMm52ViCW
        xpJI1S6QygNVvtVVPovmHDPrsyg/5UrCVTXyNT5HiQ==
X-Google-Smtp-Source: APXvYqyiU6UlnUqIAhrW50kT3qtp2qg052XzBDyqlicVjHy9RvPKM9PvqBpeFHt8qWfV9xBWY3PeAitW10iFFWQyOMg=
X-Received: by 2002:a37:464f:: with SMTP id t76mr19001408qka.353.1552557955620;
 Thu, 14 Mar 2019 03:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAOX2RU5igDk_nkj74i-1_hoC4JbSSK3w1_-DyH+3EzyeMHnMcw@mail.gmail.com>
 <0aabbc6e74fefa8bd5a094dc84b1f87c@codeaurora.org>
In-Reply-To: <0aabbc6e74fefa8bd5a094dc84b1f87c@codeaurora.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Thu, 14 Mar 2019 11:05:44 +0100
Message-ID: <CAOX2RU6wFpaP7Zm1MmvJTkxXL12Cz9VcWFvYTJzn=1=9g3wj9Q@mail.gmail.com>
Subject: Re: wil6210 firmware version
To:     merez@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Biggest thing would be Channel 4 support as it is supported by driver
but requires FW support also.
But I would also like 20 station limit instead of 8.

Cheers
Robert Marko

On Thu, 14 Mar 2019 at 11:03, <merez@codeaurora.org> wrote:
>
> On 2019-03-14 11:07, Robert Marko wrote:
> > Hi,
> > I am working on OpenWrt support for device using wil6210 card.
> > I am using firmware and board file provided in linux-firmware for its
> > development but it appears tha most of newer features that driver
> > enables are firmware dependant and version 5.2 in linux-firmware is
> > too old to expose those.
> >
> > Is there any chance of QCA pushing updated version to linux-firmware?
> >
> > Thanks
> > Robert Marko
>
> Is there any specific feature you are interested in?
>
> --
> Maya Erez
> Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project
