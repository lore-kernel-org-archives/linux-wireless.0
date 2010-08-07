Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59368 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab0HGKpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 06:45:08 -0400
Message-ID: <4C5D3929.1060708@bu3sch.de>
Date: Sat, 07 Aug 2010 12:44:57 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: stable@kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [stable] ssb: 2.6.34.1 -> 2.6.34.2 regression
References: <4C5C9252.7040007@bu3sch.de> <20100806235631.GA21827@kroah.com> (sfid-20100807_015640_159647_FFFFFFFFF3BB5C8C)
In-Reply-To: <20100806235631.GA21827@kroah.com> (sfid-20100807_015640_159647_FFFFFFFFF3BB5C8C)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/07/2010 01:56 AM, Greg KH wrote:
> On Sat, Aug 07, 2010 at 12:53:06AM +0200, Michael Büsch wrote:
>> Hi,
>>
>> The SPROM changes applied to SSB in 2.6.34.2 completely broke SPROM
>> extraction. This leads to broken wireless for my BCM4306 card.
>> All other BCM43xx and BCM44xx most likely are affected, too.
>> Symptoms should be wrong MAC addresses and broken transmission (for 43xx).
>>
>> The patch changed the SPEX() macro and removed the offset subtraction,
>> but did not remove the actual 0x1000 offset from the SPROM defines.
>> This results in random memory poking rather than proper SPROM data
>> extraction.
>>
>> I applied the following to my kernel to get it working again. However
>> this is not a proper fix. I suggest that the -stable SSB patch
>> is dropped and mainline patches being applied. They seem to
>> be correct (However I did not test mainline, yet).
>
> That's already done, can you please test the 2.6.34.3-rc1 kernel that
> was announced a few hours ago?  I should have fixed all of the issues
> there, if not, please let me know.

That one works. Thanks.

-- 
Greetings Michael.
