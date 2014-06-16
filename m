Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaFPQis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:48 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 20/25] wil6210: map additional registers on target
Date: Mon, 16 Jun 2014 19:37:18 +0300
Message-ID: <1402936643-31819-21-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190456_861134_CAB5404F)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New registers area introduced, mark corresponded address range as valid

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 281a28f..b92a042 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -75,6 +75,7 @@ static const struct {
 	{0x800000, 0x808000, 0x900000}, /* FW data RAM 32k */
 	{0x840000, 0x860000, 0x908000}, /* peripheral data RAM 128k/96k used */
 	{0x880000, 0x88a000, 0x880000}, /* various RGF */
+	{0x88b000, 0x88c000, 0x88b000}, /* Pcie_ext_rgf */
 	{0x8c0000, 0x949000, 0x8c0000}, /* trivial mapping for upper area */
 	/*
 	 * 920000..930000 ucode code RAM
-- 
1.9.1

