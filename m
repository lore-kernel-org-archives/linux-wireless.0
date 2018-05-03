Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750930AbeECXgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 19:36:09 -0400
Date: Thu, 3 May 2018 23:36:08 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/9] firmware: add kernel-doc for enum fw_opt
Message-ID: <20180503233608.GT27853@wotan.suse.de> (sfid-20180504_013622_349121_61D85D95)
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-4-andresx7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180423201205.20533-4-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2018 at 04:11:59PM -0400, Andres Rodriguez wrote:
> Some basic definitions for the FW_OPT_* values
> 
> v2: Documentation corrections from Luis.

Likewise.

> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>  drivers/base/firmware_loader/firmware.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
> index b252bfa82295..a405d400a925 100644
> --- a/drivers/base/firmware_loader/firmware.h
> +++ b/drivers/base/firmware_loader/firmware.h
> @@ -11,6 +11,26 @@
>  
>  #include <generated/utsrelease.h>
>  
> +/**
> + * enum fw_opt - options to control firmware loading behaviour
> + *
> + * @FW_OPT_UEVENT: Enables the fallback mechanism to send a kobject uevent
> + *                  when the firmware is not found. Userspace is in charge
> + *                  to load the firmware using the sysfs loading facility.

The style here is a bit off. I'll just merge this patch with the last one
an change the style a bit to match expectations.

  Luis

> + * @FW_OPT_NOWAIT: Used to describe the firmware request is asynchronous.
> + * @FW_OPT_USERHELPER: Enable the fallback mechanism, in case the direct
> + *                     filesystem lookup fails at finding the firmware.
> + *                     For details refer to fw_sysfs_fallback().
> + * @FW_OPT_NO_WARN: Quiet, avoid printing warning messages.
> + * @FW_OPT_NOCACHE: Disables firmware caching. Firmware caching is used to
> + *                  cache the firmware upon suspend, so that upon resume
> + *                  races against the firmware file lookup on storage is
> + *                  avoided. Used for calls where the file may be too
> + *                  big, or where the driver takes charge of its own firmware
> + *                  caching mechanism.
> + * @FW_OPT_NOFALLBACK: Disable the fallback mechanism. Takes precedence over
> + *                     &FW_OPT_UEVENT and &FW_OPT_USERHELPER.
> + */
>  enum fw_opt {
>  	FW_OPT_UEVENT =         BIT(0),
>  	FW_OPT_NOWAIT =         BIT(1),
> -- 
> 2.14.1
> 
> 

-- 
Do not panic
