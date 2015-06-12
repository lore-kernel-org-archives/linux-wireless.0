Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbFLP0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 11:26:55 -0400
Date: Fri, 12 Jun 2015 08:26:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com
Subject: Re: [PATCH v3] staging: wilc1000: remove oswrapper & type file
Message-ID: <20150612152655.GA26174@kroah.com> (sfid-20150612_172659_227221_1F8B54E2)
References: <1434104471-5492-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434104471-5492-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 12, 2015 at 07:21:11PM +0900, Dean Lee wrote:
> remove OS Wrapper function(wilc_oswrapper.h) is in our plan.
> i removed OS Wrapper function and it's done.
> and i found wilc_type.h file is does not used it.
> so i deleted them and modify #include line in another file.

You are also doing other things here that you don't describe:

>  /* Errors will always get printed */
> -#define WILC_ERROR(...) do {  WILC_PRINTF("(ERR)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
> -			      WILC_PRINTF(__VA_ARGS__); \
> -				} while (0)
> +#define WILC_ERROR(...)							\
> +do {									\
> +	WILC_PRINTF("(ERR)(%s:%d)", __WILC_FUNCTION__, __WILC_LINE__);	\
> +	WILC_PRINTF(__VA_ARGS__);					\
> +} while (0)

You reformatted this.

>  #if (WILC_LOG_VERBOSITY_LEVEL > 3)
> -#define WILC_FN_IN do { WILC_PRINTF("(FIN) (%s:%d) \n", __WILC_FUNCTION__, __WILC_LINE__);  } while (0)
> -#define WILC_FN_OUT(ret) do { WILC_PRINTF("(FOUT) (%s:%d) %d.\n", __WILC_FUNCTION__, __WILC_LINE__, (ret));  } while (0)
> +#define WILC_FN_IN		\
> +	WILC_PRINTF("(FIN)(%s:%d)\n", __WILC_FUNCTION__, __WILC_LINE__)
> +#define WILC_FN_OUT(ret)	\
> +	WILC_PRINTF("(FOUT)(%s:%d)%d\n", __WILC_FUNCTION__, __WILC_LINE__, ret)

And changed this for no obvious reason.

Please, only do one thing per patch.  Break this up into logical steps
and resend it as a series of patches, with the last one being the TODO
file item removal.

thanks,

greg k-h
