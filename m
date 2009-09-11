Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43633 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZIKGQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 02:16:53 -0400
Received: by ewy2 with SMTP id 2so803224ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 23:16:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	 <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
Date: Fri, 11 Sep 2009 09:16:55 +0300
Message-ID: <40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/11 Luis R. Rodriguez <lrodriguez@atheros.com>:
> All read/write ops now go through the common ops.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h |   20 ++++++++++++--------
>  drivers/net/wireless/ath/ath5k/base.c  |   17 +++++++++++++++++
>  drivers/net/wireless/ath/ath5k/base.h  |   11 -----------
>  3 files changed, 29 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 29ce868..997101b 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1315,20 +1315,24 @@ static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
>        return turbo ? (clock / 80) : (clock / 40);
>  }
>
> -/*
> - * Read from a register
> - */
> +static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
> +{
> +        return &ah->common;
> +}
> +
> +static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
> +{
> +        return &(ath5k_hw_common(ah)->regulatory);
> +}
> +
>  static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
>  {
> -       return ioread32(ah->ah_iobase + reg);
> +       return ath5k_hw_common(ah)->ops->read(ah, reg);
>  }
>
> -/*
> - * Write to a register
> - */
>  static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
>  {
> -       iowrite32(val, ah->ah_iobase + reg);
> +       ath5k_hw_common(ah)->ops->write(ah, reg, val);
>  }
>
>  #if defined(_ATH5K_RESET) || defined(_ATH5K_PHY)
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 3cb0752..535ea72 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -437,6 +437,22 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
>
>        return name;
>  }
> +static unsigned int ath5k_ioread32(void *hw_priv, u32 reg_offset)
> +{
> +       struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
> +       return ioread32(ah->ah_iobase + reg_offset);
> +}
> +
> +static void ath5k_iowrite32(void *hw_priv, u32 reg_offset, u32 val)
> +{
> +       struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
> +       iowrite32(val, ah->ah_iobase + reg_offset);
> +}
> +
> +static struct ath_ops ath5k_common_ops = {
> +       .read = ath5k_ioread32,
> +       .write = ath5k_iowrite32,
> +};
>
>  static int __devinit
>  ath5k_pci_probe(struct pci_dev *pdev,
> @@ -576,6 +592,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>        sc->ah->ah_sc = sc;
>        sc->ah->ah_iobase = sc->iobase;
>        common = ath5k_hw_common(sc->ah);
> +       common->ops = &ath5k_common_ops;
>        common->cachelsz = csz << 2; /* convert to bytes */
>
>        /* Initialize device */
> diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
> index 005d25f..b14ba07 100644
> --- a/drivers/net/wireless/ath/ath5k/base.h
> +++ b/drivers/net/wireless/ath/ath5k/base.h
> @@ -201,15 +201,4 @@ struct ath5k_softc {
>  #define ath5k_hw_hasveol(_ah) \
>        (ath5k_hw_get_capability(_ah, AR5K_CAP_VEOL, 0, NULL) == 0)
>
> -static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
> -{
> -       return &ah->common;
> -}
> -
> -static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
> -{
> -       return &(ath5k_hw_common(ah)->regulatory);
> -
> -}
> -
>  #endif

Since each driver will use it's own reg read/write functions (ath5k hw
code still uses ath5k_hw_reg_read/write), why do we need to have
common reg read/write functions like that used in the driver code ?
This makes the code more complex that it needs to be and i don't see a
reason why we need it. I understand why we need a way to handle
read/write functions from common ath code but i don't see a reason to
use these functions on ath5k, we can just fill ath_ops struct so that
common code can use them and leave ath5k_hw_read/write untouched.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
