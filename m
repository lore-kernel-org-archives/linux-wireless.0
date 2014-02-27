Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47951 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaB0HD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 02:03:28 -0500
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: change of listen interval from 70 to 10
Date: Thu, 27 Feb 2014 09:03:18 +0200
Message-Id: <1393484599-8240-1-git-send-email-egrumbach@gmail.com> (sfid-20140227_080332_460617_2DAAE914)
In-Reply-To: <530EE0EA.5030105@gmail.com>
References: <530EE0EA.5030105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

Some APs reject STA association request if a listen interval value exceeds
a threshold of 10. Thus, for example, Cisco APs may deny STA associations
returning status code 12 (Association denied due to reason outside the scope
of 802.11 standard) in the association response frame.

Fixing the issue by setting the default IWL_CONN_MAX_LISTEN_INTERVAL value
from 70 to 10.

Cc: <stable@vger.kernel.org> [3.10+]
Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e4ead86..2b0ba1f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -152,7 +152,7 @@ enum iwl_power_scheme {
 	IWL_POWER_SCHEME_LP
 };
 
-#define IWL_CONN_MAX_LISTEN_INTERVAL	70
+#define IWL_CONN_MAX_LISTEN_INTERVAL	10
 #define IWL_UAPSD_AC_INFO		(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO |\
 					 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |\
 					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |\
-- 
1.8.3.2

