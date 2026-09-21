Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B64B44AB
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017020; cv=none; b=P6b2Ynx+jfMbQdXpCvDJixKMeRA/qTR2yrr6R44+Xgu1gDXkLQwTcfr/V7i/AJPvFRyM+r3mqqEDbZAKSAi64fY4x7d5P6HIMk7RD0WyDeST8Bl4jNlNRjLH5qjIvd38Yiu0QQjHcmeImt8C0bdur9lQrQ24Acqt438Oxh923Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017020; c=relaxed/simple;
	bh=zuusXg9o13clWE6/go6vST75nAzLS737roh2Pcoa5i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiERDMHbCzdstjpg0RtPxeDfHIRtDOXHj5XebcCbH6c545gRjrgy87MrAy5xaT0+tfUoV0F2Cu4r4AMJv1Pgmk+HxONHoOs2n2NcVLcs+SYzfDQdUXI/1OG1elq09dfRoAdNkz7LRdisI0P4uIuKFpKBd7AWPtCN2DlNVsPwH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=Qfzm40+l; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Qfzm40+l"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B3A0244008C;
	Mon, 21 Sep 2026 18:56:49 +0000 (UTC)
Received: from pk2.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 0CBA113C2B0;
	Mon, 21 Sep 2026 11:56:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0CBA113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1790017009;
	bh=zuusXg9o13clWE6/go6vST75nAzLS737roh2Pcoa5i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qfzm40+l+bbmGTWoVE1D3jxB6T3yNwCqVxLOr+2e7w23k6RDPwVfIit5FgvtNwLE1
	 pAoiV0Rk8aiFxVl2CVkjshW1XRSmwBX+fi+hHxduT9+vsPT8iWyPY2JFBHXSvNhpWT
	 jxe6LDQyiX6oG2P5l4yHACs3W0mZe8qZ2TPCUiWc=
From: Rory Little <roryl@candelatech.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Dylan Eskew <dylan.eskew@candelatech.com>
Subject: [PATCH wireless-next v2] net: cfg80211: validate monitor channel set against radio usage
Date: Mon, 21 Sep 2026 11:46:05 -0700
Message-ID: <20260921184605.2699-1-roryl@candelatech.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
References: <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1790017010-Io0b6FpuVG-g
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1790017010;Io0b6FpuVG-g;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
X-PPE-TRUSTED: V=1;DIR=OUT;

Current logic only looks globally at interface counts to validate that a
monitor can have its channel configured. This works to ensure that the
wiphy is not pulled off the channel currently being used by another
active interface, but fails to allow for the case where the channels in
use on the other active interface and the desired channel for the
monitor fall on disjoint sets of radios.

Instead, search for any interface which would cause conflict, otherwise
allowing for the configuration.

Suggested-by: Dylan Eskew <dylan.eskew@candelatech.com>
Signed-off-by: Rory Little <roryl@candelatech.com>
---
v2:
- Handle error return from cfg80211_get_radio_idx_by_chan
- Fixed subject line

 net/wireless/chan.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 1071e823108b..679f1152ba65 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1810,13 +1810,40 @@ bool cfg80211_reg_check_beaconing(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_reg_check_beaconing);
 
+static bool cfg80211_can_set_monitor_channel(struct cfg80211_registered_device *rdev,
+					     struct cfg80211_chan_def *chandef)
+{
+	struct wireless_dev *wdev;
+	int radio_idx;
+
+	lockdep_assert_held(&rdev->wiphy.mtx);
+
+	if (cfg80211_has_monitors_only(rdev))
+		return true;
+
+	radio_idx = cfg80211_get_radio_idx_by_chan(&rdev->wiphy, chandef->chan);
+	if (radio_idx < 0)
+		return false;
+
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (wdev->iftype == NL80211_IFTYPE_MONITOR)
+			continue;
+		if (!wdev->netdev)
+			continue;
+		if (rdev_get_radio_mask(rdev, wdev->netdev) & BIT(radio_idx))
+			return false;
+	}
+
+	return true;
+}
+
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev,
 				 struct cfg80211_chan_def *chandef)
 {
 	if (!rdev->ops->set_monitor_channel)
 		return -EOPNOTSUPP;
-	if (!cfg80211_has_monitors_only(rdev))
+	if (!cfg80211_can_set_monitor_channel(rdev, chandef))
 		return -EBUSY;
 
 	return rdev_set_monitor_channel(rdev, dev, chandef);
-- 
2.52.0

