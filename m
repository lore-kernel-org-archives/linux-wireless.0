Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58373 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0EDVy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 17:54:59 -0400
Received: by wye20 with SMTP id 20so2797546wye.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 14:54:56 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, linville@tuxdriver.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: orinoco_usb: support wpa
Date: Tue,  4 May 2010 22:54:40 +0100
Message-Id: <1273010082-15871-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches enable WPA for the orinoco_usb cards. The first
patch contains all the code required to use WPA. The second patch
neatens things up but doesn't work so well, since it relies on having
spare tailroom in the SKB to store the MIC.

In order to use WPA with these cards, the following is required:
 * Agere firmware 9.42 or better (as with other orinoco cards)
 * compatible bridge firmware

The bridge firmware currently extracted by the orinoco-fwutils scripts
is not compatible with WPA. Instead you'll need to find the v7.82
Agere driver containing the WPA-enabled USB driver (containing the
appropriate bridge firmware and Agere fw 9.42). I'm not sure if there
is still a reliable source on the net. Further details about
extracting the firmware below.

John: 1st patch should be OK for w-t if there are no objections. I'm
expecting to redo or drop the second, depending on feedback.



Regards,

Dave.

The bridge firmware is in WLAGS51.SYS. The firmware will be 6976 bytes
long, starting with the bytes 0x02 0x10 at an offset around 0x028480.
I used the following command to extract it (you may need to modify
this if you get something different from what I have):

dd if=WLAGS51.SYS of=orinoco_ezusb_fw skip=10312 count=436 bs=16

---
David Kilroy (2):
  orinoco: refactor xmit path
  orinoco: use SKB tail for MIC

 drivers/net/wireless/orinoco/main.c        |  175 ++++++++++++++++------------
 drivers/net/wireless/orinoco/orinoco.h     |    5 +
 drivers/net/wireless/orinoco/orinoco_usb.c |   77 +++++--------
 3 files changed, 135 insertions(+), 122 deletions(-)

