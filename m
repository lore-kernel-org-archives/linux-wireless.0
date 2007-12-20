Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:54869 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXLTTXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 14:23:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Mattias Nissler <mattias.nissler@gmx.de>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: mac80211: rc algos broken
Date: Thu, 20 Dec 2007 20:20:51 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200712202020.51320.mb@bu3sch.de> (sfid-20071220_192312_188282_F863AF8E)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RC algos are broken in current wireless-2.6.
PID fails to load because it can not find any debugfs
related symbols (debugfs is mounted and works fine). I tried adding
an #include <linux/debugfs.h> to the code, but it doesn't help.

mac80211 also fails to load _any_ rc algorithm.
Both, PID and simple are compiled (after disabling debugfs stuff)
and mac80211 fails to find, load or whatever any of them.
The message "Failed to load rc algo blabla you know it" appears.

Thanks a lot for fixing this ;)

-- 
Greetings Michael.
