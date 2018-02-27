Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:46483 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbeB0X3z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:29:55 -0500
Received: by mail-ua0-f196.google.com with SMTP id n48so367111uae.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 15:29:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180227232101.20786-3-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org> <20180227232101.20786-3-mcgrof@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Feb 2018 15:29:53 -0800
Message-ID: <CAGXu5jLxAPyBfzvM3izKYYjVz6P=7LQRkxNxUz1Cxwky1gPoUA@mail.gmail.com> (sfid-20180228_003014_492767_90B558FF)
Subject: Re: [RFT 2/7] firmware: fix checking for return values for fw_add_devm_name()
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: cantabile.desu@gmail.com, Jakub Kicinski <kubakici@wp.pl>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Martin Fuzzey <mfuzzey@parkeon.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, pali.rohar@gmail.com,
        Takashi Iwai <tiwai@suse.de>, arend.vanspriel@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        nbroeking@me.com, Vikram Mulukutla <markivx@codeaurora.org>,
        stephen.boyd@linaro.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 3:20 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> fw_add_devm_name() adds device's name onto the devres for the
> device so that prior to suspend we cache the firmware onto memory,
> so that on resume the firmware is reliably available. We never
> were checking for success for this call though, meaning in some
> really rare cases we my have never setup the firmware cache for
> a device, which could in turn make resume fail.
>
> This is all theoretical, no known issues have been reported.
> This small issue has been present way since the addition of the
> devres firmware cache names on v3.7.
>
> Fixes: f531f05ae9437 ("firmware loader: store firmware name into devres list")
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  drivers/base/firmware_loader.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
> index 21dd31ef08ae..48932581c70c 100644
> --- a/drivers/base/firmware_loader.c
> +++ b/drivers/base/firmware_loader.c
> @@ -431,6 +431,7 @@ int assign_fw(struct firmware *fw, struct device *device,
>               unsigned int opt_flags)
>  {
>         struct fw_priv *fw_priv = fw->priv;
> +       int ret;
>
>         mutex_lock(&fw_lock);
>         if (!fw_priv->size || fw_state_is_aborted(fw_priv)) {
> @@ -447,8 +448,13 @@ int assign_fw(struct firmware *fw, struct device *device,
>          */
>         /* don't cache firmware handled without uevent */
>         if (device && (opt_flags & FW_OPT_UEVENT) &&
> -           !(opt_flags & FW_OPT_NOCACHE))
> -               fw_add_devm_name(device, fw_priv->fw_name);
> +           !(opt_flags & FW_OPT_NOCACHE)) {
> +               ret = fw_add_devm_name(device, fw_priv->fw_name);
> +               if (ret && ret != 1) {

Why not if (ret < 0) ?

-Kees

> +                       mutex_unlock(&fw_lock);
> +                       return ret;
> +               }
> +       }
>
>         /*
>          * After caching firmware image is started, let it piggyback
> --
> 2.16.2
>



-- 
Kees Cook
Pixel Security
