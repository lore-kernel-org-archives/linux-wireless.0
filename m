Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965108Ab3GLSed (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 14:34:33 -0400
Date: Fri, 12 Jul 2013 14:34:24 -0400
From: Dave Jones <davej@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: fail to flush all tx fifo queues
Message-ID: <20130712183424.GB12460@redhat.com> (sfid-20130712_203436_700737_AF8EFBD9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just hit this on Linus' current post 3.10 tree.

hardware is 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 3e)


iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 11
iwlwifi 0000:03:00.0: Current SW read_ptr 247 write_ptr 2
iwl data: 00000000: 03 00 00 00 00 00 00 00 00 00 80 ff 00 00 00 03  ................
iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b001
iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300095
iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00704006
iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [150,150]
iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [67,71]
iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 7 ra_tid 0x0000 [7,7]
iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 9 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1 ra_tid 0x0000 [247,2]
iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
iwlwifi 0000:03:00.0: Current SW read_ptr 157 write_ptr 161
iwl data: 00000000: 00 00 00 e0 00 00 00 00 01 00 00 00 00 00 00 00  ................
iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc010b0e6
iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300098
iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
iwlwifi 0000:03:00.0: FH TRBs(7) = 0x0070408e
iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [153,153]
iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [157,161]
iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo 7 ra_tid 0x0000 [143,143]
iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 9 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 11 is active and mapped to fifo 1 ra_tid 0x0000 [227,231]
iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]


At this point, the chip was hung. Even unloading/reloading the driver, or suspend/resume
wouldn't bring it back to life. I had to power off/on to get it to work again.

	Dave

