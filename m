Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1KDCBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 22:01:07 -0400
Subject: Re: A new driver is going to be released
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 03 Nov 2011 21:01:27 -0500
In-Reply-To: <4EB33B67.6080806@lwfinger.net>
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
	 <4EB33B67.6080806@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1320372088.29008.0.camel@dcbw.foobar.com> (sfid-20111104_030111_763697_FD515C80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 20:09 -0500, Larry Finger wrote:
> On 11/03/2011 05:40 PM, Dmitry Tarnyagin wrote:
> > Hi,
> >
> > I'm about to release cw1200 driver to the community (more or less
> > latest code is available here:
> > http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=shortlog;h=refs/heads/linux-3.0-ux500
> > as well).
> >
> > Technical question: how is it usually done in terms of commit history?
> > Should I preserve the history and release all the changes in the
> > driver separately or should I squash everything to a single commit
> > or...?
> 
> The details of what it took to get your driver to this point are not going to be 
> of much interest in the future. The "official" history starts with acceptance 
> into the kernel. Two things to keep in mind: (1) the kernel source must compile 
> at each step of the way to allow for bisection, thus any changes to Kconfig and 
> Makefile must be in the last patch, and (2) each commit should be small enough 
> that it is relatively easy to review.
> 
> As I do not know the complexity of the driver, it is a little difficult to make 
> suggestions; however, one way to accomplish the above is to add each source file 
> in a separate patch. The maintainer may submit the final version as a single 
> commit, but that is their choice.
> 
> Your sending this mail to the wireless ML indicates that you plan to submit the 
> driver to the drivers/net/wireless/ part of the source tree. As long as the 
> driver employs mac80211, that is appropriate. The other option is 
> drivers/staging/. Drivers for that section of the source tree usually are not 
> held to standards as high as the wireless section.

It looks like it's mac80211-based and already in drivers/staging/
according to the git tree Dmitry pointed to.

Dan

