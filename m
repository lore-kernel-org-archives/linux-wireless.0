Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:52999 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYIRJUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 05:20:02 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1978978nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 02:20:00 -0700 (PDT)
Message-ID: <f488382f0809180220i7d2b7a7ehb69f9aff4dd04886@mail.gmail.com> (sfid-20080918_112008_371529_34BE4D62)
Date: Thu, 18 Sep 2008 02:20:00 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: connectivity is lost after Group rekeying is done
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Senthil Balasubramanian <senthilkumar@atheros.com> writes:
>
> Connectivtiy is lost after Group rekeying is done. The keytype
> maintained by ath9k is reset when group key is updated. Though
> sc_keytype can be reset only for broadcast key the proper fix
> would be to use mac80211 provided key type from txinfo during
> xmit and get rid of sc_keytype from ath9k ath_softc.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
>  drivers/net/wireless/ath9k/core.h |    1 -
>  drivers/net/wireless/ath9k/main.c |    3 ---
>  drivers/net/wireless/ath9k/xmit.c |    6 +++---
>  3 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
> index b66de29..e8ccbe4 100644
> --- a/drivers/net/wireless/ath9k/core.h
> +++ b/drivers/net/wireless/ath9k/core.h
> @@ -976,7 +976,6 @@ struct ath_softc {
>  	u32 sc_keymax;		/* size of key cache */
>  	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);	/* key use bit map */
>  	u8 sc_splitmic;		/* split TKIP MIC keys */
> -	int sc_keytype;
>
>  	/* RX */
>  	struct list_head sc_rxbuf;
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index 1ba1800..aca893a 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -204,8 +204,6 @@ static int ath_key_config(struct ath_softc *sc,
>  	if (!ret)
>  		return -EIO;
>
> -	if (mac)
> -		sc->sc_keytype = hk.kv_type;
>  	return 0;
>  }
>
> @@ -1507,7 +1505,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
>  	case DISABLE_KEY:
>  		ath_key_delete(sc, key);
>  		clear_bit(key->keyidx, sc->sc_keymap);
> -		sc->sc_keytype = ATH9K_CIPHER_CLR;
>  		break;
>  	default:
>  		ret = -EINVAL;
> diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
> index 3fc6641..2592905 100644
> --- a/drivers/net/wireless/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath9k/xmit.c
> @@ -239,11 +239,11 @@ static int ath_tx_prepare(struct ath_softc *sc,
>  		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
>  		txctl->frmlen += tx_info->control.icv_len;
>
> -		if (sc->sc_keytype == ATH9K_CIPHER_WEP)
> +		if (tx_info->control.hw_key->alg == ALG_WEP)
>  			txctl->keytype = ATH9K_KEY_TYPE_WEP;
> -		else if (sc->sc_keytype == ATH9K_CIPHER_TKIP)
> +		else if (tx_info->control.hw_key->alg == ALG_TKIP)
>  			txctl->keytype = ATH9K_KEY_TYPE_TKIP;
> -		else if (sc->sc_keytype == ATH9K_CIPHER_AES_CCM)
> +		else if (tx_info->control.hw_key->alg == ALG_CCMP)
>  			txctl->keytype = ATH9K_KEY_TYPE_AES;
>  	}
>

Tested-by: Steven Noonan <steven@uplinklabs.net>

I was actually writing a pretty much identical patch locally, and was
in the middle of testing it when I saw this one. I wish I'd been
faster to get mine tested and out the door.

- Steven
