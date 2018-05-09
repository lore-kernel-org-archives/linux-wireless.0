Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:59938 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933625AbeEIG5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 02:57:15 -0400
Subject: Re: [PATCH v2] ath10k: support for multicast rate control
To: Sven Eckelmann <sven@narfation.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
 <17746151.BaBsPhhV2q@bentobox>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <28391873-c8f4-4ca0-7bdd-ef4b2b1eccab@dd-wrt.com> (sfid-20180509_085719_642910_C1C6A516)
Date: Wed, 9 May 2018 08:57:15 +0200
MIME-Version: 1.0
In-Reply-To: <17746151.BaBsPhhV2q@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 09.05.2018 um 08:15 schrieb Sven Eckelmann:
> On Montag, 7. Mai 2018 18:34:51 CEST Pradeep Kumar Chitrapu wrote:
>> Issues wmi command to firmwre when multicast rate change is received
>> with the new BSS_CHANGED_MCAST_RATE flag.
>> Also fixes the incorrect fixed_rate setting for CCK rates which got
>> introduced with addition of ath10k_rates_rev2 enum.
>>
>> Tested on QCA9984 with firmware ver 10.4-3.6-00104
>>
>> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
>> ---
>> v2:
>>   - fixed the CCK rates setting for mcast_rate and fixed_rate paths.
>>   - set broadcast rate along with multicast rate setting.
> These things are only modified in ath10k_bss_info_changed and not saved/
> restored. What happens when the HW needs to be reset (there are are couple of
> firmware crashes which can be seen in the wild and are handled by ath10k)? I
> would guess that not all of them automatically cause an .bss_info_changed.
>
i have never seen a card properly recovering after a firmware crash, all 
firmware crashes i have seen
are caused by bugs in firmware handling or the firmware itself. so if it 
recovers it crashes immediatly again
ending in a endless crashloop since the cause for the crash hasnt been 
fixed. they are often triggered by extern clients for instance which 
still remain in the field.
i think firmware crashes should not be hidden by recovering. this would 
also force users to report problems more frequently, than they do
since they dont even take notice of such problems

Sebastian

> 	
