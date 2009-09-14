Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33248 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522AbZINVHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 17:07:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Add LP PHY Analog Switch Support
Date: Mon, 14 Sep 2009 23:07:04 +0200
Cc: Thomas Ilnseher <illth@gmx.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1252962093.4696.45.camel@luzifer.localnet>
In-Reply-To: <1252962093.4696.45.camel@luzifer.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909142307.05860.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 September 2009 23:01:33 Thomas Ilnseher wrote:
> The current verison of b43 uses "b43_phyop_switch_analog_generic" for A,
> G and LP phys.
> 
> According to the spec, this is the wrong behaviour for the LP PHY
> (see: http://bcm-v4.sipsolutions.net/802.11/PHY/Anacore )
> 
> While no problems on the x86 plattform where seen, this leads to a crash
> on the BCM5354 SoC (MIPS 32 LE plattform).
> This patch implements the analog switch for LP PHYs according to the
> specs. It fixes the crash
> 
> signed-off-by: Thomas Ilnseher <illth@gmx.de>
> ---
> diff -uNr b/drivers/net/wireless/b43/phy_lp.c
> a/drivers/net/wireless/b43/phy_lp.c
> --- b/drivers/net/wireless/b43/phy_lp.c 2009-09-14 06:14:18.000000000 +0200
> +++ a/drivers/net/wireless/b43/phy_lp.c 2009-09-14 21:03:15.158507573 +0200
> @@ -2228,6 +2228,16 @@
>         return B43_TXPWR_RES_DONE;
>  }
>  
> +void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
> +{
> +       if (on) {
> +               b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xfff8);
> +       } else {
> +               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x0007);
> +               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x0007);
> +       }
> +}
> +
>  const struct b43_phy_operations b43_phyops_lp = {
>         .allocate               = b43_lpphy_op_allocate,
>         .free                   = b43_lpphy_op_free,
> @@ -2239,7 +2249,7 @@
>         .radio_read             = b43_lpphy_op_radio_read,
>         .radio_write            = b43_lpphy_op_radio_write,
>         .software_rfkill        = b43_lpphy_op_software_rfkill,
> -       .switch_analog          = b43_phyop_switch_analog_generic,
> +       .switch_analog          = b43_lpphy_op_switch_analog,
>         .switch_channel         = b43_lpphy_op_switch_channel,
>         .get_default_chan       = b43_lpphy_op_get_default_chan,
>         .set_rx_antenna         = b43_lpphy_op_set_rx_antenna,
> 

ack

-- 
Greetings, Michael.
