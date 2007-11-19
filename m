Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.tpgi.com.au ([203.12.160.101]:50285 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbXKSBhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 20:37:53 -0500
Received: from [10.1.2.66] (eth6155.nsw.adsl.internode.on.net [59.167.247.10])
	(authenticated bits=0)
	by mail5.tpgi.com.au (envelope-from shaddy_baddah@hotmail.com) (8.14.2/8.14.2) with ESMTP id lAJ0ueTR027821
	for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2007 11:56:42 +1100
Message-ID: <4740DF47.4040206@hotmail.com> (sfid-20071119_013759_873343_CEC444F7)
Date: Mon, 19 Nov 2007 11:56:39 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have successfully built a 2.6.22 kernel for sparc64, by taking the 
configuration for the Debian build of this kernel, and additionally 
configuring the zd1211rw driver.

I am able to modprobe this module, and the device is correctly detected. 
  However, beyond that, I am experiencing problems with the device here 
and there.

The first noticeable problem is when using iwconfig on the device. I 
cannot set a key for the device, and a query of the configuration always 
claims that the "<encryption key is too long>".

If I try to scan for APs using iwlist, I get one AP listed, before a bus 
error occurs. This of course, does not suggest that the problem is with 
the driver, but I mention it for the record.

If I configure my AP for open authentication, I can actually configure 
the device, and be assigned an address via DHCP. However, the connection 
drops out frequently, and is quite unstable.

Whilst the device is up, I continually get console messages like those I 
have inlined below:

Kernel unaligned access at TPC[100ee4d4] do_rx+0x244/0x614 [zd1211rw]
Kernel unaligned access at TPC[100ee4e8] do_rx+0x258/0x614 [zd1211rw]
Kernel unaligned access at TPC[100ee4cc] do_rx+0x23c/0x614 [zd1211rw]


I am supposing that the driver hasn't really been tested extensively on 
sparc64 architecture. However, can anyone shed some light on why the 
driver wouldn't just work as it (I assume) would do on 386 architecture?

Thanks in advance,
Shaddy
