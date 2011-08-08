Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1HHNLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:11:30 -0400
Subject: Re: [PATCHv2] nl80211: add support to abort a scan request on tx
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org, sleffler@chromium.org
In-Reply-To: <ee96368a4bef8d9cca786406089c5f3806b33f5c.1311872448.git.pstew@chromium.org> (sfid-20110728_190209_373633_0A17FEC0)
References: <5ec1fd1a0868f7a07741c25fa43fff0969667f9e.1311870004.git.pstew@chromium.org>
	 <ee96368a4bef8d9cca786406089c5f3806b33f5c.1311872448.git.pstew@chromium.org>
	 (sfid-20110728_190209_373633_0A17FEC0)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:11:29 +0200
Message-ID: <1312809089.4372.24.camel@jlt3.sipsolutions.net> (sfid-20110808_151134_032089_2EB657A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-23 at 14:34 -0700, Paul Stewart wrote:

> @@ -1014,6 +1014,8 @@ enum nl80211_commands {
>   * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
>   *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
>   *
> + * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u8)

I think it should either be a u32 or a flag attribute. u8 is kinda
pointless for a flags attribute since it needs 4 bytes of space anyway.

> +++ b/include/net/cfg80211.h
> @@ -769,6 +769,15 @@ struct cfg80211_ssid {
>  };
>  
>  /**
> + * enum cfg80211_scan_flag -  scan request control flags
> + *
> + * @CFG80211_SCAN__FLAG_TX_ABORT: abort scan on pending transmit
> + */
> +enum cfg80211_scan_flags {
> +	CFG80211_SCAN_FLAG_TX_ABORT	= BIT(0),
> +};

Err, this needs to be in nl80211.h as well, no? How else would userspace
know what flags it can use?

Additionally, it would seem that there's a need to advertise what flags
are supported by a given driver.

Would you mind splitting into nl80211/mac80211 pieces?

Also -- maybe you should explain a bit more verbosely in the commit log
why this is a good idea? I'm not even sure how it really reduces TX
latency?

johannes

