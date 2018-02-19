Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37639 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbeBSJWz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 04:22:55 -0500
Received: by mail-wm0-f67.google.com with SMTP id v71so13696779wmv.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2018 01:22:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180218164940.25451-1-s.gottschall@dd-wrt.com>
References: <20180218164940.25451-1-s.gottschall@dd-wrt.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 19 Feb 2018 20:22:33 +1100
Message-ID: <CAGRGNgXuzswWn=iFk=tdF9r=qZJqxf36dH_W0TSLTSD3Vynbcg@mail.gmail.com> (sfid-20180219_102302_486356_D88A8023)
Subject: Re: [PATCH] v6 ath10k: add LED and GPIO controlling support for
 various chipsets
To: s.gottschall@dd-wrt.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sebastian,

On Mon, Feb 19, 2018 at 3:49 AM,  <s.gottschall@dd-wrt.com> wrote:
> From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
>
> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 based chipsets with on chipset connected led's
> using WMI Firmware API.
> The LED device will get available named as "ath10k-phyX" at sysfs and can be controlled with various triggers.
> adds also debugfs interface for gpio control.

You should put the "v6" in the subject _inside_ the "[PATCH]" See the
"-v" option in git format-patch.

> v2  add correct gpio count per chipset and remove IPQ4019 support since this chipset does not make use of specific gpios)
> v5  fix compiling without LED_CLASS and GPIOLIB support, fix also error by kbuild test robot which does not occur in standard builds. curious
> v6  correct return values and fix comment style

The revisions should be between the first "---" and the diffstat.

> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> ---

I.e. here.

>  drivers/net/wireless/ath/ath10k/core.c    | 183 +++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/core.h    |  20 +++-
>  drivers/net/wireless/ath/ath10k/debug.c   | 146 ++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.h      |   2 +
>  drivers/net/wireless/ath/ath10k/mac.c     |   6 +
>  drivers/net/wireless/ath/ath10k/wmi-ops.h |  36 +++++-
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c |  65 +++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c     |  46 ++++++++
>  drivers/net/wireless/ath/ath10k/wmi.h     |  36 ++++++
>  9 files changed, 536 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index f3ec13b80b20..5ecda9242d33 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2132,12 +2148,148 @@ static int ath10k_core_reset_rx_filter(struct ath10k *ar)
> +/* register GPIO chip */
> +static int ath10k_register_gpio_chip(struct ath10k *ar)
> +{
> +       struct ath10k_gpiocontrol *gpio;
> +       gpio = kzalloc(sizeof(struct ath10k_gpiocontrol), GFP_KERNEL);
> +       if (!gpio) {
> +               return -ENOMEM;
> +       }
> +
> +       snprintf(gpio->label, sizeof(gpio->label), "ath10k-%s",
> +                wiphy_name(ar->hw->wiphy));
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,5,0)
> +       gpio->gchip.parent = ar->dev;
> +#else
> +       gpio->gchip.dev = ar->dev;
> +#endif

This is why the kbuild test bot is complaining: LINUX_VERSION_CODE is
not used in upstream code - it'll only ever be built on the current
version or newer and if there are any API changes they'll be handled
for you.

("But what about backporting?" if this code is backported, it'll most
likely be through the backports project and will be handled using this
script: https://git.kernel.org/pub/scm/linux/kernel/git/backports/backports.git/tree/patches/0002-gpio-parent.cocci
)

Removing these blocks will make the kbuild bot happy. Also,
checkpatch.pl should have complained about this.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
