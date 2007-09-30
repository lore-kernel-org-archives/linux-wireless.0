Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61847 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXI3Sil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:38:41 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 00/26] at76_usb: bring up to date
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:38:38 -0400
Message-ID: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series brings at76_usb up to date with the latest
development, which is version 0.17 plus a last minute patch that adds
another device ID.

Many changes stem from user feedback for version 0.16.  Other changes
are cleanups made while trying to convert the driver to mac80211 stack.

Accepting this series will make it possible to use wireless-2.6 as the
main repository for further development.
---

Pavel Roskin (26):
      at76_usb: Add ID for at76c503a based CNETUSB611
      at76_usb: Bump version to 0.17
      at76_usb: Use ETH_P_802_2 in monitor mode
      at76_usb: Be more verbose on startup
      at76_usb: Use dev_printk() where possible
      at76_usb: Remove incorrect firmware version check
      at76_usb: Revert to network device names starting with "wlan"
      at76_usb: Add ID for Corega Wireless LAN USB-11 mini and mini2
      at76_usb: Avoid dealing with milliseconds when possible, use jiffies
      at76_usb: Move some parts from at76_usb.h to at76_usb.c
      at76_usb: Remove unneeded memset() calls
      at76_usb: Clean reserved tx area for mgmt frames like it's done for data
      at76_usb: Make it clear that management frames are sent at 1Mbps
      at76_usb: Eliminate variables used only in at76_dbg()
      at76_usb: Use string precision to avoid line termination
      at76_usb: Stop worrying about line termination in ethtool info
      at76_usb: Rename tlv to ie for readability
      at76_usb: Remove commented out code for multicast support
      at76_usb: Eliminate err(), it's USB specific
      at76_usb: Integrate at76_set_monitor_mode() into at76_dwork_restart()
      at76_usb: Fix turning radio off
      at76_usb: No need to reserve 72 bytes in set_mib_buffer - we only need 6
      at76_usb: Don't clean priv->mib_buf, just clean data explicitly if needed
      at76_usb: Avoid dubious use of '\0'
      at76_usb: Fix some device names in the device table
      at76_usb: Use USB_DEVICE_DATA to improve readability of the device table


 drivers/net/wireless/at76_usb.c |  811 ++++++++++++++++++++-------------------
 drivers/net/wireless/at76_usb.h |   61 ---
 2 files changed, 416 insertions(+), 456 deletions(-)

-- 
Regards,
Pavel Roskin
