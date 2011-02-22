Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35148 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1BVRuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 12:50:46 -0500
Received: by gyh20 with SMTP id 20so453558gyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 09:50:46 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19811.63352.778115.482101@gargle.gargle.HOWL>
Date: Tue, 22 Feb 2011 23:20:48 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 19/23] ath9k_htc: Handle BSSID/AID for multiple interfaces
In-Reply-To: <20110222173936.GB3779@vmraj-lnx.users.atheros.com>
References: <19809.52184.289748.148298@gargle.gargle.HOWL>
	<20110222053749.GB11916@vmraj-lnx.users.atheros.com>
	<19811.46805.564817.918214@gargle.gargle.HOWL>
	<20110222173936.GB3779@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> > > > +	/*
> > > > +	 * Set the HW AID/BSSID only for the first station interface
> > > > +	 * or in IBSS mode.
> > > > +	 */
> > > > +	set_assoc = !!((priv->ah->opmode == NL80211_IFTYPE_ADHOC) ||
> > > > +		       ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
> > > > +			(priv->num_sta_vif == 1)));
> > > > +
> > > > +
> > > Assume there are two station vifs where one is associated and another is not.
> > > In such case aid and ani is not configured.
> > 
> > That's the intention...
> >
> I dont understand why not to start ani on multi-vifs.

* If an AP interface is present, ANI will be started when adding the interface.
  If the AP interface is brought down, the remaining interfaces are checked to
  see if any associated STA interfaces are present before stopping ANI.

* ANI is started for the first STA interface that makes the transition to associated
  state. For subsequent managed interfaces, there is no point in re-starting ANI, since
  it is already running. The check there takes care that ANI is not stopped when one
  STA interface disconnects.

Sujith
