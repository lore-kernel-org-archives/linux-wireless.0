Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53568 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0IJWtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:49:49 -0400
Message-ID: <4C8AB60A.2060409@candelatech.com>
Date: Fri, 10 Sep 2010 15:49:46 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [virtual-sta 3/3] mac80211:  Allow multiple STA on same BSS.
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com> <1284156298-15863-3-git-send-email-greearb@candelatech.com> <4C8AB4BD.5090204@openwrt.org>
In-Reply-To: <4C8AB4BD.5090204@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2010 03:44 PM, Felix Fietkau wrote:
> On 2010-09-10 3:04 PM, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> When adding an STA, the old code checked if there was already
>> an STA with the same BSS.  Instead, check to see if there is
>> exactly the same STA in order to allow multiple STA to be
>> associated with the same AP.
> I think that's misleading. sta_info_get_bss does not check if there is a
> STA with the same BSS. Like sta_info_get it looks for a STA with the
> given address, but unlike sta_info_get, it also accepts it if it's on a
> different interface than the provided sdata, but part of the same BSS as
> the sdata's.
> Because of that, this change seems bogus to me.

W/out this change, I cannot get a second STA to associate with
the AP because that code returns EBUSY, because the
first STA and second STA point to the same bss.

There could be a better way to do what I'm trying to do,
but that one-line patch made it work for me.  I'll be happy
to try alternative suggestions.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

