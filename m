Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63929 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZINT5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 15:57:22 -0400
Received: by fxm17 with SMTP id 17so1104487fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:57:24 -0700 (PDT)
Subject: Re: [PATCH3]Add analog switch support
From: Thomas Ilnseher <illth@gmx.de>
To: John Linville <linville@tuxdriver.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910909141243i5551c87bsfd0c9e767cfa254@mail.gmail.com>
References: <1252956934.4696.23.camel@luzifer.localnet>
	 <69e28c910909141243i5551c87bsfd0c9e767cfa254@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 21:56:23 +0200
Message-Id: <1252958183.4696.25.camel@luzifer.localnet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mo, 2009-09-14 at 21:43 +0200, Gábor Stefanik wrote:
> Always send patches to John Linville, and CC linux-wireless.
Ok, the last try ...

As I've seen Gàbor's patch, I noticed that my previous patch was
bullshit. This patch should work:

(see: http://bcm-v4.sipsolutions.net/802.11/PHY/Anacore)

Signed-off-by: Thomas Ilnseher <illth@gmx.de>

diff -uNr b/drivers/net/wireless/b43/phy_lp.c
a/drivers/net/wireless/b43/phy_lp.c
--- b/drivers/net/wireless/b43/phy_lp.c 2009-09-14 06:14:18.000000000
+0200
+++ a/drivers/net/wireless/b43/phy_lp.c 2009-09-14 21:03:15.158507573
+0200
@@ -2228,6 +2228,16 @@
        return B43_TXPWR_RES_DONE;
 }
 
+void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
+{
+       if (on) {
+               b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xfff8);
+       } else {
+               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x0007);
+               b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x0007);
+       }
+}
+
 const struct b43_phy_operations b43_phyops_lp = {
        .allocate               = b43_lpphy_op_allocate,
        .free                   = b43_lpphy_op_free,
@@ -2239,7 +2249,7 @@
        .radio_read             = b43_lpphy_op_radio_read,
        .radio_write            = b43_lpphy_op_radio_write,
        .software_rfkill        = b43_lpphy_op_software_rfkill,
-       .switch_analog          = b43_phyop_switch_analog_generic,
+       .switch_analog          = b43_lpphy_op_switch_analog,
        .switch_channel         = b43_lpphy_op_switch_channel,
        .get_default_chan       = b43_lpphy_op_get_default_chan,
        .set_rx_antenna         = b43_lpphy_op_set_rx_antenna,



