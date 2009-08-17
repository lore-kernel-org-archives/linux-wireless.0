Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:16868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZHQTdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 15:33:25 -0400
Received: by fg-out-1718.google.com with SMTP id e12so456243fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 12:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A85AD1B.1060008@gmail.com>
References: <4A85AD1B.1060008@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 17 Aug 2009 21:33:06 +0200
Message-ID: <69e28c910908171233l75b4f72cq8981fb048ad8ffbb@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix reading old mode in the set TX power
	control routine
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/14 Gábor Stefanik <netrolller.3d@gmail.com>:
> Check the mode the hardware is in, not the mode we used the last time.
>
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Mark, please test if this fixes the TX power control WARN_ON you were
> seeing.
>
> drivers/net/wireless/b43/phy_lp.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index 292ee51..76457f7 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1015,9 +1015,9 @@ static void lpphy_set_tx_power_control(struct
> b43_wldev *dev,
>        struct b43_phy_lp *lpphy = dev->phy.lp;
>        enum b43_lpphy_txpctl_mode oldmode;
>
> -       oldmode = lpphy->txpctl_mode;
>        lpphy_read_tx_pctl_mode_from_hardware(dev);
> -       if (lpphy->txpctl_mode == mode)
> +       oldmode = lpphy->txpctl_mode;
> +       if (oldmode == mode)
>                return;
>        lpphy->txpctl_mode = mode;
>
> --
> 1.6.2.4
>

John, any news on this one? I can't see it in wireless testing.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
