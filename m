Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:58599 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaAGRfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 12:35:04 -0500
Received: by mail-we0-f175.google.com with SMTP id w62so439181wes.20
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 09:35:02 -0800 (PST)
Date: Tue, 7 Jan 2014 18:34:06 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
Message-ID: <20140107173405.GA7267@magnum.frso.rivierawaves.com> (sfid-20140107_183534_789785_24A61C23)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
 <874n67eabn.fsf@kamboji.qca.qualcomm.com>
 <20140106180150.GB5358@magnum.frso.rivierawaves.com>
 <1389108818.4645.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1389108818.4645.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 07, 2014 at 04:33:38PM +0100, Johannes Berg wrote:
> On Mon, 2014-01-06 at 19:01 +0100, Karl Beldan wrote:
> 
> > +	if (vif->csa_active) {
> > +		vp->csa_bcn_cnt++;
> 
> I don't see any readers of this variable?
> 
> > +		if (vp->csa_finished) {
> > +			wiphy_debug(hw->wiphy,"%s extra CSA-beacon\n", __func__);
> > +		} else if (ieee80211_csa_is_complete(vif)) {
> > +			wiphy_debug(hw->wiphy,
> > +				    "%s CSA complete after %d beacons\n",
> > +				    __func__, vp->csa_bcn_cnt);
> 
> except for the debug, but is that really useful?
> 
In a sim/debug module ? I found it appropriate ;)
Seriously I have no strong opinion on this matter, as I said, feel free
to do whatever you want with this, there's nothing critical here.

> > +			ieee80211_csa_finish(vif);
> > +			vp->csa_finished = true;
> 
> and if we remove the other debug we can also remove the csa_finished
> variable, that seems reasonable to me since mac80211 would already warn
> anyway, no?
> 
I just got rid of a big blahblah I got for this, please, adjust as you
see fit as I have no strong opinion on this matter.

 
Karl
