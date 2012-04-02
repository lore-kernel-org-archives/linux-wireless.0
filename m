Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43086 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2DBMJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 08:09:14 -0400
Received: by pbcun15 with SMTP id un15so4460505pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 05:09:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
References: <1333365666-4413-1-git-send-email-sgruszka@redhat.com>
Date: Mon, 2 Apr 2012 14:09:14 +0200
Message-ID: <CAGXE3d8C61rnWPgRU565n_FjjKTqk4pi9ncmdjxyAmEvVM-uvA@mail.gmail.com> (sfid-20120402_140924_073073_6A48420C)
Subject: Re: [PATCH 1/2] rt2x00: configure different txdesc parameters for non
 HT channel
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Mon, Apr 2, 2012 at 1:21 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> This is needed when we are concted to non 11n AP.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00.h       |    1 +
>  drivers/net/wireless/rt2x00/rt2x00config.c |    5 +++++
>  drivers/net/wireless/rt2x00/rt2x00queue.c  |   14 ++++++++++++++
>  3 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 471f87c..8de9bfc 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -692,6 +692,7 @@ enum rt2x00_state_flags {
>         */
>        CONFIG_CHANNEL_HT40,
>        CONFIG_POWERSAVING,
> +       CONFIG_HT_DISABLED,
>
>        /*
>         * Mark we currently are sequentially reading TX_STA_FIFO register
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
> index 293676b..e7361d9 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -217,6 +217,11 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>        libconf.conf = conf;
>
>        if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL) {
> +               if (!conf_is_ht(conf))
> +                       set_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags);
> +               else
> +                       clear_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags);
> +
>                if (conf_is_ht40(conf)) {
>                        set_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
>                        hw_value = rt2x00ht_center_channel(rt2x00dev, conf);
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 9b1b2b7..f7403cf 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -320,6 +320,20 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>                txdesc->u.ht.wcid = sta_priv->wcid;
>        }
>
> +       if (test_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags)) {
> +               if (ieee80211_is_beacon(hdr->frame_control))
> +                       txdesc->u.ht.txop = TXOP_PIFS;

Why should we use PIFS for the beacon? Is that what the ralink drivers
are doing?

> +               else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
> +                       txdesc->u.ht.txop = TXOP_SIFS;
> +               else
> +                       txdesc->u.ht.txop = TXOP_BACKOFF;
> +
> +               txdesc->u.ht.mcs = txrate->idx;
> +

This lacks short preamble handling. Something like:

if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
  txdesc->u.ht.mcs |= 0x08;

Actually, you could just shuffle the code a bit such that the rate setup
happens before all the HT stuff, no?

Helmut
