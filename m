Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F4F4AA3F4
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150322; cv=none; b=Jz/Cd7uVfswRSWAz+kwX1sqn+jIl3w9tlHK+rVOiF6ZnLFbgjwmMxHS5PZcjLY2mCgOV1p+ALELQ3zXx2Fj4Ut15L/PIC4lcsnhpzdZCkb9KedwPJmiFHHlyMh70/D36X9unjp/J4Sh+tlsFIuqQOgzBMuN6aKiAghpyEBOPYSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150322; c=relaxed/simple;
	bh=4GfdX3Lih+R7jIIWxwCQYwP/xdVc3KCTyBqUyc+RFAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcArH0++Qmzb8TBlPQUnAoaSJy6uVN0hDEB0iPNNGRa+v/MmvuoyA21Gg1Vc8CRG6nnpCv76Z0sQzuqSjUNULxMCY3v5VTthWG+GR/3Td8Htu2Cts6ByhUYhDYZGTB9I6OdoeYDISEVAqJkrsh0mnO41Sc4DyWj7XQI+AVozkNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bwto6BBf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bwto6BBf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=g3WMjaJmUCRsfvNoXV0jOOjVUto/o9nZmr/q51nSvIE=;
	t=1791150320; x=1792359920; b=bwto6BBfcD/A21ZYu/qrvYuaLu7h00NrRuEy954nFVbBazO
	Diahqj2/harG+l4LjQ8q3X+dYU9tgc7BphKNpY6Ub/8TyBOS8WkP6i5Ohm/ucouMatlblvM9pWJ2K
	jH7v7H7YNOrXhyEgiIs2xJ4yKUaYFw0GbVuqtc2+6OH9bKkXY5asAZDt6OhwpKcprNyVgB+sYKKWS
	6XsHwfIoPeU6haZ2htGcC/Pt9hXNNZxdi3m9The8alTy02xjti/SvYJ+TOniMLOMMp/vrvG+KRNM1
	PBi39WhhPKBQC5KBkeLpQzrVEa5N1uxCVl5Oi/JVDtuWCzPHR2hoYZEIW7G3mtKA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU1F-00000004OqT-0mW8;
	Sun, 04 Oct 2026 23:45:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 12/12] wifi: nl80211: transmit control port frames without wiphy mutex
Date: Sun,  4 Oct 2026 23:40:58 +0200
Message-ID: <20261004234504.3e582737e279.I30d12968a0d4ab7a4ac8d0995a9ab7583b0ce2ef@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Only mac80211 currently implements tx_control_port, and it
no longer needs the wiphy mutex, so don't take it here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 1 +
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c33e31bea49..72f9ce3ad51b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5260,6 +5260,7 @@ struct mgmt_frame_regs {
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted. A @cookie
  *	value of 0 means the caller does not want TX status reporting.
+ *	Called without the wiphy mutex.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b8da2df8d9cb..92210b0de08e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21000,7 +21000,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_control_port,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
 	{
 		.cmd = NL80211_CMD_GET_FTM_RESPONDER_STATS,
-- 
2.55.0

