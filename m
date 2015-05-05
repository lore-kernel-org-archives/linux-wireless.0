Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38381 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbbEEVs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 17:48:56 -0400
Date: Tue, 5 May 2015 22:48:51 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] adm8211: fix the possible pci cache line sizes inside
 switch-case
Message-ID: <20150505214851.GA3013@bytefire-computer> (sfid-20150505_234951_239280_00189D13)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI cache line size value, stored in cline variable, was being
compared against decimal values written as hex literals. This patch
changes those literals to correct hex values. 

Please note that this patch is on top of
another code cleanup patch '[PATCH] adm8211: fix checkpatch errors for
indentation and new line around switch-case'.


Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>
---
 drivers/net/wireless/adm8211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 058fb4b..76c908f 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1101,10 +1101,10 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 		case  0x8:
 			reg |= (0x1 << 14);
 			break;
-		case 0x16:
+		case 0x10:
 			reg |= (0x2 << 14);
 			break;
-		case 0x32:
+		case 0x20:
 			reg |= (0x3 << 14);
 			break;
 		default:
-- 
1.9.1

