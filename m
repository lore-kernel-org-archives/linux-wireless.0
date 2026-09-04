Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C345E4CB8C9
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533851; cv=none; b=kNgxQJDBVTdmqeqo2fIeOrXstJsx73soJCCDOnY3UE8kNqiyg8qEPdJmX36H8/IQmKwqrJ9BHmm6FLq73tla9TQ3VerkWzSkDgaqwYwJDTp29/EC+5JRPAViym6oLyRn2737FAkqc6l3quQs8RkJ+MI7iXab5CeALq35JLYsf+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533851; c=relaxed/simple;
	bh=FrsHHn4H+x5w1fKuIBtRtwtHqkPbedGJovFBbcbWwtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5gcXicGdOQ9NjS53SdLZ7p+7pUd15xdy7C2RX+4oRmy/AqyoZN9e3P+/uKOr/DAlrQGETIGvC4xCD/ck/Gt7kGatK+OZOGbBMZFBzgD99BC0XcyB5qpL/QtueFY3UFkgDywLLt3944OsNPNxHo2nq2DTpztKpKyxRsRUvNQIQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TVAwCSJn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TVAwCSJn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=l1Yz+vUmuBgisND4Q0B3oWadkl+NeoyjiAXhzMYaeSo=;
	t=1788533849; x=1789743449; b=TVAwCSJnM5dHtRABDXqLd5S9CMWzf8WDhoCEjVml6iNax8f
	Njfs7EsCe2YuRof369Op2afpiSF8Td6PIeNu7qaGQtr7rZRdREHRHy9ipMIb4ShozQ7IlRMFSWbdB
	WOxrIaHcq5cQWxPJ8DboMcjhmNC4dX45ZWLpkzEHu8J6e1viIjZ2z3CFitbbta4KOU7o6j7v2J5zi
	P60m5CVHm7Rf9suv70vzwDzHIO5Zd5ZdCW6eCAW36z+svX4aG8cpGkVnBGU2l+K6W8W6GrlvPMUBL
	dbcpNFkQLBzWssh3aJrZ7WJKahXSx/0UsiJDqIJQlNsEPoD9d2v8euzPnNAzCwOw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VM6-00000001SWk-2Yu1;
	Fri, 04 Sep 2026 16:57:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+0d516b33238bd97ee864@syzkaller.appspotmail.com
Subject: [PATCH wireless 02/10] wifi: mac80211: don't drop scan probe requests for lack of peer rates
Date: Fri,  4 Sep 2026 16:57:06 +0200
Message-ID: <20260904165722.b57ea4ab82d3.Id6c9c42d5cef5901bfac88853647b03ba4077b3e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

While software scanning, ieee80211_tx_h_rate_ctrl() warns and drops the
frame if the target station has no usable bitrate on the band that's
currently being scanned.

But that's really meant for data frames, not if we happen to scan for
the BSSID on the wrong band, which can be constructed easily.

Skip the check for IEEE80211_TX_CTRL_DONT_USE_RATE_MASK, the previous
commit also ignored the station rate mask for such frames as well.

Assisted-by: LLM
Reported-by: syzbot+0d516b33238bd97ee864@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0d516b33238bd97ee864
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3896c7b2c4e5..d155fb319a55 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -744,10 +744,12 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		assoc = test_sta_flag(tx->sta, WLAN_STA_ASSOC);
 
 	/*
-	 * Lets not bother rate control if we're associated and cannot
-	 * talk to the sta. This should not happen.
+	 * Lets not bother rate control if we're associated and cannot talk to
+	 * the sta. This should not happen - except for frames that aren't
+	 * really for the peer to start with and already ignore rates.
 	 */
-	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) && assoc &&
+	if (!(info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK) &&
+	    WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) && assoc &&
 		 !rate_usable_index_exists(sband, &tx->sta->sta),
 		 "%s: Dropped data frame as no usable bitrate found while "
 		 "scanning and associated. Target station: "
-- 
2.55.0

