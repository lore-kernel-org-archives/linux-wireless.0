Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:45969 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756404Ab0BOWlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 17:41:09 -0500
Message-ID: <4B79CD81.3090300@free.fr>
Date: Mon, 15 Feb 2010 23:41:05 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 1/2] mac80211: Ignore replay for IBSS interfaces
References: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr> <1266225762.3758.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266225762.3758.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Mon, 2010-02-15 at 00:32 +0100, Benoit Papillault wrote:
>   
>> Using WPA-NONE, the same key is used on multiple stations. As such,
>> with
>> at least 3 nodes, a node will receive frames from the other 2 nodes
>> and
>> frames from one of those nodes will be ignored since they are being
>> detected as replayed.
>>
>> Note: WPA-NONE is not specified in 802.11i. Instead WPA2 should be
>> used,
>> but it is not currently implemented.
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>> ---
>>  net/mac80211/tkip.c |    6 +++++-
>>  net/mac80211/wpa.c  |   10 +++++++---
>>  2 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
>> index 7ef491e..f7e0062 100644
>> --- a/net/mac80211/tkip.c
>> +++ b/net/mac80211/tkip.c
>> @@ -234,6 +234,7 @@ int ieee80211_tkip_decrypt_data(struct
>> crypto_blkcipher *tfm,
>>  	u8 rc4key[16], keyid, *pos = payload;
>>  	int res;
>>  	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
>> +	bool tkip_decrypt_replay = 0;
>>  
>>  	if (payload_len < 12)
>>  		return -1;
>> @@ -271,7 +272,7 @@ int ieee80211_tkip_decrypt_data(struct
>> crypto_blkcipher *tfm,
>>  		       iv32, iv16, key->u.tkip.rx[queue].iv32,
>>  		       key->u.tkip.rx[queue].iv16);
>>  #endif
>> -		return TKIP_DECRYPT_REPLAY;
>> +		tkip_decrypt_replay = 1;
>>  	}
>>  
>>  	if (only_iv) {
>> @@ -338,5 +339,8 @@ int ieee80211_tkip_decrypt_data(struct
>> crypto_blkcipher *tfm,
>>  		*out_iv16 = iv16;
>>  	}
>>  
>> +	if (tkip_decrypt_replay)
>> +		return TKIP_DECRYPT_REPLAY;
>> +
>>  	return res;
>>  }
>> diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
>> index f4971cd..da1186d 100644
>> --- a/net/mac80211/wpa.c
>> +++ b/net/mac80211/wpa.c
>> @@ -242,7 +242,9 @@ ieee80211_crypto_tkip_decrypt(struct
>> ieee80211_rx_data *rx)
>>  					  hdr->addr1, hwaccel, rx->queue,
>>  					  &rx->tkip_iv32,
>>  					  &rx->tkip_iv16);
>> -	if (res != TKIP_DECRYPT_OK || wpa_test)
>> +	if ((res != TKIP_DECRYPT_OK || wpa_test) &&
>> +	    !(res == TKIP_DECRYPT_REPLAY &&
>> +	      rx->sdata->vif.type != NL80211_IFTYPE_ADHOC))
>>  		return RX_DROP_UNUSABLE;
>>     
>
> NACK. This will clearly _break_ any proper RSN implementation. WPA-NONE
> is the non-standard thing here, so requiring that somebody wanting to
> implement proper RSN fix this doesn't seem right to me. And RSN
> shouldn't actually be hard to implement with the events that we have now
> -- it might just be a userspace thing.
>
> johannes
>   
Right. This patch disable replay protection. RSN is indeed the correct 
solution, but it's out of reach for me (no time, no skills). As such, I 
thought that WPA-NONE could be useful in the interim.

Jouni : I would appreciate your input here. What's the status of IBSS 
RSN? How much time/skills would be required to implement it?

Regards,
Benoit


