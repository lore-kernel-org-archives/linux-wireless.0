Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2252 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbXLQP3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 10:29:48 -0500
Date: Mon, 17 Dec 2007 10:02:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
Message-ID: <20071217150202.GC3121@tuxdriver.com> (sfid-20071217_152953_473148_6458FFA5)
References: <20071217012517.882216322@gmx.de>> <20071217012550.213561122@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071217012550.213561122@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2007 at 02:25:21AM +0100, Mattias Nissler wrote:

>  config MAC80211_RCPID
> -	bool "'PID' rate control algorithm" if EMBEDDED
> +	bool "'PID' rate control algorithm"

Shouldn't this keep the "if EMBEDDED"?  Especially if it is going to be the default?

> --- rt2x00.orig/net/mac80211/ieee80211_rate.c
> +++ rt2x00/net/mac80211/ieee80211_rate.c
> @@ -97,7 +97,7 @@ ieee80211_rate_control_ops_get(const cha
>  	struct rate_control_ops *ops;
>  
>  	if (!name)
> -		name = "simple";
> +		name = "pid";

As pointed-out elsewhere, we have no way to select "simple" (without
hacking and rebuilding a driver).  Perhaps a module option would
be appropriate?

> --- rt2x00.orig/Documentation/feature-removal-schedule.txt
> +++ rt2x00/Documentation/feature-removal-schedule.txt
> @@ -49,8 +49,8 @@ Why:	V4L1 AP1 was replaced by V4L2 API d
>  	Decoder iocts are using internally to allow video drivers to
>  	communicate with video decoders. This should also be improved to allow
>  	V4L2 calls being translated into compatible internal ioctls.
> -	Compatibility ioctls will be provided, for a while, via 
> -	v4l1-compat module. 
> +	Compatibility ioctls will be provided, for a while, via
> +	v4l1-compat module.
>  Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
>  
>  ---------------------------
> @@ -308,7 +308,7 @@ Who:	Roland Dreier <rolandd@cisco.com>
>  What:   sk98lin network driver
>  When:   Feburary 2008
>  Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
> -	replaced by the skge driver. 
> +	replaced by the skge driver.
>  Who:    Stephen Hemminger <shemminger@linux-foundation.org>
>  
>  ---------------------------
> @@ -343,10 +343,19 @@ Who:	John W. Linville <linville@tuxdrive
>  
>  ---------------------------
>  
> -What:	iee80211 softmac wireless networking component
> +What:	ieee80211 softmac wireless networking component
>  When:	2.6.26 (or after removal of bcm43xx and port of zd1211rw to mac80211)
>  Files:	net/ieee80211/softmac
>  Why:	No in-kernel drivers will depend on it any longer.
>  Who:	John W. Linville <linville@tuxdriver.com>

These typo fixes seem fine, but they should be in a seperate patch.

I can manipulate the feature removal bits if you don't want to bother
with resubmitting.  Any thoughts on the other comments?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
