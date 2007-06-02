Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44132
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbXFBVXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 17:23:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: bcm43xx: New feature: Injection of TX queue overflows
Date: Sat, 2 Jun 2007 23:21:43 +0200
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Message-Id: <200706022321.43198.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added a feature to my tree that makes it possible to
conveniently inject a simulated TX queue overflow every
second. This could be used to test code in the stack
that's handling this rare event that almost never happens
in the real world (with sane hardware, at least :) )

http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=3dd01baded24ff2d35bb0e5dac5dd2d90932f926

You need to compile bcm43xx-mac80211 with debugging support.
The injection is enabled at runtime through debugfs
by doing:
echo 1 >/debug/bcm43xx_mac80211/phyX/debug_dmaoverflow

It prints a debugging message to dmesg every time it
injects a fault.

-- 
Greetings Michael.
