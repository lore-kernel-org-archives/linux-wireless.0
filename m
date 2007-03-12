Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:52359 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbXCLR6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 13:58:33 -0400
Date: Mon, 12 Mar 2007 10:56:39 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jkm@devicescape.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-ID: <20070312175639.GA4048@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070307020310.GA20466@bougret.hpl.hp.com> <1173364747.14001.7.camel@johannes.berg> <20070308184954.GA24485@bougret.hpl.hp.com> <1173382042.3248.63.camel@johannes.berg> <20070308193412.GG23040@devicescape.com> <1173382802.3248.68.camel@johannes.berg> <20070308221128.GA24884@bougret.hpl.hp.com> <1173393326.3831.21.camel@johannes.berg> <20070309213531.GA28070@bougret.hpl.hp.com> <1173634801.3382.8.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173634801.3382.8.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 11, 2007 at 06:40:01PM +0100, Johannes Berg wrote:
> On Fri, 2007-03-09 at 13:35 -0800, Jean Tourrilhes wrote:
> 
> > 	It's not as bad as it look like. All userspace programs
> > nowadays use either the iwlib or wpa_supplicant. For example,
> > NetworkManager gets its stuff through wpa_supplicant, and kdenetwork
> > uses iwlib. So, in essence, there is only two places to fix.
> 
> That's definitely not true, the latest network manager I have sources to
> on my laptop right now (0.6.4) uses iwlib but only iw_get_ext and no
> parsing functions.

	You are right. I did assume that if it was using iwlib, it
would use the scan helpers. As I said, I did my audit for the ESSID
stuff and did not refresh for the scan stuff.

> I would guess that others "use" iwlib like that too.

	Which others ? The applications that process scan results can
be counted on your fingers. And if you count the one actively
developped, you can use one hand.

> Can you please also *document* the bandaid and actually *describe* it in
> *words* instead of dense code without comments?

	I did that in the e-mail to Jouni. The problem is that most
people are unfamiliar with decoding iwevents, so can't grasp the
explanation.
	Basically, for iwpoint, we have an outer lenght and an inner
length. If they don't match, we have an alignement issue and just need
to pick the payload 8 bytes after the expected location.
	For other events, they have a well known size. If the outer
lenght is not the expected size, but is expected+4, you just pick the
payload 4 bytes after the expected location.

> I'm still not convinced that papering over the problem in userspace is a
> real solution.

	The final overall solution may be a mix of individual
solutions. This is definitely part of it. We don't know yet what are
the other part of this overall solution.
	This brings a solution to people using current and old
kernel. For example, I would expect to be much easier to convince
distro to update older/stable versions with a new wtool than with a
new kernel. The fix I did is trivial to backport to WT-28 or WT-27
(which I plan to do once it's confirmed it works).

>  johannes

	Have fun...

	Jean

