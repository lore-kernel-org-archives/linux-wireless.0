Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34910 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZFFSAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 14:00:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
Date: Sat, 6 Jun 2009 20:00:31 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052101.47168.mb@bu3sch.de> <4A298C37.9030503@lwfinger.net>
In-Reply-To: <4A298C37.9030503@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906062000.31602.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry, wouldn't it work to do

mutex_lock();
...
if (!initialized) {
	ssb_bus_powerup();
	ssb_device_enable();
	poll_the_bit;
	ssb_device_disable();
	ssb_bus_may_powerdown();
}
...
mutex_unlock();

That would be a _lot_ less heavyweight (at the order of 300 milliseconds less).
And from a power point of view, the PHY and Radio would stay turned off.

-- 
Greetings, Michael.
