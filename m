Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48285 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0GFPt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 11:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <1278376666-3509-5-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-5-git-send-email-ohad@wizery.com>
Date: Tue, 6 Jul 2010 18:49:24 +0300
Message-ID: <AANLkTilfjBIbylUDKlTGiEC_U6pJnkC6HoENOzK2eFFq@mail.gmail.com>
Subject: Re: [PATCH 04/15] mmc: support embedded data field in mmc_host
From: Grazvydas Ignotas <notasas@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 6, 2010 at 3:37 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> From: Ohad Ben-Cohen <ohadb@ti.com>
>
> Add support to set/get mmc_host private embedded
> data.
>
> This is needed to allow software to dynamically
> create (and remove) SDIO functions which represents
> embedded SDIO devices.
>
> Typically, it will be used to set the context of
> a driver that is creating a new SDIO function
> (and would then expect to be able to get that context
> back upon creation of the new sdio func).
>
> Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
> ---
>  drivers/mmc/core/Kconfig |    8 ++++++++
>  include/linux/mmc/host.h |   16 ++++++++++++++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> index bb22ffd..ab27eb3 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -16,3 +16,11 @@ config MMC_UNSAFE_RESUME
>
>          This option sets a default which can be overridden by the
>          module parameter "removable=0" or "removable=1".
> +
> +config MMC_EMBEDDED_SDIO
> +       boolean "MMC embedded SDIO device support"
> +       help
> +         If you say Y here, support will be added for embedded SDIO
> +         devices (e.g. hardwired embedded WLAN SDIO devices).
> +         Such devices require software support for emulating
> +         card detect events.
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f65913c..9a48486 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -209,6 +209,10 @@ struct mmc_host {
>        struct led_trigger      *led;           /* activity led */
>  #endif
>
> +#ifdef CONFIG_MMC_EMBEDDED_SDIO
> +       void                    *embedded_data;
> +#endif
> +

Hm, do we really need a Kconfig option just for a single pointer? It
only saves sizeof(void *) bytes per host, but adds rather confusing
config option for users and some ifdef complexity.
