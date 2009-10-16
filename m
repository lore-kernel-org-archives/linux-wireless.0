Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbZJPQQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 12:16:15 -0400
Subject: Re: libertas + cfg80211: road for kernel inclusion?
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910161426.22206.hs4233@mail.mn-solutions.de>
References: <200910161426.22206.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 09:16:20 -0700
Message-Id: <1255709780.14241.26.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-16 at 14:26 +0200, Holger Schurig wrote:
> Hi all !
> 
> Today I got a connection of libertas + cfg80211 to an AP in the 
> modes WEP40, WEP104, WPA, WPA2 and also with no encryption at 
> all.
> 
> I still have some loose odds and ends, but the initial work is 
> done and we can consider if we want this feature included in the 
> linux kernel --- or not.
> 
> 
> However, an cfg80211-converted libertas has some missing 
> features, that others migth think are important: no 
> libertas-mesh, no monitor mode, no ad-hoc mode. Nothing of this 
> is per-se impossible with cfg80211, it just needs to be 
> implemented.
> 
> I see several possibilities:
> 
> 
> 1. Let it mature outside
>    ---------------------
> Keep libertas+cfg80211 out-of-tree until it supports some minimal 
> functionality.
> 
> Pro: no one misses a feature
> Cons: no widespread testing of the cfg80211 features
> 
> 
> 2. Take it as it is
>    ----------------
> Nah, not exactly at it is today, but let us stop by missing 
> monitor-mode, adhoc etc --- for now. Implement that later, once 
> libertas is in-kernel and people need it.

If you can keep working on this, I'd say lets shoot for kernel inclusion
in 2.6.34.  But we'd need at least adhoc support before then.  The mesh
stuff will be interesting, yes, but hopefully we can hammer out what the
specific interface there should be.

I'm somewhat hesitant about pushing a big change like this to 2.6.33
without a lot more testing by people that have the hardware.  I haven't
had time to poke at this yet besides looking at the patches.

BTW, do you have any rough counts of the LoC you've removed from the
driver as a result of this?  Ideally you could remove a cargo-ship's
worth of work I did back in 2007 and you know what?  I like that :)

Dan

> Pro: widespread testing of the cfg80211 features
> Cons: people miss some functions when they upgrade the kernel
> 
> 
> 3. Make things configurable
>    ------------------------
> I could create a Kconfig "choice" entry, where one can select 
> CONFIG_LIBERTAS_WEXT or CONFIG_LIBERTAS_CFG80211. I would then 
> provide a bunch of cleanup patches, e.g. to move all things in 
> struct "libertas_private" into one place that are WEXT-related.
> 
> Pro: no one misses his beloved feature (because it's in 
> CONFIG_LIBERTAS_WEXT)
> Pro: some people can test the cfg80211-features (with 
> CONFIG_LIBERTAS_CFG80211)
> Cons: we have a higher amount of #ifdef in Libertas code until 
> either libertas-cfg80211 got all the features added OR until 
> WEXT get's removed from the kernel.
> 
> 

