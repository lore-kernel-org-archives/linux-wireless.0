Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:28502 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752713AbYKKIjm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 03:39:42 -0500
Date: Tue, 11 Nov 2008 08:39:40 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: throughput problem/bisect with rtl8187B
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200811101936.49887.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <41448.77528.qm@web23104.mail.ird.yahoo.com> (sfid-20081111_093946_619346_C3F3C8C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Herton,

I bisected through recent wireless-testing, and found the commit which results in my throughput problem - it is one of yours :-(. Can you and also possibly Larry give this a try: transfering some large files (>50MB) before and after reverting this particular commit, and see what sftp says about the transfer rate? You need to let sftp keep going for a while to see what rate it settles at. (>50MB should do, so a kernel source tarball
would be appropriate). The difference is quite obvious in my case - 
<60kB/s, and 7x - 10x that if I revert this commit. 

The commit is all magic numbers, so if you see the problem, can you please
have a look and check the numbers?

Thanks,
Hin-Tak 

-------------
>From 9c1493477380e51d152a2e0ef560291d7445e9ea Mon Sep 17 00:00:00 2001
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Mon, 13 Oct 2008 18:11:00 +0000
Subject: [PATCH] rtl8187: add short slot handling for 8187B

This change adds short slot handling for 8187B variant of rtl8187 chips.
Some things to note about changes done:
* Values used are chosen to met 802.11-2007 spec. This raised a question
  about SIFS value used with 8187L: 0x22 (34) doesn't match any spec
  value. For now just don't change 8187L, but is something to be
  looked at.
* On 8187B, the location of EIFS register is at the same place as BRSR+1
  of struct rtl818x_csr. Unfortunately there is no clean way to
  accomodate 8187B differences currently, just use address of BRSR+1 and
  comment about it. The same thing happens for Ack timeout register,
  that is on CARRIER_SENSE_COUNTER location of 8187L. The eifs and ack
  timeout values are in units of 4us. All these registers information
  was gathered from references being the vendor gpl driver and 8180
  datasheet, unfortunately there is no information about this on 8187B
  datasheet. Also the ack timeout value was inspired by the same
  calculation as done on rt2x00.
-----------------


      
