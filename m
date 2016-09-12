Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754664AbcILR5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 13:57:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 12 Sep 2016 23:27:08 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: allow driver to handle packet-loss mechanism
In-Reply-To: <1473684288.29016.38.camel@sipsolutions.net>
References: <20160906065624.4062-1-rmanohar@qti.qualcomm.com>
 <1473684288.29016.38.camel@sipsolutions.net>
Message-ID: <e968a9083a9f5fd7e9c04d563288b229@codeaurora.org> (sfid-20160912_195714_835229_9C986B34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-12 18:14, Johannes Berg wrote:
> On Tue, 2016-09-06 at 12:26 +0530, Rajkumar Manoharan wrote:
>> mac80211 keeps track of missing acks and triggers CQM packet-loss
>> mechanism whenever consecutive msdu failure reaches threshold limit
>> (STA_LOST_PKT_THRESHOLD). Drivers like ath10k offlaoded rate countrol
>> and aggregation to firmware. Such drivers have its own connection
>> monitoring algorithm that is offloaded to firmware for triggering
>> station kickout due to excessive tries. In VHT mode, single PPDU can
>> have
>> more than 50 msdus at higher rates. Under noisy environment, single
>> ppdu
>> failure can cause station kickout by current mac80211 lost_packet
>> mechanism
>> while firmware is trying to adapt its rate table. This is causing
>> frequent
>> connect and disconnect iteration when station is roaming around.
>> 
>> In such scenario, driver (or firmware) is not given enough chance to
>> tune its rate control. So for devices that report low ack events, add
>> a
>> hardware flag to rely on their mechnism.
>> 
> 
> The way you describe this it sounds like somehow you'll be reporting
> the indication to userspace from the driver; but you do not, and cannot
> do that. The description seems thus misleading?
> 
Sorry for confusion.. The idea is that driver will report low ack status 
by ieee80211_report_low_ack and if driver wants to completely rely on 
firmware algorithm, then this flag will be used to bypass mac80211 
packet loss mechanism. does it make sense?

-Rajkumar
