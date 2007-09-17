Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:59305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963AbXIQUon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 16:44:43 -0400
Received: by ug-out-1314.google.com with SMTP id z38so14476ugc
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2007 13:44:42 -0700 (PDT)
Message-ID: <46EEE735.5050306@gmail.com>
Date: Mon, 17 Sep 2007 22:44:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] revert ath5k ioread32()/iowrite32() usage - use readl()/writel(),  we're MMIO-only
References: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com>
In-Reply-To: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/2007 10:34 PM, Luis R. Rodriguez wrote:
> Based on advise from Jeff, as described in the e-mail:
> 
> [PATCH] Clarify pci_iomap() usage for MMIO-only devices
> 
> we shouldn't use ioread32()/iowrite32() unless we really have a need
> to otherwise we're creating an unnecessary branch on read/write. Lets
> revert this back to readl()/writel() as our devices so far have been
> MMIO-only. This reverts 9202ec15da36ca060722c363575e0e390d85fb71 on
> ath5k. This patch is intended for the ath5k branch of wireless-dev.
> 
> Changes-licensed-under: ISC
> Singed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> 
> ---
> 
>  drivers/net/wireless/ath5k_hw.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k_hw.c
> index 07ad127..3501b4c 100644
> --- a/drivers/net/wireless/ath5k_hw.c
> +++ b/drivers/net/wireless/ath5k_hw.c
> @@ -219,7 +219,7 @@ static inline unsigned int
> ath5k_hw_clocktoh(unsigned int clock, bool turbo)
>   */
>  static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
>  {
> -       return ioread32(hal->ah_sh + reg);
> +       return readl(hal->ah_sh + reg);
>  }
> 
>  /*
> @@ -227,7 +227,7 @@ static inline u32 ath5k_hw_reg_read(struct ath_hw
> *hal, u16 reg)
>   */
>  static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
>  {
> -       iowrite32(val, hal->ah_sh + reg);
> +       writel(val, hal->ah_sh + reg);
>  }
> 
>  /*
> 

NACK, this is wrong. iomap returns platform dependant return value, which may or
may not correspond to what is accepted by readX/writeX. (but is 100% accepted by
ioreadXX/iowriteXX).

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
