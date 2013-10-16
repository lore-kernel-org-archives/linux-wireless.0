Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47182 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:45:56 -0400
Subject: [PATCH v2 3/8] ath10k: fix endianess in prints
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:45:53 +0300
Message-ID: <20131016134553.25095.84407.stgit@localhost6.localdomain6> (sfid-20131016_154558_676121_91685240)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This fixes incorrect values being printed on
big-endian hosts.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 77238af..a796d0b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2211,7 +2211,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
-		   __cpu_to_le32(ar->wmi.num_mem_chunks));
+		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
@@ -2224,10 +2224,10 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
 
 		ath10k_dbg(ATH10K_DBG_WMI,
-			   "wmi chunk %d len %d requested, addr 0x%x\n",
+			   "wmi chunk %d len %d requested, addr 0x%llx\n",
 			   i,
-			   cmd->host_mem_chunks[i].size,
-			   cmd->host_mem_chunks[i].ptr);
+			   ar->wmi.mem_chunks[i].len,
+			   (unsigned long long)ar->wmi.mem_chunks[i].paddr);
 	}
 out:
 	memcpy(&cmd->resource_config, &config, sizeof(config));
@@ -2302,7 +2302,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
-		   __cpu_to_le32(ar->wmi.num_mem_chunks));
+		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
@@ -2315,10 +2315,10 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
 
 		ath10k_dbg(ATH10K_DBG_WMI,
-			   "wmi chunk %d len %d requested, addr 0x%x\n",
+			   "wmi chunk %d len %d requested, addr 0x%llx\n",
 			   i,
-			   cmd->host_mem_chunks[i].size,
-			   cmd->host_mem_chunks[i].ptr);
+			   ar->wmi.mem_chunks[i].len,
+			   (unsigned long long)ar->wmi.mem_chunks[i].paddr);
 	}
 out:
 	memcpy(&cmd->resource_config, &config, sizeof(config));

