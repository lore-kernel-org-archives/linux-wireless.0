Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:39334 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbbCFF07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 00:26:59 -0500
Message-ID: <54F93907.6020408@tampabay.rr.com> (sfid-20150306_062702_092229_F7039236)
Date: Fri, 06 Mar 2015 00:20:07 -0500
From: Marco <marco@tampabay.rr.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: carl1970: monitor mode only displaying beacons/probs from APs?
References: <20150304230225.J5EHX.13935.root@cdptpa-web27> <3859987.D1VAPy8h72@debian64>
In-Reply-To: <3859987.D1VAPy8h72@debian64>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/15 06:10, Christian Lamparter wrote:
> Hello,
> 
> On Wednesday, March 04, 2015 11:02:25 PM marco@tampabay.rr.com wrote:
>> Quite a while back after doing an upgrade to the latest (back then)
>> compat-wireless, I noticed that I was only seeing beacon,prob requests, and
>> the occasional data packet when in monitor mode; which at the time I wrote
>> off.  After switching to backports-3.18.1-1 recently, I still see the same
>> behavior(on x86 and arm).  I'm sure I'm missing something, but I couldn't
>> find any references to this behavior in my search.  I also tried "iw wlanX
>> set monitor control otherbss" to no avail.  Switching to a different chipset
>> using ath9k-htc showed expected traffic.
>>
>> Can anyone point me in the right direction?
> maybe. Could it be that you are looking for 802.11n(MCS) data frames?

I'm trying to see any and all frames (ctrl/mgmt/data).  I'm currently
doing my testing on 2.4ghz band, channel 11.  Playing with HT didn't
seem to make a difference.


> Because by default, carl9170's monitor mode only catches the legacy 
> 802.11a/b/g frames. If this is the case, then try setting the right
> channel mode (HT20/HT40+/HT40-) when selecting the channel. i.e.:  
> 
> # iw dev wlanX set channel Y HT20
> # iw dev wlanX set channel Y HT40+
> 
> I hope this helps. Otherwise, you could try: 
> 
> # iw dev wlanX set monitor [...] fcsfail
> 
> and see if you are picking up frames this way. This should work, but you
> will be picking up mostly damaged stuff, so some extra frame processing
> will be needed to filter out the noise. 
> 
> Regards,
>   Christian
> 

I've previously (and once again for good measure) tried fcsfail to no
avail as well.

I'm surprised no one else is seeing this/reported this, I've tried on
3 separate linux boxes now with no luck.

Regards,
Marco
