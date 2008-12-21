Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:57561 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYLUQMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 11:12:15 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: rtl8180: the network interface is not anymore created
Date: Sun, 21 Dec 2008 17:10:22 +0100
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812211710.23846.rossi.f@inwind.it> (sfid-20081221_171233_522862_DC8759A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was using successfully the rtl8180 driver but after last git-pull the 
network interface (wlan0) is not anymore created.

I have discovered the problem: there has been a change in mac80211, commit 
3fc7826b95521e40cf53f63437a5fdcc24e54ac4. The problem is that the bit 
NL80211_IFTYPE_STATION is not set during the hardware initialization.

I guess that the problem might be solved inserting the following line of code

    dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);

somewhere in rtl8180_dev.c but I don't know which is the right point to do so.

Regards,
Fabio
