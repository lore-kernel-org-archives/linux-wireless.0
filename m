Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaCXRqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 13:46:03 -0400
Message-ID: <1395683157.4276.0.camel@jlt4.sipsolutions.net> (sfid-20140324_184743_492447_98ACB3AC)
Subject: Re: [RFC] cfg80211: allow userspace to take ownership of interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Mon, 24 Mar 2014 18:45:57 +0100
In-Reply-To: <53306CC7.2010709@broadcom.com>
References: <1395680275-11657-1-git-send-email-johannes@sipsolutions.net>
	 <53306CC7.2010709@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-24 at 18:35 +0100, Arend van Spriel wrote:

> > To avoid this problem, introduce an ownership concept for interfaces. If
> > an interface is owned by a netlink socket, then it will be destroyed if
> > the netlink socket is closed for any reason, including if the process it
> > belongs to crashed. This gives us a race-free way to get rid of any such
> > interfaces.
> 
> Excellent idea.

:)

> > + * @NL80211_ATTR_IFACE_SOCKET_OWNER: flag attribute, if set during interface
> > + *	creation then the new interface will be owned by the netlink socket
> > + *	that created it and will be destroyed when the socket is closed
> > + *
> 
> Guess you want explicit flag so apps like iw can still create 
> interfaces, right?

Right, otherwise iw exits and the interface is destroyed immediately (I
did that for my testcase :) )

> > @@ -11662,6 +11675,19 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
> >   			}
> >   		}
> >   		spin_unlock_bh(&rdev->beacon_registrations_lock);
> > +
> > +		if (schedule_destroy_work) {
> > +			struct cfg80211_iface_destroy *destroy;
> > +
> > +			destroy = kzalloc(sizeof(*destroy), GFP_ATOMIC);
> 
> Probably overlooking it, because it is not part of the patch but: what 
> lock requires this to be atomic? rcu_read_lock?

yes, but even if we moved it out it wouldn't help since it's an atomic
notifier chain

johannes

