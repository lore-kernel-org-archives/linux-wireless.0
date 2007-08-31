Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57986
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbXHaNEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 09:04:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: revamp key handling
Date: Fri, 31 Aug 2007 15:03:34 +0200
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <20070821155725.489738000@sipsolutions.net> <20070821160001.763985000@sipsolutions.net> <1188517504.7585.17.camel@johannes.berg>
In-Reply-To: <1188517504.7585.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708311503.35568.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 August 2007, Johannes Berg wrote:
> Huh, this turned out to be buggy in b43:
> 
> > @@ -2921,13 +2919,15 @@ static int b43_dev_set_key(struct ieee80
> >  			err = b43_key_write(dev, index, algorithm,
> >  					    key->key, key->keylen, NULL, key);
> >  		} else {
> > +			/*
> > +			 * either pairwise key or address is 00:00:00:00:00:00
> > +			 * for transmit-only keys
> > +			 */
> >  			err = b43_key_write(dev, -1, algorithm,
> >  					    key->key, key->keylen, addr, key);
> >  		}
> > -		if (err) {
> > -			key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
> > +		if (err)
> >  			goto out_unlock;
> > -		}
> >  		dev->key[key->hw_key_idx].enabled = 1;
> >  
> >  		if (algorithm == B43_SEC_ALGO_WEP40 ||
> 
> The same obviously has to be done when deleting keys. Michael, you can
> either use the patch below or rework it to use the hw_key_idx to delete
> the key.
> 
> Interestingly, this way I found out that when the B43_RX_MAC_DECERR flag
> is set on a frame, then the hardware has decrypted the data with the
> wrong key and then found that the ICV isn't correct so that the data is
> completely mangled. Hence, you should simply drop the frame in that case
> instead of passing it up, mac80211 will simply again attempt to decrypt
> it and, since the frame is already decrypted with the wrong key, only
> get garbage. This could even be used to DoS a machine with little
> resources like an AP: simply send a lot of broken frames that mac80211
> will try to decrypt in software.

I am sorry. I introduced this as I didn't understand my own weird code anymore. :)
I think I'll fix this by using the hw_key_idx.
