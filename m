Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34976 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbeB0RDw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 12:03:52 -0500
Received: by mail-wr0-f193.google.com with SMTP id l43so25656959wrc.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 09:03:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 27 Feb 2018 09:03:50 -0800
Message-ID: <CALLGbRL6D7bSrx-AVEoCfrSCg6_C4LfWcC-Yh1e14-DpsX3Ggw@mail.gmail.com> (sfid-20180227_180358_039404_30CDDE19)
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 26, 2018 at 12:44 AM, <s.gottschall@dd-wrt.com> wrote:
>
> From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
>
> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 based chipsets with on chipset connected led's
> using WMI Firmware API.
> The LED device will get available named as "ath10k-phyX" at sysfs and can be controlled with various triggers.
> adds also debugfs interface for gpio control.
>
> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>
> v2  add correct gpio count per chipset and remove IPQ4019 support since this chipset does not make use of specific gpios)
> v5  fix compiling without LED_CLASS and GPIOLIB support, fix also error by kbuild test robot which does not occur in standard builds. curious
> v6  correct return values and fix comment style
> v7  fix ath10k_unregister_led for compiling without LED_CLASS
> v8  fix various code design issues reported by reviewers
> v9  move led and led code to separate sourcefile (gpio.c)
> v10 compile fix if gpiolib isnt included
> v11 make register_gpio_chip static. advise by krobot
> v12 fix warning
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig   |  10 ++
>  drivers/net/wireless/ath/ath10k/Makefile  |   1 +
>  drivers/net/wireless/ath/ath10k/core.c    |  28 ++++-
>  drivers/net/wireless/ath/ath10k/core.h    |  62 +++++++++-
>  drivers/net/wireless/ath/ath10k/debug.c   | 146 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/gpio.c    | 196 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.h      |   2 +
>  drivers/net/wireless/ath/ath10k/mac.c     |   5 +
>  drivers/net/wireless/ath/ath10k/wmi-ops.h |  36 +++++-
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c |  65 ++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c     |  46 +++++++
>  drivers/net/wireless/ath/ath10k/wmi.h     |  36 ++++++
>  12 files changed, 630 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath10k/gpio.c


Assuming that kbuild robot doesn't kick back another build-time
warning, it looks OK to me.

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
