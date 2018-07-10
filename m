Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933169AbeGJMjm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 08:39:42 -0400
Subject: Re: mac80211: AQM and block_tx
To: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc: simon.wunderlich@openmesh.com,
        Daniel Bailey <daniel.bailey@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        linux-wireless@vger.kernel.org
References: <2846230.fHgAC8qB8Q@bentobox> <4554238.GrJkgPgAWi@bentobox>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <51cebb7e-52cf-0421-a4c9-cad7a6f30035@codeaurora.org> (sfid-20180710_143958_215338_79CF9C00)
Date: Tue, 10 Jul 2018 18:09:37 +0530
MIME-Version: 1.0
In-Reply-To: <4554238.GrJkgPgAWi@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 7/10/2018 12:25 PM, Sven Eckelmann wrote:
> On Donnerstag, 5. Juli 2018 10:47:11 CEST Sven Eckelmann wrote:
>> Hi Toke,
>>
>> we are currently testing DFS with ath10k and noticed that AQM seems to ignore
>> cfg80211_csa_settings->block_tx. Problem is now that the channel switch is
>> started on a detected radar
>>
>>    echo 1 >/sys/kernel/debug/ieee80211/phy1/ath10k/dfs_simulate_radar
>>
>> NL80211_ATTR_CH_SWITCH_BLOCK_TX is set for the channel switch by hostapd but
>> the AP still sends QoS data to the client.
>>
>> Was there a fix for such a problem which I might have missed? I've just worked
>> around that by setting wake_tx_queue TO NULL in ath10k. This still must be
>> verified but at least I didn't see any packets anymore on a monitor interface.
>
> Just as information, the ath10k Dakota devices went through DFS certification
> but the AQM had to be disabled. Otherwise we would have had problems with the
> FCC closing time.

I am working on a patch which takes care of stopping the iTXQs after 
detecting a radar(covering other scenarios where stopping iTXQs is 
important)
and there by making sure packets are not transmitted.

The patch is still under discussion but it's worth trying the patch 
given below and see if it fixes the DFS channel closing time issue; you 
need not disable AQM while trying this patch.
https://patchwork.kernel.org/patch/10516887/

-Manikanta
