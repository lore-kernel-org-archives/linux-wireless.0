Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:58086 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321Ab1KCSBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 14:01:10 -0400
Message-ID: <4EB2D6DE.3050207@neratec.com> (sfid-20111103_190115_128429_C605867D)
Date: Thu, 03 Nov 2011 19:01:02 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> <4EB2AF36.9070608@openwrt.org>
In-Reply-To: <4EB2AF36.9070608@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 04:11 PM, Felix Fietkau wrote:
> On 2011-11-03 2:55 PM, Zefir Kurtisi wrote:
>> This patch integrates the DFS module into ath9k, including
>>   * building the module into ath9k_hw
>>   * setting up DFS debugfs
>>   * defining HW capability flag for DFS support
>>   * setting this flag by DFS supporting devices
>>     (so far: AR_SREV_9280_20_OR_LATER, TBC)
>>   * setting PHYRADAR rx filter flag to enable radar
>>     pulse reporting
>>   * forward radar PHY errors to dfs module
>>
>> This is WIP and at its current stage is limited to test ath9k
>> pulse detection capabilities. The DFS pattern matching is
>> TBD in the higher layers and is not part of this patch.
>>
>> CONFIG_ATH9K_DFS must be set to enable pulse detection.
>>
>> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/Makefile |    2 ++
>>   drivers/net/wireless/ath/ath9k/debug.c  |    3 +++
>>   drivers/net/wireless/ath/ath9k/debug.h  |    2 ++
>>   drivers/net/wireless/ath/ath9k/hw.c     |   12 ++++++++++++
>>   drivers/net/wireless/ath/ath9k/hw.h     |    1 +
>>   drivers/net/wireless/ath/ath9k/main.c   |   17 +++++++++++++++++
>>   drivers/net/wireless/ath/ath9k/recv.c   |   18 +++++++++++++-----
>>   7 files changed, 50 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index d3b92ce..4d70aab 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -305,6 +305,23 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
>>           ath9k_hw_antdiv_comb_conf_set(ah,&div_ant_conf);
>>       }
>>
>> +    if (ah->caps.hw_caps&&  ATH9K_HW_CAP_DFS) {
>> +        /**
>> +         * enable radar pulse detection
>> +         *
>> +         * TODO: do this only for DFS channels
>> +         */
>> +        ah->private_ops.set_radar_params(ah,&ah->radar_conf);
>> +        ath9k_hw_setrxfilter(ah,
>> +            ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
>> +        ath_dbg(common, ATH_DBG_DFS,
>> +            "DFS radar detection enabled for channel %d\n",
>> +            ah->curchan->channel);
>> +    } else {
>> +        ath9k_hw_setrxfilter(ah,
>> +            ath9k_hw_getrxfilter(ah)&  ~ATH9K_RX_FILTER_PHYRADAR);
>> +    }
>> +
> Please drop this chunk of code and move the check to ath_calcrxfilter, which gets called after every reset anyway. Also, use a separate flag in sc->flags for actually enabling DFS. Even if the chip has DFS support, we don't always want to enable it - especially not on 2.4 GHz or indoor 5 GHz channels.
> 
> - Felix
> 
Hi Felix,

while I was waiting for your feedback on my related patch, I assumed you're okay with having those rx filter flags preserved in ath_calcrxfilter.

I'll check your proposal for v3.

BTW, as the comment says, it is TODO enable radar detection only for DFS channels. Beside the lack of the management module to provide the relevant information, it comes handy to test pulse detection on non-DFS channels without the need to modify hostapd ;)



Thanks,
Zefir
