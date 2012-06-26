Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:54432 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab2FZWlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 18:41:03 -0400
Received: from [72.40.65.195] (helo=192.168.1.10)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <marco@tampabay.rr.com>)
	id 1SjeD9-0002qN-5W
	for linux-wireless@vger.kernel.org; Tue, 26 Jun 2012 18:26:15 -0400
Date: Tue, 26 Jun 2012 18:26:52 -0400
From: marco <marco@tampabay.rr.com>
To: linux-wireless@vger.kernel.org
Subject: carl9170 - single packet injection causes 3 packets to be sent.
Message-ID: <20120626222652.GA11880@192.168.1.10> (sfid-20120627_004114_019977_DC5446F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I noticed a problem with packet injection on the carl9170.  When I inject a
packet, I see 3 packets go out.  I see them with a secondary sniffer on a
different PC.  One interesting thing is, if the packet has a broadcast DA mac,
only one packet is injected (as I would expect).  I poked around in the
carl9170 driver a little, and it *appears* that it is only sending the single
packet across the usb stick, so I'm guessing the issue is with the
firmware/hardware (?).  The only other thing I can think of is perhaps a
radiotap header misconfiguration.  Is this a known problem or am I the only one
seeing such a thing?  I've seen it across a few driver/firmware revisions.

I'm running: 
[    8.310000] usb 1-1: driver   API: 1.9.4 2011-08-15 [1-1] 
[    8.310000] usb 1-1: firmware API: 1.9.4 2011-06-30

I'm currently running compat-wireless-2011-11-22 on a 2.6.37 kernel.

Thanks for any insight you can provide,

Marco Fonseca
