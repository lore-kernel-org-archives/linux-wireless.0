Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33081 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbbBWP5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 10:57:43 -0500
Message-ID: <1424707044.3075.14.camel@sipsolutions.net> (sfid-20150223_165746_579361_EFA13356)
Subject: Re: [PATCH v2] wext: Return -E2BIG when the buffer is too small for
 the full scan results, including IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: James Minor <james.minor@ni.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, xander.huff@ni.com, joshc@ni.com,
	joseph.hershberger@ni.com, ben.shelton@ni.com, jaeden.amero@ni.com,
	rich.tollerton@ni.com, brad.mouring@ni.com
Date: Mon, 23 Feb 2015 16:57:24 +0100
In-Reply-To: <1424382142-13346-1-git-send-email-james.minor@ni.com>
References: <54E6561F.4050109@ni.com>
	 <1424382142-13346-1-git-send-email-james.minor@ni.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-19 at 15:42 -0600, James Minor wrote:

> +#define CHECK_BUF_FULL(p, c, e)		       \
> +	do {                                   \
> +		if (unlikely(p == c))	       \
> +			e = -E2BIG;	       \
> +	} while (0)

I think this would be nicer as a static inline that returned -E2BIG, or
the passed in err, instead of modifying the macro argument.

johannes

