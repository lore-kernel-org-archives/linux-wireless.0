Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35DF59B688
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887463; cv=none; b=sD1CUukxKF/uVZ8gnix1aUOmTlqUlTTuzHhtyPwhVw4nbXT/b0dlfnFKovt8TYtpfvd3tSGloxu0Xgld/zmnKS4AfKph2EIqtOQBjh3B2k5ovUW9fPOoqRmry/YMnWA3Mn3hAt8BbpwVpaeREWEfEAxEf9jzh4dqGMKfnrWuDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887463; c=relaxed/simple;
	bh=/xXrRGDv6Jszk0sj0UbOjDjGSuSuowHtjBK+vXW0/Zg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDgXVizj4ETBvNJtNNbBJAJZbAKQXqhu06coo70fPyX4psAjhmNT5EOI3GcmyCTjp5NKnLgN+UCqj/uH1d8o+5Xdym6qMqkHAVFNu765pTEyUng1VAYpwEWw3tjnHYq2AQuG/SjaXUnb4YScxMXYvyjqmo+M0F4A8bGp9Ab06FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AZczlrHR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qs7fNUF/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AZczlrHR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qs7fNUF/"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdYEm3322664
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2FTgMhgLWmf0Jq8fB7caGXnFJscVEgzrr/HiqFpuFaU=; b=AZczlrHRn0oTuvm+
	u9vjy/xyJi6Uxt8MLyUCkTP5Z3IcPfTj/QNTir7WU/x0d3FiRb/ntb0APho+hKW1
	nMJt9RFViqU97eU6ORox5bhwO8vukjNi7X2JBXmg3y5W20/B8LlzrvJwDMV3+Rxc
	Q6yeFz740o06bCv8OdhV8mbwAWoYGNUdQ40kzvtocQ79JRd4bpoz+GWe5fMAtP0e
	O1F2SyswjBkGDLBK3xwJqjYLrUmW76ivPDSaAUk+6nbLtyuS/BbZKY5UeqPIEyjH
	16ZcgPvylrThs0wlyupKqcm1Z4kRqJEAxgDaWrFosXsPJHpUqNsQSKxAIzm0g63D
	6LatCA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjf1cj9xh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:59 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa4e4684bso25470865ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887458; x=1789492258; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2FTgMhgLWmf0Jq8fB7caGXnFJscVEgzrr/HiqFpuFaU=;
        b=Qs7fNUF/w1CDJMiI2NIbSN/HeXjjvzxduwOh8jMmqneDPHZKcN62VqYeSYDZ9H4SMO
         kUe/7+I/tR6qHFEuJoJjMmXN6iso7xPkEkT8e/zzI7rf7/F1rczEIoGDSgagoGaaVxho
         hZ2CHLPw0JxL8K/6M5Np4O0D4Yud8vpHxp9wtvJytp5V/ixrpYI6Sj1rINOL8AkbQ905
         9X7Hw48q8fsQzElmO5PLLRu6MtkxAFSQqD78CQJV3oIm7nQC3/ETFpndL2tTkyEYwayp
         vR1jwqrveQsrAsq48j+Gs4v+CmjVRNX5Qy93LClL0xclMTJWfWqkCt3wDWB2fR7cD5pU
         h7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887458; x=1789492258;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2FTgMhgLWmf0Jq8fB7caGXnFJscVEgzrr/HiqFpuFaU=;
        b=o6sLyHYvUtXZhk0p0eVq9OSzXYwVNi6NWx6D/Ghmasc3eMXf9rYjMHzdosTA55UQUL
         iH+YAQEJiNjbcL2aWtwiOzbmmCki82Iviga442N7HX6uwgbP4GNPybWtYh+kbLFh+Y+V
         XRt9g2a0acJnH9vbbOaDzRcn6F8/kBLOTqYdlfsqT4/mtDoE6lcRKriAYwvW/jhr2/gt
         +3CWDgTJVAP0eJszDaPpstLFDQNsNxrO8KROXcNago2Bv9Wpz+6gi/5ZKP9QsPrPrvp/
         BG+GReNR4CFh/Yyx5qXECdUw74y2yagrZCBHXk2oewPyZrhsuJKYrgDDqif/VYZsgSOx
         ZQkA==
X-Forwarded-Encrypted: i=1; AKwUvBzJv4/7Ai5Puv2Dv/PA6jmEs46HHEv5fPFMiGk6d7kdZYrqxVxTZ/CJ3n7O2r/cg0kOzJI0uo25CwB0pcmi7Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kzQ4hemqvtpomCkhSlB0AGmwsUO4FPDMmk40Ph1M6RLB5mVJxr
	CfUZA8CZagNGsna2M4st4Kg4gNqmG3f9B/sFhIOBmo88sz/Rkux0n1r7ufkREAmSkKJ+u4BuFH5
	RuebRKAOaaiUF81LFEdD8HhcBSTeedM/LK4f+OYaGNI/x9qS2M547BT/FkBkAulS2cQ7j
X-Gm-Gg: AYBFou2Xxe1LRJwfM2EEH6kvkO/D2RQihiLpoS9RIs5ClnutOk40nJNxNtjgDD4In+3
	2B7IiSQomAF1NWK1tnueIILC7b5lkD4cXXh7rym+QgDFbWxrUYucRNci1h/g5KzNwvyH6R9ccj+
	bbdH5IbOeIl2VYiHGN8oqpDLPL1llaJVvPXF5jaIb5tfLS2NflEVCvLJ7GaS+10kBqILlVwr8+c
	gllBzA0b6qLN1BoIwUUiYn6MnCfBVwp9Zf7exijzsPRvTEsgly/f0RwbwSWTCqQQ5y+xrCWDZoc
	F0q2TGz89Z6DeXlQNscBBSCl2aIqxTHPvldrS5cp5AX9CLSbxaXpgORzaPINNxeaJ2zJMkTyKyj
	5wTrKSr7RYKtLuxSp16oeBJG/3e/Py8OPwLMjfHEx8RweNXOkCJkeLfuz+aLcHWJTWQQ+qqY43C
	Z/EsQmcGGfCHg3OMTuzkykSg==
X-Received: by 2002:a17:90a:dfd0:b0:396:61f1:da5c with SMTP id 98e67ed59e1d1-39b260de667mr45062841a91.4.1788887458470;
        Tue, 08 Sep 2026 10:10:58 -0700 (PDT)
X-Received: by 2002:a17:90a:dfd0:b0:396:61f1:da5c with SMTP id 98e67ed59e1d1-39b260de667mr45062771a91.4.1788887457864;
        Tue, 08 Sep 2026 10:10:57 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:57 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 13/18] wifi: cfg80211/mac80211: Handle UHR Link Reconfiguration frame
Date: Tue,  8 Sep 2026 22:39:41 +0530
Message-Id: <20260908-smd-v1-13-9fd2d876a1fb@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=VN3tWdPX c=1 sm=1 tr=0 ts=6aa041a3 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=LQFPhaWwRXareCLbuGQA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: 8knn0d9dhZs74CrnOpJOK6aU1CxBODB1
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX+PCBy6PAFO5/
 7aD3oF1Q8qJGo3elM26CROs3hnntGXoBgCt4OIVqqqWvlYjcXgUjRtZA4NaxuC5jtujgs6oBT4o
 X8doUHNvutHssuThKU0GkTPLjYbKxzM=
X-Proofpoint-GUID: 8knn0d9dhZs74CrnOpJOK6aU1CxBODB1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX2jYfR+EWivUd
 RnS2qGmp12tpSAaTJ2TjvvDAYDagZz6+hshxMshkgshpuKIkbRtkEC55S5tI7Bd1yCZvmAEsHdN
 EOl2ZOxmu295eSWgGYsUQGiY+ZUJE5DRMYF3Hw2Frk+f/CAbaoLGqW9AzZ4I03L958euz441uga
 JH49LPg/RGCqMot9a2BCsZDzkD2B1byQvEE1sQw44/r32B47R1i+OPvS1OAdJloAOtn0x01+EDU
 5BFVGExrgfjfN1gEM0LNxS9Tx7/Qo3+x6RJlNGFHSAU2I1elsrBelIOnuu7uByV1wXW3BmqXjvx
 yYG1IpxUXnmb5y9Sw4Ihupx6xEAZcBm7QKEDtccfGLXi270U23QYF3tUJbsQ8zPOI71Jv7r0ODv
 bBl4PMLv2CgXNgPglDwMlK8GlpnN1PNcfyo+w10REHHF4kIE0blv3sBLkamFExP95iAB594gN8w
 QJmGQd28auQ6YlAvDfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

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

