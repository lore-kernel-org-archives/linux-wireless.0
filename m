Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:35527 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198Ab3CDUWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:22:31 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes.berg@intel.com>
Date: Mon, 4 Mar 2013 12:19:05 -0800
Subject: RE: [PATCH] regulatory: enable channels 52-144 for world roaming
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DA3D2@SC-VEXCH1.marvell.com> (sfid-20130304_212242_250662_0F451A0A)
References: <1362427007-4493-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1362427007-4493-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

[...]

> @@ -188,7 +188,11 @@ static const struct ieee80211_regdomain world_regdom = {
>                          NL80211_RRF_PASSIVE_SCAN |
>                          NL80211_RRF_NO_IBSS),
> 
> -		/* NB: 5260 MHz - 5700 MHz requires DFS */
> +		/* IEEE 802.11a, channel 52..144 - DFS required */
> +		REG_RULE(5760-10, 5720+10, 80, 6, 20,

5260-10

> +			NL80211_RRF_PASSIVE_SCAN |
> +			NL80211_RRF_NO_IBSS |
> +			NL80211_RRF_DFS),
> 
>  		/* IEEE 802.11a, channel 149..165 */
>  		REG_RULE(5745-10, 5825+10, 80, 6, 20,

Regards,
Bing

