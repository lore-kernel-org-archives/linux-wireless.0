Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105333DA7EC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281235; cv=none; b=hQtsnR+BBcjgzJ9BRdPp5pmTcnX13Gll40tBlKQmJIVIfDIBGRHDRwmFblFyyNs7s0Ieii7yA7A28wUByn9mcvwn5L/ksRyXlz2CUNFg3+hUfkE6FsU8GGorVHi/CR7QoNtpxq3lM+ms9FdNP4WLv5sDfAPybSb0JyDxhf+scVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281235; c=relaxed/simple;
	bh=3bDhUTJKj90rEnT8frpOetJ2AHmtUPrgI+XLWesPLRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twAa3ioS4SXPNj/RgeYcFBaw/aA4rde+UmXePl0fFH9xmJiLPoIm4npM0dVBcf3tTpsVShvLENTG6uJzua1mqFWrobomiDDZCpK0JpZNji5ukoO9KJa96XVQLqHXeKxP0kqdxdcYTLtdo83uo8UdDYs4XDLEu7XVdeNqLxB5RdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lFu4Bk00; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lFu4Bk00"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hlsg5n2il3KN3I5Os5Exx4IKXikKeCGEkRLGl5VIFd0=;
	t=1791281233; x=1792490833; b=lFu4Bk004e/gni4CzhlpLlD9dP32wcBsW1/mK8iwbYx3voq
	C2gfdBs/ntr1yCfugPo1wzEd3Ez1tRh9Wubmjks1QdD1Cv3/YgRyFcLfV1NdupPsJDFSS4CjfZyBW
	VvYXYPlxz3ubBwFmhzuecUpZLDZMZGi8SJYmi8YcjZl/Ex1J3kZPifxacwz22R+OmcVRk3pRcBSca
	CEPsO8539LqDuvAPqLps3LETNJHiEvMufEbCZ3xtkEE1fGnapN2jCwqHVFET+C4TJxPICFkja44PX
	pmAWbenq5sD4ri7ckc66hU0wq71EThJcCUzmWkpG9LyJdCWbjf1mv96SJd7aRCaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24j-00000006XqW-3Al6;
	Tue, 06 Oct 2026 12:07:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 10/19] wifi: cfg80211: document wiphy mutex for radar/CAC events
Date: Tue,  6 Oct 2026 12:04:08 +0200
Message-ID: <20261006120655.6fba1ce72650.I57002ac3e57d2ac4613eb0cb0e6d17bedccf0cbd@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The DFS state of channels and the CAC state of the wdev is
protected by the wiphy mutex, so the radar and CAC events
must be reported by drivers with the wiphy mutex held. In
mac80211 we do this, but some drivers don't yet:
 - mwifiex/nxpwifi have an event handling worker,
 - qtnfmac also does it from event processing, and
 - mt7915 and mt7996 don't acquire a mutex for background
   radar events.

Document the requirement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c6a606b6b26f..458c474d416d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -9808,6 +9808,7 @@ void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp);
  * @gfp: context flags
  *
  * This function is called when a radar is detected on the current chanenl.
+ * Must be called with the wiphy mutex held.
  */
 void __cfg80211_radar_event(struct wiphy *wiphy,
 			    struct cfg80211_chan_def *chandef,
@@ -9853,7 +9854,7 @@ void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
  *
  * This function is called when a Channel availability check (CAC) is finished
  * or aborted. This must be called to notify the completion of a CAC process,
- * also by full-MAC drivers.
+ * also by full-MAC drivers. Must be called with the wiphy mutex held.
  */
 void cfg80211_cac_event(struct net_device *netdev,
 			const struct cfg80211_chan_def *chandef,
-- 
2.55.0

