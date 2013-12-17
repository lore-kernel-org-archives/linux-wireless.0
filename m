Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39683 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LQNMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 08:12:51 -0500
Received: by mail-oa0-f45.google.com with SMTP id o6so6557198oag.32
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 05:12:51 -0800 (PST)
Date: Tue, 17 Dec 2013 07:12:50 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: [RFC PATCH 2/8] mac80211: Add per-interface powersave states and
 parameters
Message-ID: <20131217131250.GA5175@ubuntu-mba51> (sfid-20131217_141257_515151_C78BB0A0)
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
 <1387231260-2849-3-git-send-email-seth.forshee@canonical.com>
 <1387267898.4749.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387267898.4749.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 17, 2013 at 09:11:38AM +0100, Johannes Berg wrote:
> On Mon, 2013-12-16 at 16:00 -0600, Seth Forshee wrote:
> > In preparation for managing powersave states on a per-interface
> > basis, add powersave states and parameters to the interface-
> > specific data structures. Also add a change_ps driver callback
> > to notify drivers about changes to interface powersave states.
> > 
> > The new members and callback are unused here but will be
> > utilized by subsequent commits.
> 
> Can't say I like that part much, it just makes it harder to review.

Okay, I can squash it into the other patch easily enough.

> >  /**
> > + * enum ieee80211_vif_ps_mode - virtual interface power save mode
> > + *
> > + * Ordered in terms of increasing wakefulness.
> > + *
> > + * @IEEE80211_VIF_PS_INACTIVE: the interface is not currently open
> > + * @IEEE80211_VIF_PS_DOZE: the interface is in a low-power mode and may
> > + *	not be able to transmit or receive frames
> > + * @IEEE80211_VIF_PS_AWAKE_PM: the interface is awake and able to transmit
> > + *	and receive frames but PM may be set in frame control
> > + * @IEEE80211_VIF_PS_AWAKE: the interface is fully awake and able to
> > + *	transmit and receive frames
> > + */
> > +enum ieee80211_vif_ps_mode {
> > +	IEEE80211_VIF_PS_INACTIVE,
> 
> Does this INACTIVE thing really make sense? It should just be undefined
> if it's not associated, no? Doing this might make people want to rely on
> this to indicate associated-ness or something...

I use it to detect attempts to set the PS mode on interface which aren't
opened, but perhaps that isn't necessary. I'll look into it.

> > +	IEEE80211_VIF_PS_AWAKE_PM,
> > +	IEEE80211_VIF_PS_AWAKE,
> 
> The distinction between these seems somewhat unclear? "PM may be set"?

This is for Broadcom. It needs to be told somehow that mac80211 wants to
transmit frames with PM set, otherwise it's clearing them in the HW. I
thought about using a flag too, so long as there's some way to tell it
to set PM without powering down the hw.

> > + * @ps_mode: power save mode of this vif
> > + * @dynamic_ps_active: indicates whether dynamic PS is active for this vif
> > + * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
> > + *	powersave documentation below. This variable is valid only when
> > + *	the interface is in the doze state.
> > + * @max_sleep_period: the maximum number of beacon intervals to sleep for
> > + *	before checking the beacon for a TIM bit (managed mode only); this
> > + *	value will be only achievable between DTIM frames, the hardware
> > + *	needs to check for the multicast traffic bit in DTIM beacons.
> > + *	This variable is valid only when the interface is in the doze state.
> > + * @ps_dtim_period: The DTIM period of the AP we're connected to, for use
> > + *	in power saving. Power saving will not be enabled until a beacon
> > + *	has been received and the DTIM period is known.
> 
> Should these really be in the vif struct? They still seem somewhat
> internal to the implementation.

I made an assumption that multi-interface drivers would want to be told
about PS states and parameters for individual interfaces. This
notification happens via the change_ps callback using these members from
the vif.
