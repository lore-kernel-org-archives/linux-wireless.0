Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48828 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3FIGNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:13 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/6] wil6210: map more FW memory
Date: Sun, 9 Jun 2013 09:12:51 +0300
Message-ID: <1370758375-16867-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081316_678753_8280E677)
In-Reply-To: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

map card's back-door debug data

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index aeb64f2..cfcaf7b 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -75,10 +75,11 @@ static const struct {
 	{0x800000, 0x808000, 0x900000}, /* FW data RAM 32k */
 	{0x840000, 0x860000, 0x908000}, /* peripheral data RAM 128k/96k used */
 	{0x880000, 0x88a000, 0x880000}, /* various RGF */
-	{0x8c0000, 0x932000, 0x8c0000}, /* trivial mapping for upper area */
+	{0x8c0000, 0x949000, 0x8c0000}, /* trivial mapping for upper area */
 	/*
 	 * 920000..930000 ucode code RAM
 	 * 930000..932000 ucode data RAM
+	 * 932000..949000 back-door debug data
 	 */
 };
 
-- 
1.8.1.2

