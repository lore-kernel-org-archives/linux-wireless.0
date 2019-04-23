Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052EBC10F03
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 21:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF59218D2
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 21:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="Dvm8ApaZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfDWVFo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 17:05:44 -0400
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:42050 "EHLO
        8.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfDWVFo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 17:05:44 -0400
X-Greylist: delayed 84293 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2019 17:05:43 EDT
Received: from player774.ha.ovh.net (unknown [10.109.146.106])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 086B716B07A
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 22:48:56 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id 5202E50889C1;
        Tue, 23 Apr 2019 20:48:55 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1556052534;
        bh=jzQFdCQ2iDzpKGlU2sxjSKnE1GPk3SV5EDgsVBoXL5Q=;
        h=From:To:Cc:Subject:Date;
        b=Dvm8ApaZi6S40qB/nqWmwd4bTatpZTk5ucZuWShjXmmu/cshacM6/GbWm1ApcREOD
         9PGRuQOnS1YgBZeHR45tXJcp3Ufqd8wTzSHsdYM8q0eTMEpkwn/3yCos3PJyGBsn4z
         hoVCmHzH0/dfb/2ONmcAGILkItEz4s9EIgqBvgx8=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH] mac80211_hwsim: Extended Key ID support
Date:   Tue, 23 Apr 2019 22:47:11 +0200
Message-Id: <20190423204711.20349-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8806789074729245895
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrgeekgddugeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allow Extended Key ID to be used with hwsim.

Hwsim can only communicate with other hwsim cards, allowing it to bypass
creation of A-MPDUs in the first place.

Mixing keyIDs in an A-MPDU is therefore impossible and can never cause
interoperability issues with other cards.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 44cffd1f6dbf..7a0310715462 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2810,6 +2810,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, TDLS_WIDER_BW);
+
+	/* With only SW crypto support and only implementing the A-MPDU API
+	 * all requirements for Extended Key ID support are met.
+	 */
+	ieee80211_hw_set(hw, EXT_KEY_ID_NATIVE);
 	if (rctbl)
 		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
-- 
2.21.0

