Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34841 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab0JHLvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 07:51:21 -0400
Subject: Re: [PATCH 01/03] wl1271: BA Initiator support, Add Definitions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286456762-17480-2-git-send-email-shahar_levi@ti.com>
References: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
	 <1286456762-17480-2-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 14:51:16 +0300
Message-ID: <1286538676.21349.106.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 15:06 +0200, ext Shahar Levi wrote:
> New acx cmd wl1271_acx_ba_session_policy to set BA policy to the FW.
> Macros to use with BA setting.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

You can merge this patch with the next patch, no need to make the
changes first in the header files and then in the c files, since they go
very much hand in hand.


>  drivers/net/wireless/wl12xx/wl1271_acx.h  |   16 ++++++++++++++++
>  drivers/net/wireless/wl12xx/wl1271_conf.h |    3 +++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
> index b8da1bc..6c3c7c0 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
> @@ -1055,6 +1055,22 @@ struct wl1271_acx_ht_information {
>  	u8 padding[3];
>  } __packed;
>  
> +/*
> + * BA sessen interface structure
> + */

BA session.  Actually you can get rid of this comment, as it is obvious
from the name of the structure that this is about BA sessions.

> +struct wl1271_acx_ba_session_policy {
> +	struct acx_header header;
> +	/* Mac address of: SA as receiver / RA as initiator */
> +	u8 mac_address[ETH_ALEN];

Is this really SA for receiver and RA for initiator? Not SA and DA? Or
TA and RA?


> +	u8 tid;			/* TID */

Comment here is unnecessary.

> +	u8 policy;		/* Enable / Disable */

Could we change policy to enable here? Then the comment can go away too,
because the name of the element will be clear enough already.


> +	u16 win_size;		/* windows size in num of packet */

"number of packets"


> +	u16 inactivity_timeout;	/* as initiator inactivity timeout
> +				 * in time units(TU) of 1024us.
> +				 * as receiver reserved
> +				 */

The comment style is wrong.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
> index b3e608e..63a0a9a 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_conf.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
> @@ -94,6 +94,9 @@ enum {
>  #define HW_BG_RATES_MASK	0xffff
>  #define HW_HT_RATES_OFFSET	16
>  
> +#define BA_RECEIVER_WIN_SIZE 8
> +#define BA_INACTIVITY_TIMEOUT 10000

This should be added as a real configuration, like the other stuff in
the wl1271_conf.h file, which is then used in wl1271_main.c
default_conf.  Please define a struct conf_ba with win_size and
inactivity_timeout elements and set the actual values in the main file.


-- 
Cheers,
Luca.

