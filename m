Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 216-136-12-18.static.twtelecom.net ([216.136.12.18]:32039 "EHLO
	mail.sdicorporation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757520Ab0BLEMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 23:12:05 -0500
Message-ID: <4B74D511.3080508@sdicorporation.com>
Date: Thu, 11 Feb 2010 23:12:01 -0500
From: Olivier Singla <osingla@sdicorporation.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: ar9170 : firmware not loaded
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to use the ar9170 driver with the netgear wn111v2, on an 
arm9 platform.
I compiled the modules, and the driver loads fine:

Module                  Size  Used by
ar9170usb              51188  1
mac80211              170216  1 ar9170usb
ath                     7304  1 ar9170usb
cfg80211              120852  3 ar9170usb,mac80211,ath
rfkill_backport        15524  1 cfg80211
compat                  2336  2 mac80211,cfg80211
compat_firmware_class     7072  2 ar9170usb
pegasus                18052  0
ohci_hcd               18428  0
g_file_storage         21212  0
at91_udc               12696  1 g_file_storage

My issue is about the firmware, ar9170.fw. It is not found.
I tried w/o luck 2 options:
1) loaded from user space under /lib/firmware
2) build the kernel 2.6.29 with ar9170.fw.

With option (1), the only thing I see under /sys/class/firmware is the 
pseudo file timeout,
no filename for 60" (like I think it should).

Note that I have tried also an 802.11G adapter (iogear gwus23) with the 
very same issue.
But in this case, the 'old' kernel I am using for arm9 (2.6.29) has 
support for this 802.11g adapter,
and when I build it with 2.6.29 (therefore not using compat-wireless), I 
have no issue regarding
loading the firmware (from user-space).

If anybody had any idea what I am doing wrong or missing, I would really 
appreciate it!

Regards,
Olivier

