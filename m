Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40999 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab2GIWLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 18:11:24 -0400
Message-ID: <4FFB5709.6070403@net.t-labs.tu-berlin.de> (sfid-20120710_001127_864431_5F9E5ECA)
Date: Tue, 10 Jul 2012 00:11:21 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	linville@tuxdriver.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling as
 it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <4FFAE252.4070504@broadcom.com>
In-Reply-To: <4FFAE252.4070504@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>> index 01b190a..d341c91 100644
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>>  			u8 plcp0, plcp3, is40, sgi;
>>  			struct ieee80211_sta *sta;
>>  
>> -			sta = tx_info->control.sta;
>> +			sta = tx_info->rate_driver_data[0];
> 
> The sta pointer is not used in this function so this assignment is not
> needed. Also the rate_driver_data[0] does not yet hold the sta pointer
> upon reaching this function. brcms_c_sendampdu is called from
> brcms_c_sendpkt_mac80211 (see below).
> 
> Just remove the sta pointer here.


Good catch ! v2 is already sent.

> 
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> index 2d5a404..f3ab8a6 100644
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> @@ -267,6 +267,7 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>>  static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>  {
>>  	struct brcms_info *wl = hw->priv;
>> +	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>>  
>>  	spin_lock_bh(&wl->lock);
>>  	if (!wl->pub->up) {
>> @@ -275,6 +276,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>  		goto done;
>>  	}
>>  	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
>> +	tx_info->rate_driver_data[0] = tx_info->control.sta;
>>   done:
>>  	spin_unlock_bh(&wl->lock);
>>  }
> 
> Gr. AvS
> 


Greetings Thomas
