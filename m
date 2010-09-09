Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab0IICGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 22:06:31 -0400
Received: by bwz11 with SMTP id 11so722197bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 19:06:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283988329-44549-6-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-6-git-send-email-steve@cozybit.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 12:06:10 +1000
Message-ID: <AANLkTimTgYmdrytn6_wdx_7HVX20nurdsJ=OqiSoGJLs@mail.gmail.com>
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in order
 to fetch MAC address
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More nits:

On Thu, Sep 9, 2010 at 09:25, Steve deRosier <steve@cozybit.com> wrote:
> mac80211 requires that the MAC address be known and set before calling
> ieee80211_register_hw().  If this isn't done, we see bad MAC addresses
> in our packet headers.  In order to make this happen, I had to restructure
> to have if_sdio_probe load the firmware and get the hardware specs.
>
> I had to add a if_sdio_update_hw_spec function as if_sdio can't use the standard
> command as several required variables aren't setup yet.
> if_sdio_update_hw_spec essentially uses polled io to get the hw spec
> command response from the card.
>
> Signed-off-by: Steve deRosier <steve@cozybit.com>
> ---
>  drivers/net/wireless/libertas_tf/if_sdio.c     |  263 ++++++++++++++++++++----
>  drivers/net/wireless/libertas_tf/libertas_tf.h |    2 +-
>  drivers/net/wireless/libertas_tf/main.c        |   38 +++--
>  3 files changed, 248 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
> index 1e72b4c..189b820 100644
> --- a/drivers/net/wireless/libertas_tf/if_sdio.c
> +++ b/drivers/net/wireless/libertas_tf/if_sdio.c
> @@ -91,12 +91,15 @@ struct if_sdio_card {
>        u8                      rx_unit;
>  };
>
> -static int if_sdio_enable_interrupts(struct lbtf_private *priv)
> +static int _if_sdio_enable_interrupts(struct if_sdio_card *card)
>  {
> -       struct if_sdio_card *card = priv->card;
>        int ret;
>
>        lbtf_deb_enter(LBTF_DEB_SDIO);
> @@ -109,9 +112,14 @@ static int if_sdio_enable_interrupts(struct lbtf_private *priv)
>        return (ret);
>  }
>
> -static int if_sdio_disable_interrupts(struct lbtf_private *priv)
> +static int if_sdio_enable_interrupts(struct lbtf_private *priv)
>  {
>        struct if_sdio_card *card = priv->card;
> +       return _if_sdio_enable_interrupts(card);
> +}
> +
> +static int _if_sdio_disable_interrupts(struct if_sdio_card *card)
> +{
>        int ret;
>
>        lbtf_deb_enter(LBTF_DEB_SDIO);
> @@ -124,6 +132,12 @@ static int if_sdio_disable_interrupts(struct lbtf_private *priv)
>        return (ret);
>  }
>
> +static int if_sdio_disable_interrupts(struct lbtf_private *priv)
> +{
> +       struct if_sdio_card *card = priv->card;
> +       return _if_sdio_disable_interrupts(card);
> +}
> +
>  /*
>  *  For SD8385/SD8686, this function reads firmware status after
>  *  the image is downloaded, or reads RX packet length when

Are these changes really necessary here? - It'd probably be cleaner to
change the initial functions to just take the card struct instead? (as
it's always available as priv->card)

I'm guessing you're going to do something with the _* versions of
these functions later, so should this change be there instead?

> @@ -187,7 +201,6 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
>        struct lbtf_private *priv = card->priv;
>        int ret;
>        unsigned long flags;
> -       u8 i;
>
>        lbtf_deb_enter(LBTF_DEB_SDIO);
>

Shouldn't this be elsewhere (maybe rolled into patch #1?)

> @@ -709,7 +726,6 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
>                if( lbtf_reset_fw == 0 ) {
>                        goto success;
>                } else {
> -                       int i = 0;
>                        lbtf_deb_sdio("attempting to reset and reload firmware\n");
>
>                        if_sdio_reset_device(card);

Ditto.

> @@ -846,7 +863,6 @@ static int if_sdio_enter_deep_sleep(struct lbtf_private *priv)
>
>  static int if_sdio_exit_deep_sleep(struct lbtf_private *priv)
>  {
> -       struct if_sdio_card *card = priv->card;
>        int ret = -1;
>
>        lbtf_deb_enter(LBTF_DEB_SDIO);

Ditto.

> @@ -857,14 +873,12 @@ static int if_sdio_exit_deep_sleep(struct lbtf_private *priv)
>
>  static int if_sdio_reset_deep_sleep_wakeup(struct lbtf_private *priv)
>  {
> -       struct if_sdio_card *card = priv->card;
>        int ret = -1;
>
>        lbtf_deb_enter(LBTF_DEB_SDIO);
>
>        lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
>        return ret;
> -
>  }
>
>  static void if_sdio_reset_device(struct if_sdio_card *card)

Ditto.

> diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
> index 119d625..14ce1bc 100644
> --- a/drivers/net/wireless/libertas_tf/main.c
> +++ b/drivers/net/wireless/libertas_tf/main.c
> @@ -150,14 +150,15 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
>        int ret = -1;
>
>        lbtf_deb_enter(LBTF_DEB_FW);
> +
>        /*
>         * Read priv address from HW
>         */
>        memset(priv->current_addr, 0xff, ETH_ALEN);
>        ret = lbtf_update_hw_spec(priv);
>        if (ret) {
> -               ret = -1;
> -               goto done;
> +                  ret = -1;
> +                  goto done;
>        }
>
>        lbtf_set_mac_control(priv);

Whitespace change noise.

> @@ -165,6 +166,7 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
>        lbtf_set_mode(priv, LBTF_PASSIVE_MODE);
>
>        ret = 0;
> +
>  done:
>        lbtf_deb_leave_args(LBTF_DEB_FW, "ret: %d", ret);
>        return ret;

And again.

> @@ -433,6 +437,7 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
>                lbtf_set_mac_address(priv, (u8 *) vif->addr);
>        }
>
> +
>        lbtf_deb_leave(LBTF_DEB_MACOPS);
>        return 0;
>  }

And again.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
