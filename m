Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34242 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3LaRQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:29 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so5569573eek.16
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/28] iwlwifi: mvm: BT Coex - update channel inihibition for channel 14
Date: Tue, 31 Dec 2013 19:15:48 +0200
Message-Id: <1388510157-23345-19-git-send-email-egrumbach@gmail.com> (sfid-20131231_183435_935181_C73781FC)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This channel inhibition for channel 14 was wrong. Fix it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index d126245..dc428c8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -294,9 +294,9 @@ static const __le64 iwl_ci_mask[][3] = {
 		cpu_to_le64(0x0)
 	},
 	{
-		cpu_to_le64(0xFE00000000ULL),
+		cpu_to_le64(0xFFC0000000ULL),
 		cpu_to_le64(0x0ULL),
-		cpu_to_le64(0x0)
+		cpu_to_le64(0x0ULL)
 	},
 };
 
-- 
1.7.9.5

