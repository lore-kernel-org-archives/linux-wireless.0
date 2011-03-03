Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1CCStS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:49:18 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so1738699wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:49:18 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/19] rt2x00: Optimize getting the beacon queue structure.
Date: Thu, 3 Mar 2011 19:46:55 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031946.09972.IvDoorn@gmail.com> <201103031946.30487.IvDoorn@gmail.com>
In-Reply-To: <201103031946.30487.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031946.56905.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

In the spirit of optimizing the code to get the queue structure of TX queues,
also optimize the code to get beacon queues. We can simply use the bcn queue
field of the rt2x00_dev structure instead of using the rt2x00queue_get_queue
function.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5cd6575..5827787 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -293,7 +293,7 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 				  struct rt2x00intf_conf *conf,
 				  const unsigned int flags)
 {
-	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, QID_BEACON);
+	struct data_queue *queue = rt2x00dev->bcn;
 	unsigned int bcn_preload;
 	u32 reg;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7f58767..e7210a2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -191,7 +191,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, QID_BEACON);
+	struct data_queue *queue = rt2x00dev->bcn;
 	struct queue_entry *entry = NULL;
 	unsigned int i;
 
-- 
1.7.2.3

