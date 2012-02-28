Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:52287 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965090Ab2B1PPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 10:15:52 -0500
Message-ID: <4F4CEFA6.2090005@raritan.com> (sfid-20120228_161555_339240_36D9E542)
Date: Tue, 28 Feb 2012 16:15:50 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Occasional truncated scan results
References: <4F4CE4D6.6020108@raritan.com>  (sfid-20120228_152950_864254_C21F9143) <1330440166.3368.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330440166.3368.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.02.2012 15:42, Johannes Berg wrote:
>> After some playing with different wireless devices I discovered that
>> this is not limited to specific drivers so I digged a bit in the scan
>> code in net/wireless/scan.c and found the culprit: The scan result is
>> put together with the iwe_stream_* functions that place data into a
>> provided buffer if enough space is available in the buffer. Otherwise
>> the functions do just nothing. Before a BSS is added there is a check if
>> some minimum space is available but after the BSS has been added it is
>> not clear how many data actually has been placed into the buffer. So
>> especially (but not neccessarily only) the last BSS is prone to be
>> incomplete. I my case all the IEs were missing and this was persistent
>> over some time (the persitence behavior seems to differs between drivers
>> - probably depends on how the scanning is implemented).
>>
>> Currently I implemented a heuristic that checks if some minimum space
>> (currently 256 bytes) is still free _after_ adding a BSS and otherwise
>> return -E2BIG so the user space can provide a larger buffer but this is
>> a crappy hack.
>>
>> Can the code be changed in some way to more reliably detect if some data
>> did not fit into the buffer and report this to user space?
>
> Unfortunately not. The maximum buffer size userspace can provide is
> limited to 64k. In busy environments, this size can be exceeded. As a
> result, if we do this, you can't get *any* scan results in such
> environments. I believe the current code is almost the best we can do
> for wireless extensions, but it may be possible to implement never
> truncating a single BSS entry.

My problem is not that the scan results are larger than 64k. The user 
space is coded so that it provides a small buffer that is doubled in 
size until the data fits into the buffer. But the kernel code does not 
always detect the case that the buffer is almost full and just starts 
skipping some data without notifying user space with E2BIG.

> That said, there's a very simple fix for this. Since you're talking
> about net/wireless/scan.c, you're obviously using a driver with cfg80211
> support. Ditch wireless extensions completely and use nl80211 instead,
> you'll be much happier overall as it has no such limitations and more
> features.

Thanks for the hint. I will have a look into this.

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler
