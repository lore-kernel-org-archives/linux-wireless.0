Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C9C59481B
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887480; cv=none; b=GEPWjIi5JCi8+RRXUMSvjW5q9oyRSQ5AMh7kifAfed9ENCt4FCX2Li1Gfewwm0+iqzg9eG0Ns8OXxtwN8xjmLk7rZ6Fni4LfakHewy2UXdgPlZx2r1nC3JYRVV4oO78hvmkbNN5pRWA0RWtr3kJIVg7C4n4xsoTFcf0Z1ds056E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887480; c=relaxed/simple;
	bh=DuVTL7SFSPGn50P5/cLnuDkfUI+vw4dP9jTarQNd3pQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VA2PR/ajyEaA67lnVvDSwAQ9+/h+CIRtzKG4W2yP+WuvnubvTcxkIMhjvA2E698PLzEWgyzxH4UcFsPv08BKD6H98AzNywvtGPKfBP2JIKDPqTAfv1nuLHVh/s81jmo0B/uQBPXI/K7zZblhCM6ZEujHRExtAsSqz9CePwkrFsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h4kBYh7x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VMQLeXQI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h4kBYh7x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VMQLeXQI"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdZQd360084
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jUEQhFwlbsnMglV+/k9/p+xndCktKv3p9s//lWGSM5g=; b=h4kBYh7x4rlNQvKx
	UTdjpk1dTVc5cEh4CjnIr/QkGvl+gT3ZW7CBYUgaeXRrz6c29ZPozHY6Bq9yNlcQ
	lwPsYG0QzrKHWwBU2Yj/MuoGJxM/OC9ArJ/7VdAahjs6+xNGvu6TDU/pRt6uxb4h
	/KG+ln0mhBA6CFIl11/NOheY49nRBPluHvsWJK2OpluvVvjRe2d/7/omR/MMt6B/
	62gNZzJIJnPpU9I+Qejbs2TWiwGZGbVBMMMmfDMHDGqgsfYTabkzFB7teRscJezX
	vARVOTT2B9n8YOdRXv1DpCcAgOGaeRBxQxCpTH1tQo9fAqAaOAMGCTz+UNY72z4L
	nt0EfA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjb0pb9r3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:11:16 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-381250979d5so5964706a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887476; x=1789492276; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jUEQhFwlbsnMglV+/k9/p+xndCktKv3p9s//lWGSM5g=;
        b=VMQLeXQI3UwGrnhWDDNElpEi5Zf4k+iSlRMClSiUXicajHmuSGiamdj/MH9EcGuypR
         DItvKqvLkEofF0ZavjUAS5DvvCIJtQaw7UB8gByY1JZ2tF0unRGi9yrrchZxo0BeatCS
         wmvPMflWEly/I8oyoL4DKzcenL9xXVxh/kbwET+umhtyvxhXgOUOQaBlKybQL5PaoIvn
         WE0uONYS/OKWhZmGQNRfBMfiU5OW/IeCCtbEnRNHgFwh3yfMd2CP23zSpW4kRHegAggL
         ZJGKPLiYR8TACFgjNlCcooQD4h1kUy9KhEXk4CbwLrR4n3f5rQq8DnF5iiNl3L9Sljj3
         kmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887476; x=1789492276;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jUEQhFwlbsnMglV+/k9/p+xndCktKv3p9s//lWGSM5g=;
        b=r7rUE2rxvqv/YO3l3iBE2NaTsxg3JpRpXPjkwT/IbKGtGZ+4OUnj3PuCmAfYN9fjdq
         ilAZQD7uMkLFuVOj4OB0wJi+Y2rDHvIEEZAd+4QbN93g4sW5umwKBNbggwOi8Ld/wy7h
         PB+W3uoqBcf1L7Ts/IglkYyV55FwLOWqKZUufmu2v56JdrL1xGlSq+gbciSFyLnYUQuK
         DjdoIi0KfRBi9ZSX5FzaDd8Dmb8hvmLoAqdfF43KDxrfp7WRKxHy8ldtXbHc4nR4TxTQ
         I3H8D6hAGsrCa90JbA8nHAe19r7ZaVoC5/pxeUmfaIAKeLNZhmXF1dDblCrEL6arfPa4
         seAw==
X-Forwarded-Encrypted: i=1; AKwUvBzR5FSaHaUoe/LvZPXsVkgxxLOMqd1ziCyh3INcZ8DoWGKz1qGvEADBNSkqWZ96lQqnwSThe3phYn9HFISqJA==@vger.kernel.org
X-Gm-Message-State: AFuF++nBo1AKrCJlnUDS9FoIclGCfCer+3ypuGHchJ3oQY+BDvID9GIK
	taF6yxXzBMhJb5Cpk55J/wAqEfmfpdAPrqEiWCWKWOB3kReZUom1KRtLq97zFS9yXIq35cgOuh3
	dlpmWkppz/1Yt2/KrosUyKgsDPXOKfCarGUTV+R2vi9JliqnsommRxn6PhsKpYwjSkGYm
X-Gm-Gg: AYBFou1UMUL2/Jf1l7i4R6M0sBsNCASJKjl5tmai2YM5Qypse2GppQcog0cS01CjQMJ
	+kZEUwElPOBvQuC3ZMqtuPfnM7BOS4uCmPIr7mbt6cWaLMij4IjvLrKaaa6bIBOWLm4AkLL5kzb
	E6V8crbyVCMKVYrCTvVMy5Tq6c8HFtKrPSKZHPXJAQR5nmFTBKAdT4grFzrZKiDLoKFgl66wMRE
	UpN4qWFWGiCjnkSZRm///G2Fj+SoozOmNosb73dOFnugMtNIrVZoRNs5s9MOjufR+wdqsZS/U4X
	Jn7G1fPfAM4L4gNvElhtmeJO4m2EB93pB31O0Z1vj0NEBOQ8JlJPFKCalb2wxuHWgOPbp302Wa4
	D5PLljYPlsMHcNL53G+Z9JGOjE0LCFZD271fV7+oy6UiBvQwHnDo4C64S1ZwS9+eRxG6p/o4VgH
	O980fzQltIeZswzXsf41INMw==
X-Received: by 2002:a17:90b:3d92:b0:398:bf7e:b267 with SMTP id 98e67ed59e1d1-39b2614df9dmr46647024a91.2.1788887475507;
        Tue, 08 Sep 2026 10:11:15 -0700 (PDT)
X-Received: by 2002:a17:90b:3d92:b0:398:bf7e:b267 with SMTP id 98e67ed59e1d1-39b2614df9dmr46646945a91.2.1788887474859;
        Tue, 08 Sep 2026 10:11:14 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:11:14 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 17/18] wifi: nl80211/cfg80211: Add support for querying SMD context for target AP MLD
Date: Tue,  8 Sep 2026 22:39:45 +0530
Message-Id: <20260908-smd-v1-17-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: tI4z1sJhZ9OsuRGckUMSHX5vbIcBHTVL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX0Gs+p3fm0dl1
 Na8+3IfHQnakJGvPQOebxH9QtH1i1qJuXFz1GVfdJhvXaT7Ka1HbK4sGDvwJcuwgxxb7KPnORvi
 VuPzKJPxTrqXuh2Vl93VexQCM/QdVy4=
X-Authority-Analysis: v=2.4 cv=HL3z0Itv c=1 sm=1 tr=0 ts=6aa041b4 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=hdw18t4awISUpvPuE2cA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: tI4z1sJhZ9OsuRGckUMSHX5vbIcBHTVL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfXyUK1fEI1Cxs1
 WkE1SBwbQ20M3RPQQkLaU4xZJJMWnaXFNAZE4BTWuEKoFVU6oCK2yAcBAdy+n9Nxth1qyDQtoNl
 Te9iHpGpm02KDxm+IjTLHeIz0XCV6/akJheJknMpyQjqWOHdgzbxm0nQVTXWf0//lk0PM7x7tff
 iGsZ2aH1qItVFwUnzqjbJPexCZoyTu1xr7dP7SfknLWX0MBYOgdTjvSqXVD09MT4fbi9JVGyoPZ
 Ll5z7xED54CZIfw5ZDk94pYVW4hrJlpFm+eWehR6E1707IVTCEwBqfDpUaKRdhc2ExL6PekF44k
 7Y7ANrw3SLD6L8TCURCedSgagEWOvFU+3d9FnOJ19lXCxG5axdc3Y7C6iw6WE54kZdvPgh8vVvb
 biBK2Q035t6GXTZKImPhd4fbwhZFsgQ8k3/Tnw9jggW9WtOT8hhqJQb0dayCIt6D34iZpXzuKeL
 tXTBfrSQIy67+M/ScMQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080185

During SMD BSS Transition (ST), the non-AP MLD that has been prepared
with a target AP MLD may send the ST Execution frame directly to the
target AP MLD. In such scenarios, the target AP MLD should pull the
context from the current AP MLD to program TX and RX queues.

Add nl80211 support to handle NL80211_CMD_GET_SMD_CTX, which is sent by
userspace of the current AP MLD on behalf of the target AP MLD. This
command carries the context type to indicate to the drivers which context
needs to be collected. Once the collection is complete, the context is
sent back to userspace as an asynchronous multicast event using
NL80211_CMD_SMD_CTX_EVENT with full context data carried in
NL80211_ATTR_SMD_CTX.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h  |  53 ++++++++++++++++++
 net/wireless/core.c     |  25 +++++++++
 net/wireless/mlme.c     |  32 +++++++++++
 net/wireless/nl80211.c  | 143 ++++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h  |   9 +++
 net/wireless/rdev-ops.h |  14 +++++
 net/wireless/trace.h    |  26 +++++++++
 7 files changed, 298 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b68f5f6837be..d72d1feb0ae3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4898,6 +4898,33 @@ struct cfg80211_smd_transition_info {
 	enum nl80211_smd_ctx_type type;
 };
 
+/**
+ * struct cfg80211_smd_get_ctx_pending - pending async GET_SMD_CTX request
+ * @list: linkage on wireless_dev::smd_get_ctx_pending_list
+ * @sta_addr: non-AP MLD address for which context was requested
+ */
+struct cfg80211_smd_get_ctx_pending {
+	struct list_head list;
+	u8 sta_addr[ETH_ALEN];
+};
+
+/**
+ * cfg80211_get_smd_ctx_done - deliver async GET_SMD_CTX result to nl80211
+ * @wdev: wireless device that handled the request
+ * @sta_addr: non-AP MLD address the context was collected for
+ * @st_info: SMD BSS Transition Info (@st_info or @st_info->ctx may be NULL to
+ *	indicate failure)
+ *
+ * Called via ieee80211_get_smd_ctx_done after async driver context collection
+ * completes. Finds the matching pending request and sends a multicast
+ * %NL80211_CMD_SMD_CTX_EVENT reply to userspace (MLME group).
+ *
+ * Return: None
+ */
+void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
+			       const u8 *sta_addr,
+			       struct cfg80211_smd_transition_info *st_info);
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -5333,6 +5360,8 @@ struct cfg80211_smd_transition_info {
  * @set_smd_ctx: Set UHR SMD context data for the non-AP MLD. @st_info->ctx is
  *	freed immediately after this call returns; drivers must copy
  *	@st_info->ctx if asynchronous processing is required.
+ *
+ * @get_smd_ctx: Get UHR SMD context data for the non-AP MLD.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5714,6 +5743,9 @@ struct cfg80211_ops {
 	int	(*set_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       const u8 *addr,
 			       struct cfg80211_smd_transition_info *st_info);
+	int	(*get_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       const u8 *addr,
+			       enum nl80211_smd_ctx_type type);
 };
 
 /*
@@ -7286,6 +7318,8 @@ enum ieee80211_ap_reg_power {
  * @links.cac_time_ms: CAC time in ms
  * @valid_links: bitmap describing what elements of @links are valid
  * @radio_mask: Bitmask of radios that this interface is allowed to operate on.
+ * @smd_get_ctx_lock: lock to protect pending get_smd_ctx requests.
+ * @smd_get_ctx_pending_list: list to track pending get_smd_ctx requests.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -7405,6 +7439,10 @@ struct wireless_dev {
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
 	u16 valid_links;
 
+	/* protects @smd_get_ctx_pending_list */
+	spinlock_t smd_get_ctx_lock;
+	struct list_head smd_get_ctx_pending_list;
+
 	u32 radio_mask;
 };
 
@@ -11081,4 +11119,19 @@ void cfg80211_incumbent_signal_notify(struct wiphy *wiphy,
 				      u32 signal_interference_bitmap,
 				      gfp_t gfp);
 
+/**
+ * cfg80211_free_pending_smd_ctx_req - Free remaining entries in the
+ *	cfg80211_smd_get_ctx_pending list.
+ * @wdev: wdev that maintains the list
+ * @addr: if @addr is NULL, drain the entire list; otherwise, drain only the
+ *	matching entries
+ *
+ * When the current AP MLD requests the station's context, those requests are
+ * maintained in a pending list until drivers notify completion. In case the
+ * device is brought down or the station is removed prematurely, free up the
+ * remaining entries in the list.
+ */
+void cfg80211_free_pending_smd_ctx_req(struct wireless_dev *wdev,
+				       const u8 *addr);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691..129af6ba5fda 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1405,6 +1405,25 @@ void wiphy_rfkill_set_hw_state_reason(struct wiphy *wiphy, bool blocked,
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state_reason);
 
+void cfg80211_free_pending_smd_ctx_req(struct wireless_dev *wdev,
+				       const u8 *addr)
+{
+	struct cfg80211_smd_get_ctx_pending *pending, *tmp;
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_for_each_entry_safe(pending, tmp,
+				 &wdev->smd_get_ctx_pending_list,
+				 list) {
+		if (!addr || ether_addr_equal(pending->sta_addr, addr)) {
+			list_del(&pending->list);
+			kfree(pending);
+			dev_put(wdev->netdev);
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+}
+EXPORT_SYMBOL(cfg80211_free_pending_smd_ctx_req);
+
 static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 				      bool unregister_netdev)
 {
@@ -1477,6 +1496,10 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 		}
 	}
 
+	if (wdev->iftype == NL80211_IFTYPE_AP ||
+	    wdev->iftype == NL80211_IFTYPE_AP_VLAN)
+		cfg80211_free_pending_smd_ctx_req(wdev, NULL);
+
 	wdev->connected = false;
 }
 
@@ -1619,6 +1642,8 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
 	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	spin_lock_init(&wdev->smd_get_ctx_lock);
+	INIT_LIST_HEAD(&wdev->smd_get_ctx_pending_list);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a0d1cde26f0c..fa60e391f9bc 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1475,3 +1475,35 @@ void cfg80211_mlo_reconf_add_done(struct net_device *dev,
 	nl80211_mlo_reconf_add_done(dev, data);
 }
 EXPORT_SYMBOL(cfg80211_mlo_reconf_add_done);
+
+void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
+			       const u8 *sta_addr,
+			       struct cfg80211_smd_transition_info *st_info)
+{
+	struct cfg80211_smd_get_ctx_pending *pending = NULL, *iter;
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_for_each_entry(iter, &wdev->smd_get_ctx_pending_list, list) {
+		if (ether_addr_equal(iter->sta_addr, sta_addr)) {
+			pending = iter;
+			list_del(&pending->list);
+			break;
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	if (!pending) {
+		wiphy_err(wdev->wiphy,
+			  "No pending SMD ctx req for %pM found in %s\n",
+			  sta_addr, __func__);
+		return;
+	}
+
+	nl80211_notify_get_smd_ctx_done(wdev, sta_addr,
+					(st_info && st_info->ctx) ? st_info :
+					NULL);
+
+	dev_put(wdev->netdev);
+	kfree(pending);
+}
+EXPORT_SYMBOL(cfg80211_get_smd_ctx_done);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 70b8697e5dac..47454ea2983b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19585,8 +19585,7 @@ static size_t _nl80211_smd_ctx_nl_ba_param_size(void)
 	return n;
 }
 
-static size_t
-nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
 {
 	const struct ieee80211_smd_ctx *ctx = st_info->ctx;
 	int n_dl_tids = 0, n_ul_tids = 0;
@@ -19698,8 +19697,8 @@ nl80211_put_smd_ctx_ba_params(struct sk_buff *msg,
 	return -ENOBUFS;
 }
 
-static int nl80211_put_smd_ctx(struct sk_buff *msg,
-			       struct cfg80211_smd_transition_info *st_info)
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info)
 {
 	struct nlattr *dl_sn = NULL, *ul_sn = NULL, *ul_pn = NULL;
 	struct nlattr *smd_ctx = NULL, *dl = NULL, *ul = NULL;
@@ -20493,6 +20492,95 @@ static int nl80211_set_smd_ctx(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static struct cfg80211_smd_get_ctx_pending *
+__cfg80211_get_smd_sta_pending_ctx(struct wireless_dev *wdev, const u8 *addr)
+{
+	struct cfg80211_smd_get_ctx_pending *pending = NULL, *tmp;
+
+	lockdep_assert_held(&wdev->smd_get_ctx_lock);
+
+	list_for_each_entry(tmp, &wdev->smd_get_ctx_pending_list, list) {
+		if (ether_addr_equal(tmp->sta_addr, addr)) {
+			pending = tmp;
+			break;
+		}
+	}
+
+	return pending;
+}
+
+static int nl80211_get_smd_ctx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_smd_get_ctx_pending *pending;
+	enum nl80211_smd_ctx_type type;
+	const u8 *addr = NULL;
+	int err;
+
+	if (!rdev->ops->get_smd_ctx)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_AP_VLAN)
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR] ||
+	    !info->attrs[NL80211_ATTR_SMD_CTX_TYPE]) {
+		GENL_SET_ERR_MSG(info, "required attributes are missing");
+		return -EINVAL;
+	}
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+	type = nla_get_u8(info->attrs[NL80211_ATTR_SMD_CTX_TYPE]);
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	if (__cfg80211_get_smd_sta_pending_ctx(wdev, addr)) {
+		spin_unlock_bh(&wdev->smd_get_ctx_lock);
+		return -EBUSY;
+	}
+	/*
+	 * Concurrent NL80211_CMD_GET_SMD_CTX commands are serialized by
+	 * wiphy_lock in nl80211_pre_doit, so safe to unlock here.
+	 */
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	pending = kzalloc_obj(*pending);
+	if (!pending)
+		return -ENOMEM;
+
+	memcpy(pending->sta_addr, addr, ETH_ALEN);
+
+	/*
+	 * Take reference and add to the list before calling the driver to avoid
+	 * race. Upon success, the reference is released in
+	 * cfg80211_get_smd_ctx_done() or the list removal and drain path.
+	 */
+	dev_hold(wdev->netdev);
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_add_tail(&pending->list, &wdev->smd_get_ctx_pending_list);
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	err = rdev_get_smd_ctx(rdev, wdev, addr, type);
+	if (err) {
+		/* revert upon failure */
+		spin_lock_bh(&wdev->smd_get_ctx_lock);
+		pending = __cfg80211_get_smd_sta_pending_ctx(wdev, addr);
+		if (pending) {
+			list_del(&pending->list);
+			kfree(pending);
+			dev_put(wdev->netdev);
+		}
+		spin_unlock_bh(&wdev->smd_get_ctx_lock);
+		return err;
+	}
+
+	/* Reply will arrive via cfg80211_get_smd_ctx_done() */
+	return 0;
+}
+
 #define SELECTOR(__sel, name, value) \
 	((__sel) == (value)) ? NL80211_IFL_SEL_##name :
 int __missing_selector(void);
@@ -21401,6 +21489,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_CLEAR_SKB),
 	},
+	{
+		.cmd = NL80211_CMD_GET_SMD_CTX,
+		.doit = nl80211_get_smd_ctx,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -24426,6 +24520,47 @@ void cfg80211_nan_channel_evac(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_channel_evac);
 
+void
+nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct net_device *dev = wdev->netdev;
+	size_t msg_len = NLMSG_DEFAULT_SIZE;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (st_info && st_info->ctx)
+		msg_len = 100 + nl80211_smd_ctx_nl_size(st_info) +
+			  nla_total_size(ETH_ALEN); /* MLD address */
+
+	msg = nlmsg_new(msg_len, GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SMD_CTX_EVENT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN, sta_addr))
+		goto nla_put_failure;
+
+	if (st_info && st_info->ctx && nl80211_put_smd_ctx(msg, st_info))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index bdb065d14054..26e647dff866 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -129,4 +129,13 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
 void nl80211_mlo_reconf_add_done(struct net_device *dev,
 				 struct cfg80211_mlo_reconf_done_data *data);
 
+void
+nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info);
+
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info);
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d33a969606d7..ab520560f604 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1650,4 +1650,18 @@ static inline int rdev_set_smd_ctx(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_get_smd_ctx(struct cfg80211_registered_device *rdev,
+				   struct wireless_dev *wdev, const u8 *addr,
+				   enum nl80211_smd_ctx_type type)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_get_smd_ctx(&rdev->wiphy, wdev, addr, type);
+	if (rdev->ops->get_smd_ctx)
+		ret = rdev->ops->get_smd_ctx(&rdev->wiphy, wdev, addr, type);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 6234ceb9ebb1..a2662919b8f0 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4452,6 +4452,32 @@ TRACE_EVENT(rdev_set_smd_ctx,
 		  (unsigned long *)__get_dynamic_array(rx_tid_bitmap))
 );
 
+TRACE_EVENT(rdev_get_smd_ctx,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, const u8 *addr,
+		 enum nl80211_smd_ctx_type type),
+
+	TP_ARGS(wiphy, wdev, addr, type),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		MAC_ENTRY(sta_addr)
+		__field(u8, st_type)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(sta_addr, addr);
+		__entry->st_type = type;
+	),
+
+	TP_printk(WIPHY_PR_FMT  ", " WDEV_PR_FMT
+		  ", sta=%pM, ST type=%u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->sta_addr,
+		  __entry->st_type)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

