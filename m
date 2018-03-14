Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbeCNSzP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 14:55:15 -0400
Date: Wed, 14 Mar 2018 19:55:14 +0100
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
Subject: Re: [PATCH v3 06/20] firmware: use helpers for setting up a
 temporary cache timeout
Message-ID: <20180314185514.GB15837@kroah.com> (sfid-20180314_195614_509297_EAE2B523)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-7-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180310141501.2214-7-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 06:14:47AM -0800, Luis R. Rodriguez wrote:
> We only use the timeout for the firmware fallback mechanism
> except for trying to set the timeout during the cache setup
> for resume/suspend. For those cases, setting the timeout should
> be a no-op, so just reflect this in code by adding helpers for it.
> 
> This change introduces no functional changes.
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  drivers/base/firmware_loader.c | 49 ++++++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
> index 59dba794ce1a..2d819875348d 100644
> --- a/drivers/base/firmware_loader.c
> +++ b/drivers/base/firmware_loader.c
> @@ -191,13 +191,6 @@ static inline bool fw_is_builtin_firmware(const struct firmware *fw)
>  }
>  #endif
>  
> -static int loading_timeout = 60;	/* In seconds */
> -
> -static inline long firmware_loading_timeout(void)
> -{
> -	return loading_timeout > 0 ? loading_timeout * HZ : MAX_JIFFY_OFFSET;
> -}
> -
>  static void fw_state_init(struct fw_priv *fw_priv)
>  {
>  	struct fw_state *fw_st = &fw_priv->fw_st;
> @@ -282,6 +275,32 @@ static const struct firmware_fallback_config fw_fallback_config = {
>  	.force_sysfs_fallback = IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK),
>  };
>  
> +static int old_timeout;
> +static int loading_timeout = 60;	/* In seconds */
> +
> +static inline long firmware_loading_timeout(void)
> +{
> +	return loading_timeout > 0 ? loading_timeout * HZ : MAX_JIFFY_OFFSET;
> +}
> +
> +/*
> + * use small loading timeout for caching devices' firmware because all these
> + * firmware images have been loaded successfully at lease once, also system is
> + * ready for completing firmware loading now. The maximum size of firmware in
> + * current distributions is about 2M bytes, so 10 secs should be enough.
> + */
> +static void fw_fallback_set_cache_timeout(void)
> +{
> +	old_timeout = loading_timeout;
> +	loading_timeout = 10;
> +}
> +
> +/* Restores the timeout to the value last configured during normal operation */
> +static void fw_fallback_set_default_timeout(void)
> +{
> +	loading_timeout =  old_timeout;

extra space?

Yeah, nit, I know :)
