Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms042pub.verizon.net ([206.46.252.42]:65408 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZANFEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 00:04:00 -0500
Received: from depotrd.localnet ([96.237.17.143])
 by vms042.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0KDG00HV33DWYHC1@vms042.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 13 Jan 2009 23:03:33 -0600 (CST)
Date: Wed, 14 Jan 2009 00:03:31 -0500
From: Glenn Burkhardt <gbburkhardt@verizon.net>
Subject: poor performance with ath5k; reverting to ath_pci
To: linux-wireless@vger.kernel.org
Message-id: <200901140003.31693.gbburkhardt@verizon.net> (sfid-20090114_060412_927875_0D296AA0)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just upgraded my system to Suse 11.1, and it installed the ath5k driver.  I 
started having trouble with network access, and found that the response time 
to the wireless router in my house was lousy:

glenn@DepotRd:~> ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=1233 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1901 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=1550 ms

So I pulled the madwifi-0.9.4-1.src.rpm, and re-configured to use the ath_pci 
driver.  The results were much better:

glenn@DepotRd:~> ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=0.493 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=0.485 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=0.501 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=0.518 ms

The card I have is the Netgear WG311T, which reports with PCI ID 
0x168c:0x0013, and in the log as "Atheros Communications Inc. Atheros AR5001X+ 
Wireless Network Adapter (rev 01)".

I'd be happy to try to help figure out why the response time is so bad with 
the ath5k driver, but I'm completely new to this code set.
