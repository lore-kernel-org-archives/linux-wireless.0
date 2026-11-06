Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952016;
	b=R/ho3dHP7NJ3hKQgu6O/gpO8+nfVSF5i69Wbfy76AjVrN8gKJb5eIwIUUe/QxHkrwGeo
	 6xqIlTEYvVsDuNmv90JHsZu2QkUd0eiuMLn8cSz859FpJ7jV6skHbZFKGgP+lhm+6VgKp
	 9oJeBzKuRsJBS4ETyB4gtg/nEO0JxnvMLhfxuS2h7DoaTjRkj2Fwkn4rulOSXY0FmfO1w
	 r7zlNPvGXtARdyNQV/s9SGYXLP+Ra1NtY6KbOBKt7FjqgXugYMnqw5sCJHnTS4XlenxF/
	 2tnXBmAF7UQHmzYRv3HZYavTnGhTrF6FTRZ7UqQxB3VcrjQHw3EASQWsRMJk2x8Ry/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952016;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=58cqdlgifRKWV1I5Qv4pWFFday1yRTm7BjeSoU3ga54=;
	b=byabtzy5mylUnkweYtStJU0+auRLdsT7XSRS09qJdIBVr6ruHdeWNq3FmtC9YSvA/OUv
	 Sjo1+k9a+XviZe4UHjp3VgDNX5MEleYjD7bqRSCrJlkUSfpIlHRvWAiiOuVXS5FotTgq+
	 qYjBfNfN5YvaeXiXGuCaa5bBEIxGvPq7+ybwnpOqUsXbFromLsCP2XN/nOVgw3Kx7x9Qd
	 i2Br4SsdrCFeCBkgx1QasFk2QtyPJJu5kPLZIB1dHCOYyJfvdRXze+N9Ox6kFU0IGihSB
	 7M1XF13Z0kwMQ+h28FpxOvH/a2r3r73216atlfL61KClBvNhevyGEa10wlUesKXGgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=d6V3+As1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=B1o5cj6A;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433B60A5BC8
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3433B60A5BC8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=d6V3+As1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=B1o5cj6A
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RTlF3301633
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 08:00:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	58cqdlgifRKWV1I5Qv4pWFFday1yRTm7BjeSoU3ga54=; b=d6V3+As1GHYnrqti
	oD5UbqB4+PYCuT+n0Es+N+8abbZ1bplZD9CBhN8LqAaCTlxgndCiOfrze79VStgO
	UqNQ+O3cRWXS/+0t6fUwXHnJdjNZ2XG7GkdxGs2fc1Cxm5RL3ObqKhN4kdkxInof
	ABfgJpYc1F2QM9a4ymhHohlp3rtf7+nL8ljco+OKiTGXCHox9vXEkJJBNJscZkQQ
	Uuxv0Z+dO4OHeFx4i1umEqMdB5UcMG7jZY3DAuvurlS6brBu+7Lg29H+2sNy0Svt
	F0dnUGtpYBN1tsVanRXmajOj9qADUroKQXRKqrrwW0bmpjZ48kSOkWzPC8apbvgO
	MSVFrg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1sck-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 08:00:14 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad704d4760so439237a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 00:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793952013; x=1794556813; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58cqdlgifRKWV1I5Qv4pWFFday1yRTm7BjeSoU3ga54=;
        b=B1o5cj6ACy1fHz2Y7LSBju5tEcB30oW+KXjW6DXtVgAGQRs4phxhcQDdf3OZewPGc2
         VsNSUAP8EZHT9MaIkqkE2MAKdqKcdFYBeNCpHy46mybVa+GFeM0sL2IHvGyQgQIjPRfQ
         D0BgG1lqi46+MttVxW+AkT7BQS9kfF19MzlGWkhZNxM/Z6FrGxlwupGWYC0u/WWbzHGZ
         UYHvyDYSEuCby/ueg3A80MCsPTQuRaq0zskcLvPGHIPSnOyMxA3a+VGhRk83TgECprpZ
         sdhGRaJAYuZs4rM5ERmaPN3lpGXY66nFNMSEHIryDCgF5DICKmva4ZHmdbBPuQu0CEqw
         EgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793952013; x=1794556813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=58cqdlgifRKWV1I5Qv4pWFFday1yRTm7BjeSoU3ga54=;
        b=xMiHQqgrmAEXN9/lwBGl2e10YZjBntqJGm6285ENsiTSHA63DRhAKnHlEA4cT2r2xL
         3VsHT2SyNoWAjMHYPuOFINZ56Nkg5pvFXGoucRE4tZz2oc5C8c31xgKXaVKYTTHdl0Kc
         PtnW1OxlonhgL72rh5eFnimFIGE6aZGfChWGnIEoVDdpNHkj7ze5PrMszAPlwVhvc5AW
         9Yldck/UnbkBAdH5o/fTjepFzvx4CgBxG/1vSWKxSSCV/dWvFCDtQaVlK45cvFjGjVES
         nzuFL4VcBYkgKM3cOnAka0RvvnFQmeV7t/9qwyGDmEIk7djc6AkdGC1n2c2azRPUX6oB
         Hg+g==
X-Gm-Message-State: APuU4Z9j+ZWcvkf2gX1dOxGaJjB7saR4OMsSWkH22C3ydBHKR1Y8sTMK
	1VsNvT1HM8aIb9hIW2xiuJsEg1UYEuxwpYLcRWGuxfPur5cKg66zw9aBCVPQRIyS82QTvvPNwTM
	l6L1Ivs8vNxAJVAgasHXSnXM5+W2/336I9PkwPFSHOTjDhT4ymS9HxyMj94VBmgJ1B67eRDd++n
	g8
X-Gm-Gg: AYBFou1U5/faVH67DOAY5mqUiKFN+snM6ZyCJgIh3tnOHdF7EVCeb7agCK2QjOZoUiG
	zxWukGFnBoBEDdfcWOuYA+Kr5mLXvQK4HkZCdQmIuJDM1xH6q60NxleMKJlVuGbPs/9nSTl1c4S
	e/p/3MtAD6MBtoUCMjp18a8iuUnrr4ytJqeeCFSw8T30sUBq+rMMEz4U4nTKIcyBDXmayP+NgWd
	Q2p1aBSctVyYOD81NFMwMhrXYIa0IhFYEvV6bIaydvDN2QF/5/D89NBxN8Dy5k0CGr3ovrj80CO
	FT5oyJNc9Tg8SNvLIFhcu4xD744AgjVMRMBzXSxnPbjJ2PF+HFAqv5KxbZYLGVxmi17n6Mz4/mX
	dSBKjbK6Yi401w6GPZfcLPClkHdyvgqbRz5wCAieOoSo91oExlb4cvsoLZ2SMYpbaM23j0IZ2o4
	ZanHUY0ldP7KjcveP7dStXF3h9Eu9Ns0t0x3ZnxguDdBPXVapn+1UQXzsGbsdCSLlVlsCRPU8=
X-Received: by 2002:a17:90b:1b04:b0:3b0:a3eb:7597 with SMTP id 98e67ed59e1d1-3b0db72908bmr1272468a91.51.1793952012910;
        Fri, 06 Nov 2026 00:00:12 -0800 (PST)
X-Received: by 2002:a17:90b:1b04:b0:3b0:a3eb:7597 with SMTP id 98e67ed59e1d1-3b0db72908bmr1272443a91.51.1793952012360;
        Fri, 06 Nov 2026 00:00:12 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.06.00.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:00:11 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:57 +0530
Subject: [PATCH wireless-next v4 20/21] wifi: mac80211: add mac80211
 support to handle NL80211_CMD_GET_SMD_CTX
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-smd-v4-20-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX3cWcItP9KZkB
 EG6qNGmX194bzasoTjZpMDq58e80qeDyGx5KTxTntUvrXwhDmz8lhFLMmDfZJP5ZnICssETy3f5
 NeyvuAXpAuS0XYRs/qUsZ+q+mWeW1YoqcG2tig02FgDrb6ULEl6MAayHpL5vknFl0b+jtE+BNdP
 pVOGyhBuaUTHPyIk+ysofDp31MF3rhwX3Y3duWvC1MOU6UmX7upHhPSR+oL4Zfw6i6vJa4V0RYa
 hT0YWACdbAKgk/NzLtbkI2U0NyxOt6JbCGuh3HFIsDtAIypcUUAWcjiM1r/7HRu4MVLR9SawHsI
 mStefeq/S64p8AlBrXCVYxeIGJjhhC6W4hI0ksH6/cLoHg7MiQapY2UPR8RjFbW++V/2n8FUj/+
 +Nb4foXfH1plMo8wbLDBLEAEyxbPOzinHdVNPGWOXrKI+edGTCodb1TNuesszbqzfyFxbcun/jF
 HcdYh9b2AEURbJUYcLw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX6nf5Z7+borXg
 vHYqHd1inWkAeF/alkyOIhlp5ER5XazCRuom+EU3lxk5sTIH+3oyvfgzqhnpB7Rx9z7XOo6fmwR
 xdPB7aE1PMJKTyzbrftTn5ExhvGDHq4=
X-Proofpoint-ORIG-GUID: PyeLPAclJdCJeNh2mk0gZvHgVC9vv4mI
X-Authority-Analysis: v=2.4 cv=GpzXaU1C c=1 sm=1 tr=0 ts=6aed890e cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=x9_SPualhOxJPIen774A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: PyeLPAclJdCJeNh2mk0gZvHgVC9vv4mI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

cfg80211 supports NL80211_CMD_GET_SMD_CTX from userspace on the current
AP MLD to collect the station's context on the target AP MLD's behalf;
this context is used by the target AP MLD to program its TX and RX
queues to support seamless roaming of the non-AP MLD.

Add mac80211 support for the same to invoke the driver to collect the
requested station context. Since context collection is asynchronous,
the driver reports the collected context later via
ieee80211_get_smd_ctx_done(), which then packs the context into
NL80211_CMD_SMD_CTX_EVENT and delivers it to userspace as a multicast
event.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h    | 19 +++++++++++++++++++
 net/mac80211/cfg.c        | 36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 24 ++++++++++++++++++++++++
 net/mac80211/sta_info.c   |  6 ++++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 15d9a069ba73..d78b7e897230 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4817,6 +4817,11 @@ enum ieee80211_sta_smd_state {
  *	The callback can sleep.
  * @set_smd_ctx: Set the UHR SMD context for the non-AP MLD. This is used on
  *	the target AP MLD side to program dynamic context.
+ * @get_smd_ctx: Get the UHR SMD context for the non-AP MLD. This is used in
+ *	the current AP MLD side on behalf of the target AP MLD to collect
+ *	dynamic context, when the non-AP MLD sends ST Execute frame directly
+ *	to the target. Since the response is asynchronous, the drivers that
+ *	implement this should not store reference to @sta.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5238,6 +5243,9 @@ struct ieee80211_ops {
 	int (*set_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
 			   struct cfg80211_smd_transition_info *st_info);
+	int (*get_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   enum nl80211_smd_ctx_type type);
 };
 
 /**
@@ -8312,4 +8320,15 @@ bool ieee80211_vif_nan_started(struct ieee80211_vif *vif);
  * Return: 0 if success and non-zero on error
  */
 int ieee80211_encrypt_tx_skb(struct sk_buff *skb);
+
+/**
+ * ieee80211_get_smd_ctx_done - Deliver async get_smd_ctx result to nl80211
+ * @vif: virtual interface
+ * @sta_addr: non-AP MLD address the context was collected for
+ * @st_info: SMD BSS Transition Info (set @st_info->ctx to NULL to indicate
+ *	failure)
+ */
+void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 356c14eaa58c..26ebbc27dac0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6388,6 +6388,41 @@ static int ieee80211_set_smd_ctx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	return drv_set_smd_ctx(local, sdata, &sta->sta, st_info);
 }
 
+static int ieee80211_get_smd_ctx(struct wiphy *wiphy, struct wireless_dev *wdev,
+				 const u8 *addr,
+				 enum nl80211_smd_ctx_type type)
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
+	return drv_get_smd_ctx(local, sdata, &sta->sta, type);
+}
+
+void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_get_smd_ctx_done(&sdata->wdev, sta_addr, st_info);
+}
+EXPORT_SYMBOL(ieee80211_get_smd_ctx_done);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6512,4 +6547,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
 	.nan_set_non_evac_channels = ieee80211_set_nan_non_evac_channels,
 	.set_smd_ctx = ieee80211_set_smd_ctx,
+	.get_smd_ctx = ieee80211_get_smd_ctx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 530936ffa11a..7d23ac03a899 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1835,4 +1835,28 @@ static inline int drv_set_smd_ctx(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_get_smd_ctx(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_sta *sta,
+				  enum nl80211_smd_ctx_type type)
+{
+	int ret;
+
+	if (!sdata || !local->ops->get_smd_ctx)
+		return -EOPNOTSUPP;
+
+	sdata = get_bss_sdata(sdata);
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_get_smd_ctx(local, sdata, sta, type);
+	ret = local->ops->get_smd_ctx(&local->hw, &sdata->vif, sta, type);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d4d1008887c9..a3e161d160f0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1312,6 +1312,7 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
+	struct wireless_dev *wdev;
 	int ret, i;
 
 	might_sleep();
@@ -1321,6 +1322,7 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 
 	local = sta->local;
 	sdata = sta->sdata;
+	wdev = &sdata->wdev;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -1390,6 +1392,10 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		cfg80211_free_pending_smd_ctx_req(wdev, sta->addr);
+
 	return 0;
 }
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c156e28fa07b..cdfacbc6e891 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -3502,6 +3502,33 @@ TRACE_EVENT(drv_set_smd_ctx,
 	)
 );
 
+TRACE_EVENT(drv_get_smd_ctx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 enum nl80211_smd_ctx_type type),
+
+	TP_ARGS(local, sdata, sta, type),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, st_type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->st_type = type;
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT ", ST type=%u",
+		  LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->st_type
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

