Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.go2.pl ([193.17.41.42]:43818 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937694AbXFHVr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 17:47:56 -0400
Received: from poczta.o2.pl (mx2 [127.0.0.1])
	by poczta.o2.pl (Postfix) with ESMTP id A79EA748075
	for <linux-wireless@vger.kernel.org>; Fri,  8 Jun 2007 23:47:51 +0200 (CEST)
Received: from Z-98C0293EFA704 (87-205-45-25.adsl.inetia.pl [87.205.45.25])
	by poczta.o2.pl (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Fri,  8 Jun 2007 23:47:51 +0200 (CEST)
Date: Fri, 8 Jun 2007 23:47:32 +0200
From: zergavis <zergavis@o2.pl>
Reply-To: zergavis <zergavis@o2.pl>
Message-ID: <622435923.20070608234732@o2.pl>
To: linux-wireless@vger.kernel.org
Subject: Re[2]: mac80211 "wme.c:398" error
In-Reply-To: <466992FD.4050608@linux.intel.com>
References: <1279688715.20070608205031@o2.pl> <1181330294.6533.81.camel@johannes.berg> <466992FD.4050608@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you turn *off* CONFIG_NET_SCHED, it should build and run fine

Thanks, it works :) There was a problem with:

et/built-in.o: In function `rtnl_setlink':
rtnetlink.c:(.text+0x157bb): undefined reference to `wireless_rtnetlink_set'
net/built-in.o: In function `rtnl_getlink':
rtnetlink.c:(.text+0x15980): undefined reference to `wireless_rtnetlink_get'

but swiching off rtnetlink in wireless drivers fix it.

I will try mac80211-8.0.1 version in a few hours.

thanks,
pawel

