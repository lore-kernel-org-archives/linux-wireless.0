Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54656 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0I1Qq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 12:46:28 -0400
Message-ID: <4CA21BDC.8010100@candelatech.com>
Date: Tue, 28 Sep 2010 09:46:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v4] ath5k: Allow ath5k to support virtual STA and AP interfaces.
References: <1285621588-28184-1-git-send-email-greearb@candelatech.com> <201009281901.07312.br1@einfach.org>
In-Reply-To: <201009281901.07312.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 03:01 AM, Bruno Randolf wrote:
> On Tue September 28 2010 06:06:28 greearb@candelatech.com wrote:

>>   	/* configure operational mode */
>>   	ath5k_hw_set_opmode(ah, sc->opmode);
>> @@ -698,13 +760,13 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct
>> ath5k_buf *bf, flags |= AR5K_TXDESC_RTSENA;
>>   		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
>>   		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
>> -			sc->vif, pktlen, info));
>> +			NULL, pktlen, info));
>
> hmm, this NULL means we don't handle short preamble and erp correctly. i don't
> know if we did before, but it would be better to use the corresponding vif - i
> think it can be found in ieee80211_tx_info *info.

This is nasty though...you can't trust that the vif still exists.
It could have been deleted right after pushing this packet, I think.

I'd rather not have to ask mac80211 to do a lookup here.

Perhaps if I forced a flush of all tx pkts when an interface
was deleted?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

