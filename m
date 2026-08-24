Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D38E17B418
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787531828; cv=none; b=N9SpYY4nhap0mirCBowjpM4Wn8ShrZTzExr+rFP1WXoXFXLT6GP4kWVIUNrPMMyunBKsLlXtttBqz4VHvEeyo8h7dICMplTCdgsIz2T3aNUrLMxziigodt16eR6eMK3BO0HMxfu8W1XSnbrE1htvqJln/NjBBzxAsnOSZ5APZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787531828; c=relaxed/simple;
	bh=uoWdwa3RpAwzJqIgRTFihUod/33vvbItb8N4Mvr8jJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WpqLgp2whh7t6UKfhsgodmEwH8/fFq9R1lXcvB8gq+B6zuNWFXXm72mVAWxFZUmuCCl+n1LDCf3hSbVa5LNxZZxUZF5jO4FYIwvfQHoHyRdmeu/+/fjB1c3/diHKdOd+5BUTNL9fvAwyhCQLSxjQApqFWDri7R5/UXR+nmku0Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=byuKYtX8; arc=none smtp.client-ip=91.218.175.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="byuKYtX8"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uoWdwa3RpAwzJqIgRTFihUod/33vvbItb8N4Mvr8jJg=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787531822; v=1; x=1788136622;
 b=byuKYtX8W1jRM9AcBRX0ABnvtxPaVU4Ewe3+wlE+IoMAknQiNUzQ1aDa5KUVq8BRmbBOYj+w
 YKn3meyMq8iF7g5SFZiIttPRLBLNEJQgIrvOM5cRoUosNVt2d2vTuWSoP5CYAAtoDKosVZHuq1e
 d7XJC4/mBPgw0aWn6RBNINcx151n8bk+22mJpsWQJA1DS4yrZmQEOIIuwEkn0r57eHoS/+O2xaV
 03nD2uGqd4QJFlKadpnziO0rZfC2mmjh4BuIWntFfUV2NedOZa6SiDq2cgFwP+IQYNce2IIqMcz
 a5XCIYKpljIaM6ifmj0BVrhswBgdrMTbPHGOgSmpSwwdw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 63ef895034ec1925;
	Mon, 24 Aug 2026 00:37:02 +0000
X-Mizu-Trace-ID: 63ef895034ec1925
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: refuse to make a monitor active when it has no queue
Date: Sun, 23 Aug 2026 17:36:56 -0700
Message-ID: <20260824003656.27049-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 8105f9b8a887 ("mac80211: allocate TXQs for active monitor
interfaces") reserved a TXQ for active monitors, because drivers using TXQ
expect every interface handed to them to have one.  It covers only
interfaces created active: vif.txq is assigned in ieee80211_txq_init()
from ieee80211_if_add(), and cannot be added later.

MONITOR_FLAG_ACTIVE can still be set afterwards.
ieee80211_set_mon_options() refuses that while the interface is up, but
while it is down it just stores the flag.  Such an interface then reaches
the driver with vif->txq NULL, and ath9k resolves its multicast node's
tids through that pointer unchecked:

  BUG: kernel NULL pointer dereference, address: 0000000000000066
  RIP: 0010:ath_tx_node_init+0x49/0x170 [ath9k]
   ath9k_add_interface+0x10c/0x140 [ath9k]
   drv_add_interface+0x54/0x250 [mac80211]
   ieee80211_do_open+0x32f/0x800 [mac80211]

Two commands from a user with CAP_NET_ADMIN reach it:

  iw dev <iface> set monitor active
  ip link set <iface> up

The fault happens with RTNL held, so it is never released and all later
netlink operations block.

Refuse the promotion when there is no queue to give.

Fixes: 79af1f866193 ("mac80211: avoid allocating TXQs that won't be used")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Reproduces on mac80211_hwsim, no hardware needed: create a monitor, take it
down, make it active and bring it up, and the driver gets a NULL vif->txq.
One created with flags active gets a real one.  With the patch the first is
refused, the second still works, and an interface created active, set to
none and back to active, is still accepted.  Same on an MT7922.

Only drivers advertising NL80211_FEATURE_ACTIVE_MONITOR reach this, since
cfg80211 refuses the flag otherwise.  ath9k, mt7603 and mt76x02 deref
vif->txq unchecked.  mt7615, mt7915, mt7921, mt7925 and mt7996 test it
first.

Where it faults today, refusing costs nothing.  On the drivers that check,
I could not test whether a promoted interface actually works, so that is
where a regression would show.

Reserving a queue for every monitor instead would make the promotion work
rather than refuse it, and would also cover a passive monitor reaching the
driver under NO_VIRTUAL_MONITOR.  That undoes 79af1f866193 deliberately, so
I did not assume it.  Happy to write it if you prefer.

 net/mac80211/cfg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b6163dcc7e92..523cef0a5526 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -115,6 +115,15 @@ static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
 			return -EBUSY;
 	}
 
+	/*
+	 * An active monitor is passed to the driver and needs a TXQ, which is
+	 * reserved with the netdev in ieee80211_if_add() and cannot be added
+	 * later.  An interface created without the flag has none, so refuse to
+	 * set it rather than hand the driver a NULL vif->txq.
+	 */
+	if ((params->flags & MONITOR_FLAG_ACTIVE) && !sdata->vif.txq)
+		return -EOPNOTSUPP;
+
 	/* validate whether MU-MIMO can be configured */
 	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
 	    !ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR) &&
-- 
2.55.0

