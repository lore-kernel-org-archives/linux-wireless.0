Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36282 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdFRUoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 16:44:20 -0400
Message-ID: <1497818656.2259.1.camel@sipsolutions.net> (sfid-20170618_224425_434923_30560691)
Subject: Re: [PATCH] mac80211/wpa: use constant time memory comparison for
 MACs
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Sun, 18 Jun 2017 22:44:16 +0200
In-Reply-To: <CANUX_P1=8R5E8uk7VsqyAXQvRD52J1XdcL1R6R6GJeM_dv85vw@mail.gmail.com> (sfid-20170618_223154_508671_F7CC4FB5)
References: <1497720871224217@kroah.com>
         <20170618191854.17767-1-Jason@zx2c4.com>
         <CANUX_P1=8R5E8uk7VsqyAXQvRD52J1XdcL1R6R6GJeM_dv85vw@mail.gmail.com>
         (sfid-20170618_223154_508671_F7CC4FB5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-06-18 at 23:31 +0300, Emmanuel Grumbach wrote:
> On Sun, Jun 18, 2017 at 10:18 PM, Jason A. Donenfeld <Jason@zx2c4.com
> > wrote:
> > Otherwise, we enable all sorts of forgeries via timing attack.
> 
> crypto_memneq's description says:
[...]
> > ---
> > Here's the backport for 3.18.

Yeah, not sure what happened here, but ...

> >  #include "ieee80211_i.h"
> >  #include "michael.h"
> > @@ -150,7 +151,7 @@ ieee80211_rx_h_michael_mic_verify(struct
> > ieee80211_rx_data *rx)
> >         data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
> >         key = &rx->key-
> > >conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
> >         michael_mic(key, hdr, data, data_len, mic);
> > -       if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0)
> > +       if (crypto_memneq(mic, data + data_len, MICHAEL_MIC_LEN) !=
> > 0)
> >                 goto mic_fail;

This is obviously wrong and not like that in the original,

> >         /* remove Michael MIC from payload */
> > @@ -520,7 +521,7 @@ ieee80211_crypto_ccmp_decrypt(struct
> > ieee80211_rx_data *rx)
> > 
> >         queue = rx->security_idx;
> > 
> > -       if (memcmp(pn, key->u.ccmp.rx_pn[queue],
> > IEEE80211_CCMP_PN_LEN) <= 0) {
> > +       if (crypto_memneq(pn, key->u.ccmp.rx_pn[queue],
> > IEEE80211_CCMP_PN_LEN) <= 0) {
> >                 key->u.ccmp.replays++;
> >                 return RX_DROP_UNUSABLE;
> >         }

this isn't in the original at all, and clearly shouldn't be here,

> > @@ -771,7 +772,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct
> > ieee80211_rx_data *rx)
> >                 bip_aad(skb, aad);
> >                 ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
> >                                    skb->data + 24, skb->len - 24,
> > mic);
> > -               if (memcmp(mic, mmie->mic, sizeof(mmie->mic)) != 0)
> > {
> > +               if (crypto_memneq(mic, mmie->mic, sizeof(mmie-
> > >mic)) != 0) {

and this is just as wrong as the first one.

johannes
