Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3APODW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:03:22 -0500
Message-ID: <1358345026.22862.6.camel@jlt4.sipsolutions.net> (sfid-20130116_150325_298423_C3765D34)
Subject: Re: [PATCH] mac80211: fix FT roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: cedric.debarge@acksys.fr
Date: Wed, 16 Jan 2013 15:03:46 +0100
In-Reply-To: <1357911819-9504-1-git-send-email-johannes@sipsolutions.net> (sfid-20130111_144321_886241_D82FE615)
References: <1357911819-9504-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130111_144321_886241_D82FE615)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 14:43 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> During FT roaming, wpa_supplicant attempts to set the
> key before association. This used to be rejected, but
> as a side effect of my commit 66e67e418908442389d3a9e
> ("mac80211: redesign auth/assoc") the key was accepted
> causing hardware crypto to not be used for it as the
> station isn't added to the driver yet.
> 
> It would be possible to accept the key and then add it
> to the driver when the station has been added. However,
> this may run into issues with drivers using the state-
> based station adding if they accept the key only after
> association like it used to be.
> 
> For now, revert to the behaviour from before the auth
> and assoc change.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Cédric Debarge <cedric.debarge@acksys.fr>
> Tested-by: Cédric Debarge <cedric.debarge@acksys.fr>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied.

johannes

