Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46963 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3EIRkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 13:40:14 -0400
Message-ID: <518BDF70.3040407@candelatech.com> (sfid-20130509_194018_726804_82BD924B)
Date: Thu, 09 May 2013 10:40:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Disable spectral scan code to fix crash on rmmod.
References: <1368050908-7554-1-git-send-email-greearb@candelatech.com> <20875.13834.615920.337442@gargle.gargle.HOWL>
In-Reply-To: <20875.13834.615920.337442@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2013 10:37 PM, Sujith Manoharan wrote:
> greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> With CONFIG_ATH9K_DEBUGFS enabled, and slub memory poisoning
>> enabled, I see this crash on rmmod of ath9k.  I'm not sure how
>> to fix this properly, but in the meantime, this patch to disable
>> the spectral scan code works around the problem for me.
>>
>> With memory poisoning and the verify_mem_not_deleted code
>> below added, the crash looks as follows...  The dentry
>> is not *always* freed at this point, probably because rcu
>> callbacks haven't completed.  You still get a crash soon
>> after, however.
>
> The relay file should probably be closed before calling ieee80211_unregister_hw().
> The ath9k debugfs directory is created inside the phy#/ directory and that would
> get cleaned up when the wiphy is unregistered.
>
> Does this help ?

This fixes the problem for me, and certainly is less of a hack than
what I posted.

I did several module unloads with memory poisoning enabled, system
remains stable.

Tested-by: Ben Greear <greearb@candelatech.com>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

