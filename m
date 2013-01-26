Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3AZUxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 15:53:25 -0500
Message-ID: <1359233629.8699.4.camel@jlt4.sipsolutions.net> (sfid-20130126_215331_414115_495E1635)
Subject: Re: WARNING: at net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 26 Jan 2013 21:53:49 +0100
In-Reply-To: <87vcakxzin.fsf@purkki.adurom.net> (sfid-20130126_065156_011641_62FC8674)
References: <87vcakxzin.fsf@purkki.adurom.net>
	 (sfid-20130126_065156_011641_62FC8674)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 07:51 +0200, Kalle Valo wrote:
> Hi,
> 
> I noticed this warning in the log just by accident, I haven't had any
> problems. I'm running latest wireless-testing (commit 9d9540984a) on
> thinkpad x230 with Intel 6205.
> 
> [   10.262245] wlan0: authenticate with 00:26:f2:f7:cf:b2
> [   10.272891] wlan0: send auth to 00:26:f2:f7:cf:b2 (try 1/3)
> [   10.275093] wlan0: authenticated
> [   10.278751] wlan0: associate with 00:26:f2:f7:cf:b2 (try 1/3)
> [   10.282307] wlan0: RX AssocResp from 00:26:f2:f7:cf:b2 (capab=0x411 status=0 aid=3)
> [   10.303014] wlan0: associated
> [   10.303062] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  836.534120] wlan0: deauthenticating from 00:26:f2:f7:cf:b2 by local choice (reason=3)
> [  836.570864] ------------[ cut here ]------------
> [  836.570894] WARNING: at net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb+0x1b5/0x240 [mac80211]()

Smells like a race to me. We probably requested aggregation and then
deauthenticated, thus killing the session data. Then the driver probably
had a bug and said it started the session or something ...

johannes

