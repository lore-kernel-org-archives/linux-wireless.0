Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35532 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdCPNzT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 09:55:19 -0400
Subject: Re: [PATCH V4 1/2] firmware: add more flexible request_firmware_async
 function
To: Ming Lei <tom.leiming@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20170221094754.15406-1-zajec5@gmail.com>
 <20170223183018.16704-1-zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <f0451c04-cffe-ae1c-74de-38748da38272@gmail.com> (sfid-20170316_145548_240519_ACD58343)
Date: Thu, 16 Mar 2017 14:55:09 +0100
MIME-Version: 1.0
In-Reply-To: <20170223183018.16704-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2017 07:30 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> So far we got only one function for loading firmware asynchronously:
> request_firmware_nowait. It didn't allow much customization of firmware
> loading process - there is only one bool uevent argument. Moreover this
> bool also controls user helper in an unclear way.
>
> Resolve this problem by adding one internally shared  function that
> allows specifying any flags manually.
>
> This implementation:
> 1) Allows keeping old request_firmware_nowait API unchanged
> 2) Doesn't require adjusting / rewriting current drivers
> 3) Minimizes risk of regressions
> 4) Adds new function for drivers that need more control over loading a
>    firmware.
>
> The new function takes options struct pointer as an argument to make
> further improvements possible (without any big reworks).
>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V3: Don't expose all FW_OPT_* flags.
>     As Luis noted we want a struct so add struct firmware_opts for real
>     flexibility.
>     Thank you Luis for your review!
>
> Ming/Luis/Greg: assuming this gets a positive review, could someone of you pick
> this patchset?

Hi Ming,

It seems you changed e-mail address somewhere between V3 and V4 of this
patchset. Could you review/comment/ack this, please?

Luis: would you ack this patch now I followed your guidance?


> ---
>  drivers/base/firmware_class.c | 43 ++++++++++++++++++++++++++++++++++---------
>  include/linux/firmware.h      | 15 ++++++++++++++-
>  2 files changed, 48 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d05be1732c8b..b67b294eb31a 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1356,7 +1356,7 @@ static void request_firmware_work_func(struct work_struct *work)
>  	_request_firmware(&fw, fw_work->name, fw_work->device, NULL, 0,
>  			  fw_work->opt_flags);
>  	fw_work->cont(fw, fw_work->context);
> -	put_device(fw_work->device); /* taken in request_firmware_nowait() */
> +	put_device(fw_work->device); /* taken in __request_firmware_nowait() */
>
>  	module_put(fw_work->module);
>  	kfree_const(fw_work->name);
> @@ -1364,10 +1364,9 @@ static void request_firmware_work_func(struct work_struct *work)
>  }
>
>  /**
> - * request_firmware_nowait - asynchronous version of request_firmware
> + * __request_firmware_nowait - asynchronous version of request_firmware
>   * @module: module requesting the firmware
> - * @uevent: sends uevent to copy the firmware image if this flag
> - *	is non-zero else the firmware copy must be done manually.
> + * @opt_flags: flags that control firmware loading process, see FW_OPT_*
>   * @name: name of firmware file
>   * @device: device for which firmware is being loaded
>   * @gfp: allocation flags
> @@ -1386,9 +1385,9 @@ static void request_firmware_work_func(struct work_struct *work)
>   *
>   *		- can't sleep at all if @gfp is GFP_ATOMIC.
>   **/
> -int
> -request_firmware_nowait(
> -	struct module *module, bool uevent,
> +static int
> +__request_firmware_nowait(
> +	struct module *module, unsigned int opt_flags,
>  	const char *name, struct device *device, gfp_t gfp, void *context,
>  	void (*cont)(const struct firmware *fw, void *context))
>  {
> @@ -1407,8 +1406,7 @@ request_firmware_nowait(
>  	fw_work->device = device;
>  	fw_work->context = context;
>  	fw_work->cont = cont;
> -	fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
> -		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
> +	fw_work->opt_flags = FW_OPT_NOWAIT | opt_flags;
>
>  	if (!try_module_get(module)) {
>  		kfree_const(fw_work->name);
> @@ -1421,8 +1419,35 @@ request_firmware_nowait(
>  	schedule_work(&fw_work->work);
>  	return 0;
>  }
> +
> +int request_firmware_nowait(struct module *module, bool uevent,
> +			    const char *name, struct device *device, gfp_t gfp,
> +			    void *context,
> +			    void (*cont)(const struct firmware *fw, void *context))
> +{
> +	unsigned int opt_flags = FW_OPT_FALLBACK |
> +		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
> +
> +	return __request_firmware_nowait(module, opt_flags, name, device, gfp,
> +					 context, cont);
> +}
>  EXPORT_SYMBOL(request_firmware_nowait);
>
> +int __request_firmware_async(struct module *module, const char *name,
> +			     struct firmware_opts *fw_opts, struct device *dev,
> +			     void *context,
> +			     void (*cont)(const struct firmware *fw, void *context))
> +{
> +	unsigned int opt_flags = FW_OPT_UEVENT;
> +
> +	if (fw_opts->optional)
> +		opt_flags |= FW_OPT_NO_WARN;
> +
> +	return __request_firmware_nowait(module, opt_flags, name, dev,
> +					 GFP_KERNEL, context, cont);
> +}
> +EXPORT_SYMBOL(__request_firmware_async);
> +
>  #ifdef CONFIG_PM_SLEEP
>  static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
>
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index b1f9f0ccb8ac..a32b6e67462d 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -82,6 +82,19 @@ static inline int request_firmware_into_buf(const struct firmware **firmware_p,
>  {
>  	return -EINVAL;
>  }
> -
>  #endif
> +
> +struct firmware_opts {
> +	bool optional;
> +};
> +
> +int __request_firmware_async(struct module *module, const char *name,
> +			     struct firmware_opts *fw_opts, struct device *dev,
> +			     void *context,
> +			     void (*cont)(const struct firmware *fw, void *context));
> +
> +#define request_firmware_async(name, fw_opts, dev, context, cont)	\
> +	__request_firmware_async(THIS_MODULE, name, fw_opts, dev,	\
> +				 context, cont)
> +
>  #endif
>
