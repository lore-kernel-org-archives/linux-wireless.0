Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:52507 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933111Ab2KEWJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 17:09:15 -0500
Message-ID: <509838F4.4010301@ehuk.net> (sfid-20121105_230928_336317_DB2D2B0C)
Date: Mon, 05 Nov 2012 22:08:52 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, johannes.berg@intel.com,
	florian@reitmeir.org, linux-wireless@vger.kernel.org
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>  <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>  (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352116868.9466.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/12 12:01, Johannes Berg wrote:
> On Mon, 2012-11-05 at 11:04 +0000, Eddie Chapman wrote:
>
>>> And, can you also test 3.7-rc4, to ensure that the problem isn't there
>>> as well?
>
>
>> I've narrowed it down to this patch which introduces the problem:
>>
>> Johannes Berg:
>> mac80211: connect with HT20 if HT40 is not permitted
>> commit: 3a40414f826a8f1096d9b94c4a53ef91b25ba28d
>>
>> The other 3 patches above give me no problems at all, so I am now
>> running my 3.6.5 with those 3 back in, and just the HT20/HT40 patch
>> removed, and throughput is perfect. As soon as I introduce the patch
>> HT20/HT40 throughput drops right down to a fifth of what it was.
>
> This should also be the case on 3.7-rc4, since the patch came from
> there, and I don't see any reason to believe rt2800 would behave
> differently here, for some reason.
>
> Can you show me the contents of
> the /sys/kernel/debug/ieee80211/phy0/ht40allow_map debugfs file and "iw
> reg get" command?
>
> johannes

Hi Johannes,

Here is the output of /sys/kernel/debug/ieee80211/phy0/ht40allow_map:

2412 HT40  +
2417 HT40  +
2422 HT40  +
2427 HT40  +
2432 HT40 -+
2437 HT40 -+
2442 HT40 -+
2447 HT40 -
2452 HT40 -
2457 HT40 -
2462 HT40 -
2467 HT40
2472 HT40
2484 HT40


and "iw reg get" says:

country 00:
	(2402 - 2472 @ 40), (6, 20)
	(2457 - 2482 @ 20), (6, 20), PASSIVE-SCAN, NO-IBSS
	(2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
	(5170 - 5250 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
	(5735 - 5835 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
	(57240 - 63720 @ 2160), (N/A, 0)


I captured both of these with the HT20/HT40 patch applied.

let me know if you need anything else.
thanks,
Eddie
