Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49247 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZGWSMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 14:12:19 -0400
Subject: Re: rfkill blocking is sticky on virtual instances
From: Marcel Holtmann <marcel@holtmann.org>
To: tim.gardner@canonical.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <4A68982E.2070101@canonical.com>
References: <4A687AAB.8070306@canonical.com>
	 <4A68982E.2070101@canonical.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 20:11:32 +0200
Message-Id: <1248372692.28545.127.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tim,

> > It seems that enabling soft blocking on virtual instances of rfkill is
> > sticky. For example (using 2.6.31-rc4),
> > 
> > rtg@lanai:~$ uname -r
> > 2.6.31-4-generic
> > rtg@lanai:~$ rfkill list
> > 0: dell-wifi: Wireless LAN
> > 	Soft blocked: no
> > 	Hard blocked: no
> > 1: phy0: Wireless LAN
> > 	Soft blocked: no
> > 	Hard blocked: no
> > rtg@lanai:~$ sudo rfkill block all
> > [sudo] password for rtg:
> > rtg@lanai:~$ rfkill list
> > 0: dell-wifi: Wireless LAN
> > 	Soft blocked: yes
> > 	Hard blocked: no
> > 1: phy0: Wireless LAN
> > 	Soft blocked: no
> > 	Hard blocked: yes
> > rtg@lanai:~$ sudo rfkill unblock all
> > rtg@lanai:~$ rfkill list
> > 0: dell-wifi: Wireless LAN
> > 	Soft blocked: no
> > 	Hard blocked: yes
> > 1: phy0: Wireless LAN
> > 	Soft blocked: no
> > 	Hard blocked: no
> > 
> > Shouldn't I be able to unblock everything at one fell swoop? As long as
> > dell-wifi remains hard blocked, wireless will not reconnect. I've
> > observed this behavior on both iwl3945 as well as iwlagn. Dunno if its
> > driver specific, but I suspect not because I see similar behaviors on
> > platforms with bluetooth.
> > 
> > rtg
> 
> So, Johannes pointed out that 'all' was not a valid option to
> block/unblock (doh!). Since that is something I think a lot of folks
> would like to be able to do, I've added support for blocking by wireless
> type as well as 'all'.
> 
> Please pull:
> 
> The following changes since commit 2c3cbb3ae38dd6100ca03d7060b1a0704311d18b:
>   Johannes Berg (1):
>         bump version to 0.1
> 
> are available in the git repository at:
> 
>   git://kernel.ubuntu.com/rtg/rfkill master
> 
> Tim Gardner (3):
>       Added a utility function to acquire a list of events.
>       Added rfkill_block_all()
>       Added support for block/unblock wireless types.

do you mind sending the actual patches. I like to review them.

Regards

Marcel


