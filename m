Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57309 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab3FGMrt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 08:47:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: make use of the new rate control API
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <51B1BCE1.6080200@openwrt.org>
Date: Fri, 7 Jun 2013 14:47:51 +0200
Cc: bvahl@net.t-labs.tu-berlin.de, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, rmanohar@qca.qualcomm.com
Message-Id: <547C54A2-FC7E-43C6-BBC0-19C11F8F7BCA@net.t-labs.tu-berlin.de> (sfid-20130607_144752_427662_B36D20C4)
References: <1370593505-4439-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <51B1BCE1.6080200@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

>>> 
>>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>>> index 7f702fe..c63759f 100644
>>> --- a/drivers/net/wireless/ath/ath5k/base.c
>>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>>> @@ -1587,6 +1633,8 @@ ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
>>> 
>>> 	ieee80211_tx_info_clear_status(info);
>>> 
>>> +	memcpy(info->status.rates, bf->rates, sizeof(info->status.rates));
>>> +
>>> 	for (i = 0; i < ts->ts_final_idx; i++) {
>>> 		struct ieee80211_tx_rate *r =
>>> 			&info->status.rates[i];
>> Please make sure that either this code is able to deal with a size
>> mismatch of info->status.rates vs. bf->rates, or that it at least fails
>> at compile time if the size of info->status.rate gets changed.
>> 

Good catch, V3 is coming.

Thomas


>> - Felix
>> _______________________________________________
>> ath5k-devel mailing list
>> ath5k-devel@lists.ath5k.org
>> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
> 
