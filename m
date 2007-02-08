Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37431 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752384AbXBHSRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 13:17:37 -0500
Date: Thu, 8 Feb 2007 19:17:35 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH RFC] d80211: Fix TKIP phase1 key mixing for hwcrypto
Message-ID: <20070208191735.04b1e7d8@griffin.suse.cz>
In-Reply-To: <200702061602.45510.mb@bu3sch.de>
References: <200702031832.48505.mb@bu3sch.de>
	<20070205221957.3c9003b5@griffin.suse.cz>
	<200702061602.45510.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Feb 2007 16:02:45 +0100, Michael Buesch wrote:
> On Monday 05 February 2007 22:19, Jiri Benc wrote:
> > On Sat, 3 Feb 2007 18:32:48 +0100, Michael Buesch wrote:
> > > @@ -192,10 +192,15 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
> > >  
> > >  
> > >  void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
> > > -				  u16 *phase1key)
> > > +				  u8 *phase1key)
> > >  {
> > > +	__le16 *k = (__le16 *)phase1key;
> > > +	int i;
> > > +
> > >  	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
> > > -			   key->u.tkip.iv32, phase1key);
> > > +			   key->u.tkip.iv32, (u16 *)k);
> > > +	for (i = 0; i < 5; i++)
> > > +		k[i] = cpu_to_le16(k[i]);
> > >  }
> > 
> > Maybe a slightly better type checking but still looks ugly:
> 
> Hm, well. I don't really see how typechecking is better in this case,

cpu_to_le16 with a __le16 variable as a parameter always looks
suspicious. In the version I sent it is at least clear that it's
intended.

> but if you like it more, I'm ok with it. ;)

I dislike both of them but have no better idea.

> Yeah, I was going to check this and was going to add #ifdefs if it doesn't.
> But that was not my major concern at this point.
> It was more that people agree to me that it _is_ broken on BE platforms.

Looks like it is.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
