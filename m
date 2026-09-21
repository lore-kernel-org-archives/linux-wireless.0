Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63129509EE2
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 21:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025308; cv=none; b=LIon1kiyzBNMdomvUILyiQT6x8IkHnFMdqZNPBwRO0/J2aw9hhmG8RtQ2c1S5s1Qp80IFfwEXC6/kIMaSLn1u8j7/Tc4bBYecygxMz7c0hhxHk7TI4uB1YKSgP52AxvRZycC0oSsKZquNcrMZOdM56TlDAD989QtIPLKSn5UQ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025308; c=relaxed/simple;
	bh=+CwN2g+1OMulAJY6XERJUvij4x7VubOxld1Ljbvmgbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IglPW7Xzlj8qw5WHDLzb2gKaGZOTAy4sfMcUVxbDr5Or3atiRXahd6NPuPwueqxaXE89o9WR7TnaYkEsMdc19ktxRTeki+QWdR3hx++crug9yRtFMCqMH8sjZ8PD6XHoZZLZAW9542zLTwT79R7t9rBQheTDAsOFb+rVEsvZ5wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=RStj/sJ4; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="RStj/sJ4"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0234D10006B;
	Mon, 21 Sep 2026 21:15:02 +0000 (UTC)
Received: from pk2.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 5E55E13C2B0;
	Mon, 21 Sep 2026 14:15:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 5E55E13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1790025302;
	bh=+CwN2g+1OMulAJY6XERJUvij4x7VubOxld1Ljbvmgbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RStj/sJ4duyKsY/1sU+FApbV7YFppf1ttX7pr6WSqgiQdREUdXufwThMCrcz92MDY
	 PHmM4t8OJQ2h6PphE2MSMvI0dUjmxAi4sPOK2EOLRJV4e1v+n1AGaXFeRQTdQz7cgU
	 X62Hvrz13yp7Y5+BwihfSUiANZuGqXgZpA3SJ400=
From: Rory Little <roryl@candelatech.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Dylan Eskew <dylan.eskew@candelatech.com>
Subject: [PATCH wireless-next v3] wifi: cfg80211: validate monitor channel set against radio usage
Date: Mon, 21 Sep 2026 14:04:41 -0700
Message-ID: <20260921210441.3137-1-roryl@candelatech.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260921184605.2699-1-roryl@candelatech.com>
References: <20260921184605.2699-1-roryl@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1790025306-L1zDhCn1_nDx
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1790025306;L1zDhCn1_nDx;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
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
v3:
- Reject case where no monitors are running
- Add clarifying comment for radio_idx error path
- Actually fixed subject line

v2:
- Handle error return from cfg80211_get_radio_idx_by_chan
- Fixed subject line

 net/wireless/chan.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 1071e823108b..c743b6fb7e30 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1810,13 +1810,44 @@ bool cfg80211_reg_check_beaconing(struct wiphy *wiphy,
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
+	if (rdev->num_running_monitor_ifaces < 1)
+		return false;
+
+	if (cfg80211_has_monitors_only(rdev))
+		return true;
+
+	radio_idx = cfg80211_get_radio_idx_by_chan(&rdev->wiphy, chandef->chan);
+	/* No defined radio covers this channel. Fall back on global behavior */
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

