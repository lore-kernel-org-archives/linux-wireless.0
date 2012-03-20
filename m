Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2CTLci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 07:32:38 -0400
Subject: RE: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20328.2559.331884.450794@gargle.gargle.HOWL>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 <1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	 <1332065984.3609.5.camel@jlt3.sipsolutions.net>
	 <20326.41009.17936.152095@gargle.gargle.HOWL>
	 <1332145412.3359.2.camel@jlt3.sipsolutions.net>
	 <20327.1220.845693.349959@gargle.gargle.HOWL>
	 <1332151743.3359.19.camel@jlt3.sipsolutions.net>
	 <20327.2859.202760.119343@gargle.gargle.HOWL>
	 <1332155566.3359.22.camel@jlt3.sipsolutions.net>
	 <1332159511.3359.24.camel@jlt3.sipsolutions.net>
	 <20328.2559.331884.450794@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 12:32:34 +0100
Message-ID: <1332243154.3329.4.camel@jlt3.sipsolutions.net> (sfid-20120320_123241_608617_6EBC6D75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-20 at 10:09 +0530, Sujith Manoharan wrote:

> > Also, in order to actually implement it in AP mode we need to use the
> > "RC update only".
> > 
> > I think it makes more sense to unify the handling here -- change rate
> > control (and also tell the driver, like one of my patches did) rather
> > than treating 20/40 changes in managed mode differently than in AP mode.
> 
> Agreed.

So what should we do with ath9k_htc? As I understood you, it relies on
the no-longer updated global channel type?

IOW -- I don't think the patches we were discussing break it, Paul's
patch would already have broken it. However my patch with the new
callback could help you fix it?

johannes

