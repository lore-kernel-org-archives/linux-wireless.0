Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3560252B1DA
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813248; cv=none; b=btEeu9jueKG2bdR2ovtkLGS3mEA5F7mVbbroJEIXIQSFAUNIvc48cEz5jB2a/g1/1+uNM78pgy63tBYu/pZfWMXkst37HYrRi3DN5XKeJfsxHNkkaAIxqXFnTgiSQ/DXDFpAXjdO5/tNVOZyB+cbV17m1QRaT/ipAqcdaabeM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813248; c=relaxed/simple;
	bh=/xXrRGDv6Jszk0sj0UbOjDjGSuSuowHtjBK+vXW0/Zg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GOrjtYoBZ2JDdcXDMDZRFvIw7BSndlwEvmCXD6EJZzkFF/EkKUc2SRqXfBdhnkzxs+mRFouYqwd65p8kVXvRo33xgmIVCAckrKe0fCOZDGeVmeKqm9q29p5dJfGJ/4Oa7mSt4hdGyEmn8EavxazDfPN3PVnJUBP2v6FfUkl9AVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hJ993Gm2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=igJTnoSZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hJ993Gm2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="igJTnoSZ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H89qG838288
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2FTgMhgLWmf0Jq8fB7caGXnFJscVEgzrr/HiqFpuFaU=; b=hJ993Gm2X6ceZs4H
	00hEijX8UwEgxYue+TyOtJfLGAbC0JtJEBE/k3N6bKD9PeNyXmIW71TZ+VGzm7T2
	o7Cgp7mPfuyIhd6t/7fBw2ZxZIAXr1sGUAQfLCOKcpnC9RJk2iwEQ7myUbPSv1rH
	slKI8X0sv8lt8UYlnjaT8QfYmBvXrx+1NdIm6yRF2NQNhD/rkSP+WmLv9OW5/xYL
	iV/yUJ+Zg3WsZcMGutuaUIKlaLfOnMzb0vYzvi66U6Ue6Fn6sPLS2sA0JtANEb11
	iRwFz4RysWEMa1+6ropAllHIgLtwqR0XYVNxB09YtU/OTD0QCpu24EI8Yzez3Zof
	No5cng==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghssg2j39-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:34:04 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfca8558d2so48074295ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813244; x=1789418044; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2FTgMhgLWmf0Jq8fB7caGXnFJscVEgzrr/HiqFpuFaU=;
        b=igJTnoSZCIVE56FlA/lnNK+Vil3eU5Y3WPFWUMyy7+e7ei8QxA5N9IBbQX3gMK+Tjl
         yJB1slTZI+aEpvTA1GiZ1ahBZd/QGEl6gUG8lDdKEa6sImEaafqXESGrpCSkKWpt5LXJ
         whJLNYSKxV3G5ygrzXkKItYB8X91CaIxLc8sfGyPvMS3o+DMrM6BxkBiIv0AvYVT/s2c
         j+xftki57lSzBJZplcPMOEhVnbjIyIITBnRoCmyElnqUI/0ufesbXa0sOlyouRwvJZ8w
         ++COWH1ccXhs7D94sriIscUrKn0UZ/K/0LptVflf1rKiurY4UZ2n10jE3hq/EiqhmOpO
         saFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813244; x=1789418044;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2FTgMhgLWmf0Jq8fB7caGXnFJscVEgzrr/HiqFpuFaU=;
        b=QKPcTbXhV4i5dX/QzYehXxiJbt15AzafWjqLm27XpdTcfIxDIJT8jBtiNzSsXx6vBk
         30kRqekIUZ3aCtWNhN+qA9gp31Kt6DwM/PHJeJ1Lcm+NFmmDkqzJ5OGPUBb9ANtWWgak
         bfngNJxVdUM0v7+nacVKkVh45trzvGeBmJXFs+AjxKC/W1t9Jgb7hl4wITrgDPx8Wroe
         6/fP4DM8rpmfMDKeld4AQtkSm8NmcEJevw4XLxwBlV9wBourfBKg/Yn/JkKQKXYvfLCK
         dWOJMEmrsFixSvyHxRhDf2DoFHsf2yiJsu8SRMMWULZht5DfrJhD9TU6cek8V+qaagDL
         PLdQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlUhytJD4e3FoxSLIW+ddvT3IlAXqIJ+caxiIBRjvmdwJGswACUruDcnALUjH/gukUMmz3qL5yIMIa76ni8w==@vger.kernel.org
X-Gm-Message-State: AFuF++kNbr/A3tTaGLDVuU9LsWmyO5XKCKklj3naaVTnuiiRDZatYjMd
	/s7vhvT4NhYcCDiQ1NIR/cnphwHxmMcixrokgHuhAw25JIibCT1wTdm7e9SMxZWIcFvVNWQtWiD
	HEwrRx3qZ3nDzPdhODUUsFpXKw0fr+A0VGo2okaEZArYkz6WVIqzhnfTnjWLfFtjkAbVZ
X-Gm-Gg: AYBFou1eGf7vFUFKE1YDEAwLaOt2a9zwuztsZsEYtYH2HavOln+/vP6FhmQTjYEfTt8
	hS2mmoJcvcIvdOlUgaoZziGGP848dxtwYdVEwWi43HwbRYXql2bdtRkwXCsTZHm3B+9JnG6sMSE
	UGwzAts7sUr8lrVpGNLdhjxO/xUei2I5OMXuMKFdpxqxjtU4SR/+9A6r/K6tRrHZpzPuci1btfk
	6pOpN7Qb4Eo4u+r708jNHd2EPg+9HiCDhckR9xk9Hem/rEm/bQUU29c8HSqazBymeqiA2mEatoJ
	/VWhZN9oUHu7Y7YPae2QBFx6Gr75Ytf1fEV0LBnMeT9tYQ/mBklQ3qQzyR8bjjfrp48aVhlAs5Z
	VcfFfLRkQ6BNLM6/q7TZWnEDpfagtrDLF//G4va4BIci0iZycVBH0CmOqRownUchYu/xrJfx05+
	Pral28lFOiUDB9DM630TdJVQ==
X-Received: by 2002:a05:6a20:a11a:b0:3d1:2dc5:7d37 with SMTP id adf61e73a8af0-3da39b5c97dmr38558550637.3.1788813243893;
        Mon, 07 Sep 2026 13:34:03 -0700 (PDT)
X-Received: by 2002:a05:6a20:a11a:b0:3d1:2dc5:7d37 with SMTP id adf61e73a8af0-3da39b5c97dmr38558480637.3.1788813243407;
        Mon, 07 Sep 2026 13:34:03 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:34:02 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:22 +0530
Subject: [PATCH wireless-next 13/18] wifi: cfg80211/mac80211: Handle UHR
 Link Reconfiguration frame
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-13-65ad4ab30fbd@oss.qualcomm.com>
References: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
In-Reply-To: <20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfXwmspeLWEyyj2
 h4i3Mt6dE4j8sK3kkpCag4Gr5lhPPQqZFzJMuQ+nCX30HT7Y3z8OG3GKCsYlLtX3B7mtzuNh6Su
 +9Pru/WLzSI5o8f4quDbH+Z4I7qlYLhda2YVw2v5HYjNF7+qYcT5Gx+LmDBUY9h66on+U/mBnh+
 Q3ANxalx9nmdHPpHF34ZaP+oc2he65cgqhOrahnYiWrI3Itn6lWbZ1BzNezY2rbC/fOBzrVyDjq
 9qxWOlrygw1aP0siYeiwTPJimFIraxHOE/Xi/OQVHBfmSLbjHstlSB3HY6IoTiNhBIvjhk3szn9
 v9BaOwRS0wh5iUGe3wLe5QdF7QiFrf9LNbDhqv/UYOzZr5MiuWCLwpoA+cx+D0YvBQfX2XEFCLC
 uvA+R1n404FDOAj6JzshVUZGCiI2M4Z0NXWCyqEON3g3z/zrEUoRBnmMp125rE98Bw7vl+Nk4Ln
 waE3NkGNZDyq2paLV2w==
X-Authority-Analysis: v=2.4 cv=MrJiLWae c=1 sm=1 tr=0 ts=6a9f1fbc cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=LQFPhaWwRXareCLbuGQA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: j4Ixg_EILrB4u_rWex1VyvokiFcZilrQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX48gnp94yo1Pb
 DdePjaFPqZSOYbg9fnCzjIJ0z7u3vhqGet2Tw/5syNo3G4eOZfaA7mzQP7jNI3/dJlNm12Xl21H
 +Kitez4kTG7fohl01LVcNon+pv77dQ4=
X-Proofpoint-GUID: j4Ixg_EILrB4u_rWex1VyvokiFcZilrQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070226

The UHR Link Reconfiguration Request frame triggers SMD BSS Transition
on the current AP MLD. At the point where mac80211 forwards this
frame to userspace via nl80211_send_mgmt(), the driver has already
collected the STA's dynamic context (SN, PN, BlockAck state) and
attached it to the SKB via the SKB_EXT_WIRELESS extension. But this
information is not known by nl80211 to pack the context with the frame
sent to userspace.

Add handling for the UHR ST Preparation and Execution request frames
in ieee80211_rx_h_userspace_mgmt() to pull the ieee80211_smd_ctx
pointer from the SKB extension and store it in cfg80211_rx_info, so
that nl80211_send_mgmt() can include it in the NL80211_CMD_FRAME event.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h | 59 +++++++++++++++++++++++++++++++++++++++++++
 include/net/cfg80211.h        | 13 ++++++++++
 net/mac80211/rx.c             | 22 ++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index f904b1e65f10..cda8251a1a9a 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -743,6 +743,65 @@ ieee80211_uhr_mode_change_tuple_size(const struct ieee80211_uhr_mode_change_tupl
 			     IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_LENGTH);
 }
 
+/**
+ * ieee80211_is_uhr_link_reconf_req - check if frame is UHR Link Reconf Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Request frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_req))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_REQUEST;
+}
+
+/**
+ * ieee80211_is_st_prep_req - check if frame is ST Preparation Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Prep request frame
+ */
+static inline bool ieee80211_is_st_prep_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_req(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_PREP;
+}
+
+/**
+ * ieee80211_is_st_exec_req - check if frame is ST Execution Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Exec request frame
+ */
+static inline bool ieee80211_is_st_exec_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_req(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_EXEC;
+}
+
 #define for_each_uhr_mode_change_tuple(data, len, tuple)		\
 	for (tuple = (const void *)(data);				\
 	     (len) - ((const u8 *)tuple - (data)) >= sizeof(*tuple) &&	\
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 75d0123fbb5d..7b0f328fec79 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4887,6 +4887,17 @@ struct mgmt_frame_regs {
 	u32 global_mcast_stypes, interface_mcast_stypes;
 };
 
+/**
+ * struct cfg80211_smd_transition_info - SMD BSS Transition info
+ *
+ * @ctx: Dynamic context to be transferred as part of ST
+ * @type: Type of ST indication
+ */
+struct cfg80211_smd_transition_info {
+	struct ieee80211_smd_ctx *ctx;
+	enum nl80211_smd_ctx_type type;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -9543,6 +9554,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @flags: flags, as defined in &enum nl80211_rxmgmt_flags
  * @rx_tstamp: Hardware timestamp of frame RX in nanoseconds
  * @ack_tstamp: Hardware timestamp of ack TX in nanoseconds
+ * @st_info: SMD BSS Transition data in skb extension
  */
 struct cfg80211_rx_info {
 	int freq;
@@ -9554,6 +9566,7 @@ struct cfg80211_rx_info {
 	u32 flags;
 	u64 rx_tstamp;
 	u64 ack_tstamp;
+	struct cfg80211_smd_transition_info st_info;
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 40ed03a775ba..156a4c0d55ac 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3993,6 +3993,24 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
+static void
+ieee80211_rx_h_userspace_mgmt_st_frame(struct cfg80211_rx_info *info,
+				       struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)info->buf;
+	struct wireless_skb_ext *ext;
+	u8 type;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	ext = skb_ext_find(skb, SKB_EXT_WIRELESS);
+	if (!ext || ext->type != WIRELESS_SKB_EXT_UHR_SMD)
+		return;
+
+	info->st_info.type = type;
+	info->st_info.ctx = ext->uhr_smd_ctx->smd_ctx;
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 {
@@ -4003,6 +4021,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.len = rx->skb->len,
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
+		.st_info.ctx = NULL,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
@@ -4024,6 +4043,9 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	    ieee80211_is_ftm(rx->skb)) {
 		info.rx_tstamp = ktime_to_ns(skb_hwtstamps(rx->skb)->hwtstamp);
 		info.ack_tstamp = ktime_to_ns(status->ack_tx_hwtstamp);
+	} else if (ieee80211_is_st_prep_req(rx->skb) ||
+		   ieee80211_is_st_exec_req(rx->skb)) {
+		ieee80211_rx_h_userspace_mgmt_st_frame(&info, rx->skb);
 	}
 
 	if (cfg80211_rx_mgmt_ext(&rx->sdata->wdev, &info)) {

-- 
2.34.1

