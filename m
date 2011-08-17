Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60582 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1HQCvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 22:51:50 -0400
Date: Tue, 16 Aug 2011 19:51:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-wireless@vger.kernel.org
Cc: Jamey Sharp <jamey@minilop.net>
Subject: EINVAL when setting 802.11a channel in Ad-Hoc mode
Message-ID: <20110817025141.GA4529@leaf> (sfid-20110817_045153_283507_FC25B957)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're trying to run 802.11a in Ad-Hoc mode.  However, when we get to the
point of setting the channel, we almost always get EINVAL back from the
kernel.  We ran the following series of commands:

wlan=wlan3
iwconfig $wlan mode Ad-Hoc
ifconfig $wlan up
iwconfig $wlan essid PSAS-flight-computer
iwconfig $wlan channel 36

The channel command almost always got back an EINVAL.  This occurred on
three different wifi chipsets: a USB ar9170 (with either carl9170 or the
older ar9170usb driver), a USB rt2800usb, and iwlwifi with a Lenovo
X220.  In the former two cases, it occurs on both x86 (the
aforementioned X220) and powerpc (an MPC5200).

More strangely, the channel command would *sometimes* successfully set
the channel without error.

Have we done something wrong with the sequence of commands above?  Why
might we get EINVAL when setting a valid channel?  What next steps
should we take to debug this?

Currently about to compile in function_graph tracing and start walking
through the execution of SIOCSIWFREQ looking for what generates the
EINVAL.

- Josh Triplett
