Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8878DC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 01:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CD1E22419
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 01:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aA46LKAW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CD1E22419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbeKOLMy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 06:12:54 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32795 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbeKOLMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 06:12:54 -0500
Received: by mail-lj1-f194.google.com with SMTP id v1-v6so15831278ljd.0;
        Wed, 14 Nov 2018 17:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTZOVDqnHHoH/Q26YCTe8q24v75cZpeZk+SWc8raVz4=;
        b=aA46LKAWr6we+WcnmuVsHjuh5SN297imQZBGsduKx8nphInoKLHKTm0zWMFTpxIvGY
         2jKwpU9nXVdVb4zi5uqMZIqnIOWUDZa0S62iyv8yQk0TaIMwkLfWckNO06kQckqdWFRr
         LxRretxPaltLO01kEx9+0D2I9/aJYuiDO5qjTKihkSboW6yg74SIgfoyfDV6yKYPuS1g
         Bi9F1A1CLiaP7npigGJ1Qn2YQsgjfGpgYHkIWqsFsxKTMCmT6zr9HjSM+HAKH31dS2KR
         WDQYOGxuMuBH4pj9ob+aSX2s4WFWKJHCol5GGOCjF2KOfEk0uWwd8OOv6gPYpwm4em70
         gH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTZOVDqnHHoH/Q26YCTe8q24v75cZpeZk+SWc8raVz4=;
        b=qGbvf06gh9vSbY6WRzOobtqN4INe1B3cWJ5r+z2tDjqJw11dxVSWvwFEhauZZt9IGF
         JrfsKSC23sEIHiYSTp7o83ZJrTWrZEpps0y5S/dhHhLDQyBmogdf4iloyO2xCm+lWwzN
         09uKz5E+Gq+2GyKi1Y78uXj4YHiPhujCGzLRnjEiLMT5uNHMHQC69GsebXogneKmVLm+
         0077DFNKJFfEWmKiIGZnUNW/LLpOWeZwqNd3MpjOwWNRFWjfqSpovisB8FecEJT84DZ4
         CHpg+ytyJ8s8HeDJZZXHPFxb7GsBinpMKxCwDwUCDtCTG82okJ8poYyg678S4kOeMqDH
         pEKg==
X-Gm-Message-State: AGRZ1gLKw4bbcPOMEZ+PZR4r7z3UNsUKotJx4YXYh6l3C87YyGWRBWrx
        pzJLt4PNfcPVktBImH5ndRZHkAFJdJWvLPd76ukEVXM=
X-Google-Smtp-Source: AJdET5f6RsIclF6p5+2zjbE5OjfzatD7jof5b2gehKLT6WJ2pARxB2aL9PAr6scB2QQfl+UpQlPN9GzVBcfgMCRTY14=
X-Received: by 2002:a2e:5d12:: with SMTP id r18-v6mr2681812ljb.89.1542244034055;
 Wed, 14 Nov 2018 17:07:14 -0800 (PST)
MIME-Version: 1.0
References: <CAEJqkgiKzYTZQTGWNAPTeOPFWz658FWqDsAhyoxVDP1VKWSukg@mail.gmail.com>
 <CAEJqkgh7xksO7tmPHGkOXvWftc2AcCgi4j3S3C88CorV53+Hgw@mail.gmail.com> <CAEJqkghgyYMxRc8-wnF-J1CGhuYD2vfVDSiLU1A0fwpXKN7Huw@mail.gmail.com>
In-Reply-To: <CAEJqkghgyYMxRc8-wnF-J1CGhuYD2vfVDSiLU1A0fwpXKN7Huw@mail.gmail.com>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Thu, 15 Nov 2018 02:06:47 +0100
Message-ID: <CAEJqkgiz0-5m5uDUW2vzCatxHPX2Gi6oPQwR_J5Y4fV8iuiguw@mail.gmail.com>
Subject: Re: atk10k Unknown eventid and WARN() on resume with kernel 4.19
To:     Kalle Valo <kvalo@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, dex77@frugalware.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am Mi., 14. Nov. 2018 um 23:16 Uhr schrieb Gabriel C <nix.or.die@gmail.com>:
> > > Hello,
> > >
> > > starting with kernel 4.19 we noticed  'Unknown eventid: xxxx' warnings
> > > on our Laptops.
> > >
> > > ...
> > >
> > > crazy@devnull:~$ dmesg | grep Unknow
> > > [    7.144998] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > > [    7.147758] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > > [    9.441654] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > > [    9.444446] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > > [   11.770997] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > > [   11.773787] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > > [320339.374108] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > > [320339.377020] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > > [320342.128664] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > > [320342.131447] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > > [320344.452864] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > > [320344.455696] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > >
> > > ....
> > >
> > > Both boxes also hits the following WARN*() on resume from S3:
> > >
> >  Uh sorry .. Gmail doesn't like long lines it seems.
> > There the WARN() message:
> >
> > http://ftp.frugalware.org/pub/other/people/crazy/warn.txt
> >
> > >
> > > Please let me know if you need an dmesg or any other informations.
>
>
> Added pm list maybe someone there got some idea ?
>
> Also same issue reported there :
> https://bugzilla.kernel.org/show_bug.cgi?id=201499
>

The WARN_ON() on resume seems to be triggered  after commit cd93b83ad927b.

BR,

Gabriel C
