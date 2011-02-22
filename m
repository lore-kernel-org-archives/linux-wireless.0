Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44341 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab1BVTVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 14:21:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 11:20:43 -0800
Date: Wed, 23 Feb 2011 00:50:40 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 19/23] ath9k_htc: Handle BSSID/AID for multiple interfaces
Message-ID: <20110222192039.GA3932@vmraj-lnx.users.atheros.com>
References: <19809.52184.289748.148298@gargle.gargle.HOWL>
 <20110222053749.GB11916@vmraj-lnx.users.atheros.com>
 <19811.46805.564817.918214@gargle.gargle.HOWL>
 <20110222173936.GB3779@vmraj-lnx.users.atheros.com>
 <19811.63352.778115.482101@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19811.63352.778115.482101@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 22, 2011 at 11:20:48PM +0530, Sujith wrote:
> Rajkumar Manoharan wrote:
> > > > > +	/*
> > > > > +	 * Set the HW AID/BSSID only for the first station interface
> > > > > +	 * or in IBSS mode.
> > > > > +	 */
> > > > > +	set_assoc = !!((priv->ah->opmode == NL80211_IFTYPE_ADHOC) ||
> > > > > +		       ((priv->ah->opmode == NL80211_IFTYPE_STATION) &&
> > > > > +			(priv->num_sta_vif == 1)));
> > > > > +
> > > > > +
> > > > Assume there are two station vifs where one is associated and another is not.
> > > > In such case aid and ani is not configured.
> > > 
> > > That's the intention...
> > >
> > I dont understand why not to start ani on multi-vifs.
> 
> * If an AP interface is present, ANI will be started when adding the interface.
>   If the AP interface is brought down, the remaining interfaces are checked to
>   see if any associated STA interfaces are present before stopping ANI.
> 
> * ANI is started for the first STA interface that makes the transition to associated
>   state. For subsequent managed interfaces, there is no point in re-starting ANI, since
>   it is already running. The check there takes care that ANI is not stopped when one
>   STA interface disconnects.
>
Assume num_sta_vif = 2 and none of the interfaces are associated. Now one of
vif moves to assoc state. set_assoc check would fail so ani will not be started.
Correct me if I am wrong?

--
Rajkumar
