Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32954 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbbEEWkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 18:40:24 -0400
Date: Tue, 5 May 2015 23:40:20 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: joe@perches.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] adm8211: fix the possible pci cache line sizes inside
 switch-case
Message-ID: <20150505224020.GA3805@bytefire-computer> (sfid-20150506_004052_237796_13C67A74)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI cache line size value was being compared against decimal values prefixed with 0x.

Fixed the literals to use the correct hex values.


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

