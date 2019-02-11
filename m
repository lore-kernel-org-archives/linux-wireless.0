Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4C3C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA94E222A5
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRyj/uj1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbfBKNsP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:48:15 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:52066 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfBKNsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 08:48:15 -0500
Received: by mail-it1-f193.google.com with SMTP id y184so20069204itc.1;
        Mon, 11 Feb 2019 05:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lU7XzI1+NUUCkc2QQXTdBpFx4U5t8JLxEN662tfkH/8=;
        b=nRyj/uj1U0XpT5NVTdru444k5ZRGhvgaERY/j6xoCLBI9En9Z98V6tcNeCHVuIefVU
         x2YJrJxE086UnX1/zaPbsifcmApXp0yL13WOc/RjBf0fDMkGflQHQNAlHQnTVHbf83F5
         6ivMHmq2s19Xi5nnZ99+niBsi8+zJ+UkiBf2Jx7RnyAxU6OqA5Rx6t+hKcG66L5dEwBe
         rQTU/mXYPBeXhmn9x3R7pwnEn6Dzd1yINsJmTwSTDO6tuJwgL3FxSOUrUiS7L9lTilIA
         YbN4mgQAmjeHch1uVZJlftXRxXHvwqMfi4vgT0W8rpXAkkdZlO5bAjVwcr52rDmId2f8
         2thA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lU7XzI1+NUUCkc2QQXTdBpFx4U5t8JLxEN662tfkH/8=;
        b=Kx7y4viSli6ERHeKLARPguYKZ3GEhewbRqDvxAtcvKcSe1EzqBAyKY2KRWxe3QlOv0
         MdAtQ3AGz7dTROlmpME0bi0MJQVUu+++iAXb1KjJoQQuv5lZZZMTR8BdkVNNsP5bnMSY
         CBCrGQ4wFQnDqulRi9jyLg3eM2BIP3y3DSTUnQ/KLCrgoTy/o5dQV/dp/FgjFJ24U4wS
         /URaLki4yDrrlOtDNpFEWkSMzt63KVRYCzUV38H4pGIqoEXDYbRLLoEuw2bk/+62k9T9
         bLa4z5kLeJbhoI7q+nlO+Cbj16hfjDrpucZptxF2Dv+kqThEsm4W45aC/JCw9P2X6mPX
         xmVg==
X-Gm-Message-State: AHQUAuYIBQTFIo8jrlKsbBRQIA+bntcLBH3QJkXM5grXVVd48ewHxOxX
        D7IgRvX5FTEOd6oOnI44YVuVY0F0GmCK9C5+uzU=
X-Google-Smtp-Source: AHgI3Iap4ICxG2SQqen8FGi7zWs3wtE5e1RuT/Fe6SK+ESk3QJnUSeZYmkcXQfR6qcbtPSJqoXusI/TSdh5uMBklnMw=
X-Received: by 2002:a02:8561:: with SMTP id g88mr17480876jai.68.1549892894176;
 Mon, 11 Feb 2019 05:48:14 -0800 (PST)
MIME-Version: 1.0
References: <20190210195217.18817-1-lkundrak@v3.sk> <20190210195217.18817-2-lkundrak@v3.sk>
In-Reply-To: <20190210195217.18817-2-lkundrak@v3.sk>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 11 Feb 2019 05:47:37 -0800
Message-ID: <CALLGbRJN-gDA5nDCfZdH-SYhUgPCa7AegutGBOSYnZaoKW7NXQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] libertas_tf: move hardware callbacks to a separate structure
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 11:52 AM Lubomir Rintel <lkundrak@v3.sk> wrote:
>
> We'll need to talk to the firmware to get a hardware address before
> device is registered with ieee80211 subsystem at the end of
> lbtf_add_card(). Hooking the callbacks after that is too late.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/net/wireless/marvell/libertas_tf/cmd.c  |  2 +-
>  .../net/wireless/marvell/libertas_tf/if_usb.c   | 12 +++++++-----
>  .../wireless/marvell/libertas_tf/libertas_tf.h  | 17 +++++++++++------
>  drivers/net/wireless/marvell/libertas_tf/main.c | 10 ++++++----
>  4 files changed, 25 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net/wireless/marvell/libertas_tf/cmd.c
> index 64b147dd2432..130f578daafd 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
> @@ -256,7 +256,7 @@ static void lbtf_submit_command(struct lbtf_private *priv,
>                      command, le16_to_cpu(cmd->seqnum), cmdsize);
>         lbtf_deb_hex(LBTF_DEB_CMD, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
>
> -       ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
> +       ret = priv->ops->hw_host_to_card(priv, MVMS_CMD, (u8 *)cmd, cmdsize);
>         spin_unlock_irqrestore(&priv->driver_lock, flags);
>
>         if (ret) {
> diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> index 6ede6168bd85..7a5a1a85dcf7 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> @@ -131,6 +131,12 @@ static void if_usb_fw_timeo(struct timer_list *t)
>         lbtf_deb_leave(LBTF_DEB_USB);
>  }
>
> +static const struct lbtf_ops if_usb_ops = {
> +       .hw_host_to_card = if_usb_host_to_card,
> +       .hw_prog_firmware = if_usb_prog_firmware,
> +       .hw_reset_device = if_usb_reset_device,
> +};
> +
>  /**
>   *  if_usb_probe - sets the configuration values
>   *
> @@ -216,15 +222,11 @@ static int if_usb_probe(struct usb_interface *intf,
>                 goto dealloc;
>         }
>
> -       priv = lbtf_add_card(cardp, &udev->dev);
> +       priv = lbtf_add_card(cardp, &udev->dev, &if_usb_ops);
>         if (!priv)
>                 goto dealloc;
>
>         cardp->priv = priv;
> -
> -       priv->hw_host_to_card = if_usb_host_to_card;
> -       priv->hw_prog_firmware = if_usb_prog_firmware;
> -       priv->hw_reset_device = if_usb_reset_device;
>         cardp->boot2_version = udev->descriptor.bcdDevice;
>
>         usb_get_dev(udev);
> diff --git a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
> index ad77b92d0b41..11d5ff68bc5e 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
> +++ b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
> @@ -173,10 +173,19 @@ struct channel_range {
>
>  struct if_usb_card;
>
> +struct lbtf_ops {
> +       /** Hardware access */
> +       int (*hw_host_to_card)(struct lbtf_private *priv, u8 type,
> +                              u8 *payload, u16 nb);
> +       int (*hw_prog_firmware)(struct if_usb_card *cardp);
> +       int (*hw_reset_device)(struct if_usb_card *cardp);
> +};
> +
>  /** Private structure for the MV device */
>  struct lbtf_private {
>         void *card;
>         struct ieee80211_hw *hw;
> +       const struct lbtf_ops *ops;
>
>         /* Command response buffer */
>         u8 cmd_resp_buff[LBS_UPLD_SIZE];
> @@ -188,11 +197,6 @@ struct lbtf_private {
>
>         struct work_struct cmd_work;
>         struct work_struct tx_work;
> -       /** Hardware access */
> -       int (*hw_host_to_card) (struct lbtf_private *priv, u8 type, u8 *payload, u16 nb);
> -       int (*hw_prog_firmware) (struct if_usb_card *cardp);
> -       int (*hw_reset_device) (struct if_usb_card *cardp);
> -
>
>         /** Wlan adapter data structure*/
>         /** STATUS variables */
> @@ -486,7 +490,8 @@ void lbtf_cmd_response_rx(struct lbtf_private *priv);
>  /* main.c */
>  struct chan_freq_power *lbtf_get_region_cfp_table(u8 region,
>         int *cfp_no);
> -struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev);
> +struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev,
> +                                  const struct lbtf_ops *ops);
>  int lbtf_remove_card(struct lbtf_private *priv);
>  int lbtf_start_card(struct lbtf_private *priv);
>  int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb);
> diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
> index f93b400db949..8ed3cd158cf5 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/main.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/main.c
> @@ -281,7 +281,7 @@ static void lbtf_tx_work(struct work_struct *work)
>         BUG_ON(priv->tx_skb);
>         spin_lock_irq(&priv->driver_lock);
>         priv->tx_skb = skb;
> -       err = priv->hw_host_to_card(priv, MVMS_DAT, skb->data, skb->len);
> +       err = priv->ops->hw_host_to_card(priv, MVMS_DAT, skb->data, skb->len);
>         spin_unlock_irq(&priv->driver_lock);
>         if (err) {
>                 dev_kfree_skb_any(skb);
> @@ -301,7 +301,7 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
>
>         if (!priv->fw_ready)
>                 /* Upload firmware */
> -               if (priv->hw_prog_firmware(card))
> +               if (priv->ops->hw_prog_firmware(card))
>                         goto err_prog_firmware;
>
>         /* poke the firmware */
> @@ -322,7 +322,7 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
>         return 0;
>
>  err_prog_firmware:
> -       priv->hw_reset_device(card);
> +       priv->ops->hw_reset_device(card);
>         lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programming fw; ret=%d", ret);
>         return ret;
>  }
> @@ -605,7 +605,8 @@ EXPORT_SYMBOL_GPL(lbtf_rx);
>   *
>   *  Returns: pointer to struct lbtf_priv.
>   */
> -struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
> +struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev,
> +                                  const struct lbtf_ops *ops)
>  {
>         struct ieee80211_hw *hw;
>         struct lbtf_private *priv = NULL;
> @@ -622,6 +623,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
>
>         priv->hw = hw;
>         priv->card = card;
> +       priv->ops = ops;
>         priv->tx_skb = NULL;
>
>         hw->queues = 1;
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
