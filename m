Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59029 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZGaTfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:35:15 -0400
Received: by ewy10 with SMTP id 10so1752289ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 12:35:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249067385.20276.16.camel@mj>
References: <20090731181020.GE7963@makis>
	 <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
	 <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
	 <1249067385.20276.16.camel@mj>
Date: Fri, 31 Jul 2009 22:35:14 +0300
Message-ID: <40f31dec0907311235g63c10e53obec06ba542d942cd@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/31 Pavel Roskin <proski@gnu.org>:
> On Fri, 2009-07-31 at 21:25 +0300, Nick Kossifidis wrote:
>
>> a) We don't need a timer for this, there is no need for accuracy
>>     even with round_jiffies i think this is a waste of resources.
>>     Also we don't need to run calibration if we are idle (no interrupts).
>
> It doesn't sound right to me.
>
> Can it be that the device gets so miscalibrated during the silence that
> it won't be able to receive signal once it's there?  Say, the device is
> set to channel 1 but it actually listens to channel 3, and there are
> some weak beacons on channel 1.
>

Nope calibration deals mostly with noise immunity, it calculates the
noise floor and fixes QAM constellation. It's not related to the synthesizer
so it's not related to the channel frequency.

> And then there is an issue of the frequency straying outside the
> permitted spectrum.  Perhaps the transmission will trigger interrupts
> and thus recalibration, but in case of scanning, the first probe
> requests could be on wrong frequencies.
>

On each reset we trigger calibration so no worries there.




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
