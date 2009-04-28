Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47492 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZD1TA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 15:00:58 -0400
Date: Tue, 28 Apr 2009 14:57:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/5] rt2x00: Fix the interval for rfkill and link_tuner.
Message-ID: <20090428185709.GA3321@tuxdriver.com> (sfid-20090428_210102_765919_8FFB4F7C)
References: <200904261608.30384.IvDoorn@gmail.com> <200904261608.50411.IvDoorn@gmail.com> <200904261609.11447.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200904261609.11447.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 26, 2009 at 04:09:11PM +0200, Ivo van Doorn wrote:
> From: Alban Browaeys <prahal@yahoo.com>
> 
> extra parenthesis made the value an argument and the value of the
> define empty. This was triggering those very fast.
> 
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

???

If that were so, wouldn't that have caused compile-time errors?

John

> ---
>  drivers/net/wireless/rt2x00/rt2x00lib.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index aa284e4..747178c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -32,8 +32,8 @@
>   * Interval defines
>   * Both the link tuner as the rfkill will be called once per second.
>   */
> -#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
> -#define RFKILL_POLL_INTERVAL	( 1000 )
> +#define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
> +#define RFKILL_POLL_INTERVAL	1000
>  
>  /*
>   * rt2x00_rate: Per rate device information
> -- 
> 1.6.2.3
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
