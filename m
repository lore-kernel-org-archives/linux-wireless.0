Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab0DFQXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 12:23:24 -0400
Subject: Re: [PATCH] mac80211: check whether scan is in progress before
 queueing scan_work
From: Dan Williams <dcbw@redhat.com>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270551950.7150.47.camel@paavo-desktop>
References: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1270544765.3929.2.camel@jlt3.sipsolutions.net>
	 <1270549017.7150.28.camel@paavo-desktop>
	 <1270549677.3929.5.camel@jlt3.sipsolutions.net>
	 <1270549759.3929.6.camel@jlt3.sipsolutions.net>
	 <1270551950.7150.47.camel@paavo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 09:23:14 -0700
Message-ID: <1270570994.2969.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-06 at 14:05 +0300, Teemu Paasikivi wrote:
> On Tue, 2010-04-06 at 12:29 +0200, ext Johannes Berg wrote:
> > On Tue, 2010-04-06 at 12:27 +0200, Johannes Berg wrote:
> > > On Tue, 2010-04-06 at 13:16 +0300, Teemu Paasikivi wrote:
> > > > On Tue, 2010-04-06 at 11:06 +0200, ext Johannes Berg wrote:
> > > > > On Tue, 2010-04-06 at 11:54 +0300, Teemu Paasikivi wrote:
> > > > > > As scan_work is queued from work_work it needs to be checked if scan
> > > > > > has been started during execution of work_work. Otherwise, when hw
> > > > > > scan is used, the stack gets error about hw being busy with ongoing
> > > > > > scan.
> > > > > 
> > > > > Does that mean we ask the driver to scan twice? And your particular
> > > > > driver returns busy?
> > > > > 
> > > > 
> > > > Yes. There seems to be a possibility, that when ieee80211_work_work is
> > > > being executed, __ieee80211_start_scan gets called and it starts a hw
> > > > scan, and also sets local->hw_scan_req etc. (because it looks like
> > > > there's some holes in use of scan_mtx). Result is that work_work queues
> > > > ieee80211_scan_work and when it is executed, as there's already
> > > > hw_scan_req set, it will try to start hw scan again. And as the driver
> > > > used returns busy, scan_work will call ieee80211_scan_completed function
> > > > which leaves the driver (hw more precisely) scanning and the stack
> > > > thinking that it is not anymore scanning.
> > > > 
> > > > Obviously this kind of situation doesn't happen very often in normal
> > > > use, but it can be caused quite easily by associating to access points
> > > > in a loop while running scan in another loop.
> > > 
> > > Makes some sense. Ignore my other email(s), I looked at this in more
> > > detail now.
> > > 
> > > It would appear that we need to fix some of the locking here,
> > > potentially simply using a single mutex for both work and scan?
> > 
> > I'm mostly worried about deadlocks between work_mtx and scan_mtx really,
> > when we acquire them both like your patch.
> > 
> 
> Yes, I'm bit worried about possibility of a possible deadlock too. One
> solution would be to move the block acquiring scan_mtx and queueing
> scan_work outside of the work_mtx locked section, I'll take a look on
> that. In any case, this patch won't most likely fix all issues with the
> locking here. For example there's that checking if scan is in progress
> in the beginning of the work_work. After that it is still possible that
> the scan is started. So there's obviously need for some fixing in the
> locking yet to be done. 

One issue would be if the new scan request has different parameters than
the in-progress scan request.  This is especially important when the
incoming scan request is for a specific SSID (hidden network probing)
while the ongoing one is not.  Can we make sure that the patch at least
returns the error up the stack when the incoming scan is dropped?
Otherwise userspace has no idea that the specific SSID scan was dropped
on the floor, and just thinks that the hidden SSID wasn't found.

Dan


