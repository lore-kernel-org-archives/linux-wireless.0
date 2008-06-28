Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:35128 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYF1Sid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:38:33 -0400
Received: by ug-out-1314.google.com with SMTP id h2so100787ugf.16
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:38:31 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 00/19] orinoco: WPA for Agere based cards
Date: Sat, 28 Jun 2008 19:38:06 +0100
Message-Id: <1214678305-7057-1-git-send-email-kilroyd@gmail.com> (sfid-20080628_203904_468748_CC615C3A)
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series enables WPA on Agere based orinoco devices. An
earlier version has been available on the orinoco-devel list for a
while. I'm looking to get more feedback and testing of these patches,
so hopefully they can go into the kernel.

Patchset overview
1-2: General scanning updates
3-9: Agere firmware download to RAM
10-12: Update orinoco to work with new firmware
13-19: WPA functionality

This patchset is against wireless-testing (master-2008-06-27), is
sparse clean (UP), and should be bisectable. It is almost checkpatch
clean - the single warning looks like a false positive to me.

To test the Agere firmware download, you will need an Agere firmware
image. You can get the necessary file at
<http://marc.info/?l=orinoco-devel&m=121078835610877>, just extract
and rename orinoco.fw to agere_sta_fw.bin and place it in
/lib/firmware (or distro equivalent). Alternatively you can try
extract firmware from a Windows driver using the program in
<http://marc.info/?l=orinoco-devel&m=120846933719051>.

A brief summary of testing results is appended below.


Regards,

Dave.
---
Good results (wpa-supplicant 0.5.7, Agere fw 9.48, kernel 2.6.24):
 - WPA-PSK managed mode now works.
 - WEP managed mode still working.

Issues that have been identified with earlier versions of the
patchset (and haven't been explicitly addressed):

 - Scan results don't appear correct on a 64-bit machine (no further
   debug info). Might David Millers compat changes affect this? I'm
   not too sure what they're about...
 - Driver only reads the first 200 bytes of IEs in probe results.
 - Driver resets in monitor mode with 9.48 fw (after which monitor
   mode appears stable). Note that with the existing driver monitor
   mode with Agere fw is non-functional for fw above 6.16.

Areas of concern:

Firmware download for Symbol firmwares and non pcmcia cards. The image
that gets downloaded is selected based on the detected firmware on the
card, and the version of that firmware.

 - Firmware will not be downloaded to cards with Intersil firmware.

 - The latest Agere firmware will be downloaded to cards with Agere
   firmware.

 - Before these patches Symbol firmware was unconditionally downloaded
   to cards that use the spectrum_cs driver - after this patch the
   latest (v3.x.x) Symbol firmware is downloaded to cards with Symbol
   firmware greater than v3.0.0. This is an attempt to avoid
   downloading the v3.x.x Symbol firmware to Symbol cards that use
   orinoco_cs. I don't know if there are spectrum_cs cards with
   earlier firmware which are supposed to run the v3.x.x firmware.
