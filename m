Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:42371 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab1KLRBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 12:01:11 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout7.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1RPGx2-0002cw-6E
	for linux-wireless@vger.kernel.org; Sat, 12 Nov 2011 18:01:08 +0100
Received: from localhost ([::1]:51066 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RPGx2-0007wO-2Q
	for linux-wireless@vger.kernel.org; Sat, 12 Nov 2011 18:01:08 +0100
Received: from [195.4.92.23] (port=42738 helo=13.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RPGuU-00076V-7T
	for linux-wireless@vger.kernel.org; Sat, 12 Nov 2011 17:58:30 +0100
Received: from p4fde0d2e.dip0.t-ipconnect.de ([79.222.13.46]:38506 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RPGuT-0006pX-Ub
	for linux-wireless@vger.kernel.org; Sat, 12 Nov 2011 17:58:30 +0100
Message-ID: <4EBEA616.2020002@01019freenet.de> (sfid-20111112_180116_700364_0A4CC049)
Date: Sat, 12 Nov 2011 18:00:06 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Try to narrow down the problem with rt2800usb and rt3572 based USB
 WLAN devices
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

as I already wrote some time ago, the rt2800usb module doesn't work very
well with WUSB600Nv2, e.g. (rt3572 chip). If it's on load, you get a lot
of warnings like these:


kernel: [357109.158376] phy0 ->rt2800usb_txdone_entry_check: Warning -
Data pending for entry 28 in queue 2

or:

kernel: [357109.158275] phy0 -> rt2800usb_txdone_entry_check: Warning -
TX status report missed for queue 2 entry 20

The throughput is very very bad (between 3 and 0 Mbits/s - 802.11n).


To get some more information about what's happening, I did an USB trace
and compared it with the rt3572sta driver from ralink.

First the outcome of the trace of the ralink driver (example - netperf
-t TCP_MAERTS -h server):

Packet- src->dst	Data			URB type	URB ID	
number
----------------------------------------------------------------------
7743	host -> 8.1	Request 24576 (0)	Submit		41c0
7744	8.1 -> host	21840 bytes		Complete	41c0 (response to 7743)

7745	host -> 8.1	Request 24576 (0)	Submit		b140
7746	8.1 -> host	21840 bytes		Complete	b140 (response to 7745)

7747	host -> 8.1	Request 24576 (0)	Submit		c5c0
7748	8.1 -> host	21840 bytes		Complete	c5c0 (response to 7747)

7749	host -> 8.1	Request 24576 (0)	Submit		92c0
7750	8.1 -> host	21840 bytes		Complete	92c0 (response to 7749)

7751	host -> 8.1	Request 24576 (0)	Submit		a440
7752	8.1 -> host	6240 bytes		Complete	a440 (response to 7751)

7753	host -> 8.1	Request 24576 (0)	Submit		fe40
7754	8.1 -> host	21840 bytes		Complete	fe40 (response zu 7753)


I could see a completely regular request/response behavior. Requested
are 24576 bytes, the response almost always is 21840 bytes. Throughput
is about 10 MBit/s.



The same trace with rt2800usb confuses me completely:

82998	host -> 8.1	Request 3860 (0)	Submit		2cc0
...
83043	8.1 -> host	1560 bytes		Complete	29c0

83044	host -> 8.1	Request 3860 (0)	Submit		2bc0
83045	host -> 8.1	Request 3860 (0)	Submit		2340
83046	host -> 8.1	Request 3860 (0)	Submit		25c0
83047	8.1 -> host	1560 bytes		Complete	2540
83048	host -> 8.1	Request 3860 (0)	Submit		27c0
83049	host -> 8.1	Request 3860 (0)	Submit		29c0
83050	host -> 8.1	Request 3860 (0)	Submit		2540
....
83056	8.1 -> host	1560 bytes		Complete	1e40 (response to 83050)
83057	8.1 -> host	1560 bytes		Complete	c640 (response to 83050)
83059	8.1 -> host	1560 bytes		Complete	f4c0 (response to 83050)
83060	8.1 -> host	1560 bytes		Complete	4940 (response to 83050)
83061	8.1 -> host	1560 bytes		Complete	3240 (response to 83050)

83062	host -> 8.1	Request 3860 (0)	Submit		1e40
83063	host -> 8.1	Request 3860 (0)	Submit		c640
83064	host -> 8.1	Request 3860 (0)	Submit		f4c0
83065	host -> 8.1	Request 3860 (0)	Submit		4940
83066	host -> 8.1	Request 3860 (0)	Submit		3240

83068	8.1 -> host	1560 bytes		Complete	7440 (response to 83066)
83070	host -> 8.1	Request 3860 (0)	Submit		7440

83072	8.1 -> host	1560 bytes		Complete	34c0 (response to 83070)
83073	8.1 -> host	1560 bytes		Complete	0840 (response to 83070)

83074	host -> 8.1	Request 3860 (0)	Submit		34c0
83075	host -> 8.1	Request 3860 (0)	Submit		0840
83076	host -> 8.1	Request 3860 (0)	Submit		ddc0
83077	8.1 -> host	1560 bytes		Complete	c8c0 (response to 83075)
83078	host -> 8.1	Request 3860 (0)	Submit		c8c0
83079	host -> 8.1	Request 3860 (0)	Submit		4bc0

83111	8.1 -> host	1560 bytes		Complete	ca40 (response to 83078)
83112	8.1 -> host	1560 bytes		Complete	c640 (response to 83078)
83116	host -> 8.1	Request 3860 (0)	Submit		ca40
83116	host -> 8.1	Request 3860 (0)	Submit		c640
83122	8.1 -> host	1560 bytes		Complete	c9c0 (response to 83117)
83123	host -> 8.1	Request 3860 (0)	Submit		c9c0
83125	8.1 -> host	1560 bytes		Complete	c5c0 (response to 83123)


The device gets bombed with tons of small requests (3860 bytes instead
of 24576) and sometimes, there can be seen an answer (1560 bytes instead
of 21840). Most of the requests seem not to be answered at all.


Another comparison: using the ralink driver, I could count about 2365
packets / s. With the rt2800usb driver, I could see about 15187 packets / s.



Could anybody please try to explain this behavior, or even better, fix
it (it looks really broken to me)?


Thank you,
kind regards,
Andreas
