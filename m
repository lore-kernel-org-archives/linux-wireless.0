Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:52643 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992813AbXEBGeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 02:34:09 -0400
Message-ID: <20070502023406.0efnk48888owckc8@webmail.spamcop.net>
Date: Wed,  2 May 2007 02:34:06 -0400
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Compilation error with latest wireless-dev
References: <4638161D.7020106@lwfinger.net>
In-Reply-To: <4638161D.7020106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Larry Finger <Larry.Finger@lwfinger.net>:

> Compiling wireless-dev (commit d2f859f56c9f00f093f943cf810a863a5aa2e10f)
> results in the following
> error when building modules:
>
> WARNING: "tcf_destroy_chain" [net/mac80211/mac80211.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
> In my configuration, net/sched/sch_api.c where tcf_destroy_chain is defined
> is not compiled. The
> network-related configuration parameters are:

Same problem here.  CONFIG_NET_SCH_FIFO was enabled, apparently by
net/mac80211/Kconfig, but CONFIG_NET_SCHED.  Selecting the later (but none of
the schedulers) fixed the compile error.

However, the is something weird with the new kernel.  DNS has stopped working. 
Under the new kernel, DNS requests get "port unreachable" ICMP responses seen
in Wireshark (sorry, I would have to reboot to get the exact message).  The DNS
server is in a different subnet.  I can ping it and even telnet (over TCP) to
the DNS port 53.

Under the old kernel, the DNS requests are answered properly.

There is no way netdev folks can be unaware of it, so it's just a word of
caution, not a bugreport.

--
Regards,
Pavel Roskin
