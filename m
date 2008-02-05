Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60126 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761094AbYBEWTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 17:19:32 -0500
Message-ID: <47A8E0CD.5080202@openwrt.org> (sfid-20080205_221947_158915_12BE4203)
Date: Tue, 05 Feb 2008 23:18:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
References: <12022263282085-git-send-email-tomas.winkler@intel.com> <1ba2fa240802051140j6497593cq3776c77b75ee32be@mail.gmail.com>
In-Reply-To: <1ba2fa240802051140j6497593cq3776c77b75ee32be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Feb 5, 2008 5:45 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
>> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>>
>> This patch introduces data structures meant to contain actual
>> configuration in which Tx was made in HW, for general purposes
>> and for rate scaling in specific.
>> it includes the rate, general flags for the rate (e.g. Tx antenna)
>> and the number of retries for the rate.
>>
>> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  include/net/mac80211.h |   22 +++++++++++++++++++++-
>>  1 files changed, 21 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 460da54..ec966c8 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -318,6 +318,22 @@ struct ieee80211_rx_status {
>>  };
>>
>>  /**
>> + * struct ieee80211_tx_rate_ctrl - rate ctrl data
>> + *
>> + * The low-level driver should provide this struct as part
>> + * of the ieee80211_tx_status. this struct should give information
>> + * about the tx that is not part of the plcp rates table.
>> + * @bitrate: rate used.
>> + * @flags: Tx information (e.g. antenna selectd, guard interval, etc.)
>> + * @retry_count: number of retries for this specific rate
>> + */
>> +struct ieee80211_tx_rate_ctrl {
>> +       u32 bitrate;
>> +       u32 flags;
>> +       u8 retry_count;
>> +};
>> +
>> +/**
>>   * enum ieee80211_tx_status_flags - transmit status flags
>>   *
>>   * Status flags to indicate various transmit conditions.
>> @@ -343,7 +359,7 @@ enum ieee80211_tx_status_flags {
>>   * @control: a copy of the &struct ieee80211_tx_control passed to the driver
>>   *     in the tx() callback.
>>   * @flags: transmit status flags, defined above
>> - * @retry_count: number of retries
>> + * @retry_count: total number of retries
>>   * @excessive_retries: set to 1 if the frame was retried many times
>>   *     but not acknowledged
>>   * @ampdu_ack_len: number of aggregated frames.
>> @@ -353,6 +369,8 @@ enum ieee80211_tx_status_flags {
>>   * @ack_signal: signal strength of the ACK frame
>>   * @queue_length: ?? REMOVE
>>   * @queue_number: ?? REMOVE
>> + * @rate_ctrl_num: number of rate_ctrl allocated
>> + * @rate_ctrl: info for rate at which the packet was actually transmitted
>>   */
>>  struct ieee80211_tx_status {
>>         struct ieee80211_tx_control control;
>> @@ -364,6 +382,8 @@ struct ieee80211_tx_status {
>>         int ack_signal;
>>         int queue_length;
>>         int queue_number;
>> +       size_t rate_ctrl_num;
>> +       struct ieee80211_tx_rate_ctrl rate_ctrl[0];
>>  };
>>
>>  /**
>> --
>> 1.5.2.2
> 
> 
> Felix will this work for you?
Yes, looks good.

- Felix
