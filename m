Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35451 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752652AbeGJMKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 08:10:01 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: simon.wunderlich@openmesh.com,
        Daniel Bailey <daniel.bailey@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mac80211: AQM and block_tx
In-Reply-To: <4554238.GrJkgPgAWi@bentobox>
References: <2846230.fHgAC8qB8Q@bentobox> <4554238.GrJkgPgAWi@bentobox>
Date: Tue, 10 Jul 2018 14:09:57 +0200
Message-ID: <87wou3cmwa.fsf@toke.dk> (sfid-20180710_141004_938289_99B3074E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> On Donnerstag, 5. Juli 2018 10:47:11 CEST Sven Eckelmann wrote:
>> Hi Toke,
>> 
>> we are currently testing DFS with ath10k and noticed that AQM seems to ignore 
>> cfg80211_csa_settings->block_tx. Problem is now that the channel switch is 
>> started on a detected radar
>> 
>>   echo 1 >/sys/kernel/debug/ieee80211/phy1/ath10k/dfs_simulate_radar
>> 
>> NL80211_ATTR_CH_SWITCH_BLOCK_TX is set for the channel switch by hostapd but 
>> the AP still sends QoS data to the client.
>> 
>> Was there a fix for such a problem which I might have missed? I've just worked 
>> around that by setting wake_tx_queue TO NULL in ath10k. This still must be 
>> verified but at least I didn't see any packets anymore on a monitor interface.
>
>
> Just as information, the ath10k Dakota devices went through DFS
> certification

Cool! (I think? Not quite sure what the implications of passing / not
passing certification are?)

> but the AQM had to be disabled. Otherwise we would have had problems
> with the FCC closing time.

Hmm, too bad; but I guess this can be fixed :)

-Toke
