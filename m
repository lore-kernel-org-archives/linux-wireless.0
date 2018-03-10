Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbeCJOfw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:35:52 -0500
MIME-Version: 1.0
In-Reply-To: <20180309230925.3573-1-andresx7@gmail.com>
References: <20180309221243.15489-2-andresx7@gmail.com> <20180309230925.3573-1-andresx7@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Sat, 10 Mar 2018 06:35:30 -0800
Message-ID: <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com> (sfid-20180310_153608_324455_29831731)
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
To: Andres Rodriguez <andresx7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, thanks for your patch!

On Fri, Mar 9, 2018 at 3:09 PM, Andres Rodriguez <andresx7@gmail.com> wrote:
> Currently the firmware loader only exposes one silent path for querying
> optional firmware, and that is request_firmware_direct(). This function
> also disables the usermodehelper fallback which might not always be the
> desired behaviour.

You should explain on the commit log how at least there is one driver
which needs full silence. Also FYI I think there are others who have
asked for the same before, on the 802.11 world. Kalle, Arend, do you
guys recall if it was a synchronous or async use case?

> This patch introduces request_firmware_optional(), which will not
> produce error/warning messages if the firmware file is not found, but

This looks good for a commit message so far modulo the above.

> will still attempt to query the usermodehelper

The "usermodehelper" is a loose term which I've been trying to fight
in the firmware API. Please refer to this as the fallback mechanism.
The usermode helper actually is kernel/umh.c and in so far as the
firmware API is concerned the kernel/umc.c is used only for the uevent
for the default fallback case. In the custom fallback case there is no
kernel/umc.c API use, and I'm now wondering if use of the UMH lock
doesn't make sense there and we should remove it.

> for the optional
> firmware. Effectively, FW_OPT_UEVENT | FW_OPT_FALLBACK | FW_OPT_NO_WARN.

Can you do me a favor? The above flags are not well documented at all.
I have a big sized cleanup for v4.17 on my , can you base your patch
on top of my tree, modify these flags to become enums, and in the
process kdocify them as part of your work? Refer to
include/uapi/linux/nl80211.h for a good example of how to properly
kdocify enums.

Please base your patch on top of my tree and branch
20180307-firmware-dev-for-v4.17 [0] and resubmit with the above and
below feedback into consideration. You also I take it have users in
mind? I'd like to see at least one user of the API or this fixing a
reported issue. Ie, if users have reported this as issues incorrectly,
referring to those incorrect posts as issues and how this created
confusion would help.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20180307-firmware-dev-for-v4.17

> v2: add header prototype, use updated opt_flags
>
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>
> Sorry, I messed up the v1 patch and sent the wrong one from before I
> rebased.
>
>  drivers/base/firmware_class.c | 26 +++++++++++++++++++++++++-
>  include/linux/firmware.h      |  2 ++
>  2 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 7dd36ace6152..4e1eddea241b 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1181,7 +1181,7 @@ static int fw_sysfs_fallback(struct firmware *fw, const char *name,
>         if (!fw_run_sysfs_fallback(opt_flags))
>                 return ret;
>
> -       dev_warn(device, "Falling back to user helper\n");
> +       dev_warn(device, "Falling back to user helper for %s\n", name);

This seems like it should be a separate patch, and it should be
justified, also please modify the language given what I said above
about kernel/umc.c API use. In so far as your actual change is
concerned for this print, *why* do we need another print with the
firmware name on it? The commit log should explain that very well in a
separate patch.

>         return fw_load_from_user_helper(fw, name, device, opt_flags);
>  }
>  #else /* CONFIG_FW_LOADER_USER_HELPER */
> @@ -1351,6 +1351,30 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>  }
>  EXPORT_SYMBOL(request_firmware);
>
> +/**
> + * request_firmware_optional: - request for an optional fw module
> + * @firmware_p: pointer to firmware image
> + * @name: name of firmware file
> + * @device: device for which firmware is being loaded
> + *
> + * This function is similar in behaviour to request_firmware(), except
> + * it doesn't produce warning messages when the file is not found.
> + **/
> +int
> +request_firmware_optional(const struct firmware **firmware_p, const char *name,
> +                         struct device *device)
> +{
> +       int ret;
> +
> +       /* Need to pin this module until return */
> +       __module_get(THIS_MODULE);
> +               ret = _request_firmware(firmware_p, name, device, NULL, 0,
> +                               FW_OPT_UEVENT | FW_OPT_NO_WARN );
> +       module_put(THIS_MODULE);
> +       return ret;
> +}
> +EXPORT_SYMBOL(request_firmware_optional);

New exported symbols for the firmware API should be EXPORT_SYMBOL_GPL().

  Luis
