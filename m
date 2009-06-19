Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:45855 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZFSXdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 19:33:09 -0400
Received: from [10.0.0.2] (ool-4573a3fb.dyn.optonline.net [69.115.163.251])
 by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLI00IGLERATNP0@mta4.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Fri, 19 Jun 2009 19:33:11 -0400 (EDT)
Date: Fri, 19 Jun 2009 19:33:10 -0400
From: Darren Blaber <dmbtech@gmail.com>
Subject: iwl3945 not working after recent commits
To: linux-wireless@vger.kernel.org
Message-id: <4A3C2036.6060506@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not sure which commit broke it, but using latest compat-wireless, I get 
this:

Jun 17 19:16:58 pi kernel: [330520.037510] iwl3945 0000:0c:00.0: PCI INT 
A disabled
Jun 17 19:17:10 pi kernel: [330532.624083] cfg80211: Calling CRDA to 
update world regulatory domain
Jun 17 19:17:10 pi kernel: [330532.673014] iwl3945: Intel(R) 
PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
Jun 17 19:17:10 pi kernel: [330532.673020] iwl3945: Copyright(c) 
2003-2009 Intel Corporation
Jun 17 19:17:10 pi kernel: [330532.673120] iwl3945 0000:0c:00.0: PCI INT 
A -> GSI 17 (level, low) -> IRQ 17
Jun 17 19:17:10 pi kernel: [330532.673141] iwl3945 0000:0c:00.0: setting 
latency timer to 64
Jun 17 19:17:11 pi kernel: [330532.745068] iwl3945 0000:0c:00.0: Tunable 
channels: 11 802.11bg, 13 802.11a channels
Jun 17 19:17:11 pi kernel: [330532.745074] iwl3945 0000:0c:00.0: 
Detected Intel Wireless WiFi Link 3945ABG
Jun 17 19:17:11 pi kernel: [330532.745247] iwl3945 0000:0c:00.0: irq 28 
for MSI/MSI-X
Jun 17 19:17:11 pi kernel: [330532.746391] iwl3945 0000:0c:00.0: Failed 
to register hw (error -17)
Jun 17 19:17:11 pi kernel: [330532.746511] iwl3945 0000:0c:00.0: PCI INT 
A disabled
Jun 17 19:17:11 pi kernel: [330532.746521] iwl3945: probe of 
0000:0c:00.0 failed with error -17
Jun 17 19:17:11 pi kernel: [330532.774440] cfg80211: World regulatory 
domain updated:
Jun 17 19:17:11 pi kernel: [330532.774446] ^I(start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Jun 17 19:17:11 pi kernel: [330532.774449] ^I(2402000 KHz - 2472000 KHz 
@ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:17:11 pi kernel: [330532.774452] ^I(2457000 KHz - 2482000 KHz 
@ 20000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:17:11 pi kernel: [330532.774455] ^I(2474000 KHz - 2494000 KHz 
@ 20000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:17:11 pi kernel: [330532.774458] ^I(5170000 KHz - 5250000 KHz 
@ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:17:11 pi kernel: [330532.774461] ^I(5735000 KHz - 5835000 KHz 
@ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:18:04 pi kernel: [330585.724088] cfg80211: Calling CRDA to 
update world regulatory domain
Jun 17 19:18:04 pi kernel: [330585.774465] cfg80211: World regulatory 
domain updated:
Jun 17 19:18:04 pi kernel: [330585.774470] ^I(start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Jun 17 19:18:04 pi kernel: [330585.774474] ^I(2402000 KHz - 2472000 KHz 
@ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:18:04 pi kernel: [330585.774477] ^I(2457000 KHz - 2482000 KHz 
@ 20000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:18:04 pi kernel: [330585.774479] ^I(2474000 KHz - 2494000 KHz 
@ 20000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:18:04 pi kernel: [330585.774482] ^I(5170000 KHz - 5250000 KHz 
@ 40000 KHz), (300 mBi, 2000 mBm)
Jun 17 19:18:04 pi kernel: [330585.774485] ^I(5735000 KHz - 5835000 KHz 
@ 40000 KHz), (300 mBi, 2000 mBm)

Not sure what is causing this, but it prevents the card from 
functioning. I have also created a bug: 
http://bugzilla.kernel.org/show_bug.cgi?id=13585 .
