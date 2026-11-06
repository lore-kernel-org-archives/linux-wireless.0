Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951991;
	b=JrVQ/SwtAJZ55Ba2nHL661SQsC2ywifpZyevfG4+Qv1Zev//nwPIXC3JZWMTEbGvYaJn
	 RFFMYG9coHQo/hgh/LyU/xqitmuDevRqcYZNnUgmA438U6bWPOSkVuWn92jVQ5ckFolyh
	 vk2I/dFci7fS1FqDEPYxFKzrTqcwZaJOycKvYJgM77Y01bFB7NkrRPxPCban3zjfiwUcN
	 OAOpy2azJ4l7lYuqZNnbNJcjDWZEiTjlAD50eJbAWy2MT9c9N7CW3N1uwvFrQFYudct01
	 xxMWPKPaSJibhESODqbaEDRhJncpNfYYYlf2bXYNfpuBlB6cRH370H55QcnLf5PV17g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951991;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=;
	b=RrsNLDzYKLhmiuICTcsHnoIaRejpCns0tcrRBMYVqv/Sj7EwdWRn7f/OCPIQ/l6xnfDU
	 Y71n5SgPmEg+luUGXf58kVIRdehVsMt7t8OIo/BkroZDptNygctbuTgkcOb9iya9lC0A/
	 +fYbEUz4ykcHiiqbv8cj7yy4GTWbYUzNGgwQAxQtmi4ZzLN80vHPtQsHGpQ1GkO35UpQb
	 9lOo25dfDRjCkH6YK//BX9F6Le9f93Aa0jyw5KWQ/Q4njwhfEHfJfY0pIbQOZanL4h4Rr
	 fXkFA7wABUs5680FheNHffL+IqtanbIG12/9+vd88FEvR68BJA9ew4Sc2/pPeeywWtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="VR/lHKpj";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=edakwpAc;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A232606A33A
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A232606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VR/lHKpj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=edakwpAc
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67ROad3906879
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=; b=VR/lHKpjFXofTiP+
	4slZXQNPZgYCUXZjw/VQoMjepTowTdJij5xK9lq7Z84CYpjAASvPG3UGpc6U1TFL
	eBvaQFC5OILT6ZJXGEgukkaLlnomme69G15KnyQsAIUrN90lQMKFfgLajcEV06Iy
	XoKSObb4DcQY7Q6K65duc2iz/T7xUI0gXTSuheaIhGXZPz/7BvckH5vLkiOu8YKw
	ljCk6cW/g38/d+24jQMSh55wt4LcJK1KmMPU0l1KtB3fhgCZ8YdCh3czymrC+TYj
	oQ0t52BZmzIwiVM1nj/iSrV1YnHtTY+21EbqzkO/q5M4Xbk6ssZ+iqOZii0pbQzs
	VVPDmw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pasqjy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:50 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd3b9e70f88so428747a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951989; x=1794556789; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=;
        b=edakwpAczEGIFzO+c4xEamHkbWyDaMF6JzB7AhjfN7xH7bRxKgsBNznmt5sv1aTwli
         Aemwq9iL4QGGhl6DfiIOsEgW4F+4RobbiCaaVEOOUJuLruCdwCp37mWs+i1H1cRlZna3
         xjZ7PTaDPg4qJJVOqAPWcyD3u4A7KWeQbVgLxsk918YTY17IvVaCH1bpdCQlJQOjvscq
         hWVRGoXsN1zK9Es9a/764OYSxT48SNRb34fAduxf/e7JxAPKaYE89VYIa/naZoJ1V2Dx
         /Awtt83ehyq/J4BpNwuRHJzcx7eivMeDC6vG9TOK2mxnmlw6mbe3m52mrFXzBKIoriQ7
         yrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951989; x=1794556789;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h4VTTFuxKMGqTtxeJ0GF3MYhoSSpTs0uEoKXsXDkMsQ=;
        b=e5IfwScXNwri1aGr8UMr/odqi3xiKMmcjuDHga83DszPbTYVz1OGCqNNTAd+OLSYaG
         ebNiJvxBjfQAApyAipECuXiHsPxq/BvNtTOOAvsbF+sHYrqfudkl82Lh60/fm3k+dg7m
         y1+G1cHj6vsMSV8Fe5bJRxLWyR7pqjfrarhDQK3aX2MyIIKrO31SUcUBnbHTeKMAipUu
         YyTSa1W3pDZgRSK5l4NhAbwHdb0lavTXQ9F6TswPWuijpmBBhGgWKIrowU8Jp+LHqaBl
         CNUNOtsCvNRIUskvk75ZWNCRPyZRvUgrZlE2ls7PlWhfey6sfZ4HckSnAigs4JFLf9TC
         a7qw==
X-Gm-Message-State: APuU4Z+RA4O23zU44TKRRu1/BNHAeH/xO6eXIDf+28h/lAb21UO4Yz7Q
	2zYkzoUUujPOak6oloswBA6FKYJdxQPBCtMR6orbyNKjgBgAFM7JGL/vQXLUp8l0AdoxArawKpm
	te/cAMT/saQfXFy5Lqq1m5UhSWi9NwP6ZQrdxY28Y7BzSowvPyWd+GRcNQ+Qgh1dZrtjd
X-Gm-Gg: AYBFou3uJh/7TsCOM79znNvxCpwdXnSNAkSfR2l81MW4I/MR2XCHZHE/fIn+9/5Kh1W
	R4mj1GNbmaBId1O/v9hcs6ANHv7EenV9XhBq1yAhVqXo4RmCxGYyHIUYTeOgosgmGwqfTdNtRaN
	21wOMwoAPSdXSgniqH1rRqMEZ2spCiAOJDhIMouZolzz/FTZgpQC1f7wn7ewGtb7ZNwkZC9HNQP
	00nNIYoEDRDKDV7r4u3yXuMm6v/fBZAS9ZklUBO+rd+kOf7LdHEtXgsssvw2+GezZK5qfEYiLJM
	5EuESiPlRtdEKAXdynJX9zCNEH1mDqfs70XZUvXYp4tw0G8JNJdKD39bpViRzsKcDgngh63CT75
	y1RkdYAygIz0RHdTMrIgIOQ7PDQcifrB7hOmCVRj4EufvWNvH6OUQ2/9NjNfmMGUCTM3t6P3uXM
	zCrmpikkoKim2Lxmnin83BKKpu6zu6KnEuECP7m36Q13mjqpi6PdfjDu/FmA47VUyH/Qw/nEE=
X-Received: by 2002:a17:90b:52cc:b0:3ac:ffb8:183b with SMTP id 98e67ed59e1d1-3b0db6f90ddmr2007345a91.51.1793951989123;
        Thu, 05 Nov 2026 23:59:49 -0800 (PST)
X-Received: by 2002:a17:90b:52cc:b0:3ac:ffb8:183b with SMTP id 98e67ed59e1d1-3b0db6f90ddmr2007332a91.51.1793951988546;
        Thu, 05 Nov 2026 23:59:48 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:48 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:47 +0530
Subject: [PATCH wireless-next v4 10/21] wifi: nl80211/cfg80211: add support
 for querying SMD context for target AP MLD
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
Message-Id: <20261106-smd-v4-10-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX5ooKwvmeHdI8
 3nTaxuM7/xvp8oo8vnb/9lMnfdSVVQbiER3ELZjSE1HUYknClOQafa0IrmOboouRiEZI3vzKB+T
 dUVrNCwHcFI7xFyRQvuDElq3o9pDn5Z0Rv0JWknLI6fh/+GdaozeTD27qwgWMg3Wc6HUxcvxrwT
 ajobNgZb6k4Rgh/v3VeFgDH5Rm35UZam8kRMth9YY1fnHodiK/zfL8jnW+0pDcIdZHLLicJ9W0H
 6tUojsL8HKWLCG3GfSevmXaIghBnVELBOLVPjn9G4Rgpz4d+aay0mR1vazUSMrw3th3XuigYLhg
 zyzt889rC2kH8HIS5lESNKW91tikrtpgJ0CV736R85dvwq2y4tarf3pe5MJ9KRQvibXcCMB527h
 FTg4V0JnhpJIq/55iK4Bkb3h5fEOTysaY6jVhthlpQA5Qzg6EB4AUf9xoviafBTXnaUXKvjQtrE
 wkFogmsqlqd08rKXA/A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX3wHVMcxxmeUh
 lmxMdKH2q4YcuRbFnCNufTMg6TuXoACFYhQa3U7PBYPilRwTfIealZ9Stt3aq5TQx9vBC63/BPE
 L8zxe6cwvDuIrFavRKVWUpV5xlJUb8E=
X-Proofpoint-GUID: 1qlkHyqqpdJxgH_gTGPztzmftdIkfpw7
X-Authority-Analysis: v=2.4 cv=P4ivFSAu c=1 sm=1 tr=0 ts=6aed88f6 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=FHB-pW5jD_jF_FmM8B4A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: 1qlkHyqqpdJxgH_gTGPztzmftdIkfpw7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060031

During SMD BSS Transition, the non-AP MLD that has been prepared with a
target AP MLD may send the ST Execution frame directly to the target AP
MLD. In such scenarios, the target AP MLD should pull the context from
the current AP MLD to program TX and RX queues.

Add nl80211 support to handle NL80211_CMD_GET_SMD_CTX, which is sent by
userspace of the current AP MLD on behalf of the target AP MLD. This
command carries the context type to indicate to the drivers which context
needs to be collected. Once the collection is complete, the context is
sent back to userspace as an asynchronous multicast event using
NL80211_CMD_SMD_CTX_EVENT with full context data carried in
NL80211_ATTR_SMD_CTX.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h  |  55 +++++++++++++++++++
 net/wireless/core.c     |  25 +++++++++
 net/wireless/mlme.c     |  30 +++++++++++
 net/wireless/nl80211.c  | 140 ++++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h  |   9 ++++
 net/wireless/rdev-ops.h |  14 +++++
 net/wireless/trace.h    |  26 +++++++++
 7 files changed, 295 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 42cfdc885c90..36ee10ebd62c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4904,6 +4904,18 @@ struct cfg80211_smd_transition_info {
 	enum nl80211_smd_ctx_type type;
 };
 
+/**
+ * struct cfg80211_smd_get_ctx_pending - pending async GET_SMD_CTX request
+ * @list: linkage on wireless_dev::smd_get_ctx_pending_list
+ * @sta_addr: non-AP MLD address for which context was requested
+ * @dev_tracker: tracker object for the netdev referenced
+ */
+struct cfg80211_smd_get_ctx_pending {
+	struct list_head list;
+	u8 sta_addr[ETH_ALEN];
+	netdevice_tracker dev_tracker;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -5365,6 +5377,8 @@ struct cfg80211_smd_transition_info {
  * @set_smd_ctx: Set UHR SMD context data for the non-AP MLD. @st_info->ctx is
  *	freed immediately after this call returns; drivers must copy
  *	@st_info->ctx if asynchronous processing is required.
+ *
+ * @get_smd_ctx: Get UHR SMD context data for the non-AP MLD.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5766,6 +5780,9 @@ struct cfg80211_ops {
 	int	(*set_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			       const u8 *addr,
 			       struct cfg80211_smd_transition_info *st_info);
+	int	(*get_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       const u8 *addr,
+			       enum nl80211_smd_ctx_type type);
 };
 
 /*
@@ -7357,6 +7374,8 @@ enum ieee80211_ap_reg_power {
  * @links.cac_time_ms: CAC time in ms
  * @valid_links: bitmap describing what elements of @links are valid
  * @radio_mask: Bitmask of radios that this interface is allowed to operate on.
+ * @smd_get_ctx_lock: lock to protect pending get_smd_ctx requests.
+ * @smd_get_ctx_pending_list: list to track pending get_smd_ctx requests.
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -7480,6 +7499,10 @@ struct wireless_dev {
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
 	u16 valid_links;
 
+	/* protects @smd_get_ctx_pending_list */
+	spinlock_t smd_get_ctx_lock;
+	struct list_head smd_get_ctx_pending_list;
+
 	u32 radio_mask;
 };
 
@@ -11249,4 +11272,36 @@ struct ieee80211_smd_ctx {
 	} ul;
 };
 
+/**
+ * cfg80211_free_pending_smd_ctx_req - Free remaining entries in the
+ *	cfg80211_smd_get_ctx_pending list.
+ * @wdev: wdev that maintains the list
+ * @addr: if @addr is NULL, drain the entire list; otherwise, drain only the
+ *	matching entries
+ *
+ * When the current AP MLD requests the station's context, those requests are
+ * maintained in a pending list until drivers notify completion. In case the
+ * device is brought down or the station is removed prematurely, free up the
+ * remaining entries in the list.
+ */
+void cfg80211_free_pending_smd_ctx_req(struct wireless_dev *wdev,
+				       const u8 *addr);
+
+/**
+ * cfg80211_get_smd_ctx_done - deliver async GET_SMD_CTX result to nl80211
+ * @wdev: wireless device that handled the request
+ * @sta_addr: non-AP MLD address the context was collected for
+ * @st_info: SMD BSS Transition Info (set @st_info->ctx to NULL to indicate
+ *	failure)
+ *
+ * Called via ieee80211_get_smd_ctx_done after async driver context collection
+ * completes. Finds the matching pending request and sends a multicast
+ * %NL80211_CMD_SMD_CTX_EVENT reply to userspace (MLME group).
+ *
+ * Return: None
+ */
+void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
+			       const u8 *sta_addr,
+			       struct cfg80211_smd_transition_info *st_info);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f4153c249599..5712fc5c6096 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1483,6 +1483,25 @@ void wiphy_rfkill_set_hw_state_reason(struct wiphy *wiphy, bool blocked,
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state_reason);
 
+void cfg80211_free_pending_smd_ctx_req(struct wireless_dev *wdev,
+				       const u8 *addr)
+{
+	struct cfg80211_smd_get_ctx_pending *pending, *tmp;
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_for_each_entry_safe(pending, tmp,
+				 &wdev->smd_get_ctx_pending_list,
+				 list) {
+		if (!addr || ether_addr_equal(pending->sta_addr, addr)) {
+			list_del(&pending->list);
+			netdev_put(wdev->netdev, &pending->dev_tracker);
+			kfree(pending);
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+}
+EXPORT_SYMBOL(cfg80211_free_pending_smd_ctx_req);
+
 static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 				      bool unregister_netdev)
 {
@@ -1565,6 +1584,10 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 		}
 	}
 
+	if (wdev->iftype == NL80211_IFTYPE_AP ||
+	    wdev->iftype == NL80211_IFTYPE_AP_VLAN)
+		cfg80211_free_pending_smd_ctx_req(wdev, NULL);
+
 	wdev->connected = false;
 }
 
@@ -1708,6 +1731,8 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
 	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	spin_lock_init(&wdev->smd_get_ctx_lock);
+	INIT_LIST_HEAD(&wdev->smd_get_ctx_pending_list);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 80ca9031d29c..0631e42e2fa1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1577,3 +1577,33 @@ void cfg80211_mlo_reconf_add_done(struct net_device *dev,
 	nl80211_mlo_reconf_add_done(dev, data);
 }
 EXPORT_SYMBOL(cfg80211_mlo_reconf_add_done);
+
+void cfg80211_get_smd_ctx_done(struct wireless_dev *wdev,
+			       const u8 *sta_addr,
+			       struct cfg80211_smd_transition_info *st_info)
+{
+	struct cfg80211_smd_get_ctx_pending *pending = NULL, *iter;
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_for_each_entry(iter, &wdev->smd_get_ctx_pending_list, list) {
+		if (ether_addr_equal(iter->sta_addr, sta_addr)) {
+			pending = iter;
+			list_del(&pending->list);
+			break;
+		}
+	}
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	if (!pending) {
+		wiphy_err(wdev->wiphy,
+			  "No pending SMD ctx req for %pM found in %s\n",
+			  sta_addr, __func__);
+		return;
+	}
+
+	nl80211_notify_get_smd_ctx_done(wdev, sta_addr, st_info);
+
+	netdev_put(wdev->netdev, &pending->dev_tracker);
+	kfree(pending);
+}
+EXPORT_SYMBOL(cfg80211_get_smd_ctx_done);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 249d7a3c2841..f30110d998d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20157,8 +20157,7 @@ static size_t _nl80211_smd_ctx_nl_ba_param_size(u8 n_tids, bool dl)
 	return n;
 }
 
-static size_t
-nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
 {
 	const struct ieee80211_smd_ctx *ctx = st_info->ctx;
 	int n_dl_tids = 0, n_ul_tids = 0;
@@ -20273,8 +20272,8 @@ nl80211_put_smd_ctx_ba_params(struct sk_buff *msg,
 	return -ENOBUFS;
 }
 
-static int nl80211_put_smd_ctx(struct sk_buff *msg,
-			       struct cfg80211_smd_transition_info *st_info)
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info)
 {
 	struct nlattr *dl_sn = NULL, *ul_sn = NULL, *ul_pn = NULL;
 	struct nlattr *smd_ctx = NULL, *dl = NULL, *ul = NULL;
@@ -21185,6 +21184,92 @@ static int nl80211_set_smd_ctx(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static struct cfg80211_smd_get_ctx_pending *
+__cfg80211_get_smd_sta_pending_ctx(struct wireless_dev *wdev, const u8 *addr)
+{
+	struct cfg80211_smd_get_ctx_pending *pending = NULL, *tmp;
+
+	lockdep_assert_held(&wdev->smd_get_ctx_lock);
+
+	list_for_each_entry(tmp, &wdev->smd_get_ctx_pending_list, list) {
+		if (ether_addr_equal(tmp->sta_addr, addr)) {
+			pending = tmp;
+			break;
+		}
+	}
+
+	return pending;
+}
+
+static int nl80211_get_smd_ctx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_smd_get_ctx_pending *pending;
+	enum nl80211_smd_ctx_type type;
+	const u8 *addr = NULL;
+	int err;
+
+	if (!rdev->ops->get_smd_ctx)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_AP_VLAN)
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR] ||
+	    !info->attrs[NL80211_ATTR_SMD_CTX_TYPE]) {
+		GENL_SET_ERR_MSG(info, "required attributes are missing");
+		return -EINVAL;
+	}
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+	type = nla_get_u8(info->attrs[NL80211_ATTR_SMD_CTX_TYPE]);
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	if (__cfg80211_get_smd_sta_pending_ctx(wdev, addr)) {
+		spin_unlock_bh(&wdev->smd_get_ctx_lock);
+		return -EBUSY;
+	}
+	/* safe to unlock, concurrent commands are serialized by wiphy mutex */
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	pending = kzalloc_obj(*pending);
+	if (!pending)
+		return -ENOMEM;
+
+	memcpy(pending->sta_addr, addr, ETH_ALEN);
+
+	/*
+	 * Take reference and add to the list before calling the driver to avoid
+	 * race. Upon success, the reference is released while reporting back
+	 * the context or in the list removal and drain path.
+	 */
+	netdev_hold(wdev->netdev, &pending->dev_tracker, GFP_KERNEL);
+
+	spin_lock_bh(&wdev->smd_get_ctx_lock);
+	list_add_tail(&pending->list, &wdev->smd_get_ctx_pending_list);
+	spin_unlock_bh(&wdev->smd_get_ctx_lock);
+
+	err = rdev_get_smd_ctx(rdev, wdev, addr, type);
+	if (err) {
+		/* revert upon failure */
+		spin_lock_bh(&wdev->smd_get_ctx_lock);
+		pending = __cfg80211_get_smd_sta_pending_ctx(wdev, addr);
+		if (pending) {
+			list_del(&pending->list);
+			netdev_put(wdev->netdev, &pending->dev_tracker);
+			kfree(pending);
+		}
+		spin_unlock_bh(&wdev->smd_get_ctx_lock);
+		return err;
+	}
+
+	/* Reply will arrive via cfg80211_get_smd_ctx_done() */
+	return 0;
+}
+
 #define SELECTOR(__sel, name, value) \
 	((__sel) == (value)) ? NL80211_IFL_SEL_##name :
 int __missing_selector(void);
@@ -22109,6 +22194,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_CLEAR_SKB),
 	},
+	{
+		.cmd = NL80211_CMD_GET_SMD_CTX,
+		.doit = nl80211_get_smd_ctx,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -25141,6 +25232,47 @@ void cfg80211_nan_channel_evac(struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_nan_channel_evac);
 
+void
+nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct net_device *dev = wdev->netdev;
+	size_t msg_len = NLMSG_DEFAULT_SIZE;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (st_info->ctx)
+		msg_len = 100 + nl80211_smd_ctx_nl_size(st_info) +
+			  nla_total_size(ETH_ALEN); /* MLD address */
+
+	msg = nlmsg_new(msg_len, GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SMD_CTX_EVENT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN, sta_addr))
+		goto nla_put_failure;
+
+	if (st_info->ctx && nl80211_put_smd_ctx(msg, st_info))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index bdb065d14054..2855d30ba354 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -129,4 +129,13 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
 void nl80211_mlo_reconf_add_done(struct net_device *dev,
 				 struct cfg80211_mlo_reconf_done_data *data);
 
+size_t nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info);
+int nl80211_put_smd_ctx(struct sk_buff *msg,
+			struct cfg80211_smd_transition_info *st_info);
+
+void
+nl80211_notify_get_smd_ctx_done(struct wireless_dev *wdev,
+				const u8 *sta_addr,
+				struct cfg80211_smd_transition_info *st_info);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 96a47eccc196..e84a5c2153db 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1727,4 +1727,18 @@ static inline int rdev_set_smd_ctx(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_get_smd_ctx(struct cfg80211_registered_device *rdev,
+				   struct wireless_dev *wdev, const u8 *addr,
+				   enum nl80211_smd_ctx_type type)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_get_smd_ctx(&rdev->wiphy, wdev, addr, type);
+	if (rdev->ops->get_smd_ctx)
+		ret = rdev->ops->get_smd_ctx(&rdev->wiphy, wdev, addr, type);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 67db0b032808..37456e5530f3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4509,6 +4509,32 @@ TRACE_EVENT(rdev_set_smd_ctx,
 	)
 );
 
+TRACE_EVENT(rdev_get_smd_ctx,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, const u8 *addr,
+		 enum nl80211_smd_ctx_type type),
+
+	TP_ARGS(wiphy, wdev, addr, type),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		MAC_ENTRY(sta_addr)
+		__field(u8, st_type)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(sta_addr, addr);
+		__entry->st_type = type;
+	),
+
+	TP_printk(WIPHY_PR_FMT  ", " WDEV_PR_FMT
+		  ", sta=%pM, ST type=%u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->sta_addr,
+		  __entry->st_type)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

