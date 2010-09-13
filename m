Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:27986 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab0IMBRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 21:17:55 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-031396656
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 10:17:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: bob@bobcopeland.com
Subject: Re: [PATCH 6/8] ath5k: Use common crypt capabilities flags
Date: Mon, 13 Sep 2010 10:17:35 +0900
References: <20100908070427.11255.17659.stgit@tt-desk> <20100908070459.11255.52256.stgit@tt-desk> <20100911172752.GH20385@hash.localnet>
In-Reply-To: <20100911172752.GH20385@hash.localnet>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009131017.35762.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun September 12 2010 02:27:52 you wrote:
> On Wed, Sep 08, 2010 at 04:04:59PM +0900, Bruno Randolf wrote:
> > Replace ah_aes_support and ah_combined_mic with common ath_crypt_caps
> > ATH_CRYPT_CAP_CIPHER_AESCCM and ATH_CRYPT_CAP_MIC_COMBINED.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > --- a/drivers/net/wireless/ath/ath5k/base.c
> > +++ b/drivers/net/wireless/ath/ath5k/base.c
> > @@ -3298,7 +3298,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum
> > set_key_cmd cmd,
> > 
> >  	case WLAN_CIPHER_SUITE_TKIP:
> >  		break;
> >  	
> >  	case WLAN_CIPHER_SUITE_CCMP:
> > -		if (sc->ah->ah_aes_support)
> > +		if (common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)
> > 
> >  			break;
> >  		
> >  		return -EOPNOTSUPP;
> 
> This could be done by the common code too, right?

yes... ath9k doesn't do this, but i left the old code because i wasn't sure if 
we need it or not. can we sort this out in a following patch?

bruno
