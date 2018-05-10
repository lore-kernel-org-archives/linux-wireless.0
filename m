Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756118AbeEJCqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 22:46:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 09 May 2018 19:46:54 -0700
From: pradeepc@codeaurora.org
To: Sven Eckelmann <sven@narfation.org>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Ben Greear <greearb@candelatech.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: support for multicast rate control
In-Reply-To: <63c78277-183e-b10e-7355-154683375711@candelatech.com>
References: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
 <17746151.BaBsPhhV2q@bentobox>
 <28391873-c8f4-4ca0-7bdd-ef4b2b1eccab@dd-wrt.com>
 <63c78277-183e-b10e-7355-154683375711@candelatech.com>
Message-ID: <aaa5893622e3be98cc32c5472501dc44@codeaurora.org> (sfid-20180510_044659_495011_2DB2C389)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-09 07:31, Ben Greear wrote:
> On 05/08/2018 11:57 PM, Sebastian Gottschall wrote:
>> 
>> 
>> Am 09.05.2018 um 08:15 schrieb Sven Eckelmann:
>>> On Montag, 7. Mai 2018 18:34:51 CEST Pradeep Kumar Chitrapu wrote:
>>>> Issues wmi command to firmwre when multicast rate change is received
>>>> with the new BSS_CHANGED_MCAST_RATE flag.
>>>> Also fixes the incorrect fixed_rate setting for CCK rates which got
>>>> introduced with addition of ath10k_rates_rev2 enum.
>>>> 
>>>> Tested on QCA9984 with firmware ver 10.4-3.6-00104
>>>> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
>>>> ---
>>>> v2:
>>>>   - fixed the CCK rates setting for mcast_rate and fixed_rate paths.
>>>>   - set broadcast rate along with multicast rate setting.
>>> These things are only modified in ath10k_bss_info_changed and not 
>>> saved/
>>> restored. What happens when the HW needs to be reset (there are are 
>>> couple of
>>> firmware crashes which can be seen in the wild and are handled by 
>>> ath10k)? I
>>> would guess that not all of them automatically cause an 
>>> .bss_info_changed.
> 
> Yes, that sounds like a good idea to me.
> 
Hi Sven, Thanks for the review.
In case of HW reset, I see ieee80211_reconfig triggers bss_info changed 
and
BSS_CHANGED_MCAST_RATE is already being set in this function.
(https://patchwork.kernel.org/patch/10302175/). isn't this sufficient 
for the
re-configuring the mcast rate? Please let me know if I am missing 
something.

Thanks
Pradeep

>> i have never seen a card properly recovering after a firmware crash, 
>> all firmware crashes i have seen
>> are caused by bugs in firmware handling or the firmware itself. so if 
>> it recovers it crashes immediatly again
>> ending in a endless crashloop since the cause for the crash hasnt been 
>> fixed. they are often triggered by extern clients for instance which 
>> still remain in the field.
>> i think firmware crashes should not be hidden by recovering. this 
>> would also force users to report problems more frequently, than they 
>> do
>> since they dont even take notice of such problems
> 
> We see recovery work often.  If you see repeatable crashes, post them
> to the list.
> 
> Do you know of any particular external clients that cause these 
> crashes?
> 
> Thanks,
> Ben
