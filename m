Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaAaNqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 08:46:00 -0500
Message-ID: <1391175955.4141.13.camel@jlt4.sipsolutions.net> (sfid-20140131_144604_626877_D32B2A88)
Subject: Re: [PATCHv3] cfg80211: fix channel configuration in IBSS join
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	libertas-dev@lists.infradead.org
Date: Fri, 31 Jan 2014 14:45:55 +0100
In-Reply-To: <1391014423-1432-1-git-send-email-antonio@meshcoding.com>
References: <1391014423-1432-1-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 17:53 +0100, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> When receiving an IBSS_JOINED event select the BSS object
> based on the {bssid, channel} couple rather than the bssid
> only.
> With the current approach if another cell having the same
> BSSID (but using a different channel) exists then cfg80211
> picks up the wrong BSS object.
> The result is a mismatching channel configuration between
> cfg80211 and the driver, that can lead to any sort of
> problem.
> 
> The issue can be triggered by having an IBSS sitting on
> given channel and then asking the driver to create a new
> cell using the same BSSID but with a different frequency.
> By passing the channel to cfg80211_get_bss() we can solve
> this ambiguity and retrieve/create the correct BSS object.
> All the users of cfg80211_ibss_joined() have been changed
> accordingly.
> 
> Moreover WARN when cfg80211_ibss_joined() gets a NULL
> channel as argument and remove a bogus call of the same
> function in ath6kl (it does not make sense to call
> cfg80211_ibss_joined() with a zero BSSID on ibss-leave).

Applied, with a small code cleanup in ath6kl.

johannes

