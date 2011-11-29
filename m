Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46365 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1K2OpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:45:10 -0500
Received: by faaq16 with SMTP id q16so261495faa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 06:45:09 -0800 (PST)
From: Florian Fainelli <florian@openwrt.org>
To: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net
Subject: zd1211rw firmware loading timeout
Date: Tue, 29 Nov 2011 15:44:27 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201111291544.28692.florian@openwrt.org> (sfid-20111129_154521_174491_97F4F74D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am running Debian testing kernel 3.1.0-1-amd64, using a 079b:0062 Sagem 
XG-76NA 802.11bg stick.

Upon zd1211rw interface 
bringup (ifconfig wlan0 up) I get the following timeout:

[  950.330573] zd1211rw 1-3:1.0: phy2
[  955.108510] zd1211rw 1-3:1.0: firmware version 4725
[  955.148532] zd1211rw 1-3:1.0: zd1211b chip 079b:0062 v4810 high 00-19-70 
AL2230_RF pa0 g--NS
[snip]
[  955.204072] zd1211rw 1-3:1.0: error ioread32(CR_REG1): -110

A second ifconfig wlan0 up brings the interface up without problems.

After a bit more debugging, the call trace is the following:

[10241.028130] zd1211rw 1-3:1.0: zd_chip_lock_phy_regs: error 
ioread32(CR_REG1): -110
[10241.028140] zd1211rw 1-3:1.0: zd_switch_radio_on: failed to lock PHY regs
[10241.028148] zd1211rw 1-3:1.0: zd_op_start: failed to set radio on

The following small modification works around the issue:

diff --git a/zd_mac.c b/zd_mac.c
index cabfae1..6bfb673 100644
--- a/zd_mac.c
+++ b/zd_mac.c
@@ -306,9 +306,14 @@ int zd_op_start(struct ieee80211_hw *hw)
        r = set_mc_hash(mac);
        if (r)
                goto disable_int;
+
+       msleep(10);
+
        r = zd_chip_switch_radio_on(chip);
-       if (r < 0)
+       if (r < 0) {
+               dev_err(zd_chip_dev(chip), "%s: failed to set radio on\n", 
__func__);
                goto disable_int;
+       }
        r = zd_chip_enable_rxtx(chip);
        if (r < 0)
                goto disable_radio;

Is it possible that some chips require more time between a set_mc_hash and a 
radio on? Or in general that consequent writes to the PHY regs should be timed 
appropriately?

When I googled for this timeout issue, I could see quite some reports of other 
people having this error while the chip was already operating.

Thanks
-- 
Florian
