Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43420 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3DOOYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 10:24:12 -0400
Message-ID: <516C0D80.8000506@openwrt.org> (sfid-20130415_162420_160862_396AF48C)
Date: Mon, 15 Apr 2013 16:24:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] mac80211: fix CTS protection handling
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org>  <1365890626-86895-2-git-send-email-nbd@openwrt.org> <1366033231.8361.24.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366033231.8361.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-15 3:40 PM, Johannes Berg wrote:
> On Sun, 2013-04-14 at 00:03 +0200, Felix Fietkau wrote:
> 
>> @@ -655,7 +655,9 @@ struct ieee80211_tx_info {
>>  					struct ieee80211_tx_rate rates[
>>  						IEEE80211_TX_MAX_RATES];
>>  					s8 rts_cts_rate_idx;
>> -					/* 3 bytes free */
>> +					u8 use_rts:1;
>> +					u8 use_cts_prot:1;
> 
> hmm, why here?
> 
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -656,6 +656,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>>  		txrc.rts = rts = true;
>>  	}
>>  
>> +	info->control.use_rts = rts;
> 
> evidently, txrc already has an "rts" field?
I need access to that field after txrc is already gone (when the driver
calls ieee80211_get_tx_rates).

- Felix

