Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4886C3DB32D
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217734; cv=none; b=D+aadLd+OPTT9WJnjx1C97Ie/bIav6JYRcOHzJkcV0JWZMH5OpuOzSUAhjNF81tvd0m8J8RZGGQ1xCfqQvMHBUZYwhxnMtl3JTQE4DmpZ2ClAxGxwTHwZ15kWS7tAxIqpYAz7qBh4ximGeMOF0EbHwQ2bT0CdhKlXg2B/MpT72c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217734; c=relaxed/simple;
	bh=S9kul3CpD6z2OTmJsg8rUPYoFnddpwppURYOv5c/ydc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s03Vb2hPV6rYt/2eqLcKn801FAWUrtG89RlCEwX/zdzwbks5QqH7jgDqFdHY/k2a7MFxcPduD2uswV8bQG3b1JDneOedtXW71RirGfuLhapetazr1Y19iNLd/+dR0HBK3fehYIzJIqImy8PEK8b7IFdcWIuJtKA7FUQaTHV/hdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PBZj56Pz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TRlHs+JK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PBZj56Pz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TRlHs+JK"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2KA6N853987
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DcBFuRXort4XfTSgyIjJzIB8N6Jbd//5Kj0AfROrZqk=; b=PBZj56Pzgilr8UVY
	Q90wtoYWf2E/bpn63V8343olVaQGqBLWlzeASJvL5dJPrkb7yJvYgTWrulZwueMC
	LTMDU71T81Qwx3unTEk+KAEsWO3sGa7oJQdx9XhjQPmIbooOKRlsbqJEjj4K0z5C
	6RJdOsrLnWVxVw4hjZI/Vg55fL5hoYGlY4ujHaVxfy420e+99FcGox1iBJVg4beC
	q1+NGdK5dZzLsqoPrZ3J51qNlfRCL7ue9LftRz0+S+fiQXTUEeWxSsgp1xqInRwn
	2gX/cSsAJkKalTwUmQmiEBhEFIlJovPPpY9GROvq9ddu/fPfME8FqnC+9GBNNyWV
	sAEoRw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvhsb28yd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:42:10 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-331b2ec616fso745912eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217730; x=1790822530; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DcBFuRXort4XfTSgyIjJzIB8N6Jbd//5Kj0AfROrZqk=;
        b=TRlHs+JKoWHd5Lc7zPy3lfCUZvQPIWRfFti8BWO4110dVdoxncWxUK7fg9EBvKcCdD
         zuj7HWf9uhqrc+13lcm3VVLHjGAXp0OrGkRxGBHPcLxu0/rwGRsYbVgabOaKJNeVrHBW
         EIn4shXds6TcklhVMDh7wZe3BnZe22CMIzJ/JouoOp1VDDoKxjlFfms3eyZisuRB9ojD
         vzRDRM7/JCpueJugEYOZ2oZubTcKILqMZpAouij7yJliWAYfIZ6UgzDEUh6wOW/4BTYy
         p06Mn10mZL9PQVVn5tpt/H1OvXbb5Vmr/w2086vMhE16NDvaGSAY/aMuMzeWFfOJKgOd
         J7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217730; x=1790822530;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DcBFuRXort4XfTSgyIjJzIB8N6Jbd//5Kj0AfROrZqk=;
        b=JTrWxV/4RNxPC8rY05W5Bg7r92PP6Rl9kRaFbx877rHnZzYTYYOA9yvV8/QK2VZqfL
         +FNOhxXEtoHIC5u8BQwCaAmjnimD6HKeZMcQi/v707qiRT1ogZ8ej9E89iqzjUD31jya
         oGPJNHv5kFW26D7kO5zCIYsZSudzUR1l3X+ORqAEw+Rvs0dRZF8QWwSRzq5icOmYPonH
         mWLf/0o4SwNYmJRcCq4lDv1hBtG4OEFjBWpOyV5IkIeyrjDasY7RbN0WEmi8oKIhSOSg
         7kBTjrp4BZi+2qxRNKia9mF3WjdfExq6RrNRMZmNEBJ+eNSRJ0JVf09vTnStauncQfqA
         kaaQ==
X-Gm-Message-State: AFuF++lKA1j+xaNQKWVt4WRfJyCXatZtm90lfm2u7byaE+sPGQzdzlH5
	xpHWhMYOxPk+GWBTXKNUCJHqFoG3HtJvRpTiOhTof5icJueE4kEHXVaT6BDiCN5eln/WxwybQqY
	3jDANeVvVmvvi1QRs9WzF/Ch678Wp+N3+HVcvSsRgP6/fgLQI3oXUciBeptd1lSRNc3wrduSf7n
	/s
X-Gm-Gg: AYBFou1TnbrXuyeBT6T5Rp5QzZCzbZRcDFf/6fWg98FnfSmYo73XqhJZs6t8QGXeDrO
	Sa2B2heIOiK4uCaXVLZor8ruAPt8jzU0MvZ0IQVyKg4ucwaVIu64dWYQsQvFNoOIUFXSHr0BYX+
	EaKJyif0XwCtf/8zj6stfwTXwBB/nIsnxPb5Give91xex4DawtZZz2412fnVwN5AXy9CmmRdAwU
	ntNVzumZuhzpLNuK8Fb+0gQhcKtxUpmA9rVcjptLzrPPuilR7ppbr7JyTypteLhax28MwqVnIeg
	xWaFsSEmhJ9FwHtD2SrRHkJauVeUZECetUMNCy0fzYKlzKTBYY6CXXVrmcMklnlkji01TkX3eRW
	Ig63B31N3LlXk5W4YxsrSSRugcIu1bMceeqYgUx50DGD+BhGV2Q9v0tErox+n4ExJ19YLJcrh8e
	LJGCaHtKA7cQxvxC0aK0g8Rg==
X-Received: by 2002:a05:7300:f588:b0:33b:ae91:1e62 with SMTP id 5a478bee46e88-3400459996bmr704698eec.41.1790217729709;
        Wed, 23 Sep 2026 19:42:09 -0700 (PDT)
X-Received: by 2002:a05:7300:f588:b0:33b:ae91:1e62 with SMTP id 5a478bee46e88-3400459996bmr704671eec.41.1790217728896;
        Wed, 23 Sep 2026 19:42:08 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:42:08 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:49 +0530
Subject: [PATCH wireless-next v2 12/16] wifi: nl80211: Pack SMD dynamic
 context along with frame
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-12-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: MYY0D8XW1eaZeZTATcOivmqjXwUQyoTa
X-Proofpoint-ORIG-GUID: MYY0D8XW1eaZeZTATcOivmqjXwUQyoTa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX/t1V0HHLyI1q
 fEUVzXz/9/cqZO6F0slXy3UGvw1JWwikRqjsxs/ZwbokJnyNHLDL+9ZR46DGvFICXf6yP0i8WXO
 jx/sIpedGT0weLxdBc9WnFJK1580o0j/iUPVwcjqgqOBaIEAfD/stKVRKjjXwkP/th7FdXHtjSZ
 7TzEA/XxQUIU9szdKxOur3S1R34auWFGLGMFFee6Gzfpk4PbKtYozbCPPIg2dLmowvxHaH3wxxy
 qqg93a2k9wrzEuL6QUURSkQdTMGs6pOzKIrPgjsqpACIgCUd0a9w2RLifP0Gwnj0F+E5SfW3tNF
 eGgEhDHq6IbSAIfwcNRO/RaLuRaiuuUD4IyTOLbQbljeQnMUcwvFEJ74QYQ5e6lP+NUYFE0ASaq
 JbJgLffFDJmL7pwajGV6dHkDwP6Z0zpUcLsOfvbdoJOdXUGpdfCv78yIgXQ4L8J2dWTYrtzr1DV
 T49PMEWx6h7KbpZTBhQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXwtsPFk+YIXju
 lS96RF/yEcONfTvwqEQBh59toro6LFnWAUfW/QvqI6aFawNbVwYRz0fzTBBcOwoU6bS/JPdLSOh
 NoDalWZyWKtZ4mYqG3g3QHKhd/h+wUU=
X-Authority-Analysis: v=2.4 cv=f7vdl+yM c=1 sm=1 tr=0 ts=6ab48e02 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Yp_7Wk0lyRs0mq3gzKQA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

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
 net/wireless/nl80211.c | 274 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 273 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3940e349f270..5dc9d654d6f6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19578,6 +19578,270 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_epcs(rdev, dev, val);
 }
 
+static size_t _nl80211_smd_ctx_nl_ba_param_size(u8 n_tids)
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
+	n_dl_tids = bitmap_weight(ctx->dl.valid_tid_bmap,
+				  IEEE80211_SMD_CTX_NUM_TIDS);
+	n_ul_tids = bitmap_weight(ctx->ul.valid_tid_bmap,
+				  IEEE80211_SMD_CTX_NUM_TIDS);
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
+	if (test_bit(IEEE80211_SMD_CTX_VALID_DL_SN, ctx->valid_ctx_bmap)) {
+		n += nla_total_size(0); /* DL SN nest header */
+		n += n_dl_tids * nla_total_size(sizeof(u16)); /* DL SN */
+	}
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_PN, ctx->valid_ctx_bmap))
+		n += nla_total_size(pn_len); /* DL PN */
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_BA_PARAMS, ctx->valid_ctx_bmap))
+		n += _nl80211_smd_ctx_nl_ba_param_size(n_dl_tids); /* DL BA */
+
+	/* UL nest */
+	n += nla_total_size(0); /* UL nest header */
+
+	n += nla_total_size(sizeof(u8)); /* valid_tid_bitmap */
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_UL_SN, ctx->valid_ctx_bmap)) {
+		n += nla_total_size(0); /* UL SN nest header */
+		n += n_ul_tids * nla_total_size(sizeof(u16)); /* UL SN */
+	}
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_PN, ctx->valid_ctx_bmap)) {
+		n += nla_total_size(0); /* UL PN nest header */
+		n += n_ul_tids * nla_total_size(pn_len); /* UL PN */
+	}
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_BA_PARAMS, ctx->valid_ctx_bmap))
+		n += _nl80211_smd_ctx_nl_ba_param_size(n_ul_tids); /* UL BA */
+
+	if (ctx->drv_ctx_size)
+		n += nla_total_size(ctx->drv_ctx_size); /* Driver data */
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
+				ba->ext_buffer_size)) {
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
+	u8 dl_tid_bmap = 0, ul_tid_bmap = 0;
+	bool pn_size_valid;
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
+	dl_tid_bmap = bitmap_read(ctx->dl.valid_tid_bmap, 0,
+				  IEEE80211_SMD_CTX_NUM_TIDS);
+
+	dl = nla_nest_start(msg, NL80211_SMD_CTX_ATTR_DL);
+	if (!dl)
+		goto nla_fail;
+
+	if (nla_put_u8(msg, NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP,
+		       dl_tid_bmap))
+		goto nla_fail_dl;
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_DL_SN, ctx->valid_ctx_bmap)) {
+		dl_sn = nla_nest_start(msg, NL80211_SMD_CTX_DL_ATTR_SN);
+		if (!dl_sn)
+			goto nla_fail_dl;
+
+		for_each_set_bit(tid, ctx->dl.valid_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put_u16(msg, tid + 1, ctx->dl.sn[tid])) {
+				nla_nest_cancel(msg, dl_sn);
+				goto nla_fail_dl;
+			}
+		}
+		nla_nest_end(msg, dl_sn);
+	}
+
+	pn_size_valid =
+		ctx->pn_len && ctx->pn_len <= IEEE80211_SMD_CTX_MAX_PN_LEN;
+
+	if (pn_size_valid &&
+	    test_bit(IEEE80211_SMD_CTX_VALID_PN, ctx->valid_ctx_bmap) &&
+	    nla_put(msg, NL80211_SMD_CTX_DL_ATTR_PN, ctx->pn_len, ctx->dl.pn))
+		goto nla_fail_dl;
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_BA_PARAMS, ctx->valid_ctx_bmap) &&
+	    nl80211_put_smd_ctx_ba_params(msg, ctx->dl.valid_tid_bmap,
+					  ctx->dl.ba, true))
+		goto nla_fail_dl;
+
+	nla_nest_end(msg, dl);
+
+	/* Build UL context */
+	ul_tid_bmap = bitmap_read(ctx->ul.valid_tid_bmap, 0,
+				  IEEE80211_SMD_CTX_NUM_TIDS);
+
+	ul = nla_nest_start(msg, NL80211_SMD_CTX_ATTR_UL);
+	if (!ul)
+		goto nla_fail;
+
+	if (nla_put_u8(msg, NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP,
+		       ul_tid_bmap))
+		goto nla_fail_ul;
+
+	if (test_bit(IEEE80211_SMD_CTX_VALID_UL_SN, ctx->valid_ctx_bmap)) {
+		ul_sn = nla_nest_start(msg, NL80211_SMD_CTX_UL_ATTR_SN);
+		if (!ul_sn)
+			goto nla_fail_ul;
+
+		for_each_set_bit(tid, ctx->ul.valid_tid_bmap,
+				 IEEE80211_SMD_CTX_NUM_TIDS) {
+			if (nla_put_u16(msg, tid + 1, ctx->ul.sn[tid])) {
+				nla_nest_cancel(msg, ul_sn);
+				goto nla_fail_ul;
+			}
+		}
+		nla_nest_end(msg, ul_sn);
+	}
+
+	if (pn_size_valid &&
+	    test_bit(IEEE80211_SMD_CTX_VALID_PN, ctx->valid_ctx_bmap)) {
+		ul_pn = nla_nest_start(msg, NL80211_SMD_CTX_UL_ATTR_PN);
+		if (!ul_pn)
+			goto nla_fail_ul;
+
+		for_each_set_bit(tid, ctx->ul.valid_tid_bmap,
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
+	if (test_bit(IEEE80211_SMD_CTX_VALID_BA_PARAMS, ctx->valid_ctx_bmap) &&
+	    nl80211_put_smd_ctx_ba_params(msg, ctx->ul.valid_tid_bmap,
+					  ctx->ul.ba, false))
+		goto nla_fail_ul;
+
+	nla_nest_end(msg, ul);
+
+	/* Driver data blob */
+	if (ctx->drv_ctx_size &&
+	    nla_put(msg, NL80211_SMD_CTX_ATTR_DRV_DATA, ctx->drv_ctx_size,
+		    ctx->drv_ctx))
+		goto nla_fail;
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
@@ -22203,10 +22467,14 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
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
 
@@ -22242,6 +22510,10 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
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

