Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3BDPgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:36:37 -0500
Message-ID: <1359992219.10311.16.camel@jlt4.sipsolutions.net> (sfid-20130204_163641_118159_6D181F12)
Subject: Re: [PATCH 1/2] wireless: expand per-station byte counters to 64bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 04 Feb 2013 16:36:59 +0100
In-Reply-To: <1359978792-7121-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1359978792-7121-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 13:53 +0200, Vladimir Kondratiev wrote:
> In per-station statistics, present 32bit counters are too small
> for practical purposes - with gigabit speeds, it get overlapped
> every few seconds.
> 
> Expand counters in the struct station_info to be 64-bit.
> Driver can still fill only 32-bit and indicate in @filled
> only bits like STATION_INFO_[TR]X_BYTES; in case driver provides
> full 64-bit counter, it should also set in @filled
> bit STATION_INFO_[TR]RX_BYTES64

Applied, but ...

> Netlink sends both 32-bit and 64-bit counters, if present, to not break
> user space.

You didn't quite implement that, so I changed it:


> +	if ((sinfo->filled & STATION_INFO_RX_BYTES64) &&
> +	    nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
> +			sinfo->rx_bytes))
> +		goto nla_put_failure;
>[...]

+       if (sinfo->filled & STATION_INFO_RX_BYTES64) {
+               if (nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
+                               sinfo->rx_bytes))
+                       goto nla_put_failure;
+               if (sinfo->rx_bytes <= UINT_MAX &&
+                   nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
+                               (u32)sinfo->rx_bytes))
+                       goto nla_put_failure;
+       }
+       if (sinfo->filled & STATION_INFO_TX_BYTES64) {
+               if (nla_put_u64(msg, NL80211_STA_INFO_TX_BYTES64,
+                               sinfo->tx_bytes))
+                       goto nla_put_failure;
+               if (sinfo->tx_bytes <= UINT_MAX &&
+                   nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
+                               (u32)sinfo->tx_bytes))
+                       goto nla_put_failure;
+       }


johannes

