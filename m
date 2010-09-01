Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0IAK3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 06:29:41 -0400
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw if
 software scan pending
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1283282737-27749-1-git-send-email-linville@tuxdriver.com>
References: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
	 <1283282737-27749-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 12:29:38 +0200
Message-ID: <1283336978.4131.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 15:25 -0400, John W. Linville wrote:
> This function exists to clean-up after a hardware error or something
> similar.  The restart is accomplished using the same infrastructure used
> to resume after a suspend.  The suspend path cancels running scans, so
> it seems appropriate to do that here as well for software-based scans.
> If a hardware-based scan is pending, issue a warning message since this
> indicates that the drivers has failed to clean-up after itself.

Makes sense.

I guess unrelated to this, I wonder if we should warn in the suspend
case as well, rather than doing it unconditionally. Hmm.

johannes


