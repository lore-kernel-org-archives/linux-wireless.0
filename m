Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AEF4E8DFA
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534106; cv=none; b=DMSZS1ItpW+ugAWBuq8Yht0KjSacAqWCLe0ZNYsvnP8g1YRg/V0gBjUlQMcc1SGZseb6Qwa/PWyIeEEpSM5xYA49qxZYwQLBsbst5uplOaRzZEAxgPsO4J/ebdbQX8LlM2wzQs9HR9YXIXyeYHa4uiAnyaH/ssXwdxLeJ2Y5vAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534106; c=relaxed/simple;
	bh=jSyrYX8rYLg2czcVqgxE2zORPbGKYb4bpb0lJxcBTPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dABHLgZ/XhePbRA/JmI9x5QgIzUal60ljLTpXsWbWGMye9jH8ElS6leawb4tkO0fdkrPp6g71SNDMJnfSGAr7gb+DuHpH62CAccrR2gAkptyhxXW6jLkgP2wGbxoxufLWlbVs5DryxhMmw0iw8JPDcd2QnIuPpSoUIT79lZFJAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kVrfEF5d; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kVrfEF5d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=/dpoLMXNRrwnKqll2sjYtT+Vx1EbtW/6EK/cov3vlC8=; t=1788534105; x=1789743705; 
	b=kVrfEF5dHSZ9SEn8jN1YZG3l3+WZAILdrnqwKLN+OFrkHoawe1kFarCDrlmle/vPvDhDTls9fCQ
	kg9+M6XKHw5PERBbx05yDIhCYOkolGKur63ldo3ZocAybwfi0uHj0kmToeFEU3ooj6vwViJ3ktD5o
	rVK9sG3oF7PRHsRZo/HYtQxLi07ig6w+U3nE9IXRaaB0ypfsPtkyeK+bB1g7h9jX65Trpwk09Hdcz
	HfsypTcnuHKAcYj5CiU6JnBOA+T7fXPhQEcLRHPGUdxDVxzOFGrRHt0HW+xS9WmAlvMne3MNetay7
	z/zi3u6GpPDpgtJ7aQ0+059BNwKZ62wSnChw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VQE-00000001SgC-0toS;
	Fri, 04 Sep 2026 17:01:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com
Subject: [PATCH wireless] wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping
Date: Fri,  4 Sep 2026 17:01:35 +0200
Message-ID: <20260904170140.5f69a10d606b.I4a7921d00643f69e439c7a3b221d104f66a3dcdc@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The code checks ->started for frames coming from wmediumd, but the
radio can be stopped after the check and before frame delivery,
causing mac80211 to hit the WARN_ON(!local->started).

Expand the mutex for this case and synchronise against it when the
radio is stopped to avoid being able to hit the warning with hwsim.

Assisted-by: LLM
Fixes: 7882513bacb1 ("mac80211_hwsim driver support userspace frame tx/rx")
Reported-by: syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b4aa2b672b18f1d4dc5f
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 .../wireless/virtual/mac80211_hwsim_main.c    | 33 ++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..7703d31d35de 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -2327,7 +2327,12 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 	struct sk_buff *skb;
 	int i;
 
-	data->started = false;
+	/*
+	 * Serialise against wmediumd userspace, so no more frames
+	 * can be handed to mac80211 after this returns.
+	 */
+	scoped_guard(mutex, &data->mutex)
+		data->started = false;
 
 	for (i = 0; i < ARRAY_SIZE(data->link_data); i++)
 		hrtimer_cancel(&data->link_data[i].beacon_timer);
@@ -6535,10 +6540,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 			goto out;
 	}
 
+	/*
+	 * Serialise against mac80211_hwsim_stop() - mac80211 doesn't allow
+	 * frames reported while the HW is down, hence the ->started check
+	 * must be under mutex.
+	 */
+	mutex_lock(&data2->mutex);
+
 	/* check if radio is configured properly */
 
 	if ((data2->idle && !data2->tmp_chan) || !data2->started)
-		goto out;
+		goto out_unlock;
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
@@ -6557,22 +6569,18 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		iter_data.channel = ieee80211_get_channel(data2->hw->wiphy,
 							  rx_status.freq);
 		if (!iter_data.channel)
-			goto out;
+			goto out_unlock;
 		rx_status.band = iter_data.channel->band;
 
-		mutex_lock(&data2->mutex);
 		if (!hwsim_chans_compat(iter_data.channel, channel)) {
 			ieee80211_iterate_active_interfaces_atomic(
 				data2->hw, IEEE80211_IFACE_ITER_NORMAL,
 				mac80211_hwsim_tx_iter, &iter_data);
-			if (!iter_data.receive) {
-				mutex_unlock(&data2->mutex);
-				goto out;
-			}
+			if (!iter_data.receive)
+				goto out_unlock;
 		}
-		mutex_unlock(&data2->mutex);
 	} else if (!channel) {
-		goto out;
+		goto out_unlock;
 	} else {
 		rx_status.freq = channel->center_freq;
 		rx_status.band = channel->band;
@@ -6580,7 +6588,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
-		goto out;
+		goto out_unlock;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;
@@ -6590,10 +6598,13 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		rx_status.boottime_ns = ktime_get_boottime_ns();
 
 	mac80211_hwsim_rx(data2, &rx_status, skb);
+	mutex_unlock(&data2->mutex);
 
 	return 0;
 err:
 	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
+out_unlock:
+	mutex_unlock(&data2->mutex);
 out:
 	dev_kfree_skb(skb);
 	return -EINVAL;
-- 
2.55.0

