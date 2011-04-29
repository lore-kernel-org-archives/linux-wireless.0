Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4643 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab1D2GGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 02:06:40 -0400
Message-ID: <4DBA556E.6090602@gmail.com> (sfid-20110429_080646_870424_B74DEC96)
Date: Fri, 29 Apr 2011 08:06:38 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: Yasushi SHOJI <yashi@atmark-techno.com>,
	helmut.schaa@googlemail.com, hanada@atmark-techno.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/23] rt2x00: Make rt2x00_queue_entry_for_each more flexible
References: <201104181526.01722.IvDoorn@gmail.com> <201104181526.37747.IvDoorn@gmail.com> <201104181527.06956.IvDoorn@gmail.com> <201104181527.06956.IvDoorn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> <201104181527.44542.IvDoorn@gmail.com> <878vuvt78l.wl@dns1.atmark-techno.com> <BANLkTimY0m+reba-DyPEM7kFWNSEKVyTAg@mail.gmail.com>
In-Reply-To: <BANLkTimY0m+reba-DyPEM7kFWNSEKVyTAg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/11 20:55, Ivo Van Doorn wrote:
> Hi,
> 
>> My colleague just tested this patch set and found out that the in
>> question makes our 400MHz ARM cpu board with ralink usb dongle non
>> functional due to high cpu consumption.  it seems for us that exiting
>> from function every time it finds an entry is too expensive on systems
>> slower than PCs.
> 
> Interesting, I would suspected the patch to reduce the CPU consumption
> rather then increasing it. I can do some testing regarding this looping
> during the weekend, but I haven't seen high CPU consumption on my
> system during my last test. However I wasn't testing on an embedded system...
> 
>> To verify our thought, we changed the source code as the patch below.
>> What we intended to do with this change is to continue processing all
>> entry without breaking semantics.
>>
>> With the patch below our board seem to work fine again, but not sure
>> exactly why it takes so much time to check the list again.  We are not
>> against the idea of the patch at all.  We just want to ask you guys
>> how we should go to track this problem. it might be the slow usb?
> 
> Could you try use debugfs and see if some queue and packet counters
> of mac80211/rt2x00 show excessive values?
> 
> Have you been running the test with powersaving enabled or disabled?
> 

Yeah, I had the same impression as Ivo, that it should save CPU cycles,
especially since the patch was submitted by Helmut, who is very keen
on saving CPU cycles, as he tests on an embedded (PCI-based) platform as
well.

But, if this proves to not be useful for now, then we should revert the
entire patch, as the patch proposed simply negates the intended behavior
and leaves a mess.

I believe the offending patch was preparation for another patch which so
far has not materialized in a usable form, so there should be no harm in
reverting the offending patch.
 
---
Gertjan
