Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251A5C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 22:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A7A2084D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 22:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="F6sqy0qK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfBJWXX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 17:23:23 -0500
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:50607 "EHLO
        5.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfBJWXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 17:23:23 -0500
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 17:23:21 EST
Received: from player729.ha.ovh.net (unknown [10.109.159.140])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 761011F9216
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:48 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player729.ha.ovh.net (Postfix) with ESMTPSA id 087852B80774;
        Sun, 10 Feb 2019 21:06:47 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832805;
        bh=DsjUnxl4e6z2xAMWSsMJkRl6ddFXBpwI37En5PIoUGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=F6sqy0qKnHF+/eDrZpql1khg8EKl/QnvOJIsn31vQOB42cF/8V6YhWcbEYYCRJh6S
         OY4X+hen47zYQpwYLNn7rJCjGjIfirDaGHwL4pyF8IzGXcZ10HvHcaS00i6JOhHjWX
         hJPKI9SBv68a+mgveeMDg9VX6fiXcsZPJMmI/98Q=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
Date:   Sun, 10 Feb 2019 22:06:15 +0100
Message-Id: <20190210210620.31181-8-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549682131081764039
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleefgddthecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is not ready for merge and has known issues.
The patch is only for discussions to sort out how to handle it correctly!

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

iwlwifi intel cards had two big surprises:

Assuming I did not make some stupid errors it looks like my old
"Intel Corporation Centrino Ultimate-N 6300 (rev 3e)" using ucode 
9.221.4.1 build 25532 is perfectly fine with two keys uploaded to
harware and honoring the keyid in the MPDUs. For a card launched 2011
that's a pleasant surprise:-)

A much shorter test with a modern "Intel Corporation Wireless 8265 /
8175 (rev 78)" using ucode version 36.e91976c0.0 shows what seems to be
MPDUs decoded with the wrong key at each rekey and therefore a candidate
for the COMPAT support only..
So the bad news seems to be, that the modern card dropped the support.

It also seems to force us to add some per-card or per-firmware depending
check to decide which card can use the Native Extended Key ID support
and use the Compat mode for the rest.
Is there any way to find out which cards/firmware can be used with
Extended Key ID?
I also have tested patch for iwldvm using the Compat mode and I think
mvm cards will also work with that.

 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c | 5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 54b759cec8b3..0dd5c19ac412 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -111,6 +111,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	ieee80211_hw_set(hw, EXT_KEY_ID_NATIVE);
 
 	if (priv->trans->max_skb_frags)
 		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
@@ -676,6 +677,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 
 	switch (cmd) {
+	case EXT_SET_KEY:
 	case SET_KEY:
 		if (is_default_wep_key) {
 			ret = iwl_set_default_wep_key(priv, vif_priv->ctx, key);
@@ -701,6 +703,9 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
 		break;
+	case EXT_KEY_RX_TX:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index fc251cc47b7f..102367d2572f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -442,6 +442,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, STA_MMPDU_TXQ);
 	ieee80211_hw_set(hw, TX_AMSDU);
 	ieee80211_hw_set(hw, TX_FRAG_LIST);
+	ieee80211_hw_set(hw, EXT_KEY_ID_NATIVE);
 
 	if (iwl_mvm_has_tlc_offload(mvm)) {
 		ieee80211_hw_set(hw, TX_AMPDU_SETUP_IN_HW);
@@ -3357,6 +3358,7 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 	mutex_lock(&mvm->mutex);
 
 	switch (cmd) {
+	case EXT_SET_KEY:
 	case SET_KEY:
 		if ((vif->type == NL80211_IFTYPE_ADHOC ||
 		     vif->type == NL80211_IFTYPE_AP) && !sta) {
@@ -3464,6 +3466,9 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		IWL_DEBUG_MAC80211(mvm, "disable hwcrypto key\n");
 		ret = iwl_mvm_remove_sta_key(mvm, vif, sta, key);
 		break;
+	case EXT_KEY_RX_TX:
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.20.1

