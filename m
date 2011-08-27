Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57110 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1H0Iuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 04:50:40 -0400
Message-ID: <4E58AFD9.6070108@openwrt.org> (sfid-20110827_105046_975784_87224006)
Date: Sat, 27 Aug 2011 10:50:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: fix regression in sending aggregated packets
References: <1314433527-71007-1-git-send-email-nbd@openwrt.org> <20110827083520.GA4063@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110827083520.GA4063@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-27 10:35 AM, Rajkumar Manoharan wrote:
> On Sat, Aug 27, 2011 at 10:25:27AM +0200, Felix Fietkau wrote:
>>  The recent commit "ath9k: Send legacy rated frames as unaggregated"
>>  introduced a check to ensure that packets with non-MCS rates set in
>>  the rate series will not be aggregated. However, it failed to check
>>  if the rate series is valid before testing the flags, thus breaking
>>  aggregation for normal MCS-only packets if the last series is unset.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>   drivers/net/wireless/ath/ath9k/xmit.c |    5 ++++-
>>   1 files changed, 4 insertions(+), 1 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>>  index 5e29829..ac393a6 100644
>>  --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>  +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>  @@ -582,7 +582,10 @@ static bool ath_lookup_legacy(struct ath_buf *bf)
>>   	tx_info = IEEE80211_SKB_CB(skb);
>>   	rates = tx_info->control.rates;
>>
>>  -	for (i = 3; i>= 0; i--) {
>>  +	for (i = 0; i<  4; i++) {
>>  +		if (!rates[i].count || rates[i].idx<  0)
>>  +			break;
>>  +
> Good catch. Let it be descending order that helps to reduce number of iteration in case of
> ath9k_rate_control.
That would really just be a very minor micro-optimization and it would 
make finding the first invalid rate harder and the code more convoluted. 
I don't think it's worth changing the patch for that.

- Felix
