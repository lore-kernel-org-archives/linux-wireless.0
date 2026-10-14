Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905B63F484D
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006362; cv=none; b=LfTtJ7fGCP7NXoQBr7jiYbMOITuIlxJwkyAm531MjvrW1JC/j4/h8pvaKyNZU3ZUPpsSl8wAWh7OOkswqgGCTOIJrxTojDTJ+UkpaAl8m6CY4LyxoaXSzmbEwSan4hIedbY9NqFfnPkb3mPApmAVwv3okkJBeEntoPhK7nOXFvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006362; c=relaxed/simple;
	bh=hjVUvoadc1WXb2Y/0jzNyZH3BzBuyPlGV4lPvt+dOjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIDoXKsYofWwtKfsXa2Uth+42UfiWa5a0hXYZp1o+iP7iG0VZJstRBAPef25FDrgcYLKyAD6cIMsumwTmtxk7bJLT2cPF3TQDhC4E2Tg2IU9g31vSWv/g79WH4AN6NlCOoTHZFdWkEJ+cRoyxF/l8rtcdOduZCdXTZoYAIPuPFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=mtT1Mjo8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="mtT1Mjo8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wKXDwplybO+VDUoYYOS8jUiLCy+wtOMJ/VzuLuhGE80=;
	t=1792006360; x=1793215960; b=mtT1Mjo8y5o9jzmuC0ikpxW135Lymf/jV3TeM7ftCA9xzfX
	xXjBrk26i8dSYoK2UZMw/zgl+R2VqIo5edP1vvbPR8+te930T+J7k6cu/cVzsbgjZIgukZziciPUz
	Eoz7USwuMSLM6+ABJLMYP5cXC+2UjXzgiDAZceSTxuyvqNyMlqcPsCGH9vuZo0i0JYNWEWSd7gilA
	BXq4dolOMDc5D7I4WtyZtTCLzcymFsbqr8itOmItrQSnNX+D1djlvA4Gapn190G0JgAj+2fsKT2C1
	EvTSiuwKT+O99ImPgdVtLo4Dw2D7COI542fBt6z68b/apvKzzHRRl2g6qBANQtHw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xH4iL-000000020zZ-0wH6;
	Wed, 14 Oct 2026 21:32:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 2/4] wifi: mac80211: don't synchronize for key tailroom
Date: Wed, 14 Oct 2026 21:30:32 +0200
Message-ID: <20261014213231.ae3ae093e5b7.I2c30a5d220d65f64a6ef9b8c82b4cc2af72d24df@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014193231.886495-6-johannes@sipsolutions.net>
References: <20261014193231.886495-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When crypto_tx_tailroom_needed_cnt newly indicates tailroom is
needed, we currently flush the TX path so SW crypto never sees
frames without enough tailroom. This can be expensive when new
keys are installed, etc., and while it can be improved, doing
so would lead to quite a bit of complexity.

Since the previous patch the crypto code just expands tailroom
in the (unlikely) case this race happened, so we now no longer
need to account this as carefully and can remove the waiting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d32c61a90d93..6904b519ef37 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -75,36 +75,10 @@ update_vlan_tailroom_need_count(struct ieee80211_sub_if_data *sdata, int delta)
 
 static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 {
-	/*
-	 * When this count is zero, SKB resizing for allocating tailroom
-	 * for IV or MMIC is skipped. But, this check has created two race
-	 * cases in xmit path while transiting from zero count to one:
-	 *
-	 * 1. SKB resize was skipped because no key was added but just before
-	 * the xmit key is added and SW encryption kicks off.
-	 *
-	 * 2. SKB resize was skipped because all the keys were hw planted but
-	 * just before xmit one of the key is deleted and SW encryption kicks
-	 * off.
-	 *
-	 * In both the above case SW encryption will find not enough space for
-	 * tailroom and exits with WARN_ON. (See WARN_ONs at wpa.c)
-	 *
-	 * Solution has been explained at
-	 * http://mid.gmane.org/1308590980.4322.19.camel@jlt3.sipsolutions.net
-	 */
-
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
 	update_vlan_tailroom_need_count(sdata, 1);
-
-	if (!sdata->crypto_tx_tailroom_needed_cnt++) {
-		/*
-		 * Flush all XMIT packets currently using HW encryption or no
-		 * encryption at all if the count transition is from 0 -> 1.
-		 */
-		synchronize_net();
-	}
+	sdata->crypto_tx_tailroom_needed_cnt++;
 }
 
 static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
-- 
2.56.0

