Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1DOGzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 02:55:35 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20110415045321.GA11504@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 08:55:27 +0200
Message-ID: <1302850527.3572.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-15 at 10:23 +0530, Yogesh Ashok Powar wrote:
> When drivers use HW crypto, reservation for tail room is not needed for
> any crypto suite. Do not reserve tail room in such cases, this helps in
> optimizing the transmit path.
> 
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>

NACK.

>  	/*
> -	 * This could be optimised, devices that do full hardware
> -	 * crypto (including TKIP MMIC) need no tailroom... But we
> -	 * have no drivers for such devices currently.
> +	 * When full HW crypto is being used by the driver,
> +	 * no tail room is needed. Hence do not ask for tail room
> +	 * in such cases. This will avoid copying the skb in
> +	 * pskb_expand_head.
>  	 */
> -	if (may_encrypt) {
> +	if (!(local->hw.flags & IEEE80211_HW_CRYPTO_ENABLED) && may_encrypt) {

There's no need for this as a HW flag, and in its present form it is
EXTREMELY likely to be misused completely. And realise that even drivers
that implement HW crypto may need the extra tailroom for TKIP MMIC, so
your description of the flag is completely bogus.

You can implement the performance feature, but only by keeping track of
which keys need tailroom and skipping the code here once they are all
programmed into the device which will handle them including MMIC.

johannes

