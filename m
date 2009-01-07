Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46144 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZAGAnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 19:43:50 -0500
Received: by ewy10 with SMTP id 10so8757855ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 16:43:48 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: Remove unused variable rx_data
Date: Wed,  7 Jan 2009 00:43:54 +0000
Message-Id: <1231289034-24065-1-git-send-email-kilroyd@googlemail.com> (sfid-20090107_014356_371611_8E95B816)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Probably something leftover from experimentation with tasklets. Now the
structure declaration orinoco_rx_data can be relocated to orinoco.c

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |    6 ++++++
 drivers/net/wireless/orinoco/orinoco.h |    9 ---------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 2b7e2e9..47e51db 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -240,6 +240,12 @@ struct hermes_rx_descriptor {
 	__le16 data_len;
 } __attribute__ ((packed));
 
+struct orinoco_rx_data {
+	struct hermes_rx_descriptor *desc;
+	struct sk_buff *skb;
+	struct list_head list;
+};
+
 /********************************************************************/
 /* Function prototypes                                              */
 /********************************************************************/
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 00750c8..c653816 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -59,14 +59,6 @@ struct xbss_element {
 	struct list_head list;
 };
 
-struct hermes_rx_descriptor;
-
-struct orinoco_rx_data {
-	struct hermes_rx_descriptor *desc;
-	struct sk_buff *skb;
-	struct list_head list;
-};
-
 struct firmware;
 
 struct orinoco_private {
@@ -83,7 +75,6 @@ struct orinoco_private {
 	/* Interrupt tasklets */
 	struct tasklet_struct rx_tasklet;
 	struct list_head rx_list;
-	struct orinoco_rx_data *rx_data;
 
 	/* driver state */
 	int open;
-- 
1.6.0.6

