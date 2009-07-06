Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZGFRaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 13:30:05 -0400
Subject: Re: BUG REPORT: libertas causing kernel lockups
From: Dan Williams <dcbw@redhat.com>
To: Alexander Barinov <alex.barinov@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090705125933.5a9f7ce4@dream>
References: <20090704130346.01b2e869@dream>
	 <1246704102.16770.71.camel@johannes.local>  <20090705125933.5a9f7ce4@dream>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 13:29:55 -0400
Message-Id: <1246901395.21990.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-05 at 12:59 +0400, Alexander Barinov wrote:
> On Sat, 04 Jul 2009 12:41:42 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Sat, 2009-07-04 at 13:03 +0400, Alexander Barinov wrote:
> > > The initial symptom of the bug was system lockup when executing
> > > 'ifdown eth0' with 'BUG: scheduling while atomic'. Trying to
> > > understand the cause of the bug and find a workaround I was able to
> > > find an easier way to reproduce it. By executing
> > > 'cat /proc/net/wireless' I get the same bug:
> > This should have been fixed by
> > 87057825824973f29cf2f37cff1e549170b2d7e6. For some reason everybody
> > seems to have assumed that get_wireless_stats can sleep, which before
> > that commit it could _not_.
> 
> The patch you have mentioned was not directly applicable to 2.6.30
> kernel so I pulled wireless-testing git tree and compiled it. This
> deteriorated the situation further - now after executing
> 'cat /proc/net/wireless' I get kernel lockup without any further
> messages.

Can you get anything at all out of the kernel on that?  2.6.29.5 with
quite recent wireless-testing libertas driver works fine with sd8686 on
my machine (hp 2530p laptop with a Ricoh controller).  Can you post your
backport of that patch too?

Dan


