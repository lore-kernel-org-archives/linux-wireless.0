Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1B752D2D9
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 20:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813255; cv=none; b=jEiHEx0sQtzjAhvwCcLSYN0z8HmsMGn6Tgjdm2uifVHzpKNCRC77tBlZnVKvV4LLg6avLjTztR60DbfEDevjVCKGA0dIMNJii+Bee023N1xlQ1qCoPCMeinOljAk18SSMaM+BgklXci5KjrDqAn4ibYXyG5l2ixuw4yCiU5Vq7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813255; c=relaxed/simple;
	bh=koNnvwZa0vK3Gfgf+JGtHxqQbGSq5YiRRM9pn+/Ijsc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UQRuGH8kPaAKxytTn6TSbNtlqps5Ef7xNxGz/m5awANegloRQ+HIlCMzvE3Scel/BmnKKzNMnDTfaH11cCylaXTc89HQ3P1lKmml4uw/JqNLm9PO1YO6OXYzmgASPPUuhc3bozOHjSLWCa4XcbNIg0ky04bhCfrzDS5eMFZHxl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZQBU1vH7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZtYsYKCn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZQBU1vH7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZtYsYKCn"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687HWKjv564789
	for <linux-wireless@vger.kernel.org>; Mon, 7 Sep 2026 20:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zLlnTeI0ddtuhwizLW1JQhzy8jPGbUL1WY3U9N/wbPI=; b=ZQBU1vH76LLXvqAU
	jWEyURRpL4e2TKHTy3/+xEF4POIobywOliaEmCA8uLG7ZO+xI8n7RyN8rdDZMkn0
	yFBqdFvILbsRotetnzmKo4o9uPm9oK0UwexW1AGD1IM37VPBhu0TMILkPqd7+u3c
	++iB5bZLzk10+aQ+gmCKOAmpxE/tbJ8DJGDwrQS5XKfL71NuHUTofVITN/dZfiGH
	QvYuhObbJsnF6uFy3vXgYLVE3j3jkKJeTJdsLPbvMD0QrifEar7mG5SzOFy7cZKd
	NvFRCX2b6TNAJx3SCOwthmsiN5KS6OlU8vnxVbvw9FcPBzvXG0pyyMY6EoKP7cAY
	/aV1aw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gj1rrgg00-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 20:34:12 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398e1f7d1a5so334155a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 13:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788813252; x=1789418052; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zLlnTeI0ddtuhwizLW1JQhzy8jPGbUL1WY3U9N/wbPI=;
        b=ZtYsYKCn/KjNXuvlJoxnuL6+ycur0U75hVMIfX9C9Lrd1u8WNICMC+fxCXDQPFP2js
         lH4ELFyIYOuh+u/8XMR2oPOXvOdXOJEIiJUSakGIXgVIIBm+pdl3tZDecWjTLVlU/4gC
         951LkPhFVQyj8oQOHFcl9PkUahxSp2f53iA+JMcori2pWISPDGFLL7gW+tiePZn2LeNm
         esrfVw/zHcUUXCnGNNhGBVrPlboAENGOpFj4TV4CJ5KuMboxpyL7mkRwGKWGKsd0geGo
         8GaAh49CmpSD0XM09mvI+TabcLyCEugs8qBswloooa03FK02CqZq3cuF0Oy8USk4qywe
         Wq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788813252; x=1789418052;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zLlnTeI0ddtuhwizLW1JQhzy8jPGbUL1WY3U9N/wbPI=;
        b=DIOPELizQs/KYy06/OSV1UBAAzPBlfU2WwCPgCrvdPjTiEGNDToI8ilaXM39RUfL9v
         tbCAscMoUqHH95jOJt5s+UbSoN6E3lWt1/2UsQe7p4YF4tVK/H/+nXZPZIsB2crhI+yY
         V2ZxCYYxCXtiXtBIjEb+hqWtb/1+dW677ULitqcNe+vqwhsaQMTheKNb3BiHZArud2V+
         6PxGn9uyPc+E5Ef4R487/tnQaX7W0c71FqVT2rsDmpjrLwylzMOHdYeWIQbr8I+P00Ix
         3S8QUOImDumYBJK/6bIKkPQYV4N0nzsivTlLomJ83s/255zb9tE5rSU1SXbzoJ1nHPnI
         zEFA==
X-Forwarded-Encrypted: i=1; AKwUvByibhhpZ9kwDzBejoEJrmzyRulJB/ef8H12NH7Gbyt1B8qSkIinE+ujhzdQ4iQJLzTCs1RYVGkJWSiIqS8D4A==@vger.kernel.org
X-Gm-Message-State: AFuF++njLumkG/d96YrGalGgS1hV9fUHHY0Ow4SlF2nYDUIrPwOm5xiY
	atsW11ybrCQpkXj+NhZnktfS/ZhmbTPGC4XbxHPgIa5MvHwXM9XSBSotYN/wV2hflQGe8RyTxgw
	zLk5lN6kcPJQZqLaLZVkuJaI0+F0jxw+W0c8GV5xGCIeH6w0N15kZZgisd342EXWVziNM
X-Gm-Gg: AYBFou2nocZvPk6Xdw7P1MBXbKpZJSwYT7DWEU+QUcsY1HPfgchORYf7kPKqPf2wBiq
	ahggJl8Z9OF0FzopsRRkUb+OZmcPIPSjgnW21/e4wLuqModb0T/MmckgCXm3ge63Bw73IctcEZj
	LEoAJlsPS88g2zVorhIgln1qo7Scr4qoLVLC1C19jIC33ofPqmrWQlS5fC6B+XTIwOPL6Rq7qS9
	/AgSZUdbVhm1tv5wZMtqc3xZ09rlrQWCm/F6SxS7akF4Wsppyojy8EDWXET3sV88/u8yzoA55FU
	dVrM2x/u39047DebrE9nKUhbtEK8lFia9kInfBd7GHFjWoZpkPVsm+e4bnSKti+r8adB6hobS3g
	qNW2IuTfy1AAiqU0WSaf+b8hjRz9lrxgIJdXJeu8UtdF7OIYXFGSUxBK+Vv59+u1KfcA1+uJNzv
	pmp4COzR+20BvgjppOascptg==
X-Received: by 2002:a05:6a20:4311:b0:3c3:bbe6:95de with SMTP id adf61e73a8af0-3da39eacfc8mr32184474637.6.1788813251638;
        Mon, 07 Sep 2026 13:34:11 -0700 (PDT)
X-Received: by 2002:a05:6a20:4311:b0:3c3:bbe6:95de with SMTP id adf61e73a8af0-3da39eacfc8mr32184436637.6.1788813251159;
        Mon, 07 Sep 2026 13:34:11 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm47841297eec.16.2026.09.07.13.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:34:10 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Tue, 08 Sep 2026 01:59:24 +0530
Subject: [PATCH wireless-next 15/18] wifi: nl80211/cfg80211: Add support
 for SMD context programming
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-smd-v1-15-65ad4ab30fbd@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX/DR00EwMhOba
 stuGIjlIKKxtaKIsJ+l2HOUYxl7x1Fhtfc9GdLwaf/nRKFy5AwwFUgsvxJJH9j6pl+fARY/3Rwy
 rYPzAmqACgESVCZBoVpYUSJ6no0l60k=
X-Proofpoint-GUID: yIXGTPaMfzJ9dFNhKsYYxBmU_aMLl9C6
X-Authority-Analysis: v=2.4 cv=NsjhtcdJ c=1 sm=1 tr=0 ts=6a9f1fc4 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=4KCYKawKnagZyZotmBEA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNiBTYWx0ZWRfX8dOe2CjRC4Zz
 z05bhOjo/iCtPzjhs8N9vkcRk0KF3vCPgjy9/Ly5vIa+nSq+XOUyynYItRDafsut6IzO1IH6oLN
 M+y36rVGhlEqcpFoX32QomClRTzMz8804qbZxEXiGNUdvknnF/XSLr5QewunmDV78FXS477jt9I
 3ln1xZ7jY7wdMEhOSm1AXl6y2rObQbl498lPCQK8jdQG5NN2mSLu1SL6ize/RZQ7aowZGgzJpQY
 FYlK3DwiDzcAGgEJeCj7WTkNRJMA/wXVP72CSFIQC69aM96+Ay8OR/KU9aEpS9IH2IuIQiaht0R
 Ef00XmGsSxScj/6Ht+QtRmWb04tLR4RFtox9+pZUea10bvvaJLLbDl0GxyKh84sp8Sq7XnEbbKr
 mKX9rT1PfEz6W/7cWyqStoQ44g0DsCMq/Ndi1+tylTvin0+x96WUENvwh9d7emGCcxvUSJPiIqE
 y93ZFZqagPTZtaQa8ww==
X-Proofpoint-ORIG-GUID: yIXGTPaMfzJ9dFNhKsYYxBmU_aMLl9C6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070226

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
 net/wireless/nl80211.c  | 332 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h |  14 ++
 net/wireless/trace.h    |  47 +++++++
 4 files changed, 400 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b0f328fec79..b68f5f6837be 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5329,6 +5329,10 @@ struct cfg80211_smd_transition_info {
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
@@ -5707,6 +5711,9 @@ struct cfg80211_ops {
 			    bool val);
 	int	(*start_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
 	void	(*stop_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	int	(*set_smd_ctx)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       const u8 *addr,
+			       struct cfg80211_smd_transition_info *st_info);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5065dc75b0bc..70b8697e5dac 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19827,6 +19827,293 @@ static int nl80211_put_smd_ctx(struct sk_buff *msg,
 	return -EINVAL;
 }
 
+static int
+nl80211_parse_smd_ctx_ba_params(struct nlattr *tb,
+				struct ieee80211_smd_ctx_ba *ba_tids,
+				unsigned long *valid_ctx_bmap)
+{
+	struct nlattr *ba_tb[NL80211_SMD_CTX_BA_ATTR_MAX + 1];
+	struct ieee80211_smd_ctx_ba *ba;
+	struct nlattr *ba_attr;
+	int n_tids = 0;
+	int rem, tid;
+
+	if (!tb)
+		return 0;
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
+		n_tids++;
+	}
+
+	if (!n_tids)
+		return -EINVAL;
+
+	set_bit(IEEE80211_SMD_CTX_VALID_BA_PARAMS, valid_ctx_bmap);
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
+	size_t drv_ctx_size = 0;
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
+	if (tb[NL80211_SMD_CTX_ATTR_DRV_DATA])
+		drv_ctx_size = nla_len(tb[NL80211_SMD_CTX_ATTR_DRV_DATA]);
+
+	ctx = kzalloc(sizeof(*ctx) + drv_ctx_size, GFP_KERNEL);
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
+			bitmap_write(ctx->dl.valid_tid_bmap,
+				     nla_get_u8(bmap_attr),
+				     0, IEEE80211_SMD_CTX_NUM_TIDS);
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
+			set_bit(IEEE80211_SMD_CTX_VALID_DL_SN,
+				ctx->valid_ctx_bmap);
+		}
+
+		if (dl_tb[NL80211_SMD_CTX_DL_ATTR_PN]) {
+			const u8 *pn_data =
+				nla_data(dl_tb[NL80211_SMD_CTX_DL_ATTR_PN]);
+
+			ctx->pn_len =
+				nla_len(dl_tb[NL80211_SMD_CTX_DL_ATTR_PN]);
+
+			memcpy(ctx->dl.pn, pn_data, ctx->pn_len);
+			set_bit(IEEE80211_SMD_CTX_VALID_PN,
+				ctx->valid_ctx_bmap);
+		}
+
+		ba_attr = dl_tb[NL80211_SMD_CTX_DL_ATTR_BA_PARAMS];
+		if (ba_attr &&
+		    nl80211_parse_smd_ctx_ba_params(ba_attr, ctx->dl.ba,
+						    ctx->valid_ctx_bmap)) {
+			GENL_SET_ERR_MSG(info,
+					 "failed to parse DL BlockAck params");
+			goto err_free_ctx;
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
+			bitmap_write(ctx->ul.valid_tid_bmap,
+				     nla_get_u8(bmap_attr),
+				     0, IEEE80211_SMD_CTX_NUM_TIDS);
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
+			set_bit(IEEE80211_SMD_CTX_VALID_UL_SN,
+				ctx->valid_ctx_bmap);
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
+			set_bit(IEEE80211_SMD_CTX_VALID_PN,
+				ctx->valid_ctx_bmap);
+		}
+
+		ba_attr = ul_tb[NL80211_SMD_CTX_UL_ATTR_BA_PARAMS];
+		if (ba_attr &&
+		    nl80211_parse_smd_ctx_ba_params(ba_attr, ctx->ul.ba,
+						    ctx->valid_ctx_bmap)) {
+			GENL_SET_ERR_MSG(info,
+					 "failed to parse UL BlockAck params");
+			goto err_free_ctx;
+		}
+	}
+
+	/* Driver data */
+	if (tb[NL80211_SMD_CTX_ATTR_DRV_DATA]) {
+		ctx->drv_ctx_size = drv_ctx_size;
+		memcpy(ctx->drv_ctx,
+		       nla_data(tb[NL80211_SMD_CTX_ATTR_DRV_DATA]),
+		       drv_ctx_size);
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
@@ -20168,6 +20455,44 @@ static int nl80211_set_sar_specs(struct sk_buff *skb, struct genl_info *info)
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
+	/*
+	 * Drivers must copy @ctx if processing is deferred after
+	 * returning from this function.
+	 */
+	err = rdev_set_smd_ctx(rdev, wdev, addr, &st_info);
+	kfree(st_info.ctx);
+	return err;
+}
+
 #define SELECTOR(__sel, name, value) \
 	((__sel) == (value)) ? NL80211_IFL_SEL_##name :
 int __missing_selector(void);
@@ -21069,6 +21394,13 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
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
index 46849fe8d0b3..d33a969606d7 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1636,4 +1636,18 @@ rdev_set_epcs(struct cfg80211_registered_device *rdev,
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
index 8c2a91b85c39..6234ceb9ebb1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4405,6 +4405,53 @@ TRACE_EVENT(cfg80211_nan_channel_evac,
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
+		__field(unsigned int, num_tids)
+		__dynamic_array(unsigned long, tx_tid_bitmap,
+				BITS_TO_LONGS(IEEE80211_SMD_CTX_NUM_TIDS))
+		__dynamic_array(unsigned long, rx_tid_bitmap,
+				BITS_TO_LONGS(IEEE80211_SMD_CTX_NUM_TIDS))
+	),
+
+	TP_fast_assign(
+		struct ieee80211_smd_ctx *ctx = st_info->ctx;
+		unsigned long sz;
+
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(sta_addr, addr);
+		__entry->st_type = st_info->type;
+
+		__entry->num_tids = IEEE80211_SMD_CTX_NUM_TIDS;
+		sz = BITS_TO_LONGS(__entry->num_tids) * sizeof(unsigned long);
+
+		memcpy(__get_dynamic_array(tx_tid_bitmap),
+		       ctx->dl.valid_tid_bmap, sz);
+		memcpy(__get_dynamic_array(rx_tid_bitmap),
+		       ctx->ul.valid_tid_bmap, sz);
+	),
+
+	TP_printk(WIPHY_PR_FMT  ", " WDEV_PR_FMT
+		  ", sta=%pM, ST type=%u DL TIDs: %*pb, UL TIDs: %*pb",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->sta_addr,
+		  __entry->st_type,
+		  __entry->num_tids,
+		  (unsigned long *)__get_dynamic_array(tx_tid_bitmap),
+		  __entry->num_tids,
+		  (unsigned long *)__get_dynamic_array(rx_tid_bitmap))
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

