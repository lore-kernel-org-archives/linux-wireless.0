Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61596 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab0LDTnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 14:43:02 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so10672961wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Dec 2010 11:43:02 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: comes@naic.edu, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/2] orinoco: clear countermeasure setting on commit
Date: Sat,  4 Dec 2010 19:42:44 +0000
Message-Id: <1291491764-6655-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1291491764-6655-1-git-send-email-kilroyd@googlemail.com>
References: <1291491764-6655-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and interface up.

In these situations, you are usually trying to connect to a new AP, so
keeping TKIP countermeasures active is confusing. This is already how
the driver behaves (inadvertently). However, querying SIOCGIWAUTH may
tell userspace that countermeasures are active when they aren't.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index fa0cf74..f3d396e 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1811,6 +1811,12 @@ static int __orinoco_commit(struct orinoco_private *priv)
 	struct net_device *dev = priv->ndev;
 	int err = 0;
 
+	/* If we've called commit, we are reconfiguring or bringing the
+	 * interface up. Maintaining countermeasures across this would
+	 * be confusing, so note that we've disabled them. The port will
+	 * be enabled later in orinoco_commit or __orinoco_up. */
+	priv->tkip_cm_active = 0;
+
 	err = orinoco_hw_program_rids(priv);
 
 	/* FIXME: what about netif_tx_lock */
-- 
1.7.2.2

