Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:34457 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbXJMIRp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 04:17:45 -0400
Date: Sat, 13 Oct 2007 12:17:30 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: "John W. Linville" <linville@redhat.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: b43: regression on bcm4318
Message-ID: <20071013121730.1eef0d93@kernel.crashing.org> (sfid-20071013_091751_024449_0CAD8DB8)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John et al,
(previous email had a typo in ML addr, sorry for the extra noise)

Both b43 and b43legacy fail to load on bcm4318 for a while now, while it used to work (with known issues) more or less
fine. The issue started happening not long before ssb united the support of b44 as well. Therefor, I noticed the difference
soon, because I am not able to use ndiswrapper instead anymore (it does not like ssb, and my NIC, b44, does not like
ssb missing either).

dmesg looks like the below:

b43-phy1: Broadcom 4318 WLAN found
b43-phy1 debug: Found PHY: Analog 3, Type 2, Revision 7
b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
phy1: Failed to select rate control algorithm
phy1: Failed to initialize rate control algorithm
b43: probe of ssb0:0 failed with error -2

Currently this is latest rawhide kernel, but has been happening for awhile
(since, at least, 2.6.22.5, where ssb was not yet merged and I still able to use ndiswrapper.

Any hint to debug/investigate it appreciated. It does not look like hw malfunction, since ndiswrapper,
when able to load, still works fine.

-- 
Sincerely, Vitaly
