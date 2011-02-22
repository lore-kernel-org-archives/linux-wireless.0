Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32396 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1BVRkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 12:40:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 09:39:46 -0800
Date: Tue, 22 Feb 2011 23:09:43 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 19/23] ath9k_htc: Handle BSSID/AID for multiple interfaces
Message-ID: <20110222173936.GB3779@vmraj-lnx.users.atheros.com>
References: <19809.52184.289748.148298@gargle.gargle.HOWL>
 <20110222053749.GB11916@vmraj-lnx.users.atheros.com>
 <19811.46805.564817.918214@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19811.46805.564817.918214@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 22, 2011 at 06:45:01PM +0530, Sujith wrote:
> Rajkumar Manoharan wrote:
> > > +	/*
> > > +	 * The beacon paramters are configured only for the first
> > > +	 * station interface.
> > > +	 */
> > > +	if ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
> > > +	    (priv->num_sta_vif > 1) &&
> > > +	    (vif->type == NL80211_IFTYPE_STATION)) {
> > > +		ath_dbg(common, ATH_DBG_CONFIG,
> > > +			"Beacon already configured for a station interface\n");
> > > +		return;
> > > +	}
> > > +
> > This will not allow beacon config if your first station vif was not yet
> > associated.
> 
> Good catch.
> 
> > > +	/*
> > > +	 * Set the HW AID/BSSID only for the first station interface
> > > +	 * or in IBSS mode.
> > > +	 */
> > > +	set_assoc = !!((priv->ah->opmode == NL80211_IFTYPE_ADHOC) ||
> > > +		       ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
> > > +			(priv->num_sta_vif == 1)));
> > > +
> > > +
> > Assume there are two station vifs where one is associated and another is not.
> > In such case aid and ani is not configured.
> 
> That's the intention...
>
I dont understand why not to start ani on multi-vifs.

--
Rajkumar
