Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36706 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZKQSpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 13:45:33 -0500
Date: Tue, 17 Nov 2009 13:31:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] Adding radio type FM
Message-ID: <20091117183150.GA31701@tuxdriver.com>
References: <> <1258480113-20841-1-git-send-email-janakiram.sistla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258480113-20841-1-git-send-email-janakiram.sistla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 11:18:33PM +0530, Janakiram Sistla wrote:
> From: Janakiram Sistla <janakiram.sistla@gmail.com>
> 
> Adding radio type FM in RFKILL_TYPE_.FM belongs to
> same class of with both TX/RX capability.
> 
> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
> ---
>  include/linux/rfkill.h |    1 +
>  net/rfkill/core.c      |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 3392c59..03f5598 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -45,6 +45,7 @@ enum rfkill_type {
>  	RFKILL_TYPE_WIMAX,
>  	RFKILL_TYPE_WWAN,
>  	RFKILL_TYPE_GPS,
> +	RFKILL_TYPE_FM,
>  	NUM_RFKILL_TYPES,
>  };
>  
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index ba2efb9..61b716e 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -590,6 +590,8 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
>  		return "wimax";
>  	case RFKILL_TYPE_WWAN:
>  		return "wwan";
> +	case RFKILL_TYPE_FM:
> +		return "fm";
>  	case RFKILL_TYPE_GPS:
>  		return "gps";
>  	default:

My personal taste would dictate that you add the case statement
in the same place that you added the enum.  Depending on which
order you choose, you may need to change the BUILD_BUG_ON on line
601 of net/rfkill/core.c.  (Not sure how you managed to build w/
this patch...)

Also, when you add the enum you need to add the corresponding kerneldoc
(i.e. an @RFKILL_TYPE_FM comment) just above it.

Finally, please add "rfkill: " to the beginning of the subject line
when you resubmit your patch.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
