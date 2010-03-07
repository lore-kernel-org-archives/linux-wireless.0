Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35438 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0CGXpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 18:45:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NoQ9f-0005l5-Q2
	for linux-wireless@vger.kernel.org; Mon, 08 Mar 2010 00:45:04 +0100
Received: from 56-98.dial.nortenet.pt ([212.13.56.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 00:45:03 +0100
Received: from subscriptions by 56-98.dial.nortenet.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 00:45:03 +0100
To: linux-wireless@vger.kernel.org
From: doddel <subscriptions@stroomer.com>
Subject: ath9k: ar9220 does rx but no tx on antenna B
Date: Sun, 7 Mar 2010 23:38:53 +0000 (UTC)
Message-ID: <loom.20100308T002346-575@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in experimenting with writing antenna control for ath9k from user nl80211 user
space found experimentally, verified with several R52n miniPCI ar9220 boards,
that the current ath9k does not transmit on antenna B but does receive. Only on
antenna A association/authentication and communication is possible.
Have tried all sorts of settings for registers $8004 (AR_STA_ID1) masks
200000/40000/80000/400000 and $8058 (default antenna) and enabling/disabling
ccmp and cck diversity but cannot get antenna B to transmit.
What is the proper way to switch between 
1) mimo 80211.n operation and 
2) single antenna no-diversity operation, or
3) sectored operation giving all available antennas some airtime and beacons and
answering on basis of best reception results ? 
As said current ath9k seems not to initialize the ar9220 properly for mimo mode
on the R52n board that has two PAs but now only can use one.

