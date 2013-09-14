Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-sanjose2.Cadence.COM ([158.140.2.61]:43879 "EHLO
	mx-sanjose2.cadence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3ING2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 02:28:11 -0400
Received: from exowa05sj.global.cadence.com (sjmail.Cadence.COM [158.140.32.174])
	by mx-sanjose2.cadence.com (8.14.4/8.14.4) with ESMTP id r8E5XQvT001536
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 22:33:27 -0700 (PDT)
From: Jason Andrews <jasona@cadence.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 13 Sep 2013 22:36:07 -0700
Subject: guidance on struct alignment for rtl8192cu driver
Message-ID: <985A2B0C3F73B74792F35D4098E1CA7CB143670E93@MAILSJ3.global.cadence.com> (sfid-20130914_082815_320137_4377D7D8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using an ASUS USB N13 on an ARM platform with the rtl8192cu driver.
Linux kernel is 3.10 so I probably don't have the latest and greatest driver.

When I booted I got an ARM alignment trap caused by the driver.

I determined the cause was the 1st argument to spin_lock_irqsave() has an unaligned address.

By trial-and-error I found that if I edit wifi.h and insert 2 dummy bytes into the rtl_priv struct just above priv (last variable) the locks work and the driver works fine.

What is the recommended way to make sure the last variable in the rtl_priv struct (u8 priv[0]) is aligned on a 4 byte boundary so the driver works on ARM machines?

Regards,
Jason

