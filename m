Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0DFK3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 06:29:25 -0400
Subject: Re: [PATCH] mac80211: check whether scan is in progress before
 queueing scan_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270549677.3929.5.camel@jlt3.sipsolutions.net>
References: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1270544765.3929.2.camel@jlt3.sipsolutions.net>
	 <1270549017.7150.28.camel@paavo-desktop>
	 <1270549677.3929.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 12:29:19 +0200
Message-ID: <1270549759.3929.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-06 at 12:27 +0200, Johannes Berg wrote:
> On Tue, 2010-04-06 at 13:16 +0300, Teemu Paasikivi wrote:
> > On Tue, 2010-04-06 at 11:06 +0200, ext Johannes Berg wrote:
> > > On Tue, 2010-04-06 at 11:54 +0300, Teemu Paasikivi wrote:
> > > > As scan_work is queued from work_work it needs to be checked if scan
> > > > has been started during execution of work_work. Otherwise, when hw
> > > > scan is used, the stack gets error about hw being busy with ongoing
> > > > scan.
> > > 
> > > Does that mean we ask the driver to scan twice? And your particular
> > > driver returns busy?
> > > 
> > 
> > Yes. There seems to be a possibility, that when ieee80211_work_work is
> > being executed, __ieee80211_start_scan gets called and it starts a hw
> > scan, and also sets local->hw_scan_req etc. (because it looks like
> > there's some holes in use of scan_mtx). Result is that work_work queues
> > ieee80211_scan_work and when it is executed, as there's already
> > hw_scan_req set, it will try to start hw scan again. And as the driver
> > used returns busy, scan_work will call ieee80211_scan_completed function
> > which leaves the driver (hw more precisely) scanning and the stack
> > thinking that it is not anymore scanning.
> > 
> > Obviously this kind of situation doesn't happen very often in normal
> > use, but it can be caused quite easily by associating to access points
> > in a loop while running scan in another loop.
> 
> Makes some sense. Ignore my other email(s), I looked at this in more
> detail now.
> 
> It would appear that we need to fix some of the locking here,
> potentially simply using a single mutex for both work and scan?

I'm mostly worried about deadlocks between work_mtx and scan_mtx really,
when we acquire them both like your patch.

johannes

