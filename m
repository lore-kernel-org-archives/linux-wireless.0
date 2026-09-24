Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4DA3DE420
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217730; cv=none; b=OcmTqy2+3Dos6wzRAPyyQ/JC7whMTkTuvTdcuS0a6R1WQg5ESjBX/6ba9tlrmbmNgHUL02gncGzkdimgGtNLoRNrHpC/Rilry/q4OZjsUr9NAIdJtQ7DWjLcu5GwTVp4evhV9GLZ+7BwO7gFC8pgcElHT0/1+XBRrhkyUIX2l88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217730; c=relaxed/simple;
	bh=qjo4LXIMsSyzJCAJhlFb0c6ptyuXA14K/I0JXhuV/Hs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=frn1P92kV8hZ/lFnUjWXmIQFaMSvlOF7hzNcVpiLMxxC2i4EaSI2Sc7OPPBarYFS9mGSM3dc9CYqoyufoqgT6Iba9WhAKPAn36sIxvYp9jAROW525HjmiDY3rZJlQ7csBmJPGYLX7saJhaI7fjqmRf92WgUTTz2Lp/poe8vWWK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LSEX4eKb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IZeDx8uF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LSEX4eKb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IZeDx8uF"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2JvcC1851576
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d3/PwaR8+USw9E7Ih9bOMrj7G4CRNw/PS2L7c9cu4PY=; b=LSEX4eKbYGcY+U+l
	hY3ucSLYtVB7D6y1AKZnM3CsdrzKOJrAf1tPXMC7hHmJXukq8brY78qB2PVsO6u4
	qwpldAQCwbYUlaClQxF8+fuBs7M/HDFvcR7zj4MMvF/UyVqWp9jp9wApy7grpEyW
	8XZTF6ZYQCkvOA550mcPQNKBnP02qvok4zEaUZXGf+RrfIODrl4IkFAQ/+Vjkwqg
	YICSu2GUssFRz9I+5vxrjsM62jVN5fTrTT1nESh8gqc0Bc+zVSe6peWRTtc8bKlv
	ErjsfbxOs2r/ybTYFrc9JFZYn1v9S9ilvIeS9DmfNcmQAnAFiFYhaiz0nAeFBEnB
	XUktfQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjxtx2j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:07 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33baaba6371so835958eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217727; x=1790822527; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d3/PwaR8+USw9E7Ih9bOMrj7G4CRNw/PS2L7c9cu4PY=;
        b=IZeDx8uFyL/32lJYuxTLYWrM9VarxO68AwttM7cwpkQhuxTn5Y4/boZGleadDftYjY
         P1pA2S/b/OudxMw0aSzLI/Y+JqNg66lePinEjoKSnNFyfL1mbmvC/PczVnXnx5xbDqyG
         UX8DgW5Asjeq8ajZPcv9Fsbyfczo61GGrruRdsbOnbTdjO3f+5OvEhuIJ54MCHrqQi3I
         vVHwG02JRXo9z7G8cjQSNAUey6TzADKrKrLExudSjIkfd8+X8Bc+puKVicGe7CpmoEqe
         VbVikzbhJg0ndmwMiulnDqGBqe4h8eY6r6BnsQiFJlYhRWGSFZifL30bndMzNnTiMpkr
         +EBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217727; x=1790822527;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d3/PwaR8+USw9E7Ih9bOMrj7G4CRNw/PS2L7c9cu4PY=;
        b=n+Kp8Bje/ZTS6847tR4NtHYJsk5TBDLZyfQU7aEcmyFqRazzdSUREkxsYyfqFsb1np
         3fuVOzo684TDQeaOLaFGejE5pgseyZ6NNLIFBTLagNGHzfWhfcD77nP9iFwdeqPS6LRz
         c82V1enZkVW6RWXfsRsbHIdwNymchWTUfomDlpFz8xnPkGikUcaqNmbiUAcYf1UW4M2U
         VaqqH2RkHFwL+6lDzZNKEVpzj3ODQMnVIJ4O6iYoEjVvtXoOknURFJdv9OdgA61vXufU
         VVfnlR5KWWzNYqkWyo6vEvrZ8KyShOx5Gb0HI4nRpwUBhiSql0ky6StnKZ60b4egDiWo
         mStw==
X-Gm-Message-State: AFuF++kXMkGImh6czl+ezZBpcshMLtRI8fV7Cr63wmOTVRs0w9OvPu3W
	Ur6vxtn6LON6lLhb7rYJ/1Mt4/hWEuWYde9nibZPwu0yo/CggqAnEb7aQndIllnM7vz0P9yRnGJ
	pusrewExT+VmFIrWtPPf/j0xwZAnxBTv0o90URDrWU+OkBk08N5sb3a7DB+cqyic4AIAbIs4VpK
	1M
X-Gm-Gg: AYBFou0VN+lHPVb3xmB+wXpDpcpmpke+hnPVUgBPHNt07aEbYL+7r7k+e1QPdf6RHlD
	TL407fu+DaHa3jg3J2opSCdZbSAA4F9Pzoa2VxKr4ltassT6hp/VvS2nXzulV0CZyLiNZQkjZB3
	9scE2L8Be35Rth9DJlLfw+Q6KkN4bNbwPP/wz/wjhRYQkPZA1l++lBlk/XjpYP1aYQIggTkbEgb
	QL4TK2fyzt71tVy2jK5TM+S77kqA1vBrlhDu9cLDsaGfXyX/i56T1JI8mmurwtOORzyA7PnQ6ps
	d8wkIORXY2ACeK7cKxGmkPUojxFPTwL/FFtoY/rligNbucvSySloepveT1TYtN9zUT/RHWexrX1
	HjfaT+CkyMEWtVvThorSZIHNf01emLBTOT3UBEX3e54iEwY0Xmgix2cf3DGYwa93TjA+8uOjfNk
	d33QCNIpqSAPXDITO8OL/m/w==
X-Received: by 2002:a05:693c:621a:b0:33e:6a58:b03 with SMTP id 5a478bee46e88-34002edeb01mr909283eec.21.1790217726498;
        Wed, 23 Sep 2026 19:42:06 -0700 (PDT)
X-Received: by 2002:a05:693c:621a:b0:33e:6a58:b03 with SMTP id 5a478bee46e88-34002edeb01mr909257eec.21.1790217725786;
        Wed, 23 Sep 2026 19:42:05 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:42:05 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:48 +0530
Subject: [PATCH wireless-next v2 11/16] wifi: cfg80211/mac80211: Handle UHR
 Link Reconfiguration frame
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-11-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: Mb757s2gMuL7ImKpcsi2tbJqDBY3Hnk2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX3kcLnQOJ6r4Y
 vvEtEKtUb4d/ej/Xw/dMzM7r1vlFfpKx9EbZIahgU8t8mkV5Ewt2Gz48PI5oU20AKsxGvxsND92
 HhK179/g06UXk5s8xtpuwRjj5h0o/TRdvP768m8uiZmS2mbPLTuK0uv3JnJxilqMoBw5fQOPSD6
 jwOOgu1KaZM5GJZbozniyi+9ZaKNvIaZSfujd4se7XfPiyPnoqszGTNVxj9tcpAYDVKDvxCiS4g
 CM9laMWs8UaWNixRJ6HnXtKER8t/eo+czS4h3vRyLJx7zGvQAuI8EBNMvBMlngfKSTlU1MB3yKV
 jI4TVbfXcggwOlALn0hhPOP5Hp5io5M4IAsMINsV1Tu/MLwTRkUpVi1B2KK6UrbXKtaCKLGaj1Q
 Jh1hutu3ciJxoabgvtMjuROhXeUv87nr2eEwaso01lbwY1Z7e94vFtbWKborldm3djFgaHZY8xH
 FwdM/CXSt+ej/cNeeWQ==
X-Proofpoint-GUID: Mb757s2gMuL7ImKpcsi2tbJqDBY3Hnk2
X-Authority-Analysis: v=2.4 cv=NLpAaE6g c=1 sm=1 tr=0 ts=6ab48dff cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=kIFG_faw9rmyLF2AHFUA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXxOVjAfvrV7ur
 G3Aw1eRqqNEKp3EWrm+9zZb1cldCS0xjbXU77tky6eIaSfnfCusIUE0nGbYXWHwYIKivPc0cw6T
 O3Fn6XECx9Wfnu8FFWcyt1Dt5zsEyo0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

A UHR Link Reconfiguration Request frame (ST Preparation or Execution)
triggers SMD BSS Transition on the current AP MLD. Userspace needs
reporting of the STA's dynamic context along with such frames so that
the same can be transported to the target AP MLD for setting up the STA
TX and RX queues.

Reserve a field in ieee80211_rx_status that enables drivers to attach
the STA's dynamic context to the corresponding frame. Since the maximum
possible context can grow too big, attach the pointer to the context to
the frame. Add handling for UHR ST Preparation and Execution Request
frames so that the associated context is propagated through cfg80211 and
nl80211 for userspace reporting.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h | 59 ++++++++++++++++++++++++++
 include/net/cfg80211.h        | 13 ++++++
 include/net/mac80211.h        | 10 ++++-
 net/mac80211/ieee80211_i.h    |  2 +
 net/mac80211/rx.c             | 96 +++++++++++++++++++++++++++++--------------
 5 files changed, 149 insertions(+), 31 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index e6aaef9ae9e6..e74de842b281 100644
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
index a618b3c90161..02fe733f0204 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4889,6 +4889,17 @@ struct mgmt_frame_regs {
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
@@ -9546,6 +9557,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @rx_tstamp: Hardware timestamp of frame RX in nanoseconds
  * @ack_tstamp: Hardware timestamp of ack TX in nanoseconds
  * @no_sta: set if no station is known for the frame (relevant for MLD)
+ * @st_info: SMD BSS Transition data
  */
 struct cfg80211_rx_info {
 	int freq;
@@ -9558,6 +9570,7 @@ struct cfg80211_rx_info {
 	u64 rx_tstamp;
 	u64 ack_tstamp;
 	bool no_sta;
+	struct cfg80211_smd_transition_info st_info;
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7bfa421535ca..a377a16da5c4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1735,6 +1735,10 @@ enum mac80211_rx_encoding {
  * @ack_tx_hwtstamp: Hardware timestamp for the ack TX in nanoseconds. Only
  *	needed for Timing measurement and Fine timing measurement action frames.
  *	Only reported by devices that have timestamping enabled.
+ * @smd_ctx: Pointer to IEEE P802.11bn SMD BSS Transition context information.
+ *	Only needed for ST Preparation Request and ST Execution Request action
+ *	frames. The pointer will be consumed by mac80211; must be kmalloc-ed.
+ *	Indicated by @smd_ctx_valid.
  * @device_timestamp: arbitrary timestamp for the device, mac80211 doesn't use
  *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
@@ -1775,12 +1779,15 @@ enum mac80211_rx_encoding {
  * @link_id: id of the link used to receive the packet. Set and used by
  *	mac80211 internally, it uses @freq set by the driver to identify the
  *	correct link per vif.
+ * @smd_ctx_valid: if @smd_ctx has a valid pointer to the ST context. This flag
+ *	is used only for ST Preparation or ST Execution Request frames.
  */
 struct ieee80211_rx_status {
 	u64 mactime;
 	union {
 		u64 boottime_ns;
 		ktime_t ack_tx_hwtstamp;
+		struct ieee80211_smd_ctx *smd_ctx;
 	};
 	u32 device_timestamp;
 	u32 ampdu_reference;
@@ -1814,7 +1821,8 @@ struct ieee80211_rx_status {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 	u8 zero_length_psdu_type;
-	u8 link_id:4;
+	u8 link_id:4,
+	   smd_ctx_valid:1;
 };
 
 static_assert(sizeof(struct ieee80211_rx_status) <= sizeof_field(struct sk_buff, cb));
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9514f01778be..cf1a5d54d229 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -268,6 +268,8 @@ struct ieee80211_rx_data {
 	};
 
 	u8 link_addrs[3 * ETH_ALEN];
+
+	struct ieee80211_smd_ctx *smd_ctx;
 };
 
 struct ieee80211_csa_settings {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3990b7a7299..4ad7a71d298a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3970,6 +3970,22 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	return RX_QUEUED;
 }
 
+static void
+ieee80211_rx_h_userspace_mgmt_st_req_frame(struct cfg80211_rx_info *info,
+					   struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_mgmt *mgmt = (void *)info->buf;
+	u8 type;
+
+	if (!rx->smd_ctx)
+		return;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	info->st_info.type = type;
+	info->st_info.ctx = rx->smd_ctx;
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 {
@@ -3981,6 +3997,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
 		.no_sta = !rx->sta,
+		.st_info.ctx = NULL,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
@@ -4002,6 +4019,9 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	    ieee80211_is_ftm(rx->skb)) {
 		info.rx_tstamp = ktime_to_ns(skb_hwtstamps(rx->skb)->hwtstamp);
 		info.ack_tstamp = ktime_to_ns(status->ack_tx_hwtstamp);
+	} else if (ieee80211_is_st_prep_req(rx->skb) ||
+		   ieee80211_is_st_exec_req(rx->skb)) {
+		ieee80211_rx_h_userspace_mgmt_st_req_frame(&info, rx);
 	}
 
 	if (cfg80211_rx_mgmt_ext(&rx->sdata->wdev, &info)) {
@@ -5340,7 +5360,8 @@ static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data *link)
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct ieee80211_link_sta *link_pubsta,
 					 struct sk_buff *skb,
-					 struct list_head *list)
+					 struct list_head *list,
+					 struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -5349,16 +5370,14 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct link_sta_info *link_sta;
 	struct sta_info *sta;
 	__le16 fc;
-	struct ieee80211_rx_data rx;
 	struct rhlist_head *tmp;
 	bool rx_data_pending;
 	int err = 0;
 
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
-	memset(&rx, 0, sizeof(rx));
-	rx.skb = skb;
-	rx.local = local;
-	rx.list = list;
+	rx->skb = skb;
+	rx->local = local;
+	rx->list = list;
 
 	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
 		I802_DEBUG_INC(local->dot11ReceivedFragmentCount);
@@ -5390,8 +5409,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-	ieee80211_parse_qos(&rx);
-	ieee80211_verify_alignment(&rx);
+	ieee80211_parse_qos(rx);
+	ieee80211_verify_alignment(rx);
 
 	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control) ||
 		     ieee80211_is_beacon(hdr->frame_control) ||
@@ -5412,9 +5431,9 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					   sta);
 			link_sta = rcu_dereference(sta->link[link_pubsta->link_id]);
 
-			rx.sdata = sta->sdata;
-			if (ieee80211_rx_data_set_link_sta(&rx, link_sta) &&
-			    ieee80211_prepare_and_rx_handle(&rx, skb, true))
+			rx->sdata = sta->sdata;
+			if (ieee80211_rx_data_set_link_sta(rx, link_sta) &&
+			    ieee80211_prepare_and_rx_handle(rx, skb, true))
 				return;
 
 			goto out;
@@ -5434,13 +5453,13 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				continue;
 
 			if (rx_data_pending) {
-				ieee80211_prepare_and_rx_handle(&rx, skb,
+				ieee80211_prepare_and_rx_handle(rx, skb,
 								false);
 				rx_data_pending = false;
 			}
 
-			rx.sdata = sta->sdata;
-			if (!ieee80211_rx_data_set_link_sta(&rx, &sta->deflink))
+			rx->sdata = sta->sdata;
+			if (!ieee80211_rx_data_set_link_sta(rx, &sta->deflink))
 				continue;
 
 			rx_data_pending = true;
@@ -5458,20 +5477,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				continue;
 
 			if (rx_data_pending) {
-				ieee80211_prepare_and_rx_handle(&rx, skb,
+				ieee80211_prepare_and_rx_handle(rx, skb,
 								false);
 				rx_data_pending = false;
 			}
 
-			rx.sdata = sta->sdata;
-			if (!ieee80211_rx_data_set_link_sta(&rx, link_sta))
+			rx->sdata = sta->sdata;
+			if (!ieee80211_rx_data_set_link_sta(rx, link_sta))
 				continue;
 
 			rx_data_pending = true;
 		}
 
 		if (rx_data_pending) {
-			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
+			if (ieee80211_prepare_and_rx_handle(rx, skb, true))
 				return;
 
 			goto out;
@@ -5526,14 +5545,14 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		if (link_sta && link &&
 		    ieee80211_rx_valid_freq(status->freq, link)) {
 			if (rx_data_pending) {
-				ieee80211_prepare_and_rx_handle(&rx, skb, false);
+				ieee80211_prepare_and_rx_handle(rx, skb, false);
 				rx_data_pending = false;
 			}
 
 			/* No valid_links check as we need to RX beacons */
 
-			rx.sdata = sdata;
-			if (ieee80211_rx_data_set_link_sta(&rx, link_sta))
+			rx->sdata = sdata;
+			if (ieee80211_rx_data_set_link_sta(rx, link_sta))
 				rx_data_pending = true;
 
 			continue;
@@ -5562,22 +5581,22 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		}
 
 		if (rx_data_pending) {
-			ieee80211_prepare_and_rx_handle(&rx, skb, false);
+			ieee80211_prepare_and_rx_handle(rx, skb, false);
 			rx_data_pending = false;
 		}
 
-		rx.sdata = sdata;
-		rx.local = sdata->local;
-		rx.link = link;
-		rx.link_id = link->link_id;
-		rx.sta = NULL;
-		rx.link_sta = NULL;
+		rx->sdata = sdata;
+		rx->local = sdata->local;
+		rx->link = link;
+		rx->link_id = link->link_id;
+		rx->sta = NULL;
+		rx->link_sta = NULL;
 
 		rx_data_pending = true;
 	}
 
 	if (rx_data_pending &&
-	    ieee80211_prepare_and_rx_handle(&rx, skb, true))
+	    ieee80211_prepare_and_rx_handle(rx, skb, true))
 		return;
 
  out:
@@ -5597,6 +5616,15 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_smd_ctx *smd_ctx = NULL;
+	struct ieee80211_rx_data rx = {};
+
+	/* cache the pointer to free it later */
+	if (status->smd_ctx_valid) {
+		smd_ctx = status->smd_ctx;
+		status->smd_ctx = NULL;
+		status->smd_ctx_valid = false;
+	}
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -5731,6 +5759,12 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 
 	kcov_remote_start_common(skb_get_kcov_handle(skb));
 
+	rx.smd_ctx = smd_ctx;
+
+	if (WARN_ONCE((status->flag & RX_FLAG_8023) && rx.smd_ctx,
+		      "802.3 packet but with IEEE P802.11bn SMD context"))
+		goto drop;
+
 	/*
 	 * Frames with failed FCS/PLCP checksum are not returned,
 	 * all other frames are returned without radiotap header
@@ -5748,12 +5782,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw,
 			__ieee80211_rx_handle_8023(hw, link_pubsta, skb, list);
 		else
 			__ieee80211_rx_handle_packet(hw, link_pubsta, skb,
-						     list);
+						     list, &rx);
 	}
+	kfree(smd_ctx);
 
 	kcov_remote_stop();
 	return;
  drop:
+	kfree(smd_ctx);
 	kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_rx_list);

-- 
2.34.1

