Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:38321 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbXEBKCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 06:02:30 -0400
Received: from asia.telenet-ops.be (asia.telenet-ops.be [195.130.137.74])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id DBA009D4D0
	for <linux-wireless@vger.kernel.org>; Wed,  2 May 2007 12:02:18 +0200 (CEST)
Message-ID: <46387E7E.7040300@telenet.be>
Date: Wed, 02 May 2007 12:05:18 +0000
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Compilation error with latest wireless-dev
References: <4638161D.7020106@lwfinger.net> <20070502023406.0efnk48888owckc8@webmail.spamcop.net>
In-Reply-To: <20070502023406.0efnk48888owckc8@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have had the same experience. pretty frustrating to see the dns queries being 
answered. But all the kernel does is send an "ICMP port unreachable" back to the 
dns server.

The only thing I can think of that could cause this is "netpoll" trapping the rx
But I only say that because there were some recent changes to that code, and 
the name sounds suspicious ;)

The compile error went away when I selected NET_SCHED which was the
"QoS/and fair queing" entry in menuconfig.

cheers Ian.

Pavel Roskin wrote:
> Quoting Larry Finger <Larry.Finger@lwfinger.net>:
> 
>> Compiling wireless-dev (commit d2f859f56c9f00f093f943cf810a863a5aa2e10f)
>> results in the following
>> error when building modules:
>>
>> WARNING: "tcf_destroy_chain" [net/mac80211/mac80211.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>>
>> In my configuration, net/sched/sch_api.c where tcf_destroy_chain is defined
>> is not compiled. The
>> network-related configuration parameters are:
> 
> Same problem here.  CONFIG_NET_SCH_FIFO was enabled, apparently by
> net/mac80211/Kconfig, but CONFIG_NET_SCHED.  Selecting the later (but none of
> the schedulers) fixed the compile error.
> 
> However, the is something weird with the new kernel.  DNS has stopped working. 
> Under the new kernel, DNS requests get "port unreachable" ICMP responses seen
> in Wireshark (sorry, I would have to reboot to get the exact message).  The DNS
> server is in a different subnet.  I can ping it and even telnet (over TCP) to
> the DNS port 53.
> 
> Under the old kernel, the DNS requests are answered properly.
> 
> There is no way netdev folks can be unaware of it, so it's just a word of
> caution, not a bugreport.
> 
> --
> Regards,
> Pavel Roskin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
