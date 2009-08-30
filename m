Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54580 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbZH3K2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 06:28:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH v2] b43: LP-PHY: Begin implementing calibration & software RFKILL support
Date: Sun, 30 Aug 2009 12:28:15 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A99C4BB.7080806@gmail.com>
In-Reply-To: <4A99C4BB.7080806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908301228.16845.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 30 August 2009 02:15:55 Gábor Stefanik wrote:
>  static void lpphy_pr41573_workaround(struct b43_wldev *dev)
>  {
>  	struct b43_phy_lp *lpphy = dev->phy.lp;
> @@ -1357,28 +1488,440 @@ static void lpphy_pr41573_workaround(struct b43_wldev *dev)
>  		b43_lptab_read_bulk(dev, B43_LPTAB32(7, 0x140),
>  				    saved_tab_size, saved_tab);
>  	}
> +	b43_put_phy_into_reset(dev);

Are you sure you really want this?
This function completely disables the PHY on the backplane and keeps the physical
PHY reset pin asserted (even after return from the function).
So the PHY will physically be powered down from this point on. The following
PHY accesses could even hang the machine, because the PHY won't respond to
register accesses anymore.

We currently only use this function on A/G Multi-PHY devices to permanently
hard-disable the PHY that's not used.

> +	b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xFFF8);
> +	lpphy_table_init(dev); //FIXME is table init needed?
> +	lpphy_baseband_init(dev);
> +	b43_lpphy_op_software_rfkill(dev, false);
> +	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
> +	if (dev->phy.rev < 2) {
> +		b43_lptab_write_bulk(dev, B43_LPTAB32(10, 0x140),
> +				     saved_tab_size, saved_tab);
> +	} else {
> +		b43_lptab_write_bulk(dev, B43_LPTAB32(7, 0x140),
> +				     saved_tab_size, saved_tab);
> +	}
> +	b43_write16(dev, B43_MMIO_CHANNEL, lpphy->channel);
> +	lpphy->tssi_npt = tssi_npt;
> +	lpphy->tssi_idx = tssi_idx;
> +	lpphy_set_analog_filter(dev, lpphy->channel);
> +	if (tx_pwr_idx_over != -1)
> +		lpphy_set_tx_power_by_index(dev, tx_pwr_idx_over);
> +	if (lpphy->rc_cap)
> +		lpphy_set_rc_cap(dev);
> +	b43_lpphy_op_set_rx_antenna(dev, lpphy->antenna);
> +	lpphy_set_tx_power_control(dev, txpctl_mode);
> +	kfree(saved_tab);
> +}

-- 
Greetings, Michael.
