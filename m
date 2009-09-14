Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54651 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbZINToL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 15:44:11 -0400
Received: by fg-out-1718.google.com with SMTP id 22so652630fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:44:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252956934.4696.23.camel@luzifer.localnet>
References: <1252956934.4696.23.camel@luzifer.localnet>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 14 Sep 2009 21:43:49 +0200
Message-ID: <69e28c910909141243i5551c87bsfd0c9e767cfa254@mail.gmail.com>
Subject: Re: [PATCH3]Add analog switch support
To: Thomas Ilnseher <illth@gmx.de>,
	John Linville <linville@tuxdriver.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always send patches to John Linville, and CC linux-wireless.

On Mon, Sep 14, 2009 at 9:35 PM, Thomas Ilnseher <illth@gmx.de> wrote:
> As I've seen Gàbor's patch, I noticed that my previous patch was
> bullshit. This patch should work:
>
> Signed-off-by: Thomas Ilnseher <illth@gmx.de>
>
> diff -uNr b/drivers/net/wireless/b43/phy_lp.c a/drivers/net/wireless/b43/phy_lp.c
> --- b/drivers/net/wireless/b43/phy_lp.c 2009-09-14 06:14:18.000000000 +0200
> +++ a/drivers/net/wireless/b43/phy_lp.c 2009-09-14 21:03:15.158507573 +0200
> @@ -2228,6 +2228,16 @@
>        return B43_TXPWR_RES_DONE;
>  }
>
> +void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
> +{
> +       if (on) {
> +               b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xfff8);
> +       } else {
> +               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x0007);
> +               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x0007);
> +       }
> +}
> +
>  const struct b43_phy_operations b43_phyops_lp = {
>        .allocate               = b43_lpphy_op_allocate,
>        .free                   = b43_lpphy_op_free,
> @@ -2239,7 +2249,7 @@
>        .radio_read             = b43_lpphy_op_radio_read,
>        .radio_write            = b43_lpphy_op_radio_write,
>        .software_rfkill        = b43_lpphy_op_software_rfkill,
> -       .switch_analog          = b43_phyop_switch_analog_generic,
> +       .switch_analog          = b43_lpphy_op_switch_analog,
>        .switch_channel         = b43_lpphy_op_switch_channel,
>        .get_default_chan       = b43_lpphy_op_get_default_chan,
>        .set_rx_antenna         = b43_lpphy_op_set_rx_antenna,
>
>
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
