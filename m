Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55918 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaIKKMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:12:32 -0400
Message-ID: <1410430345.22863.0.camel@jlt4.sipsolutions.net> (sfid-20140911_121253_851283_12F4FCA3)
Subject: Re: [PATCH v2] zd1211rw: replace ZD_ASSERT with
 lockdep_assert_held()
From: Johannes Berg <johannes@sipsolutions.net>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: dsd@gentoo.org, kune@deine-taler.de,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Date: Thu, 11 Sep 2014 12:12:25 +0200
In-Reply-To: <1410430179-19944-1-git-send-email-sanjeev_sharma@mentor.com> (sfid-20140911_121019_335368_163BEA7C)
References: <1410418407.1825.0.camel@jlt4.sipsolutions.net>
	 <1410430179-19944-1-git-send-email-sanjeev_sharma@mentor.com>
	 (sfid-20140911_121019_335368_163BEA7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 15:39 +0530, Sanjeev Sharma wrote:
> on some architecture spin_is_locked() always return false in
> uniprocessor configuration and therefore it would be advise
> to replace with lockdep_assert_held().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
> Changes in v2:
>   - corrected the typo

Now it compiles, but you got the logic wrong.

> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -235,7 +235,7 @@ void zd_mac_clear(struct zd_mac *mac)
>  {
>  	flush_workqueue(zd_workqueue);
>  	zd_chip_clear(&mac->chip);
> -	ZD_ASSERT(!spin_is_locked(&mac->lock));
> +	lockdep_assert_held(&mac->lock);
>  	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
>  }

Look closely at this again.

johannes

