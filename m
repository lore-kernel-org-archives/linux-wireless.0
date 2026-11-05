Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907642;
	b=EbOFvKf6jSGWUhgOzYigvD2Lzk8M6XbA8xoGdX+o3N0b/Hf4am8baVIBMfaEnQNIp+06
	 Q73HdHApZYfPpkySUPnAS5Q/OWZZHCKNbvlL2ALJ9Ha+Rkc4b8FQ1M2475X59H9/6NFe7
	 qwowLKSEltxEIjSgndMwrmv2LJHD3GlSzam6+YFnHWkgO17b6DF4ssmL0SLg1IVNDFvL/
	 RESirVQlCFR6XpZqhjBrn4rLLXDDW/+vrunUNpjL2ACKOolbPdclHA+8/dxsi9/N61CFE
	 aJbmU4rlZ+LlaqY6SSPDpzeZWQuLUDjOykweTlxGp1QHH/WFVZFCRELQW9egX2j5hCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907642;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=;
	b=QdXn20hEERjfazqcGwiVIKETMjryPn2PopLuSte394nxWGJWjcG6btzzczfBTHa489nv
	 WYsqSFmzYsiGCk1L3AFQ+SmY+kIYsLTpykuMutBXEg1QZ5Huidh1Jgf42UusLObXzVza4
	 KbzxKamdaW4qbjj5g4xE5+wv1Wm1Z7wQ7W3wGkY49/kHzeeHBJIsKjxC0Sby/gikaMXlp
	 jInqsgMnYPzgQJJJVqQaBOqLdQCO8VQsUN6gAkpGiwygZlE5EDhh8hCd7H+YSJ7z/kS+F
	 7D60zWzpJ8Wuc5Iu7wtgxvu7h+/VMGXchDZGE8LmY0yWjW8HcywIYG6DKqpthaoiyZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AZzC9LY5;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="J/FoyQ3V";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE1960741E2
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFE1960741E2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AZzC9LY5;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J/FoyQ3V
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeECv1474588
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=; b=AZzC9LY5QrfBFBIy
	peOBmPXqBX1g3dU4eYON1NS5lLvhLPkv4qPAPGyBFWYwK8q45jLxZ5jCW0uzaYmp
	h5YZqZZ/Vw4aqiOWcJIxzomXaWM8LPkjTbpygEHEMDU2f+CaqpaNkDfWykzKwoV2
	X7sCBASSn67V9QAc5lM2KGkKu58dQ93wwlIY+qsjrtO9i8Ed6N6lzzPpgafybiDb
	wJPGP97h6sX8b1BqxorkqGpZEJ0JuYx88eyYBvvBAvqAUtAtiqZEy4hAhrrIOWa1
	X5/D3w3RXauRJBQ32iAxgA3pk/9SFtpHDoLadCg0g5BondHNeVEJmZ4Qu76AZNqw
	qMF34g==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrmcdbfj6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:40 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36efb506f29so668102eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907640; x=1794512440; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=;
        b=J/FoyQ3Vg3ea4ny4mJe1L3RCV3ve4jdz1CY1vD0JJIfYbwTtuH78S9T2ys9st9ePks
         BuTZTy1wwsWQTdyWCs0Y3rN0z+hBOXFMbbt/rpzlWPMw12Dn00DuL6YrKvSqTzZFEvvt
         bLXwsxwJaqTKUJ7ybRl7VYTbUHfPhFiMEDaqFXdYz2aIDC6Ffb3hPio3bz56L5nDP+97
         1dMhZDaJQkECg7Cffds8GWHPO8PWgWFett97iy3KzgITTbwE8xjQfhSHZJzfYHM/gLlp
         tBkZKLjobLTT10rF8Jj4tpS39f6yYxFDulB2jWlST8/jKjkVFKA3STplQ/PKLdoJyWFf
         Dh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907640; x=1794512440;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=;
        b=EJb757F8JACnaf/6YU4rBtRfCzUfrSOe5DIfSOclKEMoYrh9uOI4MeyxdNiQ5ebkJf
         vo9dTxt2WRgRXfkiWxm1mARkuj5WfpFpvNyqx0tMQDPbmcXpvxEOw5GhfOHMbkYZtwZs
         FoVg9IoVDRNpsoVHXVwVV9zgWqF7MD1xhySbwPYNcIzjZ+mvJBCa21fQ/fYz3lFvsMhh
         RY3XAh6hWXwx/hzvjN08OwBQ4wx9I55eNZLGt+j2bkIE4EOajxrnx0UYJTXmioo6foxu
         HDO0JNxttd/JbNbkdcWEn4SMNY/etVVKDy/nX3aXSvQ1GvkP3dpeiWMl0e3dJXq53ADD
         km3g==
X-Gm-Message-State: APuU4Z+Slqr2TG7fnNvjXWbXWux/A3LEUMNo1c19bVMuecr4RJH+PG+7
	+Qjxod85sf77GDTZhVSpY4w7LVfIfKrFAfSJrq+K99NW6KAw4m26BktZhD9fSk45JtAJl2H9h/C
	4zBDmdIKMTsZEP8i2EWu97/JxUL45/rpz88ZoaRZBLNu3noJznGAwldURp4pqvceiw8ay
X-Gm-Gg: AYBFou2reztsv86j+jVJStyrvMFAjzdYkGWiRHoL/Qk46AJuR0H2Gn97olV92hKd//n
	IES5lzMIWiAExgvKzMenm2fEIpGf7aQ9s+hSyR1mZTVJ05vDR1yb509kA8yt2cg8Oh2uZQsFlbS
	ZBMqFbdag1irGH8/H6xK/5HrzD8jbSr/ioyBVAw9yWHVnGXqTY19Bl/8yJnmSNaAlpRuAWn08M0
	QzAxmMpAq8ZNHciCnUPyqGjXtzGlIUVDTVaNCUVAKgnW/jp2jQMXOnK+l8QF8bhj04Z57RpkSvy
	w8RILv3/ts0lT5sLoizDFdhOUXAdaaff804l157qbjYZ6Q8ckpUX4aBZ68Am/cKl5Wl0jGkzWjl
	zLglJkhoiBsofBTX/6kbi7r0UxLx+3L+qS25QW3cwJWZ1SIPnJW6cZz9400cERad8deHFD3HnmM
	7bsA2yr/zFvvHNargAVIByF6QAhkiryMCI323efjcTu984L952+6Nvt+WxUbJ179pift30ng==
X-Received: by 2002:a05:7301:454c:b0:36a:1bd4:628a with SMTP id 5a478bee46e88-36f75a2b05emr147897eec.9.1793907639583;
        Thu, 05 Nov 2026 11:40:39 -0800 (PST)
X-Received: by 2002:a05:7301:454c:b0:36a:1bd4:628a with SMTP id 5a478bee46e88-36f75a2b05emr147869eec.9.1793907638897;
        Thu, 05 Nov 2026 11:40:38 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:37 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:44 +0530
Subject: [PATCH wireless-next v3 09/21] wifi: nl80211/cfg80211: add support
 for SMD context programming
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
Message-Id: <20261106-smd-v3-9-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=EOGTQFZC c=1 sm=1 tr=0 ts=6aecdbb8 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=ApxeY1PZkYvOm30fjnsA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: bX5ZEetPSpdCt10MekWC7Xb6qR745muF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX49fZDJuiNOYF
 vHCgLcjYoRKxRRofALnMdYk5uuk473A1glOMX1nlKqc7Wp2bw3YbV0g4ypBg5bLjQSACgPMLq4E
 SdHmcpR1w2i2NJEx8WXO6I8Tp47FC24=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX9W5Kl0BjLuMf
 W2rKhuzp0hZ/QjRkICRIAJPPWXLQfst7+e3zWgF2kOxceJclrfXsQZkR+qaip3nqQC9sG2OZSWu
 AETkm1Bl0WVl4DrtPsZaZY9hqxOKB4s/k4+jJcorlXlfuLUSPT1sWXklItjlLn62wSrNDPOnvTu
 FqXOvCe96r9PcmsUZKclfZR6RmDF96tusHxS+ZNaeNs3vkriQa0GuidKGhSoVuioI+jvq/C/C7u
 kkLGeyY7nKpmFEJ/UIdEL1SJnAp9FPDfqEbZjsM/u6zynFyJjsCRkIlAishD70D1bBWZk88PmLE
 jGvd1PWq5R5gM0s6U++D49bDz1OmWr08UcG1mtrJGoJzDzmssqsog0Ra1y4WwBORDiivaBR2Q9y
 wYvK+cXnOthLkMZlzkI2XtQF0TjXmfmk7UcQLMhXYmJDXQsNl/E3Ko5QN1DHRJ+/yryULrGmuNF
 w1mheIlk9KNjRSGEouA==
X-Proofpoint-ORIG-GUID: bX5ZEetPSpdCt10MekWC7Xb6qR745muF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050078

On the target AP MLD to which the STA will be transitioning, the dynamic
context collected and sent by the current AP MLD needs to be programmed
on the TX and RX queues to enable seamless transition and reception.

Such data include Sequence Number (SN), Packet Number (PN), BlockAck
sessions, and any driver-specific data.

Add nl80211 support to handle NL80211_CMD_SET_SMD_CTX, parse the SMD
context attributes, and invoke the cfg80211 operation on the target AP
MLD.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h  |   7 +
 net/wireless/nl80211.c  | 347 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h |  14 ++
 net/wireless/trace.h    |  35 +++++
 4 files changed, 403 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 877845477ce9..42cfdc885c90 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5361,6 +5361,10 @@ struct cfg80211_smd_transition_info {
  *
  * @start_pd: Start the PD interface.
  * @stop_pd: Stop the PD interface.
+ *
+ * @set_smd_ctx: Set UHR SMD context data for the non-AP MLD. @st_info->ctx is
+ *	freed immediately after this call returns; drivers must copy
+ *	@st_info->ctx if asynchronous processing is required.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5759,6 +5763,9 @@ struct cfg80211_ops {
 			    bool val);
 	int	(*start_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
 	void	(*stop_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	int	(*set_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       const u8 *addr,
+			       struct cfg80211_smd_transition_info *st_info);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33e52b8bb5fa..249d7a3c2841 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20413,6 +20413,310 @@ static int nl80211_put_smd_ctx(struct sk_buff *msg,
 	return -EINVAL;
 }
 
+static int
+nl80211_parse_smd_ctx_ba_params(struct nlattr *tb,
+				struct ieee80211_smd_ctx_ba *ba_tids)
+{
+	struct nlattr *ba_tb[NL80211_SMD_CTX_BA_ATTR_MAX + 1];
+	struct ieee80211_smd_ctx_ba *ba;
+	struct nlattr *ba_attr;
+	int n_tids = 0;
+	int rem, tid;
+
+	nla_for_each_nested(ba_attr, tb, rem) {
+		tid = nla_type(ba_attr) - 1;
+		if (tid < 0 || tid >= IEEE80211_SMD_CTX_NUM_TIDS)
+			return -EINVAL;
+
+		if (nla_parse_nested(ba_tb, NL80211_SMD_CTX_BA_ATTR_MAX,
+				     ba_attr, nl80211_smd_ctx_ba_policy,
+				     NULL))
+			return -EINVAL;
+
+		ba = &ba_tids[tid];
+
+		if (ba_tb[NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE])
+			ba->buffer_size =
+				nla_get_u16(ba_tb[NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE]);
+
+		if (ba_tb[NL80211_SMD_CTX_BA_ATTR_POLICY])
+			ba->ba_policy =
+				nla_get_u8(ba_tb[NL80211_SMD_CTX_BA_ATTR_POLICY]);
+
+		ba->amsdu_supported =
+			!!ba_tb[NL80211_SMD_CTX_BA_ATTR_AMSDU_SUPPORT];
+
+		if (ba_tb[NL80211_SMD_CTX_BA_ATTR_TIMEOUT])
+			ba->timeout =
+				nla_get_u16(ba_tb[NL80211_SMD_CTX_BA_ATTR_TIMEOUT]);
+
+		ba->ext_no_frag = !!ba_tb[NL80211_SMD_CTX_BA_ATTR_EXT_NO_FRAG];
+
+		if (ba_tb[NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL])
+			ba->extfrag_level =
+				nla_get_u8(ba_tb[NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL]);
+
+		if (ba_tb[NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE])
+			ba->ext_buffer_size =
+				nla_get_u16(ba_tb[NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE]);
+
+		if (ba_tb[NL80211_SMD_CTX_BA_ATTR_WINSTARTO])
+			ba->winstarto =
+				nla_get_u16(ba_tb[NL80211_SMD_CTX_BA_ATTR_WINSTARTO]);
+
+		n_tids++;
+	}
+
+	if (!n_tids)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int nl80211_parse_smd_ctx(struct genl_info *info,
+				 struct cfg80211_smd_transition_info *st_info)
+{
+	struct nlattr *dl_tb[NL80211_SMD_CTX_DL_ATTR_MAX + 1];
+	struct nlattr *ul_tb[NL80211_SMD_CTX_UL_ATTR_MAX + 1];
+	struct nlattr *tb[NL80211_SMD_CTX_ATTR_MAX + 1];
+	struct ieee80211_smd_ctx *ctx;
+	struct nlattr *bmap_attr;
+
+	st_info->type = nla_get_u8(info->attrs[NL80211_ATTR_SMD_CTX_TYPE]);
+
+	if (nla_parse_nested(tb, NL80211_SMD_CTX_ATTR_MAX,
+			     info->attrs[NL80211_ATTR_SMD_CTX],
+			     nl80211_smd_ctx_policy, NULL)) {
+		GENL_SET_ERR_MSG(info, "failed to parse SMD context");
+		return -EINVAL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	st_info->ctx = ctx;
+
+	/* DL Context */
+	if (tb[NL80211_SMD_CTX_ATTR_DL]) {
+		struct nlattr *ba_attr;
+
+		if (nla_parse_nested(dl_tb, NL80211_SMD_CTX_DL_ATTR_MAX,
+				     tb[NL80211_SMD_CTX_ATTR_DL],
+				     nl80211_smd_ctx_dl_policy, NULL)) {
+			GENL_SET_ERR_MSG(info, "failed to parse DL context");
+			goto err_free_ctx;
+		}
+
+		bmap_attr = dl_tb[NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP];
+		if (bmap_attr)
+			ctx->dl.valid_tid_bmap = nla_get_u8(bmap_attr);
+
+		if (dl_tb[NL80211_SMD_CTX_DL_ATTR_SN]) {
+			struct nlattr *sn_attr;
+			int n_tids = 0;
+			int rem, tid;
+
+			nla_for_each_nested(sn_attr,
+					    dl_tb[NL80211_SMD_CTX_DL_ATTR_SN],
+					    rem) {
+				tid = nla_type(sn_attr) - 1;
+				if (tid < 0 ||
+				    tid >= IEEE80211_SMD_CTX_NUM_TIDS) {
+					GENL_SET_ERR_MSG(info,
+							 "invalid DL SN tid");
+					goto err_free_ctx;
+				}
+
+				if (nla_len(sn_attr) != sizeof(u16)) {
+					GENL_SET_ERR_MSG(info,
+							 "invalid DL SN len");
+					goto err_free_ctx;
+				}
+
+				ctx->dl.sn[tid] = nla_get_u16(sn_attr);
+				n_tids++;
+			}
+
+			if (!n_tids) {
+				GENL_SET_ERR_MSG(info, "empty DL SN nesting");
+				goto err_free_ctx;
+			}
+
+			ctx->dl_sn_valid = 1;
+		}
+
+		if (dl_tb[NL80211_SMD_CTX_DL_ATTR_PN]) {
+			const u8 *pn_data =
+				nla_data(dl_tb[NL80211_SMD_CTX_DL_ATTR_PN]);
+
+			ctx->pn_len =
+				nla_len(dl_tb[NL80211_SMD_CTX_DL_ATTR_PN]);
+			if (ctx->pn_len > IEEE80211_SMD_CTX_MAX_PN_LEN) {
+				GENL_SET_ERR_MSG(info, "invalid DL PN length");
+				goto err_free_ctx;
+			}
+
+			memcpy(ctx->dl.pn, pn_data, ctx->pn_len);
+			ctx->pn_valid = 1;
+		}
+
+		ba_attr = dl_tb[NL80211_SMD_CTX_DL_ATTR_BA_PARAMS];
+		if (ba_attr) {
+			if (nl80211_parse_smd_ctx_ba_params(ba_attr,
+							    ctx->dl.ba)) {
+				GENL_SET_ERR_MSG(info,
+						 "failed to parse DL BlockAck params");
+				goto err_free_ctx;
+			}
+
+			ctx->ba_params_valid = 1;
+		}
+
+		if (dl_tb[NL80211_SMD_CTX_DL_ATTR_MGMT_SN]) {
+			ctx->dl.mgmt_sn =
+				nla_get_u16(dl_tb[NL80211_SMD_CTX_DL_ATTR_MGMT_SN]);
+			ctx->mgmt_tid_valid = 1;
+			ctx->dl_sn_valid = 1;
+		}
+	}
+
+	/* UL Context */
+	if (tb[NL80211_SMD_CTX_ATTR_UL]) {
+		struct nlattr *ba_attr;
+
+		if (nla_parse_nested(ul_tb, NL80211_SMD_CTX_UL_ATTR_MAX,
+				     tb[NL80211_SMD_CTX_ATTR_UL],
+				     nl80211_smd_ctx_ul_policy, NULL)) {
+			GENL_SET_ERR_MSG(info, "failed to parse UL context");
+			goto err_free_ctx;
+		}
+
+		bmap_attr = ul_tb[NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP];
+		if (bmap_attr)
+			ctx->ul.valid_tid_bmap = nla_get_u8(bmap_attr);
+
+		if (ul_tb[NL80211_SMD_CTX_UL_ATTR_SN]) {
+			struct nlattr *sn_attr;
+			int n_tids = 0;
+			int rem, tid;
+
+			nla_for_each_nested(sn_attr,
+					    ul_tb[NL80211_SMD_CTX_UL_ATTR_SN],
+					    rem) {
+				tid = nla_type(sn_attr) - 1;
+				if (tid < 0 ||
+				    tid >= IEEE80211_SMD_CTX_NUM_TIDS) {
+					GENL_SET_ERR_MSG(info,
+							 "invalid UL SN tid");
+					goto err_free_ctx;
+				}
+
+				if (nla_len(sn_attr) != sizeof(u16)) {
+					GENL_SET_ERR_MSG(info,
+							 "invalid UL SN len");
+					goto err_free_ctx;
+				}
+
+				ctx->ul.sn[tid] = nla_get_u16(sn_attr);
+				n_tids++;
+			}
+
+			if (!n_tids) {
+				GENL_SET_ERR_MSG(info, "empty UL SN nesting");
+				goto err_free_ctx;
+			}
+
+			ctx->ul_sn_valid = 1;
+		}
+
+		if (ul_tb[NL80211_SMD_CTX_UL_ATTR_PN]) {
+			struct nlattr *pn_attr;
+			int n_tids = 0;
+			int rem, tid;
+
+			nla_for_each_nested(pn_attr,
+					    ul_tb[NL80211_SMD_CTX_UL_ATTR_PN],
+					    rem) {
+				u8 pn_len;
+
+				tid = nla_type(pn_attr) - 1;
+				if (tid < 0 ||
+				    tid >= IEEE80211_SMD_CTX_NUM_TIDS) {
+					GENL_SET_ERR_MSG(info,
+							 "invalid UL PN tid");
+					goto err_free_ctx;
+				}
+
+				/*
+				 * PN length must be the same for all DL and
+				 * UL TIDs.
+				 */
+				pn_len = nla_len(pn_attr);
+				if (pn_len > IEEE80211_SMD_CTX_MAX_PN_LEN ||
+				    (ctx->pn_len && pn_len != ctx->pn_len)) {
+					GENL_SET_ERR_MSG(info,
+							 "invalid PN length");
+					goto err_free_ctx;
+				}
+				ctx->pn_len = pn_len;
+
+				memcpy(ctx->ul.pn[tid], nla_data(pn_attr),
+				       ctx->pn_len);
+				n_tids++;
+			}
+
+			if (!n_tids) {
+				GENL_SET_ERR_MSG(info, "empty UL PN nesting");
+				goto err_free_ctx;
+			}
+
+			ctx->pn_valid = 1;
+		}
+
+		ba_attr = ul_tb[NL80211_SMD_CTX_UL_ATTR_BA_PARAMS];
+		if (ba_attr) {
+			if (nl80211_parse_smd_ctx_ba_params(ba_attr,
+							    ctx->ul.ba)) {
+				GENL_SET_ERR_MSG(info,
+						 "failed to parse UL BlockAck params");
+				goto err_free_ctx;
+			}
+
+			ctx->ba_params_valid = 1;
+		}
+
+		if (ul_tb[NL80211_SMD_CTX_UL_ATTR_MGMT_SN]) {
+			ctx->ul.mgmt_sn =
+				nla_get_u16(ul_tb[NL80211_SMD_CTX_UL_ATTR_MGMT_SN]);
+			ctx->mgmt_tid_valid = 1;
+			ctx->ul_sn_valid = 1;
+		}
+
+		if (ul_tb[NL80211_SMD_CTX_UL_ATTR_MGMT_PN]) {
+			u8 pn_len = nla_len(ul_tb[NL80211_SMD_CTX_UL_ATTR_MGMT_PN]);
+
+			if (pn_len > IEEE80211_SMD_CTX_MAX_PN_LEN ||
+			    (ctx->pn_len && pn_len != ctx->pn_len)) {
+				GENL_SET_ERR_MSG(info, "invalid UL mgmt PN length");
+				goto err_free_ctx;
+			}
+			memcpy(ctx->ul.mgmt_pn,
+			       nla_data(ul_tb[NL80211_SMD_CTX_UL_ATTR_MGMT_PN]),
+			       pn_len);
+			ctx->mgmt_tid_valid = 1;
+			ctx->pn_valid = 1;
+		}
+	}
+
+	return 0;
+
+err_free_ctx:
+	kfree(ctx);
+	st_info->ctx = NULL;
+	return -EINVAL;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -20845,6 +21149,42 @@ static int nl80211_set_sar_specs(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_set_smd_ctx(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_smd_transition_info st_info = {};
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *addr;
+	int err;
+
+	if (!rdev->ops->set_smd_ctx)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_AP_VLAN)
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR] ||
+	    !info->attrs[NL80211_ATTR_SMD_CTX] ||
+	    !info->attrs[NL80211_ATTR_SMD_CTX_TYPE]) {
+		GENL_SET_ERR_MSG(info, "required attributes are missing");
+		return -EINVAL;
+	}
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+
+	err = nl80211_parse_smd_ctx(info, &st_info);
+	if (err)
+		return err;
+
+	/* drivers must copy @ctx for any deferred processing */
+	err = rdev_set_smd_ctx(rdev, wdev, addr, &st_info);
+
+	kfree(st_info.ctx);
+	return err;
+}
+
 #define SELECTOR(__sel, name, value) \
 	((__sel) == (value)) ? NL80211_IFL_SEL_##name :
 int __missing_selector(void);
@@ -21762,6 +22102,13 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
+	{
+		.cmd = NL80211_CMD_SET_SMD_CTX,
+		.doit = nl80211_set_smd_ctx,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_CLEAR_SKB),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 7b8440c1f697..96a47eccc196 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1713,4 +1713,18 @@ rdev_set_epcs(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_set_smd_ctx(struct cfg80211_registered_device *rdev,
+				   struct wireless_dev *wdev, const u8 *addr,
+				   struct cfg80211_smd_transition_info *st_info)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_set_smd_ctx(&rdev->wiphy, wdev, addr, st_info);
+	if (rdev->ops->set_smd_ctx)
+		ret = rdev->ops->set_smd_ctx(&rdev->wiphy, wdev, addr, st_info);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 31000ffebe43..67db0b032808 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4474,6 +4474,41 @@ TRACE_EVENT(cfg80211_nan_channel_evac,
 	TP_printk(WDEV_PR_FMT ", " WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT,
 		  WDEV_PR_ARG, WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
 );
+
+TRACE_EVENT(rdev_set_smd_ctx,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, const u8 *addr,
+		 struct cfg80211_smd_transition_info *st_info),
+
+	TP_ARGS(wiphy, wdev, addr, st_info),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		MAC_ENTRY(sta_addr)
+		__field(u8, st_type)
+		__field(u8, dl_tid_bitmap)
+		__field(u8, ul_tid_bitmap)
+	),
+
+	TP_fast_assign(
+		struct ieee80211_smd_ctx *ctx = st_info->ctx;
+
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(sta_addr, addr);
+		__entry->st_type = st_info->type;
+		__entry->dl_tid_bitmap = ctx->dl.valid_tid_bmap;
+		__entry->ul_tid_bitmap = ctx->ul.valid_tid_bmap;
+	),
+
+	TP_printk(WIPHY_PR_FMT  ", " WDEV_PR_FMT
+		  ", sta=%pM, ST type=%u DL TIDs: 0x%x, UL TIDs: 0x%x",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->sta_addr,
+		  __entry->st_type,
+		  __entry->dl_tid_bitmap, __entry->ul_tid_bitmap
+	)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

