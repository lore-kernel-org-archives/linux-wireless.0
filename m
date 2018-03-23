Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbeCWNlt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 09:41:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 23 Mar 2018 19:11:48 +0530
From: akolli@codeaurora.org
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Antonio Quartulli <a@unstable.cc>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: Implement get_expected_throughput callback
In-Reply-To: <2667699.TbZPxW0hJB@bentobox>
References: <1521790620-12267-1-git-send-email-akolli@codeaurora.org>
 <2667699.TbZPxW0hJB@bentobox>
Message-ID: <5434de1a4bcdf7341fdeb766e7638760@codeaurora.org> (sfid-20180323_144153_352630_7377CAE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

Thanks for the review.

On 2018-03-23 13:39, Sven Eckelmann wrote:
> On Freitag, 23. März 2018 13:07:00 CET Anilkumar Kolli wrote:
> [...]
>> +static u32 ath10k_get_expected_throughput(struct ieee80211_hw *hw,
>> +                                         struct ieee80211_sta *sta)
>> +{
>> +       struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
>> +       u32 tx_bitrate;
>> +
>> +       tx_bitrate = cfg80211_calculate_bitrate(&arsta->txrate);
>> +       ewma_sta_txrate_add(&arsta->ave_sta_txrate, tx_bitrate);
>> +
>> +       return ewma_sta_txrate_read(&arsta->ave_sta_txrate);
>>  }
> 
> Antonio and Felix, please correct me when this statement is incorrect.
> 
> The expected_throughput as initially implemented for minstrel(_ht) is 
> not
> about the raw physical bitrate but about the throughput which is 
> expected for
> things running on top of the wifi link. See
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cca674d47e59665630f3005291b61bb883015fc5
> for more details
> 
> when I interpret your change correctly then your it doesn't get the
> information about packet loss or aggregation and doesn't do anything 
> convert
> from raw physical rate to something the user could get see. It will 
> just
> overestimate the throughput for ath10k links and thus give wrong 
> information
> to routing algorithms. This could for example cause them to prefer 
> links over
> ath10k based hw when mt76 would actually provide a significant better
> throughput.
> 
> Beside that - why is the ave_sta_txrate only filled when with new 
> information
> when someone requests the current expected_throughput via
> get_expected_throughput. I would have expected that it is filled 
> everytime you
> get new information about the current rate from the firmware
> (ath10k_sta_statistics).
> 
Yes. ideally it should be doing the rate avg. of all the sent packets.

>> @@ -7686,6 +7686,22 @@ static void ath10k_sta_statistics(struct 
>> ieee80211_hw *hw,
>>         }
>>         sinfo->txrate.flags = arsta->txrate.flags;
>>         sinfo->filled |= 1ULL << NL80211_STA_INFO_TX_BITRATE;
>> +
>> +       sinfo->expected_throughput =
>> +                               
>> ewma_sta_txrate_read(&arsta->ave_sta_txrate);
>> +       sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
>> +}
> 
> This brings me directly to the next point. Why are you changing these 
> values
> here? Isn't sta_set_sinfo is expected to do that? This is at least what 
> we
> expect how it works when we call cfg80211_get_station() in batman-adv.
> 

Yes. This looks redundant, I will remove this line,
  sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);

I will make these changes and send v2.

Thanks,
Anil.
