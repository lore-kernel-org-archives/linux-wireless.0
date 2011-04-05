Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56529 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab1DESUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 14:20:02 -0400
Message-ID: <4D9B5D4B.8000909@openwrt.org>
Date: Tue, 05 Apr 2011 20:19:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Senthil Balasubramanian <senthil.lnx@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/3] ath9k: fix signal strength of received packets
References: <1301708388-8416-1-git-send-email-nbd@openwrt.org> <20110405180700.GA2430@ath9k-test>
In-Reply-To: <20110405180700.GA2430@ath9k-test>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-05 8:07 PM, Senthil Balasubramanian wrote:
> On Sat, Apr 02, 2011 at 03:39:46AM +0200, Felix Fietkau wrote:
>>  The reported RSSI values are relative to the calibrated noise floor, not
>>  relative to a hardcoded value of -95.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>   drivers/net/wireless/ath/ath9k/recv.c |   11 ++++++++++-
>>   1 files changed, 10 insertions(+), 1 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>>  index a9c3f46..87d96c5 100644
>>  --- a/drivers/net/wireless/ath/ath9k/recv.c
>>  +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>  @@ -959,6 +959,9 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>>   				struct ieee80211_rx_status *rx_status,
>>   				bool *decrypt_error)
>>   {
>>  +	struct ath_hw *ah = common->ah;
>>  +	int noise;
>>  +
>>   	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
>>
>>   	/*
>>  @@ -979,7 +982,13 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>>
>>   	rx_status->band = hw->conf.channel->band;
>>   	rx_status->freq = hw->conf.channel->center_freq;
>>  -	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
> In some cases noisefloor values were not reliable and so using
> default works for most of the cases. Please refer to our earlier
> commit a59b5a5e684652eec035c869ab8911a1689c8f53. Let me see if i
> can get more information.
Well, if the average noise floor is at -110 (which is not uncommon with 
AR9280 chipsets) then that means the signal strength is off by at least 
15 dBm as well.

>>  +
>>  +	if (ah->curchan)
>>  +		noise = ah->curchan->noisefloor;
> Even otherwise, noisefloor can be zero sometimes and so it can
> return incorrect signal strengths.. Please refer to some samples.
OK, that's easy to fix, we only need to initialize the channel 
noisefloor when we switch to the channel. I'll make a patch to fix it 
the noisefloor values and then resend this one.

John, please drop this patch but apply the other two in the series.

- Felix
