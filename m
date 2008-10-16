Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37429 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYJPXkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:40:03 -0400
Message-ID: <48F7D0D2.6090604@lwfinger.net> (sfid-20081017_014007_913218_B532EE70)
Date: Thu, 16 Oct 2008 16:40:02 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>, Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Warning from mac80211 with p54usb
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

Many thanks for the renaming of the firmware for p54usb. With this change, I can
keep an old version of the firmware (2.5.8.0.arm) named isl3887usb_bare and a
new one (2.13.1.0.arm.1) named isl3887usb in /lib/firmware and run the trees
from Linus and wireless-testing without messing with the firmware.

I have discovered one anomaly that shows up with firmware 2.5.8.0.arm. If the
USB device is unplugged and replugged, mac80211 will log the warning from
net/mac80211/main.c:234 because p54_config() returns an error. The source of the
error is p54_assign_address(), where target_skb is NULL. That happens because
priv->rx_end - last_addr is 32 whereas the value of len is 160 - thus target_skb
never gets set.

I have not seen this problem with firmware 2.13.1.arm.1, nor does it occur if
the driver is removed before the USB device is replugged.

If you have any suggestions regarding debugging, please let me know.

Larry

