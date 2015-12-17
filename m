Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51407 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687AbbLQPEg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 10:04:36 -0500
Message-ID: <1450364668.8247.34.camel@sipsolutions.net> (sfid-20151217_160456_269933_F38BE039)
Subject: Re: [PATCH 1/1] mac80211: improve the contiguous mask checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Thu, 17 Dec 2015 16:04:28 +0100
In-Reply-To: <1450364392-76874-1-git-send-email-zhaoxiu.zeng@gmail.com> (sfid-20151217_160054_877867_44DDA348)
References: <1450364392-76874-1-git-send-email-zhaoxiu.zeng@gmail.com>
	 (sfid-20151217_160054_877867_44DDA348)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 22:59 +0800, Zeng Zhaoxiu wrote:
> If the result of adding the first set bit to the mask is power of 2,
> the mask must be contiguous. "mask & -mask" can get the first set bit
> of mask gracefully.

> -		if (__ffs64(mask) + hweight64(mask) != fls64(mask))
> {
> +		inc = (mask & -mask);
> +		val = mask + inc;
> +		if ((val & (val - 1)) != 0) {
>  			/* not a contiguous mask ... not handled now! */

Hm. Ok, I can see how that would work, but it doesn't really seem like
much of an "improvement" to me? Surely I seem to need much more
thinking to understand this. There's no reason to optimise it either,
so why should we change it?

johannes
