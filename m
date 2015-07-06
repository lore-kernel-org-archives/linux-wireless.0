Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:14333 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbbGFIbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 04:31:14 -0400
Message-ID: <559A3CCD.1050308@neratec.com> (sfid-20150706_103126_123313_2E830274)
Date: Mon, 06 Jul 2015 10:31:09 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Q: iw - how to scan for a specific ssid / AP mode scan
References: <5596BDAB.4020001@neratec.com> <1435948682.2059.41.camel@sipsolutions.net>
In-Reply-To: <1435948682.2059.41.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2015 08:38 PM, Johannes Berg wrote:
> On Fri, 2015-07-03 at 18:51 +0200, Zefir Kurtisi wrote:
>> Folks,
>>
>> I have difficulties using iw for a specific use case or fail to 
>> understand the documentation correctly.
>>
>> My platform is a recent OpenWRT, running ath9k.
>>
>> First use case is scanning for a given ssid in managed mode. 
>> According do iw's documentation (and the attribute description in 
>> nl80211.h), issuing
>>
>> iw dev wlan0 scan flush ssid <SSID>
>>
>> should do exactly this, but I keep receiving a full list of visible 
>> APs.
> 
> This is telling it to scan for that particular network, and that's what
> it's going to do, but it's still going to report everything that it
> heard, for example when hearing beacons while scanning.
> 
Ah, that explains it. Though, intuitively when providing an SSID to scan for, I'd
expect other networks seen not to be displayed. If this is of general interest, I
could work out some extension to iw and provide a related patch.

>> The second issue is about scanning in AP mode. Where I want to go is
>> having two
>> APs operating on arbitrary DFS channels with periodic scans to 
>> discover each
>> other. What I observe is
>> a) passive scanning: iw dev wlan0 scan flush ap-force passive
>>    => does not work - no scan results are provided
>> b) active scanning: iw dev wlan0 scan flush ap-force
>>   * finds only a subset of APs compared to a scan in managed mode
>>   * finds only APs on non-DFS channels
>>
>> Again, I might be missing some relevant documentation, but to me the 
>> observed results look rather like 'not yet implemented' than inherent
>> limitations.
>>
> 
> Not sure - but you do need to realize that the AP isn't really allowed
> to go off-channel for any period of time (like scanning) so this isn't
> really guaranteed to work well. Especially passive scanning seems like
> a really bad idea. As to why it's not actually working, I have no idea.
> 
Your confirmation that scanning in AP mode is not reliable helps a lot.

As for the 'bad idea', this is a special case: the APs don't provide a service at
all, they only need to discover each other reliably in a mobile environment. I
assumed AP background scanning would do the trick out of the box, but now will
move to a time multiplexed AP / STA operation.


> johannes

Thanks a lot,
Zefir
