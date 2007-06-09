Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out24.alice.it ([85.33.2.24]:1854 "EHLO
	smtp-out24.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbXFIQQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 12:16:50 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: airo
Date: Sat, 9 Jun 2007 18:16:47 +0200
References: <200706061903.13228.rootkit85@yahoo.it> <46693003.8090406@redhat.com> <200706091519.29319.rootkit85@yahoo.it>
In-Reply-To: <200706091519.29319.rootkit85@yahoo.it>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706091816.47618.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

after booting i have this situation:

root@raver:~# lsmod |fgrep airo
airo                   80016  0
root@raver:~# dmesg |fgrep airo
airo(): Probing for PCI adapters
airo(eth1): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
airo(eth1): Doing fast bap_reads
airo(eth1): WPA is supported.
airo(eth1): Couldn't register_netdev
airo(): Finished probing for PCI adapters
root@raver:~#

I have to do this to connect:

root@raver:~# rmmod airo
root@raver:~# modprobe airo
root@raver:~# dmesg |fgrep airo
airo(): Probing for PCI adapters
airo(eth1): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
airo(eth1): Doing fast bap_reads
airo(eth1): WPA is supported.
airo(eth1): Couldn't register_netdev
airo(): Finished probing for PCI adapters
airo(): Probing for PCI adapters
airo(eth0): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
airo(eth0): Doing fast bap_reads
airo(eth0): WPA is supported.
airo(eth0): MAC enabled 0:d:29:4f:c:be
airo(): Finished probing for PCI adapters
root@raver:~#
