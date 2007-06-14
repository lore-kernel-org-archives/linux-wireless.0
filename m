Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:48794 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXFNO3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 10:29:31 -0400
Date: Thu, 14 Jun 2007 16:29:27 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: more nl80211/iw tool code comments
Message-ID: <20070614142925.GA24414@charon.n2.diac24.net>
References: <1181759017.29767.117.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1181759017.29767.117.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On Wed, Jun 13, 2007 at 08:23:37PM +0200, Johannes Berg wrote:
> get_phymode should probably be more strict and not accept things like
> "IEEEabg" as A mode. 
Changed.

> get_iftype should accept "ap-vlan" which str_iftype returns, although
> it's not really useful for use by hand anyway, I think.
"Oups."

> Another thing: Maybe it should be possible to say "phy# 1" in addition
> to "phy phy1" so that it's easier to write scripts that don't care about
> concurrent phy name changes? Just a thought.
Added, using "phy %0" syntax.

The entire iw tool is really just a hack btw...


> iw phy set      [ phy ] DEVICE [ CHANSPEC ] [ name NEWNAME ]
> 
> and we discussed on IRC that it might make sense to have the same for
> nl80211. On the surface, that makes sense, however, it does add a
> complication in that we need to either specify that you cannot combine
> some attributes (which doesn't really make sense), 
Hmm, I can't come up with any example other than using some 11n attribute
with a 11abg phymode... care to hit me with a hint?

>                                                    or we need to take
> quite a bit of care with atomicity; setting the channel and changing the
> phy name can both fail individually but having them in one netlink
> message implies that it's one transaction. I'm not sure the somewhat
> cleaner API and saving one command number is worth the additional
> transactional safety we need to be careful with then.
> 
> So I'd like to reverse my previously stated opinion and say that I now
> think that putting these orthogonal things into different commands would
> be better so that we don't run into this transaction problem.

Well, ... take a look at net/core/rtnetlink.c line 716:

	if (err < 0 && modified && net_ratelimit())
		printk(KERN_WARNING "A link change request failed with "
		       "some changes comitted already. Interface %s may "
		       "have been left with an inconsistent configuration, "
		       "please check.\n", dev->name);

So, if rtnetlink doesn't bother too much about "transaction safety" either,
why should we? If an app wants to know what failed, it can still send SET
requests broken down into pieces, so they will know which piece failed.
Obviously they need to leave some stuff grouped (e.g. PHYMODE and CHANNEL),
but I don't think it's useful to force them do so by breaking stuff into
multiple commands...

(There is no difference really between
	CMD_SET_PHY name=myphy
	CMD_SET_PHY phymode=a channel=1
and
	CMD_SET_PHYNAME name=myphy
	CMD_SET_CHANNEL phymode=a channel=1
but the former allows, if we don't care, to just batch it.)


-David

P.S.: I'm a bit busy and won't have time to work on stuff until approx.
next Monday. Oh and I overdid a bit on the "documentation"...
http://git.spaceboyz.net/nl80211/nl80211-meta.git/master:/nl80211doc.html
(note the quad'ified attempt at associating ;)

