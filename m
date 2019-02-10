Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0973FC4151A
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDEB721736
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="n3zG4Hua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfBJVl7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:41:59 -0500
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:44840 "EHLO
        3.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfBJVl7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:41:59 -0500
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 16:41:58 EST
Received: from player758.ha.ovh.net (unknown [10.109.159.224])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 875D814F898
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:48 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player758.ha.ovh.net (Postfix) with ESMTPSA id 19A3A295B378;
        Sun, 10 Feb 2019 21:06:47 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832805;
        bh=9rp5j8AM1egNJZGYcIsZhun08BW1eMx/HaJEf0Wicjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=n3zG4Hua3O1NmahUq4wdDPPBhlokk6iJthV+1NDIIBCKyGabyAAZItP7PUYQbOfs/
         sOiKysK1l+cSrixanWx8wzS7GA7y2P0zNa2+/JyjRmSzhKiqS/rbZVYQ5I749KER9X
         Sdr8JHqZJj87DveGeBR1OfCCWF8YRBAvTfZqFHp0=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 10/12] ath5k: ath_key_config() API compatibility update
Date:   Sun, 10 Feb 2019 22:06:18 +0100
Message-Id: <20190210210620.31181-11-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549682128695073991
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleehgdekhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update ath_key_config() call to work with Extended Key ID update for ath.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

This patch is only provided to not break compile for ath5k. 
(ath5k is very likely also able to support Extended Key ID is
Compatibility mode.)

 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 16e052d02c94..cbabb784decb 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -509,7 +509,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath_key_config(common, vif, sta, key);
+		ret = ath_key_config(common, vif, sta, key, true);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
-- 
2.20.1

