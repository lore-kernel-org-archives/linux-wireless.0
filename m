Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2900 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2HMN6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 09:58:50 -0400
Message-ID: <5029080C.3060503@broadcom.com> (sfid-20120813_155853_711794_A5640B44)
Date: Mon, 13 Aug 2012 15:58:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: linux-wireless@vger.kernel.org, dquan@qca.qualcomm.com
Subject: Re: [RFT 2/2] cfg80211: add 5 GHz UNII band regulatory hints
References: <1344644750-14000-1-git-send-email-mcgrof@do-not-panic.com>
 <1344644750-14000-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1344644750-14000-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2012 02:25 AM, Luis R. Rodriguez wrote:
> +static void reg_unii_5ghz_beacon_hint_unii(struct wiphy *wiphy,
> +					   struct ieee80211_channel *chan,
> +					   enum reg_5ghz_unii_band unii_band)
> +{
> +	struct ieee80211_supported_band *sband;
> +	unsigned int i;
> +
> +	assert_cfg80211_lock();
> +
> +	sband = wiphy->bands[chan->band];
> +
> +	/*
> +	 * Only process UNII 1 hints for UNII 1 channels
> +	 * Only process UNII 3 hints for UNII 3 channels
> +	 */
> +	for (i = 0; i < sband->n_channels; i++) {
> +		struct ieee80211_channel *c = &sband->channels[i];
> +
> +		switch (unii_band) {
> +		case REG_5GHZ_UNII_1:
> +			if (!reg_is_5ghz_unii_1(c))
> +				continue;
> +			break;
> +		case REG_5GHZ_UNII_3:
> +			if (!reg_is_5ghz_unii_3(c))
> +				continue;
> +			break;
> +		default:
> +			WARN_ONCE(1, "unexpected regulatory unii hint\n");
> +			continue;
> +		}
> +
> +		reg_chan_process_beacon_hint(wiphy, chan);

Not sure, but reading the description I think variable 'c' should be
passed here instead of 'chan'.

> +	}

Gr. AvS

