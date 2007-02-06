Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40001
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXBFPDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 10:03:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH RFC] d80211: Fix TKIP phase1 key mixing for hwcrypto
Date: Tue, 6 Feb 2007 16:02:45 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
References: <200702031832.48505.mb@bu3sch.de> <20070205221957.3c9003b5@griffin.suse.cz>
In-Reply-To: <20070205221957.3c9003b5@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702061602.45510.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 February 2007 22:19, Jiri Benc wrote:
> On Sat, 3 Feb 2007 18:32:48 +0100, Michael Buesch wrote:
> > @@ -192,10 +192,15 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
> >  
> >  
> >  void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
> > -				  u16 *phase1key)
> > +				  u8 *phase1key)
> >  {
> > +	__le16 *k = (__le16 *)phase1key;
> > +	int i;
> > +
> >  	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
> > -			   key->u.tkip.iv32, phase1key);
> > +			   key->u.tkip.iv32, (u16 *)k);
> > +	for (i = 0; i < 5; i++)
> > +		k[i] = cpu_to_le16(k[i]);
> >  }
> 
> Maybe a slightly better type checking but still looks ugly:

Hm, well. I don't really see how typechecking is better in this case,
but if you like it more, I'm ok with it. ;)

> @@ -192,10 +192,16 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
>  
>  
>  void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
> -				  u16 *phase1key)
> +				  u8 *phase1key)
>  {
> +	u16 *tmp_result = (u16 *)phase1key;
> +	__le16 *k = (__le16 *)phase1key;
> +	int i;
> +
>  	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
> -			   key->u.tkip.iv32, phase1key);
> +			   key->u.tkip.iv32, tmp_result);
> +	for (i = 0; i < 5; i++)
> +		k[i] = cpu_to_le16(tmp_result[i]);
>  }
>  
>  void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
> 
> 
> Moreover, I'm not sure if GCC is able to optimize out the for loop in
> this case :-(

Yeah, I was going to check this and was going to add #ifdefs if it doesn't.
But that was not my major concern at this point.
It was more that people agree to me that it _is_ broken on BE platforms.
(I cannot test it, yet, as tkip has other problems for bcm43xx).

-- 
Greetings Michael.
