Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbbJVJMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 05:12:31 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Robert Dolca <robert.dolca@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v4 08/10] nfc: nci: fix possible crash in nci_core_conn_create
Date: Thu, 22 Oct 2015 12:11:40 +0300
Message-Id: <1445505102-16639-9-git-send-email-robert.dolca@intel.com> (sfid-20151022_111805_543690_739E1D21)
In-Reply-To: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
References: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the number of destination speific parameters supplied is 0 the call
will fail. If the first destination specific parameter does not have a
value, curr_id will be set to 0.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 net/nfc/nci/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index f66a5da..9d5f7a2 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -602,12 +602,19 @@ int nci_core_conn_create(struct nci_dev *ndev, u8 destination_type,
 	if (!cmd)
 		return -ENOMEM;
 
+	if (!number_destination_params)
+		return -EINVAL;
+
 	cmd->destination_type = destination_type;
 	cmd->number_destination_params = number_destination_params;
 	memcpy(cmd->params, params, params_len);
 
 	data.cmd = cmd;
-	ndev->cur_id = params->value[DEST_SPEC_PARAMS_ID_INDEX];
+
+	if (params->length > 0)
+		ndev->cur_id = params->value[DEST_SPEC_PARAMS_ID_INDEX];
+	else
+		ndev->cur_id = 0;
 
 	r = __nci_request(ndev, nci_core_conn_create_req,
 			  (unsigned long)&data,
-- 
1.9.1

