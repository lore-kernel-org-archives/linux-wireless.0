Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51025
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbXI1MBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 08:01:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: r2x00: Wrong rfkill inputdev poll interval
Date: Fri, 28 Sep 2007 13:58:57 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200709281358.57627.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You pass the poll interval as (HZ/4), but the input
dev expects milliseconds instead of jiffies.
So a value of 250 would be right in your case.
Though, I think polling that often for this event might be overkill.

I'd say polling once a second should be OK for b43, for example.
We currenty also poll it only once per second.
But that's up to your choice. :)

-- 
Greetings Michael.
