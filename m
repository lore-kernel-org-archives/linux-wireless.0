Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63883 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1BVNPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 08:15:00 -0500
Received: by iwn34 with SMTP id 34so530243iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 05:15:00 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19811.46805.564817.918214@gargle.gargle.HOWL>
Date: Tue, 22 Feb 2011 18:45:01 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 19/23] ath9k_htc: Handle BSSID/AID for multiple interfaces
In-Reply-To: <20110222053749.GB11916@vmraj-lnx.users.atheros.com>
References: <19809.52184.289748.148298@gargle.gargle.HOWL>
	<20110222053749.GB11916@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> > +	/*
> > +	 * The beacon paramters are configured only for the first
> > +	 * station interface.
> > +	 */
> > +	if ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
> > +	    (priv->num_sta_vif > 1) &&
> > +	    (vif->type == NL80211_IFTYPE_STATION)) {
> > +		ath_dbg(common, ATH_DBG_CONFIG,
> > +			"Beacon already configured for a station interface\n");
> > +		return;
> > +	}
> > +
> This will not allow beacon config if your first station vif was not yet
> associated.

Good catch.

> > +	/*
> > +	 * Set the HW AID/BSSID only for the first station interface
> > +	 * or in IBSS mode.
> > +	 */
> > +	set_assoc = !!((priv->ah->opmode == NL80211_IFTYPE_ADHOC) ||
> > +		       ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
> > +			(priv->num_sta_vif == 1)));
> > +
> > +
> Assume there are two station vifs where one is associated and another is not.
> In such case aid and ani is not configured.

That's the intention...

Sujith
