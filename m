Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:53221 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763062AbZFKW7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 18:59:41 -0400
Received: by an-out-0708.google.com with SMTP id d40so3443554and.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 15:59:43 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 15:59:23 -0700
Message-ID: <43e72e890906111559p614e83fdnec245fb806e01fc3@mail.gmail.com>
Subject: rfkill on T61
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I hit rfkill, I get:

[18493.777231] btusb_intr_complete: hci0 urb cbe20000 failed to resubmit (19)
[18493.777553] btusb_send_frame: hci0 urb f7d3c700 submission failed

When I hit it again I get:

[18531.488091] usb 1-1: new full speed USB device using uhci_hcd and address 7
[18531.651409] usb 1-1: configuration #1 chosen from 1 choice

The device that disappears upon rfkill is my bluetooth controller:

mcgrof@tesla ~ $ diff -u before-rfkill after-rfkill
--- 1   2009-06-11 15:37:37.000000000 -0700
+++ 2   2009-06-11 15:37:49.000000000 -0700
@@ -6,7 +6,6 @@
 Bus 003 Device 004: ID 046d:c040 Logitech, Inc. Corded Tilt-Wheel Mouse
 Bus 003 Device 003: ID 04b3:4485 IBM Corp.
 Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
-Bus 001 Device 006: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
 Bus 001 Device 004: ID 0483:2016 SGS Thomson Microelectronics
Fingerprint Reader
 Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
 Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Granted I tested this on 2.6.27 with bleeding edge compat-wireless but
I think this is the same behaviour I will get with bleeding edge, will
try now on wireless-testing.

  Luis
