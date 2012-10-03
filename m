Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.bufferbloat.net ([149.20.54.82]:44886 "EHLO
	huchra.bufferbloat.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2JCUBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 16:01:42 -0400
From: =?UTF-8?q?Dave=20T=C3=A4ht?= <dave.taht@bufferbloat.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] Adding more comprehensive diffserv support to wireless
Date: Wed,  3 Oct 2012 12:51:35 -0700
Message-Id: <1349293896-18268-1-git-send-email-dave.taht@bufferbloat.net> (sfid-20121003_220145_704139_85450744)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The subsequent patch has been in cerowrt for a while. 

The previous dscp scheme in linux wireless only respected the topmost
3 diffserv priority bits (e.g. CS0 through CS7). This patch respects
all the diffserv bits and all the old-style tos bits that make sense.

It moves all but EF marked traffic out of the VO queue, where CS6 and
CS7 have been going.

The imm bit (set by ssh) now moves to VI. Background goes to BK
Most other (obsolete) options move into VI, notably CS6 and CS7 traffic.

Notes:

1) a few of my definitions for diffserv to hardware queue mappings 
   might be debateable
2) it would be good to have similar handling in vlans
3) 802.11q has very different behavior than 802.11e
4) it buries diffserv mappings in the mac layer when they should probably 
   be up at tc-ish layer, or netlink/iw layer
5) there is no way to change the diffserv map

Lastly... 
In using the new netperf -Y codepoint,codepoint stream classification feature,
to fully exercise these hw queues, 
it exposed some problems (long since fixed) with VI hw queue handling 
on ath9k. Some of my tests that fully exercise the wifi HW queues in this 
way seem to point to problems in other chips/drivers such as the iwl.



--
Dave Täht

Fixing bufferbloat with cerowrt...
http://www.teklibre.com/cerowrt/subscribe.html
