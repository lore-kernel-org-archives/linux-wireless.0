Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48552 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2GOLVa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 07:21:30 -0400
Message-ID: <5002A7B2.409@openwrt.org> (sfid-20120715_132134_094888_83DCD019)
Date: Sun, 15 Jul 2012 13:21:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2 08/12] ath9k: fix aggregate size limit based on queue
 TXOP limit
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org> <1342105451-42297-2-git-send-email-nbd@openwrt.org> <1342105451-42297-3-git-send-email-nbd@openwrt.org> <1342105451-42297-4-git-send-email-nbd@openwrt.org> <1342105451-42297-5-git-send-email-nbd@openwrt.org> <1342105451-42297-6-git-send-email-nbd@openwrt.org> <1342105451-42297-7-git-send-email-nbd@openwrt.org> <1342105451-42297-8-git-send-email-nbd@openwrt.org> <20481.3065.540576.366365@gargle.gargle.HOWL>,<500143CA.1020804@openwrt.org> <506697F5827BD842B7CB80D046EBE618995399@aphydexd01b>
In-Reply-To: <506697F5827BD842B7CB80D046EBE618995399@aphydexd01b>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-15 4:21 AM, Manoharan, Sujith wrote:
> I believe mac80211 has a per-VIF idea of queue parameters (tx_conf in struct ieee80211_sub_if_data).
> And we end up overwriting the parameters of the main interface. For example,
> 
> * Bringing up an AP interface:
> 
> ath: phy0: Configure tx [queue/halq] [0/0], aifs: 1, cw_min: 3, cw_max: 7, txop: 47
> ath: phy0: Configure tx [queue/halq] [1/1], aifs: 1, cw_min: 7, cw_max: 15, txop: 94
> ath: phy0: Configure tx [queue/halq] [2/2], aifs: 3, cw_min: 15, cw_max: 63, txop: 0
> ath: phy0: Configure tx [queue/halq] [3/3], aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
> 
> * Adding a new station interface (but not associated yet):
> 
> ath: phy0: Attach a VIF of type: 2
> 
> ath: phy0: Configure tx [queue/halq] [0/0], aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
> ath: phy0: Configure tx [queue/halq] [1/1], aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
> ath: phy0: Configure tx [queue/halq] [2/2], aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
> ath: phy0: Configure tx [queue/halq] [3/3], aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
Yes, but ath9k only has global queue settings, not per-vif ones, so I'm
not sure what can be done about the issue of overwriting queue settings.

Either way, it's important for the aggregation limit to be in sync with
the hardware queue TXOP limit, so I believe this patch is correct.

- Felix
