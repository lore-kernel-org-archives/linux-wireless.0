Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3BDRsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:48:12 -0500
Message-ID: <1360000114.17993.23.camel@jlt4.sipsolutions.net> (sfid-20130204_184815_646358_43C7CB43)
Subject: Re: [PATCH 1/2] wireless: expand per-station byte counters to 64bit
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 04 Feb 2013 18:48:34 +0100
In-Reply-To: <1359992219.10311.16.camel@jlt4.sipsolutions.net> (sfid-20130204_163641_118159_6D181F12)
References: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1359978792-7121-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1359992219.10311.16.camel@jlt4.sipsolutions.net>
	 (sfid-20130204_163641_118159_6D181F12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 16:36 +0100, Johannes Berg wrote:

> > +	if ((sinfo->filled & STATION_INFO_RX_BYTES64) &&
> > +	    nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
> > +			sinfo->rx_bytes))
> > +		goto nla_put_failure;
> >[...]
> 
> +       if (sinfo->filled & STATION_INFO_RX_BYTES64) {
> +               if (nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
> +                               sinfo->rx_bytes))
> +                       goto nla_put_failure;
> +               if (sinfo->rx_bytes <= UINT_MAX &&
> +                   nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
> +                               (u32)sinfo->rx_bytes))
> +                       goto nla_put_failure;
> +       }
> +       if (sinfo->filled & STATION_INFO_TX_BYTES64) {
> +               if (nla_put_u64(msg, NL80211_STA_INFO_TX_BYTES64,
> +                               sinfo->tx_bytes))
> +                       goto nla_put_failure;
> +               if (sinfo->tx_bytes <= UINT_MAX &&
> +                   nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
> +                               (u32)sinfo->tx_bytes))
> +                       goto nla_put_failure;
> +       }

Ok Vladimir convinced me this was stupid because it breaks the current
userspace API in a subtle way: right now, if it rolls over, we will get
wrapped values in userspace, afterwards with a 64-bit compatible driver
we won't get any 32-bit value ...

I'll change it to this though, so drivers don't get this choice:


-       if ((sinfo->filled & STATION_INFO_RX_BYTES) &&
+       if ((sinfo->filled & (STATION_INFO_RX_BYTES |
+                             STATION_INFO_RX_BYTES64)) &&
            nla_put_u32(msg, NL80211_STA_INFO_RX_BYTES,
-                       sinfo->rx_bytes))
+                       (u32)sinfo->rx_bytes))
                goto nla_put_failure;
-       if ((sinfo->filled & STATION_INFO_TX_BYTES) &&
+       if ((sinfo->filled & (STATION_INFO_TX_BYTES |
+                             NL80211_STA_INFO_TX_BYTES64)) &&
            nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
+                       (u32)sinfo->tx_bytes))
+               goto nla_put_failure;
+       if ((sinfo->filled & STATION_INFO_RX_BYTES64) &&
+           nla_put_u64(msg, NL80211_STA_INFO_RX_BYTES64,
+                       sinfo->rx_bytes))
+               goto nla_put_failure;
+       if ((sinfo->filled & STATION_INFO_TX_BYTES64) &&
+           nla_put_u64(msg, NL80211_STA_INFO_TX_BYTES64,
                        sinfo->tx_bytes))
                goto nla_put_failure;


IOW, always put the 32-bit value even if the driver said it had 64-bit,
but then also give the 64-bit value to userspace.

johannes

