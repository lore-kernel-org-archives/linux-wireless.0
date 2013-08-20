Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41559 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750812Ab3HTSaQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 14:30:16 -0400
Message-ID: <1377023415.2016.63.camel@joe-AO722> (sfid-20130820_203020_967856_C2D8D31B)
Subject: Re: [PATCH 12/12] brcmsmac: add support for BCM4313 iPA variant
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 20 Aug 2013 11:30:15 -0700
In-Reply-To: <1377007246-9957-13-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
	 <1377007246-9957-13-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-20 at 16:00 +0200, Arend van Spriel wrote:
> This patch completes the changes needed for supporting the
> iPA variant cards of the BCM4313 wireless chipset.
[]
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
[]
> @@ -1826,6 +1826,17 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
>  		write_radio_reg(pi, RADIO_2064_REG038, 3);
>  		write_radio_reg(pi, RADIO_2064_REG091, 7);
>  	}
> +
> +	if (!(pi->sh->boardflags & BFL_FEM)) {
> +		u8 reg038[14] = {0xd, 0xe, 0xd, 0xd, 0xd, 0xc,
> +			0xa, 0xb, 0xb, 0x3, 0x3, 0x2, 0x0, 0x0};

static const would reduce the object size.

> +		write_radio_reg(pi, RADIO_2064_REG02A, 0xf);
> +		write_radio_reg(pi, RADIO_2064_REG091, 0x3);
> +		write_radio_reg(pi, RADIO_2064_REG038, 0x3);
> +
> +		write_radio_reg(pi, RADIO_2064_REG038, reg038[channel - 1]);

Does anything limit channel to < 15?

There seem to be an awful lot of magic numbers
in the patch.


