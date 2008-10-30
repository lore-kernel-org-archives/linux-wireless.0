Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:27735 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567AbYJ3VzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 17:55:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so816101wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 14:55:23 -0700 (PDT)
Message-ID: <40f31dec0810301455h60ea1501r46578a9e667e5f23@mail.gmail.com> (sfid-20081030_225542_655089_70410969)
Date: Thu, 30 Oct 2008 23:55:22 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: update keycache to support TKIP handling
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <20081030031914.GA26970@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225283457-24417-3-git-send-email-me@bobcopeland.com>
	 <40f31dec0810290742j2c94e047u8548dfe2bdcde058@mail.gmail.com>
	 <20081030031914.GA26970@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/30 Bob Copeland <me@bobcopeland.com>:
> Newer parts have slots at entry+64 for michael mic and can do WPA-TKIP
> in hardware.  The open-sourced Atheros HAL has code for accessing this
> portion so now we know how where to put the key material.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>
> v2, without the extra definition of AR5K_KEYTABLE_MIC_OFFSET
>
>  drivers/net/wireless/ath5k/base.c |    5 ++-
>  drivers/net/wireless/ath5k/pcu.c  |   64 ++++++++++++++++++++++++++++++++++---
>  2 files changed, 62 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 4bf3678..c7ffcbb 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2983,8 +2983,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>
>        switch (key->alg) {
>        case ALG_WEP:
> -               break;
>        case ALG_TKIP:
> +               break;
>        case ALG_CCMP:
>                return -EOPNOTSUPP;
>        default:
> @@ -3003,7 +3003,8 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>                }
>                __set_bit(key->keyidx, sc->keymap);
>                key->hw_key_idx = key->keyidx;
> -               key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
> +               key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
> +                              IEEE80211_KEY_FLAG_GENERATE_MMIC);
>                break;
>        case DISABLE_KEY:
>                ath5k_hw_reset_key(sc->ah, key->keyidx);
> diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
> index 5674639..9b46d64 100644
> --- a/drivers/net/wireless/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath5k/pcu.c
> @@ -1014,17 +1014,29 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
>                const struct ieee80211_key_conf *key, const u8 *mac)
>  {
>        unsigned int i;
> +       int keylen;
>        __le32 key_v[5] = {};
> +       __le32 key0 = 0, key1 = 0;
> +       __le32 *rxmic, *txmic;
>        u32 keytype;
> +       u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
> +       bool is_tkip;
>
>        ATH5K_TRACE(ah->ah_sc);
>
> -       /* key->keylen comes in from mac80211 in bytes */
> +       is_tkip = (key->alg == ALG_TKIP);
>
> -       if (key->keylen > AR5K_KEYTABLE_SIZE / 8)
> +       /*
> +        * key->keylen comes in from mac80211 in bytes.
> +        * TKIP is 128 bit + 128 bit mic
> +        */
> +       keylen = (is_tkip) ? (128 / 8) : key->keylen;
> +
> +       if (entry > AR5K_KEYTABLE_SIZE ||
> +               (is_tkip && micentry > AR5K_KEYTABLE_SIZE))
>                return -EOPNOTSUPP;
>
> -       switch (key->keylen) {
> +       switch (keylen) {
>        /* WEP 40-bit   = 40-bit  entered key + 24 bit IV = 64-bit */
>        case 40 / 8:
>                memcpy(&key_v[0], key->key, 5);
> @@ -1038,24 +1050,66 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
>                memcpy(&key_v[4], &key->key[12], 1);
>                keytype = AR5K_KEYTABLE_TYPE_104;
>                break;
> -       /* WEP 128-bit  = 128-bit entered key + 24 bit IV = 152-bit */
> +       /* WEP/TKIP 128-bit  = 128-bit entered key + 24 bit IV = 152-bit */
>        case 128 / 8:
>                memcpy(&key_v[0], &key->key[0], 6);
>                memcpy(&key_v[2], &key->key[6], 6);
>                memcpy(&key_v[4], &key->key[12], 4);
> -               keytype = AR5K_KEYTABLE_TYPE_128;
> +               keytype = is_tkip ?
> +                       AR5K_KEYTABLE_TYPE_TKIP :
> +                       AR5K_KEYTABLE_TYPE_128;
>                break;
>
>        default:
>                return -EINVAL; /* shouldn't happen */
>        }
>
> +       /* intentionally corrupt key until mic is installed */
> +       if (is_tkip) {
> +               key0 = key_v[0] = ~key_v[0];
> +               key1 = key_v[1] = ~key_v[1];
> +       }
> +
>        for (i = 0; i < ARRAY_SIZE(key_v); i++)
>                ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
>                                AR5K_KEYTABLE_OFF(entry, i));
>
>        ath5k_hw_reg_write(ah, keytype, AR5K_KEYTABLE_TYPE(entry));
>
> +       if (is_tkip) {
> +               /* Install rx/tx MIC */
> +               rxmic = (__le32 *) &key->key[16];
> +               txmic = (__le32 *) &key->key[24];
> +#if 0
> +               /* MISC_MODE register & 0x04 - for mac srev >= griffin */
> +               key_v[0] = rxmic[0];
> +               key_v[1] = (txmic[0] >> 16) & 0xffff;
> +               key_v[2] = rxmic[1];
> +               key_v[3] = txmic[0] & 0xffff;
> +               key_v[4] = txmic[1];
> +#else
> +               key_v[0] = rxmic[0];
> +               key_v[1] = 0;
> +               key_v[2] = rxmic[1];
> +               key_v[3] = 0;
> +               key_v[4] = 0;
> +#endif
> +               for (i = 0; i < ARRAY_SIZE(key_v); i++)
> +                       ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
> +                               AR5K_KEYTABLE_OFF(micentry, i));
> +
> +               ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
> +                       AR5K_KEYTABLE_TYPE(micentry));
> +               ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_MAC0(micentry));
> +               ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_MAC1(micentry));
> +
> +               /* restore first 2 words of key */
> +               ath5k_hw_reg_write(ah, le32_to_cpu(~key0),
> +                       AR5K_KEYTABLE_OFF(entry, 0));
> +               ath5k_hw_reg_write(ah, le32_to_cpu(~key1),
> +                       AR5K_KEYTABLE_OFF(entry, 1));
> +       }
> +
>        return ath5k_hw_set_key_lladdr(ah, entry, mac);
>  }
>

(going to sleep :P)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
