Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B15C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CCFB2145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="zBBzNplC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfBJVXc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:23:32 -0500
Received: from 17.mo6.mail-out.ovh.net ([46.105.36.150]:47571 "EHLO
        17.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfBJVXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:23:32 -0500
Received: from player730.ha.ovh.net (unknown [10.109.143.225])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id EFB3D1AD0A5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:47 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player730.ha.ovh.net (Postfix) with ESMTPSA id B5F17272F50B;
        Sun, 10 Feb 2019 21:06:46 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832805;
        bh=/If4cTKzuDwGDSb1kFFnFj9z9C7qva1zD++P8+lumTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=zBBzNplC0KtS2DawTz1hlE54WFzPdHyXOV6p4eiepS+droDlR+pW68A8hSKem6Ok4
         lM1KDaoNqHd+Zu3iv0z9X7i0BP3RvJ3/oe6o4wnqS0MTpdwho8RapmUznBN6qB2fnb
         LIfpfQGjiiOkaZdgVp9so45LKcw/FntdCn88Z6Bc=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 08/12] iwlwifi: dvm - EXT_KEY_ID A-MPDU API update
Date:   Sun, 10 Feb 2019 22:06:16 +0100
Message-Id: <20190210210620.31181-9-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549400655381142727
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrledvgddugeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When using Extended Key ID mac80211 drops @IEEE80211_TX_CTL_AMPDU for
the last packet which can be added to a A-MPDU in preparation.

Don't throw a warning and just handle the frame as if
@IEEE80211_TX_CTL_AMPDU would have been set.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

I cold not figure out so far how to make sure the card will not mix
A-MPDU frames. Looks like that is handled fully in the HW and I didn't
find any interface to influence it. (It even may work already, I have
some problems to capture A-MPDU frames with A-MPDU information intact
and the topic was pretty low on the list so far. After all it works...)

This patch is therefore basically just using aggregation when it's
enabled and ignores the key border signal from mac80211.

 drivers/net/wireless/intel/iwlwifi/dvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index 4ff323a3a4e5..478f8e1c3e52 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -420,7 +420,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (tid_data->agg.state == IWL_AGG_ON)
 			is_agg = true;
 		is_data_qos = true;
 	}
-- 
2.20.1

