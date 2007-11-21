Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.tpgi.com.au ([203.12.160.101]:56344 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXKUNJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 08:09:08 -0500
Message-ID: <47442DE2.2070207@hotmail.com> (sfid-20071121_130925_337264_29372944)
Date: Thu, 22 Nov 2007 00:08:50 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: David Miller <davem@davemloft.net>,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>,
	  linux-wireless@vger.kernel.org
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <47417D7F.3060704@hotmail.com>
In-Reply-To: <47417D7F.3060704@hotmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Shaddy Baddah wrote:
>> This is an unaligned data access in the userland tools.
>> Try to catch it with GDB and give us ths backtrace.
> 
> I will try and do this at some point. Unfortunately, the system isn't 
> readily at hand, and it might take a couple of days before I am able to 
> attend to it.

I've tried to do this as best as I can (I've munged the ethernet address 
for privacy), and have included the output in-line:

# gdb --args iwlist eth2 scanning
GNU gdb 6.4.90-debian
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain 
conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "sparc-linux-gnu"...(no debugging symbols found)
Using host libthread_db library "/lib/libthread_db.so.1".

(gdb) run
Starting program: /sbin/iwlist eth2 scanning
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
(no debugging symbols found)
eth2      Scan completed :
           Cell 01 - Address: GG:GG:GG:GG:GG:GG
                     ESSID:"dixieland"
                     Protocol:IEEE 802.11bg
                     Mode:Master
                     Channel:11
                     Frequency:2.462 GHz (Channel 11)

Program received signal SIGBUS, Bus error.
0xf7fa9eb8 in iw_extract_event_stream () from /lib/libiw.so.29
(gdb) bt
#0  0xf7fa9eb8 in iw_extract_event_stream () from /lib/libiw.so.29
#1  0x00011db0 in ?? ()
#2  0x00011db0 in ?? ()
Previous frame identical to this frame (corrupt stack?)
(gdb)


Hope that helps.

Regards,
Shaddy

