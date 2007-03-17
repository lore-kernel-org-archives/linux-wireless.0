Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:44149 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965527AbXCQLHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 07:07:54 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 32B7D8D758
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 12:07:52 +0100 (CET)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 4888CFBF0
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 11:07:53 +0000 (UTC)
Message-Id: <20070317105800.659633351@warmcat.com>
Date: Sat, 17 Mar 2007 10:58:00 +0000
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Radiotap on Monitor Mode interfaces for rx and tx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

This pair of patches change the Monitor Mode wireless interfaces to use radiotap
both for monitoring and for packet injection.  The monitoring side is done by a patch
from Michael Wu.  Tcpdump knows how to handle the result.

For injecting packets, the you issue a packet using libpcap or a SOCK_PACKET
socket down an interface to the wireless device that is in Monitor Mode.  The packet
has a normal radiotap header prepended to the IEEE80211 header.  The radiotap header
is variable length depending on what the user wants to specify, currently the
transmit rate, power and antenna can be specified using normal radiotap semantics.
Any other entries are skipped.

A usermode app packetspammer is available from here

http://penumbra.warmcat.com/_twk/tiki-index.php?page=packetspammer

which allows easy injection of these packets from the commandline.  At the moment it
loops issuing packets at a variety of rates which can be seen from another
machine's monitor mode interface on the same channel.  There are instructions for
build and using it on the page above.

Currently it has been tested for both rx and tx using zd1211rw-mac80211 and works
except for 1Mbps TX (54Mbps - 2Mbps works) and the rx radiotap rate is not shown in
tcpdump.

The patches should be based against wireless-dev.

-- 
