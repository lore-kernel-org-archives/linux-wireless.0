Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab0H3TSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:18:02 -0400
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1283195671-4086-1-git-send-email-linville@tuxdriver.com>
References: <1283195671-4086-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 21:17:59 +0200
Message-ID: <1283195879.3694.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-30 at 15:14 -0400, John W. Linville wrote:
> This function exists to clean-up after a hardware error or something
> similar.  The restart is accomplished using the same infrastructure used
> to resume after a suspend.  The suspend path cancels running scans, so
> it seems appropriate to do that here as well.

> -	/* use this reason, __ieee80211_resume will unblock it */
> +	ieee80211_scan_cancel(local);
> +
> +	/* use this reason, ieee80211_reconfig will unblock it */

Hmm, yes .. but how will this interact with hw scan?

johannes

