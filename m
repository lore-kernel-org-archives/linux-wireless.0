Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbeCTIa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 04:30:57 -0400
Date: Tue, 20 Mar 2018 09:30:55 +0100
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
Subject: Re: [PATCH v3 19/20] firmware: add request_firmware_cache() to help
 with cache on reboot
Message-ID: <20180320083055.GA21640@kroah.com> (sfid-20180320_093113_492870_F03B92C1)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-20-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180310141501.2214-20-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 06:15:00AM -0800, Luis R. Rodriguez wrote:
> Some devices have an optimization in place to enable the firmware to
> be retaineed during a system reboot, so after reboot the device can skip
> requesting and loading the firmware. This can save up to 1s in load
> time. The mt7601u 802.11 device happens to be such a device.
> 
> When these devices retain the firmware on a reboot and then suspend
> they can miss looking for the firmware on resume. To help with this we
> need a way to cache the firmware when such an optimization has taken
> place.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  .../driver-api/firmware/request_firmware.rst       | 14 +++++++++++++
>  drivers/base/firmware_loader/main.c                | 24 ++++++++++++++++++++++
>  include/linux/firmware.h                           |  3 +++
>  3 files changed, 41 insertions(+)
> 
> diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
> index cc0aea880824..b554f4338859 100644
> --- a/Documentation/driver-api/firmware/request_firmware.rst
> +++ b/Documentation/driver-api/firmware/request_firmware.rst
> @@ -44,6 +44,20 @@ request_firmware_nowait
>  .. kernel-doc:: drivers/base/firmware_class.c
>     :functions: request_firmware_nowait
>  
> +Special optimizations on reboot
> +===============================
> +
> +Some devices have an optimization in place to enable the firmware to be
> +retained during system reboot. When such optimizations are used the driver
> +author must ensure the firmware is still available on resume from suspend,
> +this can be done with request_firmware_cache() insted of requesting for the
> +firmare to be loaded.
> +
> +request_firmware_cache()
> +-----------------------
> +.. kernel-doc:: drivers/base/firmware_class.c
> +   :functions: request_firmware_load
> +
>  request firmware API expected driver use
>  ========================================
>  
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index 2913bb0e5e7b..04bf853f60e9 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -656,6 +656,30 @@ int request_firmware_direct(const struct firmware **firmware_p,
>  }
>  EXPORT_SYMBOL_GPL(request_firmware_direct);
>  
> +/**
> + * request_firmware_cache: - cache firmware for suspend so resume can use it
> + * @name: name of firmware file
> + * @device: device for which firmware should be cached for
> + *
> + * There are some devices with an optimization that enables the device to not
> + * require loading firmware on system reboot. This optimization may still
> + * require the firmware present on resume from suspend. This routine can be
> + * used to ensure the firmware is present on resume from suspend in these
> + * situations. This helper is not compatible with drivers which use
> + * request_firmware_into_buf() or request_firmware_nowait() with no uevent set.
> + **/
> +int request_firmware_cache(struct device *device, const char *name)
> +{
> +	int ret;
> +
> +	mutex_lock(&fw_lock);
> +	ret = fw_add_devm_name(device, name);
> +	mutex_unlock(&fw_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(request_firmware_cache);

I know you are just following the existing naming scheme, but please
let's not continue the problem here.  Can you prefix all of the firmware
exported symbols with "firmware_", and then the verb.  So this would be
"firmware_request_cache", and the older function would be
"firmware_request_direct".

I've stopped here in the patch series, applying the others now, so feel
free to rebase and resend what I've missed, and the minor fixups for the
prior patches.

thanks,

greg k-h
