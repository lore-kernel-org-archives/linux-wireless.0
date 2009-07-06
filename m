Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:61180 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZGFTXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 15:23:17 -0400
Received: by bwz25 with SMTP id 25so1527675bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 12:23:20 -0700 (PDT)
Date: Mon, 6 Jul 2009 23:23:39 +0400
From: Alexander Barinov <alex.barinov@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: BUG REPORT: libertas causing kernel lockups
Message-ID: <20090706232339.292ff530@dream>
In-Reply-To: <1246901395.21990.1.camel@localhost.localdomain>
References: <20090704130346.01b2e869@dream>
	<1246704102.16770.71.camel@johannes.local>
	<20090705125933.5a9f7ce4@dream>
	<1246901395.21990.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 06 Jul 2009 13:29:55 -0400
Dan Williams <dcbw@redhat.com> wrote:
> On Sun, 2009-07-05 at 12:59 +0400, Alexander Barinov wrote:
> > On Sat, 04 Jul 2009 12:41:42 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> > > On Sat, 2009-07-04 at 13:03 +0400, Alexander Barinov wrote:
> > > > The initial symptom of the bug was system lockup when executing
> > > > 'ifdown eth0' with 'BUG: scheduling while atomic'. Trying to
> > > > understand the cause of the bug and find a workaround I was
> > > > able to find an easier way to reproduce it. By executing
> > > > 'cat /proc/net/wireless' I get the same bug:
> > > This should have been fixed by
> > > 87057825824973f29cf2f37cff1e549170b2d7e6. For some reason
> > > everybody seems to have assumed that get_wireless_stats can
> > > sleep, which before that commit it could _not_.
> > 
> > The patch you have mentioned was not directly applicable to 2.6.30
> > kernel so I pulled wireless-testing git tree and compiled it. This
> > deteriorated the situation further - now after executing
> > 'cat /proc/net/wireless' I get kernel lockup without any further
> > messages.
> 
> Can you get anything at all out of the kernel on that?  2.6.29.5 with
> quite recent wireless-testing libertas driver works fine with sd8686
> on my machine (hp 2530p laptop with a Ricoh controller).  Can you
> post your backport of that patch too?

The problem is I get no kernel messages at all, just a lockup. Wireless
debug (CONFIG_MAC80211_*_DEBUG) and libertas debug
(CONFIG_LIBERTAS_DEBUG) are on, no "quiet" option on boot. Is there any
other way I can increase level of debug output to be able to give you
some meaningful information with regards to my problem?

BTW, my case is sd8686 on some SDHCI PCI controller, I am not sure how
to find the vendor.

I am not sure which backport you are talking about, as I am using
wireless-testing pulled from git, it should be something around
2.6.31-rc1.

Regards,
Alexander
