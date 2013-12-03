Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3LCOYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 09:24:23 -0500
Message-ID: <1386080659.4393.29.camel@jlt4.sipsolutions.net> (sfid-20131203_152444_377925_1B3AB7E0)
Subject: Re: [PATCH 4/4] nl80211: add VHT support for set_bitrate_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 03 Dec 2013 15:24:19 +0100
In-Reply-To: <1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131203_095102_974758_EBAAA3B1)
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386060648-6020-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131203_095102_974758_EBAAA3B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 09:50 +0100, Janusz Dziedzic wrote:
> Add VHT mcs support for nl80211_set_tx_bitrate_mask().

Do we really need more fine-grained control than 0-7/8/9? Why do we need
this at all? :)

> +#define NL80211_MAX_SUPP_VHT_RATES		80

Where does 80 come from? That seems odd?

> + * @NL80211_TXRATE_VHT_MCS: VHT (MCS) rates allowed for TX rate selection
> + *	in an array of MCS numbers.

VHT has no "MCS numbers", so this doesn't make much sense?

>  		if (mask.control[band].legacy == 0) {
> -			/* don't allow empty legacy rates if HT
> +			/* don't allow empty legacy rates if HT and VHT
>  			 * is not even supported. */

probably should say "are not" now :)

johannes

