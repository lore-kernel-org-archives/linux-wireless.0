Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2GDL1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:27:46 -0400
Message-ID: <1341401264.12432.7.camel@jlt3.sipsolutions.net> (sfid-20120704_132749_752933_DD7057D2)
Subject: Re: [PATCH 06/13] cfg80211: track monitor interfaces count
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Date: Wed, 04 Jul 2012 13:27:44 +0200
In-Reply-To: <1341401180.12432.6.camel@jlt3.sipsolutions.net> (sfid-20120704_132627_061268_46C684C8)
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
	 <1340966828-22874-7-git-send-email-michal.kazior@tieto.com>
	 <1341400378.12432.4.camel@jlt3.sipsolutions.net>
	 (sfid-20120704_131306_010478_4A0DA490) <1341400632.12432.5.camel@jlt3.sipsolutions.net>
	 (sfid-20120704_131718_037897_66E57863) <1341401180.12432.6.camel@jlt3.sipsolutions.net>
	 (sfid-20120704_132627_061268_46C684C8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 13:26 +0200, Johannes Berg wrote:
> On Wed, 2012-07-04 at 13:17 +0200, Johannes Berg wrote:
> > On Wed, 2012-07-04 at 13:12 +0200, Johannes Berg wrote:
> > > Hi Michal,
> > > 
> > > A few people noticed that these patches cause deadlocks. I think the
> > > reason is that it's not allowed to lock the device here:
> > > 
> > > >  	case NETDEV_DOWN:
> > > >  		dev_hold(dev);
> > > > +		cfg80211_lock_rdev(rdev);
> > > 
> > > This causes a deadlock since the interface is set down inside mac80211
> > > when inside a handler from cfg80211 already, or so.
> > 
> > I just reproduce it -- it's because we come from nl80211_del_interface()
> 
> Ok ... we don't really need to hold the rdev lock since it's all under
> rtnl. Can you please confirm this is safe?
> 
> http://p.sipsolutions.net/bde4760671f3e250.txt

I guess we can remove more locking:
http://p.sipsolutions.net/8a1b875a431e72a0.txt

johannes

