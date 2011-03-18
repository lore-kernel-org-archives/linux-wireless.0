Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab1CRIyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 04:54:43 -0400
Date: Fri, 18 Mar 2011 09:54:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, herton@mandriva.com.br,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187b throughput-related regression in 2.6.35.x fixed in
 2.6.37.x
Message-ID: <20110318085401.GB2162@redhat.com>
References: <813132.20275.qm@web29506.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <813132.20275.qm@web29506.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 05:18:25AM +0000, Hin-Tak Leung wrote:
> Hi Larry/Herton/John,
> 
> There appears to be some kind of throughput related regression in 2.6.35.x (11-85-ish fedora, current long-term maintainance kernel) which is fixed by putting compat-wireless 2.6.37.x (4) on. I just thought I should mention this, in case somebody files a bug about rtl8187(b) being too slow, that putting compat-wireless on might help.
> 
> My AP machine was out for almost a year so I have not been using my rtl8187b for a while. When I finally got that fixed, after a while I noticed the throughput between the two machines was low (60KB/s, or 0.5Mb/s, although iwconfig says rate=11Mb/s, etc). Putting compat-wireless on gets me back the throughput I expect from a year ago (400KB/s+ onwards, or a few Mb/s at least). So 2.6.31.x a year ago was okay, 2.6.37.x is okay, but there appear to be something not quite right with 2.6.35.x in the middle. There are too many changes, and it is probably not important since current-ish kernel head is okay.

Would be nice to have this fixed in stable.

We have already one AP mode bug opened:
http://bugzilla.redhat.com/show_bug.cgi?id=671514

It was recognized that this patch is needed in .35.11 (.35.9 is ok):
http://git.kernel.org/linus/09a02fdb919876c01e8f05960750a418b3f7fa48

Not sure if this is the same issue, but perhaps you could try above
patch. If it does not help, could you check if problem is
2.6.35.x -> 2.6.35.11 regression?

Stanislaw
