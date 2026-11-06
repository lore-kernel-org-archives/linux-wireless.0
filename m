Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951989;
	b=oPoLIG55rGQcDm97QB2T4JqgI8IhspeYYMRVsfa1+cyOej6QI1pQFZtU7SxjOQL8Gxi8
	 o01jc/3E5UygdsdlCfW/cw6oWHnIPFk7uhjyLhWUI35j4dnql9fzggpaCXur/yRPx8lqK
	 bI8iGbhPb0abVxg3LqTRXKG4kZkWDFR9mnKMA4k8XpKXUcn5uQa7Gq0Uahgds26/BLnn/
	 pCDW7uVJQWhTdwkjNL6W4fBX7pTnqoBuk9xQ1mcslb1agrWEgKjx2j6dk6FH6Z/H9N4Pb
	 laQxT2adx/2/9U8a9/RKGYjDtcqOuFzQDgUgoZy50hgLAQvJCmLzr7uPqIiCEJd+NSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951989;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=;
	b=CKrI13834kFybrjlXsspopwZkX7uiK+gfHxnviKi5h6LnsmGywt+vLg5jWtun/FaRtox
	 FBpqa79Xt+0hGGSyfYNygEqXAbahdtJ4GJa61U0dY89Ci0g+ux3KoZVCNdJWjB6YVtNrc
	 wiLTIRvPDrMlkM/trCjNAI6V2c27amd1K0uM+w4mlQvOozjpsrzQk+SquourSFst2clvU
	 Rfv1DElQEbnEOAbaNI/KdbTDza7PiD0kDMHV/VQXgogCioy+MOVzJ/nPzNrPcBTOAuTSU
	 XvKmS036bhYSpZb17BtEiR+2rCpHEzFasPn46apfNMy/cU5WiFDraKvMjU9wo5CsKnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZNwiGOkl;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GRD10323;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E06606D812
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18E06606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZNwiGOkl;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GRD10323
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RkPA3883412
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=; b=ZNwiGOklrTzASKnV
	iIV3HE5Of6DaaBdCIImvywNT9MIi5xuboOv41+VMXWQzoJoLEG/25FAxSVr0RXPM
	h6nvn2QtSfG7Wp25Xiu+4iq/R/NFctkPvRMkvrZylVILmmOtaQdMQqnY+Riu9Y7b
	F8rsWWqvqI6CW50H36BrySRMIvHUBfn/OUrjTuNNxKnFWWyNpmHeQBQIEfjnj24d
	NQ4svSOnF70tX2VgDM8xTrXNUIsW9rMdr6nBEmA3psGNXjGkkB/omAwlRJuIroQ4
	hHMsdE3HEksNutwLrFg81OCVag8XqrzCSO2k8j1JoKoKZ2cn3LlV+crtg3pus8gJ
	turG6Q==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pb1qwy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:47 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3abb4c24125so365909a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951987; x=1794556787; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=;
        b=GRD10323cqC/1krVqO7KuJ2KpCnRqMePthqJuCsvQChvaiTK/dQczLOnVd/hip5Ukf
         eSjhziRvDEdTP+NKKTN80nsBAp+205h+Bzf7cLQlfStxEgPIqSDN12xVIpxgx9pcL13A
         n2KRpkGtG3L3yVevfF5C7+ccmywJwWq2jaggetNjDX785LsK1H3YT6GBsSeDNG390GYg
         VtO2/52FPj7PtTfj25e95r4UqElEtdF43gKDViDgGFjzjxR8ist/odOm4l0svu+X25VW
         rivr0Y5tkZQ11lOoU/Mzz8FA1tvZp+g1Dtjp6BWeSgFaH02LVV2khKMjjHjswEzzl1H9
         nmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951987; x=1794556787;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1r1AVJhgDJg+QBqAeb8bg/Bx8SLnDuk7rGMaEsXzLw=;
        b=wOY8W74vGiiE1eGxceO11iX67/aXgo0LEI8+9QXbfHIx8Y7k2adKcVI+t2cDJOROR4
         ANdVjEoZ+LkWN0F2+K1V0gVmozoj1XjP9oM3KoJfMS/M0wnlzIcXr6HaEI9pSVjI0Pgy
         P2+OJ3WD9a1ywdx8sI/x0BF1eVqB+9dedp61bDcg93u9b0s0kARc3st3G9pkZekdMh0F
         hZ5mk+TOfKYUUN+1a8VOBCGYId8CSROoF7B236YAmuUAoihFCmNiwWsF+5RGEOGsMEDf
         fWjIuyf8X0IGDGdGEmAmPdolMQ/ixyBGDcTpcFoEyA/KSOFRVK52ZOV06Jpw4/0thCTg
         S0TA==
X-Gm-Message-State: APuU4Z/Ujugn4rVEmvLPx7E9mDXPwWEhOlf8UeBaTE0kJSy1AgOjQrgN
	BRBlA9cpe7n2yHLA5z6ZgZ0L9qDs0GqNp/7lzTi9hbU12nbnXRBn1fVnmwC8lYiAGFeKViJbVye
	AqWpWXTHFlCXMTBlcZ1c/EG5XGTUC2oc7/tis+x/tRhzb4doJliBpEOp9qXwQCviWtcbM
X-Gm-Gg: AYBFou3bdoad9LgVHCoR4vCvvGyH+FDbYd3V7uj4SNDCKXaE15BWzvzX6mOP+sl6uJy
	hDnEUj/CoAF6tWxoT23bM7dgIuUQiMrBPf78Ql6mN/rVyd+MbDhrPClfWEQMZq/TaVGyUgRfTUJ
	qNvKgs1ZDNzoVDt6ltvPyoT3+BQ9b0UjjtanLUJq8CIKJRjCGxPK/wHWHQOD++Z2A7gTVzkTcqF
	yp7DGD0smJndxvdor5q3mKOvYv2Morpp/aXFpLNFdY/suP0sMAydA3iM0UKPnjt16z2xjD9suvS
	ZscLoIhr41GXq1d4N2yYC0bUUeASIf6OQQk5lwzfooABqSEU1edb8NPBA/XUBHj4Vyql7XGSGkq
	QbVhXDJ86b0HbEobn18pbUqeJk+OtgO2gm2iMaOiwl3XNJyqVWTpONf3/X62eBjKYyL2lDlWQgv
	hfh+rqXkZjZgFxRciToL5uFb9IkOHykZ5JdeiCbL3SFliEk5wiK1+BorCaaI5md2HQOWIC0QA=
X-Received: by 2002:a17:90b:58e3:b0:3ac:6fcf:81a2 with SMTP id 98e67ed59e1d1-3b0db727640mr1667892a91.57.1793951986707;
        Thu, 05 Nov 2026 23:59:46 -0800 (PST)
X-Received: by 2002:a17:90b:58e3:b0:3ac:6fcf:81a2 with SMTP id 98e67ed59e1d1-3b0db727640mr1667872a91.57.1793951986192;
        Thu, 05 Nov 2026 23:59:46 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:45 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:46 +0530
Subject: [PATCH wireless-next v4 09/21] wifi: nl80211/cfg80211: add support
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
Message-Id: <20261106-smd-v4-9-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: iGS4mgzXSMzeQfnUS7qxD1LADCAuN9tY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX6zyTi4yqwyVi
 am/Ge6I0HIYKGAd+uZQzT4/XJgh/ty0yxkICTfkYLc7XphzmmxxL77NgmoKo+ivl8CvXdw2dDG0
 Wner2YuUFwVCdeBuZ4wTCxu2ZIAovz8=
X-Authority-Analysis: v=2.4 cv=LIrz05W9 c=1 sm=1 tr=0 ts=6aed88f3 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=ApxeY1PZkYvOm30fjnsA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: iGS4mgzXSMzeQfnUS7qxD1LADCAuN9tY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXzdKjbLOJCh79
 RXbJvd2G0evqay6dtqRk/Y/jXYQwpE7ZcXli6MVKyXyJIstTxxmGZUU06cdls2pOngarJqj2Y9h
 /R7LHy+qGNw7afZkDcWA3j4eRWEpkwzpXZ4OSyn+afxVXd+sgyFTrhxWhafVljKwpVD/KdplGWN
 wD/cBZggP/wfuIqbnY9R5EtRyFPY1WNRQzNKFTr06U6rSIyWuJr3CPcb1nTK/yzccUgmEe1AdC1
 qcq0wWk6xNFOXt7WbDMYzSo/xTKXHZX3S0/TxvjTtVEP8ewEbWE3d5KBwo3Eh25Oql79tx0RKzU
 0tU5LA0QqTzWMJawVQkTWGBSn+/Egv49wj7bZJ7YDQxfkEUIAbuJsTbYD/AVZrIBg1sNtArDBbU
 Iz1s5A8N/wygWudelvenDUj2M+2fGKUaDo7l6S0LjF2wpIjF9ZHTEC7kw+om+2T3ktEfeDRZ1Ls
 PGjPMGEAftLWHHyt3gg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060031

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

