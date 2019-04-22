Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210E3C10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 21:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 832EB206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 21:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="ylXXAfwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfDVVwb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:52:31 -0400
Received: from 10.mo179.mail-out.ovh.net ([46.105.79.46]:54096 "EHLO
        10.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfDVVwb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 17:52:31 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2019 17:52:30 EDT
Received: from player718.ha.ovh.net (unknown [10.108.42.176])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 2DDBB1253AC
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2019 23:34:21 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player718.ha.ovh.net (Postfix) with ESMTPSA id 81ACF4EDEE37;
        Mon, 22 Apr 2019 21:34:19 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1555968858;
        bh=WgM0UDRnPlmG8UkabbpibpT2If8wShVK3tOLFJxTzFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ylXXAfwEYJGshXPELYHhU0lJhLS+/5v82KoAfgEbDLgcMS/O/Bg3jzRNGBmB6Qf3U
         scjUluYaApxPAB4l2CpN/ZgUo7B/CgGfSLUI8MEhoL0SyG772GCSyDMZaUgwiMb8qY
         QJV31A0/YTNYVGqXspYg52QVJinavoTsm2aeNK8Y=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 2/2] mac80211_hwsim:  Update feature flags
Date:   Mon, 22 Apr 2019 23:34:12 +0200
Message-Id: <20190422213412.16533-2-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190422213412.16533-1-alexander@wetzel-home.de>
References: <20190422213412.16533-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3701114470241737927
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrgeeigdduheegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hwsim is not using HW crypto offload and can correctly rekey PTK keys.
Set NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 to not trigger workarounds.

Also allow Extended Key ID to be used with hwsim, regardless that the
driver A-MPDU aggregation is violating IEEE 802.11 and can aggregate
MPDUs using different key IDs into one A-MPDU.

Hwsim can only communicate with other hwsim cards and itself is able to
handle the non-standard A-MPDUs on Rx.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 44cffd1f6dbf..7abe52e3357f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2810,6 +2810,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, TDLS_WIDER_BW);
+	ieee80211_hw_set(hw, EXT_KEY_ID_NATIVE);
 	if (rctbl)
 		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
@@ -2824,6 +2825,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			       NL80211_FEATURE_DYNAMIC_SMPS |
 			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
-- 
2.21.0

