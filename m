Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbbIAOzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 10:55:24 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v2 8/9] nfc: nci: Add a parameter to get the new connection id
Date: Tue,  1 Sep 2015 17:54:27 +0300
Message-Id: <1441119268-30654-9-git-send-email-robert.dolca@intel.com> (sfid-20150901_165659_569717_913731EE)
In-Reply-To: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
References: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nci_core_conn_create has a new parameter so it can return the id of the
new connection. Also now you can't call nci_core_conn_create
without waiting for the answer from the previous call.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 drivers/nfc/st-nci/st-nci_se.c |  2 +-
 include/net/nfc/nci_core.h     | 11 ++++++++---
 net/nfc/nci/core.c             | 14 ++++++++++----
 net/nfc/nci/rsp.c              |  6 ++++++
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/st-nci/st-nci_se.c b/drivers/nfc/st-nci/st-nci_se.c
index c742ef6..65ba433 100644
--- a/drivers/nfc/st-nci/st-nci_se.c
+++ b/drivers/nfc/st-nci/st-nci_se.c
@@ -524,7 +524,7 @@ static int st_nci_hci_network_init(struct nci_dev *ndev)
 	r = nci_core_conn_create(ndev, NCI_DESTINATION_NFCEE, 1,
 				 sizeof(struct core_conn_create_dest_spec_params) +
 				 sizeof(struct dest_spec_params),
-				 dest_params);
+				 dest_params, NULL);
 	if (r != NCI_STATUS_OK)
 		goto free_dest_params;
 
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 61dcaf2..880b5cf 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -260,6 +260,11 @@ struct nci_dev {
 	/* Save RF Discovery ID or NFCEE ID under conn_create */
 	__u8			cur_id;
 
+	/* Pointer to the address where the next connection ID
+	 * will be stored */
+	__u8			*next_conn_id;
+	__u8			conn_busy;
+
 	/* stored during nci_data_exchange */
 	struct sk_buff		*rx_data_reassembly;
 
@@ -294,9 +299,9 @@ int nci_set_config(struct nci_dev *ndev, __u8 id, size_t len, __u8 *val);
 int nci_nfcee_discover(struct nci_dev *ndev, u8 action);
 int nci_nfcee_mode_set(struct nci_dev *ndev, u8 nfcee_id, u8 nfcee_mode);
 int nci_core_conn_create(struct nci_dev *ndev, u8 destination_type,
-			 u8 number_destination_params,
-			 size_t params_len,
-			 struct core_conn_create_dest_spec_params *params);
+			 u8 number_destination_params, size_t params_len,
+			 struct core_conn_create_dest_spec_params *params,
+			 u8 *conn_id);
 int nci_core_conn_close(struct nci_dev *ndev, u8 conn_id);
 
 struct nci_hci_dev *nci_hci_allocate(struct nci_dev *ndev);
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 5d61b6e..a9119e1 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -589,18 +589,22 @@ static void nci_core_conn_create_req(struct nci_dev *ndev, unsigned long opt)
 }
 
 int nci_core_conn_create(struct nci_dev *ndev, u8 destination_type,
-			 u8 number_destination_params,
-			 size_t params_len,
-			 struct core_conn_create_dest_spec_params *params)
+			 u8 number_destination_params, size_t params_len,
+			 struct core_conn_create_dest_spec_params *params,
+			 u8 *conn_id)
 {
 	int r;
 	struct nci_core_conn_create_cmd *cmd;
 	struct core_conn_create_data data;
 
+	mutex_lock(&ndev->req_lock);
+
 	data.length = params_len + sizeof(struct nci_core_conn_create_cmd);
 	cmd = kzalloc(data.length, GFP_KERNEL);
-	if (!cmd)
+	if (!cmd) {
+		mutex_unlock(&ndev->req_lock);
 		return -ENOMEM;
+	}
 
 	cmd->destination_type = destination_type;
 	cmd->number_destination_params = number_destination_params;
@@ -608,10 +612,12 @@ int nci_core_conn_create(struct nci_dev *ndev, u8 destination_type,
 
 	data.cmd = cmd;
 	ndev->cur_id = params->value[DEST_SPEC_PARAMS_ID_INDEX];
+	ndev->next_conn_id = conn_id;
 
 	r = __nci_request(ndev, nci_core_conn_create_req,
 			  (unsigned long)&data,
 			  msecs_to_jiffies(NCI_CMD_TIMEOUT));
+	mutex_unlock(&ndev->req_lock);
 	kfree(cmd);
 	return r;
 }
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 0efab0b..e83e664 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -244,6 +244,12 @@ static void nci_core_conn_create_rsp_packet(struct nci_dev *ndev,
 		conn_info->id = ndev->cur_id;
 		conn_info->conn_id = rsp->conn_id;
 
+		/* Set the conn ID to the address provided by the caller */
+		if (ndev->next_conn_id) {
+			*ndev->next_conn_id = rsp->conn_id;
+			ndev->next_conn_id = NULL;
+		}
+
 		/* Note: data_exchange_cb and data_exchange_cb_context need to
 		 * be specify out of nci_core_conn_create_rsp_packet
 		 */
-- 
1.9.1

