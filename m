Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACF115746F
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 23:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787010400; cv=none; b=SMqUcTXzYKwim+CXG09zQMxXuQajWsOai07TlLOuk8Nzvy0jMdyPrh3jxbip4vPscYdXbXMF2TWgLIhbRVxfg4f9TbRmOtgaudjYAxpuURRI+bwohB+mE60eUDW+G/ErmVp6QZz1KZPUyap+jjb4dBvTXdw2CK3NU0EbE+/3bGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787010400; c=relaxed/simple;
	bh=PDmUKOmAKGHZJyPbhmnbu7isu5GWDVEupdxR1CCyeNw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=cYUW9VquWKHw0dS19kiwavqP7nuv8Xip/EqY8comK0cXEN47Jmt7BXCMdsynUsJStTXGeEbBd3ZjwSvSCA3OFwlzbNAodwny6bXm9xKY0qVrdLMh17lqGP1jYARSjYbISluUQXLhq/WgXVVwSEOyFPRiQPze6gjMjzSYV6IWw2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dDxTvk0N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VvGtFsY0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dDxTvk0N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VvGtFsY0"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HLlNWX3883840
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 23:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=y4Omj204/uIeyve9oBEjC2
	WLK/tG67t/xbLfOcYNJ2I=; b=dDxTvk0N5jty+8WsCM70xQIna6ThVK18KtOfcG
	pkBgDPorOZllPVIJwY5n0txYs9prMfoRUZ98T/tfHSFNr/v/ViAhWmr/M8hqiUuf
	r94hlWvFD3Tkx7z3j3DhMx48HIzbog0wwptDBI2THt3tiDL243nv1nRRDWfocW0a
	oEHx3Y0bDU61IIbhmt887c/p4xSa7jlggbsBCfwbJ6kqzFrhaBjxRYUssh0G66bH
	Q6oigplvCac33h4CSPa5MCnpXovFS7lFrVLexDc7PUTPve85P7+vXRJNAKOhmb1K
	s2X1oWOh40r0yQNCTgOfkiTj1eW3Dbk0F5yd4wlpFOvsxVRA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g3y77bjdw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 23:46:37 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb4cdf95b5aso7235914a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 16:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787010397; x=1787615197; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=y4Omj204/uIeyve9oBEjC2WLK/tG67t/xbLfOcYNJ2I=;
        b=VvGtFsY0nItq0rAuWNJMf2emlChbQcZFbACpTa4PDG6tb4cUCLikuwLlyWlTaXEu8i
         +JWVGSPN/hIOSCDHnggdwfPLyRNbuZLoeuHTXWweJygxVs/kaCgzSO5EyQSmeyX5wXXK
         s3qtk4QSVOVOhG5P7k8+acE6D1OZLjQKh3BCqRep23k7i0MyHIN7fcxvLu0bj8eBHE66
         CEx49BlPMvPMqn/b8FvoQ1yOnR6kPP5Ugl/DPl+u5krb9SAjkSTMs4MK/BAQULFywDW0
         IiiDL/02id3Zo6qXUin0QN9vrvQDao1soZUDdDxs+vQ+TAre9dpLIdfaWTxouqo/2HEO
         HJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787010397; x=1787615197;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=y4Omj204/uIeyve9oBEjC2WLK/tG67t/xbLfOcYNJ2I=;
        b=tDvnqS0UNBIlVomM3mUfkEgvXaGMQ1CQIjsCWhOgEjxiyC4OY9ms7hkjVmHRnvf+1B
         H3VqoCKeE0exajHyeNBVxUTLx2c73vnqwEJjojkLrMo6sxnuPG87b2pelBLlW/tl5O9A
         vVsUHlB5eCFSQnuLVwkeCWdSvk8cJluh7zYX92khbCLQ40R+JeCPUHQ1emwOliygFmVI
         UwQn3TVrJxO1asRlfDMBv8qB0WZrkm/7zXqukV8EE2ZUr/4lyuNk1Bu/SEUxBDBNWaTD
         HQwCn+FzIeys2okrfVB6QNaW63DWFf8lXmBggxg8qntsWGpb8AV19EcC3W1IT5rzemiU
         xFxg==
X-Gm-Message-State: AOJu0YwXPIXFSThjqqpsOcgi80dOulCPQIuOlGwOnCwQpBH3QNYG7rZd
	G5Ohr04e2Ecbj5DhOTn2lAn4vzw9RWmoec7GGWg/JtK7Xz965WuH7eBnQ482NkBXUNpoYlGxwvJ
	2w9+8MZj+BBP8Bdk1gPeqKME+PjwSWeKkL0JIz3yGTVjagY8GTebUS6Vyu/V+C1kE3N3Jhp0ZZl
	hDFQ==
X-Gm-Gg: AR+sD13Nijm1+zY7OMJXn27NsJePL2V+AD3kA/fzc+7flpeqkHGWxTKn/LoRa6iIjsq
	f4rK75siMG1NkalYT5ileLsLxuhxFDqbFz78nztQiwFFlxp7Sj3KlP/j9NQBDRaWl4Bi6Bg1mk9
	8/1od3HqS1pvFmBhSk98G7YaIJC5xgQK96ySofnYBKd/p17iQlZn1Kx2f9rbjPNhUozRgdBlm1U
	kgVVbbNIzkj9R8/O6z9G+eTELP73xTIRmMPBKT1WkoWNprrX4DD/qScExLLnLc6sK6UqlKisiOU
	RTBkcDr3iLCJ8GoE3Wu20LY/OFag3MyzLwbmz2aCOiZZN03tgvm7uYryFTvAfvWYZg18rOS7rXB
	n7DSsPan564xcGEYeUJdqwWcOhWTesQpr/Sh5u7FXkCKqYcNZxHLe74A=
X-Received: by 2002:a05:6a21:3511:b0:3c3:b57b:6285 with SMTP id adf61e73a8af0-3cc71a2c74emr37886969637.13.1787010396907;
        Mon, 17 Aug 2026 16:46:36 -0700 (PDT)
X-Received: by 2002:a05:6a21:3511:b0:3c3:b57b:6285 with SMTP id adf61e73a8af0-3cc71a2c74emr37886894637.13.1787010396474;
        Mon, 17 Aug 2026 16:46:36 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32678dcedf4sm10043488eec.5.2026.08.17.16.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 16:46:35 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Mon, 17 Aug 2026 16:46:34 -0700
Subject: [PATCH ath-next] wifi: ath11k: fix reg_info_store leak in
 ath11k_service_ready_ext_event()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-reg_info_store-leak-v1-1-77025a99b074@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAFmdg2oC/32NUQqDMBBEryL73ZUkpaL96j2KSDAbXapJm1ixS
 O7e1AP0Z2B4zJsdIgWmCNdih0ArR/YuF3kqoB+1GwjZ5A5KqErUQmGgoWNnfRcXHwgn0g+U2ta
 yP1OlGwt5+QxkeTusd9DLiI62BdpMRv7NPsfdKg/+17xKlKiEaRpTm4ux6uZjLF9vPfV+nssc0
 KaUvuaKWrvHAAAA
X-Change-ID: 20260802-reg_info_store-leak-1af81c3e6a9f
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE4MiBTYWx0ZWRfX3TkW9xh/lqYR
 kQ4PA9chC/PSd7AfEBR1uFDChjYFNPTOmVyUSx2rBPAKTWYuQMoRLCnr5XkqAsXLxx14Qo4LeGT
 U7PEcaYu3/aFl9nWgkDwVg6ydqw7e5r30kkKIAnszTXo2nFm+t+3YoRepIOZHHLF2PTV+bEz7Ry
 kuq75rSOr5ZDleHO9W9pOc+VXDhKeGI4EH/Lj59onn3ZTbztShFWEWyA8C/1TsBbSGs5PXzHFPK
 H1kq9anfuMaocmftCLxXAcMp+1L7w5zx8qPZ6ndC6q/hv35MfFdmB/3KnAzA8zhoNydta1tp6qF
 W/CYhjVZQBgEByqB4CtRO8UEid1lE21KtE/Zinn0SXmmEyXws/Ko2H5iKoGIJ67Va+aah5w99MZ
 rTnJO17vQwP6iAqmX9SPjLgtsiv6+3l/7wZY00bG/7MAtMGOs/wEG1zeb0pNLW++wllf+Ye+Pkk
 vEZqeRZhqsTwNIE95EQ==
X-Proofpoint-ORIG-GUID: Gm_lR9soBkEZGRzl4Wr4wtp3KivOi1Bj
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE4MiBTYWx0ZWRfX1mvY+4+iwLgI
 Sj0psMensR9lAxNCdQ82ulzKDicplUiPjSarE9gaOJrJ4niep7KB4FIvOWq2lMvYMswy7DXbyaR
 /fQWK0ll27uwfxgdhiuadxA3tpHfwAs=
X-Proofpoint-GUID: Gm_lR9soBkEZGRzl4Wr4wtp3KivOi1Bj
X-Authority-Analysis: v=2.4 cv=WNhPmHsR c=1 sm=1 tr=0 ts=6a839d5d cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=ioZH6r-_hHwHCcFRKkYA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170182

Currently, while processing the WMI Service Ready Ext event, the iterator
in ath11k_service_ready_ext_event() can dispatch the HAL Regulatory
Capabilities handler ath11k_wmi_tlv_ext_soc_hal_reg_caps_parse() which can
allocate ab->reg_info_store.

If a subsequent failure occurs during iteration, the ab->reg_info_store
allocation is leaked.

Directly free and clear the pointer on the error path.

Note that the normal cleanup function ath11k_reg_free() cannot be used
since other regulatory-related fields are not yet populated at this point.

Compile tested only.

Fixes: 7004bdceef60 ("wifi: ath11k: store cur_regulatory_info for each radio")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index bbca275a8289..08fd6795ed9e 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5136,6 +5136,15 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 
 err:
 	kfree(svc_rdy_ext.mac_phy_caps);
+
+	/*
+	 * During TLV iteration the WMI_TAG_SOC_HAL_REG_CAPABILITIES
+	 * handler may have allocated ab->reg_info_store, so free it
+	 * on error to avoid a memory leak
+	 */
+	kfree(ab->reg_info_store);
+	ab->reg_info_store = NULL;
+
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }

---
base-commit: 8150c22bc80caef4ba8391eb98b25e9f7c6cb487
change-id: 20260802-reg_info_store-leak-1af81c3e6a9f

