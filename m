Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:35351 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965636AbXDBS3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 14:29:13 -0400
Message-ID: <4611F47F.2060809@linux.intel.com>
Date: Mon, 02 Apr 2007 23:30:23 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com> <1175111599.5151.123.camel@johannes.berg>
In-Reply-To: <1175111599.5151.123.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>>  static ieee80211_txrx_result
>>  ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
>>  {
>> @@ -4373,6 +4510,7 @@ static ieee80211_rx_handler ieee80211_rx
>>  	ieee80211_rx_h_remove_qos_control,
>>  	ieee80211_rx_h_802_1x_pae,
>>  	ieee80211_rx_h_drop_unencrypted,
>> +	ieee80211_rx_h_data_agg,
>>  	ieee80211_rx_h_data,
>>  	ieee80211_rx_h_mgmt,
>>  	NULL
>> diff -Nupr wireless-dev/net/mac80211/wme.h
>> wireless-dev-new/net/mac80211/wme.h
>> --- wireless-dev/net/mac80211/wme.h	2007-03-22 11:40:17.000000000 -0700
>> +++ wireless-dev-new/net/mac80211/wme.h	2007-03-27 01:48:34.000000000
>> -0700
>> @@ -24,6 +24,8 @@
>>  
>>  #define QOS_CONTROL_TAG1D_MASK 0x07
>>  
>> +#define QOS_CONTROL_A_MSDU_PRESENT 0x80

I am calling ieee80211_rx_h_data_agg after ieee80211_rx_h_remove_qos_control which
clears all QoS data which include QOS_CONTROL_A_MSDU_PRESENT bit. We can solve this by
adding new field is_frame_agg to ieee80211_txrx_data.u.rx.is_frame_agg which will be set in
ieee80211_rx_h_parse_qos or we can add new function to ieee80211_rx_pre_handlers just to do that. the other 
option is to shuffle calling sequence here if that possible to call ieee80211_rx_h_data_agg
before ieee80211_rx_h_remove_qos_control. any opinion?
Mohamed
 
