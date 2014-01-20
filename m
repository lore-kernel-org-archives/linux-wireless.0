Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaATLJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 06:09:44 -0500
Message-ID: <1390216180.4335.20.camel@jlt4.sipsolutions.net> (sfid-20140120_120948_017638_A23A5442)
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 20 Jan 2014 12:09:40 +0100
In-Reply-To: <20140107173405.GA7267@magnum.frso.rivierawaves.com> (sfid-20140107_183503_827315_9BED6D6F)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
	 <874n67eabn.fsf@kamboji.qca.qualcomm.com>
	 <20140106180150.GB5358@magnum.frso.rivierawaves.com>
	 <1389108818.4645.11.camel@jlt4.sipsolutions.net>
	 <20140107173405.GA7267@magnum.frso.rivierawaves.com>
	 (sfid-20140107_183503_827315_9BED6D6F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 18:34 +0100, Karl Beldan wrote:
> On Tue, Jan 07, 2014 at 04:33:38PM +0100, Johannes Berg wrote:
> > On Mon, 2014-01-06 at 19:01 +0100, Karl Beldan wrote:
> > 
> > > +	if (vif->csa_active) {
> > > +		vp->csa_bcn_cnt++;
> > 
> > I don't see any readers of this variable?
> > 
> > > +		if (vp->csa_finished) {
> > > +			wiphy_debug(hw->wiphy,"%s extra CSA-beacon\n", __func__);
> > > +		} else if (ieee80211_csa_is_complete(vif)) {
> > > +			wiphy_debug(hw->wiphy,
> > > +				    "%s CSA complete after %d beacons\n",
> > > +				    __func__, vp->csa_bcn_cnt);
> > 
> > except for the debug, but is that really useful?
> > 
> In a sim/debug module ? I found it appropriate ;)
> Seriously I have no strong opinion on this matter, as I said, feel free
> to do whatever you want with this, there's nothing critical here.
> 
> > > +			ieee80211_csa_finish(vif);
> > > +			vp->csa_finished = true;
> > 
> > and if we remove the other debug we can also remove the csa_finished
> > variable, that seems reasonable to me since mac80211 would already warn
> > anyway, no?
> > 
> I just got rid of a big blahblah I got for this, please, adjust as you
> see fit as I have no strong opinion on this matter.

Well, heh. That'd mean learning all about the API? I think I have a
patch somewhere from somebody else that looked simpler, I think I'll
take that and see what happens.

johannes

