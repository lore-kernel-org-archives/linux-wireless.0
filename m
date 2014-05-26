Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58352 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaEZJiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:38:23 -0400
Message-ID: <1401097086.29704.0.camel@jlt4.sipsolutions.net> (sfid-20140526_113843_501005_6DD5D97C)
Subject: Re: [regdb] Add support to parse 2000mW tx power
From: Johannes Berg <johannes@sipsolutions.net>
To: chaitanya.mgit@gmail.com
Cc: linville@tuxdriver.com, mcgrof@gmail.com,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Mon, 26 May 2014 11:38:06 +0200
In-Reply-To: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140526_093938_790284_7B77A8B1)
References: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20140526_093938_790284_7B77A8B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-26 at 13:09 +0530, chaitanya.mgit@gmail.com wrote:

> @@ -74,7 +74,7 @@ function parse_reg_rule()
>  			power = 23
>  		} else if (power == 500) {
>  			power = 27
> -		} else if (power == 1000) {
> +		} else if ((power == 1000) || (power == 2000)) {
>  			power = 30

This seems like a pretty sick thing to do to start with, and certainly
power=30 isn't right for 2000mW...

Can't awk calculate the logarithm?

johannes

