Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750911AbeEDAAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 20:00:08 -0400
Date: Fri, 4 May 2018 00:00:06 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com, Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/9] firmware: add function to load firmware without
 warnings v5
Message-ID: <20180504000006.GO27853@wotan.suse.de> (sfid-20180504_020022_642490_AC12FB90)
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-6-andresx7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180423201205.20533-6-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2018 at 04:12:01PM -0400, Andres Rodriguez wrote:
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index db8351a42405..a34e16f77f20 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -42,6 +42,8 @@ struct builtin_fw {
>  #if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
>  int firmware_request(const struct firmware **fw, const char *name,
>  		     struct device *device);
> +int firmware_request_nowarn(const struct firmware **fw, const char *name,
> +			    struct device *device);
>  int firmware_request_nowait(
>  	struct module *module, bool uevent,
>  	const char *name, struct device *device, gfp_t gfp, void *context,

You also missed the firmware_request_nowarn() call on the #else. I'll add it
and re-submit myself.

In future patches about firmware please also Cc Mimi Zohar <zohar@linux.vnet.ibm.com>,
and Kees Cook <keescook@chromium.org>. You can also use the long list (modulo, not
the EFI list) that Hans used on his EFI patches. I realize its long but its just
to ensure enough folks get to review and eybeball the code.

  Luis
