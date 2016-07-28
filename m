Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35499 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbcG1Sdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 14:33:47 -0400
Date: Thu, 28 Jul 2016 11:33:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160728183343.GD16852@dtor-ws> (sfid-20160728_203404_977898_843176F0)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469692512-16863-8-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 
> Loading firmware is an operation many drivers implement in various ways
> around the completion API. And most of them do it almost in the same
> way. Let's reuse the firmware_stat API which is used also by the
> firmware_class loader. Apart of streamlining the firmware loading states
> we also document it slightly better.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> ---
>  drivers/input/misc/ims-pcu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
> index 9c0ea36..cda1fbf 100644
> --- a/drivers/input/misc/ims-pcu.c
> +++ b/drivers/input/misc/ims-pcu.c
> @@ -109,7 +109,7 @@ struct ims_pcu {
>  
>  	u32 fw_start_addr;
>  	u32 fw_end_addr;
> -	struct completion async_firmware_done;
> +	struct firmware_stat fw_st;
>  
>  	struct ims_pcu_buttons buttons;
>  	struct ims_pcu_gamepad *gamepad;
> @@ -940,7 +940,7 @@ static void ims_pcu_process_async_firmware(const struct firmware *fw,
>  	release_firmware(fw);
>  
>  out:
> -	complete(&pcu->async_firmware_done);
> +	fw_loading_done(pcu->fw_st);

Why does the driver have to do it? If firmware loader manages this, then
it should let waiters know when callback finishes. 

>  }
>  
>  /*********************************************************************
> @@ -1967,7 +1967,7 @@ static int ims_pcu_init_bootloader_mode(struct ims_pcu *pcu)
>  					ims_pcu_process_async_firmware);
>  	if (error) {
>  		/* This error is not fatal, let userspace have another chance */
> -		complete(&pcu->async_firmware_done);
> +		fw_loading_abort(pcu->fw_st);

Why should the driver signal abort if it does not manage completion in
this case?

>  	}
>  
>  	return 0;
> @@ -1976,7 +1976,7 @@ static int ims_pcu_init_bootloader_mode(struct ims_pcu *pcu)
>  static void ims_pcu_destroy_bootloader_mode(struct ims_pcu *pcu)
>  {
>  	/* Make sure our initial firmware request has completed */
> -	wait_for_completion(&pcu->async_firmware_done);
> +	fw_loading_wait(pcu->fw_st);
>  }
>  
>  #define IMS_PCU_APPLICATION_MODE	0
> @@ -2000,7 +2000,7 @@ static int ims_pcu_probe(struct usb_interface *intf,
>  	pcu->bootloader_mode = id->driver_info == IMS_PCU_BOOTLOADER_MODE;
>  	mutex_init(&pcu->cmd_mutex);
>  	init_completion(&pcu->cmd_done);
> -	init_completion(&pcu->async_firmware_done);
> +	firmware_stat_init(&pcu->fw_st);

Do not quite like it... I'd rather asynchronous request give out a
firmware status pointer that could be used later on.

	pcu->fw_st = request_firmware_async(IMS_PCU_FIRMWARE_NAME,
					    pcu,
					    ims_pcu_process_async_firmware);
	if (IS_ERR(pcu->fw_st))
		return PTR_ERR(pcu->fw_st);

	....

	fw_loading_wait(pcu->fw_st);

Thanks.

-- 
Dmitry
