Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46474 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab2GNKC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 06:02:57 -0400
Message-ID: <500143CA.1020804@openwrt.org> (sfid-20120714_120339_286936_EDEED5F8)
Date: Sat, 14 Jul 2012 12:02:50 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org> <1342105451-42297-2-git-send-email-nbd@openwrt.org> <1342105451-42297-3-git-send-email-nbd@openwrt.org> <1342105451-42297-4-git-send-email-nbd@openwrt.org> <1342105451-42297-5-git-send-email-nbd@openwrt.org> <1342105451-42297-6-git-send-email-nbd@openwrt.org> <1342105451-42297-7-git-send-email-nbd@openwrt.org> <1342105451-42297-8-git-send-email-nbd@openwrt.org> <20481.3065.540576.366365@gargle.gargle.HOWL>
In-Reply-To: <20481.3065.540576.366365@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-14 8:04 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> @@ -1384,6 +1384,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
>>  		queue, txq->axq_qnum, params->aifs, params->cw_min,
>>  		params->cw_max, params->txop);
>>  
>> +	ath_update_max_aggr_framelen(sc, queue, qi.tqi_burstTime);
>>  	ret = ath_txq_update(sc, txq->axq_qnum, &qi);
>>  	if (ret)
>>  		ath_err(common, "TXQ Update failed\n");
> 
> Wouldn't this break multi-interface operation ? This unconditionally
> updates the aggr. limits of an existing interface when a new one is added.
No, this doesn't break multi-interface. TXOP limit (like other WMM
settings) can only be configured per-wiphy, so the max. aggregation
lengths are per-wiphy as well.

- Felix
