Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847FFC432BE
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 08:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E26E6102A
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 08:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhHWIx4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Aug 2021 04:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235677AbhHWIx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Aug 2021 04:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A6361262;
        Mon, 23 Aug 2021 08:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629708794;
        bh=r/dyWtyROZaLlf9laLCTtzhNCxcH3a2A75/fyRzUe9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1mvcmSgIMuKJVR9c/lH8tcHuthZxfY0zgQsuaxVNj58g1XuAgvFAQzZRJA3dQCip
         O4z5ojqd+HCZvy2JJVMsxOIYiGYPv/QColRG9WwVwobzwY8ddV8QgWJWeA9h0N86wa
         ASEhnMmAtUjGFqwNLloroyNBICY41EHf/UEBpmQK+mF3aKLzPbxe7Jl1Ec7+HUj49Q
         uCpy9pWRsHBvCKDCqIvisFw1GrdzQ2GhpL1KNSpoHy/eBjCR8AiCCGM18dS/+q0Iy0
         YDyzN42rQzUb+6fzGXq0GtzI9j8EFvnN5jN6HMJBKFuacaEjrX6j7SqYZKkpBWeRxJ
         TmIVBOLfiUbMw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, chui-hao.chiu@mediatek.com
Subject: [PATCH v3 mac80211-next 6/7] mt76: mt7915: enable twt responder capability
Date:   Mon, 23 Aug 2021 10:52:44 +0200
Message-Id: <b770bc64f8f0061e4ddd24dfbb82a7f87c9bbc91.1629706968.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1629706968.git.lorenzo@kernel.org>
References: <cover.1629706968.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable TWT support in AP mode

Tested-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ca9d0380d42b..11bd9b4686ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -699,6 +699,8 @@ mt7915_init_he_caps(struct mt7915_phy *phy, enum nl80211_band band,
 
 		switch (i) {
 		case NL80211_IFTYPE_AP:
+			he_cap_elem->mac_cap_info[0] |=
+				IEEE80211_HE_MAC_CAP0_TWT_RES;
 			he_cap_elem->mac_cap_info[2] |=
 				IEEE80211_HE_MAC_CAP2_BSR;
 			he_cap_elem->mac_cap_info[4] |=
-- 
2.31.1

