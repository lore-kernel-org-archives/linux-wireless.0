Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19607 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbYCSTxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix spinlock recursion bug
Date: Wed, 19 Mar 2008 15:24:21 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803191524.21866.hs4233@mail.mn-solutions.de> (sfid-20080319_195437_942150_AAA2A953)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a bug detected by CONFIG_DEBUG_SPINLOCK:

if_cs_get_int_status() is only called from lbs_thread(), via
priv->hw_get_int_status. However, lbs_thread() has already taken the
priv->driver_lock. So it's a fault to take the same lock again here.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
CONFIG_DEBUG_SPINLOCK,
---

John, this patch might also go into linux-2.6.25-rcX

Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-03-19 13:46:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-03-19 13:46:53.000000000 +0100
@@ -677,9 +677,7 @@ sbi_get_int_status_exit:
 
 	/* Card has a command result for us */
 	if (*ireg & IF_CS_C_S_CMD_UPLD_RDY) {
-		spin_lock(&priv->driver_lock);
 		ret = if_cs_receive_cmdres(priv, priv->upld_buf, &priv->upld_len);
-		spin_unlock(&priv->driver_lock);
 		if (ret < 0)
 			lbs_pr_err("could not receive cmd from card\n");
 	}
