Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53029 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYIOKCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 06:02:09 -0400
Received: by gxk9 with SMTP id 9so24452450gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 03:02:08 -0700 (PDT)
Message-ID: <40f31dec0809150302m31b2aa76r4d0e7bf1d395a6f8@mail.gmail.com> (sfid-20080915_120213_060240_E16C788F)
Date: Mon, 15 Sep 2008 13:02:07 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Brian Prodoehl" <bprodoehl@gmail.com>
Subject: Re: ath5k, higher bitrates (>24M) not working in IBSS mode
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <415f2dc40809142020n5647007bm6538158317817c01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <415f2dc40809142020n5647007bm6538158317817c01@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/15 Brian Prodoehl <bprodoehl@gmail.com>:
> I'm testing the driver (2008-09-12 compat-wireless-old snapshot) doing
> point to point communication in ad-hoc mode with some XR2's (AR5414)
> on an ixp425 platform running kernel 2.6.25.1.  "iwlist scanning"
> reports RSSI around -30dBm.  I'm setting the bitrate with iwconfig,
> and all rates from 1M to 24M work beautifully, but if I set the rate
> to 36M, 48M or 54M, absolutely no data gets through at those rates.
> Its not like it gets really lossy or anything, absolutely nothing
> (except broadcasts) get through.
>

It's a known problem, not only for IBSS mode. We don't initialize RF
parts correctly, we are not doing any power calibration nor adaptive
noise immunity (ANI). Depending on your environment and your card you
might not be able to set any rate above 18M or you might get 25 -
27Mbits @ 54Mbits (i have seen both behaviours during my tests).

Right now this is work in progress, i hope we 'll have something soon
(at least for ANI). Broadcasts might get through because they don't
need to be ACKed from the card (to mark a frame as txed card must sent
the frame and receive an ack for it, if the noack flag is set then it
only has to send it and doesn't wait for an ack, so if rx path has
problems on some rates -due to bad rf initailization- card might be
able to send a frame but unable to receive the ack, so you get packet
loss for non-multicast frames).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
