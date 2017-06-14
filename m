Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34908 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdFNHtz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 03:49:55 -0400
Date: Wed, 14 Jun 2017 10:49:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] NFC: nci: Remove an unneeded NULL check
Message-ID: <20170614074945.GA29233@elgon.mountain> (sfid-20170614_094959_349210_9DFC418E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"conn_info" can't be NULL here.  Also we just dereferenced it a couple
lines earlier, so that makes static checkers complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 61fff422424f..5542fc72f020 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -73,11 +73,9 @@ int nci_get_conn_info_by_dest_type_params(struct nci_dev *ndev, u8 dest_type,
 		if (conn_info->dest_type == dest_type) {
 			if (!params)
 				return conn_info->conn_id;
-			if (conn_info) {
-				if (params->id == conn_info->dest_params->id &&
-				    params->protocol == conn_info->dest_params->protocol)
-					return conn_info->conn_id;
-			}
+			if (params->id == conn_info->dest_params->id &&
+			    params->protocol == conn_info->dest_params->protocol)
+				return conn_info->conn_id;
 		}
 	}
 
