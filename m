Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43482 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbXC2Nko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 09:40:44 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id C3CCF8CB14
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 15:40:38 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 02A32100CC
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 13:41:01 +0000 (UTC)
Message-Id: <20070329133814.841581235@warmcat.com>
Date: Thu, 29 Mar 2007 14:38:14 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] Try #6: Radiotap on Monitor Mode interfaces for rx and tx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

This set of patches change the Monitor Mode wireless interfaces to use radiotap
both for monitoring and for packet injection.  The monitoring side is done by a patch
from Michael Wu.  Tcpdump knows how to handle the result.

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

The patches should be based against yesterday's wireless-dev.

I also added some documentation files which explains how to use the injection
functionality and radiotap header notes.
-- 
