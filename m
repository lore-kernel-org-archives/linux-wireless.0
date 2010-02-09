Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58428 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0BIW72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 17:59:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 08/11] b43: implement writing to MMIO shared memory
Date: Tue, 9 Feb 2010 23:59:23 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <1265745883-3392-9-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-9-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002092359.24301.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 February 2010 21:04:40 Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_common.c |   11 +++++++++++
>  drivers/net/wireless/b43/phy_common.h |    2 ++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
> index 8f7d7ef..0b0f9df 100644
> --- a/drivers/net/wireless/b43/phy_common.c
> +++ b/drivers/net/wireless/b43/phy_common.c
> @@ -466,3 +466,14 @@ struct b43_c32 b43_cordic(int theta)
>  
>  	return ret;
>  }
> +
> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacWriteShm */
> +void b43_bmac_write_shm(struct b43_wldev *dev, u32 offset, u16 value)
> +{
> +	b43_write32(dev, B43_MMIO_SHM_CONTROL, 0x00010000 | (offset >> 2));
> +	b43_read32(dev, B43_MMIO_SHM_CONTROL);
> +	if (offset & 2)
> +		b43_write16(dev, 0x165, value);
> +	else
> +		b43_write16(dev, B43_MMIO_SHM_DATA, value);
> +}

I'd like to put a biiiig questionmark on this.
We already have SHM access. Your function does exactly the same, except that it
accesses the bullshit register h165.

-- 
Greetings, Michael.
