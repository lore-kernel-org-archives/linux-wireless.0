Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:58984 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZLNTkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 14:40:04 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>, stable@kernel.org
Subject: [PATCH v2 2.6.33] rt2x00: Disable powersaving for rt61pci and rt2800pci.
Date: Mon, 14 Dec 2009 20:33:55 +0100
Message-Id: <1260819235-8017-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've had many reports of rt61pci failures with powersaving enabled.
Therefore, as a stop-gap measure, disable powersaving of the rt61pci
until we have found a proper solution.
Also disable powersaving on rt2800pci as it most probably will show
the same problem.

Cc: stable@kernel.org
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---

John, this is an urgent fix for 2.6.33.

v2:
- Handled feedback from Ivo:
	- Only disable powersaving by default, not permanent.
	- Also apply to rt2800pci.

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6e13650..fa197ac 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2022,6 +2022,12 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	u16 eeprom;
 
 	/*
+	 * Disable powersaving as default on PCI devices.
+	 */
+	if (rt2x00_intf_is_pci(rt2x00dev))
+		rt2x00dev->hw->wiphy->ps_default = false;
+
+	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 687e17d..9440a4d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2539,6 +2539,11 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	/*
+	 * Disable powersaving as default.
+	 */
+	rt2x00dev->hw->wiphy->ps_default = false;
+
+	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-- 
1.6.5.5

