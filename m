Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55231 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3FBXhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 19:37:09 -0400
Received: by mail-qa0-f45.google.com with SMTP id o13so1492089qaj.4
        for <linux-wireless@vger.kernel.org>; Sun, 02 Jun 2013 16:37:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370181183-11424-3-git-send-email-pizza@shaftnet.org>
References: <1370181183-11424-1-git-send-email-pizza@shaftnet.org> <1370181183-11424-3-git-send-email-pizza@shaftnet.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 3 Jun 2013 09:36:48 +1000
Message-ID: <CAGRGNgWrOj2QMzvvdVvVL16Cs64La_a5jx8Zpvp_9VH5u_Y8=w@mail.gmail.com> (sfid-20130603_013712_516788_9BBAC14B)
Subject: Re: [PATCH -next 3/3] cw1200: Replace use of 'struct resource' with
 'int' for GPIO fields.
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Solomon,

One very minor nit.

On Sun, Jun 2, 2013 at 11:53 PM, Solomon Peachy <pizza@shaftnet.org> wrote:
> The only advantage of 'struct resource' is that it lets us assign names
> as part of the platform data.  Unfortunately since we are using platform
> data, we are already limited to a single instance of each driver,
> rendering this moot.
>
> So, replace the struct resources with ints, resulting in cleaner code.
>
> This was based on a suggestion from Arnd Bergmann.
>
> Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
> ---
>  drivers/net/wireless/cw1200/cw1200_sagrad.c   | 49 +++-----------------------
>  drivers/net/wireless/cw1200/cw1200_sdio.c     | 50 ++++++++++++---------------
>  drivers/net/wireless/cw1200/cw1200_spi.c      | 33 ++++++++----------
>  include/linux/platform_data/cw1200_platform.h | 12 +++----
>  4 files changed, 47 insertions(+), 97 deletions(-)
>
> diff --git a/drivers/net/wireless/cw1200/cw1200_sagrad.c b/drivers/net/wireless/cw1200/cw1200_sagrad.c
> index 14c2a18..3f884ac 100644
> --- a/drivers/net/wireless/cw1200/cw1200_sagrad.c
> +++ b/drivers/net/wireless/cw1200/cw1200_sagrad.c
> @@ -68,9 +45,9 @@ static struct cw1200_platform_data_sdio cw1200_platform_data = {
>         .ref_clk = 38400,
>         .have_5ghz = false,
>  #if 0
> -       .reset = &cw1200_href_resources[0],
> -       .powerup = &cw1200_href_resources[1],
> -       .irq = &cw1200_href_resources[2],
> +       .reset = GPIO_RF_RESET, /* Replace as appropriate */
> +       .powerup = GPIO_RF_POWERUP, /* Replace as appropriate */
> +       .irq = GPIO_TO_IRQ(GPIO_RF_IRQ), /* Replace as appropriate */

You might want to mark these "Replace as appropriate" bits with a
comment at the start indicating that these need to be set for the
platform data or modified as appropriate. I haven't looked at the rest
of the driver, so you've probably documented this already, but it
can't hurt to say that twice.

Maybe:

/* If your device doesn't support Device Tree, you'll need to enable
 * this and set the GPIO pins as appropriate.
 */

Also, at least in Vim, if "XXX", "FIXME" or "TODO" appear in comments,
they get highlighted, so it might be worth adding one of those,
(probably "TODO") to the comments so that this is a touch easier to
find.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
