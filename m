Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0BA3DB336
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501326; cv=none; b=ip30AKiw49cfGJrYXPdKrlq21EbuXRc2w6sEYlN4bh5G6lEUHZhZCHpdH13Yx8mo24O31UfhWfOfz505qqKFwL9IwtlhqPtizG/r/RqZVHwmLOdp0/D2dS7tc5F8nTLOU2RNQFAoDYdcZ7y5ZiznED2u4hRrHUJ+JwR5w1beA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501326; c=relaxed/simple;
	bh=gTdggbvaB6x7848EGqj36834vWoqoSIsvC5RhvMirJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuB4o2xT6TNo6zvCfxN+dmKNFh1HAsy3fAF0vlccJ7cVnkUZewKggpjMv++0c8fK5BobkY+xLDdoOHbZzs9QKIyGYpVC5NfDyEn6DvAd9t3JE79aN/cErmkqL2TtMDAq5d0LHx6CaMqW3Bn4yXpDTJG+/DpC17noB9jdrxPD3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hryJf6q8; arc=none smtp.client-ip=209.85.221.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hryJf6q8"
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5bfb3347dc4so575828e0c.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501324; x=1786106124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dvzVH9b2ozkOdQzhM+oBzR772b6NvYmkBpZvSNx5YlI=;
        b=TwGnUEXD+Ub/Nf1raY4flk/PacQqMlYVdTi8CJepV21/wvWmVzNgMnp88qyTaiJQZN
         gIBVMx+ByFYNAWBB8vtH1Nf3TxwL8G8PoPcn/umyjdqBHEygzSFanfYlWehyxhiy6seg
         q00T564837So72dLbqngm8LeFucYtEGhExUlmSF+aWFg/fZTbZcV6JjvjL+DcQ2YcOjp
         ytDmOWjKal0W6xGp7EBOHFALcqzZKgZtnX8U+6xSdKwDoPBn4GhmZvvLjl7nGA1BREPW
         WuLITnyRqYHNjlkfzvDlTKMrvyrEUwAkwaHNbHMsGcaKLAW+jK1hFRLm5H1ENFQWiuyW
         JMaQ==
X-Gm-Message-State: AOJu0YzewgwbMAyLghC7XrT6fDe5l1cnRE/+f+BQcmzQMMCHF9PkCfLU
	wtacxx6hslGOj8fK9nkyWNBefR5B779KJGgQGVHnFGV1JVKjHy81o3lAlyaW+Cec0hXjIsshiFI
	zaqjwHOz66d8h6fFiogSLUtQdvXZmnTl2Kyd59b9XyZE7nmzvZdUcIIfXpQvgwaO94GvBL1BDiT
	H+DcZp6gZ/n4ldoDdI82RCQB683Qbi9CcgkV1BCJqhmpqApozNgBXCDSYdYtCHHYStYJpVzVyHl
	+sPXLL/XFV1Fqb7q6SKPSbEbkgv
X-Gm-Gg: AR+sD11R3Q+My1Ei9Uq0oXulyV0SW+TdmD/J844DP//QGQNOrKqeequ4yjtllSqmOEg
	wtwcwzdeOl89RfxfUcfsy5RLkTXGt7RxyNV25MYTlET3Zy1kqAa3L6fxxrXFT11uX1BJTvHXSUe
	ga+wRvEdGOnclUSzjZja1XLD2fqxTPT8nXH58bd9H+OP2k/3toz1DCs4yQLZTBdGmHla8dweKy/
	AcqUQR8GFJgvY+LVNtMCkA+6ZiSmoy8mgBEQUca1iAaEgadZtJykdEXBcDyn//UaQNDIsjm3jHf
	HBa+1OYv0M0l4/ftUE1+WuZB2mcOfLdn6BZ/1SEsOJs/c0LyYR3tdrOq+mWDJ5OWJHLXwIx/42C
	qk+5SkASzhR5F2203z9NlUtbWqsssJy+EB6ehv8JIAYJjH+tTocv/XhOFU7mM2eqDAZ5Ci6li3P
	YPmBwfX4GNPsb+kvex8DBCC3+dvFTzhmCg+7lJxd8=
X-Received: by 2002:a05:6122:c84:b0:5bf:8109:dc81 with SMTP id 71dfb90a1353d-5c37e6d6278mr499946e0c.14.1785501323655;
        Fri, 31 Jul 2026 05:35:23 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c37ecd4d2csm187880e0c.6.2026.07.31.05.35.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:23 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso1303006a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501322; x=1786106122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dvzVH9b2ozkOdQzhM+oBzR772b6NvYmkBpZvSNx5YlI=;
        b=hryJf6q8QxqW3G65dNiEpCeuTUCkX6aAh2wdhOHbTz/71N5Br8E0bDo5r54rxo/JcJ
         w6P6WtI1j4ti+l6LiRJ2YhWtmGF0kKq8ERp+ZDdxPewxh0AGZJcNuYu9AAS0Z9elwqzM
         +b3N8vf7DyDvEWvS6CM5MI+7+JK6QemZbNICI=
X-Received: by 2002:a05:6a21:6cc4:b0:3c8:e397:cf77 with SMTP id adf61e73a8af0-3c91b176954mr1786161637.2.1785501322100;
        Fri, 31 Jul 2026 05:35:22 -0700 (PDT)
X-Received: by 2002:a05:6a21:6cc4:b0:3c8:e397:cf77 with SMTP id adf61e73a8af0-3c91b176954mr1786133637.2.1785501321426;
        Fri, 31 Jul 2026 05:35:21 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:20 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 02/13] wifi: mac80211: stop using ieee80211_mgmt_tx_cookie()
Date: Fri, 31 Jul 2026 14:34:58 +0200
Message-ID: <20260731123509.1975281-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
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
index 0a9247be26af..b6d02d2b28f5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4831,19 +4831,6 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
@@ -4868,7 +4855,6 @@ int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 	IEEE80211_SKB_CB(skb)->status_data_idr = 1;
 	IEEE80211_SKB_CB(skb)->status_data = id;
 
-	*cookie = ieee80211_mgmt_tx_cookie(local);
 	IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a1ef88fe846d..3760319ab079 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1710,8 +1710,6 @@ struct ieee80211_local {
 	struct list_head roc_list;
 	struct wiphy_work hw_roc_start, hw_roc_done;
 	unsigned long hw_roc_start_time;
-	u64 roc_cookie_counter;
-
 	struct idr ack_status_frames;
 	spinlock_t ack_status_lock;
 
@@ -1991,7 +1989,6 @@ u64 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
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
index 0cf5f6ec75e6..6993e694e835 100644
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

