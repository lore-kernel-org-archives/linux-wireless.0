Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EB3E9C0E
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043707; cv=none; b=YZO/w0YvpB3fFu3239uPGqri7hqJgFP3vcf/gC0ibut8o6B+OGYaQ35Ay3qYxAAclUZdD2FtR46RNNEu28764iEF6PymXYwdfK/xDxUeTpO7oETGVZVIaxfDM/W83K9qSNdRyzS30sBakhfA2X49cU3C53JqFdbN25LmTcg420k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043707; c=relaxed/simple;
	bh=O+vmDEA9SrtszxaXtYYJdU0mWKZ8IBwdvgKnZX0qXSw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lwh5dbsURWzDkPdVaTNd3kmciKZp0NiaJMUUQroiT8WaFIeJXm5DWF3+Hd323zE3ZpTmIoQfGL7Yvn2Iu6FZazHmYm+NrcE1zyT5DDAXQGhxk2T2O8T1aXYgth26MkhBm72GccxflJjtMFNRke/vbwkCJBxXIPE3yKKlGNxrUKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dX6G9SlG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g1MMGJ2/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dX6G9SlG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g1MMGJ2/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F3xUV11641221
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=DbeCza8hA1q
	lMcN+Uvbg8tIR05Pv/Xitan3no9pyUjI=; b=dX6G9SlGApvAR/YlFYi7RZp73m+
	4Ut8sTXFpRCpOik3vIyJhK0OQeYZJtnj+4NP9IyyDt53Q5+Kl7annPyb0jEHSs4Y
	QxgZhJSfV0RFvvc8gCqfcc9hklB0hsOfVhFPkqGQQyyUWbv3kIsLGZHLoDm0mSfX
	Y41yZ6zMLgQ7Uvau8bREsd/ur3FOjVMBOnx0u7SjAy8pufKUOykRvuwLgMMm+lv+
	dI3t7Fl7D3sKyGEqUzf9U/si1WX/i7d/e2ipXvJolMxxdYj7jquvcJE7BqQ9YMoF
	ict04+kGZyiJl9n81xds4Bv0ei0yVqv4sYLk57AN0jU6o1BKybVoGGt05dA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haqdhgcbc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:05 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e941532594so14036545ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043705; x=1792648505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DbeCza8hA1qlMcN+Uvbg8tIR05Pv/Xitan3no9pyUjI=;
        b=g1MMGJ2/3sV1dtK2hNgYzUS27BP4eW9FDRYZzab2PLowtPcwThpgBUotn4zxf5LQVu
         QpeJtfv1GKQEu+eLLQ5onGWvxc9ePeaph2xFX+LK96T6wL4fOG9QRDLNbnbEY87081fE
         niRDowhDP9mLkqunnzbSmm70eMv8PcSlwWReu+W0O+KYnNWbfTK3MPQo9/Et+XdnKjj2
         ZevMEgrKrOf6xV1tlTdvEtV7NJUl0pxA0wSvPMYCuPpXsgEx9r5dHku/BU8b8F79joQk
         Idl+hD2kVSWJzZw80tnDGRktl0xGXBURIPVAVst9KUmDJnhCYlpPrXpp9d+8A9HanDeq
         +4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043705; x=1792648505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DbeCza8hA1qlMcN+Uvbg8tIR05Pv/Xitan3no9pyUjI=;
        b=ZoQT7q/6YKxpW+O/6RxzOsbPwVKYdvUZgFqi1OyZOt99iHkEa8ZrvEQ5YPrPwy9ahA
         EHaGIK3XeBttK7oUkN3Ok5nitXdI4Zb6zKl3XguUB5+1W5NQRzjT6qM4NuSitE/t7dWq
         JJtBq+h2gZl/2b3+objSqmxcPolq298yJNBgt3MuMqE68m8yKYagWaYD1DwnAT3Ddh/e
         VMK2isDgiPOEYnjVleXKqDNoOFizkUNc2xd1VquPFT54GFuaPPKC//Fcug7Qxaf+w/Y9
         80MrCClU2D3sX94/v20ojlOV4bsQ+dMSJLL8+w2vJUvLMyM8robMCCIP0MB6MLGSh4+r
         +yCA==
X-Gm-Message-State: AFq9FYLCfkX+Sc0UV1szSLIH3atQq6CCIC970fPLptlZbmdBJB2eZptF
	WrqnzMhmhYyRsz0iQ+2KE2zXdFS5eRo1bje9ydMWgPoIFeqWPOOARTKYcsUP3nNjFGy1D6T1AdW
	+GdHZ0TNEluf6Kb45OkiQNyuRyQ8W0LoMhQaT4IWiLIQB2nGGc5s8UICZinRCrh4i3BK7Rg==
X-Gm-Gg: AYBFou0XVrporFwDLb5ZD1K0u2W4yAQuCkFUc+A8bxpgwD5R0qWj4yaB0j+h0IQzGWb
	XTzz/6lXqOriGKAiYNyUf5D+Wtfq/87Z1SJFWwtU3UC44qa9w8vzSZzh9RlkhbpALPOy6Uw+u4v
	JxlCDazksuu+PtWjDHAwyrY+P3VQ4YbQ4LbOESlAoS8PMz7tkb3FX0hyqG606D4c1Ukn6ZAUFIY
	Bp9NqP+gtVtye4Qmjrlylo7LcdDWAIF4A8D38ZXrjIpI0cSeupwWbYxJbV4X0E4//IqBQeNIak1
	2OdVrFKSGP4wh+XGgknCAmlLmkK72VW48TWGxH827tDymUUsT5ED2nbX/OndX5gT11GeoJAU4xL
	Zueggqgo09x43ArHpxjbDV6/PuNgxrU4LqorTEvCGiZ8cX4eo/nNoxQlvE7Yh2YpxC36LXsanBk
	c/CNe6frKRZuSJ
X-Received: by 2002:a17:90b:498c:b0:3ac:9176:e81c with SMTP id 98e67ed59e1d1-3ac9176f12dmr1951402a91.46.1792043704392;
        Wed, 14 Oct 2026 22:55:04 -0700 (PDT)
X-Received: by 2002:a17:90b:498c:b0:3ac:9176:e81c with SMTP id 98e67ed59e1d1-3ac9176f12dmr1951389a91.46.1792043703926;
        Wed, 14 Oct 2026 22:55:03 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:55:03 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Arun Vikas T <arun.t@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 4/7] wifi: mac80211: forward QoS Management configuration to drivers
Date: Thu, 15 Oct 2026 11:24:38 +0530
Message-Id: <20261015055441.680588-5-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
References: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX/G8EMQQJwURX
 nZ9LeyUJtz9pgEJyGSBsFwcGFv/ilX3+/FxQySzOTWw4hq5+XA1r4LtFvdoegGcIbgxAwTSHYvE
 olNDqlagGGGOBifOnbvOeFKq2gMIyO5QxAIbBETeEIuSwFIuWwBWVCt3dFy0XH3F0oQOqPdI/uR
 1wO1F2sOHNEoRyHFmJSKj+TlyBLiPPHOkfZRxaBBZKmmwWFTW7phYHK7T15wwCkfoGSVT4ZZ71X
 vgeW6KX3PM4tQDMLlgfz9FK8XDwGWuFpoJmIV1cN5YRDqv1bebO3E+zEDaY59eNm8jKmlVRd+Gp
 r8r3FHujVe44ysZM1/tY0SlmvD4J117l26nyZoC6mJhJKNnQCqjqJlEKvi5AT3LZ8IMFUOGSAEK
 0CUjp6JaBgZPCrp6YD+fVa0ryG/zIbmN0JEwUkTC4EiszUqFwWzLvje4+p/QdXj+bcSI4yCWtOD
 Fld92tufo76YhTQecBA==
X-Proofpoint-GUID: 4i2xm6QLwWgIZq868-NPPXQ5EIAJWGl3
X-Authority-Analysis: v=2.4 cv=DeeCOftW c=1 sm=1 tr=0 ts=6ad06ab9 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=ZuwutKCGwYuCb3peWq0A:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX8as93DHelxwN
 HO0qHUlGI4SOSNSrkF6RWxPOYbGJqS28dvdFVo0K/qIJspQUI9sm5TvKFqzu91Ii+2m1bbSACCJ
 JbgLWXkuOC2oSuoSogkB+9JUJ4SLuDA=
X-Proofpoint-ORIG-GUID: 4i2xm6QLwWgIZq868-NPPXQ5EIAJWGl3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150023

Add a mac80211 QoS Management driver operation and connect it to the
cfg80211 set_qos_mgmt_cfg() callback.

Pass the parsed SCS/MSCS request, including any QoS Characteristics, to
the driver together with the response descriptor array. The driver is
expected to apply the protocol-specific configuration and update each
response descriptor with the status for its corresponding request.

The accepted configuration is then retained by mac80211 for use by
subsequent data-path handling.

Co-developed-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 include/net/mac80211.h     |  7 +++++++
 net/mac80211/cfg.c         | 13 +++++++++++++
 net/mac80211/driver-ops.h  | 28 ++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/mlme.c        | 17 +++++++++++++++++
 net/mac80211/trace.h       | 24 ++++++++++++++++++++++++
 6 files changed, 93 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a1a6409b44c1..a610d6eb92b4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4760,6 +4760,9 @@ struct ieee80211_prep_tx_info {
  * @set_eml_op_mode: Configure eMLSR/eMLMR operation mode in the underlay
  *	driver according to the parameter received in the EML Operating mode
  *	notification frame.
+ * @qos_mgmt_cfg: Configure QoS Management (QM) for a station. The request
+ *	contains SCS or MSCS parameters, and the driver populates the
+ *	per-descriptor response status.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5173,6 +5176,10 @@ struct ieee80211_ops {
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
 			       struct ieee80211_eml_params *eml_params);
+	int (*qos_mgmt_cfg)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta,
+			    struct cfg80211_qm_req_data *qm_req,
+			    struct cfg80211_qm_resp_data *qm_resp);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9608c07bcea7..f66f736adb92 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6309,6 +6309,18 @@ ieee80211_set_nan_non_evac_channels(struct wiphy *wiphy,
 	return ieee80211_nan_set_non_evac_channels(sdata, channels);
 }
 
+static int
+ieee80211_set_qos_mgmt_cfg(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_qm_req_data *qm_req,
+			   struct cfg80211_qm_resp_data *qm_resp)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	lockdep_assert_wiphy(wiphy);
+
+	return ieee80211_qos_mgmt_cfg(sdata, qm_req, qm_resp);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6432,4 +6444,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.nan_set_local_sched = ieee80211_set_local_nan_sched,
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
 	.nan_set_non_evac_channels = ieee80211_set_nan_non_evac_channels,
+	.set_qos_mgmt_cfg = ieee80211_set_qos_mgmt_cfg,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 83dd15f2daf6..f1dc9ca9f8f7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1804,4 +1804,32 @@ drv_nan_peer_sched_changed(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int
+drv_qos_mgmt_cfg(struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_local *local, struct ieee80211_sta *sta,
+		 struct cfg80211_qm_req_data *qm_req,
+		 struct cfg80211_qm_resp_data *qm_resp)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!check_sdata_in_driver(sdata))
+		return ret;
+
+	/*
+	 * Called only for SCS descriptors carrying a QoS Characteristics
+	 * element (9.4.2.326, IEEE Std 802.11be-2024).  Legacy SCS and MSCS
+	 * are handled in mac80211.
+	 */
+	trace_drv_qos_mgmt_cfg(local, sdata, sta, qm_req);
+	if (local->ops->qos_mgmt_cfg)
+		ret = local->ops->qos_mgmt_cfg(&local->hw, &sdata->vif,
+						sta, qm_req, qm_resp);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a6cbbb5a17d..63391a1fd9c6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -3020,6 +3020,10 @@ ieee80211_uhr_cap_ie_to_sta_uhr_cap(struct ieee80211_sub_if_data *sdata,
 				    u8 uhr_cap_len,
 				    struct link_sta_info *link_sta);
 
+int ieee80211_qos_mgmt_cfg(struct ieee80211_sub_if_data *sdata,
+			   struct cfg80211_qm_req_data *qm_req,
+			   struct cfg80211_qm_resp_data *qm_resp);
+
 #if IS_ENABLED(CONFIG_MAC80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_MAC80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
 #define VISIBLE_IF_MAC80211_KUNIT
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6ec45a9f7221..e476c6b9cb14 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -12036,3 +12036,20 @@ void ieee80211_sta_rx_queued_frame(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 }
+
+int ieee80211_qos_mgmt_cfg(struct ieee80211_sub_if_data *sdata,
+			   struct cfg80211_qm_req_data *qm_req,
+			   struct cfg80211_qm_resp_data *qm_resp)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
+	sta = sta_info_get_bss(sdata, qm_req->peer_mac);
+	if (!sta)
+		return -ENOENT;
+
+	return drv_qos_mgmt_cfg(sdata, local, &sta->sta, qm_req, qm_resp);
+}
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index ea46c3cca21a..ce69e5edd03f 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -3431,6 +3431,30 @@ TRACE_EVENT(drv_nan_peer_sched_changed,
 	)
 );
 
+TRACE_EVENT(drv_qos_mgmt_cfg,
+	    TP_PROTO(struct ieee80211_local *local,
+		     struct ieee80211_sub_if_data *sdata,
+		     struct ieee80211_sta *sta,
+		     struct cfg80211_qm_req_data *qm_req),
+	    TP_ARGS(local, sdata, sta, qm_req),
+	    TP_STRUCT__entry(LOCAL_ENTRY
+			     VIF_ENTRY
+			     STA_ENTRY
+			     __field(u8, qm_type)
+			     __field(unsigned int, num_qm_desc)
+	),
+	    TP_fast_assign(LOCAL_ASSIGN;
+			   VIF_ASSIGN;
+			   STA_NAMED_ASSIGN(sta);
+			   __entry->qm_type = qm_req->qm_type;
+			   __entry->num_qm_desc = qm_req->num_qm_desc;
+	),
+	    TP_printk(LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT
+		      " qm_type:%u num_qm_desc:%u",
+		      LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG,
+		      __entry->qm_type, __entry->num_qm_desc)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.34.1

