Return-Path: <SRS0=HZW5=B7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F833C433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 06:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB2E20702
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 06:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597990347;
	bh=OEqebMumZ1WAvNjpublDJ/6UF26UIgB3B/eBkFYP1Ds=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=XRoR1xmRPORaA4Q6zwSFJilXb+LpGOrKf7MnFONCni95pLNLxc9VzURopNWsd34Ue
	 vQOk2qMx9pJSwuKNbqWmdgc88xH9J196JgIBL8fftrXPHQz+yZNA2exHbCPpl4fVHL
	 gXf+fZiTnAW0M4RqKxOAXVXZw3qJnw6rMAh3vDh0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHUGMV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Aug 2020 02:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgHUGMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Aug 2020 02:12:20 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAAB520702;
        Fri, 21 Aug 2020 06:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597990339;
        bh=OEqebMumZ1WAvNjpublDJ/6UF26UIgB3B/eBkFYP1Ds=;
        h=Date:From:To:Cc:Subject:From;
        b=r0f/lPYJY+pc+VwDGTohm75LEwa5wwssTc6ZK1mQ6Tum8mIi+gfwRH+qq/nGcxAAY
         5cV2UIXpm2Rid28uSrT8wUiojsZvhNrvfENgcIijK18KWPdIEoMscIgdrI+JAD9GUF
         B9vL3fcNNmzfMQBnpf9X2y9aylH0WlocmbWRkw70=
Date:   Fri, 21 Aug 2020 01:18:07 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] rtlwifi: Use fallthrough pseudo-keyword
Message-ID: <20200821061807.GA8412@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c          | 2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c          | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index a4489b9302d4..5dd707e60166 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2443,7 +2443,7 @@ static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
 	case IEEE80211_SMPS_AUTOMATIC:/* 0 */
 	case IEEE80211_SMPS_NUM_MODES:/* 4 */
 		WARN_ON(1);
-	/* fall through */
+		fallthrough;
 	case IEEE80211_SMPS_OFF:/* 1 */ /*MIMO_PS_NOLIMIT*/
 		action_frame->u.action.u.ht_smps.smps_control =
 				WLAN_HT_SMPS_CONTROL_DISABLED;/* 0 */
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 4dd82c6052f0..a4f698709b79 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -227,7 +227,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_CLIENT:
 		mac->p2p = P2P_ROLE_CLIENT;
-		/*fall through*/
+		fallthrough;
 	case NL80211_IFTYPE_STATION:
 		if (mac->beacon_enabled == 1) {
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
@@ -254,7 +254,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		mac->p2p = P2P_ROLE_GO;
-		/*fall through*/
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 "NL80211_IFTYPE_AP\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index b8a2b2326902..0e7ac3bd38d9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -370,7 +370,7 @@ static void _rtl8812ae_phy_set_rfe_reg_24g(struct ieee80211_hw *hw)
 			rtl_set_bbreg(hw, RB_RFE_INV, BMASKRFEINV, 0x000);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case 0:
 	case 2:
 	default:
-- 
2.27.0

