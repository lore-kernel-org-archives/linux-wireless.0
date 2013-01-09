Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3AILUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 06:20:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tsthl-0007hG-Ux
	for linux-wireless@vger.kernel.org; Wed, 09 Jan 2013 12:20:22 +0100
Message-ID: <1357730448.9757.1.camel@jlt4.sipsolutions.net> (sfid-20130109_122026_441512_AB55BEF3)
Subject: Re: [PATCH] regulatory: fix restore_regulatory_settings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 12:20:48 +0100
In-Reply-To: <1357730405-31853-1-git-send-email-johannes@sipsolutions.net> (sfid-20130109_121943_526291_1A8E091B)
References: <1357730405-31853-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130109_121943_526291_1A8E091B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 12:20 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My commit 379b82f4c9dc6e67bf61aa61b096c06a2f320f60
> ("regulatory: pass new regdomain to reset function")
> broke the restore_regulatory_settings() function due
> to a logic change. Consider this change:
> 
> -	reset_regdomains(true);
> -	cfg80211_regdomain = cfg80211_world_regdom;
> +	reset_regdomains(true, cfg80211_world_regdom);
> 
> This looks innocent enough, until you realise that the
> called function (reset_regdomains) also resets the
> cfg80211_world_regdom pointer, so that the old version
> of the code would use the new object it pointed to and
> the new version of the code uses the old object. This
> lead to a double-free of this object.
> 
> Since reset_regdomains() sets it to &world_regdom, use
> that directly.

Applied.

johannes

