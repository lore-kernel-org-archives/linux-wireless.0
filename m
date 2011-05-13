Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab1EMMWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:22:54 -0400
Date: Fri, 13 May 2011 14:22:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jorge Miguel <jmiggal@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Setting my WiFi adhoc connection in power save mode
Message-ID: <20110513122235.GC5516@redhat.com> (sfid-20110513_142257_830749_54A77A48)
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
 <20110513115030.GB5516@redhat.com>
 <1305287703.3487.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305287703.3487.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 01:55:03PM +0200, Johannes Berg wrote:
> > Also in kernel 2.6.39, after driver split into iwlegacy, power save
> > is marked as not supported by driver. I wonder it was deliberate action
> > from Intel developers, or just IEEE80211_HW_SUPPORTS_PS is missed by
> > mistake. I'm going to look at this.
> 
> Deliberate. On some platforms/systems, the way the device goes to sleep
> caused DMA trouble or something like that, and the ucode would sysassert
> when it tried to wake itself up. The problem was fairly rare, but of
> course the device wakes up 10 times a second or so ...

It's interesting if PS on 3945 ever works or was broken from very
beginning. I bet it was, on some old kernel, and this issue is similar
case like most of other bugs we have in iwlwifi - something that worked
well was broken by adding new chipsets/features support, but never fixed
again and just masked/disabled instead.
 
Stanislaw
