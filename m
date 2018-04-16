Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51872 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbeDPGae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 02:30:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 16 Apr 2018 12:00:32 +0530
From: akolli@codeaurora.org
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        ath10k@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Implement get_expected_throughput callback
In-Reply-To: <f028b45d-8a2d-97f6-5eb9-fdb071a51e4d@bowerswilkins.com>
References: <1521814034-17880-1-git-send-email-akolli@codeaurora.org>
 <2322769.sx4MhzsvNg@bentobox>
 <7428dc3685e146dca147805b6a1bc5d2@codeaurora.org>
 <1580002.5HauTVtcdp@bentobox> <87lgdrqkst.fsf@kamboji.qca.qualcomm.com>
 <f028b45d-8a2d-97f6-5eb9-fdb071a51e4d@bowerswilkins.com>
Message-ID: <a42e9e3f2988c21d2b60af3d99489b62@codeaurora.org> (sfid-20180416_083038_143114_054385C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-14 01:54, Peter Oh wrote:
> On 04/13/2018 06:48 AM, Kalle Valo wrote:
>> Sven Eckelmann <sven.eckelmann@openmesh.com> writes:
>> 
>>> But of course, I cannot say much about how the rate control from QCA 
>>> works and
>>> in which form these information are already available.
>>> 
>>> If you want to know the average PHY rate then wouldn't it be better 
>>> to report
>>> the rates to one of the upper layers and let them to the averaging? 
>>> Similar to
>>> what there already is for NL80211_STA_INFO_CHAIN_SIGNAL
>>> (NL80211_STA_INFO_CHAIN_SIGNAL_AVG) just for 
>>> NL80211_STA_INFO_TX_BITRATE/
>>> NL80211_STA_INFO_RX_BITRATE. Not sure whether this makes sense or 
>>> whether
>>> someone has an use-case for it.
>> Sounds like a good idea, but I don't see it preventing to apply this
>> patch. We can always change the implementation later as this is just
>> communication between ath10k and mac80211, right?
>> 
> I agree with Sven on the usage or expectation of
> get_expected_throughput cabllback.
> It's not really ab expected throughput implementation.
> However I'm with Kalle about approving this patch as Sven also
> mentioned "here sounds a little bit like in "Our medical doctor would
> ideally not decapitate each patient but we have at least an MD"".
> I could improve it once merged since there are more members in
> ath10k_per_peer_tx_stats useful such as succ_bytes, failed_bytes,
> duration, and etc.

On each packet sent successfully, driver has the success_bytes details.
Throughput calculation can be done using these bytes and tx rate 
(tx_rate * bytes),
send this average value to mac80211. is this you are thinking of?

Thanks,
Anil.
