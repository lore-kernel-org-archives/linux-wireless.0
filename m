Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDE543DA2E
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813211; cv=none; b=TRtUoUpM2uokLPnBuFnO+mYYEA/oaxSryU3fMj1e0cdRx/lj7YuI3TZqzEgTFPsRZ6JEolbtlcxgyn+2Ki26Jp6+Qjx69QhSFpaTHwQXkKHCbi70XstUAF0aQbGWO1tGS3h04J0+qa77UCeF+dNIx/HAASw9VoVndn+hB2w0wOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813211; c=relaxed/simple;
	bh=vGFJQ6aAodKhtzS21oPWEsRImbjCMwfBF99koJOYdiM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=phoiiUoG4fqXQH73OCFlqggcIKvExE6ntf/LFlkEj2t+v8zPUUQfr+PsLQLdrsbZ0StPOsEzceQwwmW5I5o/j1GdB459+PBUqWhNwxnygNpM9DgYTPN74N4T3JsfAo38mVf+sxos42+wUDdM/dtG9cebkkz7ybSOaL3H3Dn2rKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZiGbn6se; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QA3uUY7y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZiGbn6se";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QA3uUY7y"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687H7g5a1642016
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tmSBOtvSp+Gmy3pqLBjim1lUAAw6sE0lZZQQfu5q2wE=; b=ZiGbn6segsoLakw4
	y4HXVWYxLiKdfZtKxyeVKoWm5rUTQ1Fq9A4fVKo+E1+U+R/qQDHVMlP5XNT7eFde
	4zLO1/JSHJGSRsb8JtUU1GrhAaC/elb0U/tXbfDXfkxw+mfdsxSzXXx/8swt0Bfm
	0pJL3z/+cxKT6BIGVdQoh2F5uM0j2ewWnZwF/X7WBcaqGCdHprIeZUZtUlxJJXNz
	1qluEfE5Z1hVTmgY54Cb75tzNWLUipgiTdiqhjVGG9ps2lT5sKiDFlfbaPFKs7n5
	TVyJOokJ8xjnoNGc6qXo3Iwc4Xvbsn0jb0x0ZSnjMCmhTJUulH+H9IuHKJrNUxk/
	oCHH3g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghruaaxc2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:33:28 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f57e31b6eso256833a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813208; x=1789418008; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tmSBOtvSp+Gmy3pqLBjim1lUAAw6sE0lZZQQfu5q2wE=;
        b=QA3uUY7yFSCFR8YAa+Bq4qdNAY+muwZjn/YDHzFj67iQNzWgrF3zCEkoimJazssqZK
         elH8tiftEbeMjV5BV/yBWSMir/j5E1C4HBZDJnwacNZbkcHw1pEuN6oit7oFGS3AxMaZ
         vsLnvDYkelfKS8bGWJIfYVvleJ0pwQ4HI8yIiym+5WQWlSP68SR9Qw/K05VdqBPdryFR
         TvUrbbModxJvuC4SmBdgPz3ji2QdFioTeExu4vODKIytuSuTo8FYmakn7AsJpC3MndrV
         Vfsm2ACL/KP464LwgDdO3KAPOCG9Sx+MdjL/rAVyoB0QPBMPSnNjBJMaRzZa6naRSCW3
         12qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813208; x=1789418008;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tmSBOtvSp+Gmy3pqLBjim1lUAAw6sE0lZZQQfu5q2wE=;
        b=GcycnybfB77PZ+MVeTJIVYfogpGypYqBXMBXaUHcPSlopAIt0lB0r4GKRkY1oXv6U7
         WEAfeMvJzHlTrlrxKOVP2QvNWbwXmKbJ0g17EzBdgEPDy0hRVs4ehspiV1qjPfbeYw8j
         bXkQ561SttDqqw6TkPVQXDwjmSVLUXQrK7HG8T1xltkvpRNSZ/fkMtTU4nDX3VdPltnN
         XBag1lZnBSSZMv2lf3dd/sblkedluptsivKJ2CsrfRnZ60f3gkuo7olUtEhPQErulqUe
         Y3O7x7LU2nBBiC6vEJAlkm77WM/wbKZrZSdtU9XrHR+OZlRGcXYw854J8KQ4mCOrg2/i
         i6iw==
X-Forwarded-Encrypted: i=1; AKwUvBzsCUaDgjui7Bibl8uVyPxOfavfI1K2IcZRMHAEEjLAy1ENsqcoh8kUBqRIY+FvGgXham5ESmqS6bg6Y/dzsA==@vger.kernel.org
X-Gm-Message-State: AFuF++l0otVNW0tRjDl8gC/WXuIApECHxcfz1JrwAORSOanUzjROi0KI
	EDxPhYlcFDy3lEYQPjOb48RVjt4H0fmkah/cc1PAaabS7n/MYNxSwt2aC3G62y/lPidmsSs9sAP
	Nn5/u/N5X4jeQxJXQ85BTjddZZsG0lDY0jPWV2SdtdOp5rbYjOu5bnWO+oN60/D8yyaP8
X-Gm-Gg: AYBFou1wKpdMpzDzulSesy9IPf+9wKZKOvrowI41cLa5tfJdQHbuCqjbx0x3pW7kUXi
	meqxDSRxr59rjv3KbpttquBLaZgTHZwv4gOezkDvFW6cnfs0+Rkor5eOcannr8BKEET8aR3vsK4
	WHydujRG7rzUWxlb1YD7qwQyFYOKwG7bGkYy0Yy0pZeJKjZ1qa8PmKrzFyoavlgXmnRy6qy+PK1
	0jlFbDEpfr3zyDLrhCnoo9psiZQWwWTio92TOQkrqKExiBmrXeqDo3S2Fu3ecKE5oVJmQsA4Q6A
	bdWu1DPWu3L+s7oFqOWMzf/5Ko2JOcavNw35f3B0TJMtqyswnhfSctPV/d9/zpAvIp1HCy0VP88
	rSoAQs1U3SbKrZx2y/0y6THMJ5eCyII1vnsV80fFCoHOlCNwrHerIpWr/mVEiCMoStKBd8y/ESZ
	qtgDS0B/1KRq4bHGSxH4pCGw==
X-Received: by 2002:a17:90b:1dc3:b0:398:d6f4:c61a with SMTP id 98e67ed59e1d1-39b26207ee4mr38263434a91.17.1788813208189;
        Mon, 07 Sep 2026 13:33:28 -0700 (PDT)
X-Received: by 2002:a17:90b:1dc3:b0:398:d6f4:c61a with SMTP id 98e67ed59e1d1-39b26207ee4mr38263380a91.17.1788813207672;
        Mon, 07 Sep 2026 13:33:27 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:33:27 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:13 +0530
Subject: [PATCH wireless-next 04/18] wifi: cfg80211/mac80211: Configure AP
 with SMD capabilities
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-4-65ad4ab30fbd@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: CyTmWU81ZvShBAQtnpW2RAjdC9LoMf0D
X-Authority-Analysis: v=2.4 cv=U+aiy+ru c=1 sm=1 tr=0 ts=6a9f1f98 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=56q9xwJp3_aMvtWITrUA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: CyTmWU81ZvShBAQtnpW2RAjdC9LoMf0D
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX+MGj1YM+0XXP
 0tmTrcKVpx07UbztI3XBc/N5Tng7mvI+4Ix2y0y3IxSmlS0sStBinRzQ+kXTW+b+46gC9bU8CFO
 eVo/P/BvK1jK834VifveTCQgJpxCaGY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX6fjyyeJ5JwRh
 uCcHwxj6x0ucJfhIAv+1ijXJWniRaZS2xhJGaA7Yprjv0tonoGkv1gtVpdHy6kRxhanqG8a/wFC
 CpWK9n/lJo1jtBTko6+4knBk5FU0xMi5TyUue5isZDTvFtoqB5rTxAtjVax3J3NtXfMqqIPrPCm
 RKeESwWGmRCAkj+bgkqQGU8OLp9AVIOEXnOTIszsQkrDOfw1Fbg/HGXL6rX97YuJIZYGOVn5+y5
 c5sLUPW5tmmstDta1bx7N0BlR2y3WPOYqABMPKMgK69roMJtEgqR+lLDW6PIuq4WELBHOwbBd8b
 9I9ocmV3KwI3XMfSxlmjtGYKidzW+Rb7g+MDi893tUYsjPnYujCDbBtvUAI4xmWYYtJ8h4jwwW2
 GxcGpbryHkmIuhftl8DkUzigBKG0XfP5hCSAndBXUqx6IjoyQuZEmcXiEMlpj8tUwMcv3ung9V+
 RJgArGxpxpwoS4ey9bg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070226

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

