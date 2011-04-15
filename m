Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1DOHKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 03:10:06 -0400
Subject: Re: [PATCH 2/2] ath9k_htc: Cleanup HTC debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Sujith <m.sujith@gmail.com>,
	Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110415070626.GB23429@vmraj-lnx.users.atheros.com>
References: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
	 <1302848033-7072-2-git-send-email-rmanoharan@atheros.com>
	 <19879.59459.480384.309998@gargle.gargle.HOWL>
	 <20110415070626.GB23429@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 09:10:00 +0200
Message-ID: <1302851401.3572.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-15 at 12:36 +0530, Rajkumar Manoharan wrote:

> > > @@ -150,6 +149,10 @@ static void ath9k_deinit_device(struct ath9k_htc_priv *priv)
> > >  {
> > >  	struct ieee80211_hw *hw = priv->hw;
> > >  
> > > +	if (priv->debug.debugfs_phy) {
> > > +		debugfs_remove_recursive(priv->debug.debugfs_phy);
> > > +		priv->debug.debugfs_phy = NULL;
> > > +	}
> > 
> > It would be consistent to have this chunk of code in ath9k_htc_exit_debug().
> >
> I think mac80211 handles debugfs_remove_recursive. isn't it?
> If so, Shall I remove it?

cfg80211 will remove all per wiphy debugfs files, but you might want to
remove them before so nobody accesses them while you're uninitialising.

johannes

