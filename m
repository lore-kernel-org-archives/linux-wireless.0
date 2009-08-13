Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47063 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZHMRXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 13:23:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH v2] b43: Update dummy transmission to match V4 specs
Date: Thu, 13 Aug 2009 19:23:29 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A842887.2080109@gmail.com>
In-Reply-To: <4A842887.2080109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908131923.29847.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 August 2009 16:51:51 Gábor Stefanik wrote:
> The V4 dummy transmission has two extra bools in its prototype,
> so update all callers with the 2 bools.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> v2: Convert all callers to v4, and drop the v3->v4 wrapper.

> -	/* Commit writes */
> -	b43_read32(dev, B43_MMIO_MACCTL);

> -	value = ((phy->type == B43_PHYTYPE_A) ? 1 : 0);
> +	if (dev->dev->id.revision < 11)
> +		b43_write16(dev, 0x07C0, 0x0000);
> +	else
> +		b43_write16(dev, 0x07C0, 0x0100);
> +	value = (ofdm ? 0x41 : 0x40);
>  	b43_write16(dev, 0x050C, value);

This patch changes G-PHY codepaths. Did you test it on (at least one) G-PHY device?

-- 
Greetings, Michael.
