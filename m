Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab1LGNEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:04:43 -0500
Subject: Re: [PATCH 1/2] cfg80211: Define a wrapper function for reporting
 roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1323262624-30060-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1323262624-30060-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 14:04:37 +0100
Message-ID: <1323263077.3404.33.camel@jlt3.sipsolutions.net> (sfid-20111207_140448_815333_5FB2CCB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 18:27 +0530, Vasanthakumar Thiagarajan wrote:

>  /**
> + * cfg80211_roamed_bss - notify cfg80211 of roaming
> + *
> + * @dev: network device
> + * @bss: entry of bss to which STA got roamed (may be %NULL)
> + * @channel: the channel of the new AP
> + * @bssid: the BSSID of the new AP
> + * @req_ie: association request IEs (maybe be %NULL)
> + * @req_ie_len: association request IEs length
> + * @resp_ie: association response IEs (may be %NULL)
> + * @resp_ie_len: assoc response IEs length
> + * @gfp: allocation flags
> + *
> + * This is just a wrapper to notify cfg80211 of roaming event with driver
> + * passing bss to avoid a race in timeout of the bss entry. It should be
> + * called by the underlying driver whenever it roamed from one AP to another
> + * while connected. Drivers which have roaming implemented in firmware
> + * may use this function to avoid a race in bss entry timeout where the bss
> + * entry of the new AP is seen in the driver, but gets timed out by the time
> + * it is accessed in __cfg80211_roamed() due to delay in scheduling
> + * rdev->event_work. Returns 0 upon success. Driver has to release a reference
> + * to bss with cfg80211_put_bss() when the return value is non-zero.
> + */

That calling convention is strange. Either make the function responsible
for it, nor not, but having to do the return value dance is not very
useful.

johannes

