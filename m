Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55626 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaGNGvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:18 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 7/7] wil6210: add new register region for AGC table
Date: Mon, 14 Jul 2014 09:49:43 +0300
Message-ID: <1405320583-5775-8-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085125_639609_5C8D3BB8)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

New register area defined in the firmware

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h |    2 +-
 drivers/net/wireless/ath/wil6210/wmi.c     |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a78aaab..67e9624 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -152,7 +152,7 @@ struct fw_map {
 	const char *name; /* for debugfs */
 };
 /* array size should be in sync with actual definition in the wmi.c */
-extern const struct fw_map fw_mapping[6];
+extern const struct fw_map fw_mapping[7];
 
 /**
  * mk_cidxtid - construct @cidxtid field
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 084c3de..1d1d0af 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -73,6 +73,7 @@ const struct fw_map fw_mapping[] = {
 	{0x800000, 0x808000, 0x900000, "fw_data"}, /* FW data RAM       32k */
 	{0x840000, 0x860000, 0x908000, "fw_peri"}, /* periph. data RAM 128k */
 	{0x880000, 0x88a000, 0x880000, "rgf"},     /* various RGF       40k */
+	{0x88a000, 0x88b000, 0x88a000, "AGC_tbl"}, /* AGC table          4k */
 	{0x88b000, 0x88c000, 0x88b000, "rgf_ext"}, /* Pcie_ext_rgf       4k */
 	{0x8c0000, 0x949000, 0x8c0000, "upper"},   /* upper area       548k */
 	/*
-- 
1.7.6

