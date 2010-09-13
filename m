Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:5299 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754104Ab0IMBhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 21:37:33 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-022923200
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 10:10:39 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 3/8] ath5k: Use common ath key management functions
Date: Mon, 13 Sep 2010 10:09:59 +0900
Cc: me@bobcopeland.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20100908070427.11255.17659.stgit@tt-desk> <20100908070443.11255.13951.stgit@tt-desk> <20100911172250.GE20385@hash.localnet>
In-Reply-To: <20100911172250.GE20385@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009131009.59765.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun September 12 2010 02:22:50 me@bobcopeland.com wrote:
> On Wed, Sep 08, 2010 at 04:04:43PM +0900, Bruno Randolf wrote:
> > Use common ath key management functions in ath5k. This fixes problems
> > with HW encryption in AP mode, which was broken in the ath5k
> > implementation.
> 
> We went from this:
> > -		key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
> > -			       IEEE80211_KEY_FLAG_GENERATE_MMIC);
> 
> to:
> > +			/* push IV and Michael MIC generation to stack */
> > +			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
> > +			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
> > +				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
> 
> There's no need to special case the flags based on whether the
> cipher is TKIP; mac80211 does this already.
> 
> > +			if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
> > +				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
> 
> Ditto, this already only affects CCMP in mac80211 (btw, why can't we do
> management frames in hardware?) so it can be more simply written as:
> 
> key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
>                IEEE80211_KEY_FLAG_GENERATE_MMIC |
>                IEEE80211_KEY_FLAG_SW_MGMT);

i just copied the code from ath9k, but you're right - i'll simplify it and 
send a patch v2.

i don't know wether we can encrypt management frames in HW, so until this is 
sorted out, i disabled it.

bruno


