Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65023 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2ARLOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:14:07 -0500
Received: by yenm6 with SMTP id m6so702218yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2012 03:14:06 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 2/3] NFC: NFC core layer should not set the target_idx
Date: Wed, 18 Jan 2012 13:16:13 +0200
Message-Id: <1326885374-13318-3-git-send-email-ilane@ti.com> (sfid-20120118_121410_905182_1B9A339A)
In-Reply-To: <1326885374-13318-1-git-send-email-ilane@ti.com>
References: <1326885374-13318-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

The NFC core layer should not set the target_idx.
Instead, the driver layer (e.g. NCI, PN533) should set the
target_idx, so that it will be able to identify the target
when its I/F (e.g. activate_target) is called.
This is required in order to support multiple targets.
Note that currently supported drivers (PN533 and NCI) don't
use the target_idx in their implementation.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nfc.h |    1 -
 net/nfc/core.c        |    5 -----
 net/nfc/rawsock.c     |   12 ------------
 3 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 819530d..d253278 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -87,7 +87,6 @@ struct nfc_genl_data {
 
 struct nfc_dev {
 	unsigned idx;
-	unsigned target_idx;
 	struct nfc_target *targets;
 	int n_targets;
 	int targets_generation;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 3ddf6e6..6089aca 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -431,15 +431,10 @@ EXPORT_SYMBOL(nfc_alloc_recv_skb);
 int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
 							int n_targets)
 {
-	int i;
-
 	pr_debug("dev_name=%s n_targets=%d\n", dev_name(&dev->dev), n_targets);
 
 	dev->polling = false;
 
-	for (i = 0; i < n_targets; i++)
-		targets[i].idx = dev->target_idx++;
-
 	spin_lock_bh(&dev->targets_lock);
 
 	dev->targets_generation++;
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 2e2f8c6..5325439 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -92,18 +92,6 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
 		goto error;
 	}
 
-	if (addr->target_idx > dev->target_idx - 1 ||
-		addr->target_idx < dev->target_idx - dev->n_targets) {
-		rc = -EINVAL;
-		goto error;
-	}
-
-	if (addr->target_idx > dev->target_idx - 1 ||
-		addr->target_idx < dev->target_idx - dev->n_targets) {
-		rc = -EINVAL;
-		goto error;
-	}
-
 	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);
 	if (rc)
 		goto put_dev;
-- 
1.7.0.4

