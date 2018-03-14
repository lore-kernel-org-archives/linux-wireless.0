Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbeCNSxs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 14:53:48 -0400
Date: Wed, 14 Mar 2018 19:53:47 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 05/20] firmware: simplify
 CONFIG_FW_LOADER_USER_HELPER_FALLBACK further
Message-ID: <20180314185347.GA15837@kroah.com> (sfid-20180314_195414_587732_CB74FE93)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180310141501.2214-6-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 06:14:46AM -0800, Luis R. Rodriguez wrote:
> All CONFIG_FW_LOADER_USER_HELPER_FALLBACK really is, is just a bool,
> initailized at build time. Define it as such. This simplifies the
> logic even further, removing now all explicit #ifdefs around the code.
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  drivers/base/firmware_loader.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
> index 7dd36ace6152..59dba794ce1a 100644
> --- a/drivers/base/firmware_loader.c
> +++ b/drivers/base/firmware_loader.c
> @@ -266,6 +266,22 @@ static inline bool fw_state_is_aborted(struct fw_priv *fw_priv)
>  
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
>  
> +/**
> + * struct firmware_fallback_config - firmware fallback configuratioon settings
> + *
> + * Helps describe and fine tune the fallback mechanism.
> + *
> + * @force_sysfs_fallback: force the sysfs fallback mechanism to be used
> + * 	as if one had enabled CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y.
> + */
> +struct firmware_fallback_config {
> +	bool force_sysfs_fallback;
> +};

This is C, why are you messing around with a structure and "getters and
setters" for a set of simple values?

> +static const struct firmware_fallback_config fw_fallback_config = {
> +	.force_sysfs_fallback = IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK),
> +};

static bool force_sysfs_fallback = IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK);

Then just read/write the foolish thing, don't make this more complex
than is needed please.

There is a "getter and setters are evil" rant somewhere out there
online, if you really need me to dig up the old tired arguments :)

thanks,

greg k-h



> +
>  static inline bool fw_sysfs_done(struct fw_priv *fw_priv)
>  {
>  	return __fw_state_check(fw_priv, FW_STATUS_DONE);
> @@ -1151,19 +1167,14 @@ static int fw_load_from_user_helper(struct firmware *firmware,
>  	return ret;
>  }
>  
> -#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> -static bool fw_force_sysfs_fallback(unsigned int opt_flags)
> -{
> -	return true;
> -}
> -#else
>  static bool fw_force_sysfs_fallback(unsigned int opt_flags)
>  {
> +	if (fw_fallback_config.force_sysfs_fallback)

Ok, you directly access it here, but your later patches get a lot more
"complex" it seems...

thanks,

greg k-h
