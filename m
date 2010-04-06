Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27840 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0DFLK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 07:10:27 -0400
Subject: Re: [PATCH] mac80211: check whether scan is in progress before
 queueing scan_work
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270549759.3929.6.camel@jlt3.sipsolutions.net>
References: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1270544765.3929.2.camel@jlt3.sipsolutions.net>
	 <1270549017.7150.28.camel@paavo-desktop>
	 <1270549677.3929.5.camel@jlt3.sipsolutions.net>
	 <1270549759.3929.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 14:05:50 +0300
Message-Id: <1270551950.7150.47.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-06 at 12:29 +0200, ext Johannes Berg wrote:
> On Tue, 2010-04-06 at 12:27 +0200, Johannes Berg wrote:
> > On Tue, 2010-04-06 at 13:16 +0300, Teemu Paasikivi wrote:
> > > On Tue, 2010-04-06 at 11:06 +0200, ext Johannes Berg wrote:
> > > > On Tue, 2010-04-06 at 11:54 +0300, Teemu Paasikivi wrote:
> > > > > As scan_work is queued from work_work it needs to be checked if scan
> > > > > has been started during execution of work_work. Otherwise, when hw
> > > > > scan is used, the stack gets error about hw being busy with ongoing
> > > > > scan.
> > > > 
> > > > Does that mean we ask the driver to scan twice? And your particular
> > > > driver returns busy?
> > > > 
> > > 
> > > Yes. There seems to be a possibility, that when ieee80211_work_work is
> > > being executed, __ieee80211_start_scan gets called and it starts a hw
> > > scan, and also sets local->hw_scan_req etc. (because it looks like
> > > there's some holes in use of scan_mtx). Result is that work_work queues
> > > ieee80211_scan_work and when it is executed, as there's already
> > > hw_scan_req set, it will try to start hw scan again. And as the driver
> > > used returns busy, scan_work will call ieee80211_scan_completed function
> > > which leaves the driver (hw more precisely) scanning and the stack
> > > thinking that it is not anymore scanning.
> > > 
> > > Obviously this kind of situation doesn't happen very often in normal
> > > use, but it can be caused quite easily by associating to access points
> > > in a loop while running scan in another loop.
> > 
> > Makes some sense. Ignore my other email(s), I looked at this in more
> > detail now.
> > 
> > It would appear that we need to fix some of the locking here,
> > potentially simply using a single mutex for both work and scan?
> 
> I'm mostly worried about deadlocks between work_mtx and scan_mtx really,
> when we acquire them both like your patch.
> 

Yes, I'm bit worried about possibility of a possible deadlock too. One
solution would be to move the block acquiring scan_mtx and queueing
scan_work outside of the work_mtx locked section, I'll take a look on
that. In any case, this patch won't most likely fix all issues with the
locking here. For example there's that checking if scan is in progress
in the beginning of the work_work. After that it is still possible that
the scan is started. So there's obviously need for some fixing in the
locking yet to be done. 


Teemu


