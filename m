Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55442 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602Ab3DIRgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 13:36:05 -0400
Message-ID: <5164517C.1050304@candelatech.com> (sfid-20130409_193610_127026_8B114EBB)
Date: Tue, 09 Apr 2013 10:35:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211:  Optimize sta lookup for many VIFs
References: <1364572823-28071-1-git-send-email-greearb@candelatech.com>  (sfid-20130329_170033_026763_9F6C74DD) <1365501048.8465.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365501048.8465.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2013 02:50 AM, Johannes Berg wrote:
> On Fri, 2013-03-29 at 09:00 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The sta_info hash is designed to deal with an AP
>> with lots of stations associated, or a station interface
>> connected to a single AP.
>
> Given your other hash patches, does this even make sense still?

This handles the TX side for station VIFs.  The more complicated
hashing handles the rx logic.  I could use the hash
for the tx side, though performance is likely a small bit
worse since you have to deal with the hash logic.

And, if the more complicated RFC hashing patch has no upstream
chance anyway, then if the 'some-sta' patch is acceptable,
I'd still be interested in seeing it upstream.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

