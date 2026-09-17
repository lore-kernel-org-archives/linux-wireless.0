Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33BF48FF9F
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 22:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683669; cv=none; b=hk2uU4iztNIREhFDCw3G8hGVUYztYDjMHlIvs947hfJAPLRq5/VhntfLFL1rQ+x+GTwpOdmlN4/6ilDyuy9xhmOq84X9pTj3ZfSE6MEbL19W/RGl0m+y0o7c47ByNTXnd8AmOvX/GUnfsukIWkfUQ0H/fVdkuiD8WkxXdNuFBTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683669; c=relaxed/simple;
	bh=WhEDno9xPRB3OJui3pgXo4nsMBf1p9ql7z9BcTq53JI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jSfQ9mUjR7mKoOIS5sWLR+MoP51hkTcpMAxYK8Wybm6K8pDUcof3lOAca297TqCP2fmB8LF5XGRHJhLLeqqf+PeODJOXsUEUv4/EW+uxbT/NhjYV6/BJiCv4LlEtx3A09MfgEHG1XXGjChYAC3/FcSO0gDrJq0kmcnuXzwpBs5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=bA39qMPc; arc=none smtp.client-ip=67.231.154.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="bA39qMPc"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6AA7E3C0071;
	Thu, 17 Sep 2026 22:20:58 +0000 (UTC)
Received: from pk2.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id DCF2713C2B0;
	Thu, 17 Sep 2026 15:20:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DCF2713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1789683658;
	bh=WhEDno9xPRB3OJui3pgXo4nsMBf1p9ql7z9BcTq53JI=;
	h=From:To:Cc:Subject:Date:From;
	b=bA39qMPcnlHKhMuelZ/BptFHYeKVtXZUfw18fy8x/DajcN76vNYdwlziUmog6DY1b
	 3e7TYgxV+QEDFHrppFT3P5X6AxV9RmB34dDuFai4C34oCCzZR80GxU4GSxLUkhhGcC
	 rvwvg2TiPWtmcW1tsbil6dSrBu/30ecO6mZj6a80=
From: Rory Little <roryl@candelatech.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Dylan Eskew <dylan.eskew@candelatech.com>
Subject: [PATCH wireless-next] net: cfg80211: Validate monitor channel set against radio usage
Date: Thu, 17 Sep 2026 15:12:05 -0700
Message-ID: <20260917221205.3214125-1-roryl@candelatech.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1789683660-mgSu3DuUfCIi
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1789683660;mgSu3DuUfCIi;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
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

