Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9543E2FC00D
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813271; cv=none; b=pCIWy8optjy0fJtsCK4AJGUDFx75ECA7A3pg4ujjRqiSEo/u6uUx7Ed/aNPSYznt2gKr/r6O7yPhFeB1egmiqSqqVgRjQKqywfGZfIvOXDFgmDo9xMzdYt4sSjEo4WGnEhvG4h38kgyGEaAQOZRqEHd70ECUmd63YRZNvQQ+1nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813271; c=relaxed/simple;
	bh=FQBKNG1LQN+Or7ubGtjxhGSxqu1NLRi2ZcAg1jgnpUg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RA1XXeFxPdPKWEgOfRs6wPgbOymkhGqR+UVpo/ahWXe+vMf5QUiu6hMBkGdL5meyZ7vn9eI8IHuJ0liAnib45P8J1two2ymo9F1jOcTVD6Fn794zC6lEx5AYUyBDzZJ7b3YsFQ5sZo5J4FqppX+5nyzlsAK0arMcgwNR40L1XM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OoC2xGnw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G+u0tUHX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OoC2xGnw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G+u0tUHX"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H7x5P415156
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tJrfU3MojC9W8Hc4my3vk6BlrKJp8pREKh3Df4ly1FA=; b=OoC2xGnwIVw6+/zZ
	YxCdpugcl1dqQF7oeAl0Woy+xsNAbcrpS3How7xgwvFlmMivmSDKD1m4A8p6gFaw
	lmbqNMzvXFJ+UysU+cBoneggQhjbTZqatOqXVxFcL9aa72vQKZSZFgwFFgp8W225
	qKQ9EyIvr7H3jXCxqLsYWSAMi1T+MizyceS9FcrFVSKtdIiENX8idaa43/JZA7GC
	X+ABngcgEW5MkJhrzyK2K4AWyCCMefZIkS/X7c1700R/IUL3P/tI/5szjMnxFkIC
	ct7roYKVwtSpD+OUbhF4fe2YBPgPmXQjYTcnLUWG8MmqCOY1GIOzvpCNq75l28+C
	cKJGPQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghsfyjkuv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:34:24 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d932ef41c4so53814065ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813263; x=1789418063; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tJrfU3MojC9W8Hc4my3vk6BlrKJp8pREKh3Df4ly1FA=;
        b=G+u0tUHXHB2yPT7hkdqvLOgH9IjLDnGbJ0oWvFmX/MJg0/MU/erCHwppJOLz+B/IHl
         uxaWDZzDaSZk9utDQoZwuI5ar1xtoUHo7mOejggMpy2JYu/8mW/RSNehzMP7EHXF0XEg
         ovj6342iZH+IQyqyMvk1Wb6ZqQSzENx+VSBI9etuPvhwo3ZOEDf67yFyPMcwlFbJeGen
         hLdldVwPkERXHer+hHQ9a5tWXtXepTyEBcS1bcn2eW7z97GjFWWopmGtncf5qe5HZKVT
         PhIAoMZhqOxWrE9kCtgJqfIJmkz/AwtS0UXuvrJTIyLL9YUzijvgOoFa4VKvwN68v4y+
         /8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813263; x=1789418063;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tJrfU3MojC9W8Hc4my3vk6BlrKJp8pREKh3Df4ly1FA=;
        b=hpUwI/BSM8ivXmj0EvZetfJwXf1yaxg8sush/ev3CSdn1hiQ5Nb7UUXopFKg0ysga6
         rM6vi+RduzN1gYPeC8/GNuJz7dsC/0io8Sy1bk7I3KVllowPciPeNZkhUyM6HttO973l
         sykMEAMWVCSiaH8Ff+tb2xRNOgWTD25iS5Og9yzaynfWb9wLVBRCh//oLJf7aUIds+pV
         nEXR2nhr757vhzMdUyj+sEV74q/dsO541im3WLOMCkgcvplbkifg4wiqDU3KejJAfLea
         oveTuOdU4mXy2EKeH1E52p/gfdbEQubP08pFyAIy0aaiRm6gmH7lm4LydOwtO3qEyLPF
         81KQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZ0IdlUld05YdtWpF89sQaUFfoapAKqpik/hnC1esE0rgy6YSbtjWhI3njyLwGgKj8QYir3a8spipvbT/dIg==@vger.kernel.org
X-Gm-Message-State: AFuF++k4yW3i2jR3lXEEI2adT9W7UVLZB55XBv9AXGBmloIXRXzjDTa8
	RzREEdkc0gwfUv/ss1mHypNeYqRP1wjRXm2QtjNlT7oSrJYzu0jCY6l0Ov/IO5loPTv9sZpU6UF
	TNt4p678geTFN9y7xLWd4uyd0H87cMCenxiyd/aOTfHoS7d4kiqYQrhJ9cUrXNtk1SdYL
X-Gm-Gg: AYBFou0nDzfoIXqNu5S3C1zo5DpOK7XYG7OWUjsbyMoIOv3RPP4r5EgJnKisALt0ClW
	3g0q6sVl5VSeumbrxkEJx93zuZG40wqm9FI1RaJpAeCUO8NNO/EvgL7VwieMaRCV3pZLoMTHVWe
	larQ31H8272xm/w8az6q5z26wnkmm3YXCVw0MRA28E2c89Fpk+Re42+M+iVa3msdAfZ4mDwRn/U
	hQQ+5QwlCbfmiB9Y1N7+EKfd0K+HKZ2mPfVAUoE7L2yrT/f+r7dPuMeIusc52My4A4ai/vy/4Qc
	w5jzgVnF1qTueGyg+5Tt8N3e6v5OVR6Ee6CB5jWnK8+xBOfwwF7+LxLAx3v8yJdY0ANGAbxXcXj
	PNXRdE70p2oS1MRO2RM10MeutnKZJ4X0RljnouY/XXs3V41GV+rRnUrAj25l8B6zrruyiICJLrk
	glDLwV82MHvb+SS2QoePR9og==
X-Received: by 2002:a17:902:c951:b0:2d9:2b1b:878a with SMTP id d9443c01a7336-2dafaf60ec2mr291623925ad.10.1788813263335;
        Mon, 07 Sep 2026 13:34:23 -0700 (PDT)
X-Received: by 2002:a17:902:c951:b0:2d9:2b1b:878a with SMTP id d9443c01a7336-2dafaf60ec2mr291623525ad.10.1788813262835;
        Mon, 07 Sep 2026 13:34:22 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:34:22 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:27 +0530
Subject: [PATCH wireless-next 18/18] wifi: mac80211: Add mac80211 support
 to handle NL80211_CMD_GET_SMD_CTX
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-18-65ad4ab30fbd@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: _EGUofcb0kAkq5p7jpQDTE5Wf9CZp1Ly
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfXxZNRL6/N0CAs
 G+NjZR4PRK1TTiDVIej+uR7EVOEQSVF3exTq9R+Umd85HG7LhTBYBvdosuDRj89x2oBtyocDheQ
 t0Q1PXOeeUlSzmk6LDjkfcBE84v2rAKQP3vgMPFeNZCssxkVrvEISXkmuEZwKl1JQqXQM+eWRG3
 82RW83cgivVO4kILLi5BiUgKbmckoOSWcQt6GH0Sf1r5Hv8YfJhcAvbF6/poZiQauN2d0TRikaP
 9171yk4SzagBU8UQibo+gjA+g8ji7Tp68Zb1o7KXPK32T0VeJx2IlrVUJlnlZVdp87IrX62HqFa
 D80a+lyOgTspGrC0NGRjQh1kLBmt+05XqRjpPRiwjamJa4A9TKMNAq125JptgklBksub1zcnHA0
 uDUm3F7+o2yLsCNn7A42STIFyxCwAn+s4/KyY7PJVHRRMTVSVHsHVz9ou/7m4NXV4vSkyhARGYR
 KfP9cyu1cVD+p0lmk4Q==
X-Proofpoint-GUID: _EGUofcb0kAkq5p7jpQDTE5Wf9CZp1Ly
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX1okd1KrF3RXh
 KF7Yy/FNU+hwDrALeK88k7k4A7yz+2qlgAxNlQrxWrBuSzOOPgjsFcIL6bSDnTmgswqzDbBez56
 cCflZaxLuWNHBye5n+uazVR1DNV/msg=
X-Authority-Analysis: v=2.4 cv=AduB2XXG c=1 sm=1 tr=0 ts=6a9f1fd0 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=c93CP5vvwBK-QZUl55wA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

cfg80211 supports NL80211_CMD_GET_SMD_CTX from userspace on the current
AP MLD to collect the station's context on the target AP MLD's behalf;
this context is used by the target AP MLD to program its TX and RX
queues to support seamless roaming of the non-AP MLD.

Implement the get_smd_ctx cfg80211_op in mac80211 to invoke the driver
to collect the requested station context. Because context collection is
asynchronous, the driver signals completion later via
ieee80211_get_smd_ctx_done(), which packs the collected context into
NL80211_CMD_SMD_CTX_EVENT and delivers it to userspace as a multicast
event.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h    | 23 +++++++++++++++++++++++
 net/mac80211/cfg.c        | 34 ++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 24 ++++++++++++++++++++++++
 net/mac80211/sta_info.c   |  6 ++++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 5 files changed, 114 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e0e13f0ed31f..f16112e41594 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2528,6 +2528,21 @@ enum ieee80211_sta_state {
 	IEEE80211_STA_AUTHORIZED,
 };
 
+/**
+ * ieee80211_get_smd_ctx_done - Deliver async get_smd_ctx result to nl80211
+ * @vif: virtual interface
+ * @sta_addr: non-AP MLD address the context was collected for
+ * @st_info: SMD BSS Transition Info (@st_info or @st_info->ctx may be NULL to
+ *	indicate failure). @st_info is owned by the driver.
+ *
+ * Called by the driver after the %NL80211_CMD_GET_SMD_CTX context collection
+ * is complete. mac80211 forwards the result to cfg80211 which finds the pending
+ * nl80211 request and sends reply to userspace.
+ */
+void ieee80211_get_smd_ctx_done(struct ieee80211_vif *vif,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info);
+
 /**
  * enum ieee80211_sta_rx_bandwidth - station RX bandwidth
  * @IEEE80211_STA_RX_BW_20: station can only receive 20 MHz
@@ -4782,6 +4797,11 @@ enum ieee80211_sta_smd_state {
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
@@ -5191,6 +5211,9 @@ struct ieee80211_ops {
 	int (*set_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
 			   struct cfg80211_smd_transition_info *st_info);
+	int (*get_smd_ctx)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   enum nl80211_smd_ctx_type type);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 268d5f42293a..a33ce96a4752 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6104,6 +6104,39 @@ static int ieee80211_set_smd_ctx(struct wiphy *wiphy, struct wireless_dev *wdev,
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
+	if (!sta || !sta->sta.smd_params.smd_sta)
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
@@ -6223,4 +6256,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.nan_set_local_sched = ieee80211_set_local_nan_sched,
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
 	.set_smd_ctx = ieee80211_set_smd_ctx,
+	.get_smd_ctx = ieee80211_get_smd_ctx,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e764dd394de2..0339ff71cd4a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1844,4 +1844,28 @@ static inline int drv_set_smd_ctx(struct ieee80211_local *local,
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
index 5aa6f5b481e3..9ea0a8791289 100644
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
index 7aba79e441cf..38ad5076232d 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -3487,6 +3487,33 @@ TRACE_EVENT(drv_set_smd_ctx,
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

