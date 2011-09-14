Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53288 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab1INVvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 17:51:00 -0400
Received: by ywb5 with SMTP id 5so1788623ywb.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 14:51:00 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Big-endian fixes for rt2800usb
Date: Wed, 14 Sep 2011 16:50:21 -0500
Message-Id: <1316037024-17340-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110914_235112_399258_D9FE8158)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches are needed to fix rt2800usb to work on my Powerbook G4
Titanium. The first one is not an error in the rt2x00 code, but a
work-around for a compiler error in gcc 4.4.5 for the PowerPC. The second
patch fixes the internal storage of the eeprom contents.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I'm not sure what should be done with number 1. Should these kind of
compiler work-arounds be a prt of the kernel? AFAIK, this bug was not
in the x86 or x86_64 versions of gcc. On the chance that you think it
should be in 3.1, I have marked it to be sent to stable.

Patch number 2 should be applied to 3.1 and backported to stable.

Larry
---

Larry Finger (2):
  rt2800pci: Fix compiler error on PowerPC
  rtl2800usb: Fix incorrect storage of MAC address on big-endian
    platforms

 drivers/net/wireless/rt2x00/rt2800lib.c |   47 +++++++++++++++++--------------
 1 files changed, 26 insertions(+), 21 deletions(-)

-- 
1.7.6.1

