Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59695 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbYGWFny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 01:43:54 -0400
Message-ID: <4886C50E.6040304@lwfinger.net> (sfid-20080723_074433_332139_B395299C)
Date: Wed, 23 Jul 2008 00:43:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <200807221613.34434.herton@mandriva.com.br> <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com> <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>
In-Reply-To: <4886AA3B.3000406@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

In the current wireless-testing (v2.6.26-rc9-14207-ga520bdb), rtl8187 is broken. 
In most cases, it is unable to complete a connection. Occasionally, it will 
authenticate and even get an IP using DHCP; however, only a few pings get 
through to the AP before the connection fails completely.

Using bisection, this problem was traced to:

==================================================
commit 741b4fbc441dba885cc8f97a10e87f2acd04c5f2
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Jul 10 11:21:26 2008 +0200

     mac80211: fix TX sequence numbers

     This patch makes mac80211 assign proper sequence numbers to
     QoS-data frames. It also removes the old sequence number code
     because we noticed that only the driver or hardware can assign
     sequence numbers to non-QoS-data and especially management
     frames in a race-free manner because beacons aren't passed
     through mac80211's TX path.
===============================================================

The validity of the bisection was confirmed by reverse application of the patch. 
The resulting driver worked.

The appears that rtl8187 needs some kind of modification such as b43, b43legacy, 
and rt2x00 got in the original patch. I'll be studying the changes to the other 
drivers to see if I can find the problem, but I will appreciate your help when 
you get a chance. Perhaps after your trip to Canada is over.

Thanks,

Larry
