Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34177 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZHJSqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 14:46:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: Update LP-PHY rev2+ baseband init to match the specs
Date: Mon, 10 Aug 2009 20:46:00 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A806A19.2070209@gmail.com>
In-Reply-To: <4A806A19.2070209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908102046.00427.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 August 2009 20:42:33 Gábor Stefanik wrote:
> +static void lpphy_save_dig_flt_state(struct b43_wldev *dev)
> +{
> +	static const u16 addr[] = {
> +		B43_PHY_OFDM(0xC1),
> +		B43_PHY_OFDM(0xC2),
> +		B43_PHY_OFDM(0xC3),
> +		B43_PHY_OFDM(0xC4),
> +		B43_PHY_OFDM(0xC5),
> +		B43_PHY_OFDM(0xC6),
> +		B43_PHY_OFDM(0xC7),
> +		B43_PHY_OFDM(0xC8),
> +		B43_PHY_OFDM(0xCF),
> +	};
> +
> +	static const u16 coeffs[] = {
> +		0xDE5E, 0xE832, 0xE331, 0x4D26,
> +		0x0026, 0x1420, 0x0020, 0xFE08,
> +		0x0008,
> +	};
> +
> +	struct b43_phy_lp *lpphy = dev->phy.lp;
> +	int i;
> +
> +	for (i = 0; i < 9; i++) {

Use ARRAY_SIZE, please.

> +		lpphy->dig_flt_state[i] = b43_phy_read(dev, addr[i]);
> +		b43_phy_write(dev, addr[i], coefs[i]);
> +	}
> +}
> +
> +static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
> +{
> +	static const u16 addr[] = {
> +		B43_PHY_OFDM(0xC1),
> +		B43_PHY_OFDM(0xC2),
> +		B43_PHY_OFDM(0xC3),
> +		B43_PHY_OFDM(0xC4),
> +		B43_PHY_OFDM(0xC5),
> +		B43_PHY_OFDM(0xC6),
> +		B43_PHY_OFDM(0xC7),
> +		B43_PHY_OFDM(0xC8),
> +		B43_PHY_OFDM(0xCF),
> +	};
> +
> +	struct b43_phy_lp *lpphy = dev->phy.lp;
> +	int i;
> +
> +	for (i = 0; i < 9; i++)

Same here.

> +		b43_phy_write(dev, addr[i], lpphy->dig_flt_state[i]);
> +}
> +


-- 
Greetings, Michael.
