Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:55920 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141Ab3FFKdW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 06:33:22 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] ath5k: make use of the new rate control API
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <51B063C7.5040509@openwrt.org>
Date: Thu, 6 Jun 2013 12:33:22 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, mickflemm@gmail.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com,
	adrian@freebsd.org, ath5k-devel@lists.ath5k.org,
	bvahl@net.t-labs.tu-berlin.de
Message-Id: <6E08D01A-502E-435D-BBD3-3DA3B40DC2BF@net.t-labs.tu-berlin.de> (sfid-20130606_123325_410312_D09B89D0)
References: <1370509492-24293-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <51B063C7.5040509@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI,

> This patch is missing changes in the tx status path. At tx completion,
> info->status.rates needs to be filled with the contents of bf->rates
> before filling in retry counts.
> 

Thats right, I will fix this in V2.

>> 
>> +	txrate.count = bf->rates[0].count;
>> +
>> 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
>> 		ieee80211_get_hdrlen_from_skb(skb), padsize,
>> 		get_hw_packet_type(skb),
>> 		(ah->ah_txpower.txp_requested * 2),
>> 		hw_rate,
>> -		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
>> +		txrate.count, keyidx, ah->ah_tx_ant, flags,
>> 		cts_rate, duration);
>> 	if (ret)
>> 		goto err_unmap;
> The txrate variable is pointless, you only use txrate.count where you
> could also just use bf->rates[0].count directly.
> 

I will remove this variable.

Thx for you review.

Thomas

> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

