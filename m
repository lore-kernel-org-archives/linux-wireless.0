Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61D2C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 21:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9839620818
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 21:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oaDHc7Ip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfBEVGx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 16:06:53 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:35115 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfBEVGx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 16:06:53 -0500
Received: by mail-ot1-f53.google.com with SMTP id 81so8327866otj.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2019 13:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKBLxK1zZ8uXIpFquzzCdXnQ9lm2s5oPY5fg1sS00aU=;
        b=oaDHc7IpyYYyMNhSoBp+MQUILBLDftQiANgq8L0wYAnKSI0YTuZ0EVmK4hLHJq65GM
         vhvF/lV+JRnOWkaKOzWFiHuzQX47P/AYgnZrLt8q65mfLdRIr6eQ3/0wYdpxuml3xhbc
         IAMbCTo5gqtOcSHCutctsyuA5AMZyXstHsAn8qU5p8KHiJd0GKuWlzCt0nI3EEwbdmsv
         y1rKht0RmhGQ405P9aGnLnuhVuMfpp1OMMeskzxTryMSpuB95XXpMYUgRXZ+TCcbDPYr
         wB4b4mwfH09Xmx9Nsg4wVXjKu9Hc25xqCP5O0Ihk/nI0wZX/PT03T5w9TjGXs5MjAmfe
         c2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKBLxK1zZ8uXIpFquzzCdXnQ9lm2s5oPY5fg1sS00aU=;
        b=nwnXpjWpo6XkyOlWwvi9qUHifevvHezPIJV0BffQULgzhuIrkjibcG0pSuf4lwYkpw
         ljS3EKbuT0qwQWP6Kqi2bxOOW8MERuTvOQHmYbOdMfdlUmGGr46s6XEEak5LvvJ1R3cw
         n/BZnxkQSpZoQIJ4IKPDnEfk9fTzMuz0i5kVtWbNsZeZvOoCnxiM+CuiDtzdzOONXUSf
         desHkQTy86PCorG5oyPlWUJN0btbyAJBo6r8BNfK3Yaqu8bGBHBPe5Q67qpA7Cp6fqHP
         8O5E5UtyuY37glCWSi/feAVMDVSzZQZ+OidpgfnyC0jffXcAD+5njXEUARalHgXonQ1+
         8cdg==
X-Gm-Message-State: AHQUAuYjeBziuvxf9ANpMpUlHsYaxTy0byfdeuUUG41k74euY/5wr3I1
        Of238DS2KB68uAw0HqnvvukHjkXCQq9e/6xFAbZcRg==
X-Google-Smtp-Source: AHgI3IblUYmphgWU0pePkTvyhL2BTdauWhMZmjQyernn0B89D7YY7Amgru88IyzoeFNIRhdI06XepWcBfjIc4pP7tqk=
X-Received: by 2002:a9d:751a:: with SMTP id r26mr3795848otk.273.1549400812300;
 Tue, 05 Feb 2019 13:06:52 -0800 (PST)
MIME-Version: 1.0
References: <CAKxU2N9choD2mdQd+Qwf5047VNWdwKOPB_YRXvw4i6BtLn6vxQ@mail.gmail.com>
 <20190205151022.GE7510@redhat.com>
In-Reply-To: <20190205151022.GE7510@redhat.com>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Tue, 5 Feb 2019 13:06:41 -0800
Message-ID: <CAKxU2N9XGgaroZ0ijmdG0xkiBqae9KWXt8_Op4ZS21HvJY10Fw@mail.gmail.com>
Subject: Re: [mt76x2e] minipcie card is not working
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 5, 2019 at 7:14 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Mon, Jan 28, 2019 at 12:14:49PM -0800, Rosen Penev wrote:
> > I have a full height production sample mt7612e card that does not work
> > in either Access Point or Client mode. Monitor mode does not work
> > either (no packets received/transmitted).
> >
> > dmesg shows everything to be fine:
> >
> > [    5.801993] mt76x2e 0000:2b:00.0: enabling device (0000 -> 0002)
> > [    5.802122] mt76x2e 0000:2b:00.0: ASIC revision: 76120044
> > [    6.466527] mt76x2e 0000:2b:00.0: ROM patch build: 20141115060606a
> > [    6.468999] mt76x2e 0000:2b:00.0: Firmware Version: 0.0.00
> > [    6.469000] mt76x2e 0000:2b:00.0: Build: 1
> > [    6.469001] mt76x2e 0000:2b:00.0: Build Time: 201507311614____
> > [    6.496042] mt76x2e 0000:2b:00.0: Firmware running!
> > [    6.497999] mt76x2e 0000:2b:00.0 wlp43s0: renamed from wlan0
> >
> > This is on 5.0-rc3.
> >
> > Tested with a desktop running Ubuntu 18.04 (custom kernel) and an
> > mvebu device (Turris Omnia) running OpenWrt on kernel 4.14.
>
> I have access to similar device and it does not work for me.
>
> You can check latest mt76 driver https://github.com/openwrt/mt76 ,
> some users reported success with mt76x2e problems, but I can
> not confirm that with my device.
>
> Do you have Mediatek driver for it (i.e. received driver on associated
> CD with the device) or know about such driver. If so, does it work?
Don't have another driver.

I also noticed mt76 starts failing after suspend with this device.
I've blacklisted it for now.
>
> Thanks
> Stanislaw
