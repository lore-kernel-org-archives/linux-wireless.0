Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1EMM11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:27:27 -0400
Subject: Re: Setting my WiFi adhoc connection in power save mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jorge Miguel <jmiggal@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20110513122235.GC5516@redhat.com>
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
	 <20110513115030.GB5516@redhat.com>
	 <1305287703.3487.16.camel@jlt3.sipsolutions.net>
	 <20110513122235.GC5516@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 14:27:22 +0200
Message-ID: <1305289642.3487.18.camel@jlt3.sipsolutions.net> (sfid-20110513_142730_710817_34D88280)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 14:22 +0200, Stanislaw Gruszka wrote:
> On Fri, May 13, 2011 at 01:55:03PM +0200, Johannes Berg wrote:
> > > Also in kernel 2.6.39, after driver split into iwlegacy, power save
> > > is marked as not supported by driver. I wonder it was deliberate action
> > > from Intel developers, or just IEEE80211_HW_SUPPORTS_PS is missed by
> > > mistake. I'm going to look at this.
> > 
> > Deliberate. On some platforms/systems, the way the device goes to sleep
> > caused DMA trouble or something like that, and the ucode would sysassert
> > when it tried to wake itself up. The problem was fairly rare, but of
> > course the device wakes up 10 times a second or so ...
> 
> It's interesting if PS on 3945 ever works or was broken from very
> beginning. I bet it was, on some old kernel, and this issue is similar
> case like most of other bugs we have in iwlwifi - something that worked
> well was broken by adding new chipsets/features support, but never fixed
> again and just masked/disabled instead.

I doubt it, iirc it was just some DMA issue that was discovered at some
point and nobody could really pinpoint it. Those old devices stored some
internal data into a host memory buffer, and reading them back sometimes
corrupted them.

johannes

