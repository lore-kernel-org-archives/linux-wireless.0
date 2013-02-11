Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3BKLsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:48:41 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rsG-0000gK-5Y
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:48:40 +0100
Message-ID: <1360583318.8738.18.camel@jlt4.sipsolutions.net> (sfid-20130211_124844_554155_E2BA0C72)
Subject: Re: [PATCH] cfg80211: track hidden SSID networks properly
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:48:38 +0100
In-Reply-To: <1359754837-1271-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_224022_738976_09E79D21)
References: <1359754837-1271-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130201_224022_738976_09E79D21)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-01 at 22:40 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently, cfg80211 will copy beacon IEs from a previously
> received hidden SSID beacon to a probe response entry, if
> that entry is created after the beacon entry. However, if
> it is the other way around, or if the beacon is updated,
> such changes aren't propagated.
> 
> Fix this by tracking the relation between the probe
> response and beacon BSS structs in this case.
> 
> In case drivers have private data stored in a BSS struct
> and need access to such data from a beacon entry, cfg80211
> now provides the hidden_beacon_bss pointer from the probe
> response entry to the beacon entry.

Applied.

johannes

