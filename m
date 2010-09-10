Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54997 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab0IJQxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 12:53:00 -0400
Message-ID: <4C8A6263.5020306@candelatech.com>
Date: Fri, 10 Sep 2010 09:52:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RFC:  Allow multiple STA connected to same AP.
References: <4C8959BC.7040501@candelatech.com> <7fa0decef9a717c1562ee155bba78ce9@localhost> <4C896747.6090905@candelatech.com> <9b3afa510682d20c031f85f20345abd7@localhost> <4C89B98F.3090000@candelatech.com> <848696fe638aa1c29d8420fc9186fee9@localhost>
In-Reply-To: <848696fe638aa1c29d8420fc9186fee9@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2010 09:37 AM, Johannes Berg wrote:
>
> On Thu, 09 Sep 2010 21:52:31 -0700, Ben Greear<greearb@candelatech.com>
> wrote:
>
>> After some more debugging, it seems at least part of the problem is that
>> ath9k uses ieee80211_iterate_active_interfaces_atomic to determine which
>> MACs to add to the BSSID mask.  But, before things are associated
> properly,
>> sdata isn't 'running', so ath9k doesn't calc the mask properly.
>>
>> Looks a bit like chicken-and-egg issue, and for some reason, it doesn't
>> seem to happen with WPA (but then, WPA doesn't authenticate properly
>> either).
>>
>> Maybe a new iterator is needed to get interfaces that want to go active
>> (maybe by determining if sdata->dev is 'UP') ?
>
> Err, that's exactly what the active interfaces iterator does. sdata is
> in fact 'running' as soon as the interface is UP.

Maybe that bssidmask logic runs before sdata is actually brought up
then.  I'll keep poking at things.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

