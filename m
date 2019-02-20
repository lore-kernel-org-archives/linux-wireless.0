Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164BBC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 19:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1BB2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 19:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PK+6xrif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfBTTPQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 14:15:16 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:53794 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBTTPQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 14:15:16 -0500
Received: by mail-it1-f194.google.com with SMTP id x131so17996529itc.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 11:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kfa2BZv4u3AtUtNVuj9BPsX9/+2G10TMkCpdnuwfGKY=;
        b=PK+6xrifnav8QHjdRwCYRqqKV07gPO3x5zyDa4idcsmgDA1JSb+9F0n/ByQIZ0DRXx
         8kzvfLVsUtxOf6dHotzQcSEC92MRG2W/sd5uIU5K1QyOi/E7hcBdfQVTduSA81jUDKZ8
         OHXh6/ZL5JJi6hnFTuv/gFrI01ueqJ+rN+a4ooNJya/IKJhOBLxRChFrq0ZEocaEzbrn
         c9+H2RT9APFoV2EThjDyfLpKxhbhz6Ep31CPmE02qytH+U3C5k2I7295LO8nAAVPaPb2
         44eTtjylmiBel60pJA60HE5aOv4mLqCBJGOuQ8GUYOKmHfaAdAw1vEIPEe5SpdjJpJ7m
         MvQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kfa2BZv4u3AtUtNVuj9BPsX9/+2G10TMkCpdnuwfGKY=;
        b=ISNZgJw9/X7ZBdhkQtrXxPYvBSsStxM60eBNHIq4f1IGuqmhI9AC9mb0noyXReFmBL
         NYnLAJ1zux+X5NPEJLohPuAXw1Up051IVkQuVmkiY72JH7haWOjKHbYwdz8P8aH/jCmk
         +er98+BXzV/WcAWuiMsKk58UsBnQ+yYYHvF7kXR774HeX9jIDtKRzyNr1lfYoOR5/fw0
         o7npwjpm4fFcD9sALnnMb9SaqQOxMQfxNtAL93Bba54NW8eD8kijrxOWi/xd1u6mnF7a
         U9ZdbwLiCDyDxrbw15xo7RMl4M7ybloUIIVz6c7KSJ0mR/1y0tDjS3UDdEtxp15uWSmq
         jMkA==
X-Gm-Message-State: AHQUAuYOUCWkwfNw4WUOXrHCEUF5R6lFCYSf0x6jWNXO05mL+ML5KCuh
        hycpknyGv8W4FlyaXAENsH6JRAYHAMUBi5lACwMgmg==
X-Google-Smtp-Source: AHgI3Ib68Ec3W1E+Y4Ku0bD/9neGtrggxVb6ReUnYRDPfmsO10w7Wa/6iOw9J+yPc65Rb5Q3JVJr4fCMSoBFGM6kmNc=
X-Received: by 2002:a6b:3c17:: with SMTP id k23mr19206276iob.182.1550690115642;
 Wed, 20 Feb 2019 11:15:15 -0800 (PST)
MIME-Version: 1.0
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
 <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk>
 <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk>
 <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com> <871sa7ylmi.fsf@toke.dk>
In-Reply-To: <871sa7ylmi.fsf@toke.dk>
From:   Grant Grundler <grundler@google.com>
Date:   Wed, 20 Feb 2019 11:15:02 -0800
Message-ID: <CANEJEGuBoRMBJBOrFOYyPtiJSMfTahrVgTfxZ2ift6Q5uGazFA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Johannes Berg <johannes@sipsolutions.net>, wgong@qti.qualcomm.com,
        wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 6, 2018 at 3:18 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>
> Grant Grundler <grundler@google.com> writes:
>
> >> And, well, Grant's data is from a single test in a noisy
> >> environment where the time series graph shows that throughput is all o=
ver
> >> the place for the duration of the test; so it's hard to draw solid
> >> conclusions from (for instance, for the 5-stream test, the average
> >> throughput for 6 is 331 and 379 Mbps for the two repetitions, and for =
7
> >> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
> >> used in this test, so I can't go verify it myself; so the only thing I
> >> can do is grumble about it here... :)
> >
> > It's a fair complaint and I agree with it. My counter argument is the
> > opposite is true too: most ideal benchmarks don't measure what most
> > users see. While the data wgong provided are way more noisy than I
> > like, my overall "confidence" in the "conclusion" I offered is still
> > positive.
>
> Right. I guess I would just prefer a slightly more comprehensive
> evaluation to base a 4x increase in buffer size on...

Kalle, is this why you didn't accept this patch? Other reasons?

Toke, what else would you like to see evaluated?

I generally want to see three things measured when "benchmarking"
technologies: throughput, latency, cpu utilization
We've covered those three I think "reasonably".

What does a "4x increase in memory" mean here?  Wen, how much more
memory does this cause ath10k to use?

If a "4x increase in memory" means I'm using 1MB instead of 256KB, I'm
not going worry about that on a system with 2GB-16GB of RAM if it
doubles the throughput of the WIFI for a given workload.  I expect
routers with 128-256MB RAM would make that tradeoff as well assuming
they don't have other RAM-demanding workload.

cheers,
grant
