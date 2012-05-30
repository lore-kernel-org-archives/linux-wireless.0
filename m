Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2E3QdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 12:33:15 -0400
Message-ID: <1338395594.4511.31.camel@jlt3.sipsolutions.net> (sfid-20120530_183318_800574_73BD940D)
Subject: Re: [PATCH v2 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 May 2012 18:33:14 +0200
In-Reply-To: <1338393559-1792-1-git-send-email-victorg@ti.com>
References: <1338393559-1792-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 18:59 +0300, Victor Goldenshtein wrote:

>  #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
> +#define	IEEE80211_CHANNEL_TIME		(HZ / 33)
> +#define	IEEE80211_PASSIVE_CHANNEL_TIME	(HZ / 8)

And as you just heard on IRC, this is bogus since the units are supposed
to be TU, not jiffies (which isn't a valid unit to use in a userspace
API anyway since it's not even a "constant" unit)

johannes

