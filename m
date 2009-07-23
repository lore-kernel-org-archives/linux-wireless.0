Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1883 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZGWRE7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 13:04:59 -0400
Message-ID: <4A68982E.2070101@canonical.com>
Date: Thu, 23 Jul 2009 11:04:46 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rfkill blocking is sticky on virtual instances
References: <4A687AAB.8070306@canonical.com>
In-Reply-To: <4A687AAB.8070306@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Gardner wrote:
> It seems that enabling soft blocking on virtual instances of rfkill is
> sticky. For example (using 2.6.31-rc4),
> 
> rtg@lanai:~$ uname -r
> 2.6.31-4-generic
> rtg@lanai:~$ rfkill list
> 0: dell-wifi: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 1: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> rtg@lanai:~$ sudo rfkill block all
> [sudo] password for rtg:
> rtg@lanai:~$ rfkill list
> 0: dell-wifi: Wireless LAN
> 	Soft blocked: yes
> 	Hard blocked: no
> 1: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: yes
> rtg@lanai:~$ sudo rfkill unblock all
> rtg@lanai:~$ rfkill list
> 0: dell-wifi: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: yes
> 1: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 
> Shouldn't I be able to unblock everything at one fell swoop? As long as
> dell-wifi remains hard blocked, wireless will not reconnect. I've
> observed this behavior on both iwl3945 as well as iwlagn. Dunno if its
> driver specific, but I suspect not because I see similar behaviors on
> platforms with bluetooth.
> 
> rtg

So, Johannes pointed out that 'all' was not a valid option to
block/unblock (doh!). Since that is something I think a lot of folks
would like to be able to do, I've added support for blocking by wireless
type as well as 'all'.

Please pull:

The following changes since commit 2c3cbb3ae38dd6100ca03d7060b1a0704311d18b:
  Johannes Berg (1):
        bump version to 0.1

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/rfkill master

Tim Gardner (3):
      Added a utility function to acquire a list of events.
      Added rfkill_block_all()
      Added support for block/unblock wireless types.

 rfkill.c |  127
+++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 113 insertions(+), 14 deletions(-)
-- 
Tim Gardner tim.gardner@canonical.com
