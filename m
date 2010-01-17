Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38748 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0AQQhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 11:37:53 -0500
Received: by fxm25 with SMTP id 25so419470fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 08:37:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.u6oef6cl9lhzdc@linux-g0th.site>
References: <op.u6oef6cl9lhzdc@linux-g0th.site>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 17 Jan 2010 17:37:29 +0100
Message-ID: <69e28c911001170837u4ea715ddn4a8e2001f6c1acc3@mail.gmail.com>
Subject: Re: [PATCH 2/7] b43: N-PHY: implement TX PHY cleanup and setup
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/17 Rafał Miłecki <zajec5@gmail.com>:
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_n.c |  112
> +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 110 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_n.c
> b/drivers/net/wireless/b43/phy_n.c
> index 4a1853b..34dd4a2 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -1505,6 +1505,114 @@ static struct nphy_txgains
> b43_nphy_get_tx_gains(struct b43_wldev *dev)
>        return target;
>  }
>
> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhyCleanup */
> +static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
> +{
> +       u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
> +
> +       if (dev->phy.rev >= 3) {
> +               b43_phy_write(dev, B43_NPHY_AFECTL_C1, regs[0]);
> +               b43_phy_write(dev, B43_NPHY_AFECTL_C2, regs[1]);
> +               b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, regs[2]);
> +               b43_phy_write(dev, B43_NPHY_AFECTL_OVER, regs[3]);
> +               b43_phy_write(dev, B43_NPHY_BBCFG, regs[4]);
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset 3,
> +                       width 16, and data from regs[5] */
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset
> 19,

While you are at it, why aren't you programming these table writes?
The table handling functions are AFAIK already in place...

> +                       width 16, and data from regs[6] */
> +               b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs[7]);
> +               b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs[8]);
> +               b43_phy_write(dev, B43_NPHY_PAPD_EN0, regs[9]);
> +               b43_phy_write(dev, B43_NPHY_PAPD_EN1, regs[10]);
> +               b43_nphy_reset_cca(dev);
> +       } else {
> +               b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, regs[0]);
> +               b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, regs[1]);
> +               b43_phy_write(dev, B43_NPHY_AFECTL_OVER, regs[2]);
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset 2,
> +                       width 16, and data from regs[3] */
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset
> 18,
> +                       width 16, and data from regs[4] */
> +               b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs[5]);
> +               b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs[6]);
> +       }
> +}
> +
> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhySetup */
> +static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
> +{
> +       u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
> +       u16 tmp;
> +
> +       regs[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
> +       regs[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
> +       if (dev->phy.rev >= 3) {
> +               b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0xF0FF, 0x0A00);
> +               b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0xF0FF, 0x0A00);
> +
> +               tmp = b43_phy_read(dev, B43_NPHY_AFECTL_OVER1);
> +               regs[2] = tmp;
> +               b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, tmp | 0x0600);
> +
> +               tmp = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
> +               regs[3] = tmp;
> +               b43_phy_write(dev, B43_NPHY_AFECTL_OVER, tmp | 0x0600);
> +
> +               regs[4] = b43_phy_read(dev, B43_NPHY_BBCFG);
> +               b43_phy_mask(dev, B43_NPHY_BBCFG, ~B43_NPHY_BBCFG_RSTRX);
> +
> +               /* TODO: Read an N PHY Table with ID 8, length 1, offset 3,
> +                       width 16, and data pointing to tmp */
> +               regs[5] = tmp;
> +
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset 3,
> +                       width 16, and data 0 */
> +               /* TODO: Read an N PHY Table with ID 8, length 1, offset 19,
> +                       width 16, and data pointing to tmp */
> +               regs[6] = tmp;
> +
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset
> 19,
> +                       width 16, and data 0 */
> +               regs[7] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
> +               regs[8] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
> +
> +               /* TODO: Call N PHY RF Ctrl Intc Override with 2, 1, 3 */
> +               /* TODO: Call N PHY RF Ctrl Intc Override with 1, 2, 1 */
> +               /* TODO: Call N PHY RF Ctrl Intc Override with 1, 8, 2 */
> +
> +               regs[9] = b43_phy_read(dev, B43_NPHY_PAPD_EN0);
> +               regs[10] = b43_phy_read(dev, B43_NPHY_PAPD_EN1);
> +               b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x0001);
> +               b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x0001);
> +       } else {
> +               b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, 0xA000);
> +               b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, 0xA000);
> +               tmp = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
> +               regs[2] = tmp;
> +               b43_phy_write(dev, B43_NPHY_AFECTL_OVER, tmp | 0x3000);
> +               /* TODO: Read an N PHY Table with ID 8, length 1, offset 2,
> +                       width 16, and data pointing to tmp */
> +               regs[3] = tmp;
> +               tmp |= 0x2000;
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset 2,
> +                       width 16, and data pointer tmp */
> +               /* TODO: Read an N PHY Table with ID 8, length 1, offset 18,
> +                       width 16, and data pointer tmp */
> +               regs[4] = tmp;
> +               tmp |= 0x2000;
> +               /* TODO: Write an N PHY Table with ID 8, length 1, offset
> 18,
> +                       width 16, and data pointer tmp */
> +               regs[5] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
> +               regs[6] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
> +               if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
> +                       tmp = 0x0180;
> +               else
> +                       tmp = 0x0120;
> +               b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, tmp);
> +               b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, tmp);
> +       }
> +}
> +
>  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal */
>  static void b43_nphy_restore_cal(struct b43_wldev *dev)
>  {
> @@ -1617,7 +1725,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev
> *dev,
>                width 16, and data pointer gain */
>
>        b43_nphy_tx_cal_radio_setup(dev);
> -       /* TODO: Call N PHY TX Cal PHY Setup */
> +       b43_nphy_tx_cal_phy_setup(dev);
>
>        phy6or5x = dev->phy.rev >= 6 ||
>                (dev->phy.rev == 5 && nphy->ipa2g_on &&
> @@ -1788,7 +1896,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev
> *dev,
>                b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0);
>        }
>
> -       /* TODO: Call N PHY TX Cal PHY Cleanup */
> +       b43_nphy_tx_cal_phy_cleanup(dev);
>        /* TODO: Write an N PHY Table with ID 7, length 2, offset 0x110,
>                width 16, and data from save */
>
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
