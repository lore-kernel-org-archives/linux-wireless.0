Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1DRNgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:05 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/23] rt2x00: Always inline rt2x00pci_enable_interrupt
Date: Mon, 18 Apr 2011 15:31:31 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181530.37227.IvDoorn@gmail.com> <201104181531.03375.IvDoorn@gmail.com>
In-Reply-To: <201104181531.03375.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181531.32313.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This allows the compiler to perform the necessary bitfield calculations
during compile time instead of run time and thus reduces the number of
instructions to run during each tasklet invocation. This should improve
performance in the RX hotpath.

This comes at the cost of a slight increase in the module size (for
example rt2800pci):

Before:
   text    data     bss     dec     hex filename
  14133     832       4   14969    3a79 drivers/net/wireless/rt2x00/rt2800pci.ko

After:
   text    data     bss     dec     hex filename
  14149     832       4   14985    3a89 drivers/net/wireless/rt2x00/rt2800pci.ko

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6b7206e..01e9517 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1314,8 +1314,8 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static void rt2400pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-				       struct rt2x00_field32 irq_field)
+static inline void rt2400pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+					      struct rt2x00_field32 irq_field)
 {
 	u32 reg;
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 82e8012..c8deeeb 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1446,8 +1446,8 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static void rt2500pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-				       struct rt2x00_field32 irq_field)
+static inline void rt2500pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+					      struct rt2x00_field32 irq_field)
 {
 	u32 reg;
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index d2fe5fd..46c3e3c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -768,8 +768,8 @@ static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 	return !max_tx_done;
 }
 
-static void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-				       struct rt2x00_field32 irq_field)
+static inline void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+					      struct rt2x00_field32 irq_field)
 {
 	u32 reg;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 35c5d20..264508f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2260,8 +2260,8 @@ static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static void rt61pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-				     struct rt2x00_field32 irq_field)
+static inline void rt61pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+					    struct rt2x00_field32 irq_field)
 {
 	u32 reg;
 
-- 
1.7.2.3

