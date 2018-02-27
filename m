Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:39420 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeB0XbM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:31:12 -0500
Received: by mail-ua0-f196.google.com with SMTP id e25so383327uam.6
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 15:31:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180227232101.20786-4-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org> <20180227232101.20786-4-mcgrof@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Feb 2018 15:31:11 -0800
Message-ID: <CAGXu5jL1mrZ6LqV0WKBY=w_kZzzcSrUD6Z5YqToSS2qmNaS4Fw@mail.gmail.com> (sfid-20180228_003118_038839_BB7210D7)
Subject: Re: [RFT 3/7] firmware: make fw_add_devm_name() return 0 if cache present
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
        Mark Brown <broonie@kernel.org>,
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
> Currently fw_add_devm_name() returns 1 if the firmware cache
> was already set. This makes it complicated for us to check for
> correctness. It is actually non-fatal if the firmware cache
> is already setup, so just return 0, and simplify the checkers.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

That'll teach me to read all the patches first. ;)

Honestly, I'd just fold this into the prior patch: there's only one
caller and it's exactly about checking the return value.

-Kees

> ---
>  drivers/base/firmware_loader.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
> index 48932581c70c..a385622bf3e1 100644
> --- a/drivers/base/firmware_loader.c
> +++ b/drivers/base/firmware_loader.c
> @@ -403,7 +403,7 @@ static int fw_add_devm_name(struct device *dev, const char *name)
>
>         fwn = fw_find_devm_name(dev, name);
>         if (fwn)
> -               return 1;
> +               return 0;
>
>         fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm),
>                            GFP_KERNEL);
> @@ -450,7 +450,7 @@ int assign_fw(struct firmware *fw, struct device *device,
>         if (device && (opt_flags & FW_OPT_UEVENT) &&
>             !(opt_flags & FW_OPT_NOCACHE)) {
>                 ret = fw_add_devm_name(device, fw_priv->fw_name);
> -               if (ret && ret != 1) {
> +               if (ret) {
>                         mutex_unlock(&fw_lock);
>                         return ret;
>                 }
> --
> 2.16.2
>



-- 
Kees Cook
Pixel Security
