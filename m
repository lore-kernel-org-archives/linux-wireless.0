Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2FCSd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 14:33:59 -0400
Message-ID: <1338748437.15431.0.camel@jlt3.sipsolutions.net> (sfid-20120603_203402_477935_01C03F39)
Subject: Re: IWLWIFI should depend on SUSPEND
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 03 Jun 2012 20:33:57 +0200
In-Reply-To: <20120603164905.GA2056@wolfgang> (sfid-20120603_184923_810965_27443E1D)
References: <20120519201958.GA2313@wolfgang>
	 <1337540836.4585.1.camel@jlt3.sipsolutions.net>
	 <1338384543.4511.18.camel@jlt3.sipsolutions.net>
	 <20120603091643.GA2191@wolfgang>
	 <1338735736.4972.0.camel@jlt3.sipsolutions.net>
	 <20120603164905.GA2056@wolfgang> (sfid-20120603_184923_810965_27443E1D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-03 at 18:49 +0200, Sebastian Kemper wrote:
> On Sun, Jun 03, 2012 at 05:02:16PM +0200, Johannes Berg wrote:
> > Oh, so this goes back much further than I thought.
> > 
> > Well, the easiest is probably if you find the wowlan.pattern_max_len
> > stuff etc. and put #ifdef around the whole wowlan block manually, like
> > in my patch.
> > 
> > johannes
> > 
> 
> Hello again,
> 
> I didn't try it out yet, although I did find the block you're talking
> about. I didn't because I *think* that
> 
> #ifdef CONFIG_PM
> …
> #endif
> 
> wouldn't work.

You're right, it should be CONFIG_PM_SLEEP or something ... I'll have to
sort it out. It looks like in iwlwifi, the suspend/resume methods are
under CONFIG_PM_SLEEP, while in mac80211 they're under CONFIG_PM.

johannes

