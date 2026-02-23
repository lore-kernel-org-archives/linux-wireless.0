Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D873F36605A
	for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2026 12:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850453; cv=none; b=mw2qxFt3LrIKTBVUeByJ0GnAungkpbIOhb9ZUwaM/7KYtSg91xsQYwH/okGU19XNO6LEuqhwNXdRX979X3qR1hox1MAXnUVO3TkWk/7hoyF0u+7QmHt+ZxC/aURhoR/w43VDejLBclQFTN13Gtk2BO9ejw0TPFqDcN82uL3JUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850453; c=relaxed/simple;
	bh=T40Fao1wt2/vPCOPTTSrVpi8mOZkVgUzCU051wCxHpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0e7KRwxv7xi+QlSe4LlC/3kYO+iDUUkZungxU2k918uqHSwvNkSByq41zppqOHi7sNOVUfsThEQBH4CdzncTdys1Ktq5uVlWFUpwM/pni4WIcIJnzImBqonGicspNo4wIW82sAG1Ji2VdWD1Iagypjh2jrDDctE1IBx3ZvG980=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=M2EJCugt; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="M2EJCugt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=opwHMjlSHbdbIsgGkM9Ren5B7zE7qk3j2yyT1zXi+R8=;
	t=1771850451; x=1773060051; b=M2EJCugtCirZw7W7aq5ZIR60+xIfq/x8PIemVXTRAAcsKuY
	TJXeh5D0DNXKwqmIWZXGnrMFEqKoxdZoXJVt6MZLWVvMX6FRCYaKRLW6KxVkjtKO4+KViMokAZ7Cp
	BhKFPZFXyMngkzfnwG/k2qKqlkXxzfXLPp83eNuS5mjkY8DHBOygCybtafi1Z35QzwA9kAKG1K4+M
	QamL/dUh3N25bLCdpnM2Y2/zuz+h3osj8BzVGGuEdUYaLTdlxK4RvnTWyC7A3XJ22du0aZHPHz73q
	akXRtkhTdINmpV24BqI8A5yApu+gcEnB4WMPCnyXJfyBOimSZjSklYvSDvM2o5lg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1vuVF2-0000000H2xI-495N;
	Mon, 23 Feb 2026 13:40:49 +0100
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [RFC PATCH v2 6/8] wifi: mac80211: report to cfg80211 when no STA is known for a frame
Date: Mon, 23 Feb 2026 13:38:25 +0100
Message-ID: <20260223133818.276d9af5badd.I28d8146b9189c5961411ecb26b44588895de1b56@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223123818.384184-10-benjamin@sipsolutions.net>
References: <20260223123818.384184-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This is relevant for hostapd to know whether address translation was
done on a received management frame.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d76e8ee1a607..ec718b7f3e16 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3948,6 +3948,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.len = rx->skb->len,
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
+		.no_sta = !rx->sta,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
-- 
2.53.0

