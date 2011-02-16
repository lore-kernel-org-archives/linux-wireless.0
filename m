Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm3-vm1.bullet.mail.ird.yahoo.com ([77.238.189.212]:21617 "HELO
	nm3-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757273Ab1BPB2W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 20:28:22 -0500
Message-ID: <727820.81721.qm@web29509.mail.ird.yahoo.com>
Date: Wed, 16 Feb 2011 01:28:19 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: zd1211 vendor driver on 2.6.35.10
To: zd1211-devs@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	wiquitous@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I added patch 13 and 14 to
http://htl10.users.sourceforge.net/patchsets/LinuxUSB_AR2524-3.0.0.56/
which allows the zd1211 vendor driver to build against recent kernel - in my case, 2.6.35.10 .

I use it mainly for the AP mode, on an old machine that has just been resurrected after over a year, so the last it worked was on 2.6.31.x . There are a couple of old and new quirks: a dozen of 'We are trapped in zd_SigProcess, Going to release all,id=3,block=1' is new to 2.6.35.x, but the driver has always needed if down/up and or iwlist scan before a client station can connect, and that's still the case; and under extended use (a few days, and/or a few GB traffic) it can still bring the AP machine down.

I see some great person has just had a whole bunch of patches committed to wireless-testing in the last few months for enabling AP mode for the in-kernel zd1211rw driver... so 2.6.39(?) or thereabout it would be generally available...so the use of the vendor driver for AP mode would soon not be needed any more. I'd probably give the compat-wireless a try soon enough.


      
