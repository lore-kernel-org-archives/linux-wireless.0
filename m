Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47604 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab2FVLeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 07:34:06 -0400
Date: Fri, 22 Jun 2012 17:05:22 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sven Eckelmann <sven@narfation.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC] ath9k: raise aggregation limit to 64k for HT IBSS
Message-ID: <20120622113520.GA10283@vmraj-lnx.users.atheros.com> (sfid-20120622_133410_464367_852F72FE)
References: <1340355904-861-1-git-send-email-sven@narfation.org>
 <20120622105214.GC7934@vmraj-lnx.users.atheros.com>
 <20010825.m5IpWLuaVf@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20010825.m5IpWLuaVf@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 22, 2012 at 01:10:24PM +0200, Sven Eckelmann wrote:
> On Friday 22 June 2012 16:22:16 Rajkumar Manoharan wrote:
> > > +	/* update ampdu factor/density, they may have changed. This may happen
> > > +	 * in HT IBSS when a beacon with HT-info is received after the station
> > > +	 * has already been added.
> > > +	 */
> > > +	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
> > > +		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
> > > +				     sta->ht_cap.ampdu_factor);
> > > +		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
> > > +		an->mpdudensity = density;
> > > +	}
> > > +
> > 
> > No need to declare local variable. ins't it?
> 
> You want more than 80 chars per line or ugly/complex code...?
>
Never mind. keep the local variable.

-Rajkumar
