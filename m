Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbeCWOJB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 10:09:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 23 Mar 2018 19:38:59 +0530
From: akolli@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Antonio Quartulli <a@unstable.cc>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: Implement get_expected_throughput callback
In-Reply-To: <1521812659.28252.0.camel@sipsolutions.net>
References: <1521790620-12267-1-git-send-email-akolli@codeaurora.org>
 <2667699.TbZPxW0hJB@bentobox>
 <5434de1a4bcdf7341fdeb766e7638760@codeaurora.org>
 (sfid-20180323_144153_352630_7377CAE0)
 <1521812659.28252.0.camel@sipsolutions.net>
Message-ID: <13b463416aedef1cee5641a8f89f9705@codeaurora.org> (sfid-20180323_150906_642910_BB688B53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2018-03-23 19:14, Johannes Berg wrote:
> On Fri, 2018-03-23 at 19:11 +0530, akolli@codeaurora.org wrote:
>> 
>> > > +
>> > > +       sinfo->expected_throughput =
>> > > +
>> > > ewma_sta_txrate_read(&arsta->ave_sta_txrate);
>> > > +       sinfo->filled |=
>> > > BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
>> > > +}
> 
>> Yes. This looks redundant, I will remove this line,
>>   sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
> 
> You don't need any of the changes here in ath10k_sta_statistics().

Hi Jaohannes,

Yes. I removed this in ath10k driver and sent a v2 patch.

Thanks,
Anil.
