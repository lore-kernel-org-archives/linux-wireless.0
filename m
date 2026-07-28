Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F352C11CF
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249964; cv=none; b=tKKu2CFvIDOQjNcFLALT3b4Ld1YpkAL4X+rZ6TtYcECIc4aP88s381Sg5Zx7yxpvkH4MeuwlD4u3wGm/5gC4Su3vvqxLA+HGIgdFvtc8O/x1V64Ol2oUyZcExYLzWxV9KHbAwP+rHiAiuiubuXQkSLoXQcEjlP/IU//RYazUPqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249964; c=relaxed/simple;
	bh=fYsYE/4pd//5zYUChMxbjn/SjznVltvAOaAi1g7yEcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WarVZZ/biTJJ2WB1chmggl6XGwZdjfqj1+XN9+Hg0E/bJOKfnkjI1dWVLbzP7ThQqMY4ApJFCuA/Xch2WIa8H+YMLBX5XhL9PEq7wfbqvSt58Il3ErXryDwpnKpb3F5xMsDqnAAPMgzgOF77MSokdFcQXjN2JR+gEWpXt5bR06g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WIvlQe2C; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WIvlQe2C"
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-92e55b62640so210418885a.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249962; x=1785854762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IdxVhr7EVeFJyQ3maQTqTGgQkmWNCzpHPWLQq6UcYic=;
        b=nF9hiwxsbsduQuiQl/IvpA8NvmVaI6dyUaUg1vd2Fc7LnCY5nyZytInh2BA0YMjlWR
         QtLXmCqiQC5W/7Amc/64nXQb9qPaJB5YI4TGlvWV/xTz2yct3q0XiukiS+omh0DBNArD
         cFyH/RmAh8c+ieg8TDALslxLUWrZ6deVe2BeRwJxhmCHYaB+tf3iHq6F4wWX2bPYS76E
         BP73RA5qcTcO/YLHUUuqq6AAGWGFT0ODQAXgs6xZCbr9wz5oVJvjJ6WCklCooP6b7j91
         jBJ5WtZa0u1rkZbxk3BJqtU2SW4vDKRqByGJGSzN/d/q0fUkB7oLxrg8RUUnR2TdZaN6
         8Zrg==
X-Gm-Message-State: AOJu0YyVMwDF/IeYEUZT1N/ivGR/b9fsT7yKV1wAAoAR+m1hRm3dhrn9
	aqcK9ljRZirsjKASbMBaD19yFwjhby8rHMiqUycbSOc8hBtRrnQk7CFGVZdBEBRYLDo5t4O9rxy
	4YyCz4NXPgDoV7zqcmj/8lEetd0jmODco0phSKgBW2hJOnj86QHx+UAMJrcEacmNrpBeJlWC1N2
	yDjhyt+rr8FVI413diIrUglwCKNcK62OAdBNMk2/F2/Vl/WD3WM/fZB4f788BA+iJr0IzGH7vpv
	j+ccN2hYwNcakcesWrtser90ILk
X-Gm-Gg: AR+sD10cQx4zWo9QCDgSyIBZ68FcJZ+9KgwszuwWCq7GY0gZSlLxIe3Yyruq1//pDCp
	Bk2DLLeAI4QoTdc3AHjlOBRRmejdss0q18NN2NNsa0Iy8tW8Ulad29KPmEWzxrraWZhHDGbKN/f
	tiaQc5FBpjUXn7J98dLqmOt4Zy3pbTFVEy+cS3wm10Y82dwmquCHkHCoA8Uf/XsNlWxI5BjL9l8
	jV/PhtnAfAyRdfLtFWi+W0vxzNJhScxptVp/ezpRO/W8w7XG2w4RNmfgnnWxcZEOCLkliFeQeGG
	Ii8SN11e3oZ0039bhmb5/KDo1ayKexy9ZGdMgyUttzVRRIZg1oDi0Tly2vsIz21jx30vW/G+kmj
	rr4HTzqYv1WPsrEY4MXFk0ve9r6PwAMetqakTQ9JArr/O1OBxDo21UhOsS4tDzfBENrC2EDSJKS
	/2HXQ44eGQPLJonHz9KWr7q6dYMO3Wp9mDmXRNAl0=
X-Received: by 2002:a05:620a:6885:b0:92e:612d:87cc with SMTP id af79cd13be357-933027745b6mr246853585a.46.1785249961924;
        Tue, 28 Jul 2026 07:46:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-9081dcfa345sm41676d6.17.2026.07.28.07.46.00
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-930edb4362dso416917685a.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249960; x=1785854760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IdxVhr7EVeFJyQ3maQTqTGgQkmWNCzpHPWLQq6UcYic=;
        b=WIvlQe2CiC69TSV+l0T2MvoafrRlADTdRuwUpeVF3rxsZ8DiJ6I0WEJsNtyDdmy3ed
         ywxbku0A5hr2VLAz+N/j0Q6Om6bYqPHFNoAncPqcqlI/qtWdhvlbZKFii7MElJfrcMCD
         iwZRN2wvIndTWRZIyvfHweEMOF6zbBhGxNjfY=
X-Received: by 2002:a05:620a:25d2:b0:92e:fd2c:6a1b with SMTP id af79cd13be357-93302772db3mr266144885a.50.1785249960248;
        Tue, 28 Jul 2026 07:46:00 -0700 (PDT)
X-Received: by 2002:a05:620a:25d2:b0:92e:fd2c:6a1b with SMTP id af79cd13be357-93302772db3mr266138085a.50.1785249959637;
        Tue, 28 Jul 2026 07:45:59 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:45:58 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 02/12] wifi: mac80211: stop using ieee80211_mgmt_tx_cookie()
Date: Tue, 28 Jul 2026 16:45:39 +0200
Message-ID: <20260728144549.2207061-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
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

