Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:18177 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab2KFQuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 11:50:23 -0500
Message-ID: <50993FC2.7040100@ehuk.net> (sfid-20121106_175036_072563_743A7A6E)
Date: Tue, 06 Nov 2012 16:50:10 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>  <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>  (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>  <509838F4.4010301@ehuk.net> <1352188621.9440.4.camel@jlt4.sipsolutions.net>  <50992E0E.3040606@ehuk.net>  <1352217244.9440.16.camel@jlt4.sipsolutions.net>  (sfid-20121106_165343_414402_7F00AE58) <1352219976.9440.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352219976.9440.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 06/11/12 16:39, Johannes Berg wrote:
> On Tue, 2012-11-06 at 16:54 +0100, Johannes Berg wrote:
>
>>> BSS 82:e1:fa:1a:65:00 (on wlan0) -- associated
>> [...]
>>> 	HT operation:
>>> 		 * primary channel: 9
>>> 		 * secondary channel offset: above
>>
>> As you can see, it's using HT40+ on channel 9 (2452 MHz). Your HT40
>> allow (correctly) map showed:
>>
>> 2452 HT40 -
>>
>> This is because HT40+ isn't actually allowed on channel 9 by the
>> standard (cf. 802.11-2012 Table E-1 (US), E-2 (Europe), E-3 (Japan).
>
> Oops, no, that is obviously wrong. This is permitted outside the US, and
> that is reflected in those tables as well (I was confused). However,
> your AP isn't transmitting any info on where it is, and your device is
> set up for world roaming (country is "00" rather than a real country).
> Thus, channel 13 isn't allowed and you can't do HT40+ on channel 9.

In the AP's dmesg output which I included in my other message, I see this:

<6>[    9.300000] cfg80211: Regulatory domain changed to country: GB

So it seems the AP knows where it is, but is it not transmitting that to 
the client?

Eddie
