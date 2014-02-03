Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:56566 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaBCU6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:53 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so2488786eaj.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:52 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/62] iwlwifi: mvm: add predefined broadcast filter configuration
Date: Mon,  3 Feb 2014 22:57:30 +0200
Message-Id: <1391461088-8082-24-git-send-email-egrumbach@gmail.com> (sfid-20140203_220011_494793_4A9F13C7)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Configure arp request broadcast filter if this
option is enabled, in order to allow only arp
request broadcasts to pass-in.

(A following patch will make this filter even narrower
by limiting the arp request to our own ip)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 08b8051..6f9640b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -128,6 +128,28 @@ static const struct wiphy_wowlan_tcp_support iwl_mvm_wowlan_tcp_support = {
 };
 #endif
 
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
+	{
+		/* arp */
+		.discard = 0,
+		.frame_type = BCAST_FILTER_FRAME_TYPE_ALL,
+		.attrs = {
+			{
+				/* frame type - arp, hw type - ethernet */
+				.offset_type =
+					BCAST_FILTER_OFFSET_PAYLOAD_START,
+				.offset = sizeof(rfc1042_header),
+				.val = cpu_to_be32(0x08060001),
+				.mask = cpu_to_be32(0xffffffff),
+			},
+		},
+	},
+	/* last filter must be empty */
+	{},
+};
+#endif
+
 static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 {
 	int i;
@@ -292,6 +314,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 #endif
 
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+	/* assign default bcast filtering configuration */
+	mvm->bcast_filters = iwl_mvm_default_bcast_filters;
+#endif
+
 	ret = iwl_mvm_leds_init(mvm);
 	if (ret)
 		return ret;
-- 
1.7.9.5

