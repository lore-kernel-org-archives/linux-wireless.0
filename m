Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6217DC43610
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 20:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F4820645
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 20:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="APftx1en"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27F4820645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbeKVHfR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Nov 2018 02:35:17 -0500
Received: from smtps.newmedia-net.de ([185.84.6.167]:52467 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726280AbeKVHfR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Nov 2018 02:35:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=ki6cmGpXhyDGiaUih9kVIZaeH2ViBgzSc2o0YYDQdg0=;
        b=APftx1en4ES0c7WC8OkauxdOHeSdFBGs3brALugomUakeZmmuQSIiB6E+DTfvmAZzo2RfxAzaV8iIM7XaGbvOxUh0PlG2JwBaG1clhA4TR2LNBpfHQ6sm+f5kDjork1QEXbdbKtFhj120Z1XvKFcds3avlQa8l+WrSrc+6BLmew=;
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting
 and scheduling to TXQs
To:     "David P. Reed" <dpreed@deepplum.com>, David Lang <david@lang.hm>
Cc:     Dave Taht <dave.taht@gmail.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>
References: <1542814135.446217011@apps.rackspace.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <eb65f613-23b0-737f-fabe-851e6c1abbdd@newmedia-net.de>
Date:   Wed, 21 Nov 2018 21:58:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1542814135.446217011@apps.rackspace.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f20:e600:9889:74bc:2bca:489c]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gPZaY-00083j-H6; Wed, 21 Nov 2018 21:59:10 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

its not bluetooth. active tire pressure control systems are based on 433 
mhz in most countries. in the usa its 315 mhz

Sebastian

Am 21.11.2018 um 16:28 schrieb David P. Reed:
> Really? Tires are Bluetooth? I don't think mine are, but now I want to figure out how that works. 1600Chips/sec is 600 microseconds per chip. They spin at up to, say, radial rates that are a 100 revs/sec and thus take maybe 10 msec. to travel 30 cm. How much warble in a chip frequency is there?
>
> Ok, maybe they only need to work when the car is stopped.
>
> I would design a tire pressure system that sends, maybe, 10 bits per second, at most. Or calibrate the sensor to produce 1 bit, and use the car metal frame to carry the signal to the computer as a single bit. A very slowly varying sensor can be sensed without needing a battery, by using some passive, tuned circuit.
>
> Bluetooth is way overkill, but cheap. I doubt it works well in the application, though.
>
> -----Original
> From: "David Lang" <david@lang.hm>
> Sent: Mon, Nov 19, 2018 at 9:12 pm
> To: "Dave Taht" <dave.taht@gmail.com>
> Cc: "Dave Taht" <dave.taht@gmail.com>, "Rajkumar Manoharan" <rmanohar@codeaurora.org>, "Make-Wifi-fast" <make-wifi-fast@lists.bufferbloat.net>, "linux-wireless" <linux-wireless@vger.kernel.org>, "ath10k" <ath10k@lists.infradead.org>, "Ben Greear" <greearb@candelatech.com>, "Felix Fietkau" <nbd@nbd.name>
> Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting and scheduling to TXQs
>
> On Mon, 19 Nov 2018, Dave Taht wrote:
>
>>> I'm not sure if this was a fluke or not, but at Starbucks recently I sat outside,
>>> right next to their window, and could not scan their AP at all.  Previously, I sat
>>> inside, 3 feet away through the glass, and got great signal.  I wonder what that was
>>> all about!  Maybe special tinting that blocks RF?  Or just dumb luck of some sort.
>> Ya know, I could definitely see a market for a material like that! I'd
>> like it for my car, so bluetooth wouldn't escape.
> That would break your tire pressure sensors (each car is rolling around
> broadcasting 4 unique bluetooth IDs, not hard to track)
>
> David Lang
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
>
>
