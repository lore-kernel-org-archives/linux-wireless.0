Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeCNTAk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 15:00:40 -0400
Date: Wed, 14 Mar 2018 20:00:39 +0100
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
Subject: Re: [PATCH v3 11/20] firmware: enable to force disable the fallback
 mechanism at run time
Message-ID: <20180314190039.GD15837@kroah.com> (sfid-20180314_200053_787911_96780478)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <20180310141501.2214-12-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180310141501.2214-12-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 06:14:52AM -0800, Luis R. Rodriguez wrote:
> You currently need four different kernel builds to test the firmware
> API fully. By adding a proc knob to force disable the fallback mechanism
> completely we are able to reduce the amount of kernels you need built
> to test the firmware API down to two.
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  drivers/base/firmware_loader/fallback.c       | 5 +++++
>  drivers/base/firmware_loader/fallback.h       | 4 ++++
>  drivers/base/firmware_loader/fallback_table.c | 9 +++++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
> index 45cc40933a47..d6838e7ec00c 100644
> --- a/drivers/base/firmware_loader/fallback.c
> +++ b/drivers/base/firmware_loader/fallback.c
> @@ -643,6 +643,11 @@ static bool fw_force_sysfs_fallback(unsigned int opt_flags)
>  
>  static bool fw_run_sysfs_fallback(unsigned int opt_flags)
>  {
> +	if (fw_fallback_config.ignore_sysfs_fallback) {
> +		pr_info_once("Ignoring firmware sysfs fallback due to debugfs knob\n");

s/debugfs/sysctl/ right?
