Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.128.226]:50847 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504Ab0BPXoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 18:44:01 -0500
Date: Tue, 16 Feb 2010 18:43:46 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: give warning if building w/out rate ctrl  
 algorithm
Message-ID: <20100216184346.3c6c1651@droptest.queued.net>
In-Reply-To: <1266361299.8849.26.camel@localhost.localdomain>
References: <20100216161656.42079d77@droptest.queued.net>
	<1266355279.8849.24.camel@localhost.localdomain>
	<20100216165004.010d2c4b@droptest.queued.net>
	<1266361299.8849.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 16 Feb 2010 15:01:39 -0800
Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Andres,
> 
> > > > I discovered that if EMBEDDED=y, one can accidentally build a
> > > > mac80211 stack and drivers w/ no rate control algorithm.  For
> > > > drivers like RTL8187 that don't supply their own RC algorithms,
> > > > this will cause ieee80211_register_hw to fail (making the driver
> > > > unusable).
> > > > 
> > > > This will tell kconfig to provide a warning if no rate control
> > > > algorithms have been selected.  That'll at least warn the user;
> > > > users that know that their drivers supply a rate control
> > > > algorithm can safely ignore the warning, and those who don't
> > > > know (or who expect to be using multiple drivers) can select a
> > > > default RC algorithm.
> > > 
> > > this is not an acceptable policy. You are generating false
> > > positives now for drivers that have been fine before.
> > > 
> > 
> > Unacceptable how?  It's a warning, not a requirement.  It's
> > telling the user to double-check their config.
> 
> and why not either whitelist drivers with their own rate control or
> have the ones without rate control depend on a selection. You can't
> really expect all users to know which driver comes with rate control
> and which doesn't.
> 

Two reasons:

1) It's not clear which drivers should be whitelisted.  *No* driver sets
IEEE80211_HW_HAS_RATE_CONTROL. Some drivers (ath9k, iwlagn, iwl3945)
call ieee80211_rate_control_register().  That's a pretty incomplete
list.

2) Here's a scenario to consider: via menuconfig, a user configures
net/mac80211 (that section comes before drivers/net/wireless); there's
no warning, because iwlagn is already selected in drivers/net/wireless.
They don't select any RC algorithms, and then proceed to
drivers/net/wireless, where they select rtl8187 (maybe they use both,
or maybe iwlagn was just selected as the default, or maybe from an
old .config; who knows?). Rtl8187 requires an RC algorithm, but there's
no warning displayed to the user that RC algorithms aren't being built,
so the user then builds a broken rtl8187 driver.  Maybe the rtl8187
'help' section should be warning the user, or maybe the current warning
should be moved over to drivers/net/wireless/Kconfig, or maybe the
rtl8187 driver should just forcefully select an RC algorithm if none is
selected (which is frowned upon).  This kind of problem is not fixed by
a simplistic whitelist, though.


I'm more than happy to come up w/ a Kconfig framework for drivers to
opt into, stating that they don't require RC, but that's something that
needs wider discussion, feedback from driver authors, and potentially
changes to drivers as well.  In the meantime, a simplistic warning
(suggesting to the user a *safe* choice) is better than nothing, and
hurts no one.
