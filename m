Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933604AbeFRJS1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 05:18:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 18 Jun 2018 14:48:26 +0530
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cfg80211: last ack signal support in station dump
In-Reply-To: <1529062873.10037.9.camel@sipsolutions.net>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
 <1528121469-16450-2-git-send-email-bpothuno@codeaurora.org>
 <1529062873.10037.9.camel@sipsolutions.net>
Message-ID: <72bc5a1b5136eb30baba715f891961f1@codeaurora.org> (sfid-20180618_111849_054407_36990416)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-15 17:11, Johannes Berg wrote:
> On Mon, 2018-06-04 at 19:41 +0530, Balaji Pothunoori wrote:
>> 
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -3000,8 +3000,8 @@ enum nl80211_sta_bss_param {
>>   *	received from the station (u64, usec)
>>   * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit 
>> alignment
>>   * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK 
>> frame(u8, dBm)
>> - * @NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG: avg signal strength of 
>> (data)
>> - *	ACK frame (s8, dBm)
>> + * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of data or 
>> management
>> + *	ACK frames(s8, dBm)
>>   * @__NL80211_STA_INFO_AFTER_LAST: internal
>>   * @NL80211_STA_INFO_MAX: highest possible station info attribute
>>   */
>> @@ -3041,7 +3041,7 @@ enum nl80211_sta_info {
>>  	NL80211_STA_INFO_RX_DURATION,
>>  	NL80211_STA_INFO_PAD,
>>  	NL80211_STA_INFO_ACK_SIGNAL,
>> -	NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG,
>> +	NL80211_STA_INFO_ACK_SIGNAL_AVG,
> 
> Wait, what happened here? You can't remove old API.

Here is my intention is to make the unique average ack signal and last 
ack signal
support in station dump irrespective of data or management tx ack 
packet.
Do you want me to add a new API for management tx ack packet?

> 
>> @@ -5128,9 +5128,9 @@ enum nl80211_feature_flags {
>>   *	"radar detected" event.
>>   * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports 
>> sending and
>>   *	receiving control port frames over nl80211 instead of the 
>> netdevice.
>> - * @NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT: This Driver support 
>> data ack
>> - *	rssi if firmware support, this flag is to intimate about ack rssi
>> - *	support to nl80211.
>> + * @NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT: This Driver support ack 
>> rssi if
>> + *	firmware support, this flag is to intimate about ack rssi support
>> + *	to nl80211.
> 
> Same here, why are you removing the data-ack-signal API?
> 
> Is that just a rebase error or something?
> 
> Or is it intentional, but then please explain what you're trying to do
> and I can help find a correct solutions.
> 
> johannes

Here i renamed above API because in driver i will fill this 
"NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT"
if firmware supports either of the one "WMI_SERVICE_TX_DATA_ACK_RSSI" or 
"WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS".
This is to make unique avg ack signal/last ack signal support.

Regards,
Balaji.
