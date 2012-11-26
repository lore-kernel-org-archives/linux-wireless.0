Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2KZLqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:46:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tcx8U-0001TA-8U
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 12:46:02 +0100
Message-ID: <1353930390.9488.29.camel@jlt4.sipsolutions.net> (sfid-20121126_124608_573988_75856CFB)
Subject: Re: [PATCH] mac80211: fix managed mode channel flags handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 12:46:30 +0100
In-Reply-To: <1353927754-17265-1-git-send-email-johannes@sipsolutions.net> (sfid-20121126_120213_647898_7E3AD214)
References: <1353927754-17265-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121126_120213_647898_7E3AD214)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 12:02 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If ieee80211_prep_channel() decides that HT should be
> disabled (because the HT IEs from the AP were invalid)
> it will set the IEEE80211_STA_DISABLE_HT to not send
> HT capabilities to the AP when associating. If this
> happens during authentication, the flag will be lost
> and we send HT frames, even if the channel config was
> set up for non-HT. This can lead to issues.
> 
> Fix this by always resetting the ifmgd flags to zero
> when the channel context is released so that the flag
> resetting in ieee80211_mgd_assoc() isn't necessary.
> 
> To make the code a bit easier move the call to release
> the channel in ieee80211_set_disassoc() to the end of
> the function together with the flag resetting (which
> needs to be at the end to avoid timers setting flags.)

Applied. :)

johannes

