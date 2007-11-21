Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.tpgi.com.au ([203.12.160.61]:41603 "EHLO
	mail4.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXKUNAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 08:00:52 -0500
Message-ID: <47442BFC.8090008@hotmail.com> (sfid-20071121_130057_253737_40039B01)
Date: Thu, 22 Nov 2007 00:00:44 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	   Shaddy Baddah <shaddy_baddah@hotmail.com>,
	   David Miller <davem@davemloft.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: Re: ZD1211RW unaligned accesses...
References: <20071120.040546.222294375.davem@davemloft.net>
In-Reply-To: <20071120.040546.222294375.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

David Miller wrote:
> Shaddy I attach a hack patch that you can use which should get
> rid of the warnings.

It hasn't seemed to. I patched the source (confirming the patched lines 
are in), compiled, installed and rebooted to effect the changes. My 
zd1211rw modules timestamp indicates that I have an updated module:

$ ls -l /lib/modules/2.6.22/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
-rw-r--r-- 1 root root 84536 2007-11-21 23:18 
/lib/modules/2.6.22/kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko

lsmod confirms the module is loaded. After activating the interface 
(without configuring it yet):

$ ifconfig eth2 up

I start getting the messages over and over on the console:

Kernel unaligned access at TPC[100ee624] do_rx+0x394/0x5ec [zd1211rw]
Kernel unaligned access at TPC[100ee62c] do_rx+0x39c/0x5ec [zd1211rw]
Kernel unaligned access at TPC[100ee638] do_rx+0x3a8/0x5ec [zd1211rw]

Sorry that this has not been successful this time, but thanks for your 
help. I will be trying to follow-up on some of the other questions put 
to me.

Regards,
Shaddy
