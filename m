Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011AC368D4F
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785093959; cv=none; b=cvIA8YpYGvUBR7dGrsN6eL+8JKRGU76PC8+AQEVjDrw/a7GuqI8OSwsryh412FGz4Up5fEH5bZR1TJeHi57t0DBUqcQjLwGMDjelGA9zhsee3uTvGYZPgkKTN/NR9cTwTZZo2H7y856I5oF2qMuMVlkbbJi8L9lI+5Pja8IQegQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785093959; c=relaxed/simple;
	bh=fYsYE/4pd//5zYUChMxbjn/SjznVltvAOaAi1g7yEcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ9IGnUGil8zrCfyjm0m0qIjzroWz7EFWTfw/CeRJvlgj7GpuGNd896U4LymV1URW6L7KmfEcx2AQMSot5lmMSzPHofuaaugF5fgVWkeX9BKuWr+zjy39WDE+b1qHR6ipn77x26ck33aj7ZkSYnb16ftImD1AgVH5gjVUtMnnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bCLuylef; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bCLuylef"
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7eb1dc6bd53so1148969a34.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785093957; x=1785698757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IdxVhr7EVeFJyQ3maQTqTGgQkmWNCzpHPWLQq6UcYic=;
        b=UCLJeIQFPzmbIovzNLDDgdeY9MUdb9tBBZR7xZgPUFQU3myayVllfLEWNK5KAQyIUr
         /+//pqm8OkTFyBUvSRcDgu8tbV1gUZ3BZ1QsmLfAEASyiF+tJP+Djo4Ce7GoVU3WS3E7
         akIq9+Wuu4WOrtd0+R28zglcIIo+yDZ4q3t1h5y+eoLvFkRCnyCOyu0/Mis6UP56Dmxs
         qXlwF1J1SEHDkB6RMDwNYZIkOQZAQ9eKt8XTaykSqhGp0vOnhFpnqkwVuzmcT+jORzFj
         QO21DnMq9cEIoXVykSwHww9UhX09FV0FOV9MW06XiIyUh5VGmgl8dxOk/jz0YHxFEIJZ
         Px0Q==
X-Gm-Message-State: AOJu0YwCvzwuB58njbKbjsyvJ4bigqweiIl8lqpdVs/Fs51vyJU6B0ew
	zKmhTioVsGBEbUkUUdAs29Mtu0tBj9SfD9C77fsV5YMXQg74XwNMMS3qV++qOxvCiqMhDxesEtg
	ALbP1xaDxlqO8Jdz31zun2/ZCqeK0xyYKwwcibbU8OFuWR8EhFDiX/qPjUqmP//o80Bp3QQ/oVS
	hWUcJTPzkcQGyxko2ppOlH+KJIX9e3hbgKaz6o0Jjkl98hefyOHQvIlM4fD+Zfo38n1r9HXh1dC
	YEGtUp/ZaVzHttWVQFxWLXmr9uh
X-Gm-Gg: AR+sD117S3iKbAqwSZESsdY56LifUuxiAyI3NbWeyNiE2rA2As31fUcJO3qAiFWS6PU
	GFhHzCwAn/SFLqN4p4CSLBSb4z6voxkEVIFbLIz6UuCcsn0SIL8awIWNUXex45BXNm8pLmIVK74
	ftI7Lof9lNRh0eDJMNWAYhqMJL0kXUZi+/DZGKQBFZGTvVBOp4e1kgPQNbxhnK8vVIgnR+CbUne
	Q0IO4hlj/mQxscNhGhmRMgaejC9RAx+f+r+8oyRd2C3cUJldtGhiGmyXBQsV0qaXs1eq/IT1q5g
	W6dPUwo+PAZOiZC0RQpapkPm8TIM7f6R2DEkcxCpKBCRL5izVZT9eBAMYOJBJWus96Gl0et30sX
	3AXejdSTTnIOW0zMScZu6OtIuaO3DxMf9gTOiGw/51eSg70rblco0+U6dypI8jYFKp6+Hv7RYcL
	SXVLymgwWLuZ2sZ9VdU+MhFDcSi6EU/jqhqN6FF9U=
X-Received: by 2002:a05:6820:f025:b0:6a3:7341:f6ed with SMTP id 006d021491bc7-6aaff7e91damr4302765eaf.1.1785093956756;
        Sun, 26 Jul 2026 12:25:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-457673b64d7sm1191717fac.10.2026.07.26.12.25.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:25:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cea6a46766so35320875ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785093954; x=1785698754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IdxVhr7EVeFJyQ3maQTqTGgQkmWNCzpHPWLQq6UcYic=;
        b=bCLuylef1UkSbpvdEkfHUpfMlpJSiqq78zJYAgwfQ7ubPghEno4yfxUs+1EOR150gu
         UrW57xOJJxOJuR6D4xtrDgS2rhULSS65Z4i2bmgeH5v3a9t+eAJUpeqngQvEFZ3F9JVA
         JHJBEPGufOS7zGcuIxABnzssXoXVyXhNatol8=
X-Received: by 2002:a17:902:e544:b0:2cc:f43b:fa4a with SMTP id d9443c01a7336-2cfde8253b7mr58906775ad.24.1785093954336;
        Sun, 26 Jul 2026 12:25:54 -0700 (PDT)
X-Received: by 2002:a17:902:e544:b0:2cc:f43b:fa4a with SMTP id d9443c01a7336-2cfde8253b7mr58906635ad.24.1785093953794;
        Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc44cb92sm38355795eec.13.2026.07.26.12.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 12:25:53 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next 02/10] wifi: mac80211: stop using ieee80211_mgmt_tx_cookie()
Date: Sun, 26 Jul 2026 21:25:33 +0200
Message-ID: <20260726192541.2816743-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Now that cfg80211 pre-assigns the cookie before calling into mac80211,
stop calling ieee80211_mgmt_tx_cookie() in all affected paths:

- ieee80211_start_roc_work(): for normal ROC use the pre-assigned value
  directly instead of generating a new one.
- ieee80211_attach_ack_skb(): the cookie is already set by the caller;
  remove the ieee80211_mgmt_tx_cookie() call and store it in the ack
  SKB as-is. This covers both mgmt_tx and probe_peer since both call
  ieee80211_attach_ack_skb().
- ieee80211_mgmt_tx(): the dummy 0xffffffff assignment for the
  dont_wait_for_ack case is no longer needed; cfg80211_assign_cookie()
  guarantees a non-zero value which is sufficient for the internal
  ROC vs mgmt-tx distinction.
- ieee80211_store_ack_skb(): same fix for the tx_control_port path.

With no remaining callers, remove ieee80211_mgmt_tx_cookie() and the
roc_cookie_counter field from struct ieee80211_local.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/mac80211/cfg.c         | 14 --------------
 net/mac80211/ieee80211_i.h |  3 ---
 net/mac80211/offchannel.c  | 17 ++++-------------
 net/mac80211/tx.c          |  4 +---
 4 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index df68a5bdeb2f..3f9954338707 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4827,19 +4827,6 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return __ieee80211_channel_switch(wiphy, dev, params);
 }
 
-u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local)
-{
-	lockdep_assert_wiphy(local->hw.wiphy);
-
-	local->roc_cookie_counter++;
-
-	/* wow, you wrapped 64 bits ... more likely a bug */
-	if (WARN_ON(local->roc_cookie_counter == 0))
-		local->roc_cookie_counter++;
-
-	return local->roc_cookie_counter;
-}
-
 int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 			     u64 *cookie, gfp_t gfp)
 {
@@ -4864,7 +4851,6 @@ int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 	IEEE80211_SKB_CB(skb)->status_data_idr = 1;
 	IEEE80211_SKB_CB(skb)->status_data = id;
 
-	*cookie = ieee80211_mgmt_tx_cookie(local);
 	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 11f449e8ff00..a8ea55265f93 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1708,8 +1708,6 @@ struct ieee80211_local {
 	struct list_head roc_list;
 	struct wiphy_work hw_roc_start, hw_roc_done;
 	unsigned long hw_roc_start_time;
-	u64 roc_cookie_counter;
-
 	struct idr ack_status_frames;
 	spinlock_t ack_status_lock;
 
@@ -1989,7 +1987,6 @@ u64 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
 void ieee80211_handle_queued_frames(struct ieee80211_local *local);
 
-u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local);
 int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 			     u64 *cookie, gfp_t gfp);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 2bceb73717c6..94be6497f259 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -602,14 +602,12 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 	/*
 	 * cookie is either the roc cookie (for normal roc)
-	 * or the SKB (for mgmt TX)
+	 * or the mgmt_tx cookie; both are pre-assigned by cfg80211
 	 */
-	if (!txskb) {
-		roc->cookie = ieee80211_mgmt_tx_cookie(local);
-		*cookie = roc->cookie;
-	} else {
+	if (!txskb)
+		roc->cookie = *cookie;
+	else
 		roc->mgmt_tx_cookie = *cookie;
-	}
 
 	req = wiphy_dereference(local->hw.wiphy, local->scan_req);
 
@@ -1021,13 +1019,6 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			kfree_skb(skb);
 			goto out_unlock;
 		}
-	} else {
-		/* Assign a dummy non-zero cookie, it's not sent to
-		 * userspace in this case but we rely on its value
-		 * internally in the need_offchan case to distinguish
-		 * mgmt-tx from remain-on-channel.
-		 */
-		*cookie = 0xffffffff;
 	}
 
 	if (!need_offchan) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eb36f1b9771b..183beae2193a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2605,10 +2605,8 @@ static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 		if (id >= 0) {
 			info_id = id;
 			*info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-			if (cookie) {
-				*cookie = ieee80211_mgmt_tx_cookie(local);
+			if (cookie)
 				IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
-			}
 		} else {
 			kfree_skb(ack_skb);
 		}
-- 
2.54.0

