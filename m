Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32967 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGXKyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:54:49 -0400
Message-ID: <1406199271.14675.10.camel@jlt4.sipsolutions.net> (sfid-20140724_125519_352167_B8180F6A)
Subject: Re: [PATCH] mac80211_hwsim: fix compiler warning on MIPS
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2014 12:54:31 +0200
In-Reply-To: <1406065431-20813-1-git-send-email-abrestic@chromium.org> (sfid-20140722_234503_746857_0630E11C)
References: <1406065431-20813-1-git-send-email-abrestic@chromium.org>
	 (sfid-20140722_234503_746857_0630E11C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-07-22 at 14:43 -0700, Andrew Bresticker wrote:
> The dividend in do_div() is expected to be an unsigned 64-bit integer,
> which leads to the following warning when building for 32-bit MIPS:
> 
>   drivers/net/wireless/mac80211_hwsim.c: In function 'mac80211_hwsim_set_tsf':
>   drivers/net/wireless/mac80211_hwsim.c:664:98: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>     data->bcn_delta = do_div(delta, bcn_int);
> 
> Since we care about the signedness of delta when adjusting tsf_offset
> and bcm_delta, use the absolute value for the division and compare
> the two timestamps to determine the sign.

Applied, thanks.

johannes

