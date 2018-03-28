Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeC1GLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 02:11:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 28 Mar 2018 11:41:51 +0530
From: akolli@codeaurora.org
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Antonio Quartulli <a@unstable.cc>,
        Felix Fietkau <nbd@nbd.name>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Implement get_expected_throughput callback
In-Reply-To: <2322769.sx4MhzsvNg@bentobox>
References: <1521814034-17880-1-git-send-email-akolli@codeaurora.org>
 <2322769.sx4MhzsvNg@bentobox>
Message-ID: <7428dc3685e146dca147805b6a1bc5d2@codeaurora.org> (sfid-20180328_081155_529481_1D307AB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-26 12:52, Sven Eckelmann wrote:
> On Freitag, 23. März 2018 19:37:14 CEST Anilkumar Kolli wrote:
>> +static u32 ath10k_get_expected_throughput(struct ieee80211_hw *hw,
>> +                                         struct ieee80211_sta *sta)
>> +{
>> +       struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
>> +
>> +       return ewma_sta_txrate_read(&arsta->ave_sta_txrate);
>> +}
> 
> On Freitag, 23. März 2018 19:11:48 CEST akolli@codeaurora.org wrote:
>> > Antonio and Felix, please correct me when this statement is incorrect.
>> >
>> > The expected_throughput as initially implemented for minstrel(_ht) is
>> > not
>> > about the raw physical bitrate but about the throughput which is
>> > expected for
>> > things running on top of the wifi link. See
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cca674d47e59665630f3005291b61bb883015fc5
>> > for more details
>> >
>> > when I interpret your change correctly then your it doesn't get the
>> > information about packet loss or aggregation and doesn't do anything
>> > convert
>> > from raw physical rate to something the user could get see. It will
>> > just
>> > overestimate the throughput for ath10k links and thus give wrong
>> > information
>> > to routing algorithms. This could for example cause them to prefer
>> > links over
>> > ath10k based hw when mt76 would actually provide a significant better
>> > throughput.
>> >
>> > Beside that - why is the ave_sta_txrate only filled when with new
>> > information
>> > when someone requests the current expected_throughput via
>> > get_expected_throughput. I would have expected that it is filled
>> > everytime you
>> > get new information about the current rate from the firmware
>> > (ath10k_sta_statistics).
>> >
>> Yes. ideally it should be doing the rate avg. of all the sent packets.
> 
> No, not the PHY rate average - but the "throughput avg". And the 
> "ideally"
> here sounds a little bit like in "Our medical doctor would ideally not
> decapitate each patient but we have at least an MD".
> 

The rate average and throughput are relative. no?

- Anil.
