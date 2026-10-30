Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367063;
	b=4853K+RLIG0pIqC6ai4J968cQKX217U+aqnkxCZRkLnZfZqsodpzs8pUUkaD8PGgKYJH
	 Qzc04y0pIxyXCWKn9DDIUsHW0N4LG3+etlnzHgN5MMb+Hx8KweBhWOTnSycA2Icfc+7wO
	 I1noWswAmlNLIKq3kLStqMcDPQJ9YGvvdKGeASAU8a2MEufJ3vBWfPxSa4x0ghb+0srKI
	 9HJjhuOvLda9vcYv5FfvjhE/KU28fQ4VW99MZ5n5u7AglQeOdTz5xhV4+WeBcNek+Llrh
	 hKxWgpMSZrq+KqPfxHkA8PHyvkOIz/jgFmu+1Ivvh2V2RiptkcDKDq2jipw4m4IyDTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367063;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=yZAogoGQSXRyQWdTXEBO+Rb703BrJhhjCoclRRfSAF0=;
	b=3max0f5nxAUb2d2Ek4M1zKp8i/SOWJAF2tTi6edjuVuYOsBXkS3M7UsAgHKot2YK8wcd
	 RxpBtER34qi0bAl+Ge4YHO8gn66IKiAQSSoUq0eT1XmW8sz+g/y9jNgUT9b9uqS+QrcmX
	 RACSEDpDv8WEs93cvze3yLI93cUo489X2md14a3InXQbF2KAYXqi8nh5U2+b2AoaZfy+x
	 aDZxChDvFHyqBvEFSb7Xjq3xphhnLf40aCMVlHmJWg4rUpqohM3qInugfFSlgYR9hKbVs
	 7nqohgzqQam7SadRq2Sn6yXu4mU/zBYrrihHHkSWOQNw2+T/g1mxcakxgBkHBoA3O5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ecb0RbDM;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cUGLd58z;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334BE606A320
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 334BE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ecb0RbDM;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cUGLd58z
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBG1RK2071579
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=yZAogoGQSXR
	yQWdTXEBO+Rb703BrJhhjCoclRRfSAF0=; b=ecb0RbDM4gSHLtufGT/Fu/GzaHB
	LUh/ty9jEqg3DpL6LOoY8b+JPJuoJyUlMbELSz4nZA/u1bnY+TucQlP7Sn+gmL9L
	wndLUuV11D7tX2YiyaLmuSvZZMjmCy9PQEuaIiGQFpJTz3XmcuSqSDdfi7eTbmBh
	lIHaJ9ZtTSVQcc4GWcQvFaPZk8MInY5d8XJ9AtkgUqIE4Ql5S20deYFk1n933LY+
	I+/UD06kYd3vA3Q962Tg43do4lvB+0ggxwKdA37s6cytg+O5iICP2VYMoePWM5ps
	9cHdtA1j0/574G22IJ9D8h8so53QPNThuP77dY397iBJJJzEuFH2Qsrw1dQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6p3929-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:31:01 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad3fc547bfso1031599a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367061; x=1793971861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yZAogoGQSXRyQWdTXEBO+Rb703BrJhhjCoclRRfSAF0=;
        b=cUGLd58zVwz/oqY6ZH5ElF21xikXakaYRRUprs/gLoF57wQIptcbX0bwPS6RdQngVY
         TULyXShIxlsi919pECjFBi6wvCuLCbha0UjRynPulwAAyzOpH9cvg7XxUHUHMZzVInQU
         TfGfuOblULBsl3lvyyajUXCGHrtAfn2I31yOXYEXm8OU9WVkWDKCUCXjnWP8vP/vsJo9
         zQQpONJj5NoM1Ifmbjk+VHdDp7kizFT/qg9Xtwd1zvI181d4csxLPJVvdUjEQODhIN8o
         naR8UBI12HClBjk/90dXmOj4yoSXKiqz81fdTRHSfw7pQNwPwFOuwlHRyJ3RB1oAXD/c
         mrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367061; x=1793971861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yZAogoGQSXRyQWdTXEBO+Rb703BrJhhjCoclRRfSAF0=;
        b=KuBU4pqAhplC/MjLmpHeJY1tFWiVCeTLfo+Lbc8CW2eEyw1dAfAwE9N2+IRX768/OD
         Jtx1ad/xRv0YvIkk7aSe3toxZJKfhw0SbXN4KwNTxj7V7qG4WgRzuGqfGwSEiE75yQtw
         G2Mt+9cLx3grvL4mGrhdCYVquUBy7ADwLq/ceoJgjaK0lIXDUjqS5GOfvrUy9lH+TmZ/
         WR11J/X9KTwYGCn4jHAcBEtePrib9z4FDsdgUl0xIAZh06WRqf0QZFCj3qRZwDVghNrV
         DObG733nFwO8FVbvj3z0xXxwxqM5SZvcQ4cUzeFgAVTo5yQBqk1EtqZEioz5tVBgZ4w3
         Esrw==
X-Gm-Message-State: AFq9FYJcb9r6+ltB1yeUotew7YLvaiuedUkAIYdtTQcp/ojFDb2zPIVR
	lHq5tkZaIY8yCgAfKi3VSPQaX/6pY27vgxCya9gcEctTRWMiHY1GXpOQUJ044B7d8K9uO+8T8rL
	JAKAlb94Mv08XyY5WC/nxNElgF7JYPG1KmPU769P7YwxIcnT5ED7XIsilh/N43h3vIGXlqQ==
X-Gm-Gg: AYBFou0sQ5DXYU2fzYly2WQTKYzLgoRI3TA0URYJ5BdGm4h8XLQdKNTvyGFYbQsP8My
	cGwY04zoxsYNZnDZN5rK2iZretw7obVFNWa8u3rSlUTzDi5uPBfQr0B4WrUl0gv0QaGySKHR6ym
	cSksD4aGRQ6uqhqd7uHlQ5D80uNZhk6VwkuCHqMDPOmUMwKitDLDiBclKY8yoWoUixIxVgw0g0G
	BBNv/8zvwx1oMfc6Tdc/70D6Y/IRcZk79hDjf0fIVmka8piVQfgQnZ335AHKHiiTRX6WK271g0C
	0V+cGfet+3nSgyrJeTrN3ANrqv2I6fANfIpJB2W9b1sFWAjjRvhEv2YyT1rNSmIM+tv4OOpFxEI
	ESIVez3mdZc3iJh1Q/bG7cCueQOhKTzUjU7pszIZBItbHWnyXvU1iml7QJ+mIqF0dtrRNF07ShA
	lsCHSPzjrhzQ==
X-Received: by 2002:a17:90b:2691:b0:3ab:189b:6980 with SMTP id 98e67ed59e1d1-3ae89776111mr1902399a91.39.1793367060576;
        Fri, 30 Oct 2026 06:31:00 -0700 (PDT)
X-Received: by 2002:a17:90b:2691:b0:3ab:189b:6980 with SMTP id 98e67ed59e1d1-3ae89776111mr1902366a91.39.1793367059748;
        Fri, 30 Oct 2026 06:30:59 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:59 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 11/16] wifi: nl80211/cfg80211: add support for NDP response in offload mode
Date: Fri, 30 Oct 2026 19:00:07 +0530
Message-Id: <20261030133012.3009774-12-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
References: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX4UaBBkXYD2Mc
 lGcZkDj6k4buuXJDBpQ8J114Im3o6c8ymnS9/CmAivHUuargiuPeYMZt1zjTZOfi0na5M7DndLr
 Xiw5KUDVPObX0bTqtrYwBUKiMF75VMya8h+JbkF0utiXhh0HsDdVBu0y5RetOXFo19ez1HAbirs
 2al6HRcDM8V5vUCj3nuRcRfr7BTNdTguhX034+qY81lBxCuHx7gBWf7Lvb6uxcrT201t3gADInx
 /Y/4JIpNY80TbdC4tyaSEhHCMCe4Tw5EG9D6Ic9DUmSmIbgc9PXPMjOH0wLcUKTWSPd6Dim4Q0B
 q8zLa7vfcWperJ4V6sYGgWaruyRKbwlZj5aEzDg8ECrvXdVNmBTCJay6ExciLFtuaDY/roc9aM9
 aQWQ8t00Zlq25s+UMLaDZ86aPt8RN7LBFThVGyVHxswunju+10QV7d3724yElS13buhfqc4VSjk
 Vw5QVz1BebaTiso3UEg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfXx9yf00A/aq+7
 njJJA8OqH/YIKZaBgudhR/79sulnrTpEmCcyEvXmsXRDEp0movUWFzejX2fdVtwGZ6sK7zoZwWk
 gF7u34gBAnW675adhPdd0bsXSV6ITKQ=
X-Proofpoint-ORIG-GUID: 1Nrh2PyACbiJWCMEkyiTPWFWQpdO8icH
X-Proofpoint-GUID: 1Nrh2PyACbiJWCMEkyiTPWFWQpdO8icH
X-Authority-Analysis: v=2.4 cv=TL3Q2Fla c=1 sm=1 tr=0 ts=6ae49c15 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=HzrLvHWT_3PvwsSceqsA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300053

Add NL80211_CMD_NAN_NDP_RESPOND to allow userspace to accept or reject
an incoming NDP request when NDP management is offloaded to firmware.
Add the corresponding parameter structure, nl80211 policy, command
handler, and driver callback. Reject the request if the driver has not
advertised NDP offload capability or if security material is provided
without secure NAN support.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  48 +++++++++++++
 include/uapi/linux/nl80211.h |  13 ++++
 net/wireless/nl80211.c       | 129 +++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  16 +++++
 net/wireless/trace.h         |  24 +++++++
 5 files changed, 230 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e5e58495d05c..5312eb8f83ac 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4381,6 +4381,49 @@ struct cfg80211_nan_ndp_initiate {
 	bool ndpe;
 };
 
+/**
+ * struct cfg80211_nan_ndp_respond - NAN NDP respond parameters
+ *
+ * @peer_nmi: peer NMI address
+ * @ndp_id: NDP ID from the received NDP Request
+ * @init_ndi: initiator NDI MAC from the received NDP Request
+ * @resp_ndi: responder NDI MAC. The corresponding
+ *	%NL80211_IFTYPE_NAN_DATA interface must exist (if accepting).
+ * @accept: if true, accept the NDP; if false, reject it
+ * @reason: rejection reason code (valid when @accept is false)
+ * @ssi: response service-specific info (may be NULL)
+ * @ssi_len: length of @ssi
+ * @cipher_suite: NAN cipher suite ID (must match initiator's)
+ * @pmk: NAN Data Path PMK (%NL80211_NAN_NDP_PMK_LEN bytes,
+ *	valid when @pmk_set is true)
+ * @pmk_set: if true, @pmk contains a valid PMK
+ * @gtk_required: if true, GTK protection is required
+ * @gtk_cipher: GTK cipher suite ID
+ * @ipv6_intf_id: IPv6 link-local interface identifier
+ *	(%NL80211_NAN_NDP_IPV6_INTF_ID_LEN bytes,
+ *	valid when @ipv6_intf_id_set is true)
+ * @ipv6_intf_id_set: if true, @ipv6_intf_id is valid
+ * @ndpe: if true, use NDPE attribute instead of NDP attribute
+ */
+struct cfg80211_nan_ndp_respond {
+	const u8 *peer_nmi;
+	u8 ndp_id;
+	const u8 *init_ndi;
+	const u8 *resp_ndi;
+	bool accept;
+	u8 reason;
+	const u8 *ssi;
+	u8 ssi_len;
+	u32 cipher_suite;
+	u8 pmk[NL80211_NAN_NDP_PMK_LEN];
+	bool pmk_set;
+	bool gtk_required;
+	u32 gtk_cipher;
+	u8 ipv6_intf_id[NL80211_NAN_NDP_IPV6_INTF_ID_LEN];
+	bool ipv6_intf_id_set;
+	bool ndpe;
+};
+
 /**
  * enum cfg80211_nan_conf_changes - indicates changed fields in NAN
  * configuration
@@ -5361,6 +5404,8 @@ struct mgmt_frame_regs {
  *
  * @nan_ndp_initiate: Initiate a NAN Data Path session as the initiator.
  *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
+ * @nan_ndp_respond: Respond to an incoming NDP request as the responder.
+ *	Only valid if the driver has set %WIPHY_NAN_FLAGS_OFFLOAD_NDP.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
@@ -5772,6 +5817,9 @@ struct cfg80211_ops {
 	int     (*nan_ndp_initiate)(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    struct cfg80211_nan_ndp_initiate *params);
+	int	(*nan_ndp_respond)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_nan_ndp_respond *params);
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4831da4fd253..a9785b628f3e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1474,6 +1474,11 @@
  *	interface specified in %NL80211_NAN_NDP_ATTR_INIT_NDI must already
  *	exist as a %NL80211_IFTYPE_NAN_DATA interface. Carries
  *	%NL80211_ATTR_NAN_NDP nested with %NL80211_NAN_NDP_ATTR_* fields.
+ * @NL80211_CMD_NAN_NDP_RESPOND: Respond to a received NDP request as
+ *	the responder. Requires %WIPHY_NAN_FLAGS_OFFLOAD_NDP. The NDI
+ *	interface specified in %NL80211_NAN_NDP_ATTR_RESP_NDI must already
+ *	exist as a %NL80211_IFTYPE_NAN_DATA interface. Carries
+ *	%NL80211_ATTR_NAN_NDP nested with %NL80211_NAN_NDP_ATTR_* fields.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1758,6 +1763,7 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_BEACON,
 
 	NL80211_CMD_NAN_NDP_INITIATE,
+	NL80211_CMD_NAN_NDP_RESPOND,
 
 	/* add new commands above here */
 
@@ -8104,6 +8110,11 @@ enum nl80211_nan_conf_attributes {
  *	interface identifier. Included as NDPE TLV type 0 when present.
  * @NL80211_NAN_NDP_ATTR_NDPE: flag. Use NDPE attribute instead of NDP
  *	attribute when peer supports NDPE.
+ * @NL80211_NAN_NDP_ATTR_ACCEPT: flag. If present in
+ *	%NL80211_CMD_NAN_NDP_RESPOND, the NDP is accepted. If absent, it is
+ *	rejected.
+ * @NL80211_NAN_NDP_ATTR_REASON: (u8) Termination or rejection reason
+ *	code (enum nan_reason from the Wi-Fi Aware Specification).
  * @__NL80211_NAN_NDP_ATTR_LAST: Internal.
  * @NL80211_NAN_NDP_ATTR_MAX: Highest NDP attribute.
  */
@@ -8123,6 +8134,8 @@ enum nl80211_nan_ndp_attributes {
 	NL80211_NAN_NDP_ATTR_GTK_CIPHER,
 	NL80211_NAN_NDP_ATTR_IPV6_INTF_ID,
 	NL80211_NAN_NDP_ATTR_NDPE,
+	NL80211_NAN_NDP_ATTR_ACCEPT,
+	NL80211_NAN_NDP_ATTR_REASON,
 
 	/* keep last */
 	__NL80211_NAN_NDP_ATTR_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5ee053f53143..2511175c70f3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -794,6 +794,8 @@ nl80211_nan_ndp_policy[NL80211_NAN_NDP_ATTR_MAX + 1] = {
 	[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID] =
 		NLA_POLICY_EXACT_LEN(NL80211_NAN_NDP_IPV6_INTF_ID_LEN),
 	[NL80211_NAN_NDP_ATTR_NDPE] = { .type = NLA_FLAG },
+	[NL80211_NAN_NDP_ATTR_ACCEPT] = { .type = NLA_FLAG },
+	[NL80211_NAN_NDP_ATTR_REASON] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -18640,6 +18642,127 @@ static int nl80211_nan_ndp_initiate(struct sk_buff *skb,
 	return rdev_nan_ndp_initiate(rdev, wdev, &params);
 }
 
+static int nl80211_nan_ndp_respond(struct sk_buff *skb,
+				   struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct nlattr *tb[NL80211_NAN_NDP_ATTR_MAX + 1];
+	struct cfg80211_nan_ndp_respond params = {};
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP respond requires NAN interface");
+		return -EOPNOTSUPP;
+	}
+
+	if (!(rdev->wiphy.nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP)) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NAN NDP offload not supported by driver");
+		return -EOPNOTSUPP;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_NAN_NDP]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP respond requires peer NMI and NDP params");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, NL80211_NAN_NDP_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_NAN_NDP],
+			       nl80211_nan_ndp_policy,
+			       info->extack);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_NAN_NDP_ATTR_ID] ||
+	    !tb[NL80211_NAN_NDP_ATTR_INIT_NDI]) {
+		NL_SET_ERR_MSG(info->extack,
+			       "NDP respond requires NDP ID and INIT_NDI");
+		return -EINVAL;
+	}
+
+	params.peer_nmi = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	params.ndp_id = nla_get_u8(tb[NL80211_NAN_NDP_ATTR_ID]);
+	params.init_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_INIT_NDI]);
+	params.accept = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_ACCEPT]);
+
+	if (params.accept) {
+		if (!tb[NL80211_NAN_NDP_ATTR_RESP_NDI]) {
+			NL_SET_ERR_MSG(info->extack,
+				       "NDP accept requires RESP_NDI");
+			return -EINVAL;
+		}
+		params.resp_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_RESP_NDI]);
+	} else {
+		if (tb[NL80211_NAN_NDP_ATTR_REASON])
+			params.reason =
+				nla_get_u8(tb[NL80211_NAN_NDP_ATTR_REASON]);
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_SSI]) {
+		params.ssi = nla_data(tb[NL80211_NAN_NDP_ATTR_SSI]);
+		params.ssi_len = nla_len(tb[NL80211_NAN_NDP_ATTR_SSI]);
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_CIPHER_SUITE])
+		params.cipher_suite =
+			nla_get_u32(tb[NL80211_NAN_NDP_ATTR_CIPHER_SUITE]);
+
+	if (params.accept && tb[NL80211_NAN_NDP_ATTR_PMK]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_PMK],
+					    "PMK requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+		memcpy(params.pmk,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_PMK]),
+		       NL80211_NAN_NDP_PMK_LEN);
+		params.pmk_set = true;
+	}
+
+	if (params.accept && tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SECURE_NAN)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED],
+					    "GTK_REQUIRED requires SECURE_NAN feature");
+			return -EOPNOTSUPP;
+		}
+
+		if (!tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[NL80211_NAN_NDP_ATTR_GTK_REQUIRED],
+					    "GTK_CIPHER is required when GTK_REQUIRED is set");
+			return -EINVAL;
+		}
+
+		params.gtk_required = true;
+		params.gtk_cipher =
+			nla_get_u32(tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]);
+	} else if (params.accept && tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER]) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_NAN_NDP_ATTR_GTK_CIPHER],
+				    "GTK_CIPHER requires GTK_REQUIRED");
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID]) {
+		memcpy(params.ipv6_intf_id,
+		       nla_data(tb[NL80211_NAN_NDP_ATTR_IPV6_INTF_ID]),
+		       NL80211_NAN_NDP_IPV6_INTF_ID_LEN);
+		params.ipv6_intf_id_set = true;
+	}
+
+	params.ndpe = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_NDPE]);
+
+	return rdev_nan_ndp_respond(rdev, wdev, &params);
+}
+
 static bool nl80211_nan_is_sched_empty(struct cfg80211_nan_local_sched *sched)
 {
 	if (!sched->n_channels)
@@ -21798,6 +21921,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
 	},
+	{
+		.cmd = NL80211_CMD_NAN_NDP_RESPOND,
+		.doit = nl80211_nan_ndp_respond,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index df8ec338e59d..d65dd39a1bcb 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1205,6 +1205,22 @@ rdev_nan_ndp_initiate(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_nan_ndp_respond(struct cfg80211_registered_device *rdev,
+		     struct wireless_dev *wdev,
+		     struct cfg80211_nan_ndp_respond *params)
+{
+	int ret;
+
+	if (!rdev->ops->nan_ndp_respond)
+		return -EOPNOTSUPP;
+
+	trace_rdev_nan_ndp_respond(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->nan_ndp_respond(&rdev->wiphy, wdev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0da1c159315b..f937941c6076 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2574,6 +2574,30 @@ TRACE_EVENT(rdev_nan_ndp_initiate,
 		  __entry->peer_nmi, __entry->publish_id)
 );
 
+TRACE_EVENT(rdev_nan_ndp_respond,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_ndp_respond *params),
+	TP_ARGS(wiphy, wdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__array(u8, peer_nmi, ETH_ALEN)
+		__field(u8, ndp_id)
+		__field(bool, accept)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		memcpy(__entry->peer_nmi, params->peer_nmi, ETH_ALEN);
+		__entry->ndp_id = params->ndp_id;
+		__entry->accept = params->accept;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
+		  ", peer: %pM, ndp_id: %u, accept: %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  __entry->peer_nmi, __entry->ndp_id, __entry->accept)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
-- 
2.34.1

