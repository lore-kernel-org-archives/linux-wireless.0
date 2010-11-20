Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34439 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0KTBNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 20:13:07 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAK1D5u6021355
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 17:13:06 -0800
Message-ID: <4CE720A1.3090408@candelatech.com>
Date: Fri, 19 Nov 2010 17:13:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k very unstable and kills file-system.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been another frustrating week for using ath9k.

With a patched wpa_supplicant (found here:
https://github.com/greearb/hostap-ct/tree/)
I can reliably cause ath9k to spew all sorts of DMA warnings
and evidently crash the hard-drive controller and/or corrupt the
file system so bad that fsck cannot fix it.  (Back up anything you
want to keep before attempting to reproduce this.)

The test case is simply create 30 or so STA interfaces, run one instance
of the patched wpa_supplicant to control the 30 interfaces, and send
a bit of traffic across the interfaces.  It's not even needed to send
any significant data...probably just the supplicant associate logic
is enough.

You'll want the xmit locking patch Felix posted or it will likely spew
lockdep warnings and/or lockup before it gets a chance to crash your
hard drive.

There are no other /n NICs that can do virtual stations, so I must
either get ath9k functional or give up on that feature set entirely.

If anyone wants to help with this and cannot easily reproduce it,
please let me know and I'll furnish scripts etc to make it easier
to reproduce.

I'm also happy to help test patches.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

