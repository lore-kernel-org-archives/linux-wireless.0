Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.math.uh.edu ([129.7.128.33]:33903 "EHLO mx2.math.uh.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXFVEuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 00:50:40 -0400
Received: from epithumia.math.uh.edu ([129.7.128.2])
	by mx2.math.uh.edu with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <tibbs@math.uh.edu>)
	id 1I1aiI-0007zZ-H6
	for linux-wireless@vger.kernel.org; Thu, 21 Jun 2007 23:25:39 -0500
Received: from epithumia.math.uh.edu (epithumia.math.uh.edu [127.0.0.1])
	by epithumia.math.uh.edu (8.13.8/8.12.5) with ESMTP id l5M4Pctn006282
	for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2007 23:25:38 -0500
To: linux-wireless@vger.kernel.org
Subject: iwl3945 problems
From: Jason L Tibbitts III <tibbs@math.uh.edu>
Date: 21 Jun 2007 23:25:38 -0500
Message-ID: <ufa8xacfwe5.fsf@epithumia.math.uh.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been trying new versions of the iwlwifi driver for a while now,
and while the situation for most folks seems to be improving, I'm not
having much luck.  I'm running 0.0.32 patched into the latest Fedora
kernel (which is basically 2.6.21.5 plus the current wireless-dev
tree).  This version is improved over some previous versions which
would periodically freeze the machine for a few seconds, but I can
still see no networks or even do a scan.  (iwlist scan just hangs for
about 15 seconds.)  I'm using version 2.14.3 of the microcode.

An interesting note is that the ipw3945 driver never worked on this
hardware either.  It manages to at least see networks, but won't
associate.  Unfortunately it does work fine under that other OS.

The machine is a Sony Vaio TXN17P; lspci shows:

01:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)

Here are the iwl3945-related kernel messages:
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 0.0.32d
iwl3945: Copyright(c) 2003-2007 Intel Corporation
iwl3945: Detected Intel PRO/Wireless 3945BG Network Connection
iwl3945: Unhandled INTA bits 0x04000000
iwl3945: Disabled INTA bits 0x04000000 were pending
iwl3945:    with FH_INT = 0x00000000
iwl3945: Channel 12 [2.4GHz] is Tx only -- skipping.
iwl3945: Channel 13 [2.4GHz] is Tx only -- skipping.
iwl3945: Channel 14 [2.4GHz] is Tx only -- skipping.
iwl3945: Channel 183 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 184 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 185 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 187 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 188 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 189 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 192 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 196 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 7 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 8 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 11 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 12 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 16 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 34 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 36 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 38 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 40 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 42 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 44 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 46 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 48 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 52 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 56 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 60 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 64 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 100 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 104 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 108 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 112 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 116 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 120 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 124 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 128 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 132 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 136 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 140 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 145 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 149 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 153 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 157 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 161 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 165 [5.2GHz] is Tx only -- skipping.
iwl3945: Tunable channels: 11 802.11bg, 0 802.11a channels
wmaster0: Selected rate control algorithm 'iwl-3945-rs'
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4418 ser 0x0000004B
iwl3945: ipw going down
iwl3945: Can't stop Rx DMA.
iwl3945: Grabbing access while already held at line 825.

Any assistance would be greatly appreciated.

 - J<
