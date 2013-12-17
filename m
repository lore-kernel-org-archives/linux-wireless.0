Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3LQILl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 03:11:41 -0500
Message-ID: <1387267898.4749.4.camel@jlt4.sipsolutions.net> (sfid-20131217_091144_856717_6D181BA5)
Subject: Re: [RFC PATCH 2/8] mac80211: Add per-interface powersave states
 and parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>
Date: Tue, 17 Dec 2013 09:11:38 +0100
In-Reply-To: <1387231260-2849-3-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230108_711579_9783326A)
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
	 <1387231260-2849-3-git-send-email-seth.forshee@canonical.com>
	 (sfid-20131216_230108_711579_9783326A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 16:00 -0600, Seth Forshee wrote:
> In preparation for managing powersave states on a per-interface
> basis, add powersave states and parameters to the interface-
> specific data structures. Also add a change_ps driver callback
> to notify drivers about changes to interface powersave states.
> 
> The new members and callback are unused here but will be
> utilized by subsequent commits.

Can't say I like that part much, it just makes it harder to review.

>  /**
> + * enum ieee80211_vif_ps_mode - virtual interface power save mode
> + *
> + * Ordered in terms of increasing wakefulness.
> + *
> + * @IEEE80211_VIF_PS_INACTIVE: the interface is not currently open
> + * @IEEE80211_VIF_PS_DOZE: the interface is in a low-power mode and may
> + *	not be able to transmit or receive frames
> + * @IEEE80211_VIF_PS_AWAKE_PM: the interface is awake and able to transmit
> + *	and receive frames but PM may be set in frame control
> + * @IEEE80211_VIF_PS_AWAKE: the interface is fully awake and able to
> + *	transmit and receive frames
> + */
> +enum ieee80211_vif_ps_mode {
> +	IEEE80211_VIF_PS_INACTIVE,

Does this INACTIVE thing really make sense? It should just be undefined
if it's not associated, no? Doing this might make people want to rely on
this to indicate associated-ness or something...

> +	IEEE80211_VIF_PS_AWAKE_PM,
> +	IEEE80211_VIF_PS_AWAKE,

The distinction between these seems somewhat unclear? "PM may be set"?

> + * @ps_mode: power save mode of this vif
> + * @dynamic_ps_active: indicates whether dynamic PS is active for this vif
> + * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
> + *	powersave documentation below. This variable is valid only when
> + *	the interface is in the doze state.
> + * @max_sleep_period: the maximum number of beacon intervals to sleep for
> + *	before checking the beacon for a TIM bit (managed mode only); this
> + *	value will be only achievable between DTIM frames, the hardware
> + *	needs to check for the multicast traffic bit in DTIM beacons.
> + *	This variable is valid only when the interface is in the doze state.
> + * @ps_dtim_period: The DTIM period of the AP we're connected to, for use
> + *	in power saving. Power saving will not be enabled until a beacon
> + *	has been received and the DTIM period is known.

Should these really be in the vif struct? They still seem somewhat
internal to the implementation.

johannes

