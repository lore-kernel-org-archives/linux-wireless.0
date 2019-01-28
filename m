Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96008C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B4BC214DA
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696355;
	bh=29jjvKe5CMJnihePTpcwea7edh2rWu3tC/8FLhquHPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lqPDWWnYb7ZxOx1IlcdKgrcAhYTsWHZzeXceKooR7YaHbZEtvn7WTjdWGnkBK+sOf
	 qjb9XbDnIBVXy7hVhTGrABxGCqicV2RL26h2zu/nmEfqNcYjMfEHDqrNGdMeryJZcW
	 hWeuu2rgkTuRlgWsOElF08ye18dTpzmVnaCfW8pc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbfA1QBC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbfA1QBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:01:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5B62175B;
        Mon, 28 Jan 2019 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691259;
        bh=29jjvKe5CMJnihePTpcwea7edh2rWu3tC/8FLhquHPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rztJtzxwhTr4t4IaBDDVkL8ABMei16uWqmu6fzEbrZ6Uh8YCFgzP40EKNmVEEwXBZ
         si+8WJZZ/UhkXpAse2PoCtHTWo0Ws6GfbHeo+p3st4wJC8yjeGqUMA3Y+F7QUDm9sF
         JQNfvvVUnuTlqn4LGZo7X3PeFWiO8Ez4mlN2eSNc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 035/258] iwlwifi: fw: do not set sgi bits for HE connection
Date:   Mon, 28 Jan 2019 10:55:41 -0500
Message-Id: <20190128155924.51521-35-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit 5c2dbebb446539eb9640bf59a02756d6e7f1fc53 ]

If the association supports HE, HT/VHT rates will never be used for Tx
and therefore there's no need to set the sgi-per-channel-width-support
bits, so don't set them in this case.

Fixes: 110b32f065f3 ("iwlwifi: mvm: rs: add basic implementation of the new RS API handlers")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 8169d1450b3b..d1c1a8069c7e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -98,8 +98,12 @@ static u8 rs_fw_sgi_cw_support(struct ieee80211_sta *sta)
 {
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	struct ieee80211_sta_he_cap *he_cap = &sta->he_cap;
 	u8 supp = 0;
 
+	if (he_cap && he_cap->has_he)
+		return 0;
+
 	if (ht_cap->cap & IEEE80211_HT_CAP_SGI_20)
 		supp |= BIT(IWL_TLC_MNG_CH_WIDTH_20MHZ);
 	if (ht_cap->cap & IEEE80211_HT_CAP_SGI_40)
-- 
2.19.1

