Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37713 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYL0VJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 16:09:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: Hostapd doesn't like crda
Date: Sat, 27 Dec 2008 22:08:20 +0100
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <200812272208.20153.mb@bu3sch.de> (sfid-20081227_220932_735547_E49BEFBF)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please take a look at the following log:
http://bu3sch.de/misc/crda.JPG

Note the ordering of the events.
Hostapd starts up and tells the kernel what country we're in.
Then the kernel calls CRDA, _but_ hostapd goes on with its business
before CRDA has finished its work.
So hostapd does set the channel before regulatory stuff is uploaded by CRDA
to the kernel. That fails, if we use channel 13, which is allowed in DE,
but not in the default regulatory settings.

On the second attempt to start hostapd it works fine, of course, because
the regulatory tables are already uploaded.

Any ideas?

-- 
Greetings, Michael.
