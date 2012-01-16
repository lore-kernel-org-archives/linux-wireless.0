Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51043 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab2APTcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 14:32:12 -0500
Received: by eekc14 with SMTP id c14so250764eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 11:32:11 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Re: Re: [RFC] mac80211: Fix possible race between sta_unblock and network softirq
Date: Mon, 16 Jan 2012 20:32:07 +0100
Message-ID: <12639684.2oQAdY9LVf@helmutmobil.site> (sfid-20120116_203216_637892_A73EE058)
In-Reply-To: <1326741914.3510.25.camel@jlt3.sipsolutions.net>
References: <1326728542-31697-1-git-send-email-helmut.schaa@googlemail.com> <331689478.qzl2dPmWvj@helmutmobil.site> <1326741914.3510.25.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 16. Januar 2012, 20:25:14 schrieb Johannes Berg:
> On Mon, 2012-01-16 at 20:22 +0100, Helmut Schaa wrote:
> > Am Montag, 16. Januar 2012, 17:51:33 schrieb Johannes Berg:
> > > On Mon, 2012-01-16 at 16:42 +0100, Helmut Schaa wrote:
> > > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > > > ---
> > > > 
> > > > I'm currently writing some code for rt2800 that requires the driver
> > > > to stop sending to a specific station for a short period of time
> > > > (until all AMPDUs are finished to work around a hw issue that affects
> > > > rate sampling with minstrel_ht). I decided to give
> > > > ieee80211_sta_block_awake a try, however, the machine sometimes locked
> > > > up while running some performance tests but due to a hw watchdog I
> > > > wasn't able to get any sort of backtrace :(
> > > > 
> > > > So, while doing some review of the ieee80211_sta_block_awake I came
> > > > across this and wondered if softirqs should be disabled when delivering
> > > > the buffered frames in sta_unblock.
> > > > 
> > > > Using this patch I cannot reproduce the lockup anymore.
> > > > 
> > > > So, is there any special reason this single code path in sta_unblock
> > > > doesn't disable softirqs?
> > > 
> > > This seems right
> > 
> > The patch or the current approach without disable_bh?
> 
> The patch.

Thanks :)
