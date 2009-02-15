Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:47168 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZBOQn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:43:26 -0500
Received: by nf-out-0910.google.com with SMTP id d21so175401nfb.21
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 08:43:25 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Remove check for rf word 0
Date: Sun, 15 Feb 2009 17:42:48 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200902151742.01372.IvDoorn@gmail.com> <200902151742.30220.IvDoorn@gmail.com>
In-Reply-To: <200902151742.30220.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200902151742.48677.IvDoorn@gmail.com> (sfid-20090215_174332_696221_73EB1902)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only way rf_write() can be called with word 0 is
when the user sends the wrong word index through debugfs.
However the values which are send through debugfs are
validated using the RF_BASE and RF_SIZE macro values,
the most logical solution is to increase RF_BASE with 4
and decrease RF_SIZE with 4 (RF_SIZE has always been
1 word too big)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    3 ---
 drivers/net/wireless/rt2x00/rt2400pci.h |    4 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c |    3 ---
 drivers/net/wireless/rt2x00/rt2500pci.h |    4 ++--
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 ---
 drivers/net/wireless/rt2x00/rt2500usb.h |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    3 ---
 drivers/net/wireless/rt2x00/rt61pci.h   |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ---
 drivers/net/wireless/rt2x00/rt73usb.h   |    4 ++--
 10 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b084825..0f08773 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -114,9 +114,6 @@ static void rt2400pci_rf_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (!word)
-		return;
-
 	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 72ac31c..ec3b004 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -48,8 +48,8 @@
 #define EEPROM_SIZE			0x0100
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x0020
-#define RF_BASE				0x0000
-#define RF_SIZE				0x0010
+#define RF_BASE				0x0004
+#define RF_SIZE				0x000c
 
 /*
  * Number of TX queues.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index eb82860..276a823 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -114,9 +114,6 @@ static void rt2500pci_rf_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (!word)
-		return;
-
 	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 17a0c9c..ce2f065 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -59,8 +59,8 @@
 #define EEPROM_SIZE			0x0200
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x0040
-#define RF_BASE				0x0000
-#define RF_SIZE				0x0014
+#define RF_BASE				0x0004
+#define RF_SIZE				0x0010
 
 /*
  * Number of TX queues.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 270691a..ca28067 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -204,9 +204,6 @@ static void rt2500usb_rf_write(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
-	if (!word)
-		return;
-
 	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index afce0e0..5bc46fe 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -59,8 +59,8 @@
 #define EEPROM_SIZE			0x006a
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x0060
-#define RF_BASE				0x0000
-#define RF_SIZE				0x0014
+#define RF_BASE				0x0004
+#define RF_SIZE				0x0010
 
 /*
  * Number of TX queues.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0be147f..2ca8b7a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -123,9 +123,6 @@ static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (!word)
-		return;
-
 	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 2f97fee..41e8959 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -50,8 +50,8 @@
 #define EEPROM_SIZE			0x0100
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x0080
-#define RF_BASE				0x0000
-#define RF_SIZE				0x0014
+#define RF_BASE				0x0004
+#define RF_SIZE				0x0010
 
 /*
  * Number of TX queues.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 8f52234..846996c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -122,9 +122,6 @@ static void rt73usb_rf_write(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (!word)
-		return;
-
 	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 834b28c..c8016f6 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -50,8 +50,8 @@
 #define EEPROM_SIZE			0x0100
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x0080
-#define RF_BASE				0x0000
-#define RF_SIZE				0x0014
+#define RF_BASE				0x0004
+#define RF_SIZE				0x0010
 
 /*
  * Number of TX queues.
-- 
1.5.6.1

