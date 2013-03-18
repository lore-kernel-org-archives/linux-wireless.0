Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3CRT0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:26:14 -0400
Message-ID: <1363634768.8260.16.camel@jlt4.sipsolutions.net> (sfid-20130318_202617_037484_1E5A720C)
Subject: Re: Radiotap injected rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Date: Mon, 18 Mar 2013 20:26:08 +0100
In-Reply-To: <20130317215544.GA7031@gobelin> (sfid-20130317_225612_791728_FF17B65A)
References: <20130317215544.GA7031@gobelin>
	 (sfid-20130317_225612_791728_FF17B65A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-03-17 at 22:55 +0100, Karl Beldan wrote:
> Hi,
> 
> Some time ago the rate selection for radiotap injected frames did not
> make it essentially for mac80211 getting short in IEEE80211_TX_CTL_*s.
> 
> Would it be acceptable to replace the originally proposed:
> 
> 
> -	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
> +	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
> +	    !(info->flags & IEEE80211_TX_CTL_NO_RC))
>  		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> 
> with something like :
> 
> -	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
> +	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
> +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[i]))
> 		CALL_TXH(ieee80211_tx_h_rate_ctrl);

No, older wpa_supplicant/hostapd still use monitor interfaces for
management frame transmissions, and require rate control.

johannes

