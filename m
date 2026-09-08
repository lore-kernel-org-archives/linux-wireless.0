Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E5D5947FA
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887421; cv=none; b=EHii+2/vXbHsngMcDeotOcnQdZSRFEfqr/YVdz2emIo8mL0QkCA+XJDILEc/ZJ/MvJAT6RFROpJSFVCJxe6xS3gVRq6CSqakiV3S6u1DL1+LqgxzwzPc+51JDsbwgW6ROmdabsnw4e6KAQ1n8YA0tZl15yOag9YJ7ILwdDoVbhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887421; c=relaxed/simple;
	bh=vGFJQ6aAodKhtzS21oPWEsRImbjCMwfBF99koJOYdiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uf3r6l60FniabkVjcVWwURGZEskd0OCNZgpidwnaMxgINstm3lof88ySJkM1dUK9AyTvKQn8z51OYaZV5Ao+icZ3NpZaLDejPufYnzEpiqFh7vKwdC9jiZJD5XbPM9G1I2zYtgG1nkJvBDDL8ZMxOJLV/e6x64oeGqtYZRZNy1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GvTpwNkj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=em9L3VXJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GvTpwNkj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="em9L3VXJ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdZP42899279
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tmSBOtvSp+Gmy3pqLBjim1lUAAw6sE0lZZQQfu5q2wE=; b=GvTpwNkjRPblAZV3
	wBYl4geZZJBHmih1Ts5hQwRvDRzRXpwkLEb/P+IDEeWv7GF9EKwlgR0LWbihzPgh
	VgrdwdwvWq1mlyM2oNSuws9yRJqJeXmDmE82T8s+6y7D8BXmW22YxpXtP+BXT9IM
	kL54lHzOhZgye0vJVV2ipuFgwNkaGDE153uVUPXDwF3b2T7WNLTk8uCk0POnkrEf
	ltYzMXvi/pYRcihNwh9PkCgaTVMuWVw/JXh1KcpI37Qv6MBrZOekgYhS/wQ1Df0+
	DPdmN/F4tVhwxi0TpWLGTGJZqLCB64NPM7l7yOqHS8FtASYkFLF16MlZAeC7nLGe
	NmPdiA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjcvujvck-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:17 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc42a07d04aso5199265a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887417; x=1789492217; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tmSBOtvSp+Gmy3pqLBjim1lUAAw6sE0lZZQQfu5q2wE=;
        b=em9L3VXJR0AA7t0HKCixms3+990j4ly9vCT3R3KAYbzcAa33uCPUEibcV3dwIbyeam
         8htzFfPjoZqNFqgXGeAlH64id+/03btyIvZhfaIGbl3+QAfb1DwyJ06dfDbLs3Ml4uV8
         zvXC68LoGI7pCFsO7TF3ssbbRW8gYt1MnvEDwfrFNNONLAiVNvNhvsQAOeqyjnk5Xk4e
         fn8M3d2JtjUqQCwNS9fe6LDmuPIvpYHpf+dELfccolEetFDK+rsdT6QSPcfsmrajkkSd
         oHnLohWRieifFxK9X3/wRfcxxg/Sr9TEK4SGJeBxE0jWGUMFYZ2OxucE9AvCF6onGQ/E
         tMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887417; x=1789492217;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tmSBOtvSp+Gmy3pqLBjim1lUAAw6sE0lZZQQfu5q2wE=;
        b=ccD9FvLG29toQSEw5eAFQ5RTFA29aQlBdNhS9no1bCM6bjGcLmjVhIWZLb7zp/TXV9
         klSoDIE+TrsBCFhRl1lcNZ1M8ENBmfoSWf2mypMgb0YME0VHhIUKw1UOa1AFHeyJy7gc
         hvqNpAx26qO4zKvnc9EZMUyRpazhU/zkvRK5ezorsKg/7ZDiiXtgByFBEL+6Y/v1zmA6
         fqXvwyGLgnqMwen2WV6pSh9jbp4hKA3jIJKO/soElkSxfEUFXxY2JpVwBOKuBm9VUv9E
         tktXCdVOcSq8K7jkTgMJCYZOjYMpzhpelIkXMED+eDkQnKupnRCarUU5CQbod3tWbVcB
         9txg==
X-Forwarded-Encrypted: i=1; AKwUvBzEUQlPsfo66+fy6Y4DVxz7BoqnUwfPEmhbwC1122z+6Urfs69LBgTz178DzKr7hZhRCnQXyryEobr+XgruoQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lKEv7Lbs62bH2bsl/v7qPbG1oebH4g8nfVsdIpC+d6PaLDlHNi
	wqSTCwp0iGUgjrXi6Cs5yvkpriMDyHAYhsvh2pI6d1us3GNxTJIpmrTT8F/kmN/CfoGR9po5Itg
	Aihl/FaOnXuX6mtd9V/RWOmSey9b2ihH4/I5Whkyyli0SmQB8XXlH9OTkWGhdYJFyR003
X-Gm-Gg: AYBFou0GEVC2OdBj27/j5jjMf+8Ej7rJbq64Opaz88y/fGFBOUSvVHI8l1jgFsHKUEe
	aBWqNRxOL+af+PXL95may2tt440Y5K6PGB9WifctBmyQL0+XsTpJ8+p7j2ws/GWQSRWeJM+UYeO
	n0twCyxeATbXjzMa6dV2cvR9KK2nwBCbx7ai30XBv84EVUuvtJY/RIP4H36D7eRRlFk+WIb3W1H
	pHnDVZWJ4whYdEj3UqWdfwtD24C9BOr6uwyVvItQLmnMgLxkaI8Ad8Nr9841zlDvm45N04PO89y
	Ml3fkHpoDiEfi30NX0AEbftZLd+ndoIoTkeWGpojWLCUqjr1R1g+OutAI/lHxeusUKSpe1tg/jg
	/1e2Zy1TIaQ6YC8kJSMdGb5pESr8au3azpQWboyfArpH13oWelfVsSKlZMZM8eqdyC4UfSM8pY2
	j8hRTCsM5c8tUxHHbr8oM3Cg==
X-Received: by 2002:a05:6a20:db91:b0:3d3:ae1f:d7f5 with SMTP id adf61e73a8af0-3da3a0b9eecmr47536192637.21.1788887416829;
        Tue, 08 Sep 2026 10:10:16 -0700 (PDT)
X-Received: by 2002:a05:6a20:db91:b0:3d3:ae1f:d7f5 with SMTP id adf61e73a8af0-3da3a0b9eecmr47536097637.21.1788887416272;
        Tue, 08 Sep 2026 10:10:16 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:15 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 04/18] wifi: cfg80211/mac80211: Configure AP with SMD capabilities
Date: Tue,  8 Sep 2026 22:39:32 +0530
Message-Id: <20260908-smd-v1-4-9fd2d876a1fb@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=ePkjSnp1 c=1 sm=1 tr=0 ts=6aa04179 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=56q9xwJp3_aMvtWITrUA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: WSb3-CPdBK4IoK7Xi-hEdAYTvj7Cq3zr
X-Proofpoint-ORIG-GUID: WSb3-CPdBK4IoK7Xi-hEdAYTvj7Cq3zr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX4SYap0t88ZUx
 yxoJ2XQOZblT/zlvBdKra3CEY9si1xesluNiFbCg+qMlom4WR0lZFZgYqoegAFXnba9LVQu4kPo
 X7MrEi0s5QjLRn36/yiUJe/QuucDZQFGK+X+gWog0EklqFyy+2jVFWmfNeFqybXhP11E7ZKQk37
 0iqG6wJKr0qPh0z9yWicovsSTD30Z+QBqaXNOuBryQoH6hpEVj6tXUNWlQrtKMSkaB2nHQlh6Wt
 1IwI5UwvgiQ56WJHHQYeDGMeHx6dhBH/JQ6wrt+scheIgZt6Q0sDdcbkzlTJ8l8YXXr+esqTehc
 ZLvIRzak1fGxzSz2OwFK8m1gc4UXtXzUs+UQOcFDpoyPri7GOv4uRP9MBZ0Fsr2yrX2FeBVDXKR
 LffhIBDLZDB056B155+yerWVbk+0VToHBOXthxPSeXRqjc0rQF1f9niFcJbqFaSeFPgjFV5p7QK
 7pq+IboNTA43oT8rA4w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfXwzgQk/ALn1gD
 XkuUA2zudGjZB5lyg49WhjIC63mSWHpUrpGQUYk+cjo85OlZ115Ge4gIgjQ8ZG1bGodIk7OvcRa
 JDmDE0FnoK8+XoJ6hiTkKChNqKm5KD4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

From: Rohan Dutta <drohan@qti.qualcomm.com>

When an AP is getting started, configure the AP as SMD-enabled if
userspace defines configuration for the Seamless Mobility Domain (SMD).

The SMD parameters are:
 - SMD Identifier: unique identifier of the SMD
 - SMD Preparation Timeout: Valid duration for a prepared target AP MLD
 - Downlink Data Forwarding: Forwarding support for buffered DL packets
 - Max number of Peer AP MLDs: Number of target AP MLDs a non-AP MLD can
       prepare with
 - SMD Type: Type of SMD
 - SMD PTK Mode: PTK mode used in the SMD
 - Neighbor Probing: UHR Neighboring AP Probing

Without these parameters configured, drivers and lower layers cannot be
able to support SMD BSS Transition.

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
index 6461a7bd0169..d0a269f4c711 100644
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
+ * @smd_timeout: timeout in 64 TUs for ST preparation
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
index 7bb4618065b6..6b82ca07fbf0 100644
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
index 22d71f32815f..aa7aa70a5b41 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7224,6 +7224,78 @@ static int nl80211_check_npca(struct cfg80211_registered_device *rdev,
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
@@ -7505,6 +7577,12 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
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

