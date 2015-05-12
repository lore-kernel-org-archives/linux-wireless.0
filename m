Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35565 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934009AbbELXMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 19:12:06 -0400
Received: by iebpz10 with SMTP id pz10so16501073ieb.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 16:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55527D6E.7090207@gmail.com>
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>
 <20150420082441.GU10964@mwanda> <553C18B6.807@gmail.com> <20150427101242.GR14154@mwanda>
 <554AD76E.7060605@gmail.com> <20150508110328.GT14154@mwanda> <55527D6E.7090207@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 13 May 2015 09:11:45 +1000
Message-ID: <CAGRGNgUOkUjPfr7wAnUR85a6SzRsYyd-EOWNV2AKf0Po+ztuMw@mail.gmail.com> (sfid-20150513_011211_527236_147BC3D4)
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
To: Gaston Gonzalez <gascoar@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Joe Perches <joe@perches.com>, navyasri.tech@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gaston,

A couple of minor style comments:

On Wed, May 13, 2015 at 8:23 AM, Gaston Gonzalez <gascoar@gmail.com> wrote:
> On 08/05/15 08:03, Dan Carpenter wrote:
>> To be honest, I'm a little bit a newbie myself when it comes to
>> linux-wireless so keep that in mind.  ;)  Changing the parameters seems
>> simple enough.  But it needs to an EXPORT_SYMBOL() and to be declared in
>> a header file and I'm not sure what else.  But we have four
>> implementations of this function now.
> Ok Dan, I did the test exporting tkip_mixing_phase2(). Below is how the
> patch would look.
> So far I didn't get any warnings.
>
> Summary and comments:
>
>  - Goal: use tkip_mixing_phase2() from /net/mac80211/tkip.c in
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
>
>  - Approach: export  tkip_mixing_phase2(), adding tkip_ctx structure
> definition without toucing original structures from
> ieee80211_crypt_tkip.c. As you pointed out, this is done by adding
> EXPORT_SYMBOL() and declaring the function in the destined file.
>
>  - As commented in the previous email, adding tkip_ctx structure
> duplicates some members. Only one of them is used in the function: p1k,
> so it is copied from one structure to the other.
>
>  - Please let me know if the implementation is useful or is better
> another approach or if it needs changes.
>
>  - In the case this is well oriented, the submission form would be a new
> patch or v2 of the original one?
>
> regards,
>
> Gaston
>
>
> ---
>  .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      | 79
> ++++++++--------------
>  net/mac80211/tkip.c                                |  3 +-
>  2 files changed, 32 insertions(+), 50 deletions(-)
>
> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
> b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
> index 1f80c52..51e2034 100644
> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
> @@ -18,3 +18,4 @@
>  #include <linux/if_ether.h>
>  #include <linux/if_arp.h>
>  #include <linux/string.h>
> +#include <net/mac80211.h>
>
>  #include "ieee80211.h"
>
> @@ -61,2 +62,2 @@ struct ieee80211_tkip_data {
>      u8 rx_hdr[16], tx_hdr[16];
>  };
>
> +enum ieee80211_internal_tkip_state {
> +    TKIP_STATE_NOT_INIT,
> +    TKIP_STATE_PHASE1_DONE,
> +    TKIP_STATE_PHASE1_HW_UPLOADED,
> +};
> +
> +struct tkip_ctx {
> +    u32 iv32;    /* current iv32 */
> +    u16 iv16;    /* current iv16 */
> +    u16 p1k[5];    /* p1k cache */
> +    u32 p1k_iv32;    /* iv32 for which p1k computed */
> +    enum ieee80211_internal_tkip_state state;
> +};
> +
> +void tkip_mixing_phase2(const u8 *tk, struct tkip_ctx *ctx,
> +            u16 tsc_IV16, u8 *rc4key);
> +

I'm guessing you copied all of this from mac80211/tkip.c. It should
get stuffed into a header somewhere, not copied to the top of the
file.

>  static void *ieee80211_tkip_init(int key_idx)
>  {
>      struct ieee80211_tkip_data *priv;
> @@ -254,1 +272,1 @@ static void tkip_mixing_phase1(u16 *TTAK, const u8
> *TK, const u8 *TA, u32 IV32)
>  }
>
>
> -static void tkip_mixing_phase2(u8 *WEPSeed, const u8 *TK, const u16 *TTAK,
> -                   u16 IV16)
> -{
> -    /* Make temporary area overlap WEP seed so that the final copy can be
> -     * avoided on little endian hosts. */
> -    u16 *PPK = (u16 *) &WEPSeed[4];
> -
> -    /* Step 1 - make copy of TTAK and bring in TSC */
> -    PPK[0] = TTAK[0];
> -    PPK[1] = TTAK[1];
> -    PPK[2] = TTAK[2];
> -    PPK[3] = TTAK[3];
> -    PPK[4] = TTAK[4];
> -    PPK[5] = TTAK[4] + IV16;
> -
> -    /* Step 2 - 96-bit bijective mixing using S-box */
> -    PPK[0] += _S_(PPK[5] ^ Mk16_le((u16 *) &TK[0]));
> -    PPK[1] += _S_(PPK[0] ^ Mk16_le((u16 *) &TK[2]));
> -    PPK[2] += _S_(PPK[1] ^ Mk16_le((u16 *) &TK[4]));
> -    PPK[3] += _S_(PPK[2] ^ Mk16_le((u16 *) &TK[6]));
> -    PPK[4] += _S_(PPK[3] ^ Mk16_le((u16 *) &TK[8]));
> -    PPK[5] += _S_(PPK[4] ^ Mk16_le((u16 *) &TK[10]));
> -
> -    PPK[0] += RotR1(PPK[5] ^ Mk16_le((u16 *) &TK[12]));
> -    PPK[1] += RotR1(PPK[0] ^ Mk16_le((u16 *) &TK[14]));
> -    PPK[2] += RotR1(PPK[1]);
> -    PPK[3] += RotR1(PPK[2]);
> -    PPK[4] += RotR1(PPK[3]);
> -    PPK[5] += RotR1(PPK[4]);
> -
> -    /* Step 3 - bring in last of TK bits, assign 24-bit WEP IV value
> -     * WEPSeed[0..2] is transmitted as WEP IV */
> -    WEPSeed[0] = Hi8(IV16);
> -    WEPSeed[1] = (Hi8(IV16) | 0x20) & 0x7F;
> -    WEPSeed[2] = Lo8(IV16);
> -    WEPSeed[3] = Lo8((PPK[5] ^ Mk16_le((u16 *) &TK[0])) >> 1);
> -
> -#ifdef __BIG_ENDIAN
> -    {
> -        int i;
> -        for (i = 0; i < 6; i++)
> -            PPK[i] = (PPK[i] << 8) | (PPK[i] >> 8);
> -    }
> -#endif
> -}
> -
> -
>  static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len,
> void *priv)
>  {
>      struct ieee80211_tkip_data *tkey = priv;
>          int len;
>      u8 *pos;
> +    struct tkip_ctx *tx = NULL;
> +    size_t p1k_len;
>      struct rtl_80211_hdr_4addr *hdr;
>      cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>      struct blkcipher_desc desc = {.tfm = tkey->tx_tfm_arc4};
> @@ -314,2 +287,2 @@ static int ieee80211_tkip_encrypt(struct sk_buff
> *skb, int hdr_len, void *priv)
>      u32 crc;
>      struct scatterlist sg;
>
> +    p1k_len = sizeof(tkey->tx_ttak);
> +    memcpy(&tx->p1k, &tkey->tx_ttak, p1k_len);
> +
>      if (skb_headroom(skb) < 8 || skb_tailroom(skb) < 4 ||
>          skb->len < hdr_len)
>          return -1;
> @@ -327,7 +303,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff
> *skb, int hdr_len, void *priv)
>                      tkey->tx_iv32);
>              tkey->tx_phase1_done = 1;
>          }
> -        tkip_mixing_phase2(rc4key, tkey->key, tkey->tx_ttak,
> tkey->tx_iv16);
> +        tkip_mixing_phase2(tkey->key, tx, tkey->tx_iv16, rc4key);

You've done the exact same thing (define a struct tkip_ctx, p1k_len,
the sizeof() and memcpy() calls) in a few places just to produce the
second argument to tkip_mixing_phase2(). Why not make a helper (say
ieee80211_tkip_mixing_phase2()) that does all of this based on the
struct ieee80211_tkip_data and rc4key arguments? This would also
reduce the amount of stuff that needs to be exported.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
