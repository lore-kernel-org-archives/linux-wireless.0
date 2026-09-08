Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B7C59B68F
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887466; cv=none; b=VoHTWMSb8aK9mF34oWYB/owahqoUDy4tdT9y2SR4Sa5DuceYlNef5anIawRimD4h06EQC0utFuQjGZr2xEnCjq1aQLoZk7tRjLvQImQVlE9NtjurZ9PRZ3dlIYV70yRJaKBhReY2QZR+iXNOCeJVcsGIzgbD1UPEjsXylIxtTys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887466; c=relaxed/simple;
	bh=9GUJmm0JnYOjtca2tQcxf9Y4BE+SaF+P3iTowK/ZOVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJ4oTc+x4z1n/TajALBqKzqB7DBAt7sPZAqjq+IiaJ3/EVZwrK6l+9LxQJbOkCbxgHshf2bfz9u2NZ1Zj/1SosJFK+aYPDKtVaxZF3Vyj9s+7G/VoBqn4yq0JEnlPWGTBz9TAB/Dm0S1Qk1MNxQ8sZIlvDl+UEM2JQ2e+hPKDzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Hd51RSQ5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z1MJAX2/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Hd51RSQ5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z1MJAX2/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdhdQ2899746
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wVk15Adnij0xzN+GSJBRJZvYMNQ2RQbb8lQpb3qcGW8=; b=Hd51RSQ5ya6jaTND
	x3ROzanRiWP31EzHx9gi4OKxr6j+xQmGYhkmLTp4QhkNW0s4XAt82C1xtut1oZO+
	liA9dNDoGpUWhOyANZvk8i3rtzbkWYsZgm1RyzteP95GQN949+oHk7CMguvEHr01
	cSEQ/j79iN3NF+TRmzWd7qYvaIMDnbVccOVUaJPJ00naWCiSECAEXGigF/uROgYZ
	wUh1QbHwrzD9E66NzzQiMc5fmN/lzk1Q4WuIzACABzKz8zsxc8kJQINmGpFkJxp2
	kSlUxWmjbqfTWe8KnBbBPueGRO8YHrMa6NJrrmEbhVS/MDFgbNrcU1HymQCDgQcN
	sj8VeQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjcvujvfx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:11:03 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-848568a6f62so5045554b3a.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887463; x=1789492263; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wVk15Adnij0xzN+GSJBRJZvYMNQ2RQbb8lQpb3qcGW8=;
        b=Z1MJAX2/j0JEr6o3iB48e325gjXtz5/7x0zanbcp/PrvWvrEw9XiHOK7DlOWKLG72m
         p8uPiaHs72acR0uVI0dHsWriz95C1vMCBdD620yqLCHHySNjkIa2fjzxyUdrp1kmmDbG
         odHYPlFr9p6mmeKQrfNjZGRSIZjh+l2QrCSaeJ5qnKNAzu9sjPgrmFvR9N3QmefktgkY
         mHwomI+hE1G2aYV+zpWoYNIVPifujP221yKLpL5/f5qvDN82S9pPmv5C7gF7U3DNBxNF
         DXIyRI8d8pfJ1TV7nBIBkQ+itCeHLh4A+aZ0a60kRGhvIn++jfK08wj145ORXa+h9c4G
         nQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887463; x=1789492263;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wVk15Adnij0xzN+GSJBRJZvYMNQ2RQbb8lQpb3qcGW8=;
        b=K71WNBfx228wUhR/QOsdPt5/ZCB6b4lkUUi3vZrgG8CTYUuAPffQVI64xsm6d78aOy
         5CMuS6bLznlr/py47rZKOrSDS+0fYiqmZmAephB0L/LVxT4uojCrs+ipRqFPz1SpKdAF
         g1ttBVqINJr3U5XkiPH/MUCyZnHuEkbUpbkzbMfZ9eHjHRcUsKkGKu6WrhtoPBTM++sc
         g0Q6Q0USY5pGwny4vkBE0NoqCJne7MxL/HIwc5uZOKV5J2yJHVJV00UG3EAs0kJjJums
         lAUBAFiuD70Tmt4EK+4SSS1F7aRU9/0hC6GH2xC+Y1BMin5GhJUo4z1iQiPfp/P2pZIA
         uw8Q==
X-Forwarded-Encrypted: i=1; AKwUvByhXn9bxOzM/RWj5CBAuMzrWjbBBZCyERhe+gf+y2UpaUCcrcRT2DUmjjfH5aoRTQFQM79HZcQvqhA7wihk8g==@vger.kernel.org
X-Gm-Message-State: AFuF++npENBJPlb3xJwFsMoGhfu+vs1UnVAuqs1OQfb098poT+BXUvXf
	lDkMF5+zptqtaazF7gKJ/uNCl72Ufhh5ydfeW5GgpsZH5z1dzuZlm4BvXk2aoRFYTe5sb8/seyy
	lzJB1gm2ptHlBWykmqFiNwuNcDuocKrHgxeiI7KUNHzIdXAPBCjBaPg+Q/YUDwI/wYSDG
X-Gm-Gg: AYBFou2njPPYbGyDv4VdOWRcYgUj8EKWrU6erN20oIyCVT/uPxfYuKh0hzJegE5/INW
	j8qLuf5uMkEDiWVlqR4pZvYxpRErjnuPdNEbMvld1EZSLEDblcyOhZ8IISHCb/177nV+YjXr9cF
	xOZvK6aud+VW1yDxqXDThVnECkXNAjbFSt5PMjfX99nklsSHDgsQjmm2w7cFng94zBzsdeY26OR
	yVQH+9AfCzAVRFvU92Aa+UiFXlvWDBOOIVbvCeHN9WmX1g1qS8MOyEt21u5JUtLJUHF50jOV6CA
	wtDRAWQ/hCyxoAR308EGUIXvBIpH5IbFwpSu8WzQduVgwrCpsrgA0wSJVwqMcJOj9uOqW2dsj7A
	kj/MSy8MJ0/4pj9CbsNQhRjY8dHkXRvenFDExrpZ3Ai+6i9XPOCnQoAOZoJvHOg8AITAgLpoHjt
	dFJ2iknzV/pvKKqaVL8a1Iiw==
X-Received: by 2002:a05:6a20:9151:b0:3d3:af44:ee12 with SMTP id adf61e73a8af0-3da3a2067e9mr45620748637.27.1788887462816;
        Tue, 08 Sep 2026 10:11:02 -0700 (PDT)
X-Received: by 2002:a05:6a20:9151:b0:3d3:af44:ee12 with SMTP id adf61e73a8af0-3da3a2067e9mr45620700637.27.1788887462352;
        Tue, 08 Sep 2026 10:11:02 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:11:01 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 14/18] wifi: nl80211: Pack SMD dynamic context along with frame
Date: Tue,  8 Sep 2026 22:39:42 +0530
Message-Id: <20260908-smd-v1-14-9fd2d876a1fb@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=ePkjSnp1 c=1 sm=1 tr=0 ts=6aa041a7 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=bhEJrp4yiY6RaB6cu_EA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: 8rl4vKxgmxmkDUm9n14VoOI5DSPtMJX5
X-Proofpoint-ORIG-GUID: 8rl4vKxgmxmkDUm9n14VoOI5DSPtMJX5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfXxhiqzHHOI8Ey
 GWup/8Wpp3McDUiuhmLwiybp92SPGRzEWXBMho1enHV0W75GY3Bem4sx647FF1qSKSO3P8pRJVl
 Hauk0nGG5MtRmpBt5Qb14dEGzjSc97EX8gzkqvoVFhckJ7oLmczcfux5tqjtWWxYfSzSHG1rvfw
 Jcl+VNWYGq8k8l4A0fSch4ZZGrYqwQHOVibk7IubMsr7LnzcshqjXxLb3qDM57tk5tyWoWR8tKn
 V46JBhJZU3kDr9VA++Cf8tCQ92d6efUXM1EpVrlp8bDylPVp6RBK4Kzi8NC23ojDPUCBHCWj8tQ
 oe8a/35XRsBttgNlRpQtu0WcX4RQKx2DZz37HNRyz0nWD+nICB/rVn6TlVz9OSP16P4EEg+BsVV
 n4qOn8LM+4/RFbQuV/n0zCSv0KWG8DVUch3VrgauV/HPYk+1Zomqz/Aht8LiTcK4KkL4kfNKwRc
 PDD2se07S2bnQllr41A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfXwqSEQH9qVWCh
 +YlGeQATlDEUiSe8TWaYYaHrSg1ptCHC2hIXYk9oH+buIR6nSmL1hM4pKQUOJ6cw16/uuIl6Oz+
 oBSyASoxh8oYKc0DkY5FK0XON5XDdVM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

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
 net/wireless/nl80211.c | 269 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 268 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d59f0eb40493..5065dc75b0bc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19568,6 +19568,265 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_epcs(rdev, dev, val);
 }
 
+static size_t _nl80211_smd_ctx_nl_ba_param_size(void)
+{
+	size_t n = 0;
+
+	n += nla_total_size(0); /* ba_params nest header */
+	n += n_dl_tids * (nla_total_size(0) + /* tid nest header */
+			nla_total_size(sizeof(u16)) + /* buff_size */
+			nla_total_size(sizeof(u8)) + /* policy */
+			nla_total_size(0) + /* amsdu_support */
+			nla_total_size(sizeof(u16)) + /* timeout */
+			nla_total_size(0) + /* ext_no_frag */
+			nla_total_size(sizeof(u8)) + /* ext_frag_lvl */
+			nla_total_size(sizeof(u16))); /* ext_buff_size */
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
+		n += _nl80211_smd_ctx_nl_ba_param_size(); /* DL BA params */
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
+		n += _nl80211_smd_ctx_nl_ba_param_size(); /* UL BA params */
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
+	if (test_bit(IEEE80211_SMD_CTX_VALID_PN, ctx->valid_ctx_bmap) &&
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
+	if (ctx->pn_len &&
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
@@ -22193,10 +22452,14 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
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
 
@@ -22230,6 +22493,10 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 						   NL80211_ATTR_PAD)))
 		goto nla_put_failure;
 
+	if (st_roaming_data_len &&
+	    nl80211_put_smd_ctx(msg, &info->st_info))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlportid);

-- 
2.34.1

