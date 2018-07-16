Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43611 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbeGPRzm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 13:55:42 -0400
Received: by mail-pf0-f195.google.com with SMTP id j26-v6so2122596pfi.10
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 10:27:19 -0700 (PDT)
Date: Mon, 16 Jul 2018 10:27:17 -0700
From: Eric Biggers <ebiggers@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless/lib80211: Convert from ahash to shash
Message-ID: <20180716172717.GC77258@google.com> (sfid-20180716_192726_197081_2A651473)
References: <20180716035226.GA32095@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180716035226.GA32095@beast>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 15, 2018 at 08:52:26PM -0700, Kees Cook wrote:
> In preparing to remove all stack VLA usage from the kernel[1], this
> removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of
> the smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash
> to direct shash. The stack allocation will be made a fixed size in a
> later patch to the crypto subsystem.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/wireless/lib80211_crypt_tkip.c | 55 ++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 25 deletions(-)
> 
> diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
> index ba0a1f398ce5..e6bce1f130c9 100644
> --- a/net/wireless/lib80211_crypt_tkip.c
> +++ b/net/wireless/lib80211_crypt_tkip.c
> @@ -65,9 +65,9 @@ struct lib80211_tkip_data {
>  	int key_idx;
>  
>  	struct crypto_skcipher *rx_tfm_arc4;
> -	struct crypto_ahash *rx_tfm_michael;
> +	struct crypto_shash *rx_tfm_michael;
>  	struct crypto_skcipher *tx_tfm_arc4;
> -	struct crypto_ahash *tx_tfm_michael;
> +	struct crypto_shash *tx_tfm_michael;
>  
>  	/* scratch buffers for virt_to_page() (crypto API) */
>  	u8 rx_hdr[16], tx_hdr[16];
> @@ -106,8 +106,7 @@ static void *lib80211_tkip_init(int key_idx)
>  		goto fail;
>  	}
>  
> -	priv->tx_tfm_michael = crypto_alloc_ahash("michael_mic", 0,
> -						  CRYPTO_ALG_ASYNC);
> +	priv->tx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
>  	if (IS_ERR(priv->tx_tfm_michael)) {
>  		priv->tx_tfm_michael = NULL;
>  		goto fail;
> @@ -120,8 +119,7 @@ static void *lib80211_tkip_init(int key_idx)
>  		goto fail;
>  	}
>  
> -	priv->rx_tfm_michael = crypto_alloc_ahash("michael_mic", 0,
> -						  CRYPTO_ALG_ASYNC);
> +	priv->rx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
>  	if (IS_ERR(priv->rx_tfm_michael)) {
>  		priv->rx_tfm_michael = NULL;
>  		goto fail;
> @@ -131,9 +129,9 @@ static void *lib80211_tkip_init(int key_idx)
>  
>        fail:
>  	if (priv) {
> -		crypto_free_ahash(priv->tx_tfm_michael);
> +		crypto_free_shash(priv->tx_tfm_michael);
>  		crypto_free_skcipher(priv->tx_tfm_arc4);
> -		crypto_free_ahash(priv->rx_tfm_michael);
> +		crypto_free_shash(priv->rx_tfm_michael);
>  		crypto_free_skcipher(priv->rx_tfm_arc4);
>  		kfree(priv);
>  	}
> @@ -145,9 +143,9 @@ static void lib80211_tkip_deinit(void *priv)
>  {
>  	struct lib80211_tkip_data *_priv = priv;
>  	if (_priv) {
> -		crypto_free_ahash(_priv->tx_tfm_michael);
> +		crypto_free_shash(_priv->tx_tfm_michael);
>  		crypto_free_skcipher(_priv->tx_tfm_arc4);
> -		crypto_free_ahash(_priv->rx_tfm_michael);
> +		crypto_free_shash(_priv->rx_tfm_michael);
>  		crypto_free_skcipher(_priv->rx_tfm_arc4);
>  	}
>  	kfree(priv);
> @@ -510,29 +508,36 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
>  	return keyidx;
>  }
>  
> -static int michael_mic(struct crypto_ahash *tfm_michael, u8 * key, u8 * hdr,
> -		       u8 * data, size_t data_len, u8 * mic)
> +static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
> +		       u8 *data, size_t data_len, u8 *mic)
>  {
> -	AHASH_REQUEST_ON_STACK(req, tfm_michael);
> -	struct scatterlist sg[2];
> +	SHASH_DESC_ON_STACK(desc, tfm_michael);
>  	int err;
>  
>  	if (tfm_michael == NULL) {
>  		pr_warn("%s(): tfm_michael == NULL\n", __func__);
>  		return -1;
>  	}

This NULL check is pointless, since 'tfm_michael' is already dereferenced by the
previous AHASH_REQUEST_ON_STACK() or SHASH_DESC_ON_STACK().

> -	sg_init_table(sg, 2);
> -	sg_set_buf(&sg[0], hdr, 16);
> -	sg_set_buf(&sg[1], data, data_len);
>  
> -	if (crypto_ahash_setkey(tfm_michael, key, 8))
> +	desc->tfm = tfm_michael;
> +	desc->flags = 0;
> +
> +	if (crypto_shash_setkey(tfm_michael, key, 8))
>  		return -1;
>  
> -	ahash_request_set_tfm(req, tfm_michael);
> -	ahash_request_set_callback(req, 0, NULL, NULL);
> -	ahash_request_set_crypt(req, sg, mic, data_len + 16);
> -	err = crypto_ahash_digest(req);
> -	ahash_request_zero(req);
> +	err = crypto_shash_init(desc);
> +	if (err)
> +		goto out;
> +	err = crypto_shash_update(desc, hdr, 16);
> +	if (err)
> +		goto out;
> +	err = crypto_shash_update(desc, data, data_len);
> +	if (err)
> +		goto out;
> +	err = crypto_shash_final(desc, mic);
> +
> +out:
> +	shash_desc_zero(desc);
>  	return err;
>  }
>  
> @@ -654,9 +659,9 @@ static int lib80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
>  {
>  	struct lib80211_tkip_data *tkey = priv;
>  	int keyidx;
> -	struct crypto_ahash *tfm = tkey->tx_tfm_michael;
> +	struct crypto_shash *tfm = tkey->tx_tfm_michael;
>  	struct crypto_skcipher *tfm2 = tkey->tx_tfm_arc4;
> -	struct crypto_ahash *tfm3 = tkey->rx_tfm_michael;
> +	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
>  	struct crypto_skcipher *tfm4 = tkey->rx_tfm_arc4;
>  
>  	keyidx = tkey->key_idx;
> -- 
> 2.17.1
> 
> 
> -- 
> Kees Cook
> Pixel Security
