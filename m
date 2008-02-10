Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:47305 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYBJPKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:37 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 00/12] at76_usb mac80211 port
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 16:59:49 +0200
Message-ID: <20080210145733.17592.61729.stgit@tikku> (sfid-20080210_151042_562062_4F51E716)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a patch series of my at76_usb mac80211 port. I'm sending them now 
for comments. Currently open mode and WEP authentication are supported.

The patches have received very little testing, so please be careful when
trying these. Also some features, comparated to the original driver, are 
missing. I will implement the missing features later.

I have checked all patches with checkpatch.pl and sparse. gcc warns
about three unused functions, but I plan to use them with the debugfs
interface in the future.

Thanks to Pavel Roskin for giving me guidance on the port.

---

Kalle Valo (11):
      Remove struct net_device
      Prepare for struct net_device removal
      Allocate struct at76_priv using ieee80211_alloc_hw()
      Use wiphy_name everywhere where needed
      Remove support the legacy stack
      Add support for WEP
      Add support for monitor mode
      at76_usb: add mac80211 support
      Add DBG_CMD for debugging firmware commands
      Convert DBG_TX levels to use at76_dbg_dump()
      Add at76_dbg_dump() macro

Pavel Roskin (1):
      Use net/mac80211.h instead of net/ieee80211.h


 drivers/net/wireless/at76_usb.c | 4149 +++++----------------------------------
 drivers/net/wireless/at76_usb.h |  172 --
 2 files changed, 585 insertions(+), 3736 deletions(-)

