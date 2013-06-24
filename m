Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3FXNsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:48:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ur77y-000617-Rf
	for linux-wireless@vger.kernel.org; Mon, 24 Jun 2013 15:48:19 +0200
Message-ID: <1372081696.8439.4.camel@jlt4.sipsolutions.net> (sfid-20130624_154822_341143_A2538DFC)
Subject: Re: [PATCH 1/2] cfg80211: require passing BSS struct back to
 cfg80211_assoc_timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 24 Jun 2013 15:48:16 +0200
In-Reply-To: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net> (sfid-20130619_155405_104292_D5B25261)
References: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130619_155405_104292_D5B25261)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 15:53 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Doing so will allow us to hold the BSS (not just ref it) over the
> association process, thus ensuring that it doesn't time out and
> gets invisible to the user (e.g. in 'iw wlan0 link'.)
> 
> This also fixes a leak in mac80211 where it doesn't always release
> the BSS struct properly in all cases where calling this function.
> This leak was reported by Ben Greear.

Applied both.

johannes

