Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:45147 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYCLK5A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 06:57:00 -0400
Date: Wed, 12 Mar 2008 19:57:48 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PS3: gelic: change the prefix of the net interface for wireless
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kay.sievers@vrfy.org,
	sassmann@suse.de, Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <Pine.LNX.4.64.0803121125150.15905@vixen.sonytel.be>
References: <20080312162152.0B14.40F06B3A@sm.sony.co.jp> <Pine.LNX.4.64.0803121125150.15905@vixen.sonytel.be>
Message-Id: <20080312194039.255F.40F06B3A@sm.sony.co.jp> (sfid-20080312_105709_760474_2DBC1EAE)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 12 Mar 2008 11:26:54 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> On Wed, 12 Mar 2008, Masakazu Mokuno wrote:
> > The gelic driver uses two net interfaces, one for ethernet and the
> > other for wireless. They share same MAC address and use 'eth' prefix
> > for the name.
> > As udev uses the MAC address to check uniqueness, this is
> > somewhat problematic.  So change the prefix of the network interface
> > name for the wireless so that udev can have an easy way to distinguish
> > interfaces.
> 
> Now my PS3 has `eth0' and `wlan0_rename'.
> I assume we still need changes to udev?

The patch just gives a clue to write nicer rule in udev.
My previous fix for this issue was to add an exception to udev like:

--- 75-persistent-net-generator.rules.orig	2008-03-04 14:17:07.000000000 +0900
+++ 75-persistent-net-generator.rules	2008-03-04 14:03:23.000000000 +0900
@@ -23,6 +23,9 @@
 # ignore Xen virtual interfaces
 SUBSYSTEMS=="xen", GOTO="persistent_net_generator_end"
 
+# ignore PS3 gelic interfaces; they share a mac address
+DRIVERS=="ps3_gelic_driver", GOTO="persistent_net_generator_end"
+
 # read MAC address
 ENV{MATCHADDR}="$attr{address}"
 
But Kay Sievers <kay.seivers@vrfy.org> told that he could add a nicer
rule if the wireless interface has the distinct prefix like 'wlan'.  So
I made this patch.

-- 
Masakazu MOKUNO

