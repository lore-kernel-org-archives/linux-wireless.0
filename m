Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946353Ab3BHMvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 07:51:42 -0500
Message-ID: <1360327897.29851.21.camel@jlt4.sipsolutions.net> (sfid-20130208_135146_306175_3E76577A)
Subject: Re: 3.7.6+:  WARNING: at net/mac80211/iface.c:705 ieee80211_do_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 08 Feb 2013 13:51:37 +0100
In-Reply-To: <5112F8D9.5060206@candelatech.com> (sfid-20130207_014415_868355_33170FE8)
References: <5112F8D9.5060206@candelatech.com>
	 (sfid-20130207_014415_868355_33170FE8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 16:44 -0800, Ben Greear wrote:
> This came from my patched 3.7.6+ kernel...it has some additional printout for the
> WDS/flush states, in case that helps any...
> 
> Doesn't seem to have caused any lasting harm.

> [13051.973344] sta6: authenticate with 00:ab:87:60:10:10
> [13052.099487] sta6: send auth to 00:ab:87:60:10:10 (try 1/3)
> [13052.139177] sta6: authenticated
> [13052.176209] sta6: Invalid WDS/flush state, type: 2  WDS: 5  flushed: 1
> [13052.193241] ------------[ cut here ]------------
> [13052.206642] WARNING: at /home/greearb/git/linux-3.7.dev.y/net/mac80211/iface.c:705 ieee80211_do_stop+0x647/0x6a0 [mac80211]()

Humm, ok, I see what happens here ... in ieee80211_do_stop() we flush
stations first, and then later call ieee80211_mgd_stop(). That should
clearly be the other way around (also the AP bit there), but I'm not
entirely sure what to do. Probably just move the ieee80211_mgd_stop()
call up to the start of the function.

johannes

