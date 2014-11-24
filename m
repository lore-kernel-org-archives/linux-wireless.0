Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63946 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKXOfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:08 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so12308085wgg.22
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:06 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/75] iwlwifi: mvm: rs: fix a WARNING in case of STBC and VHT
Date: Mon, 24 Nov 2014 16:33:43 +0200
Message-Id: <1416839691-28533-7-git-send-email-egrumbach@gmail.com> (sfid-20141124_154444_046824_1F72252F)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This was taken care of in case we're doing STBC with HT
but not when working with VHT.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6775100..cb18b60 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -816,7 +816,7 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 
 		if (nss == 1) {
 			rate->type = LQ_VHT_SISO;
-			WARN_ON_ONCE(num_of_ant != 1);
+			WARN_ON_ONCE(!rate->stbc && num_of_ant != 1);
 		} else if (nss == 2) {
 			rate->type = LQ_VHT_MIMO2;
 			WARN_ON_ONCE(num_of_ant != 2);
-- 
1.9.1

