Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907639;
	b=tWI90ujY1aC8qxdcGSk+KbzcUoB6tbLBJiGMmlaph4KO4bZYj7l31dWkKCEPRhFOj9DF
	 TUWDw1Cb3K0c5EmRZuGEZZhr6EJVujA9HM5UirpPqhSm+gzr7DBCAEuiFTL6LUUbMLnlY
	 Qo+yYuiEyOmmlZw3WcwOvV4FWoQNXbJ1ifIGZLHVYZ12QXKxyINesCzmS7E7risExdr5v
	 5ig9u0sYP+DpPrF0+jdldzvOEJKSMqBNKPsRDBbG2cWjur3APbTUInwpwjN8HDozQnwZb
	 JziIPtCgc+Ag4eUdgRcsZ9Pw21SefwCQBKFyYi4cas37WBAQSU+AU0PaOTBBOOLJhKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907639;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=;
	b=OWNLN5IcOtIlgneDat1Z2wi8B2SewOMgzro4e0d8KkyBFAXQT7DAtJmNmjhrWaXBBR/M
	 aw6gpfSg6h5EYyPXeNfrriqvOdkNNmw2QiFAsYW/IizHuTxv8bo97SdI4I7KTrckGy1KR
	 f3Ri13+hJfUNo6AY7Nfqh0s6VNmD+JlnyR4nSOvCg1SGVxLgUD3P88SJZwwymsQePLhk7
	 KXp6WR0spgH5dPtiDPEgibJMTcCzzBxlGHwC0H0+wdI07VIn+tfWX7KzQX98Yqd5D1t/X
	 6RJYz2t7plUA/O1MxD6+pH5Yv9xnt1XynFi55NuVYsLvjAO5DdFmAdBt4XR0JdfbO6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VxRrGRUq;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DYut8wh1;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4692606E41C
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4692606E41C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VxRrGRUq;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DYut8wh1
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeL3W2091030
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=; b=VxRrGRUqu5IINdtn
	0MI9js5xOg45OlpdFYMJ4FqFnwV5mL6ws76HPr8eBJ50JGaPUEjlsgsbkfXtUYYU
	hCW4Ie5pBBYHZ8L0MqwH/24/6BGj0PBh1Tpqg+WEkE2vQ8RV40YUDXbOFZ37bv8q
	eBZSSUNjeUVhXrbXHuEbaaYofmCpyLChEt8VcDNIhkDzHNML2blOBOctTN6Dzu5j
	4nz8vPtGNeLNnEzjuv0MAGj8TSb15JPyGvBWULM4eFDst+fEFFF8Qa9+eHQucw5X
	jHEQi5Dgs9PndyRrwtJyHg6qFulKiOqz44vmpLiP8/zzy1p+5g7tbIy1QV9+kxab
	rVHbZw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrq9faky4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:37 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3552883bd19so4077974eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907637; x=1794512437; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=;
        b=DYut8wh1YKQdwI8oODUHS39dW5B5jYjiQTKUtA3kV650ffKuxixzZHwAuIdByqiybQ
         aL//m+hGrZG2bxMchAx2aAD3XHdL/xH7AKMtbj3tz78rTpaTQA/ZMJ9YNdtH9l25jEjl
         nuHvFjoxann56DcjP3ufFsAUUMHGDsrsa/H2iJDT3m5ap97No8EvOkFo5DDhAXDafe9/
         r42WpgzAQxvhd0+kutL/V8bLjpBs7+G4ToZ6hw7OQLr+8hzDoGtkdzxy2j9TUhGnjG8v
         FTD/GhvuwkaDVxJ+IfqqxZXi/GxK+Lg7h99HE7Ipe9n3K4cM5UU2eG3l4SG2gz06c0GG
         Gl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907637; x=1794512437;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7XCIGy7VOcydOSZMHcSQZc1HcSURFK9cVcXy2V6Ix0Q=;
        b=qHXCkcW3PKn5S/DSIyd7bMF4x8J3g5IFAAIY1b9ye5po+UMKA93i247/fhHLMND2au
         MnuBwW3UpBbkI4cpdBjS0VDAFzLwniACPElCb0dvdO4sMBRF7K2pdB0LqqkzsUq1XyPH
         q+Bu0awNVLylKqfEVxlWVwgtn8mURgzrkdZUl/JOC9H0RAbAegc8lRgBdrVljoh1ad/B
         vRFreUno6DAgEMUsQF26/nDa70XrP9dWyoZtthjS8BXhPF2AtDy+aKd9VNEumZDheEk3
         9eqJudxIBLq+Mqd6SdVQKfufSdWajjCCQW8rrMgRP3dF3MOjpuPl0GPL4i4IiMHpRDda
         K9Mw==
X-Gm-Message-State: APuU4Z8Mx/TB8XLLcVVGyFfNl7otgq2Gf+RruUF9iTW+FR5SCO/64Aac
	icrBnjFfWK9TeQI/FS60SFxuqT9mByEGKObhlOctsXmSSF8/K/udSo8eRAu4XqslZtIJCm4avcs
	UlGpN2WTChUBXK2dzQAtBl56VEpYCH5ejXsSCHKc5hyrDvY3eoKLYnBNuyGvO9u1f26e/
X-Gm-Gg: AYBFou0ej3ii2pHY2V/Zircj422Zrgjd2ENOtScKmzv4zOGbRiazUOSVD66i6ogNmlZ
	lFJgXtiLW+AJnlbetXAaWDAc2aCnN/u3vDZFX4SheRbtDNCNFj5SL9eoR3EBNUoA6B7fmankRg7
	5ox5Y3WUb8fV9UssncwY4BVtv7PMO58Fs4QHsM9tPLipeWHV+oMkuQAQQwTxL13vTH7rOxmzuMl
	CNqFo1tsaICndwZhG2i35rf7a0T0y/LufvyiSCo9HLzn0xWQFvLZkMb+RxIYmQDF0pzYlictmm0
	8/7UjKTz6S53x7MbaIdR/WOrLrrRK0nyY3NNG3hW65YV0wGdtD2nyXzdZ68B4cziLqmwju5JOSV
	rc6opGaq78LmVd6hu8O3ny4BqB1MblvCL4wMqEQLqFjK+i26D4L0BJ9Uz3ol+BCkkEVM8ACy4iB
	2kd71X+tNJnXw5hAg6XXr8C8HL0+JG0ULnocV6V3Yr+1gG8GcwFtM5qMBWkpZs5yXspStHWg==
X-Received: by 2002:a05:7301:1522:b0:36c:a104:90db with SMTP id 5a478bee46e88-36f77eda3afmr135557eec.41.1793907636553;
        Thu, 05 Nov 2026 11:40:36 -0800 (PST)
X-Received: by 2002:a05:7301:1522:b0:36c:a104:90db with SMTP id 5a478bee46e88-36f77eda3afmr135529eec.41.1793907635907;
        Thu, 05 Nov 2026 11:40:35 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:35 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:43 +0530
Subject: [PATCH wireless-next v3 08/21] wifi: nl80211/cfg80211: pack SMD
 dynamic context along with frame
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
Message-Id: <20261106-smd-v3-8-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX39P6oRfkN4Hp
 jx+hhJUuewNcOlJezaYiWRbnsIWxSWapw2Hmvo0EFNYcDMEacZ39MX/SZIgd6U7f958kpYXuF94
 1iaw+2CZ20yxUdtmnmc1tAUR0YcyAnIru+wnYuQimv/wcwPyR9Ke2EJ0GpuHWfsymmc0ENZK1S9
 TASK2ao1eL+2OukMU9ki2yM04BIBzCCx1Bm3EXRdUYrbOx9l23aswUolKBU2XZI8sm5u5EjS5n8
 uCwIuT1u9w4J4PEWMZt2MX3Qe0LRyhqLbM0ehViT9iU9bHdWBLPhlA7fBGGIMC0OZJOlxtyco5y
 G3VGd7xv39iJOCBOfGxzGB0iCRHrOhDvaY22EiAHH9dF61PDK16v+JbWwDAQUjM1QusWVBfvmU+
 zkybXNwyxGDH24LzC6M9jAR7RSf4fxc5jhTOdaoyBNGJByw1Va0OyeSL4khZiV18+BJWUdCXMIo
 lGnWTry8PmofsxquD2w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX1bDMQtIVyiow
 oYfqu0WwyoQM223TwTrz9IBSOXiuuaAiJEVV/lX/lX7jPwbE9dS46Ds12EMMXXmc1CDvQSBa0Zu
 sDanhh4bc2LNFSKbkreBkZU6f4fadd0=
X-Authority-Analysis: v=2.4 cv=Vdhir1p9 c=1 sm=1 tr=0 ts=6aecdbb5 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=Q3n5vibPIWZSySpmOWoA:9 a=DZ0Sps0JoYeYFSLR:21
 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: nLsWKEhJjNQa1q6IUy3Dh7EfhxXDWv2W
X-Proofpoint-GUID: nLsWKEhJjNQa1q6IUy3Dh7EfhxXDWv2W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

While packing the received management frame in nl80211_send_mgmt() to
send to userspace, nest the SMD dynamic context along with the frame
message. This shall be used by userspace to transport the context to the
target AP MLD for programming the dynamic state of the STA session for
seamless roaming as part of SMD BSS Transition.

Suggested-by: Jouni Malinen <jouni.malinen@oss.qualcomm.com>
Co-developed-by: Aditya Sathish <asathish@qti.qualcomm.com>
Signed-off-by: Aditya Sathish <asathish@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h |  13 +++
 net/wireless/nl80211.c | 286 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 298 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 938fbfe0e71d..877845477ce9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4893,6 +4893,17 @@ struct mgmt_frame_regs {
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
@@ -9624,6 +9635,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @rx_tstamp: Hardware timestamp of frame RX in nanoseconds
  * @ack_tstamp: Hardware timestamp of ack TX in nanoseconds
  * @no_sta: set if no station is known for the frame (relevant for MLD)
+ * @st_info: SMD BSS Transition data
  */
 struct cfg80211_rx_info {
 	int freq;
@@ -9636,6 +9648,7 @@ struct cfg80211_rx_info {
 	u64 rx_tstamp;
 	u64 ack_tstamp;
 	bool no_sta;
+	struct cfg80211_smd_transition_info st_info;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d2cd03d8b0c5..33e52b8bb5fa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20137,6 +20137,282 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_epcs(rdev, dev, val);
 }
 
+static size_t _nl80211_smd_ctx_nl_ba_param_size(u8 n_tids, bool dl)
+{
+	size_t n = 0;
+
+	n += nla_total_size(0); /* ba_params nest header */
+	n += n_tids * (nla_total_size(0) + /* tid nest header */
+		       nla_total_size(sizeof(u16)) + /* buff_size */
+		       nla_total_size(sizeof(u8)) + /* policy */
+		       nla_total_size(0) + /* amsdu_support */
+		       nla_total_size(sizeof(u16)) + /* timeout */
+		       nla_total_size(0) + /* ext_no_frag */
+		       nla_total_size(sizeof(u8)) + /* ext_frag_lvl */
+		       nla_total_size(sizeof(u16))); /* ext_buff_size */
+
+	if (dl)
+		n += n_tids * nla_total_size(sizeof(u16)); /* winstarto */
+
+	return n;
+}
+
+static size_t
+nl80211_smd_ctx_nl_size(struct cfg80211_smd_transition_info *st_info)
+{
+	const struct ieee80211_smd_ctx *ctx = st_info->ctx;
+	int n_dl_tids = 0, n_ul_tids = 0;
+	u8 pn_len = ctx->pn_len;
+	size_t n = 0;
+
+	/* count valid TIDs */
+	n_dl_tids = hweight8(ctx->dl.valid_tid_bmap);
+	n_ul_tids = hweight8(ctx->ul.valid_tid_bmap);
+
+	n += nla_total_size(sizeof(u8)); /* ST type */
+
+	/* outer NL80211_ATTR_SMD_CTX nest */
+	n += nla_total_size(0); /* nest header */
+
+	/* DL nest */
+	n += nla_total_size(0); /* DL nest header */
+
+	n += nla_total_size(sizeof(u8)); /* valid_tid_bitmap */
+
+	if (ctx->dl_sn_valid) {
+		n += nla_total_size(0); /* DL SN nest header */
+		n += n_dl_tids * nla_total_size(sizeof(u16)); /* DL SN */
+		if (ctx->mgmt_tid_valid)
+			n += nla_total_size(sizeof(u16)); /* DL mgmt_sn */
+	}
+
+	if (ctx->pn_valid)
+		n += nla_total_size(pn_len); /* DL PN */
+
+	if (ctx->ba_params_valid)
+		n += _nl80211_smd_ctx_nl_ba_param_size(n_dl_tids, true); /* DL BA */
+
+	/* UL nest */
+	n += nla_total_size(0); /* UL nest header */
+
+	n += nla_total_size(sizeof(u8)); /* valid_tid_bitmap */
+
+	if (ctx->ul_sn_valid) {
+		n += nla_total_size(0); /* UL SN nest header */
+		n += n_ul_tids * nla_total_size(sizeof(u16)); /* UL SN */
+		if (ctx->mgmt_tid_valid)
+			n += nla_total_size(sizeof(u16)); /* UL mgmt_sn */
+	}
+
+	if (ctx->pn_valid) {
+		n += nla_total_size(0); /* UL PN nest header */
+		n += n_ul_tids * nla_total_size(pn_len); /* UL PN */
+		if (ctx->mgmt_tid_valid)
+			n += nla_total_size(pn_len); /* UL mgmt_pn */
+	}
+
+	if (ctx->ba_params_valid)
+		n += _nl80211_smd_ctx_nl_ba_param_size(n_ul_tids, false); /* UL BA */
+
+	return n;
+}
+
+static int
+nl80211_put_smd_ctx_ba_params(struct sk_buff *msg,
+			      const unsigned long *tid_bmap,
+			      const struct ieee80211_smd_ctx_ba *ba_tids,
+			      bool dl)
+{
+	u32 ba_params_attr = NL80211_SMD_CTX_DL_ATTR_BA_PARAMS;
+	struct nlattr *dl_ul_ba = NULL, *tid_ba = NULL;
+	u8 tid;
+
+	if (!dl)
+		ba_params_attr = NL80211_SMD_CTX_UL_ATTR_BA_PARAMS;
+
+	dl_ul_ba = nla_nest_start(msg, ba_params_attr);
+	if (!dl_ul_ba)
+		return -ENOBUFS;
+
+	for_each_set_bit(tid, tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS) {
+		const struct ieee80211_smd_ctx_ba *ba = &ba_tids[tid];
+
+		tid_ba = nla_nest_start(msg, tid + 1);
+		if (!tid_ba)
+			goto nla_fail;
+
+		if (nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE,
+				ba->buffer_size) ||
+		    nla_put_u8(msg, NL80211_SMD_CTX_BA_ATTR_POLICY,
+			       ba->ba_policy) ||
+		    (ba->amsdu_supported &&
+		     nla_put_flag(msg,
+				  NL80211_SMD_CTX_BA_ATTR_AMSDU_SUPPORT)) ||
+		    nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_TIMEOUT,
+				ba->timeout) ||
+		    (ba->ext_no_frag &&
+		     nla_put_flag(msg, NL80211_SMD_CTX_BA_ATTR_EXT_NO_FRAG)) ||
+		    nla_put_u8(msg, NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL,
+			       ba->extfrag_level) ||
+		    nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE,
+				ba->ext_buffer_size) ||
+		    (dl && nla_put_u16(msg, NL80211_SMD_CTX_BA_ATTR_WINSTARTO,
+				       ba->winstarto))) {
+			nla_nest_cancel(msg, tid_ba);
+			goto nla_fail;
+		}
+
+		nla_nest_end(msg, tid_ba);
+	}
+
+	nla_nest_end(msg, dl_ul_ba);
+	return 0;
+
+nla_fail:
+	nla_nest_cancel(msg, dl_ul_ba);
+	return -ENOBUFS;
+}
+
+static int nl80211_put_smd_ctx(struct sk_buff *msg,
+			       struct cfg80211_smd_transition_info *st_info)
+{
+	struct nlattr *dl_sn = NULL, *ul_sn = NULL, *ul_pn = NULL;
+	struct nlattr *smd_ctx = NULL, *dl = NULL, *ul = NULL;
+	const struct ieee80211_smd_ctx *ctx;
+	unsigned long dl_tid_bmap = 0, ul_tid_bmap = 0;
+	bool pn_valid;
+	u8 tid;
+
+	/* ST Type */
+	if (nla_put_u8(msg, NL80211_ATTR_SMD_CTX_TYPE, st_info->type))
+		return -ENOBUFS;
+
+	smd_ctx = nla_nest_start(msg, NL80211_ATTR_SMD_CTX);
+	if (!smd_ctx)
+		return -ENOBUFS;
+
+	ctx = st_info->ctx;
+
+	/* Build DL context */
+	dl_tid_bmap = ctx->dl.valid_tid_bmap;
+
+	dl = nla_nest_start(msg, NL80211_SMD_CTX_ATTR_DL);
+	if (!dl)
+		goto nla_fail;
+
+	if (nla_put_u8(msg, NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP,
+		       ctx->dl.valid_tid_bmap))
+		goto nla_fail_dl;
+
+	if (ctx->dl_sn_valid) {
+		dl_sn = nla_nest_start(msg, NL80211_SMD_CTX_DL_ATTR_SN);
+		if (!dl_sn)
+			goto nla_fail_dl;
+
+		for_each_set_bit(tid, &dl_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put_u16(msg, tid + 1, ctx->dl.sn[tid])) {
+				nla_nest_cancel(msg, dl_sn);
+				goto nla_fail_dl;
+			}
+		}
+		nla_nest_end(msg, dl_sn);
+	}
+
+	pn_valid = (ctx->pn_len && ctx->pn_len <= IEEE80211_SMD_CTX_MAX_PN_LEN &&
+		    ctx->pn_valid);
+
+	if (pn_valid &&
+	    nla_put(msg, NL80211_SMD_CTX_DL_ATTR_PN, ctx->pn_len, ctx->dl.pn))
+		goto nla_fail_dl;
+
+	if (ctx->ba_params_valid &&
+	    nl80211_put_smd_ctx_ba_params(msg, &dl_tid_bmap,
+					  ctx->dl.ba, true))
+		goto nla_fail_dl;
+
+	if (ctx->dl_sn_valid && ctx->mgmt_tid_valid &&
+	    nla_put_u16(msg, NL80211_SMD_CTX_DL_ATTR_MGMT_SN, ctx->dl.mgmt_sn))
+		goto nla_fail_dl;
+
+	nla_nest_end(msg, dl);
+
+	/* Build UL context */
+	ul_tid_bmap = ctx->ul.valid_tid_bmap;
+
+	ul = nla_nest_start(msg, NL80211_SMD_CTX_ATTR_UL);
+	if (!ul)
+		goto nla_fail;
+
+	if (nla_put_u8(msg, NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP,
+		       ctx->ul.valid_tid_bmap))
+		goto nla_fail_ul;
+
+	if (ctx->ul_sn_valid) {
+		ul_sn = nla_nest_start(msg, NL80211_SMD_CTX_UL_ATTR_SN);
+		if (!ul_sn)
+			goto nla_fail_ul;
+
+		for_each_set_bit(tid, &ul_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put_u16(msg, tid + 1, ctx->ul.sn[tid])) {
+				nla_nest_cancel(msg, ul_sn);
+				goto nla_fail_ul;
+			}
+		}
+		nla_nest_end(msg, ul_sn);
+	}
+
+	if (pn_valid) {
+		ul_pn = nla_nest_start(msg, NL80211_SMD_CTX_UL_ATTR_PN);
+		if (!ul_pn)
+			goto nla_fail_ul;
+
+		for_each_set_bit(tid, &ul_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put(msg, tid + 1, ctx->pn_len,
+				    ctx->ul.pn[tid])) {
+				nla_nest_cancel(msg, ul_pn);
+				goto nla_fail_ul;
+			}
+		}
+		nla_nest_end(msg, ul_pn);
+	}
+
+	if (ctx->ba_params_valid &&
+	    nl80211_put_smd_ctx_ba_params(msg, &ul_tid_bmap,
+					  ctx->ul.ba, false))
+		goto nla_fail_ul;
+
+	if (ctx->mgmt_tid_valid) {
+		if (ctx->ul_sn_valid &&
+		    nla_put_u16(msg, NL80211_SMD_CTX_UL_ATTR_MGMT_SN,
+				ctx->ul.mgmt_sn))
+			goto nla_fail_ul;
+
+		if (pn_valid &&
+		    nla_put(msg, NL80211_SMD_CTX_UL_ATTR_MGMT_PN,
+			    ctx->pn_len, ctx->ul.mgmt_pn))
+			goto nla_fail_ul;
+	}
+
+	nla_nest_end(msg, ul);
+
+	nla_nest_end(msg, smd_ctx);
+
+	return 0;
+
+nla_fail_ul:
+	nla_nest_cancel(msg, ul);
+
+nla_fail_dl:
+	nla_nest_cancel(msg, dl);
+
+nla_fail:
+	nla_nest_cancel(msg, smd_ctx);
+	return -EINVAL;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -22872,10 +23148,14 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct cfg80211_rx_info *info, gfp_t gfp)
 {
 	struct net_device *netdev = wdev->netdev;
+	int st_roaming_data_len = 0;
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(100 + info->len, gfp);
+	if (info->st_info.ctx)
+		st_roaming_data_len = nl80211_smd_ctx_nl_size(&info->st_info);
+
+	msg = nlmsg_new(100 + info->len + st_roaming_data_len, gfp);
 	if (!msg)
 		return -ENOMEM;
 
@@ -22911,6 +23191,10 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	     nla_put_flag(msg, NL80211_ATTR_FRAME_NO_STA)))
 		goto nla_put_failure;
 
+	if (st_roaming_data_len &&
+	    nl80211_put_smd_ctx(msg, &info->st_info))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);

-- 
2.34.1

