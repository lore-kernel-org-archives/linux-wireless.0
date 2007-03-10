Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gundega.hpl.hp.com ([192.6.19.190]:63188 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767699AbXCJBB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 20:01:57 -0500
Date: Fri, 9 Mar 2007 17:01:28 -0800
To: Jouni Malinen <jkm@devicescape.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-ID: <20070310010128.GA28810@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070307020310.GA20466@bougret.hpl.hp.com> <1173364747.14001.7.camel@johannes.berg> <20070308184954.GA24485@bougret.hpl.hp.com> <1173382042.3248.63.camel@johannes.berg> <20070308193412.GG23040@devicescape.com> <1173382802.3248.68.camel@johannes.berg> <20070308221128.GA24884@bougret.hpl.hp.com> <1173393326.3831.21.camel@johannes.berg> <20070309213531.GA28070@bougret.hpl.hp.com> <20070309231922.GF24143@devicescape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070309231922.GF24143@devicescape.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 09, 2007 at 03:19:22PM -0800, Jouni Malinen wrote:
> On Fri, Mar 09, 2007 at 01:35:31PM -0800, Jean Tourrilhes wrote:
> 
> > 	It's not as bad as it look like. All userspace programs
> > nowadays use either the iwlib or wpa_supplicant. For example,
> > NetworkManager gets its stuff through wpa_supplicant, and kdenetwork
> > uses iwlib. So, in essence, there is only two places to fix.
> > 	Which is why I would like to hear from Jouni.
> 
> How confident are you of this being the full set?

	I spent some time tracking that when we did the ESSID
change. I also try to keep the list on my web site up to date.
	The reason the set is small is that most programs are
simplistic, only reporting signal strength, and only a few go beyond
that.

> > 	By the way, I've just released version 29.pre16 which has a
> > better band aid. It fixes bugs of the previous version and is more
> > forward compatible (i.e. it's compatible with option 2).
> 
> Hmm.. What should I look as the description of the latest proposed
> workaround? I was kind of hoping to see a nice description of the
> problem and proposed change in couple of paragraphs of text.. ;-)

	Alignement issue in structures. On 64 bit, you get an extra 4
bytes of stuff between the header and the payload. So, you need to
detect this condition and remove the extra 4 bytes.

> Anyway, I can see two changes when I diff wireless tools 29.pre14 and
> pre15 that are clearly related to this. Diff of pre14 vs. pre16 or pre15
> vs. pre16 includes more changes and some of them do not seem to be
> related to issue.

	Actually, apart from ifrename, all the pre15 to pre16 changes
are related to this.

> Unfortunately I do not have access to any system to test this
> workaround, so I cannot easily test this myself.

	Same here.

> Jouni Malinen

	Jean

