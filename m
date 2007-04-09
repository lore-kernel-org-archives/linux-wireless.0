Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45537 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965915AbXDIPxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 11:53:37 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id CA5A78CAE9
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2007 17:53:30 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 74133FCDA
	for <linux-wireless@vger.kernel.org>; Mon,  9 Apr 2007 15:53:44 +0000 (UTC)
Message-Id: <20070409154802.470925215@warmcat.com>
Date: Mon, 09 Apr 2007 16:48:02 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] Try #8: Radiotap on Monitor Mode interfaces for rx and tx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

This set of patches change the Monitor Mode wireless interfaces to use radiotap
both for monitoring and for packet injection.  The monitoring side is done by a patch
from Michael Wu.  For example, tcpdump can handle the resulting radiotap packets.

For injecting packets, you issue a packet using libpcap or a SOCK_PACKET
socket down an interface to the wireless device that is in Monitor Mode.  
The packet has a normal radiotap header prepended to the IEEE80211 header.
The radiotap header is variable length depending on what the user wants to 
specify: currently the transmit rate, power and antenna are interpreted,
and any other entries are skipped.

The radiotap parser is broken out into its own file under cfg80211.

A usermode app packetspammer is available from here

http://penumbra.warmcat.com/_twk/tiki-index.php?page=packetspammer

which allows easy injection of these packets from the commandline.  At the moment it
loops issuing packets at a variety of rates which can be seen from another
machine's monitor mode interface on the same channel.  There are instructions for
build and using it on the page above.

Currently it has been tested for both rx and tx using zd1211rw-mac80211.

The patches are based against this morning's wireless-dev.

I also added some documentation files which explains how to use the injection
functionality and radiotap header notes.

I have used the radiotap include patch from Michael Wu which basically syncs 
wireless-dev with the one in wireless-2.6, and his latest radiotap rx patch.

Michael Wu's rx patch exposed an issue with zd1211rw-mac80211 using its
hardware-dependent rx rate coding which differs from the coding used to
specify tx rates.  I therefore added a small broken-out patch in this set
which converts the reported rx rate from zd1211rw-mac80211 to use the
corresponding tx rate coding, so mac80211 can use the reported rate with
its rate tables (which use the hardware-specific tx rate coding) to find
the absolute bitrate and report that via radiotap.

-- 
