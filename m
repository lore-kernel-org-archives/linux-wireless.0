Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:10311 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757614AbXFRJmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 05:42:05 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: phy mode, channel -> freq mapping (was RE: more nl80211/iw tool code comments)
Date: Mon, 18 Jun 2007 02:42:01 -0700
Message-ID: <285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com>
References: <1181759017.29767.117.camel@johannes.berg> <20070614142925.GA24414@charon.n2.diac24.net>
From: "Sandesh Goel" <sgoel@marvell.com>
To: "David Lamparter" <lists@diac24.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a high level comment on the whole phy mode, channel and frequency
mapping business.

I think it is cleaner to define a parameter called BAND which can take
values 2.4 GHz, 5 GHz and so on. Then, the combination of BAND and
CHANNEL will uniquely define the operating frequency.

Using PHY_MODE for this purpose is redundant and confusing in my
opinion. Following is the relationship between BAND and PHY_MODE. 

If BAND is 2.4 GHz, PHY_MODE can be either b, g or n.
If BAND is 5 GHZ, PHY_MODE can be a or n.

Note that 'n' is common to both bands and hence PHY_MODE of 'n' alone
can not define the frequency uniquely. PHY_MODE and BAND were almost
equivalent when only 802.11a and 802.11b were around, but certainly not
any more. If this is not handled properly, it can get quite ugly down
the road.

I wasn't sure if this has already been thought about. I look forward to
being educated if I am missing something.

Thanks,
Sandesh

PS: David, I appreciate your attempt at documenting the API; it got me
interested in reviewing this.

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of David
Lamparter
Sent: Thursday, June 14, 2007 7:59 PM
To: Johannes Berg
Cc: linux-wireless
Subject: Re: more nl80211/iw tool code comments

Hi!

On Wed, Jun 13, 2007 at 08:23:37PM +0200, Johannes Berg wrote:
> get_phymode should probably be more strict and not accept things like
> "IEEEabg" as A mode. 
Changed.

> get_iftype should accept "ap-vlan" which str_iftype returns, although
> it's not really useful for use by hand anyway, I think.
"Oups."

> Another thing: Maybe it should be possible to say "phy# 1" in addition
> to "phy phy1" so that it's easier to write scripts that don't care
about
> concurrent phy name changes? Just a thought.
Added, using "phy %0" syntax.

The entire iw tool is really just a hack btw...


> iw phy set      [ phy ] DEVICE [ CHANSPEC ] [ name NEWNAME ]
> 
> and we discussed on IRC that it might make sense to have the same for
> nl80211. On the surface, that makes sense, however, it does add a
> complication in that we need to either specify that you cannot combine
> some attributes (which doesn't really make sense), 
Hmm, I can't come up with any example other than using some 11n
attribute
with a 11abg phymode... care to hit me with a hint?

>                                                    or we need to take
> quite a bit of care with atomicity; setting the channel and changing
the
> phy name can both fail individually but having them in one netlink
> message implies that it's one transaction. I'm not sure the somewhat
> cleaner API and saving one command number is worth the additional
> transactional safety we need to be careful with then.
> 
> So I'd like to reverse my previously stated opinion and say that I now
> think that putting these orthogonal things into different commands
would
> be better so that we don't run into this transaction problem.

Well, ... take a look at net/core/rtnetlink.c line 716:

	if (err < 0 && modified && net_ratelimit())
		printk(KERN_WARNING "A link change request failed with "
		       "some changes comitted already. Interface %s may
"
		       "have been left with an inconsistent
configuration, "
		       "please check.\n", dev->name);

So, if rtnetlink doesn't bother too much about "transaction safety"
either,
why should we? If an app wants to know what failed, it can still send
SET
requests broken down into pieces, so they will know which piece failed.
Obviously they need to leave some stuff grouped (e.g. PHYMODE and
CHANNEL),
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
http://git.spaceboyz.net/nl80211/nl80211-meta.git/master:/nl80211doc.htm
l
(note the quad'ified attempt at associating ;)

-
To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
