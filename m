Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:15992 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZINIqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:46:33 -0400
Received: by fg-out-1718.google.com with SMTP id 22so473134fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 01:46:35 -0700 (PDT)
Message-ID: <4AAE02E9.2050905@gmail.com>
Date: Mon, 14 Sep 2009 10:46:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ath5k: define ath_common ops
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com> <1252917123-11559-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917123-11559-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2009 10:32 AM, Luis R. Rodriguez wrote:
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -437,6 +437,22 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
>  
>  	return name;
>  }
> +static unsigned int ath5k_ioread32(void *hw_priv, u32 reg_offset)
> +{
> +	struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
> +	return ioread32(ah->ah_iobase + reg_offset);

Why not just
return ath5k_hw_reg_read(hw_priv, reg_offset)
as I suggested?

> +static void ath5k_iowrite32(void *hw_priv, u32 val, u32 reg_offset)
> +{
> +	struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
> +	iowrite32(val, ah->ah_iobase + reg_offset);

and ath5k_hw_reg_write(hw_priv, val, reg_offset)

If we ever decide to not use ioread32/iowrite32, it will need a change
on a single place.

> +}
> +
> +const static struct ath_ops ath5k_common_ops = {

C99, 6.11.5 Storage-class specifiers:
1 The placement of a storage-class specifier other than at the
beginning of the declaration specifiers in a declaration is
an obsolescent feature.

I.e. use static const, please.
