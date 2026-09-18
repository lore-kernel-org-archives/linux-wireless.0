Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D500A394794
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751899; cv=none; b=KqKDttlUxMZzgBJrdhzpFFtUNNAXQwipYgO0QaxyeX0CkLqLkkM4OV4gUyBI50zZAc7CEl59N3O+H5ikhC7RzIuAG9YPJJRAezjRTfGs8PtSxB6hl6ZU4kc/awNctgAwH/1cDfLtP9ChsDZaPicMeY5v52ndEBLFektm2FsWST0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751899; c=relaxed/simple;
	bh=WhEDno9xPRB3OJui3pgXo4nsMBf1p9ql7z9BcTq53JI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qs8rOfyNdDWIb+6t/Au7biJpw8lMR8cfBPQrarsIk6/XDPBQM2wBrDL8YytmBVZ++4/G+voRoqUdxm22feNq1Yrg+F8sPu+o6YSGTR6pffKhdcSoqrsytTXUL4M/XYfnqnoSkG+etrZNkp3tR52SvY9/J8aTCjrNoFAV5ML9/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=qHins6es; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="qHins6es"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9C572B8007B;
	Fri, 18 Sep 2026 17:18:09 +0000 (UTC)
Received: from pk2.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 0D1A913C2B0;
	Fri, 18 Sep 2026 10:18:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0D1A913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1789751889;
	bh=WhEDno9xPRB3OJui3pgXo4nsMBf1p9ql7z9BcTq53JI=;
	h=From:To:Cc:Subject:Date:From;
	b=qHins6esSxJDQ9u1xUH16RqYqothRgSj3jlC5x7Q2I/iARcyfGvOJTkcz7oW/F2uw
	 9JFD/IH1khTL1Jiox2sSMW9aBpn3aGhFkPZZsHrcRdSlbZXJ/mlcpwWerryJoG+W5+
	 tDUcS7wkxlYE8gbonb8gycBwJ/52TYPXQe0vwenY=
From: Rory Little <roryl@candelatech.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Dylan Eskew <dylan.eskew@candelatech.com>
Subject: [PATCH wireless-next] net: cfg80211: Validate monitor channel set against radio usage
Date: Fri, 18 Sep 2026 10:07:46 -0700
Message-ID: <20260918170746.3824-1-roryl@candelatech.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1789751890-Za569ErfUrBa
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1789751890;Za569ErfUrBa;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
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
 net/wireless/chan.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 1071e823108b..e417649a543a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1810,13 +1810,38 @@ bool cfg80211_reg_check_beaconing(struct wiphy *wiphy,
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

