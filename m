Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab0DFSHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 14:07:48 -0400
Subject: Re: [PATCH] mac80211: check whether scan is in progress before
 queueing scan_work
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1270574265.24505.3.camel@jlt3.sipsolutions.net>
References: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1270544765.3929.2.camel@jlt3.sipsolutions.net>
	 <1270549017.7150.28.camel@paavo-desktop>
	 <1270549677.3929.5.camel@jlt3.sipsolutions.net>
	 <1270549759.3929.6.camel@jlt3.sipsolutions.net>
	 <1270551950.7150.47.camel@paavo-desktop>
	 <1270570994.2969.12.camel@localhost.localdomain>
	 <1270574265.24505.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 11:07:39 -0700
Message-ID: <1270577259.8534.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-06 at 19:17 +0200, Johannes Berg wrote:
> On Tue, 2010-04-06 at 09:23 -0700, Dan Williams wrote:
> 
> > > Yes, I'm bit worried about possibility of a possible deadlock too. One
> > > solution would be to move the block acquiring scan_mtx and queueing
> > > scan_work outside of the work_mtx locked section, I'll take a look on
> > > that. In any case, this patch won't most likely fix all issues with the
> > > locking here. For example there's that checking if scan is in progress
> > > in the beginning of the work_work. After that it is still possible that
> > > the scan is started. So there's obviously need for some fixing in the
> > > locking yet to be done. 
> > 
> > One issue would be if the new scan request has different parameters than
> > the in-progress scan request.  This is especially important when the
> > incoming scan request is for a specific SSID (hidden network probing)
> > while the ongoing one is not.  Can we make sure that the patch at least
> > returns the error up the stack when the incoming scan is dropped?
> > Otherwise userspace has no idea that the specific SSID scan was dropped
> > on the floor, and just thinks that the hidden SSID wasn't found.
> 
> There's no scan request being dropped -- it's just that we try to ask
> the hw to do the same scan twice without noticing that we've already
> asked it.

Aha; thanks for the clarification.

Dan


