Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3BAS3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 13:29:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U1LMr-0002Fh-8l
	for linux-wireless@vger.kernel.org; Fri, 01 Feb 2013 19:29:41 +0100
Message-ID: <1359743405.8528.26.camel@jlt4.sipsolutions.net> (sfid-20130201_192945_370194_D9000099)
Subject: Re: [PATCH] cfg80211: fix BSS list hidden SSID lookup
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 01 Feb 2013 19:30:05 +0100
In-Reply-To: <1359742986-12932-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_192315_970791_397EE812)
References: <1359742986-12932-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130201_192315_970791_397EE812)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-01 at 19:23 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When trying to find a hidden SSID, the lookup function
> is done wrong; the code is trying to combine the two
> lookups into one, and as a consequence doesn't always
> find the entry at all. To understand this, consider a
> case where multiple BSS entries with the same channel
> and BSSID exist but have different SSID length. Then
> comparing against the probe response SSID length is
> bound to cause problems since the hidden one might be
> either zeroed out or zero-length.

Note that the bug really only matters if you have multiple hidden SSIDs
on a single BSSID, and those have different lengths. Which I think is
possible with some Cisco deployments ...

johannes

