Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59010 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab3BKOKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 09:10:20 -0500
Message-ID: <5118FBC9.7000801@openwrt.org> (sfid-20130211_151023_707965_48674E03)
Date: Mon, 11 Feb 2013 15:10:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 3/3] mac80211/minstrel_ht: add support for using CCK
 rates
References: <1360589765-58642-1-git-send-email-nbd@openwrt.org> <1360589765-58642-2-git-send-email-nbd@openwrt.org> <1360589765-58642-3-git-send-email-nbd@openwrt.org> <201302111457.28452.chunkeey@googlemail.com>
In-Reply-To: <201302111457.28452.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-11 2:57 PM, Christian Lamparter wrote:
> On Monday, February 11, 2013 02:36:05 PM Felix Fietkau wrote:
>> When MCS rates start to get bad in 2.4 GHz because of long range or
>> strong interference, CCK rates can be a lot more robust.
>> 
>> This patch adds a pseudo MCS group containing CCK rates (long preamble
>> in the lower 4 slots, short preamble in the upper slots).
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  static void
>> +minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
>> +		       struct ieee80211_supported_band *sband,
>> +		       struct ieee80211_sta *sta)
>> +{
>> +	int i;
>> +
>> +	if (sband->band != IEEE80211_BAND_2GHZ)
>> +		return;
>> +
>> +	mi->cck_supported = 0;
>> +	mi->cck_supported_short = 0;
>> +	for (i = 0; i < 4; i++) {
>> +		if (!rate_supported(sta, sband->band, mp->cck_rates[i]))
>> +			continue;
> 
> Don't we need to check if the receiver (and the minstrel_ht sender)
> supports IEEE80211_HT_CAP_DSSSCCK40 when the phy is in HT40+/- mode?
I don't think this should be handled in the rate control modules, when
mac80211 can easily handle that through the supported rates set (which
seems to be the intention behind this flag in the standard as well).

- Felix

