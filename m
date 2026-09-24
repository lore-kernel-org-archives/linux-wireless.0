Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B9C3D0C18
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217705; cv=none; b=OgM3AUdhygPmc/M/GUxCFU0FnQCwP0JmLD7YQuQmQqRO/y+hOkuPSJHJIK4aVUxzlzFfWu04iPuAMOAGvWpO2LOdM8io3sz6QtLSqwKX7pqiMKtm4XHQhIc4g1xl57fyd0kEwaAqXkVf9RPZn8ah5pd1mXHWAVjmiDOnBWaSLnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217705; c=relaxed/simple;
	bh=eSricYYNrtrlErctZulR5p1WU1rEO75n7pS1CPhbnEU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U5duL7NWJOEocJE59tF1ACI5OV+6iOB6zeQKeKargSVmbSMVk1jtVOcDcbeSMYRsl1O94KSn4ijaWa7k2GpXZlVDJlKYbP7DtcwH+u79icv9Z6ruXS4GyRTqteMMGnts3jHP2wz9IFAvW74Lk3MlnYH9qeXcUe87LlxfSVMVdTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D1eXD18b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R907v6J7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D1eXD18b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R907v6J7"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2K4RM853892
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9l9FUpOYaeyDvNvaTKqpoEQKgTajA/wJWZ0uNQmQU8I=; b=D1eXD18bMdcb/tLp
	KqVrBi9N+M4hPuv81rRhn02HDDhl6T9x1ZVH1bUE9DPm5fIBryR2Ztrd2sigNvJf
	00pCynZFOO+cDCJ4ZrCGGConotBHdyaxQLFT7HX9ChtqwNcQea1mL9Qm/LT/HdVT
	lYXjCr6n2DOiMPVxQEPyyn+3bxTbZQ0gUfVaurcNgCj9jT1zGcP3APYqDqNj7fSG
	t0IJSq48lMx/rrB0OzEb0I9R9hn0XcffoDrkoaPH/j3VaaqqVFfIbsXJN7PI3ZJr
	laZgmK4TB/AXKaPIjOJ8LbUYLCHJY339r5WKBf5gGvjYSILC5Qf/Xr6JadXfS2gS
	TpPfqQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvhsb28x7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:42 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3282d5302ffso470206eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217701; x=1790822501; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9l9FUpOYaeyDvNvaTKqpoEQKgTajA/wJWZ0uNQmQU8I=;
        b=R907v6J7HoaTzdPuDqUfqrU6cKFcgFELX1jVS652ouL4P+CaD5SQnbNENMby1opiKa
         qRtfi5Gj9sMCc5GHu5ui6+kCthoSTMWFVH72pU6VhFrN3GrodTOghinHyMEJnw7HPk/I
         jDIoJ+nOXuTC/YAYB+ZtrTtST3wG78tFlq/jp1QLvbp2ADxU6nDHLyAB5pvYxKertThr
         hAUUQUmh1u9d31IuGWZfaKMCeNQK5GnI+E2r0f8kvpT1iUByc83becEjMoZA6OxUBrwH
         uLhV9mpsb+iUMVuGY9YZ0aYh356Bwxee7j2DvousSjvbFbOAdHk+NI9hOSOJ0c/tWNJ3
         NJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217701; x=1790822501;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9l9FUpOYaeyDvNvaTKqpoEQKgTajA/wJWZ0uNQmQU8I=;
        b=N+DC5g4lHdb3Culs4UKt1WVQoxDrEBKdgbjKNWIXTpVN/fgldSXmQAUJZCI+qhrKCI
         F9ZJEA87XFXlPUlXSYi2Gs4GboXyW60wtNiMP0lqmMOfAdqyn+mPT1Ql+4J8PFo6d2Rm
         zx9oQLNXEDL9UQ3bKECnfUezgH5H5MigWIbamlAHoiwI/tybQTiWdU3w0tFywe8K0Cfg
         lN7ktUkWsVuXqi+PKrkEE6UsyLWhdWz/lAGRRpH1qekTU0GgW2qdCIATXhfR9TOrEpmX
         kf9DdwiiqZ/JpYxrp0pd4L6hEMnIZiWyJW36s/3YYz39E6Qfru1mhFbkAObUYJxCEz8u
         kWeA==
X-Gm-Message-State: AFuF++k3POSR9LJ+SsrLYpagXGeW362yezEm6e4SYTSMQKISWix8GFkn
	BPvubqzcn7CVqS9kWus8TZ0frGvOcJ69G80JOFRandvL4cPg1eGdAUb49sfMHJ/LnTfGqiQ5+8y
	LzoBjcjy6X+iPUD5dXKYaHwqPmoyINE1oAFz5YMtrP2kmoZrwv5ZFlrsa3LnlNRv0bzv45h4S1J
	Ep
X-Gm-Gg: AYBFou1l67BCpiz7klmO7aMQVZOOsfW6IvNvSCcyWRmJlovjm/UtvvWD5/5Yixfmutu
	5J6FYa0A1bh480blG8TloMhucgD/zntegx4AVV2ZGfiBhtMHVWPLAF5aZkNF6/TPzRBQQtyeM5L
	ahp4yXyXtGWzOU5gxlvtLERYYIh1J3LLdbfRkuQ9j67quJKlnUe9K8ujKjdgC7pp16NEmGKJwYA
	KJfJGWKd7Uv4hOi879CXI+QiazYepeZ4l3otI0A8MLyX7ZaTxs5p5kFm4sAtzhVB8fhSWgtM9Bm
	OgUVo76uP3SmkYc8JkJ8vwrlgeRjFxrmKnMD/cWdna9Cc2uCIl+gEMCgLSyHupr6i6Fj2kjHKu7
	sV2q9q2WLdQKwal22AofOVkIixfIfdrrtBKxwA8ULZRy3Kv7ZXHXogpuAXPCIxbR29ig7wonSYu
	GOTo6Tcg3qpE++BLIBY/otFQ==
X-Received: by 2002:a05:7301:705:b0:332:946c:477a with SMTP id 5a478bee46e88-340059679dfmr678103eec.16.1790217701107;
        Wed, 23 Sep 2026 19:41:41 -0700 (PDT)
X-Received: by 2002:a05:7301:705:b0:332:946c:477a with SMTP id 5a478bee46e88-340059679dfmr678086eec.16.1790217700474;
        Wed, 23 Sep 2026 19:41:40 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:41:40 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:40 +0530
Subject: [PATCH wireless-next v2 03/16] wifi: cfg80211/mac80211: Configure
 AP with SMD capabilities
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-3-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: iEZNXKKwnQf4OWDQpPK153cKnPTflS6z
X-Proofpoint-ORIG-GUID: iEZNXKKwnQf4OWDQpPK153cKnPTflS6z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX0My/I2Kywhzh
 i+JOsnhuMg9rGfYbgC8uuEILOLV2rfokJFU8J4wFzIvCrzKrzIPt/axjC9jctfmR+tKB40HUtV2
 7Ji+dhoSkxzEfojygB+WcOW/FfSv/12eblPtqWkmlXbBPaNGihM8d0x03cphlZUGELF5ojcVGYd
 pQcQmXgDUzJKijv+U3bLVPTtzQVNEArkcBwaQXacXqLFUky/PpL/SSHt9PDrsldHNxlKMx2btQT
 ohcnsdi0bihwL8KFOWehd1mkBB/AyIG+pO3S4adODODVe7z/3oI94yLPe+EhCn0YbF4I9BTCSAE
 YidSsrSQrbnxLS33pFpWEQWl02Y8DwxCepkaAqvZal0Juj3fCcEQ9vNigD+bs6LB1Pf3s/F0S+I
 Ql1JeFSIM8svdmjApXAiw6HtkBXsdj+u60iYWBVNZ3PBd4P6MhumPYmZlMrbbUpYX/lVW/DiukP
 fiuSudK7KAYgZJAd8nQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXyl1McS6ilEEs
 /Xcunb1Ba/Ii4VFooABzon0gQRqxKPSTEIfEMUFfeAy8vz3LbWrDwzgiPvX0uy1W3C+ojxXPVUo
 A4cPyWho4iJ89vqST6aq8PLp//EtAPs=
X-Authority-Analysis: v=2.4 cv=f7vdl+yM c=1 sm=1 tr=0 ts=6ab48de6 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=56q9xwJp3_aMvtWITrUA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

From: Rohan Dutta <drohan@qti.qualcomm.com>

When an AP is getting started, configure the AP as SMD-enabled if
userspace provides configuration for the Seamless Mobility Domain (SMD).

The SMD parameters are:
 - SMD Identifier: unique identifier of the SMD
 - SMD Preparation Timeout: Valid duration for a prepared target AP MLD
 - Downlink Data Forwarding: Forwarding support for buffered DL packets
 - Max Number of Peer AP MLDs: Number of target AP MLDs that a non-AP
                               MLD can prepare with
 - SMD Type: Type of SMD
 - SMD PTK Mode: PTK mode used in the SMD
 - Neighbor Probing: UHR Neighboring AP Probing

Without these parameters configured, drivers and lower layers cannot
support SMD BSS Transition.

Signed-off-by: Rohan Dutta <drohan@qti.qualcomm.com>
Co-developed-by: Aditya Sathish <asathish@qti.qualcomm.com>
Signed-off-by: Aditya Sathish <asathish@qti.qualcomm.com>
Co-developed-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h | 25 ++++++++++++++++
 include/net/mac80211.h |  2 ++
 net/mac80211/cfg.c     |  5 ++++
 net/wireless/nl80211.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9aa7d2d4a184..df85dc804c50 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1587,6 +1587,29 @@ struct cfg80211_s1g_short_beacon {
 	size_t short_tail_len;
 };
 
+/**
+ * struct cfg80211_smd_params - Seamless Mobility Domain parameters
+ *
+ * @smd_enabled: SMD is enabled on this device
+ * @smd_identifier: SMD ID (ETH_ALEN bytes)
+ * @smd_timeout: timeout in 64 TUs for ST Preparation
+ * @dl_data_fwd: MSDU forwarding supported
+ * @max_num_of_peer_apmlds: max prepared AP MLDs supported (0-7)
+ * @smd_type: SMD type
+ * @ptk_mode: PTK mode
+ * @neighbor_probing: UHR Neighboring AP Probing supported
+ */
+struct cfg80211_smd_params {
+	bool smd_enabled;
+	u8 smd_identifier[ETH_ALEN];
+	u16 smd_timeout;
+	bool dl_data_fwd;
+	u8 max_num_of_peer_apmlds;
+	enum nl80211_smd_type smd_type;
+	enum nl80211_smd_ptk_mode ptk_mode;
+	bool neighbor_probing;
+};
+
 /**
  * struct cfg80211_ap_settings - AP configuration
  *
@@ -1623,6 +1646,7 @@ struct cfg80211_s1g_short_beacon {
  * @mbssid_config: AP settings for multiple bssid
  * @s1g_long_beacon_period: S1G long beacon period
  * @s1g_short_beacon: S1G short beacon data
+ * @smd_params: Seamless Mobility Domain (SMD) parameters
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -1655,6 +1679,7 @@ struct cfg80211_ap_settings {
 	struct cfg80211_mbssid_config mbssid_config;
 	u8 s1g_long_beacon_period;
 	struct cfg80211_s1g_short_beacon s1g_short_beacon;
+	struct cfg80211_smd_params smd_params;
 };
 
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1172d7b83ed1..3a5011945eed 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -797,6 +797,7 @@ struct ieee80211_bss_npca_params {
  * @s1g_long_beacon_period: number of beacon intervals between each long
  *	beacon transmission.
  * @npca: NPCA parameters
+ * @smd_params: SMD parameters
  */
 struct ieee80211_bss_conf {
 	struct ieee80211_vif *vif;
@@ -904,6 +905,7 @@ struct ieee80211_bss_conf {
 	u8 s1g_long_beacon_period;
 
 	struct ieee80211_bss_npca_params npca;
+	struct cfg80211_smd_params smd_params;
 };
 
 #define IEEE80211_NAN_MAX_CHANNELS 3
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..b4b42790c5d7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1796,6 +1796,11 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
+	if (params->smd_params.smd_enabled)
+		link_conf->smd_params = params->smd_params;
+	else
+		link_conf->smd_params.smd_enabled = false;
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP &&
 	    params->mbssid_config.tx_wdev) {
 		err = ieee80211_set_ap_mbssid_options(sdata,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index de93b34444b4..b4ff784d131b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7225,6 +7225,78 @@ static int nl80211_check_npca(struct cfg80211_registered_device *rdev,
 	return -EINVAL;
 }
 
+static int nl80211_parse_smd_params(struct genl_info *info,
+				    struct cfg80211_smd_params *smd_params)
+{
+	struct nlattr *smd_params_attr = info->attrs[NL80211_ATTR_SMD_PARAMS];
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct nlattr *tb[NL80211_SMD_PARAMS_ATTR_MAX + 1];
+	int err;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_SMD)) {
+		GENL_SET_ERR_MSG(info, "SMD is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!wdev->valid_links) {
+		GENL_SET_ERR_MSG(info, "SMD is not allowed without MLO");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, NL80211_SMD_PARAMS_ATTR_MAX,
+			       smd_params_attr, nl80211_smd_params_policy,
+			       NULL);
+	if (err) {
+		GENL_SET_ERR_MSG(info, "failed to parse SMD parameters");
+		return err;
+	}
+
+	if (!tb[NL80211_SMD_PARAMS_ATTR_IDENTIFIER] ||
+	    !tb[NL80211_SMD_PARAMS_ATTR_TIMEOUT] ||
+	    !tb[NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS] ||
+	    !tb[NL80211_SMD_PARAMS_ATTR_TYPE] ||
+	    !tb[NL80211_SMD_PARAMS_ATTR_PTK_MODE]) {
+		GENL_SET_ERR_MSG(info, "required SMD parameters are missing");
+		return -EINVAL;
+	}
+
+	memcpy(smd_params->smd_identifier,
+	       nla_data(tb[NL80211_SMD_PARAMS_ATTR_IDENTIFIER]),
+	       ETH_ALEN);
+
+	smd_params->smd_timeout =
+		nla_get_u16(tb[NL80211_SMD_PARAMS_ATTR_TIMEOUT]);
+
+	smd_params->dl_data_fwd =
+		!!tb[NL80211_SMD_PARAMS_ATTR_DL_DATA_FORWARDING];
+	if (smd_params->dl_data_fwd &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING)) {
+		GENL_SET_ERR_MSG(info,
+				 "SMD DL packet forwarding is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	smd_params->max_num_of_peer_apmlds =
+		nla_get_u8(tb[NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS]);
+
+	smd_params->smd_type =
+		nla_get_u8(tb[NL80211_SMD_PARAMS_ATTR_TYPE]);
+
+	smd_params->ptk_mode =
+		nla_get_u8(tb[NL80211_SMD_PARAMS_ATTR_PTK_MODE]);
+
+	smd_params->neighbor_probing =
+		!!tb[NL80211_SMD_PARAMS_ATTR_NEIGHBOR_PROBING];
+
+	smd_params->smd_enabled = true;
+
+	return 0;
+}
+
 static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -7506,6 +7578,12 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 	/* FIXME: validate MLO/link-id against driver capabilities */
 
+	if (info->attrs[NL80211_ATTR_SMD_PARAMS]) {
+		err = nl80211_parse_smd_params(info, &params->smd_params);
+		if (err)
+			goto out;
+	}
+
 	err = rdev_start_ap(rdev, dev, params);
 	if (!err) {
 		wdev->links[link_id].ap.beacon_interval = params->beacon_interval;

-- 
2.34.1

