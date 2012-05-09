Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab2EIJBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:01:07 -0400
Message-ID: <1336554064.4323.6.camel@jlt3.sipsolutions.net> (sfid-20120509_110113_415368_DF0D3EAE)
Subject: Re: [PATCH] mac80211: Fix race between tx path and
 ___ieee80211_stop_tx_ba_session
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 09 May 2012 11:01:04 +0200
In-Reply-To: <1336553772-7519-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120509_105648_217428_5DF1720D)
References: <1336553772-7519-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20120509_105648_217428_5DF1720D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 10:56 +0200, Helmut Schaa wrote:
> ___ieee80211_stop_tx_ba_session first deletes the tx aggregation session
> timer and afterwards clears HT_AGG_STATE_OPERATIONAL. Hence, there is a
> small time window where the tx path can call mod_timer after
> del_timer_sync.
> 
> When ieee80211_start_tx_ba_session runs before the timer the call to
> init_timer will cause a BUG_ON:

This may have been fixed by my other patch where I check the state?

johannes

