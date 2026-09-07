Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2B152ED3E
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813259; cv=none; b=f4Fx12I5J1bjFCXFR1dL84/fCTY7ktQYUOJ8t+muid/zOh2/pD5ykcchKYamFnqaMykaWXp5Y6vBKEXkMkovxsVeGa8SphEF+6XvedODrEKBAIampDMKED2peqG2uQKWsdjEfszU6K4u/NOVNIKpnom8cfdDEHHOW/KPmV6IvUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813259; c=relaxed/simple;
	bh=1uMWzUWflebLiT0iHAY0034lgOkn4kH51Nlr0m2TKN8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ck8CugvKTuwSJk7pyommYzmqt2h/0Zvs1bUIuP/tPEGB3fz1XSrLSxJr5IegU5gGu5V9uQukayUpIF0SiH0KtIkv+S1KnpFc5S2FuObufXlkLotuoh7nQhJh6exaYEGdozaaczrf6hrxH+c7ivRn0XLLaXNiypqNZWyCt/2RJ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PDC31RPT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kptrbbyO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PDC31RPT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kptrbbyO"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H7n751314404
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DAgmn3n8oR+1sTJOd89f91uGu1zJpklwZxV7NMQTcT0=; b=PDC31RPT4SMfGTS8
	4Wa6ZryAh/s1D4T4Ow6jnXw52Tlu4uUayey6XOYoSuWd1ylzc16uoOaink5GPVOX
	Doz2VE8380UFCw4ZRWgjln+/mnPzETFArWc5ZvkI1EgDPUxdS4zrK8QWusyHbXp6
	bs1ptYryQFxp4nMOmZAtj58PsDQdKp9gZ+fUeg6W8J0RdADU/CznaOw1++vQ8pXA
	D7HADFKbddx4T2y+nQ9bDlrnbpjLbjPrgqJpVUcJpnuPjP2fnLd0/x+DY50bDZIM
	LElQT78K5jn/P22qg0GsjLYanVe6cqY+kwt4u0z/J9B9g7Z26XM7myKQpt4zTXZb
	9zo1Dg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghuyk9vxe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:34:16 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cfca8558d2so48075775ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813256; x=1789418056; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DAgmn3n8oR+1sTJOd89f91uGu1zJpklwZxV7NMQTcT0=;
        b=kptrbbyOp2GBFb0fZz392DT6HOdLW6SxFNX+o5Nbm2C0Fh5t0wBcpCzyO3LjYRQwgJ
         +cfhYxofV9edkc5xrRXHa0MZxGKZyekCay2sMK1CoeyBpjK+8u1pBbdnB00hMk5PI6Hh
         m177CVUUKSrlP6zvQycMNB+IBLaw6rS+DlwY+qm7DLeKMRZxLtVbHD/tk9oB/cMEuvAe
         Vwm2KJLraPAn/jDZK0NwuxgLc/RLki9MtKda4ySIO2m73SW51RZ2+5VUuqvddlrElo4f
         OLNG63d9y1H5iwdIVHeDmvhgVOjE1OZ4k1s/0Jnq7Ie0SrwWfsJWfvPP2EvDggsM2Qra
         SqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813256; x=1789418056;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DAgmn3n8oR+1sTJOd89f91uGu1zJpklwZxV7NMQTcT0=;
        b=B3csIPh8kC9gEoJbWwQpsKpRseB4tlt2DjKyKMlBi+5tFfz85BAU1vmJMBoz/PeLyQ
         /tloh1LVQQbsZEPkhPhv6NXh8YsWXH+hFT2hEhujoPT0+1398/1A66YJpBJAkmdYiUC5
         9maE2JrR98M9hhQd5xSuU4Ie8rl3ywfdBcaJL6jZhQKIVwOlIuTu8wArAtnDopwl9tWz
         fMxNTKV4TyoafjF/WohrObnWvMUvimLZ6yKlpM4/Qqct9l/gUB+kDHmS1j0iirpI9bbR
         eaq4omygezlRsHo41DF8ZZbY8n5PfK9v9+6XxRjuM34vw6kekFnrix7INZp8+OnTC5TO
         LReQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3XodnTLBaBLTSEpv2dHy0lLJ8tCrn27hI2SvrAft51vvufGJ2oqsEiMr1GqTVIIfk7OAx2KhMtt5dw4uuOA==@vger.kernel.org
X-Gm-Message-State: AFuF++k2ubh9G7JxGnve/j7xp4hp6pSrBAI2ntClGY+fnQmFrvXXdNvG
	nvCIA11IIVh/O4A1wBZSXYfmE63F/uWih46F7KJb+pMfhWX0aTcmalegtMXdxi8v04jHuwJoalW
	Qov3YZw1Bc3HPqUQm3cbPMn/JCF5iNYQLaTf9+tjXRv1alVHyXn0Jf9wDbPtPa6vNH+ia
X-Gm-Gg: AYBFou15lcZ+ZeQWxp5oYmJ8GihbNFNExDQF0rHcXULbge5yEUGm4yRgpGYbSp/Z9bR
	P3wLpK3paFmFfesIUzb6no/U/rgmS8TVXXdyRhYqgPp9tQhgxwqVDOYQB09aybl7fQ8aZI/MqFK
	LnfHo0T6xJjrR/35umbIFc7kt0CRjcb2SMmZmLM69yT3bzb0EnZhKxegjOKozMbzFVdhi4wC7wi
	4K5YOPIgPvXs6bZWoX+TDUOpm6lfDQNbyQs1S0XWc4IvvYue8A6jNoNS6e8yjspChyqqbEfyFjl
	YGS6cJBTbIVBuVf8nvArVPsSwuY5BdvsppDaCKmFo5A2pJAL9QFIIQ4wOz2ecSv3QnLgx05s/LM
	dO6YBdIWFoShqMp/d97y2M5PAAw9hvxr+BG3PlUQmQeT0wvpirsjYXpSzrKWbBu6nLedXCKd1Th
	lGo8t+JGWfIQkR6Wbq7Y0cVw==
X-Received: by 2002:a17:903:4b04:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2db124b1ae2mr338036265ad.6.1788813255584;
        Mon, 07 Sep 2026 13:34:15 -0700 (PDT)
X-Received: by 2002:a17:903:4b04:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2db124b1ae2mr338035425ad.6.1788813255020;
        Mon, 07 Sep 2026 13:34:15 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:34:14 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:25 +0530
Subject: [PATCH wireless-next 16/18] wifi: mac80211: Add mac80211 support
 to handle NL80211_CMD_SET_SMD_CTX
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-16-65ad4ab30fbd@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX0QqBU3nO9Qps
 ZjCDzU6VLDUnX9vWfDofEQKujPjLwyE3/32aIOUyYcLrXSPJ1MHfMVlt4tvwdVAMpNRW+L2SqiX
 75zvVXbJmdnaxuNrw6XxTdaaeHN+iMQ=
X-Proofpoint-GUID: 3LNVTr7l_ejxoSq5hlCpvqLlbvDXY4o5
X-Authority-Analysis: v=2.4 cv=ObSoyBTY c=1 sm=1 tr=0 ts=6a9f1fc8 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=zHDNONmbSdC_GOYWSZkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: 3LNVTr7l_ejxoSq5hlCpvqLlbvDXY4o5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX6T+odNXND+jH
 //T0n2ve70Z4Q7jB2GfFv0Ys3O0vK1AqqVoAXwZMlTRwwzz86pShfi5olUF+H3fARXtfsJ3F2cL
 C4QWGEOLqW8OsvQIL9YnCajQnpZKQsmGXFSPBJmAjM84HS7eYVVQoLJTbXGd//NZ5Z7mYHhdGJ5
 zWp03EsxUCUk+d4k7P3jbIoPoU+bopa+4KYuKNJkmWR5p8+YYkZ58KH7HFzpiVbJrGpWiuV+aiF
 to7hcHqpkvTdgF5B+mEsaknVmaGfUIFBM8xeitSQbNn8HboAhc7zzIOckI7/gBbicf6LEG4tDzQ
 JSTtz7cDAr0HE8MrLaemriK+fIle2oRC1MjIJ++6QarGoB2brtdS4zQZvYdjmWzqb1IKvUGfWz6
 p3bcdN0td/ipMi1l1aHBBmPOE5sOZHd0HYyObKZ8Z4wxj9xkEWr1wpL84d/E29exI/wtKOvX2pA
 y+NqsigX8fBILNqS/Lw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

cfg80211 accepts NL80211_CMD_SET_SMD_CTX on the target AP MLD for
userspace to be able to program the station's dynamic context on the TX
and RX queues.

Add mac80211 support to handle NL80211_CMD_SET_SMD_CTX in the driver and
lower layers so that the context is installed and the target AP MLD is
ready to continue data transfer with the non-AP MLD from where it may
have left off at the current AP MLD. This enables the seamless roaming
facilitation of the SMD BSS Transition procedure.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h    |  5 +++++
 net/mac80211/cfg.c        | 24 +++++++++++++++++++++++
 net/mac80211/driver-ops.h | 24 +++++++++++++++++++++++
 net/mac80211/trace.h      | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b4b1d3db9b19..e0e13f0ed31f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4780,6 +4780,8 @@ enum ieee80211_sta_smd_state {
  * @sta_smd_state: Notifies low level driver about IEEE 802.11bn SMD substate
  *	transition of a station. It must not fail while transitioning down.
  *	The callback can sleep.
+ * @set_smd_ctx: Set the UHR SMD context for the non-AP MLD. This is used on
+ *	the target AP MLD side to program dynamic context.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5186,6 +5188,9 @@ struct ieee80211_ops {
 			     struct ieee80211_sta *sta,
 			     enum ieee80211_sta_smd_state old_state,
 			     enum ieee80211_sta_smd_state new_state);
+	int (*set_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct cfg80211_smd_transition_info *st_info);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0ea8b610a771..268d5f42293a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6081,6 +6081,29 @@ ieee80211_set_peer_nan_sched(struct wiphy *wiphy,
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
+	if (!sta || !sta->sta.smd_params.smd_sta)
+		return -EINVAL;
+
+	return drv_set_smd_ctx(local, sdata, &sta->sta, st_info);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6199,4 +6222,5 @@ const struct cfg80211_ops mac80211_config_ops = {
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

