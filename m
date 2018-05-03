Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60197 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbeECXmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 19:42:37 -0400
Date: Thu, 3 May 2018 23:42:35 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com, Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] firmware: print firmware name on fallback path
Message-ID: <20180503234235.GX27853@wotan.suse.de> (sfid-20180504_014254_002668_B0C56C66)
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-7-andresx7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180423201205.20533-7-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2018 at 04:12:02PM -0400, Andres Rodriguez wrote:
> Previously, one could assume the firmware name from the preceding
> message: "Direct firmware load for {name} failed with error %d".
> 
> However, with the new firmware_request_nowarn() entrypoint, the message
> outlined above will not always be printed.

I though the whole point was to not print an error message. What if
we want later to disable this error message? This would prove a bit
pointless.

Let's discuss the exact semantics desired here. Why would only the
fallback be desirable here?

Andres, Kalle?

After we address this I'll address resubmitting this lat patch
along with the last one. For now I'll skip it.

  Luis

> Therefore, we add the firmware name to the fallback path spew in order
> to associate it with the appropriate request.
> 
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>  drivers/base/firmware_loader/fallback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
> index e75928458489..1a47ddc70c31 100644
> --- a/drivers/base/firmware_loader/fallback.c
> +++ b/drivers/base/firmware_loader/fallback.c
> @@ -669,6 +669,6 @@ int fw_sysfs_fallback(struct firmware *fw, const char *name,
>  	if (!fw_run_sysfs_fallback(opt_flags))
>  		return ret;
>  
> -	dev_warn(device, "Falling back to user helper\n");
> +	dev_warn(device, "Falling back to user helper for %s\n", name);
>  	return fw_load_from_user_helper(fw, name, device, opt_flags);
>  }
> -- 
> 2.14.1
> 
> 

-- 
Do not panic
