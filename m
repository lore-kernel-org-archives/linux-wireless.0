Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbZISACV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 20:02:21 -0400
Date: Fri, 18 Sep 2009 17:02:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ar9170: implement frequency calibration for
 one-stage/openfw
Message-Id: <20090918170211.8acce2cc.akpm@linux-foundation.org>
In-Reply-To: <200909032025.31260.chunkeey@googlemail.com>
References: <200909032025.31260.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 3 Sep 2009 20:25:31 +0200
Christian Lamparter <chunkeey@googlemail.com> wrote:

> This patch ports some code from the vendor driver, which is
> supposed to upload the right calibration values for the
> chosen frequency.
> 
> In theory, this should give a better range and throughput
> for all users with the open, or one-stage firmware.
> 
> ...
>
> +		for (i = 0; i < 76; i++) {
> +			u32 phy_data;
> +			u8 tmp;
> +
> +			if (i < 25) {
> +				tmp = ar9170_interpolate_val(i, &pwrs[0][0],
> +							     &vpds[0][0]);
> +			} else {
> +				tmp = ar9170_interpolate_val(i - 12,
> +							     &pwrs[1][0],
> +							     &vpds[1][0]);
> +			}
> +
> +			phy_data |= tmp << ((i & 3) << 3);

Clearly buggy and the compiler warns.  The value of phy_data is unknown
here.

How did this get all the way into mainline?

