Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57792 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933887AbeEIOcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 10:32:08 -0400
Subject: Re: [PATCH v2] ath10k: support for multicast rate control
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Sven Eckelmann <sven@narfation.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
References: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
 <17746151.BaBsPhhV2q@bentobox>
 <28391873-c8f4-4ca0-7bdd-ef4b2b1eccab@dd-wrt.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <63c78277-183e-b10e-7355-154683375711@candelatech.com> (sfid-20180509_163211_956081_F92886A0)
Date: Wed, 9 May 2018 07:31:57 -0700
MIME-Version: 1.0
In-Reply-To: <28391873-c8f4-4ca0-7bdd-ef4b2b1eccab@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/08/2018 11:57 PM, Sebastian Gottschall wrote:
>
>
> Am 09.05.2018 um 08:15 schrieb Sven Eckelmann:
>> On Montag, 7. Mai 2018 18:34:51 CEST Pradeep Kumar Chitrapu wrote:
>>> Issues wmi command to firmwre when multicast rate change is received
>>> with the new BSS_CHANGED_MCAST_RATE flag.
>>> Also fixes the incorrect fixed_rate setting for CCK rates which got
>>> introduced with addition of ath10k_rates_rev2 enum.
>>>
>>> Tested on QCA9984 with firmware ver 10.4-3.6-00104
>>> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
>>> ---
>>> v2:
>>>   - fixed the CCK rates setting for mcast_rate and fixed_rate paths.
>>>   - set broadcast rate along with multicast rate setting.
>> These things are only modified in ath10k_bss_info_changed and not saved/
>> restored. What happens when the HW needs to be reset (there are are couple of
>> firmware crashes which can be seen in the wild and are handled by ath10k)? I
>> would guess that not all of them automatically cause an .bss_info_changed.

Yes, that sounds like a good idea to me.

> i have never seen a card properly recovering after a firmware crash, all firmware crashes i have seen
> are caused by bugs in firmware handling or the firmware itself. so if it recovers it crashes immediatly again
> ending in a endless crashloop since the cause for the crash hasnt been fixed. they are often triggered by extern clients for instance which still remain in the field.
> i think firmware crashes should not be hidden by recovering. this would also force users to report problems more frequently, than they do
> since they dont even take notice of such problems

We see recovery work often.  If you see repeatable crashes, post them
to the list.

Do you know of any particular external clients that cause these crashes?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
