Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:59223 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0L0NL6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 08:11:58 -0500
Subject: Re: [PATCH v2 09/18] wl1271: Configure AP on BSS info change
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-10-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-10-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 15:11:55 +0200
Message-ID: <1293455515.19215.3052.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Configure AP-specific beacon and probe response templates.
> Start the AP when beaconing is enabled.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

>  static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
> @@ -1898,73 +1900,84 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,

This whole wl1271_op_bss_info_changed() function was already quite long
and hard to read.  Now, with support for AP and STA, it got even worse.
I think this should be broken down into smaller functions.  No need to
clean the whole function up now, but would it be possible to separate at
least the AP and STA parts into separate functions?


> @@ -1983,11 +2018,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>  						  bss_conf->cqm_rssi_thold,
>  						  bss_conf->cqm_rssi_hyst);
>  		if (ret < 0)
> -			goto out;
> +			goto out_sleep;

Hmmm, nice catch.  We were going out without sleeping in case of error
here.  But this is a cross-patch change, could you separate it and send
as a standalone patch?


-- 
Cheers,
Luca.

