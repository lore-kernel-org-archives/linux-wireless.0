Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61359 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934350AbXC2Vqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 17:46:51 -0400
Message-ID: <460C33CA.3050509@lwfinger.net>
Date: Thu, 29 Mar 2007 16:46:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Patches for bcm43xx-softmac
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent change to the specs for the initialization of 2.4 GHz radios has resulted in increased
transfer speeds for the bcm43xx-softmac driver. Thanks to Joe Jezak for all his work.

My measurements are for transfers speeds between my laptop and an FTP server connected to my router
by a 100 Mbs wired connection. Using the new patches, I get receive speeds up to 2 MB/s and transmit
speeds of up to 0.7 MB/s for the BCM4311 and the BCM4318. Speeds for the BCM4306 are slower (0.7
MB/s for receive and 0.6 MB/s for transmit).

The files needed to patch the various 2.6.20.y and 2.6.21-rc5 kernels are at
ftp://lwfinger.dynalias.org/patches. I have abandoned support for 2.6.18 and 2.6.19 kernels. The
patch for 2.6.21-rc5 can be applied to either Linus's or Linville's wireless-2.6 git tree.

Also on the FTP site are two Perl scripts for testing. One of them (perf_test.pl) uses an Iperf
server somewhere on your LAN. The other (file_test.pl) works with an NFS server on your LAN to
measure transfer rates.

