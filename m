Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:51892 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbXFLNFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 09:05:05 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 941698D763
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 15:05:00 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 03E28104A3
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 13:05:26 +0000 (UTC)
Message-Id: <20070612130435.896010304@warmcat.com>
Date: Tue, 12 Jun 2007 14:04:35 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH Try#11 0/4] Radiotap injection for Monitor Mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add the ability to inject packets down a monitor mode interface for 
transmission according to a prepended radiotap header.

For injecting packets, the you issue a packet using libpcap or a SOCK_PACKET
socket down an interface to the wireless device that is in Monitor Mode.  The packet
has a normal radiotap header prepended to the IEEE80211 header.  The radiotap header
is variable length depending on what the user wants to specify, currently the
transmit rate, power and antenna can be specified using normal radiotap semantics.
Any other entries are skipped.

The radiotap parser is broken out into its own file under cfg80211.

A usermode app packetspammer is available from here

http://penumbra.warmcat.com/_twk/tiki-index.php?page=packetspammer

which allows easy injection of these packets from the commandline.  At the moment it
loops issuing packets at a variety of rates which can be seen from another
machine's monitor mode interface on the same channel.  There are instructions for
build and using it on the page above.

Currently it has been tested for both rx and tx using zd1211rw-mac80211.

The patches are based against current wireless-dev.

I also added some documentation files which explains how to use the injection
functionality and radiotap header notes.
-- 
