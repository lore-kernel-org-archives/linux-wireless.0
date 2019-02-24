Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30858C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 11:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E279206B6
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 11:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfBXLnp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 06:43:45 -0500
Received: from shells.gnugeneration.com ([66.240.222.126]:45406 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfBXLnp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 06:43:45 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2019 06:43:44 EST
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 48A431A41326; Sun, 24 Feb 2019 03:34:03 -0800 (PST)
Date:   Sun, 24 Feb 2019 03:34:03 -0800
From:   Vito Caputo <vcaputo@pengaru.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
Cc:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [REGRESSION] v5.0-rc5 rtl8192cu breakage
Message-ID: <20190224113403.22lzj6cg7dzjfb6k@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Never seen this before v5.0-rc5, rc5 is the only v5.0 build I've booted
so far, if this is already fixed in a newer rc please let me know.

Just wanted to give a heads up since we're so close to v5.0:

WiFi stopped functioning abruptly, this appeared in dmesg:

[968853.940102] usb 2-1: USB disconnect, device number 2
[968853.949169] wlan3: deauthenticating from 0c:72:d9:27:17:57 by local choice (Reason: 3=DEAUTH_LEAVING)
[968853.949537] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! status:0xffffffed value=0x6954341e
[968853.949552] rtl_usb: reg 0x422, usbctrl_vendorreq TimeOut! status:0xffffffed value=0x8531114
[968853.949564] rtl_usb: reg 0x542, usbctrl_vendorreq TimeOut! status:0xffffffed value=0x34085e
[968853.949583] rtl_usb: reg 0x1cc, usbctrl_vendorreq TimeOut! status:0xffffffed value=0x2e
[968854.204153] usb 2-1: new high-speed USB device number 4 using ehci-pci
[968854.335901] usb 2-1: New USB device found, idVendor=7392, idProduct=7811, bcdDevice= 2.00
[968854.335910] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[968854.335916] usb 2-1: Product: 802.11n WLAN Adapter
[968854.335921] usb 2-1: Manufacturer: Realtek
[968854.335926] usb 2-1: SerialNumber: 00e04c000001
[968854.340632] rtl8192cu: Chip version 0x10
[968854.431999] rtl8192cu: Board Type 0
[968854.432614] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[968854.432723] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[968854.433043] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[968854.488906] rtl8192cu 2-1:1.0 wlan3: renamed from wlan0
[968854.507120] rtl8192cu: MAC auto ON okay!
[968854.548252] rtl8192cu: Tx queue select: 0x05
[968855.298268] rtl8192c_common: Polling FW ready fail! REG_MCUFWDL:0x00030006.
[968855.298274] rtl8192c_common: Firmware is not ready to run!

Unplugging the USB WiFi dongle and reinserting got everything back up and
working.  Only experienced this once so far and it took ~10 days to
happen, only just started using v5.0 so not much more information at
this time.

No reproducer at this time, I wasn't doing anything in particular.

Regards,
Vito Caputo
