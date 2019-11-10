Return-Path: <SRS0=Jrqb=ZC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B12C43331
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 03:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D6821D7F
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 03:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573354863;
	bh=qX0frf5V4JFJGYGpyYcZ1RuX4317DQq5x9AahDUvJEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2JxH3BHkgwE0jyJ0BA/Wfze0mJqiskJ3dQNM+dFyquN9vD3Z3quIMdbIFJpFs3W2R
	 68hOFnYhvXQgjjPQL/KDQmN+03mYf2mjZwO81VjOjJYHBfiilccIrR2bkIFn6IVPrQ
	 25GVkI38ytvMkin51itQbcVTodcx1mCBiIpDhqkg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfKJDAx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbfKJC4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3621E224D3;
        Sun, 10 Nov 2019 02:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354099;
        bh=qX0frf5V4JFJGYGpyYcZ1RuX4317DQq5x9AahDUvJEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cU8e3hl8kaCUzfJ1j/+0oVHea2Ht55HA0Q7z5Pxl5PLFOErMzce12xiAlV3QPhr8b
         Wf2QiGh6DLH4UyDwFLx79n/sTI03BD+2CcMfTy3ZgoZogh0eXOI1KPgtnp27jmc2eA
         2D1X0Kuma24+e6VtO5SUb8089AUZrR7TYmUWGxI0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 090/109] iwlwifi: mvm: Allow TKIP for AP mode
Date:   Sat,  9 Nov 2019 21:45:22 -0500
Message-Id: <20191110024541.31567-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 6f3df8c1192c873a6ad9a76328920f6f85af90a8 ]

Support for setting keys for TKIP cipher suite was mistakenly removed
for AP mode. Fix this.

Fixes: 85aeb58cec1a ("iwlwifi: mvm: Enable security on new TX API")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index d31d84eebc5d0..d16e2ed4419fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3067,10 +3067,6 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (vif->type == NL80211_IFTYPE_AP) {
-			ret = -EINVAL;
-			break;
-		}
 		addr = iwl_mvm_get_mac_addr(mvm, vif, sta);
 		/* get phase 1 key from mac80211 */
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
-- 
2.20.1

