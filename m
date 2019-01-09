Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8C2C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 06:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B49120821
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 06:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="YZk3dadt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbfAIGSM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 01:18:12 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:54030 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbfAIGSM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 01:18:12 -0500
Received: by mail-it1-f193.google.com with SMTP id g85so10060034ita.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 22:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfRUJW/sQQZeWxCGtkwLlqsxFW6XFwgkiKWAWu80dlU=;
        b=YZk3dadth+FWbtmz02HC5GIdPBvmUTzFGMKCbRbp9tyLTCJCq7QixqMtPv4bM7VEVa
         JDCTWQIZ2HIsAiFKFkYwfiIAygca0W3dCwaLZAfJGbmVtTBUzOmOC3U+XqkbGYDLn7+n
         sVnrTAo0AV7QTE72uHXycA2ns5boNfrJ2SxNSVve4yWd1StppvWN95o0UTxV1bEb8JEp
         IbEZNtCkt7zMQivZZDhpMjItmlDtZnFjz2AqRqg5aJIAnjmEVflbl3F34LM7WeGrTJuB
         PhXxpXId3fZjfvTR5ojL45o2lhixdfuQlEPF/jkphWJNeaVPeij/9URoMWRIlyMTNh71
         vkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfRUJW/sQQZeWxCGtkwLlqsxFW6XFwgkiKWAWu80dlU=;
        b=DwxdTf7SqaOUqJHfQVqwtoZmb8hpaAfQHv+flwhxrmopGQkNLnnCy/+WSOQ65OlCgA
         8B/HVyEbP0+B+ykhJpbUS5NMkHbNcavbIyMOCNo4i7nS/jxXYbJBs88BnWSOhut9859D
         B78RX466ZY8Yhkh8vIlCO1BZ6TvdBXbA5Lwd7gXqQIcyevaZEfxxsGSYxeJZKNH756va
         4FyWTNPL5dq26VjoAxskgCVInlOOwsjWrgrySq23i0P70mzKM+8E0+4T0gh+VDt6nDcY
         7a2IleGFRKFiwKliepIyI5KFbN9fsob73b25KUh/aWRhIw8LjWonnfG9D9ojRVMsIONq
         B1NQ==
X-Gm-Message-State: AJcUukf2UPcJvf8/m38zcc8jgNo7eIEPfS8Ut9OUEE5U+lei/t/AT1dy
        hs7tHkUlkIf3geKJ4xGlRDtJR9F+5GTap5UMD4AHgA==
X-Google-Smtp-Source: ALg8bN4xfp3MKVhv8v8KYpVPTKuouC+u0e90NwLT8By/LIwANCaEXuJwZtOx6VQnJcqnsV/5yNp2p9BIKFYNK7lrUio=
X-Received: by 2002:a24:7094:: with SMTP id f142mr3254494itc.90.1547014690851;
 Tue, 08 Jan 2019 22:18:10 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com> <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
In-Reply-To: <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Wed, 9 Jan 2019 07:17:59 +0100
Message-ID: <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

     Hi Tom,

On Tue, 8 Jan 2019 at 12:04, Tom Psyborg <pozega.tomislav@gmail.com> wrote:
> > rt2x00usb_vendor_request: Error - Vendor Request X failed for offset X
> > with error -110
> > [many of these, system is slowly locking up]
> >
> > So the only clue that I had was that perhaps rt2x00usb_vendor_request
> > wasn't catching the correct return value.
>
> Hi
>
> error message vendor request failed - do you get it on a real hardware
> or in virtualized environment?

I only run these on bare metal. What I assume so far is that when
rt2x00usb_vendor_request starts failing like this, the MCU has failed.
Power cycling the system helps but is undesirable, and sometimes so
does a forced removal of rt2800usb, a short recovery period (cooling
down, reloading the firmware?) and then loading the module again.

But the problem I am looking to solve is not a hardware problem, it is
recovering gracefully from a failure in the RT5592, so I have been
looking intently at rt2x00usb_vendor_request because that's the
function that complains loudly and kills the entire kernel when the
RT5592 sees this failure.


Kind regards,
     jer
