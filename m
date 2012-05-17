Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:57559 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762396Ab2EQXEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 19:04:08 -0400
Date: Fri, 18 May 2012 01:04:01 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, helmut.schaa@googlemail.com,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org
Subject: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
Message-ID: <20120517230400.GB22418@yumi.tdiedrich.de> (sfid-20120518_010412_888516_120E33C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
respectively, similar to how it is already done in rt2[45]00pci.c

rt2800lib.c doesn't initialize max_power and thus after
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
was applied txpower is limited to 0 for these devices.

This should be the proper fix compared to the net/wireless/reg.c
hack in http://patchwork.openwrt.org/patch/2165/

(Patch against the OpenWRT compat-wireless version, but applies
equally well against wireless-next with a 19-line offset)

Signed-off-by: Tobias Diedrich <ranma+openwrt@tdiedrich.de>


Index: compat-wireless-2012-04-17/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- compat-wireless-2012-04-17.orig/drivers/net/wireless/rt2x00/rt2800lib.c	2012-05-18 00:25:22.515271380 +0200
+++ compat-wireless-2012-04-17/drivers/net/wireless/rt2x00/rt2800lib.c	2012-05-18 00:28:48.809658951 +0200
@@ -4622,6 +4622,7 @@
 	default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
 
 	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_G_TXPOWER;
 		info[i].default_power1 = default_power1[i];
 		info[i].default_power2 = default_power2[i];
 	}
@@ -4631,6 +4632,7 @@
 		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_A_TXPOWER;
 			info[i].default_power1 = default_power1[i];
 			info[i].default_power2 = default_power2[i];
 		}

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
