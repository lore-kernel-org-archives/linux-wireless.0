Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3126 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZGWO7C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 10:59:02 -0400
Message-ID: <4A687AAB.8070306@canonical.com>
Date: Thu, 23 Jul 2009 08:58:51 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rfkill blocking is sticky on virtual instances
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that enabling soft blocking on virtual instances of rfkill is
sticky. For example (using 2.6.31-rc4),

rtg@lanai:~$ uname -r
2.6.31-4-generic
rtg@lanai:~$ rfkill list
0: dell-wifi: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
rtg@lanai:~$ sudo rfkill block all
[sudo] password for rtg:
rtg@lanai:~$ rfkill list
0: dell-wifi: Wireless LAN
	Soft blocked: yes
	Hard blocked: no
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: yes
rtg@lanai:~$ sudo rfkill unblock all
rtg@lanai:~$ rfkill list
0: dell-wifi: Wireless LAN
	Soft blocked: no
	Hard blocked: yes
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

Shouldn't I be able to unblock everything at one fell swoop? As long as
dell-wifi remains hard blocked, wireless will not reconnect. I've
observed this behavior on both iwl3945 as well as iwlagn. Dunno if its
driver specific, but I suspect not because I see similar behaviors on
platforms with bluetooth.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
