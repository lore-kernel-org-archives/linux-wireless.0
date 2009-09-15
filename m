Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40258 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbZIOVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 17:00:12 -0400
Received: by ewy2 with SMTP id 2so865643ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 14:00:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH] ar9170: handle overflow in tsf_low register during get_tsf
Date: Tue, 15 Sep 2009 23:00:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4AAFF89D.1000804@gmx.de>
In-Reply-To: <4AAFF89D.1000804@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909152300.06026.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 September 2009 22:27:09 Joerg Albert wrote:
> ar9170_op_get_tsf: handle a carry from register TSF_L into TSF_H
> by reading TSF_H twice.  We also get rid of the mutex here
> and use read_mreg.
> 
> Signed-off-by: Joerg Albert <jal2@gmx.de>
NACK.

don't remove the mutex!

it ensures an exclusive access the driver's data structures
(cmdbuf, [readlen and readbuf]) and synchronous control message transfer.

Regards,
	Chr
> ---
>  drivers/net/wireless/ath/ar9170/cmd.c  |    3 +--
>  drivers/net/wireless/ath/ar9170/cmd.h  |    1 +
>  drivers/net/wireless/ath/ar9170/main.c |   30 +++++++++++++++++-------------
>  3 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/cmd.c b/drivers/net/wireless/ath/ar9170/cmd.c
> index f57a620..cf6f5c4 100644
> --- a/drivers/net/wireless/ath/ar9170/cmd.c
> +++ b/drivers/net/wireless/ath/ar9170/cmd.c
> @@ -72,8 +72,7 @@ int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val)
>  	return err;
>  }
>  
> -static int ar9170_read_mreg(struct ar9170 *ar, int nregs,
> -			    const u32 *regs, u32 *out)
> +int ar9170_read_mreg(struct ar9170 *ar, int nregs, const u32 *regs, u32 *out)
>  {
>  	int i, err;
>  	__le32 *offs, *res;
> diff --git a/drivers/net/wireless/ath/ar9170/cmd.h b/drivers/net/wireless/ath/ar9170/cmd.h
> index a4f0e50..826c45e 100644
> --- a/drivers/net/wireless/ath/ar9170/cmd.h
> +++ b/drivers/net/wireless/ath/ar9170/cmd.h
> @@ -44,6 +44,7 @@
>  int ar9170_write_mem(struct ar9170 *ar, const __le32 *data, size_t len);
>  int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val);
>  int ar9170_read_reg(struct ar9170 *ar, u32 reg, u32 *val);
> +int ar9170_read_mreg(struct ar9170 *ar, int nregs, const u32 *regs, u32 *out);
>  int ar9170_echo_test(struct ar9170 *ar, u32 v);
>  
>  /*
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index c1f8c69..3457cd2 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -2190,22 +2190,26 @@ static u64 ar9170_op_get_tsf(struct ieee80211_hw *hw)
>  {
>  	struct ar9170 *ar = hw->priv;
>  	int err;
> -	u32 tsf_low;
> -	u32 tsf_high;
>  	u64 tsf;
> +#define NR 3

> +	static const u32 addr[NR] = { AR9170_MAC_REG_TSF_H,
> +				    AR9170_MAC_REG_TSF_L,
> +				    AR9170_MAC_REG_TSF_H };
> +	u32 val[NR];
> +	int loops = 0;
> +
> +	while (loops++ < 100) {
> +		err = ar9170_read_mreg(ar, NR, addr, val);
> +		if (WARN_ON(err))
> +			return 0;
> +		if (val[0] == val[2])
> +			break;
> +	}
>  
> -	mutex_lock(&ar->mutex);
> -	err = ar9170_read_reg(ar, AR9170_MAC_REG_TSF_L, &tsf_low);
> -	if (!err)
> -		err = ar9170_read_reg(ar, AR9170_MAC_REG_TSF_H, &tsf_high);
> -	mutex_unlock(&ar->mutex);
> -
> -	if (WARN_ON(err))
> -		return 0;
> -
> -	tsf = tsf_high;
> -	tsf = (tsf << 32) | tsf_low;
> +	tsf = val[0];
> +	tsf = (tsf << 32) | val[1];
>  	return tsf;
> +#undef NR
>  }
>  
>  static int ar9170_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> 
