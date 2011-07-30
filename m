Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47864 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1G3PTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 11:19:08 -0400
Received: by iyb12 with SMTP id 12so5141150iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 08:19:08 -0700 (PDT)
Message-ID: <4E3420E9.6080603@lwfinger.net> (sfid-20110730_171936_395743_89DE6563)
Date: Sat, 30 Jul 2011 10:19:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Report on bcma with 14e4:4353 (BCM43224)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał,

I'm using a recent pull from wireless-testing - 'git describe' results in 
master-2011-07-26-150-g4ea94a9.

The driver is working well with reasonable performance. Using tcpperf, I get 
8-10 Mb/s upload on an 802.11g connection. The connection has been up for 17 
hours with no disconnects.

A minor annoyance is that the driver does not autoload on boot and had to be 
manually modprobed. AFAIK, I don't have any blacklisting or other configuration 
parameters that would cause this. Furthermore, I don't see anything in the 
driver code that would cause this. Does autoload work on your system?

A more serious problem is that the driver does not work on my 802.11n AP that is 
set for "up to 270 Mbps at 2.4 GHz". It will authenticate and associate, but the 
throughput is minimal. It also gets the "PHY transmission error" messages. None 
occur with 802.11g. I would guess some kind of error in the HT40 settings.

Thanks for your hard work on this device.

Larry
