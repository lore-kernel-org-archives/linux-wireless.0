Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20279 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0EKE2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 00:28:05 -0400
Subject: Re: [patch 9/9] wl1271: remove some unneeded code
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>,
	"Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>, Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100508162638.GU27064@bicker>
References: <20100508162638.GU27064@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 07:28:03 +0300
Message-ID: <1273552083.2021.27.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-08 at 18:26 +0200, ext Dan Carpenter wrote:
> The goto and the break are equivelent.  I removed the goto in memory of
> Edsger Dijkstra who famously hated gotos and who would have been eighty
> years old next Tuesday.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index 55aa813..da40cee 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -1563,8 +1563,6 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  	default:
>  		wl1271_error("Unsupported key cmd 0x%x", cmd);
>  		ret = -EOPNOTSUPP;
> -		goto out_sleep;
> -
>  		break;
>  	}

We use goto out_* in error cases throughout our code (sorry Edsger!) and
in many cases they are not needed because they're the last check in the
function, but we still use them for consistency.

In this case, there are two "consistency" items conflicting with each
other (ie. the "break" in the last case entry is not needed, but it's
there for consistency).  Your change indeed makes the code look cleaner,
so I think the "keep-the-break-in-the-default-case" rule should win
here. ;)

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
 


-- 
Cheers,
Luca.


