Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224621FF7C5
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043704; cv=none; b=KQ/MN4I8OnAi4FlnDxZbyLp5s5Uiko1WvLOXQ/D68WLMwH3yoce7IFKvLxIt1P99TSXEWjXInRbHs1uE9DC2hEQMgOCym8Kp04VR0yKyz4GQ6OothmAJ+uyf1NAgBPWYJ60cc+WsZhNtP3/A52sESATfDqEDRhko3M7wym3c+4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043704; c=relaxed/simple;
	bh=DwDC6Tgqqt5kBsAozlhwSg0bgZZAblE8jB9FIKhuyL8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ed+qhwtVWUjp4dUeCBk3MXX2vPKRAtBGFYnjCEBRuGf0/k/Hu6xaYdqw1oZy9xJM6BtBdg32+ZdVHcUd5R4eWotVygHGXvc5WXyxv0+d0LM0/+aakTssfl4hQEWWnBG3TFJBW+2m9kx5ACRZAveDk1TkO9XwE+SOVIGY5vU/pi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AgSM/tLI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OBcBVvL6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AgSM/tLI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OBcBVvL6"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EMmVPi500287
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=VZ0z65RxFkA
	IQRQmBBZh6ybS7lS24LaNYQuOQ1nHWFY=; b=AgSM/tLIljPHY/fjEnwXYuFyluC
	cQ9FVmabWSwLf9/hvISjRezZ/hMruAcYPAOL31Pc+SAUyqbYEZUySWB6otGy6eSE
	turEotaF++Ugb4METbeajfmhBg07oi+1n68ZkaDx0u6r3X7id0zVjuVlujVO16Ty
	eM83t6kAe/hTKOLZuwMZ8aad5N9HoBpLSh7BLBLdwHVEVBUVd5QNbq/QM8kC7ybZ
	GH23YiY0eOqPjqddhqDzB9uFO2OiYEWqdRxgqJsFRfUylVbKUpBKmnTD73POA6lx
	C1TDeW5LtwLz49NL235q9We8OF45aVar2pwwgLa3FoNQ6zahoq7b+qlN3vQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haagf3dpg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:01 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1a439db36so1287812a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043701; x=1792648501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VZ0z65RxFkAIQRQmBBZh6ybS7lS24LaNYQuOQ1nHWFY=;
        b=OBcBVvL61hp81T7KaUh4rIZw/d8o3MLIV2d53Day/1ZN+dqQpGtqf9TvUa9npFoLXo
         k5JDRYT09l8I4x0mXT6vjIY6GKlDSy0i11gYVXPoFqEvl2/PP7YikoQ5bgtH9tV9Q64w
         WqZyvbLd1shAJvb4Z8d/icO//8Go1yvzi7bUcwC/ZdQ0eTEgurrYIsx3FTBcEiHF7Iq6
         kyoajN8StQ9/C5kGCoEXH4CG3KiVSxqSgD2UcPi0Z+oGsYWSUBEAgkXrLaxlEweFNk+3
         Zm6M8X0+IEdrU/hoOZE9RwFD5ughj3O9kmvdO6GeEUrvIKd8c50hXRFJ+UE/GqqjS8/F
         gCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043701; x=1792648501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VZ0z65RxFkAIQRQmBBZh6ybS7lS24LaNYQuOQ1nHWFY=;
        b=LZuUrjmvw3P2hfO1chdpUpZqRJTsosS3syqP5AHVQl1Bjfm7NpZROOi4j+guQTrqJM
         yYZ8U2G9P4brGVdqCh62KFHoyrDMmb7xX6VuOMEJj+PAMQOo9CA8Ycq9B0f+Qt80HL5P
         vTj5XTEw47SZlH0pTqn+ckIxs9MGvU5bw1HwMb4MRmDVAwbzvJbIpC45ULD/wOSd2sqS
         wfTfKfeyWgtTGMg+uXXxHZ4ypvigGJXfdIZCFoDjk1myVypuTayQzuesOYIheDzUPGJo
         /FGNFctAKDhPpsMdOZjZXaJ20uqEpBN3LNsOnlGGpyghNOaewllpDyZcbbH9dy06Wxn+
         Q1tg==
X-Gm-Message-State: AFq9FYJMXCXlErgGWWUtoq22FRVorHR34UTnCtnwoVMdDqMMS1u+gSMP
	8xqLzAnKRl7g3KLVUlX27hcm6zeTdE8QfgkRIMuUJVblu0mGWQ2Eu5sG3rX94QqUrYtZFZGF4Ho
	+6r4/o3JjXOYgDtePH246Cin4W4Tl6u0lEAq9nksYqqVYR4FZQbWACsAerI9OX6VoHpZ+jw==
X-Gm-Gg: AYBFou0Q4PT7pM89ZRS6GiIIH4OnHayuJlVnQzoHucA+AFl+OktkWX0AQ9C0D6W2UZU
	3zZsbgmF4boz04d57zVYe5AxPaHvuLUlGyO3ZGolG0q1onT+qp097mM11afv+/FrjG3jbCDiagE
	N36zs+LsvJPudJHO7wh9eVvKOl8bnka+6blicyYQZzFjsiZQrt02wwtLtLKokZ3gBNhfSkVuijX
	K5lZ+fVOd5u7ulwX39lDZuNuQZ2VvSfc6gdxQxOLMR2bfWxzyoOecrKycE2ZAQ+LUP7z/DmNsxT
	XB7QRQufXfWFYhridoViiCl5x9EuevUHgFzw8jWVf5bW08bi1zzNg3+NcDrGkTBhOydTyqbTs81
	zL+9P5aPFYOH8Oe7dF5jlq2oUYBqUk/obSCYvxzBBnvgAKt6cBMMJu8NOSBVIEVpySwmbSumaxx
	u4u7I7q+YXitKE
X-Received: by 2002:a17:90a:c88b:b0:3a4:8c41:fab6 with SMTP id 98e67ed59e1d1-3ab3ab32a3amr14333569a91.46.1792043700857;
        Wed, 14 Oct 2026 22:55:00 -0700 (PDT)
X-Received: by 2002:a17:90a:c88b:b0:3a4:8c41:fab6 with SMTP id 98e67ed59e1d1-3ab3ab32a3amr14333543a91.46.1792043700104;
        Wed, 14 Oct 2026 22:55:00 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:54:59 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Arun Vikas T <arun.t@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 3/7] wifi: nl80211: implement QoS Management request parsing and response
Date: Thu, 15 Oct 2026 11:24:37 +0530
Message-Id: <20261015055441.680588-4-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
References: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX9ko0IFiezXrD
 1BM9/OuqH8p5wQ1rliLmEGLqi7yRJguWVqx0MXgI0qqCeTEpSIrp99i/gnbJAI4O+T8u2FSDW7x
 OCkI3olhxQutZCb+2tEfFgNiard3yk5kn4VUOKPuaXaShySYfBf25kRFSTb1jsB0x1VvXXbUJid
 DwI0sDz8s/vZ/tViMFV+PYsrbTCKGfd6SN/jZfeCbUPpiJfqiroYnsAgcqI1m885LiNb/wMsw5+
 QZZMRp0bVpPHhWQrTmffhMKhCxLWl6qVm09ctmOUajGgD/jEcGKCSTMkyt1HMaCmOueLnt5XazG
 qb+Y39R1K8+KCeDxeSUZ7E3YTgTlkM36yq3SGLbFbCEDY0mp9LrJV01PH2KwIWrvS/pKV76fNkF
 J/L02Hc7LlE0QoQdd/CzGdsM8D7rSuqFw5ImxqC7U0sPgMfPI+oTfl2i7uoNYK8y4gjRR3BA489
 m0X9au+amoK2Eyh3zoQ==
X-Proofpoint-GUID: Xu1_cpffDhhWM3DOLWfFtSC7AgvB_GTH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX99pUumPVgLna
 +ZIV298PtcEjDz/HvlDNZRDGYLP4TBVya6fbNawuLaKahna9/O/lM7UpLO1Voq3CaMxS5pBJOZR
 8hiaJNuYu0tzqNhJHVlUo8vg0W6Xvsk=
X-Proofpoint-ORIG-GUID: Xu1_cpffDhhWM3DOLWfFtSC7AgvB_GTH
X-Authority-Analysis: v=2.4 cv=V/noQuni c=1 sm=1 tr=0 ts=6ad06ab5 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=wz39OnzSvwoNRslPu38A:9 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150023

Add support for NL80211_CMD_QOS_MGMT to allow userspace to submit
QoS Management requests through nl80211.

Parse QoS Management request descriptors and forward them to drivers
through cfg80211. Descriptor attributes are parsed according to the
requested operation and QoS Management protocol. Drivers process the
request through the new set_qos_mgmt_cfg() operation and return a status
for each descriptor.

Send a QoS Management reply containing the request identifier and
processing status for each descriptor, allowing userspace to correlate
responses with submitted requests.

Co-developed-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 net/wireless/nl80211.c  | 642 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h |  17 ++
 net/wireless/trace.h    |  20 ++
 3 files changed, 679 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3bf7aa5c9386..d77363a7ed17 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20547,6 +20547,642 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 };
 
+static int
+nl80211_parse_qm_tclas4_elem(struct nlattr *tb_tclas_entry[],
+			     struct cfg80211_qm_tclas4_params *type4_params)
+{
+	struct nlattr *tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_MAX + 1];
+	struct nlattr *attr;
+	u8 version;
+
+	if (nla_parse_nested(tb_tclas_type4, NL80211_QM_TCLAS_TYPE4_ATTR_MAX,
+			     tb_tclas_entry[NL80211_QM_TCLAS_ATTR_TYPE4_PARAMS],
+			     nl80211_qm_tclas_type4_policy, NULL))
+		return -EINVAL;
+
+	if (!tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_CLASSIFIER_MASK] ||
+	    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_IP_VERSION] ||
+	    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP] ||
+	    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP] ||
+	    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_PORT] ||
+	    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_PORT] ||
+	    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DSCP])
+		return -EINVAL;
+
+	attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_CLASSIFIER_MASK];
+	type4_params->classifier_mask = nla_get_u8(attr);
+	if (!(type4_params->classifier_mask &
+	      NL80211_QM_TCLAS_TYPE4_MASK_VERSION))
+		return -EINVAL;
+	attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_IP_VERSION];
+	type4_params->ip_ver = nla_get_u8(attr);
+	attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_PORT];
+	type4_params->src_port = nla_get_u16(attr);
+	attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_PORT];
+	type4_params->dst_port = nla_get_u16(attr);
+	attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DSCP];
+	type4_params->dscp = nla_get_u8(attr);
+
+	version = type4_params->ip_ver;
+	if (version == QM_IP_VERSION_4) {
+		if (!tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_PROTOCOL])
+			return -EINVAL;
+
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP];
+		if (nla_len(attr) != QM_IPV4_LEN)
+			return -EINVAL;
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP];
+		if (nla_len(attr) != QM_IPV4_LEN)
+			return -EINVAL;
+
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_PROTOCOL];
+		type4_params->protocol = nla_get_u8(attr);
+
+		nla_memcpy(type4_params->src_ip.ipv4,
+			   tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP],
+			   QM_IPV4_LEN);
+		nla_memcpy(type4_params->dst_ip.ipv4,
+			   tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP],
+			   QM_IPV4_LEN);
+	} else if (version == QM_IP_VERSION_6) {
+		if (!tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_NEXT_HEADER] ||
+		    !tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_FLOW_LABEL])
+			return -EINVAL;
+
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP];
+		if (nla_len(attr) != QM_IPV6_LEN)
+			return -EINVAL;
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP];
+		if (nla_len(attr) != QM_IPV6_LEN)
+			return -EINVAL;
+
+		nla_memcpy(type4_params->src_ip.ipv6,
+			   tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_SRC_IP],
+			   QM_IPV6_LEN);
+		nla_memcpy(type4_params->dst_ip.ipv6,
+			   tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_DST_IP],
+			   QM_IPV6_LEN);
+
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_NEXT_HEADER];
+		type4_params->next_header = nla_get_u8(attr);
+
+		attr = tb_tclas_type4[NL80211_QM_TCLAS_TYPE4_ATTR_FLOW_LABEL];
+		nla_memcpy(type4_params->flow_label,
+			   attr,
+			   NL80211_QM_TCLAS_TYPE4_FLOW_LABEL_LEN);
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+nl80211_parse_qm_tclas10_elem(struct nlattr *tb_tclas_entry[],
+			      struct cfg80211_qm_tclas10_params *type10_params)
+{
+	struct nlattr *tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_MAX + 1];
+	struct nlattr *attr;
+	u8 filter_value_len, filter_mask_len;
+
+	attr = tb_tclas_entry[NL80211_QM_TCLAS_ATTR_TYPE10_PARAMS];
+	if (nla_parse_nested(tb_tclas_type10, NL80211_QM_TCLAS_TYPE10_ATTR_MAX,
+			     attr,
+			     nl80211_qm_tclas_type10_policy, NULL))
+		return -EINVAL;
+
+	if (!tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_PROT_INSTANCE] ||
+	    !tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_PROT_NUMBER] ||
+	    !tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_VALUE] ||
+	    !tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_MASK])
+		return -EINVAL;
+
+	attr = tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_PROT_INSTANCE];
+	type10_params->protocol_instance = nla_get_u8(attr);
+	attr = tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_PROT_NUMBER];
+	type10_params->protocol_number = nla_get_u8(attr);
+
+	attr = tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_VALUE];
+	filter_value_len = nla_len(attr);
+	attr = tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_MASK];
+	filter_mask_len = nla_len(attr);
+
+	if (filter_value_len != filter_mask_len ||
+	    filter_value_len > NL80211_QM_TCLAS_TYPE10_MAX_FILTER_LEN)
+		return -EINVAL;
+
+	type10_params->filter_len = filter_value_len;
+	nla_memcpy(type10_params->filter_value,
+		   tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_VALUE],
+		   type10_params->filter_len);
+	nla_memcpy(type10_params->filter_mask,
+		   tb_tclas_type10[NL80211_QM_TCLAS_TYPE10_ATTR_FILTER_MASK],
+		   type10_params->filter_len);
+
+	return 0;
+}
+
+static int
+nl80211_parse_qm_tclas_elem(struct nlattr *tb_tclas,
+			    struct cfg80211_qm_tclas_elements *tclas)
+{
+	struct nlattr *tb_tclas_entry[NL80211_QM_TCLAS_ATTR_MAX + 1];
+	struct cfg80211_qm_tclas4_params *type4_params;
+	struct cfg80211_qm_tclas10_params *type10_params;
+	struct nlattr *attr;
+	u8 classifier_type;
+	int ret;
+
+	if (nla_parse_nested(tb_tclas_entry, NL80211_QM_TCLAS_ATTR_MAX,
+			     tb_tclas, nl80211_qm_tclas_policy, NULL))
+		return -EINVAL;
+
+	if (!tb_tclas_entry[NL80211_QM_TCLAS_ATTR_USER_PRIORITY] ||
+	    !tb_tclas_entry[NL80211_QM_TCLAS_ATTR_CLASSIFIER_TYPE])
+		return -EINVAL;
+
+	tclas->up =
+		nla_get_u8(tb_tclas_entry[NL80211_QM_TCLAS_ATTR_USER_PRIORITY]);
+	attr = tb_tclas_entry[NL80211_QM_TCLAS_ATTR_CLASSIFIER_TYPE];
+	tclas->classifier_type = nla_get_u8(attr);
+	classifier_type = tclas->classifier_type;
+	type4_params = &tclas->tclas_elem.type4_params;
+	type10_params = &tclas->tclas_elem.type10_params;
+
+	switch (classifier_type) {
+	case NL80211_QM_TCLAS_CLASSIFIER_TYPE4:
+		if (!tb_tclas_entry[NL80211_QM_TCLAS_ATTR_TYPE4_PARAMS])
+			return -EINVAL;
+
+		ret = nl80211_parse_qm_tclas4_elem(tb_tclas_entry,
+						   type4_params);
+		if (ret)
+			return ret;
+		break;
+
+	case NL80211_QM_TCLAS_CLASSIFIER_TYPE10:
+		if (!tb_tclas_entry[NL80211_QM_TCLAS_ATTR_TYPE10_PARAMS])
+			return -EINVAL;
+
+		ret = nl80211_parse_qm_tclas10_elem(tb_tclas_entry,
+						    type10_params);
+		if (ret)
+			return ret;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+nl80211_parse_qm_tclas(struct nlattr *tb[],
+		       struct cfg80211_qm_req_desc_data *qm_req_desc)
+{
+	struct nlattr *tb_tclas;
+	struct nlattr *tclas_elements;
+	struct cfg80211_qm_tclas_elements *tclas_elem;
+	struct nlattr *attr;
+	int rem_tclas_desc;
+	unsigned int num_tclas_elements = 0;
+	unsigned int tclas_idx = 0;
+	int ret;
+
+	tclas_elements = tb[NL80211_QM_DESC_ATTR_TCLAS_ELEMENTS];
+	nla_for_each_nested(tb_tclas, tclas_elements, rem_tclas_desc)
+		num_tclas_elements++;
+
+	if (num_tclas_elements) {
+		qm_req_desc->tclas = kzalloc_objs(*qm_req_desc->tclas,
+						  num_tclas_elements,
+						  GFP_KERNEL);
+		if (!qm_req_desc->tclas)
+			return -ENOMEM;
+	}
+
+	nla_for_each_nested(tb_tclas, tclas_elements,
+			    rem_tclas_desc) {
+		tclas_elem = &qm_req_desc->tclas[tclas_idx];
+		ret = nl80211_parse_qm_tclas_elem(tb_tclas, tclas_elem);
+		if (ret)
+			return ret;
+
+		tclas_idx++;
+	}
+
+	qm_req_desc->num_tclas_elements = num_tclas_elements;
+
+	attr = tb[NL80211_QM_DESC_ATTR_TCLAS_PROCESSING];
+	if (attr)
+		qm_req_desc->tclas_processing = nla_get_u8(attr);
+
+	return 0;
+}
+
+/*
+ * QoS characteristics control info bitfield masks, used only here to
+ * parse NL80211_QM_QOS_ATTR_CONTROL_INFO.
+ */
+#define QM_CTRL_INFO_DIRECTION_MASK	GENMASK(1, 0)
+#define QM_CTRL_INFO_TID_MASK		GENMASK(5, 2)
+#define QM_CTRL_INFO_UP_MASK		GENMASK(8, 6)
+#define QM_CTRL_INFO_BITMAP_MASK	GENMASK(24, 9)
+#define QM_CTRL_INFO_LINK_ID_MASK	GENMASK(28, 25)
+#define QM_CTRL_INFO_RESERVED_MASK	GENMASK(31, 29)
+
+/*
+ * MSDU delivery info bitfield masks, used only here to parse
+ * NL80211_QM_QOS_ATTR_MSDU_DELIVERY_INFO.
+ */
+#define QM_MSDU_DELIVERY_INFO_RATIO_MASK		GENMASK(3, 0)
+#define QM_MSDU_DELIVERY_INFO_COUNT_EXPONENT_MASK	GENMASK(7, 4)
+
+#define GET_FIELD_FROM_QM_CTRL_INFO(ctrl_info, FIELD) \
+	u32_get_bits((ctrl_info), QM_CTRL_INFO_##FIELD##_MASK)
+
+#define GET_FIELD_FROM_QM_MSDU_DELIVERY_INFO(msdu_delivery_info, FIELD) \
+	u8_get_bits((msdu_delivery_info), \
+		    QM_MSDU_DELIVERY_INFO_##FIELD##_MASK)
+
+static int
+nl80211_parse_qm_qos_attr(struct nlattr *tb[],
+			  struct cfg80211_qm_qos_attributes *qos_attr)
+{
+	struct nlattr *tb_qm_qos[NL80211_QM_QOS_ATTR_MAX + 1];
+	struct nlattr *attr;
+	u8 msdu_delivery_info;
+	u32 control_info;
+
+	attr = tb[NL80211_QM_DESC_ATTR_QOS_ATTRIBUTES];
+	if (nla_parse_nested(tb_qm_qos, NL80211_QM_QOS_ATTR_MAX, attr,
+			     nl80211_qm_qos_policy, NULL))
+		return -EINVAL;
+
+	if (!tb_qm_qos[NL80211_QM_QOS_ATTR_CONTROL_INFO] ||
+	    !tb_qm_qos[NL80211_QM_QOS_ATTR_MIN_SVC_INTERVAL] ||
+	    !tb_qm_qos[NL80211_QM_QOS_ATTR_MAX_SVC_INTERVAL] ||
+	    !tb_qm_qos[NL80211_QM_QOS_ATTR_MIN_DATA_RATE] ||
+	    !tb_qm_qos[NL80211_QM_QOS_ATTR_DELAY_BOUND])
+		return -EINVAL;
+
+	attr = tb_qm_qos[NL80211_QM_QOS_ATTR_CONTROL_INFO];
+	control_info = nla_get_u32(attr);
+	qos_attr->direction =
+		GET_FIELD_FROM_QM_CTRL_INFO(control_info, DIRECTION);
+	qos_attr->tid = GET_FIELD_FROM_QM_CTRL_INFO(control_info, TID);
+	qos_attr->up = GET_FIELD_FROM_QM_CTRL_INFO(control_info, UP);
+	qos_attr->bitmap = GET_FIELD_FROM_QM_CTRL_INFO(control_info, BITMAP);
+	qos_attr->link_id = GET_FIELD_FROM_QM_CTRL_INFO(control_info, LINK_ID);
+
+	qos_attr->min_service_interval =
+		nla_get_u32(tb_qm_qos[NL80211_QM_QOS_ATTR_MIN_SVC_INTERVAL]);
+	qos_attr->max_service_interval =
+		nla_get_u32(tb_qm_qos[NL80211_QM_QOS_ATTR_MAX_SVC_INTERVAL]);
+	qos_attr->min_data_rate =
+		nla_get_u32(tb_qm_qos[NL80211_QM_QOS_ATTR_MIN_DATA_RATE]);
+	qos_attr->delay_bound =
+		nla_get_u32(tb_qm_qos[NL80211_QM_QOS_ATTR_DELAY_BOUND]);
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_MAX_MSDU_SIZE]) {
+		attr = tb_qm_qos[NL80211_QM_QOS_ATTR_MAX_MSDU_SIZE];
+		qos_attr->max_msdu_size = nla_get_u16(attr);
+	}
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_SVC_START_TIME]) {
+		attr = tb_qm_qos[NL80211_QM_QOS_ATTR_SVC_START_TIME];
+		qos_attr->service_start_time = nla_get_u32(attr);
+	}
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_SVC_START_TIME_LINK_ID]) {
+		attr = tb_qm_qos[NL80211_QM_QOS_ATTR_SVC_START_TIME_LINK_ID];
+		qos_attr->service_start_time_link_id = nla_get_u8(attr);
+	}
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_MEAN_DATA_RATE]) {
+		attr = tb_qm_qos[NL80211_QM_QOS_ATTR_MEAN_DATA_RATE];
+		qos_attr->mean_data_rate = nla_get_u32(attr);
+	}
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_BURST_SIZE])
+		qos_attr->burst_size =
+			nla_get_u32(tb_qm_qos[NL80211_QM_QOS_ATTR_BURST_SIZE]);
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_MSDU_LIFETIME]) {
+		attr = tb_qm_qos[NL80211_QM_QOS_ATTR_MSDU_LIFETIME];
+		qos_attr->msdu_lifetime = nla_get_u16(attr);
+	}
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_MSDU_DELIVERY_INFO]) {
+		attr = tb_qm_qos[NL80211_QM_QOS_ATTR_MSDU_DELIVERY_INFO];
+		msdu_delivery_info = nla_get_u8(attr);
+
+		qos_attr->msdu_delivery_ratio =
+			GET_FIELD_FROM_QM_MSDU_DELIVERY_INFO(msdu_delivery_info,
+							     RATIO);
+		qos_attr->msdu_count_exponent =
+			GET_FIELD_FROM_QM_MSDU_DELIVERY_INFO(msdu_delivery_info,
+							     COUNT_EXPONENT);
+	}
+
+	if (tb_qm_qos[NL80211_QM_QOS_ATTR_MEDIUM_TIME])
+		qos_attr->medium_time =
+			nla_get_u16(tb_qm_qos[NL80211_QM_QOS_ATTR_MEDIUM_TIME]);
+
+	return 0;
+}
+
+static int nl80211_parse_qm_desc(struct nlattr *tb_qm_desc,
+				 struct cfg80211_qm_req_desc_data *qm_req_desc,
+				 enum nl80211_qm_type qm_type)
+{
+	struct nlattr *tb[NL80211_QM_DESC_ATTR_MAX + 1];
+	struct nlattr *attr;
+	int ret;
+
+	if (nla_parse_nested(tb, NL80211_QM_DESC_ATTR_MAX,
+			     tb_qm_desc, nl80211_qm_desc_params_policy, NULL))
+		return -EINVAL;
+
+	if (!tb[NL80211_QM_DESC_ATTR_QM_ID] ||
+	    !tb[NL80211_QM_DESC_ATTR_REQUEST_TYPE])
+		return -EINVAL;
+
+	qm_req_desc->qm_id = nla_get_u8(tb[NL80211_QM_DESC_ATTR_QM_ID]);
+	if (!qm_req_desc->qm_id)
+		return -EINVAL;
+
+	qm_req_desc->request_type =
+		nla_get_u8(tb[NL80211_QM_DESC_ATTR_REQUEST_TYPE]);
+
+	switch (qm_req_desc->request_type) {
+	case NL80211_QM_REMOVE_REQ:
+		return 0;
+	case NL80211_QM_ADD_REQ:
+	case NL80211_QM_CHANGE_REQ:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (qm_type) {
+	case NL80211_QM_TYPE_SCS:
+		if (tb[NL80211_QM_DESC_ATTR_PRIORITY]) {
+			attr = tb[NL80211_QM_DESC_ATTR_PRIORITY];
+			qm_req_desc->priority = nla_get_u8(attr);
+		}
+
+		if (tb[NL80211_QM_DESC_ATTR_TCLAS_ELEMENTS]) {
+			ret = nl80211_parse_qm_tclas(tb, qm_req_desc);
+			if (ret)
+				return ret;
+		}
+
+		if (tb[NL80211_QM_DESC_ATTR_QOS_ATTRIBUTES]) {
+			ret = nl80211_parse_qm_qos_attr(tb,
+							&qm_req_desc->qos_attr);
+			if (ret)
+				return ret;
+
+			qm_req_desc->is_qos_present = true;
+		}
+		break;
+
+	case NL80211_QM_TYPE_MSCS:
+		if (tb[NL80211_QM_DESC_ATTR_USER_PRIORITY_BITMAP]) {
+			attr = tb[NL80211_QM_DESC_ATTR_USER_PRIORITY_BITMAP];
+			qm_req_desc->user_priority_bitmap = nla_get_u8(attr);
+		}
+
+		if (tb[NL80211_QM_DESC_ATTR_USER_PRIORITY_LIMIT]) {
+			attr = tb[NL80211_QM_DESC_ATTR_USER_PRIORITY_LIMIT];
+			qm_req_desc->user_priority_limit = nla_get_u8(attr);
+		}
+
+		if (tb[NL80211_QM_DESC_ATTR_TCLAS_MASK]) {
+			attr = tb[NL80211_QM_DESC_ATTR_TCLAS_MASK];
+			qm_req_desc->tclas_mask = nla_get_u8(attr);
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+nl80211_set_qm_resp_desc(struct sk_buff *msg,
+			 struct cfg80211_qm_resp_desc_data *qm_resp_desc,
+			 int idx)
+{
+	struct nlattr *qm_desc_entry;
+
+	qm_desc_entry = nla_nest_start(msg, idx);
+	if (!qm_desc_entry)
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_QM_DESC_ATTR_QM_ID,
+		       qm_resp_desc->qm_id) ||
+	    nla_put_u8(msg, NL80211_QM_DESC_ATTR_STATUS,
+		       qm_resp_desc->status)) {
+		nla_nest_cancel(msg, qm_desc_entry);
+		return -ENOBUFS;
+	}
+
+	nla_nest_end(msg, qm_desc_entry);
+	return 0;
+}
+
+static int
+nl80211_qm_send_resp(struct genl_info *info,
+		     struct cfg80211_qm_req_data *qm_req,
+		     struct cfg80211_qm_resp_data *qm_resp)
+{
+	struct nlattr *qm, *qm_desc;
+	struct sk_buff *msg;
+	void *hdr;
+	int ret;
+	int idx;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_QOS_MGMT);
+	if (!hdr) {
+		ret = -ENOBUFS;
+		goto nla_fail;
+	}
+
+	qm = nla_nest_start(msg, NL80211_ATTR_QOS_MGMT);
+	if (!qm) {
+		ret = -ENOBUFS;
+		goto nla_fail;
+	}
+
+	if (nla_put(msg, NL80211_QM_ATTR_MAC_ADDR, ETH_ALEN,
+		    qm_req->peer_mac) ||
+	    nla_put_u8(msg, NL80211_QM_ATTR_QM_TYPE,
+		       qm_req->qm_type)) {
+		ret = -ENOBUFS;
+		goto nla_qm_fail;
+	}
+
+	qm_desc = nla_nest_start(msg, NL80211_QM_ATTR_DESCRIPTOR_PARAMS);
+	if (!qm_desc) {
+		ret = -ENOBUFS;
+		goto nla_qm_fail;
+	}
+
+	for (idx = 0; idx < qm_req->num_qm_desc; idx++) {
+		ret = nl80211_set_qm_resp_desc(msg, &qm_resp->qm_resp_desc[idx],
+					       idx);
+		if (ret) {
+			GENL_SET_ERR_MSG(info,
+					 "QoS Management response descriptor failed");
+			goto nla_qm_desc_fail;
+		}
+	}
+
+	nla_nest_end(msg, qm_desc);
+	nla_nest_end(msg, qm);
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+nla_qm_desc_fail:
+	nla_nest_cancel(msg, qm_desc);
+nla_qm_fail:
+	nla_nest_cancel(msg, qm);
+nla_fail:
+	nlmsg_free(msg);
+	return ret;
+}
+
+static void
+nl80211_free_qm_req(struct cfg80211_qm_req_data *qm_req)
+{
+	unsigned int i;
+
+	for (i = 0; i < qm_req->num_qm_desc; i++)
+		kfree(qm_req->qm_req_desc[i].tclas);
+
+	kfree(qm_req->qm_req_desc);
+}
+
+static int
+nl80211_qos_mgmt_cfg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct nlattr *tb_qm[NL80211_QM_ATTR_MAX + 1];
+	struct cfg80211_qm_resp_data qm_resp = {};
+	struct cfg80211_qm_req_data qm_req = {};
+	struct cfg80211_qm_req_desc_data *qm_req_desc;
+	struct nlattr *tb_qm_desc;
+	int rem_qm_desc;
+	unsigned int num_qm_desc = 0;
+	unsigned int idx;
+	int ret;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_QOS_MGMT]) {
+		GENL_SET_ERR_MSG(info, "QoS Management attribute missing");
+		return -EINVAL;
+	}
+
+	if (nla_parse_nested(tb_qm, NL80211_QM_ATTR_MAX,
+			     info->attrs[NL80211_ATTR_QOS_MGMT],
+			     nl80211_qm_policy, NULL)) {
+		GENL_SET_ERR_MSG(info,
+				 "QoS Management attribute parsing failed");
+		return -EINVAL;
+	}
+
+	if (!tb_qm[NL80211_QM_ATTR_MAC_ADDR] ||
+	    !tb_qm[NL80211_QM_ATTR_QM_TYPE] ||
+	    !tb_qm[NL80211_QM_ATTR_DESCRIPTOR_PARAMS]) {
+		GENL_SET_ERR_MSG(info,
+				 "QoS Management request attributes missing");
+		return -EINVAL;
+	}
+
+	nla_memcpy(qm_req.peer_mac, tb_qm[NL80211_QM_ATTR_MAC_ADDR], ETH_ALEN);
+	qm_req.qm_type = nla_get_u8(tb_qm[NL80211_QM_ATTR_QM_TYPE]);
+
+	nla_for_each_nested(tb_qm_desc,
+			    tb_qm[NL80211_QM_ATTR_DESCRIPTOR_PARAMS],
+			    rem_qm_desc)
+		num_qm_desc++;
+
+	if (!num_qm_desc) {
+		GENL_SET_ERR_MSG(info,
+				 "QoS Management descriptor list is empty");
+		return -EINVAL;
+	}
+
+	qm_req.qm_req_desc = kzalloc_objs(*qm_req.qm_req_desc,
+					  num_qm_desc, GFP_KERNEL);
+	if (!qm_req.qm_req_desc) {
+		ret = -ENOMEM;
+		goto free_qm;
+	}
+
+	nla_for_each_nested(tb_qm_desc,
+			    tb_qm[NL80211_QM_ATTR_DESCRIPTOR_PARAMS],
+			    rem_qm_desc) {
+		qm_req_desc = &qm_req.qm_req_desc[qm_req.num_qm_desc];
+		ret = nl80211_parse_qm_desc(tb_qm_desc, qm_req_desc,
+					    qm_req.qm_type);
+		if (ret) {
+			GENL_SET_ERR_MSG(info,
+					 "QoS Management descriptor parsing failed");
+			goto free_qm;
+		}
+		qm_req.num_qm_desc++;
+	}
+
+	if (qm_req.qm_type == NL80211_QM_TYPE_MSCS && qm_req.num_qm_desc != 1) {
+		GENL_SET_ERR_MSG(info,
+				 "MSCS request must contain exactly one descriptor");
+		ret = -EINVAL;
+		goto free_qm;
+	}
+
+	qm_resp.qm_resp_desc = kzalloc_objs(*qm_resp.qm_resp_desc,
+					    qm_req.num_qm_desc, GFP_KERNEL);
+	if (!qm_resp.qm_resp_desc) {
+		ret = -ENOMEM;
+		goto free_qm;
+	}
+
+	for (idx = 0; idx < qm_req.num_qm_desc; idx++) {
+		qm_resp.qm_resp_desc[idx].qm_id =
+			qm_req.qm_req_desc[idx].qm_id;
+		qm_resp.qm_resp_desc[idx].status = NL80211_QM_STATUS_DECLINED;
+	}
+
+	ret = rdev_set_qos_mgmt_cfg(rdev, dev, &qm_req, &qm_resp);
+	if (ret) {
+		GENL_SET_ERR_MSG(info, "set_qos_mgmt_cfg failed");
+		goto free_qm;
+	}
+
+	ret = nl80211_qm_send_resp(info, &qm_req, &qm_resp);
+
+free_qm:
+	kfree(qm_resp.qm_resp_desc);
+	nl80211_free_qm_req(&qm_req);
+	return ret;
+}
+
 static const struct genl_small_ops nl80211_small_ops[] = {
 	{
 		.cmd = NL80211_CMD_SET_WIPHY,
@@ -21438,6 +22074,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
+	{
+		.cmd = NL80211_CMD_QOS_MGMT,
+		.doit = nl80211_qos_mgmt_cfg,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index ae15cec9bf8b..16698af39020 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1707,4 +1707,21 @@ rdev_set_epcs(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_qos_mgmt_cfg(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev,
+		      struct cfg80211_qm_req_data *qm_req,
+		      struct cfg80211_qm_resp_data *qm_resp)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_set_qos_mgmt_cfg(wiphy, dev, qm_req);
+	if (rdev->ops->set_qos_mgmt_cfg)
+		ret = rdev->ops->set_qos_mgmt_cfg(wiphy, dev, qm_req, qm_resp);
+	trace_rdev_return_int(wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 31000ffebe43..83bd63e1c7e2 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3281,6 +3281,26 @@ TRACE_EVENT(rdev_set_epcs,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->val)
 );
 
+TRACE_EVENT(rdev_set_qos_mgmt_cfg,
+	    TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_qm_req_data *qm_req),
+	    TP_ARGS(wiphy, netdev, qm_req),
+	    TP_STRUCT__entry(WIPHY_ENTRY
+			     NETDEV_ENTRY
+			     __field(u8, qm_type)
+			     __field(unsigned int, num_qm_desc)
+	),
+	    TP_fast_assign(WIPHY_ASSIGN;
+			   NETDEV_ASSIGN;
+			   __entry->qm_type = qm_req->qm_type;
+			   __entry->num_qm_desc = qm_req->num_qm_desc;
+	),
+	    TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT
+		      ", qm_type=%u num_qm_desc=%u",
+		      WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->qm_type,
+		      __entry->num_qm_desc)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.34.1

