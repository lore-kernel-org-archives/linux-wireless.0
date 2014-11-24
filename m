Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49360 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaKXOgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:53 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so6020078wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:52 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 72/75] iwlwifi: mvm: disconnect TDLS peers before channel switch
Date: Mon, 24 Nov 2014 16:34:48 +0200
Message-Id: <1416839691-28533-72-git-send-email-egrumbach@gmail.com> (sfid-20141124_153659_502830_DB4EB72D)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In case of channel switch, we need to teardown the TDLS peers.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5dbf547..322d01b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3245,6 +3245,9 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unlock;
 
+	/* we won't be on this channel any longer */
+	iwl_mvm_teardown_tdls_peers(mvm);
+
 out_unlock:
 	mutex_unlock(&mvm->mutex);
 
-- 
1.9.1

