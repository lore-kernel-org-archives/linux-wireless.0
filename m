Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33451 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0IOFtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 01:49:17 -0400
Message-ID: <4C905E4D.7060707@candelatech.com>
Date: Tue, 14 Sep 2010 22:49:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
References: <4C8EB03D.7070808@candelatech.com>	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com> <1284529613.10728.32.camel@dcbw.foobar.com>
In-Reply-To: <1284529613.10728.32.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 10:46 PM, Dan Williams wrote:
> On Tue, 2010-09-14 at 22:30 -0700, Ben Greear wrote:
>> On 09/14/2010 08:03 PM, Jouni Malinen wrote:
>>> On Mon, Sep 13, 2010 at 04:14:05PM -0700, Ben Greear wrote:
>>>> This patch aims to decrease channel switching when there is at least one
>>>> interface associated.  This should help multiple station interfaces co-exist
>>>> on the same hardware, especially in WPA mode.
>>>
>>> If I understood the change correctly, it would prevent running full
>>> scans when in associated state. That does not sound reasonable behavior
>>> and scanning should not cause an association to be lost. Did I miss
>>> something or what exactly is this trying to do?
>>
>> That's pretty much what I'm trying to do.  We had similar code in
>> our 2.6.31 kernel with ath5k. Imagine getting 50 virtual stations
>> started with WPA and all of them trying to scan all channels at once!
>> Most got timeouts, and one scanning would disrupt traffic on the others.
>> And, the hardware can only associate on a single channel anyway, so getting
>> scan results for other channels doesn't do a great deal of good.
>>
>> With current ath9k, I see DMA timeouts and other nasty things (without
>> that patch applied) when trying to bring up two VIFs with WPA.
>>
>> I think for the multi-VIF scenario, it should scan the single associated
>> channel by default, but it would be nice to allow full scans on demand.
>> (I would very much like to work with standard wpa_supplicant, but if hacking it
>> is the only way, then I can attempt that.)
>
> Allowing full scans on demand (ie when userspace requests it) is a must.
> Even in multi-VIF mode.

So, something like 'iw sta1 scan all' to force scanning all,
with 'iw sta1 scan' just returning results for associated channel
in multi-vif scenario?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
