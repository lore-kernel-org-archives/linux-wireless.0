Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12725 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2GDMoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 08:44:54 -0400
Date: Wed, 4 Jul 2012 18:16:08 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 06/13] cfg80211: track monitor interfaces count
Message-ID: <20120704124606.GA9866@vmraj-lnx.users.atheros.com> (sfid-20120704_144458_567519_B35712C2)
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
 <1340966828-22874-7-git-send-email-michal.kazior@tieto.com>
 <1341400378.12432.4.camel@jlt3.sipsolutions.net>
 <1341400632.12432.5.camel@jlt3.sipsolutions.net>
 <1341401180.12432.6.camel@jlt3.sipsolutions.net>
 <1341401264.12432.7.camel@jlt3.sipsolutions.net>
 <4FF43838.4010908@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FF43838.4010908@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 04, 2012 at 02:34:00PM +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> >On Wed, 2012-07-04 at 13:26 +0200, Johannes Berg wrote:
> >>On Wed, 2012-07-04 at 13:17 +0200, Johannes Berg wrote:
> >>>On Wed, 2012-07-04 at 13:12 +0200, Johannes Berg wrote:
> >>>>Hi Michal,
> >>>>
> >>>>A few people noticed that these patches cause deadlocks. I think the
> >>>>reason is that it's not allowed to lock the device here:
> >>>>
> >>>>>  	case NETDEV_DOWN:
> >>>>>  		dev_hold(dev);
> >>>>>+		cfg80211_lock_rdev(rdev);
> >>>>
> >>>>This causes a deadlock since the interface is set down inside mac80211
> >>>>when inside a handler from cfg80211 already, or so.
> >>>
> >>>I just reproduce it -- it's because we come from nl80211_del_interface()
> >>
> >>Ok ... we don't really need to hold the rdev lock since it's all under
> >>rtnl. Can you please confirm this is safe?
> >>
> >>http://p.sipsolutions.net/bde4760671f3e250.txt
> >
> >I guess we can remove more locking:
> >http://p.sipsolutions.net/8a1b875a431e72a0.txt
> 
> I can't really test it right now, but it looks good to me.
> 
The patch fixes the issue. Works for me.

-Rajkumar
