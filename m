Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A842C677FC
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 19:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CFC82075C
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 19:31:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMB6e+t1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CFC82075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbeJLC7l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:59:41 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:44110 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbeJLC7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 22:59:41 -0400
Received: by mail-qk1-f177.google.com with SMTP id y8-v6so6214789qka.11
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 12:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/Zuk7R5+uxRx4erk8GrBpi2ZdJAIfx6Z3p5bEINm47k=;
        b=bMB6e+t1UD4aYZnEwS2BtHp0BY3JGTO+QBn1IaejolXw5n960vgzBSREl1RTUd52pn
         anuoi4h07sYU0f6DIQRrDhL+LyZNZ0EzYG5qSVuN0QW/f8EbB7p4WRzfU3RJ2Kb7WSzy
         TrLij6BrY1J6yksEYL3OsrFRgqpBK8z1qR6Lpr64x58qUdw5hkQeG8FpzuI3Nz4PyjsD
         elwP5EayzMmRtjnogT7mj3Mr2jvfWg/ms076t6UM/NnbfVBwSOkTva7jjYQFzC4kRXbb
         SNtbBMKgcWQzkhEf4ZhQU9Qs+eX9s6kYmfzybCQ+A+0iBwrzru38coutrONlGtWO1Akx
         N/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/Zuk7R5+uxRx4erk8GrBpi2ZdJAIfx6Z3p5bEINm47k=;
        b=AcE2mMkprU8UDsioQPIdEO2h5a3lqadTf59/I8tmMrrRHuWibKM5/MRxs/eXVXwRql
         DcgMoc5eZfA2dEKRcxNlSuYFGK4k9wLm2WcREjPVp4gxC67qQVVIcmlpvz+rC+w26KSr
         BA097VpASpE/L5oICcENIFVxIaH9+CzjFXXxMCXZDxjpTBDSKeNn6AAnnCxMt6HA0jGa
         yPId746laSFLqXkp7gaT2spl01lh1LRTlcCpu5H4VJskmiLUXy1/1zGOZjisO9lsnaxs
         z3+reuACYB3X32E97IgR+8iz9VJcDQVB45yxItNuCptloKchjpqD+b5tpLuXOa9brVXs
         GouQ==
X-Gm-Message-State: ABuFfoilQ1T6J8OjDJ0oFf6/yrGXvHuAbzsnohzM5VmIoBf7HVGtLBLt
        3C1BdAv3u82nPhC5kWJUnd1MYzakzE/a6BfV3g3XPQ==
X-Google-Smtp-Source: ACcGV62BnmoYHYkiFKq4vL2Fejdv8ZB8B/+fUshQT2U4TlZThe87kDidfahQ85tkPxfv0quQAjp/a8aOkXJvwvyx4/g=
X-Received: by 2002:a37:170d:: with SMTP id i13-v6mr2865834qkh.125.1539286261963;
 Thu, 11 Oct 2018 12:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <edaca500-8ae2-aef4-1c9d-b754af7e899f@gmx.com>
In-Reply-To: <edaca500-8ae2-aef4-1c9d-b754af7e899f@gmx.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Thu, 11 Oct 2018 21:30:50 +0200
Message-ID: <CABvG-CUJNAq=4XWf3bVYw_EF4W8zmmL7fvc=nt+Zae82Wn7yug@mail.gmail.com>
Subject: Re: Intel 8265 unstable/asymmetric ping response time (only under Linux)
To:     quwenruo.btrfs@gmx.com
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 11 Oct 2018 at 15:56, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> Hi,
>
> I found one pretty strange behavior for the Intel 8265/8275 wireless
> (from ThinkPad X1 carbon)
>
> If I ping *FROM* my router/desktop to the wireless laptop, the response
> time is very unstable and slow, like:
> ------
> $ ping -4 thinkpad
> PING thinkpad.lan (172.16.0.100) 56(84) bytes of data.
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D1 ttl=3D64 time=3D1=
43 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D2 ttl=3D64 time=3D1=
66 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D3 ttl=3D64 time=3D1=
88 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D4 ttl=3D64 time=3D2=
11 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D5 ttl=3D64 time=3D2=
9.8 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D6 ttl=3D64 time=3D5=
1.7 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D7 ttl=3D64 time=3D7=
2.8 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D8 ttl=3D64 time=3D9=
4.6 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D9 ttl=3D64 time=3D1=
17 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D10 ttl=3D64 time=3D=
140 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D11 ttl=3D64 time=3D=
163 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D12 ttl=3D64 time=3D=
186 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D13 ttl=3D64 time=3D=
207 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D14 ttl=3D64 time=3D=
25.1 ms
> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D15 ttl=3D64 time=3D=
47.6 ms
> -----
>
> It looks like the response time get increase by 20ms and flipped over
> around 200ms.
[...]
> So is this something wrong with the wireless card or something wrong
> with the firmware/powersaving setting of ThinkPad X1 Carbon 6th gen?

What you're seeing here is powersave.

When you ping your laptop its wifi card may be in powersave so AP will
store those icmp requests in a queue. The AP will start advertising
that fact in the next beacon frame (which it broadcasts regularily).
The wifi client can then see that there's traffic queued up for it,
wake up, receive it and possibly reply (with icmp response in your
case). The interval between each ping is long enough for the wifi
client to re-enter powersave due to "nothing more to do" every time
causing the same sequence (sleep, queue, advertise, wake, txrx).

The time drift comes from the fact beacon interval tends to be
slightly off from your ping interval. The fact it wraps around at
~200msec for you means your AP's beacon interval is roughly that long
as well which you can probably confirm with your AP/wifi router
settings. Most APs tend to run 100 or 200msec (or TU, actually, which
is 1024/1000 of msec) by default.

If you run more traffic the lag will go away. I find this sort of
behavior behavior annoying for mostly idle systems where I want to do
remoting with ssh (or any other bursty and interactive work).

You can try disabling powersave with:
  iw wlan0 set power_save off

You might need to replace wlan0 with wlpXsY depending on your system.
You'll need root privileges to do it, e.g. via sudo, or su.

Keep in mind it'll cause more power to be outputted and e.g. leave you
with slightly shorter battery runtime. On intel compute sticks
disabling wifi powersave can cause its fan to kick in more often due
to thermal impact and unfortunate fan trip points.

Wifi powersave might be disabled in Windows for some reason. Maybe it
does that disable it when AC is plugged in, and if you were to plug it
out and run off of battery only, it'd enable it and show similar
(laggy) behavior?


Micha=C5=82
