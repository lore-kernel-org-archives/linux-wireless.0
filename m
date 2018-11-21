Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259BBC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98E02147D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E98E02147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=deepplum.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbeKVCDu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:03:50 -0500
Received: from smtp86.iad3a.emailsrvr.com ([173.203.187.86]:40679 "EHLO
        smtp86.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731141AbeKVCDu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 21:03:50 -0500
Received: from smtp27.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp27.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id A4F2C23A0B;
        Wed, 21 Nov 2018 10:28:55 -0500 (EST)
X-SMTPDoctor-Processed: csmtpprox beta
Received: from smtp27.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp27.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 99EAE24B4F;
        Wed, 21 Nov 2018 10:28:55 -0500 (EST)
Received: from app8.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
        by smtp27.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 7ED1923A0B;
        Wed, 21 Nov 2018 10:28:55 -0500 (EST)
X-Sender-Id: MAILER-DAEMON
Received: from app8.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
        by 0.0.0.0:25 (trex/5.7.12);
        Wed, 21 Nov 2018 10:28:55 -0500
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
        by app8.wa-webapps.iad3a (Postfix) with ESMTP id 6D73D60C3A;
        Wed, 21 Nov 2018 10:28:55 -0500 (EST)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Wed, 21 Nov 2018 10:28:55 -0500 (EST)
Date:   Wed, 21 Nov 2018 10:28:55 -0500 (EST)
Subject: RE: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting and scheduling to TXQs
From:   "David P. Reed" <dpreed@deepplum.com>
To:     "David Lang" <david@lang.hm>
Cc:     "Dave Taht" <dave.taht@gmail.com>,
        "Rajkumar Manoharan" <rmanohar@codeaurora.org>,
        "Make-Wifi-fast" <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "ath10k" <ath10k@lists.infradead.org>,
        "Ben Greear" <greearb@candelatech.com>,
        "Felix Fietkau" <nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain;charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <1542814135.446217011@apps.rackspace.com>
X-Mailer: mobile/6.0.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Really? Tires are Bluetooth? I don't think mine are, but now I want to figure out how that works. 1600Chips/sec is 600 microseconds per chip. They spin at up to, say, radial rates that are a 100 revs/sec and thus take maybe 10 msec. to travel 30 cm. How much warble in a chip frequency is there?

Ok, maybe they only need to work when the car is stopped.

I would design a tire pressure system that sends, maybe, 10 bits per second, at most. Or calibrate the sensor to produce 1 bit, and use the car metal frame to carry the signal to the computer as a single bit. A very slowly varying sensor can be sensed without needing a battery, by using some passive, tuned circuit.

Bluetooth is way overkill, but cheap. I doubt it works well in the application, though.

-----Original
From: "David Lang" <david@lang.hm>
Sent: Mon, Nov 19, 2018 at 9:12 pm
To: "Dave Taht" <dave.taht@gmail.com>
Cc: "Dave Taht" <dave.taht@gmail.com>, "Rajkumar Manoharan" <rmanohar@codeaurora.org>, "Make-Wifi-fast" <make-wifi-fast@lists.bufferbloat.net>, "linux-wireless" <linux-wireless@vger.kernel.org>, "ath10k" <ath10k@lists.infradead.org>, "Ben Greear" <greearb@candelatech.com>, "Felix Fietkau" <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccounting and scheduling to TXQs

On Mon, 19 Nov 2018, Dave Taht wrote:

>> I'm not sure if this was a fluke or not, but at Starbucks recently I sat outside,
>> right next to their window, and could not scan their AP at all.  Previously, I sat
>> inside, 3 feet away through the glass, and got great signal.  I wonder what that was
>> all about!  Maybe special tinting that blocks RF?  Or just dumb luck of some sort.
>
> Ya know, I could definitely see a market for a material like that! I'd
> like it for my car, so bluetooth wouldn't escape.

That would break your tire pressure sensors (each car is rolling around 
broadcasting 4 unique bluetooth IDs, not hard to track)

David Lang
_______________________________________________
Make-wifi-fast mailing list
Make-wifi-fast@lists.bufferbloat.net
https://lists.bufferbloat.net/listinfo/make-wifi-fast

