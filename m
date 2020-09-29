Return-Path: <SRS0=ETdN=DG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DFCC2D0A8
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Sep 2020 01:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A517820774
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Sep 2020 01:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601343373;
	bh=dCz7OQ/JYPDJsQPHxnG8M+hDDFlJbKaWyCh0Aa5bvGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yb/UPKwSiXWRbYj+5xIWmmc040/jECKZDQbMwdEwO8iR8hzsZj9auhaSspOzRnIU2
	 FWCNRPM4vW/2nNkK0ed9BgKFBm0VenlFkO/I4EMQ85N1woTGzQbORATYaDfka8adnV
	 p2LaBXl3oMsWSq5PDq505WzRCub6WeC8BAh9bxbk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgI2BgL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbgI2Bax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B86342080A;
        Tue, 29 Sep 2020 01:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343052;
        bh=dCz7OQ/JYPDJsQPHxnG8M+hDDFlJbKaWyCh0Aa5bvGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgFiH/5KoTq8+PvLOJzkgvhtukCxapLIIs5WHzg3s/usacVbxT6+Ei0VREGG6Y9HU
         IgaobpFczaPzc4HRfuzQmqIve8z9mUyfahrKoIBauiuhrRjqOTXljBU5BZWhZTf4e5
         OrgVssHRiGfZWft1KSe8WtfwBoj70hyJE6N9Pgm8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 19/29] mac80211: do not allow bigger VHT MPDUs than the hardware supports
Date:   Mon, 28 Sep 2020 21:30:16 -0400
Message-Id: <20200929013027.2406344-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3bd5c7a28a7c3aba07a2d300d43f8e988809e147 ]

Limit maximum VHT MPDU size by local capability.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200917125031.45009-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/vht.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 9c6045f9c24da..d1b64d0751f2e 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -168,10 +168,7 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	/* take some capabilities as-is */
 	cap_info = le32_to_cpu(vht_cap_ie->vht_cap_info);
 	vht_cap->cap = cap_info;
-	vht_cap->cap &= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895 |
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-			IEEE80211_VHT_CAP_RXLDPC |
+	vht_cap->cap &= IEEE80211_VHT_CAP_RXLDPC |
 			IEEE80211_VHT_CAP_VHT_TXOP_PS |
 			IEEE80211_VHT_CAP_HTC_VHT |
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
@@ -180,6 +177,9 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
 			IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
 
+	vht_cap->cap |= min_t(u32, cap_info & IEEE80211_VHT_CAP_MAX_MPDU_MASK,
+			      own_cap.cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK);
+
 	/* and some based on our own capabilities */
 	switch (own_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
 	case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ:
-- 
2.25.1

