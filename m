Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:55322 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750Ab2GXUHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 16:07:41 -0400
Message-ID: <500F0088.6070408@net.t-labs.tu-berlin.de> (sfid-20120724_220744_194466_38810A86)
Date: Tue, 24 Jul 2012 22:07:36 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: coelho@ti.com, brcm80211-dev-list@broadcom.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	ilw@linux.intel.com, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, chunkeey@googlemail.com,
	dsd@gentoo.org, buytenh@wantstofly.org
Subject: Re: [ath5k-devel] [PATCH v4] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
References: <1343072022-1383-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120723_213356_862232_300A4FC5) <1343141251.4415.39.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343141251.4415.39.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg schrieb:

> On Mon, 2012-07-23 at 21:33 +0200, Thomas Huehn wrote:
> 
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -196,6 +196,8 @@ struct ieee80211_tx_data {
>>  	struct ieee80211_channel *channel;
>>  
>>  	unsigned int flags;
>> +
>> +	struct ieee80211_tx_control control;
> 
> Why is this needed/useful?


I used it just in tx.c to pass the control pointer as function
parameter, but as I like your suggestion below it is gone in v5.

> 
>>  		info->control.vif = vif;
>> -		info->control.sta = sta;
>> +		control->sta = sta;
>>  
>>  		__skb_unlink(skb, skbs);
>> -		drv_tx(local, skb);
>> +		drv_tx(local, control, skb);
> 
> You're assigning to it right before, and I don't see you using it any
> time before, so why not just have the control struct on the stack of
> this function?


Good idea, v5 is coming.

Greetings Thomas

