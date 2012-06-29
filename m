Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59959 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401Ab2F2M51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 08:57:27 -0400
Message-ID: <4FEDA625.8060005@net.t-labs.tu-berlin.de> (sfid-20120629_145732_116778_514C37FE)
Date: Fri, 29 Jun 2012 05:57:09 -0700
From: thomas <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com, linville@tuxdriver.com
Subject: Re: [PATCH] brcmsmac: restructure info->control.sta handling as it
 is goning to be removed soon.
References: <1340943304-70933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120629_061650_559847_B79CE9A9) <1340952528.4488.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340952528.4488.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg schrieb:

> On Thu, 2012-06-28 at 21:15 -0700, Thomas Huehn wrote:
>> @@ -267,7 +267,9 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>>  static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>  {
>>  	struct brcms_info *wl = hw->priv;
>> +	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>>  
>> +	tx_info->rate_driver_data[0] = tx_info->control.sta;
> 
> It seems that brcmsmac doesn't care about anything but the
> tx_info->flags, but it would still seem safer to overwrite the data
> before the function returns, rather than as the first thing?
> 

I will send a version 2.
Thx Johannes for the suggestion.

Thomas
