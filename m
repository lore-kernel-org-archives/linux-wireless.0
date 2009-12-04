Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:59570 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZLDXb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 18:31:59 -0500
Date: Sat, 5 Dec 2009 00:32:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: rjw@sisk.pl, IvDoorn@gmail.com, gwingerde@gmail.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: regression: rt2561 frequent "Arrived at non-free entry" errors in
	2.6.32
Message-ID: <20091204233202.GA13658@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Rafael, something for your regression list]

I upgraded a system which was running 2.6.30 to 2.6.32.
It has a 

06:02.0 Network controller: RaLink RT2561/RT61 802.11g PCI

wireless PCI card. Now regularly even under moderate traffic
I see messages like

phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.

and loss of connectivity, often until the wireless connection
is restarted. This wasn't the case in 2.6.30, there the driver
ran stable without any problems. The problem currently
happens every few minutes.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
