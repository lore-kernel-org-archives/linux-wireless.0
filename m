Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43983 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JORcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:32 -0400
Received: by mail-pa0-f42.google.com with SMTP id kx10so1245860pab.15
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/7] ath10k: fix endianess in prints
Date: Tue, 15 Oct 2013 10:29:52 -0700
Message-Id: <1381858196-17000-4-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193236_209324_89C3F2FB)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes incorrect values being printed on
big-endian hosts.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f9766fa..8e59887 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2209,7 +2209,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
-		   __cpu_to_le32(ar->wmi.num_mem_chunks));
+		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
@@ -2222,10 +2222,10 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
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
@@ -2300,7 +2300,7 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
-		   __cpu_to_le32(ar->wmi.num_mem_chunks));
+		   ar->wmi.num_mem_chunks);
 
 	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
 
@@ -2313,10 +2313,10 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
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
-- 
1.8.4.rc3

