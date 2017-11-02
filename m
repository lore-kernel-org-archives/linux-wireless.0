Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:50083 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964928AbdKBVId (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 17:08:33 -0400
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
To: Christian Lamparter <chunkeey@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
References: <20171101200157.27096-1-chunkeey@gmail.com>
 <224e2890-3775-967b-d4ce-4297574c0642@dd-wrt.com>
 <1666282.PC3nhpCf9f@debian64>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <b31e2b05-4882-de0a-09c8-a007f1e407ce@dd-wrt.com> (sfid-20171102_220838_380617_6152D4C9)
Date: Thu, 2 Nov 2017 22:08:30 +0100
MIME-Version: 1.0
In-Reply-To: <1666282.PC3nhpCf9f@debian64>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i know. saw that later too. code should be safe

Am 02.11.2017 um 20:34 schrieb Christian Lamparter:
> On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall wrote:
>> a additional array bounds check would be good
> Ah, about that:
>
> the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
> in the following way [0]:
> |	bw = info2 & 3;
>
> the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set by [1]:
> |	txrate.bw = ATH10K_HW_BW(peer_stats->flags);
>
> ATH10K_HW_BW is a macro defined as [2]:
> |	#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)
>
> In both cases the bandwidth values already are limited to 0-3 by
> the "and 3" operation.
>
> [0] <https://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/net/wireless/ath/ath10k/htt_rx.c#L646>
>
> [1] <https://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/net/wireless/ath/ath10k/htt_rx.c#L2254>
> [2] <https://elixir.free-electrons.com/linux/v4.14-rc7/source/drivers/net/wireless/ath/ath10k/wmi.h#L4810>
>
>
>>> @@ -592,6 +592,9 @@ struct amsdu_subframe_hdr {
>>>    
>>>    #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
>>>    
>>> +static const u8 ath10k_bw_to_mac80211[] = { RATE_INFO_BW_20, RATE_INFO_BW_40,
>>> +	RATE_INFO_BW_80, RATE_INFO_BW_160 };
>>> +
>>>    static void ath10k_htt_rx_h_rates(struct ath10k *ar,
>>>    				  struct ieee80211_rx_status *status,
>>>    				  struct htt_rx_desc *rxd)
>>> @@ -694,23 +697,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
>>>    		if (sgi)
>>>    			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
>>>    
>>> [...]
>>> +		status->bw = ath10k_bw_to_mac80211[bw];
>>>    		status->encoding = RX_ENC_VHT;
>>>    		break;
>>>    	default:
>>> @@ -2297,7 +2284,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
>>>    		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
>>>    
>>>    	arsta->txrate.nss = txrate.nss;
>>> -	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
>>> +	arsta->txrate.bw = ath10k_bw_to_mac80211[txrate.bw];
>>>    }
>>>    
>>>    static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
>
>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
