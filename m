Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4919C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2232175B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfA2H2X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:28:23 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40910 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfA2H2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 02:28:23 -0500
Received: by mail-io1-f68.google.com with SMTP id k2so15757418iog.7
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 23:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lR9iFBLz70HURn/RfZl8AE1z9Gx6JKVHNWTSyYEBwcg=;
        b=l+/82znb4tsvwzVWz5ZfH0ZClimfnelkz1YN/C669kjGaTLKqChLFP68kcdPxxfdGC
         wqMqE7MNPB7jMHFZpeBnGeAd8RXgKjteL0g+rrO8iaWl9o/86B/LuDrCzcvf4M2u8C20
         f1IsMKNZzG4NxgMrMbzPwW2vUHBs6XWU7EUSzEGT031aeQ2IDeE8Qs8lI+mGl8b7+h3A
         pl7paY+SDY15IYo6ogfNRBPq1luH1SiybHlFTs1rbsQt7VqDJ6aKm37tWqjdYZK5rpFI
         5ixV92br9MgMDZpwQS8o51jynxdQZOU0IkAr5uY4zImpzxHniMFXjSUazyvUc4LWh2jz
         hvqg==
X-Gm-Message-State: AJcUukcQu2Ubt+EZbDMdAGLfMwDtQIoKidPxDtruxUnk1rxa5pH++u0Z
        gn2Wz11snk0rP+lSijHe/Zt8kYwD/HpcQ3rZL3k29A==
X-Google-Smtp-Source: AHgI3IbAlIThp8geSDRtoQZerJAjI4y1nBDRFm12PvYr4Kcxod0DcUgNH3ROS3JB+BZdF+T7R5SGZVVxOZr0nwfM2DE=
X-Received: by 2002:a6b:ea09:: with SMTP id m9mr14150029ioc.297.1548746902616;
 Mon, 28 Jan 2019 23:28:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
 <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
 <87tvhstujr.fsf@purkki.adurom.net> <20190128205002.GA2165@localhost.localdomain>
 <87bm40ym88.fsf@codeaurora.org>
In-Reply-To: <87bm40ym88.fsf@codeaurora.org>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Tue, 29 Jan 2019 08:28:11 +0100
Message-ID: <CAJ0CqmVPK6R45F511Bnc4EXGFkEnwRsYhPTGpfvy59v8RbsOBg@mail.gmail.com>
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >>
> >> > Report correct eeprom per channel power value.
> >> > Fix chan_vs_power map in mt76x0_get_power_info routine
> >> >
> >> > Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
> >> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> >>
> >> So what's the actual bug this fixes? The commit log is not really clear
> >> on that. Wondering because you marked this for wireless-drivers.
> >
> > Hi Kalle,
> >
> > You are right, I have been not so clear in the commit log.
> > Offsets in chan_map were wrong since mt76x02_eeprom_get() reads at even addresses.
> > Moreover 'if' condition in the for loop was wrong (chan->hw_value and
> > chan_map[i].chan were swapped)
>
> But how does this affect from user's point of view? I mean what feature
> is broken and how does this fix that?
>
> --
> Kalle Valo

mt76x0_get_power_info() is used to read from eeprom the global max tx
power according to the operating channel.
mt76x02_eeprom_get() reads just at even addresses and it reports -1
for odd ones (so offset must be a even).
This issue will affect the tx power that userspace is able to configure.
Do you think it is better to merge it in wireless-drivers-next?

Regards,
Lorenzo
