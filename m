Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12379 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab2GNGFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 02:05:49 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20481.3065.540576.366365@gargle.gargle.HOWL> (sfid-20120714_080620_587612_2F5A24FB)
Date: Sat, 14 Jul 2012 11:34:41 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue TXOP limit
In-Reply-To: <1342105451-42297-8-git-send-email-nbd@openwrt.org>
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org>
	<1342105451-42297-2-git-send-email-nbd@openwrt.org>
	<1342105451-42297-3-git-send-email-nbd@openwrt.org>
	<1342105451-42297-4-git-send-email-nbd@openwrt.org>
	<1342105451-42297-5-git-send-email-nbd@openwrt.org>
	<1342105451-42297-6-git-send-email-nbd@openwrt.org>
	<1342105451-42297-7-git-send-email-nbd@openwrt.org>
	<1342105451-42297-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> @@ -1384,6 +1384,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
>  		queue, txq->axq_qnum, params->aifs, params->cw_min,
>  		params->cw_max, params->txop);
>  
> +	ath_update_max_aggr_framelen(sc, queue, qi.tqi_burstTime);
>  	ret = ath_txq_update(sc, txq->axq_qnum, &qi);
>  	if (ret)
>  		ath_err(common, "TXQ Update failed\n");

Wouldn't this break multi-interface operation ? This unconditionally
updates the aggr. limits of an existing interface when a new one is added.

Sujith
