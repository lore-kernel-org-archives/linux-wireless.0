Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab3BNUYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:24:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U65Lu-0004Fo-PA
	for linux-wireless@vger.kernel.org; Thu, 14 Feb 2013 21:24:18 +0100
Message-ID: <1360873456.8210.19.camel@jlt4.sipsolutions.net> (sfid-20130214_212424_082537_96DEC958)
Subject: Re: [PATCH] nl80211: remove and renumber
 NL80211_FEATURE_FULL_AP_CLIENT_STATE
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 14 Feb 2013 21:24:16 +0100
In-Reply-To: <1360840384-13986-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_121311_772413_A31329D9)
References: <1360840384-13986-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_121311_772413_A31329D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 12:13 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Adding the flag to mac80211 already without testing was
> clearly a mistake, one that we now pay for by having to
> reserve bit 13 forever. The problem is cfg80211 doesn't
> allow capability/rate changes for station entries that
> were added unassociated, so the station entries cannot
> be set up properly when marked associated.
> 
> Change the NL80211_FEATURE_FULL_AP_CLIENT_STATE number
> to make it clear to userspace implementations that all
> current kernels don't actually support it, even though
> the previous bit is set, and of course also remove the
> flag from mac80211 until we test and fix the issues.

Applied.

johannes

