Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3924 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1GME3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 00:29:04 -0400
Subject: Re: [PATCH 03/24] ath6kl: add cfg80211.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713013324.8517.86411.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013324.8517.86411.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:29:03 -0700
Message-ID: <1310531343.1143.26.camel@Joe-Laptop> (sfid-20110713_062909_004773_5026A88E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
[] 
> +static struct ieee80211_rate ath6kl_rates[] = {

const?

> +static struct ieee80211_channel ath6kl_2ghz_channels[] = {

const?

> +static struct ieee80211_channel ath6kl_5ghz_a_channels[] = {

const?

> +static struct ieee80211_supported_band ath6kl_band_2ghz = {

const?

> +static struct ieee80211_supported_band ath6kl_band_5ghz = {

const?

> +		ath6kl_err("%s: %u not spported\n", __func__, wpa_version);
> +		ath6kl_err("%s: 0x%x not spported\n", __func__, auth_type);

supported

> +		wait_event_interruptible_timeout(ar->event_wq,
> +						 ar->
> +						 tx_pending[wmi_get_control_ep
> +							     (ar->wmi)] == 0,
> +						 WMI_TIMEOUT);

I think you can ignore 80 columns for this.

		wait_event_interruptible_timeout(ar->event_wq,
						 ar->tx_pending[wmi_get_control_ep(ar->wmi)] == 0,
						 WMI_TIMEOUT);

or maybe use different argument alignment when appropriate:

		wait_event_interruptible_timeout(ar->event_wq,
			ar->tx_pending[wmi_get_control_ep(ar->wmi)] == 0,
			WMI_TIMEOUT);

[]

> +		if (sme->key_idx < WMI_MIN_KEY_INDEX
> +		    || sme->key_idx > WMI_MAX_KEY_INDEX) {

I think it's more consistent with other files in drivers/net
to use logical continuations at EOL

if (sme->key_idx < WMI_MIN_KEY_INDEX ||
    sme->key_idx > WMI_MAX_KEY_INDEX) {

> +			ath6kl_err("%s: key index %d out of bounds\n", __func__,
> +				   sme->key_idx);

I think it's better to use format on one line,
arguments on another.

			ath6kl_err("%s: key index %d out of bounds\n",
				    __func__, sme->key_idx);


It seems almost all of your ath6kl_<level> logging
messages use __func__.  Perhaps you might as well
#define it to take __func__ instead of using it
in-place over and over.



