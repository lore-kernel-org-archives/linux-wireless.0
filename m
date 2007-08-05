Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59836
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXHEVoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 17:44:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: suspend/resume support in mac80211
Date: Sun, 5 Aug 2007 23:44:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <1186343417.8459.23.camel@localhost>
In-Reply-To: <1186343417.8459.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708052344.12673.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 August 2007, Mattias Nissler wrote:
> Hi,
> 
> we have recently been struggling with getting suspend/resume working in
> rt2x00. A few questions:

There is no suspend/resume support in mac80211.

> 1. What is the recommended scheme for implementing suspend/resume with
> mac80211? Some drivers (p54, iwlwifi) call ieee80211_stop_queues().

Calling stop_queues() from outside of the TX handler may deadlock.
That is a bug in mac80211. I don't think it has been fixed, yet.

> 2. Are there any mac80211 drivers that suspend/resume properly? Also
> when associated?
> 
> 3. Shouldn't mac80211 be made suspend/resume-aware (AFAIK it is not), so
> we can do things like disassociating during suspend and reassociating
> when resuming? I'd like something in the spirit of
> netif_device_detach()/netif_device_attach(). Comments?

I think we should have a API call to mac80211 that suspends the stack
(saves the state etc..) and a call the resumes (reassociates, re-handshakes...).
But that's probably not that easy to implement, as parts of this
does happen in userspace.
