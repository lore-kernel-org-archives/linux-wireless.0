Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:40071 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZBGH1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 02:27:08 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 582C9C7EEE
	for <linux-wireless@vger.kernel.org>; Sat,  7 Feb 2009 09:27:05 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 491261C6389
	for <linux-wireless@vger.kernel.org>; Sat,  7 Feb 2009 09:27:04 +0200 (EET)
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] at76c50x-usb: mac80211 port of at76_usb
To: linux-wireless@vger.kernel.org
Date: Sat, 07 Feb 2009 09:27:04 +0200
Message-ID: <20090207071701.21485.18763.stgit@tikku> (sfid-20090207_082714_081757_BD19D0EE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's the first version of at76c50x-usb which is a mac80211 port from
at76_usb, which included own 802.11 stack. The driver has received almost
no testing, I just associated few to times to an AP using WEP and iwconfig. 

My quick test showed problems already, for example sometimes I had to
set essid twice before the driver associated. And I'm sure there are also
loads of other issues. Patches welcome :)

The driver is based on at76_usb mac80211 patches[1] plus some cosmetic 
changes to reflect the name change. Also I dropped the wpa patches for now
due to stability issues. I'll readd wpa support after the driver is stable
enough.

John, please consider this driver as inclusion to the linux-testing tree. I
don't consider this ready for mainline yet, I want to test this more first in
case there are critical bugs.

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-legacy.git;a=shortlog;h=at76

---

Kalle Valo (1):
      at76c50x-usb: add driver


 drivers/net/wireless/Kconfig        |    8 
 drivers/net/wireless/Makefile       |    2 
 drivers/net/wireless/at76c50x-usb.c | 2465 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/at76c50x-usb.h |  463 +++++++
 4 files changed, 2938 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/at76c50x-usb.c
 create mode 100644 drivers/net/wireless/at76c50x-usb.h

