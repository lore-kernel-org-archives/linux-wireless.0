Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49818 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZKOOTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 09:19:34 -0500
Message-ID: <4B000DF5.4020606@openwrt.org>
Date: Sun, 15 Nov 2009 15:19:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] mac80211: add private driver flags and ampdu length
 to tx info
References: <4AFED564.8030804@openwrt.org> <1258293706.6294.7.camel@johannes.local>
In-Reply-To: <1258293706.6294.7.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-11-14 at 17:05 +0100, Felix Fietkau wrote:
> 
>> - * @ampdu_ack_len: number of aggregated frames.
>> - * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
>> + * @ampdu_ack_len: number of acked aggregated frames.
>> + * 	relevant only if ieee80211_tx_status_ampdu was set.
> 
> why lowercase that?
Sorry, late night vim accident. I'll resend...

>> -	/* 2 byte hole */
>> -	u8 pad[2];
>> +	u8 driver_flags;
>> +	u8 pad;
> 
> The ampdu_len seems ok, but I'm still not convinced this is right.
> Drivers _should_ have enough space in the driver parts of this struct,
> and not need flags here. I realise that you do need that because of the
> RC and other internal things, but maybe you could simply use "pad[0]"
> for that so not to encourage others to start doing this too?
If you prefer it using the padding directly, I can change it to that
too. I don't mind as long as I have space to put that stuff into and
don't need to use rate_driver_data.

- Felix
