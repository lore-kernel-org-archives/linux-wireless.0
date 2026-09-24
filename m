Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109D33DD537
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217740; cv=none; b=JR32nTI3VbyOXxLvLo7xLPwB/L4k7Mer13EZk3QYwBgujmXZi2p8ucvzsdMhyKKkpgoRHQrUsMqCQTt0tXmgiUtkr+haSpHbXZ1iBy9I8NzFtknWoTu1+3uK5Fu6lPrcZy10uukFs+292PC6UeiS3q/4ao9hg4j8zJrow/IpWU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217740; c=relaxed/simple;
	bh=6MDsvhsZRptcdzRT2KgxEhVYPgQoKySi/ytmitiXZf0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=in3b57cDchjqOvqnX6impLhv/W2XJMLVIQW/yXlcQjlR1FcwSPzRVwiHNikgt0dGO5TJO/C3svQqE/S2onThMO2PZPlqPeCOK4ejKhpVGTuwtxq7wU1qNco9uovbSTiIlLjTTDGorHrcpsKA96J1bQ7xsYMMRiL0tEnb1git4y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j8Qfdapf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EeyI6WuE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j8Qfdapf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EeyI6WuE"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2K1Pc1107933
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	22Hkp/dfmESuHCK5pIE6zDXW+3S1sKzUXW4v3WjO7d0=; b=j8QfdapfhVCH+cms
	nRsJOhaYVc7hXZwzW3QSRy0lIUPNpK/lUJ23WcqGEPvDXrocusVjHyilZpF7W5Hb
	UdoPPZqkK0unww5sl0YT2gw7jJaQaJwBgLFiy/AQH1b/DOWygq+hHfBH2Q5RT24K
	NG8I2PcbR129rE0sMQWn3bRp2q7xaxe6iNPUYKzZ7cHaZMtUo+ayWuImkAiYhxKe
	D6Cacn3mwfx6yNv5sOJ5U2U+rJwnNKPzKy1MQmkuAnzVxzv19KeylxFmzvbipGDe
	XowqehR9/d+QJ1Qh7Bj4raXxFYNx+xb1frvRUTv3DINlqhVYm+jwmL/jCCkKQWcP
	yG4xMA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvsfgrb2j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:16 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33bee712354so2033604eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217736; x=1790822536; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=22Hkp/dfmESuHCK5pIE6zDXW+3S1sKzUXW4v3WjO7d0=;
        b=EeyI6WuEQNobOh0UyTdjiQxMngKPvE38n3kp6vBr2MqG0WGhy7dcvbjwQj0IY5NF5c
         1q+oOhZwwJ+WXM/4/ElnIntUstSLy5t6tHXfcmiFiSmyKQg046lVEj2v4Jmx0JZTKPjw
         ApaYj+qJgXSBunbifNShOpO53bTFsalLMHxjkuuWaygQAPQrdQtqMeYQfEjgkoxWpoqd
         X89qWGdtbR2/eyHgZegHjgJtQAoTT2xkUU0F3PiU44dNYmxrnCf2dY9mWGXmDBMtFULH
         zKvmxM91czS7LcIoJC0YSm3UOFOhPBOo/jkDJl0KCNZfM7q1nsWXPMnJIb6+GJSpUnGT
         Zu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217736; x=1790822536;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=22Hkp/dfmESuHCK5pIE6zDXW+3S1sKzUXW4v3WjO7d0=;
        b=rPMge0r+vzhM74u49yVDOHMRujdMFCVhaXWtqvtDtO6orxlJ+JBNPLH2unZXx+m6RY
         xAJ+VQkuA86yc37T68dgnQExCzlQTpNiNnbJs7+f2Xa+fk1oI5Z25begMVeKnwrSkZ5V
         H5izRVqM7HXOlwaRcKC+Gmxz7Rec0deBp2KuwJaeh1xbuvNJhLzJdWr5yTcHOtcKL6hc
         jEcLWM5Ng/3sFkJ5363GjXvUGy0n2/hpA8TOuLfVPWamwuszPMfiFGZEW+LJOvsf1+OK
         mXn7dBQJHzIW8pBvSen/uh2wvFYB+Br1eJVaHX0JVX066x7Ld2VmTrQebTmTboUrb1ih
         N0DQ==
X-Gm-Message-State: AFuF++mL+cp1QBcexdaCawXIYkfhGOSfljU+y6osaMe6QQqRSYVKTiAt
	9psFSH/64hE/mK/TkI8YI8LfWKuwusKBxn31UOyXOtE77thzVy1d7R4cI47V2dgTJc/igWdcjfa
	RmD3vXClnytvBJFGprgyQmDEsgJeXiRM4MHKivHn9KxkJhWJvLIy6fzRS++z5qIym1fA+2oCh+B
	Ea
X-Gm-Gg: AYBFou1kWCqmtLxUKSFc21/kr7IRYL0XvGCJ6GGc9DfsXGdWhCq86R8qSG8Tpr0Pxdy
	s9DJ2Xpxgdq+6vxtlu1QgEt4vxqMkG/+BqPMxCILLpaKlObkS5IxpfPimH9MxxMLT05g8Ss4IAt
	pEE4kdeTgODMEszK0+Gl/cf3pOlVZaZN2OcLZnRTq/g5u+2TjIW6PvX41S2X0ZbJ5EMOcoA6L0x
	kY4XroPyyDlCWbfPzdjv1wA53jRx90Z/9hNuEMRiFi5xp6Lm/UUEM3KJpZHkcwKMvurJw/EU2GO
	FpE+VTAJluT6yXPFpMNrQu05UTQUQ0IVoLkae0r3u83zztvohS6qMNFN//SYlkwfe015fje4XVL
	Iekw60phI5SA/jkSGh0GxX58FP5uaZwXSmzA4uw66eY4WJMII42XZ/bT+0WBwZsfMKcU3A7tMeI
	5fw4Y07Q1oaCtqOf+2YN42Bg==
X-Received: by 2002:a05:693c:821a:b0:33e:699d:575d with SMTP id 5a478bee46e88-34003ca6caamr714417eec.1.1790217735741;
        Wed, 23 Sep 2026 19:42:15 -0700 (PDT)
X-Received: by 2002:a05:693c:821a:b0:33e:699d:575d with SMTP id 5a478bee46e88-34003ca6caamr714390eec.1.1790217735131;
        Wed, 23 Sep 2026 19:42:15 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:42:14 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:51 +0530
Subject: [PATCH wireless-next v2 14/16] wifi: mac80211: Add mac80211
 support to handle NL80211_CMD_SET_SMD_CTX
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-14-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=YfoodARf c=1 sm=1 tr=0 ts=6ab48e08 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=zHDNONmbSdC_GOYWSZkA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: 88awcPSrpyJ6oDGD4fh18zYg9uJMJLvq
X-Proofpoint-GUID: 88awcPSrpyJ6oDGD4fh18zYg9uJMJLvq
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX7ZYuzjxic5zb
 qo/TcMa9rlk36bHS9ECju1jVft796wpDcyqcEM4SsxbzdnkYYbcKL/L+c8BXEuYXiblAHwR3h7G
 YWY9gCDDg13Tz4reR6A9cwkrtmJKnPY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX7Oe/opcykAOM
 uoefPvDMJIWAShkcuL8uul7XU57xezz/WlEOWZAS/mAS1ePmFG+jjNmqhvvWu0ko7sl5W+RNnbz
 jV1NmbZ12o7/9jQpJCDDcv3/2ttGDJ316mvLIlIBbAaaS3Z8O8fiyB67oATcHOuHdSvPxxKiC2A
 yRLKeT9rk35KhrpKKeerWk+1ycMUfk1UavEiiyr5m72INTjgxGKQ/qZ/+CuxbaBSqzz2brbyin1
 fupKdtRTvj0kEUgqOXokDEpFAPCq2L0t8iPxm9NioW6Gx1tZHAdfTeZfIAcWC7CuwiqVhXTCVWa
 uIBW+0ICHxCuLMH76qar23TUZMDwdkbEA80C1DQ85NXKVJVeNbLp2YDuJBqcVAaVyf8BUpicxKT
 CV4PvmlfGQGPkXUYD8kyuVL74VEv5qNY9KpD4280Hgy9HSwwZGE+4jbXilvFGsiaHESYoMXPhhm
 endXTtMrE+HZH2GrmPg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240012

cfg80211 supports NL80211_CMD_SET_SMD_CTX on the target AP MLD for
userspace to program the station's dynamic context on the TX and RX
queues.

Add mac80211 support to handle this command in driver and lower layers
so that the context is installed and the target AP MLD is ready to
continue data transfer with the non-AP MLD from where it may have left
off at the current AP MLD. This facilitates the seamless roaming benefit
of the SMD BSS Transition procedure.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h    |  5 +++++
 net/mac80211/cfg.c        | 26 +++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 24 +++++++++++++++++++++++
 net/mac80211/trace.h      | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a377a16da5c4..9b451628f248 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4786,6 +4786,8 @@ enum ieee80211_sta_smd_state {
  * @sta_smd_state: Notifies low level driver about IEEE 802.11bn SMD substate
  *	transition of a station. It must not fail while transitioning down.
  *	The callback can sleep.
+ * @set_smd_ctx: Set the UHR SMD context for the non-AP MLD. This is used on
+ *	the target AP MLD side to program dynamic context.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5192,6 +5194,9 @@ struct ieee80211_ops {
 			     struct ieee80211_sta *sta,
 			     enum ieee80211_sta_smd_state old_state,
 			     enum ieee80211_sta_smd_state new_state);
+	int (*set_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct cfg80211_smd_transition_info *st_info);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0ea8b610a771..2cf0e80137a7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6081,6 +6081,31 @@ ieee80211_set_peer_nan_sched(struct wiphy *wiphy,
 	return ieee80211_nan_set_peer_sched(sdata, sched);
 }
 
+static int ieee80211_set_smd_ctx(struct wiphy *wiphy, struct wireless_dev *wdev,
+				 const u8 *addr,
+				 struct cfg80211_smd_transition_info *st_info)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+
+	lockdep_assert_wiphy(wiphy);
+
+	sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
+	sta = sta_info_get_bss(sdata, addr);
+	if (!sta)
+		return -ENOENT;
+	if (!sta->sta.smd_params.smd_sta)
+		return -EINVAL;
+
+	return drv_set_smd_ctx(local, sdata, &sta->sta, st_info);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6199,4 +6224,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_epcs = ieee80211_set_epcs,
 	.nan_set_local_sched = ieee80211_set_local_nan_sched,
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
+	.set_smd_ctx = ieee80211_set_smd_ctx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ce11a723ec36..e764dd394de2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1820,4 +1820,28 @@ int drv_sta_smd_state(struct ieee80211_local *local,
 		      enum ieee80211_sta_smd_state old_state,
 		      enum ieee80211_sta_smd_state new_state);
 
+static inline int drv_set_smd_ctx(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_sta *sta,
+				  struct cfg80211_smd_transition_info *st_info)
+{
+	int ret;
+
+	if (!local->ops->set_smd_ctx)
+		return -EOPNOTSUPP;
+
+	sdata = get_bss_sdata(sdata);
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_set_smd_ctx(local, sdata, sta, st_info);
+	ret = local->ops->set_smd_ctx(&local->hw, &sdata->vif, sta, st_info);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 63838a6d5d07..7aba79e441cf 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -3438,6 +3438,55 @@ TRACE_EVENT(drv_sta_smd_state,
 	)
 );
 
+TRACE_EVENT(drv_set_smd_ctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 struct cfg80211_smd_transition_info *st_info),
+
+	TP_ARGS(local, sdata, sta, st_info),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, st_type)
+		__field(unsigned int, num_tids)
+		__dynamic_array(unsigned long, dl_tid_bitmap,
+				BITS_TO_LONGS(IEEE80211_SMD_CTX_NUM_TIDS))
+		__dynamic_array(unsigned long, ul_tid_bitmap,
+				BITS_TO_LONGS(IEEE80211_SMD_CTX_NUM_TIDS))
+	),
+
+	TP_fast_assign(
+		struct ieee80211_smd_ctx *ctx = st_info->ctx;
+		unsigned long sz;
+
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->st_type = st_info->type;
+
+		__entry->num_tids = IEEE80211_SMD_CTX_NUM_TIDS;
+		sz = BITS_TO_LONGS(__entry->num_tids) * sizeof(unsigned long);
+
+		memcpy(__get_dynamic_array(dl_tid_bitmap),
+		       ctx->dl.valid_tid_bmap, sz);
+		memcpy(__get_dynamic_array(ul_tid_bitmap),
+		       ctx->ul.valid_tid_bmap, sz);
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT
+		  ", ST type=%u DL TIDs: %*pb, UL TIDs: %*pb",
+		  LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG,
+		  __entry->st_type,
+		  __entry->num_tids,
+		  (unsigned long *)__get_dynamic_array(dl_tid_bitmap),
+		  __entry->num_tids,
+		  (unsigned long *)__get_dynamic_array(ul_tid_bitmap)
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

