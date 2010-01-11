Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42968 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752382Ab0AKOyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 09:54:23 -0500
Date: Mon, 11 Jan 2010 09:54:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Gertjan van Wingerde <gwingerde@gmail.com>
cc: linux-wireless@vger.kernel.org, <netdev@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: REGRESSION for RT2561/RT61 in 2.6.33
In-Reply-To: <4B201D67.8000607@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1001110947350.2873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan:

Sorry to bother you again, but I have run across a new bug affecting
my rt2561s card.  It appeared in 2.6.33-rc1 and is still present in 
-rc3.  (This is with CONFIG_CFG80211_DEFAULT_PS disabled, not that it 
should make any difference now.)

The card doesn't work.  Although the firmware load appears to
succeed, "iwconfig wlan0" says no wireless extensions present.

The only clue I can offer is that "rmmod rt61pci" hangs in 
wiphy_unregister() during the wait_event() loop near the start, because 
rdev->opencount is equal to -1.  This suggests a refcounting imbalance 
of some sort.

Alan Stern

