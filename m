Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31788 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbbGGFKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 01:10:16 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "nbd@openwrt.org" <nbd@openwrt.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
Subject: RE: [PATCH v2] ath9k: export HW random number generator
Date: Tue, 7 Jul 2015 05:07:25 +0000
Message-ID: <262dbfcff3564c4ba2025f9fde11e8e2@NASANEXM01E.na.qualcomm.com> (sfid-20150707_071054_689855_03787A0F)
References: <1435912110-9646-1-git-send-email-miaoqing@qca.qualcomm.com>
 <559A5919.3060308@openwrt.org>
In-Reply-To: <559A5919.3060308@openwrt.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR_PHY_TST_ADC is BB ADC sample register, it doesn't depend on other BB registers.  Get non zero data if it has the ADC values.   

Thanks,
Miaoqing
-----Original Message-----
From: Felix Fietkau [mailto:nbd@openwrt.org] 
Sent: Monday, July 06, 2015 6:32 PM
To: Pan, Miaoqing; linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org; ath9k-devel; Valo, Kalle
Subject: Re: [PATCH v2] ath9k: export HW random number generator

On 2015-07-03 10:28, miaoqing@qti.qualcomm.com wrote:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> We measured the ADC-based entropy in 3 ways, Shannon entropy, 
> collision entropy, and directly measured min-entropy. Entropy is in 
> bits per 16 bit value,
>    ---------------------------
>    Shannon | collision | min
>    ---------------------------
>    12.00   | 10.80     | 9.18
>    ---------------------------
> 
> Recommend: A generous safety factor be used. NIST Special Publication 
> 800-90B (draft) requires that data used to seed a deterministic random 
> bit generator with N bits of strength have an estimated entropy at 
> least twice the block size of the underlying primitive. Given all the 
> uncertainties, it would be wise to collect even more.
> 
> Analysis was done by Jacobson,David(djacobso@qti.qualcomm.com).
> 
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig  |  7 ++++  
> drivers/net/wireless/ath/ath9k/Makefile |  1 +  
> drivers/net/wireless/ath/ath9k/ath9k.h  | 23 ++++++++++++
>  drivers/net/wireless/ath/ath9k/main.c   |  4 ++
>  drivers/net/wireless/ath/ath9k/rng.c    | 66 +++++++++++++++++++++++++++++++++
>  5 files changed, 101 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/ath9k/rng.c
> 

> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -0,0 +1,66 @@
> +/*
> + * Copyright (c) 2015 Qualcomm Atheros, Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software 
> +for any
> + * purpose with or without fee is hereby granted, provided that the 
> +above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL 
> +WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE 
> +LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY 
> +DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN 
> +AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING 
> +OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include "ath9k.h"
> +#include "hw.h"
> +#include "ar9003_phy.h"
> +
> +static int ath9k_rng_data_read(struct hwrng *rng, u32 *data) {
> +	u32 v1, v2;
> +	struct ath_softc *sc = (struct ath_softc *)rng->priv;
> +	struct ath_hw *ah = sc->sc_ah;
> +
> +	ath9k_ps_wakeup(sc);
> +
> +	v1 = REG_READ(ah, AR_PHY_TST_ADC);
> +	v2 = REG_READ(ah, AR_PHY_TST_ADC);
> +
> +	ath9k_ps_restore(sc);
> +
> +	/* wait for data ready */
> +	if (v1 && v2 && sc->rng_last != v1 && v1 != v2) {
> +		*data = (v1 & 0xffff) | (v2 << 16);
> +		sc->rng_last = v2;
> +
> +		return sizeof(u32);
> +	}
I have some doubt about this part. Doesn't the value of AR_PHY_TST_ADC depend on the initialization of the baseband observation registers?
What guarantee is there that it's initialized to return any data that is useful for random number generation on all chipsets?
Did you validate all relevant initval settings for this?

- Felix
