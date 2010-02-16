Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.128.226]:40868 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab0BPVuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:50:18 -0500
Date: Tue, 16 Feb 2010 16:50:04 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: give warning if building w/out rate ctrl
 algorithm
Message-ID: <20100216165004.010d2c4b@droptest.queued.net>
In-Reply-To: <1266355279.8849.24.camel@localhost.localdomain>
References: <20100216161656.42079d77@droptest.queued.net>
	<1266355279.8849.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 16 Feb 2010 13:21:19 -0800
Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Andres,
> 
> > I discovered that if EMBEDDED=y, one can accidentally build a
> > mac80211 stack and drivers w/ no rate control algorithm.  For
> > drivers like RTL8187 that don't supply their own RC algorithms,
> > this will cause ieee80211_register_hw to fail (making the driver
> > unusable).
> > 
> > This will tell kconfig to provide a warning if no rate control
> > algorithms have been selected.  That'll at least warn the user;
> > users that know that their drivers supply a rate control algorithm
> > can safely ignore the warning, and those who don't know (or who
> > expect to be using multiple drivers) can select a default RC
> > algorithm.
> 
> this is not an acceptable policy. You are generating false positives
> now for drivers that have been fine before.
> 

Unacceptable how?  It's a warning, not a requirement.  It's
telling the user to double-check their config.
