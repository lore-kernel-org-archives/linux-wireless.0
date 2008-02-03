Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:42008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763481AbYBCOvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:50 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1586229fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:49 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/19] rt2x00: Add per-interface structure
Date: Sun, 3 Feb 2008 15:49:59 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031549.59280.IvDoorn@gmail.com> (sfid-20080203_145152_487057_D727E6E5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the interface handling. Delete the interface structure
and replace it with a per-interface structure. This changes the
way rt2x00 handles the active interface drastically.

Copy ieee80211_bss_conf to the this rt2x00_intf structure during
the bss_info_changed() callback function. This will allow us to
reference it later, and removes the requirement for the device flag
SHORT_PREAMBLE flag which is interface specific.

Drivers receive the option to give the maximum number of virtual
interfaces the device can handle. Virtual interface support:
rt2400pci: 1 sta or 1 ap, * monitor interfaces
rt2500pci: 1 sta or 1 ap, * monitor interfaces
rt2500usb: 1 sta or 1 ap, * monitor interfaces
rt61pci: 1 sta or 4 ap, * monitor interfaces
rt73usb: 1 sta or 4 ap, * monitor interfaces

At the moment none of the drivers support AP and STA interfaces
simultaneously, this is a hardware limitation so future support
will be very unlikely.

Each interface structure receives its dedicated beacon entry,
with this we can easily work with beaconing while multiple master
mode interfaces are currently active.

The configuration handlers for the MAC, BSSID and type are
often called together since they all belong to the interface
configuration. Merge the 3 configuration calls and cleanup
the API between rt2x00lib and the drivers. While we are cleaning
up the interface configuration anyway, we might as well clean up
the configuration handler as well.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

Patch size 77k, located on server
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.1.0/0008-rt2x00-Add-per-interface-structure.patch

 drivers/net/wireless/rt2x00/rt2400pci.c    |   84 ++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c    |   98 +++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c    |  207 ++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2500usb.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h       |  113 +++++++++++----
 drivers/net/wireless/rt2x00/rt2x00config.c |  119 ++++++++++-------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  154 +++++++++++++++------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |  152 ++++++++++++++-------
 drivers/net/wireless/rt2x00/rt2x00pci.c    |   32 +++--
 drivers/net/wireless/rt2x00/rt2x00queue.h  |    3 -
 drivers/net/wireless/rt2x00/rt61pci.c      |  169 +++++++++++++----------
 drivers/net/wireless/rt2x00/rt61pci.h      |   18 ++-
 drivers/net/wireless/rt2x00/rt73usb.c      |  179 +++++++++++++-----------
 drivers/net/wireless/rt2x00/rt73usb.h      |   17 ++-
 15 files changed, 826 insertions(+), 530 deletions(-)
