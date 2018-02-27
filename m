Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:41957 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbeB0X2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:28:23 -0500
Received: by mail-ua0-f195.google.com with SMTP id u99so373370uau.8
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 15:28:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180227232101.20786-2-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org> <20180227232101.20786-2-mcgrof@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Feb 2018 15:28:21 -0800
Message-ID: <CAGXu5jJwRU1mMH-erQmHLsrDgu1zmYOMrWiG_A_r3tksufLHDg@mail.gmail.com> (sfid-20180228_002841_797856_F65162E3)
Subject: Re: [RFT 1/7] rename: _request_firmware_load() fw_load_sysfs_fallback()
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
> This reflects much clearer what is being done.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  Documentation/driver-api/firmware/fallback-mechanisms.rst | 2 +-
>  drivers/base/firmware_fallback.c                          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/driver-api/firmware/fallback-mechanisms.rst
> index 4055ac76b288..f353783ae0be 100644
> --- a/Documentation/driver-api/firmware/fallback-mechanisms.rst
> +++ b/Documentation/driver-api/firmware/fallback-mechanisms.rst
> @@ -112,7 +112,7 @@ Since a device is created for the sysfs interface to help load firmware as a
>  fallback mechanism userspace can be informed of the addition of the device by
>  relying on kobject uevents. The addition of the device into the device
>  hierarchy means the fallback mechanism for firmware loading has been initiated.
> -For details of implementation refer to _request_firmware_load(), in particular
> +For details of implementation refer to fw_load_sysfs_fallback(), in particular
>  on the use of dev_set_uevent_suppress() and kobject_uevent().
>
>  The kernel's kobject uevent mechanism is implemented in lib/kobject_uevent.c,
> diff --git a/drivers/base/firmware_fallback.c b/drivers/base/firmware_fallback.c
> index 13fa5ff2b46c..ce7ccfe82c69 100644
> --- a/drivers/base/firmware_fallback.c
> +++ b/drivers/base/firmware_fallback.c
> @@ -536,7 +536,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>  }
>
>  /* load a firmware via user helper */

As long as this is being renamed, maybe add full kern-doc for this function?

-Kees

> -static int _request_firmware_load(struct fw_sysfs *fw_sysfs,
> +static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
>                                   unsigned int opt_flags, long timeout)
>  {
>         int retval = 0;
> @@ -621,7 +621,7 @@ static int fw_load_from_user_helper(struct firmware *firmware,
>         }
>
>         fw_sysfs->fw_priv = firmware->priv;
> -       ret = _request_firmware_load(fw_sysfs, opt_flags, timeout);
> +       ret = fw_load_sysfs_fallback(fw_sysfs, opt_flags, timeout);
>
>         if (!ret)
>                 ret = assign_fw(firmware, device, opt_flags);
> --
> 2.16.2
>



-- 
Kees Cook
Pixel Security
