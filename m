Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46868 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1ATRw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:52:29 -0500
Message-ID: <4D387658.8040002@candelatech.com>
Date: Thu, 20 Jan 2011 09:52:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Support sw_scan_start_cur
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com> <1295545044.3693.43.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295545044.3693.43.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2011 09:37 AM, Johannes Berg wrote:
> On Thu, 2011-01-20 at 09:32 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This method is called when driver can support
>> scanning the currect active channel without otherwise
>> impeding traffic on that channel.  The mac80211 scan
>> logic may call this when we are only scanning on the
>> active channel and thus do not need to go off channel.
>
> I frankly don't see any point telling the driver about this. Looking at
> the ath9k patch you sent, it seems to avoid some things like flushing --
> but the flushing should be controlled by mac80211 already (or converted
> to be) so that it's not necessary to have this.

mac80211 + ath9k is a house of cards, and this seemed the least
invasive approach.  It also lets us not change behaviour for
the rest of the drivers until they are audited and potentially
updated.  At best I can test/hack on ath5k and ath9k.  These are
touchy enough, and other drivers may be even more twitchy...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

