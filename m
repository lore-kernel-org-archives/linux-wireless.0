Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2G3Hge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 03:36:34 -0400
Message-ID: <1343633789.4452.5.camel@jlt3.sipsolutions.net> (sfid-20120730_093639_871027_D3F99ABD)
Subject: Re: [PATCH 2/2] mac80211: Add transmit power control support (TPC)
 for ACK packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Date: Mon, 30 Jul 2012 09:36:29 +0200
In-Reply-To: <1343404809-70329-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120727_180038_027363_C1B333FB)
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1343404809-70329-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120727_180038_027363_C1B333FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 18:00 +0200, Thomas Huehn wrote:

> @@ -283,6 +284,9 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
>  					      txrc->bss_conf->basic_rates,
>  					      sband);
>  		}
> +		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
> +			info->control.rates[i].tpc = txrc->hw->conf.power_level;
> +		}

No need for braces, and a blank line above it would be good. Remember
code is meant to be read by people and compilers (in that order)

Anyway I don't think I'm going to apply any of this until we have some
code that uses it.

johannes

