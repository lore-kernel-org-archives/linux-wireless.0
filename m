Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64968 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbZIPTlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 15:41:10 -0400
Received: by fxm17 with SMTP id 17so2531847fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 12:41:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253129879.2989.48.camel@note>
References: <1253129879.2989.48.camel@note>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 16 Sep 2009 21:40:52 +0200
Message-ID: <69e28c910909161240p7739edebi653b5d402a792856@mail.gmail.com>
Subject: Re: [PATCH 2/2] b43: Add lpphy_clear_tx_power_offsets to improve TX
	Power handling
To: Thomas Ilnseher <illth@gmx.de>
Cc: John Linville <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You are essentially implementing dead code at this point - this will
only ever be called if hardware-accelerated TX power control is
enabled - and HW TX power control is unsupported, even for G-PHYs.

On Wed, Sep 16, 2009 at 9:37 PM, Thomas Ilnseher <illth@gmx.de> wrote:
> This patch adds the lpphy_clear_tx_power_offsets to b43.
>
> Signed-off-by: Thomas Ilnseher <illth@gmx.de>
>
> ---
> diff -uNr a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> --- a/drivers/net/wireless/b43/phy_lp.c 2009-09-16 20:52:17.501318374 +0200
> +++ b/drivers/net/wireless/b43/phy_lp.c 2009-09-16 20:53:36.593319452 +0200
> @@ -1125,6 +1125,18 @@
>        dev->phy.lp->tssi_idx = (b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_STAT) & 0x7F00) >> 8;
>  }
>
> +static void lpphy_clear_tx_power_offsets(struct b43_wldev *dev)
> +{
> +       int i;
> +       int id = 7;
> +       if (dev->phy.rev < 2)
> +               id = 10;
> +       for (i = 0; i < 12; i++)
> +               b43_lptab_write(dev, B43_LPTAB32(id, 0x40 + i), 0);
> +       for (i = 0; i < 64; i++)
> +               b43_lptab_write(dev, B43_LPTAB32(id, 0x80 + i), 0);
> +}
> +
>  static void lpphy_set_tx_power_control(struct b43_wldev *dev,
>                                       enum b43_lpphy_txpctl_mode mode)
>  {
> @@ -1139,7 +1151,7 @@
>
>        if (oldmode == B43_LPPHY_TXPCTL_HW) {
>                lpphy_update_tx_power_npt(dev);
> -               //TODO Clear all TX Power offsets
> +               lpphy_clear_tx_power_offsets(dev);
>        } else {
>                if (mode == B43_LPPHY_TXPCTL_HW) {
>                        //TODO Recalculate target TX power
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
