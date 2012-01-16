Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2APTZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 14:25:16 -0500
Subject: Re: Re: [RFC] mac80211: Fix possible race between sta_unblock and
 network softirq
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <331689478.qzl2dPmWvj@helmutmobil.site> (sfid-20120116_202301_888909_6A90A771)
References: <1326728542-31697-1-git-send-email-helmut.schaa@googlemail.com>
	 <1326732693.3510.21.camel@jlt3.sipsolutions.net>
	 <331689478.qzl2dPmWvj@helmutmobil.site>
	 (sfid-20120116_202301_888909_6A90A771)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 20:25:14 +0100
Message-ID: <1326741914.3510.25.camel@jlt3.sipsolutions.net> (sfid-20120116_202520_164975_FA72BD86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-16 at 20:22 +0100, Helmut Schaa wrote:
> Am Montag, 16. Januar 2012, 17:51:33 schrieb Johannes Berg:
> > On Mon, 2012-01-16 at 16:42 +0100, Helmut Schaa wrote:
> > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > > ---
> > > 
> > > I'm currently writing some code for rt2800 that requires the driver
> > > to stop sending to a specific station for a short period of time
> > > (until all AMPDUs are finished to work around a hw issue that affects
> > > rate sampling with minstrel_ht). I decided to give
> > > ieee80211_sta_block_awake a try, however, the machine sometimes locked
> > > up while running some performance tests but due to a hw watchdog I
> > > wasn't able to get any sort of backtrace :(
> > > 
> > > So, while doing some review of the ieee80211_sta_block_awake I came
> > > across this and wondered if softirqs should be disabled when delivering
> > > the buffered frames in sta_unblock.
> > > 
> > > Using this patch I cannot reproduce the lockup anymore.
> > > 
> > > So, is there any special reason this single code path in sta_unblock
> > > doesn't disable softirqs?
> > 
> > This seems right
> 
> The patch or the current approach without disable_bh?

The patch.

johannes

