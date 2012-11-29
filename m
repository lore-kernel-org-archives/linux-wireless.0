Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33881 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab2K2Mvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:51:53 -0500
Message-ID: <1354193471.5254.6.camel@cumari.coelho.fi> (sfid-20121129_135157_105393_27F8BAA3)
Subject: Re: [PATCH 20/20] wl18xx: set last Tx rate from FW status
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 29 Nov 2012 14:51:11 +0200
In-Reply-To: <1353998701-18171-21-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-21-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:45 +0200, Arik Nemtsov wrote:
> Obtain the last Tx rate from the FW status and translate it to
> the mac80211 rate+flag format before sending it up via the Tx status.
> 
> Bump up the min FW version to the first FW that supports the rate byte.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> +static
> +void wl18xx_get_last_tx_rate(struct wl1271 *wl, struct ieee80211_vif *vif,
> +			     u8 *tx_rate, u8 *tx_rate_flags)

[...]

> +	/*
> +	 * first pass info->control.vif while it's valid, and then fill out
> +	 * the info->status structures
> +	 */
> +	wl18xx_get_last_tx_rate(wl, info->control.vif,
> +				&info->status.rates[0].idx,
> +				&info->status.rates[0].flags);

This doesn't work anymore, because commit 8bc83c24 (mac80211: support
VHT rates in TX info) changed the struct like this:

@@ -560,10 +568,32 @@ enum mac80211_rate_control_flags {
  */
 struct ieee80211_tx_rate {
        s8 idx;
-       u8 count;
-       u8 flags;
+       u16 count:5,
+           flags:11;
 } __packed;

So you can't get the address of flags anymore.

Do you mind respinning it?

--
Luca.

