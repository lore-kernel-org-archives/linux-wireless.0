Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39357 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0IOOWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 10:22:03 -0400
Message-ID: <4C90D683.7000801@candelatech.com>
Date: Wed, 15 Sep 2010 07:21:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
References: <4C8EB03D.7070808@candelatech.com>	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com> <1284545796.3842.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284545796.3842.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2010 03:16 AM, Johannes Berg wrote:
> On Tue, 2010-09-14 at 22:30 -0700, Ben Greear wrote:
>
>>> If I understood the change correctly, it would prevent running full
>>> scans when in associated state. That does not sound reasonable behavior
>>> and scanning should not cause an association to be lost. Did I miss
>>> something or what exactly is this trying to do?
>>
>> That's pretty much what I'm trying to do.  We had similar code in
>> our 2.6.31 kernel with ath5k. Imagine getting 50 virtual stations
>> started with WPA and all of them trying to scan all channels at once!
>
> They can't ... cfg80211 limits it to one scan at a time per hardware ...

Right, but as soon as one finished, the next would start, and at least in .31,
that caused the first to un-associate, giving never-ending loop of interfaces
scanning and trying to associate.

>> I think for the multi-VIF scenario, it should scan the single associated
>> channel by default, but it would be nice to allow full scans on demand.
>
> Go change your userspace then to request only the single channel scan.
>
>> (I would very much like to work with standard wpa_supplicant, but if hacking it
>> is the only way, then I can attempt that.)
>
> Yes, I don't see how we can reasonably work around this in the kernel.

Ok, I'll see if I can add a 'scan-one-if-associated' flag for wpa-supplicant to
use.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
