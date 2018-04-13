Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0068.outbound.protection.outlook.com ([104.47.2.68]:54616
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750989AbeDMUYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 16:24:45 -0400
Subject: Re: [PATCH v2] ath10k: Implement get_expected_throughput callback
To: Kalle Valo <kvalo@codeaurora.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
References: <1521814034-17880-1-git-send-email-akolli@codeaurora.org>
 <2322769.sx4MhzsvNg@bentobox>
 <7428dc3685e146dca147805b6a1bc5d2@codeaurora.org>
 <1580002.5HauTVtcdp@bentobox> <87lgdrqkst.fsf@kamboji.qca.qualcomm.com>
Cc: akolli@codeaurora.org, Marek Lindner <mareklindner@neomailbox.ch>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        ath10k@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <f028b45d-8a2d-97f6-5eb9-fdb071a51e4d@bowerswilkins.com> (sfid-20180413_222512_037704_101B3FBD)
Date: Fri, 13 Apr 2018 13:24:30 -0700
MIME-Version: 1.0
In-Reply-To: <87lgdrqkst.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/13/2018 06:48 AM, Kalle Valo wrote:
> Sven Eckelmann <sven.eckelmann@openmesh.com> writes:
>
>> But of course, I cannot say much about how the rate control from QCA works and
>> in which form these information are already available.
>>
>> If you want to know the average PHY rate then wouldn't it be better to report
>> the rates to one of the upper layers and let them to the averaging? Similar to
>> what there already is for NL80211_STA_INFO_CHAIN_SIGNAL
>> (NL80211_STA_INFO_CHAIN_SIGNAL_AVG) just for NL80211_STA_INFO_TX_BITRATE/
>> NL80211_STA_INFO_RX_BITRATE. Not sure whether this makes sense or whether
>> someone has an use-case for it.
> Sounds like a good idea, but I don't see it preventing to apply this
> patch. We can always change the implementation later as this is just
> communication between ath10k and mac80211, right?
>
I agree with Sven on the usage or expectation of get_expected_throughput 
cabllback.
It's not really ab expected throughput implementation.
However I'm with Kalle about approving this patch as Sven also mentioned 
"here sounds a little bit like in "Our medical doctor would ideally not 
decapitate each patient but we have at least an MD"".
I could improve it once merged since there are more members in 
ath10k_per_peer_tx_stats useful such as succ_bytes, failed_bytes, 
duration, and etc.
