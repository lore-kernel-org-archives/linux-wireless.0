Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5421C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09E2222B7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KW5pxPWv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfBKOMS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:12:18 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:53827 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfBKOMS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:12:18 -0500
Received: by mail-it1-f193.google.com with SMTP id g85so26559815ita.3;
        Mon, 11 Feb 2019 06:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7F8iOswapPYd77PwaLJtcMSUtbMvO6i/bDB5sKUbSU=;
        b=KW5pxPWvIctmAjgKpd9aktcU/sTZEOF1WJImXcXTEEgCixJ2YTB+iF0gb/NSQSFwIM
         JYRE+SYsCGlPsg3mEvNSeJ1fmDoVC4M3sQPRqEm/dKP728wktt3WrCapCR2EPt55HObM
         2Y9LUIEq5a1qDwW/mBrhznPm8LxALeDknMb/EK4qyb/ssjdF0L/oS4nzraNGbcH/Mmp4
         FQGpG3jAbupotTdBvzJSZLb7+otvW6QpvDrpXtxl7+kDp+BjuJdABjmL6rRm9VHKilsU
         n9zy8B7d8xVdoZJesWv/+lopOUkv1rNOen7N2XmlNTTzTik7bJwdeLpX8pnas7zZPb36
         vBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7F8iOswapPYd77PwaLJtcMSUtbMvO6i/bDB5sKUbSU=;
        b=W5Cfo2z7j8vIplnQ8DSq3W7N3j7W1VW6pk5XMOS6s1AY8sJ84BJ4Nh3V4OuNM7XqQW
         2kl5NMbsAgii5K3ogg5RKUtHzfc3JfFm1uCDLelP9WDfnKmb1t4DDyJBLBQJG1V4x0O+
         WAPzzHo63kFL/wpGk7hKSSM5jbag+NmPFa7TiGnp7SLA1OnQgixSZMhawTbrz0TPlo1C
         IXVqHr+3cSS4l2ychUjZdn3iLRFrrB14QCcj4VOWSgt6vzGPA+HVtCjM0SvVmWrwJAeM
         CfazDfCMErvoqM4VRrOKpEB2neQ71LXHhONzAA03lfGCnurmOuApxx/ynahX+SStGLUk
         SO4A==
X-Gm-Message-State: AHQUAuaYbBUUKYmikTfTDCJdgQPNb3FRj0Mo4COrSCvTcKUPeQmeVY8+
        J9jayrkoitZ6gxkQprXKhcO6X1S1hpdTazC4TiWq/gfx
X-Google-Smtp-Source: AHgI3Ibbn3vnE64LaH6moqN7EBTTj9CVY3WMCEjbYfxxD83ZQyWuElKvORWvSIUwGThahtc+exYiKqn/qNYYq9ORWWY=
X-Received: by 2002:a24:7c44:: with SMTP id a65mr4029744itd.137.1549894337299;
 Mon, 11 Feb 2019 06:12:17 -0800 (PST)
MIME-Version: 1.0
References: <20190210195217.18817-1-lkundrak@v3.sk> <20190210195217.18817-4-lkundrak@v3.sk>
In-Reply-To: <20190210195217.18817-4-lkundrak@v3.sk>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 11 Feb 2019 06:11:40 -0800
Message-ID: <CALLGbRJvZrdg8+oGOkNxm+QNkBcCjTWkXvfG+rqbTc-2UMmNng@mail.gmail.com>
Subject: Re: [PATCH 3/3] libertas_tf: get the MAC address before registering
 the device
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
> The start() callback is too late for this: NetworkManager would already
> have seen the hardware, thinking 00:00:00:00:00:00 is its permanent
> address.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  .../net/wireless/marvell/libertas_tf/main.c   | 57 ++++---------------
>  1 file changed, 11 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
> index b4bd3047eb4e..da53da71987e 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/main.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/main.c
> @@ -125,37 +125,6 @@ static void lbtf_cmd_work(struct work_struct *work)
>         lbtf_deb_leave(LBTF_DEB_CMD);
>  }
>
> -/**
> - *  lbtf_setup_firmware: initialize firmware.
> - *
> - *  @priv    A pointer to struct lbtf_private structure
> - *
> - *  Returns: 0 on success.
> - */
> -static int lbtf_setup_firmware(struct lbtf_private *priv)
> -{
> -       int ret = -1;
> -
> -       lbtf_deb_enter(LBTF_DEB_FW);
> -       /*
> -        * Read priv address from HW
> -        */
> -       eth_broadcast_addr(priv->current_addr);
> -       ret = lbtf_update_hw_spec(priv);
> -       if (ret) {
> -               ret = -1;
> -               goto done;
> -       }
> -
> -       lbtf_set_mac_control(priv);
> -       lbtf_set_radio_control(priv);
> -
> -       ret = 0;
> -done:
> -       lbtf_deb_leave_args(LBTF_DEB_FW, "ret: %d", ret);
> -       return ret;
> -}
> -
>  /**
>   *  This function handles the timeout of command sending.
>   *  It will re-send the same command again.
> @@ -289,30 +258,17 @@ static void lbtf_tx_work(struct work_struct *work)
>  static int lbtf_op_start(struct ieee80211_hw *hw)
>  {
>         struct lbtf_private *priv = hw->priv;
> -       int ret = -1;
>
>         lbtf_deb_enter(LBTF_DEB_MACOPS);
>
> -       /* poke the firmware */
>         priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
>         priv->radioon = RADIO_ON;
>         priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
> -       ret = lbtf_setup_firmware(priv);
> -       if (ret)
> -               goto err_setup_firmware;
> -
> -       if ((priv->fwrelease < LBTF_FW_VER_MIN) ||
> -           (priv->fwrelease > LBTF_FW_VER_MAX)) {
> -               ret = -1;
> -               goto err_setup_firmware;
> -       }
> +       lbtf_set_mac_control(priv);
> +       lbtf_set_radio_control(priv);
>
>         lbtf_deb_leave(LBTF_DEB_MACOPS);
>         return 0;
> -
> -err_setup_firmware:
> -       lbtf_deb_leave_args(LBTF_DEB_MACOPS, "fw setup error; ret=%d", ret);
> -       return ret;
>  }
>
>  static void lbtf_op_stop(struct ieee80211_hw *hw)
> @@ -649,6 +605,15 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev,
>                 goto err_init_adapter;
>         }
>
> +       eth_broadcast_addr(priv->current_addr);
> +       if (lbtf_update_hw_spec(priv))
> +               goto err_init_adapter;
> +
> +       if (priv->fwrelease < LBTF_FW_VER_MIN ||
> +           priv->fwrelease > LBTF_FW_VER_MAX) {
> +               goto err_init_adapter;
> +       }
> +
>         /* The firmware seems to start with the radio enabled. Turn it
>          * off before an actual mac80211 start callback is invoked.
>          */
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
