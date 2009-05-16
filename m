Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47372 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZEPMJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:09:51 -0400
Received: by ewy24 with SMTP id 24so3051294ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 05:09:50 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 0/3] orinoco: initiate cfg80211 conversion
Date: Sat, 16 May 2009 13:22:54 +0100
Message-Id: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interesting bit of this series is in patch 3, which shamelessly
cribs from Johns rndis_wlan conversion.

I'm interested in hearing if there's a better way to organise the
wiphy/wdev/net_device/orinoco_private structures for orinoco. Also
whether I'm registering with netdev and cfg80211 in the right places.

The driver appears to runs fine. iw list shows the card on phy0. iwconfig
still gets 'IEEE802.11b' for GIWNAME. However the device is still eth1 -
is that expected?

The first two patches are only there because I started marking things
const, and found a couple cfg80211 interfaces wouldn't let me. I couldn't
see anything in the code that needs to modify ops and privid, so I've
marked them const. A build coverring (almost?) all drivers still works,
and I couldn't see any extra sparse complaints. Anyway, I've no particular
attachment to these two patches, so dropping them is fine by me.


Regards,

Dave.
---

David Kilroy (3):
  cfg80211: mark ops as pointer to const
  cfg80211: mark wiphy->privid as pointer to const
  orinoco: initiate cfg80211 conversion

 drivers/net/wireless/orinoco/Kconfig   |    1 +
 drivers/net/wireless/orinoco/Makefile  |    2 +-
 drivers/net/wireless/orinoco/cfg.c     |   82 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/cfg.h     |   18 +++++++
 drivers/net/wireless/orinoco/main.c    |   28 ++++++++++-
 drivers/net/wireless/orinoco/orinoco.h |    7 +++
 drivers/net/wireless/orinoco/wext.c    |   22 +--------
 include/net/cfg80211.h                 |    4 +-
 net/wireless/core.c                    |    2 +-
 net/wireless/core.h                    |    2 +-
 10 files changed, 142 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/cfg.c
 create mode 100644 drivers/net/wireless/orinoco/cfg.h

