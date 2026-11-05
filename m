Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907633;
	b=0bv6ycumBR2dtteYjUnjGLWSJFl2UhRWxCLq15t5pucdKrRFoFV2SGFF3RajI4b5dv4r
	 5IB1qBU2Kj6NM6BA5KVocZEyuRbYcA1tSHAuBsEWm9kY1UXhhqn5SKy9A3iDj8IQlw01x
	 Jv3/Gjb2eulhmDoap8xMycA906Z7PP3YVBM1tFqQmo5779xt5roIfmlD8CUuzZ8HYh6zf
	 pIx+jDlmM+CQA7LHlQvUqkkxUYC/BJGJ3GIoG3yi/ATCCdVX75uO4L6IHq8dP0jaKuMOe
	 92yfMygSEur+I3nn51jLEE/6cFJM/DJd5Mdpi9Sa0IgM2TVXwSTVusk3TOQl2t918vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907633;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=;
	b=KPWKs2/6vA9ij3yARALqlmsjnoN13+eCItY2vXPNfCmn6w6o1h3q1Zmhud2W8m+5J+cl
	 2hHCaCQR51t6MKH25c3wU22brCjWxbl9+tyBhKGVAQnX5Q/yT4zgi+va9R4g1JwQB8478
	 Zzqh4mSggzqXOTxYFq9iUc5xc25bwYY7XZJPyDQrLMmhfJmDFJ4f5b2BOzPIyfDscfvx3
	 aXnJ4D3eoj5dugs5eNOyLxAYg7t7Lo9qoLo1bnHnMb1qE0CdH+D2sQQcF4opvzVsrzCvh
	 K+ZLkCjWvyrPi4MZtoTiVVvGVuWQt2zwb9QU4WNNBrBf9rK4NUA1QESk5ZPCpVAhLvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MmHyqTTn;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QuKJAhO5;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDA4606E403
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDDA4606E403
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MmHyqTTn;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QuKJAhO5
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5JM9p1598804
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=; b=MmHyqTTnvbps7mPL
	aJz+MPNemEn0W6ghS+7DnwFI8+rRaI7olwppDA4NuXeTmmwnDKbZi5JLO8S1lhTl
	ShN5McEJf+R3TG4Np8g0iK4/PFpmfMzZs7fOdiTGJsDnw/PbBJPCL9seifOgmVKl
	m1mAWULSyKiRMYdMo3jvo4JHIuSKo0XlgQ8Vr7XEY/KHPRzpYEWle831KmTfMU0W
	W4XJ0zMk1lxq/oNwUuLPeEvDGBzokC7GJrG06PBaxpGY5sq0F6IYgJrUsfPJzeyd
	U49LVddv87HwK6dEH0Ywa/DA5EvSQNJhzUpximwKWrvFrFhhlYLYyFwgu/c77V9C
	sRLIBw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hryvv02se-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:30 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36d69ab3c2bso2343571eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907630; x=1794512430; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=;
        b=QuKJAhO5/AGHrCBi3LKGAvZoR07ilaGb0hNWRxryEJTgQKSHPyVJfVdcRfb9JXsf1q
         v6Ehhx3YnbM9QkbY99pLJEA7m7zYSx5OZ1S9lnYPKNy1cYV4ihcBKTvDLZPqaxU+AMYT
         jgQxQAgli2HDl32nk1Ib/iLqzZspqtvtOGPrABxFLDF9W6zvNLNobOmHTxT83y6Bo5kf
         1LuPk0RyCEa+kPfkdGEmBFEEtxDmCyx4l/nWoFuTeynz9dKsxNOEVO4gtf8FqBBe24lS
         fwxRrnmw1CwC26J/4C/5l9uJTMnKQ2JqCtYz75dd9Ena0KuHkzQMQ62SDVYLnmf+p0I2
         IcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907630; x=1794512430;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=;
        b=C+IQrFn33gAxcNib9jahvkVoT+ElbidXzFpQdYQ3IiUikPiNqlpbVCOskheyQqE+zS
         +jZ/Oo2/A36K9r+KTVwcdQpFzcRqRmydWyaW6Y5/amnrEOXtKgShSxjztmtnbQrwqEO6
         Pk/NlTx5mTTAgcAU3N04X/HlxOYo0Ow+/nLfOYRcPyxDLx+aOx2SiFtuknq2SXLmxrq1
         PvjEteXijOo7qvDWdQ+U/lBnTcnl4aq5l3FMeMRqDch8ONo4PKUBHsDWeA7iVw/i6ax3
         Bt11hPAuM8/bef/lz5Wxc2o4ca2b2fwraJ91hfEixSjXFDMtjywLmVjzh2D616LK0ieY
         hi0g==
X-Gm-Message-State: APuU4Z/v5M2yhcgQcvZMAlJ190xnpHDxhtCLUMyw67KTtkrIQOiKHp/B
	cx6UNwIs1zklgpxOKneTJGic5UmuSU2SmkiV1o23I75UPX2DKH79iWD4O+giLmuDndPwN3cMhaI
	kgpfo4vzY4I6S1rOnA/SwBws8fidSpuCxqdmhACbwfGDBHzwBWNRFcxB/BM0pm65w/YUP
X-Gm-Gg: AYBFou0MltAWD1vwAvV2E9sbnJ0Qe+9pKQVuqbEmYzL70xDZ3sxPy1u5GQnBQwgYmCM
	rV3glXQekDzt+UujAkm12n1RfrbJjZcR7zr3Lw8N91z84qMLBAtrlNJnLr5vT/3mhGz5dbCf1Z2
	20dw3OFdKgQ+0gv3Z6dyme3nLLcN49p4wL5Pultm2CS7YoW+LRHY/ftNjvRNRogrmum6Oh9MU0m
	9XNDoICjx09RX8NiHxxj8lHhAVfTD8Pp40sf6mV//RgM1V/o0xNkLmYBTJJhcLvh33q6iOxO6aP
	TTCVoACqDlzQJs9RUeQEry/uevAgS9yXb31lx6LmrXIWbul1vFAR2vQJH3sqNgbI7rF7dDnCa+i
	54WfiHe5OzxaUWxviG4Ikm5SGsLdxPk7INAn3UJFeyqudkae//xWLbrfxV2MzYvAMhPOKVEXEle
	MFXj6PaFACqjK7KZa+AzqTgxAmY/VL/DR/rSSx2qq8nv0ouL7wJpUk9Iotk/8UUAiB+1hEPg==
X-Received: by 2002:a05:693c:808b:b0:369:ef92:bd7b with SMTP id 5a478bee46e88-36f773f204dmr165724eec.41.1793907629299;
        Thu, 05 Nov 2026 11:40:29 -0800 (PST)
X-Received: by 2002:a05:693c:808b:b0:369:ef92:bd7b with SMTP id 5a478bee46e88-36f773f204dmr165679eec.41.1793907628582;
        Thu, 05 Nov 2026 11:40:28 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:28 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:40 +0530
Subject: [PATCH wireless-next v3 05/21] wifi: nl80211: define interfaces
 for SMD BSS Transition context transfer
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
Message-Id: <20261106-smd-v3-5-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXxE9xTBWpmo25
 eTdF430+O1wUugeafA046iOVNawk6eV7kfPeo9zvvHvl4xm9qWDOaMazHW0WFD46Dy1dsukNuif
 bTVuFTtTeOqYGE8I5FOJKXT3PwLrYXs=
X-Proofpoint-GUID: F0m8oZXSdbwyZz5XVyVo5gXIE3AzIPBb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX6WBOEMY/xXje
 5nQXXxbYnllhTjEbwgGDLPzjeeJqH02Q/P/g0iQIHrzdBSCmW5tPrsMC9kTty4VmiSYbyHl3L88
 Xc7nZWRR0RgYU0PfQdGUSvD8+bZJqUNGp29CvNzi9+Y/oQv2u9gPg2Rc05smQ2qdn0358utLAKs
 +UN0L1lLY8L1sgAGKQsqcjR4YClbFsNJEoH5OY6YL8acTHlQyNA+9RzIMF2u//QTvAuVLN5kafy
 uhn5DGzYDNjGFdWQ0o5feYyulSrIhhpd+eh1IG/SWFJgQpLV7BTE4CXZN1pTdGo92p/1galshpY
 0WSR+46cE/OWkfWQcCRpKJPmbHy7Iy3sLH8f+vUK4BCvZjVnmULq2V7TLMAE6eiO62XKL7iKZuL
 QgOiElositanFBfvxSosRB5Kze6Ox0460dkwovnGtMoqQD+mU4tZYtnTTo3vmP9G1kiC1akAHyj
 lRUoo5JxXYjOPN/oZJQ==
X-Authority-Analysis: v=2.4 cv=dKUzC+Zb c=1 sm=1 tr=0 ts=6aecdbae cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=A4pAW7IlmD6AYZ-BFbAA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: F0m8oZXSdbwyZz5XVyVo5gXIE3AzIPBb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

Define nl80211 attributes and policies required to pack SMD BSS Transition
context along with NL80211_CMD_FRAME to be sent to userspace, and to set
and get the context during roaming via current AP MLD and roaming via
target AP MLD. Without these, userspace will not be able to transport the
context to the target AP MLD, program the context on the target AP MLD TX
and RX queues, nor fetch the context on behalf of the target AP MLD if
the ST Execution frame is sent directly to the target.

Suggested-by: Jouni Malinen <jouni.malinen@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 190 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  48 +++++++++++
 2 files changed, 238 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 81c16ea2fd34..fbc23aca006e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -375,6 +375,19 @@
  *	on the target AP MLD while creating the station entry.
  *	%NL80211_STA_FLAG_SMD_{EXEC_CURRENT,DL_DRAIN}, on the other hand, can be
  *	set using %NL80211_CMD_SET_STATION on the current AP MLD.
+ *
+ * Drivers can use %NL80211_ATTR_SMD_CTX to pack the dynamic context of the
+ * non-AP MLD along with the ST Preparation or ST Execution Request frames in
+ * the %NL80211_CMD_FRAME event.
+ *
+ * On the target AP MLD, this collected context, received in the
+ * userspace-managed backhaul between the AP MLDs, can be programmed using
+ * %NL80211_CMD_SET_SMD_CTX.
+ *
+ * In case the non-AP MLD executes directly with the target AP MLD, the current
+ * AP MLD can request the context from the driver on the target's behalf using
+ * %NL80211_CMD_GET_SMD_CTX and the response can be reported back using
+ * %NL80211_CMD_SMD_CTX_EVENT.
  */
 
 /**
@@ -1502,6 +1515,21 @@
  *	and multiple can be nested in %NL80211_ATTR_MLO_LINKS but then the
  *	update isn't atomic if any failures happen.
  *	Only supported with %NL80211_EXT_FEATURE_UPDATE_BEACON.
+ *
+ * @NL80211_CMD_SET_SMD_CTX: Set the SMD BSS Transition dynamic context for a
+ *	non-AP MLD sent from the current AP MLD on the target AP MLD managed by
+ *	an SMD-ME. This command carries %NL80211_ATTR_MLD_ADDR,
+ *	%NL80211_ATTR_SMD_CTX_TYPE and %NL80211_ATTR_SMD_CTX. The station must
+ *	be present on the target AP MLD in the "prepared" state with a default
+ *	key installed.
+ * @NL80211_CMD_GET_SMD_CTX: Get the SMD BSS Transition dynamic context for a
+ *	non-AP MLD associated to an AP MLD managed by an SMD-ME. This command
+ *	carries %NL80211_ATTR_MLD_ADDR and %NL80211_ATTR_SMD_CTX_TYPE.
+ * @NL80211_CMD_SMD_CTX_EVENT: Event reporting the collected SMD context
+ *	(requested via %NL80211_CMD_GET_SMD_CTX) to userspace. It carries
+ *	%NL80211_ATTR_MLD_ADDR, %NL80211_ATTR_SMD_CTX_TYPE, and
+ *	%NL80211_ATTR_SMD_CTX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1784,6 +1812,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_BEACON,
 
+	NL80211_CMD_SET_SMD_CTX,
+	NL80211_CMD_GET_SMD_CTX,
+	NL80211_CMD_SMD_CTX_EVENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -3282,6 +3314,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMD_ROAM_STA: Flag attribute to indicate that the station is
  *	created as part of SMD BSS Transition and not by typical association.
  *
+ * @NL80211_ATTR_SMD_CTX: Nested attribute associated with UHR SMD BSS
+ *	Transition data. Used with %NL80211_CMD_FRAME, %NL80211_CMD_SET_SMD_CTX,
+ *	and %NL80211_CMD_SMD_CTX_EVENT. See &enum nl80211_smd_ctx.
+ * @NL80211_ATTR_SMD_CTX_TYPE: u8 attribute specifying the type of SMD context.
+ *	Used along with %NL80211_CMD_FRAME, %NL80211_CMD_SET_SMD_CTX,
+ *	%NL80211_CMD_GET_SMD_CTX, and %NL80211_CMD_SMD_CTX_EVENT.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3892,6 +3931,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_SMD_SUPPORT,
 	NL80211_ATTR_SMD_ROAM_STA,
 
+	NL80211_ATTR_SMD_CTX,
+	NL80211_ATTR_SMD_CTX_TYPE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -9253,4 +9295,152 @@ enum nl80211_nan_peer_map_attrs {
 
 #define NL80211_NAN_SCHED_NOT_AVAIL_SLOT 0xff
 
+/**
+ * enum nl80211_smd_ctx_type - SMD Request Type values
+ *
+ * Used with %NL80211_ATTR_SMD_CTX_TYPE.
+ *
+ * @NL80211_SMD_CTX_TYPE_PREP: SMD BSS Transition (ST) Preparation.
+ * @NL80211_SMD_CTX_TYPE_EXEC: ST Execution.
+ * @NUM_SMD_CTX_TYPES: internal.
+ * @NL80211_SMD_CTX_TYPE_MAX: Max type of ST context.
+ */
+enum nl80211_smd_ctx_type {
+	NL80211_SMD_CTX_TYPE_PREP,
+	NL80211_SMD_CTX_TYPE_EXEC,
+
+	NUM_SMD_CTX_TYPES,
+	NL80211_SMD_CTX_TYPE_MAX = NUM_SMD_CTX_TYPES - 1,
+};
+
+/**
+ * enum nl80211_smd_ctx_ba_param - SMD Block Ack Context attributes
+ *
+ * @__NL80211_SMD_CTX_BA_ATTR_INVALID: Invalid attribute.
+ * @NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE: Required (u16) BA buffer size.
+ * @NL80211_SMD_CTX_BA_ATTR_POLICY: Required (u8) BA policy.
+ * @NL80211_SMD_CTX_BA_ATTR_AMSDU_SUPPORT: Flag attribute to indicate
+ *	AMSDU support.
+ * @NL80211_SMD_CTX_BA_ATTR_TIMEOUT: Required (u16) Block Ack timeout.
+ * @NL80211_SMD_CTX_BA_ATTR_EXT_NO_FRAG: Flag attribute to indicate
+ *	fragmentation support.
+ * @NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL: Required (u8) HE fragmentation
+ *	level.
+ * @NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE: Required (u16) extended buffer size.
+ * @NL80211_SMD_CTX_BA_ATTR_WINSTARTO: Required (u16) Starting Sequence Number
+ *	of the BA window.
+ *	Applicable only with %NL80211_SMD_CTX_DL_ATTR_BA_PARAMS.
+ * @__NL80211_SMD_CTX_BA_ATTR_LAST: Last attribute, used internally.
+ * @NL80211_SMD_CTX_BA_ATTR_MAX: Max attribute.
+ *
+ * Used with %NL80211_SMD_CTX_DL_ATTR_BA_PARAMS and
+ * %NL80211_SMD_CTX_UL_ATTR_BA_PARAMS.
+ */
+enum nl80211_smd_ctx_ba_param {
+	__NL80211_SMD_CTX_BA_ATTR_INVALID,
+	NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE,
+	NL80211_SMD_CTX_BA_ATTR_POLICY,
+	NL80211_SMD_CTX_BA_ATTR_AMSDU_SUPPORT,
+	NL80211_SMD_CTX_BA_ATTR_TIMEOUT,
+	NL80211_SMD_CTX_BA_ATTR_EXT_NO_FRAG,
+	NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL,
+	NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE,
+	NL80211_SMD_CTX_BA_ATTR_WINSTARTO,
+
+	__NL80211_SMD_CTX_BA_ATTR_LAST,
+	NL80211_SMD_CTX_BA_ATTR_MAX = __NL80211_SMD_CTX_BA_ATTR_LAST - 1
+};
+
+/**
+ * enum nl80211_smd_ctx_dl - SMD Dynamic Context - DL direction
+ *
+ * @__NL80211_SMD_CTX_DL_ATTR_INVALID: Invalid attribute.
+ * @NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP: Optional (u8) TIDs included.
+ * @NL80211_SMD_CTX_DL_ATTR_SN: Optional (nested) next SN (u16) per TID to
+ *	be assigned to DL individually addressed frames.
+ * @NL80211_SMD_CTX_DL_ATTR_PN: Optional (binary) starting PN (max 16 bytes) for
+ *	DL individually addressed frames.
+ * @NL80211_SMD_CTX_DL_ATTR_BA_PARAMS: Optional (nested) Block Ack parameters,
+ *	nested array of TIDs (uses &enum nl80211_smd_ctx_ba_param).
+ * @NL80211_SMD_CTX_DL_ATTR_MGMT_SN: Optional (u16) next SN to be assigned for
+ *	DL individually addressed management frames.
+ * @NL80211_SMD_CTX_DL_ATTR_MGMT_PN: Optional (binary) starting PN
+ *	(max 16 bytes) for DL individually addressed management frames.
+ * @__NL80211_SMD_CTX_DL_ATTR_LAST: Last attribute, used internally.
+ * @NL80211_SMD_CTX_DL_ATTR_MAX: Max attribute.
+ *
+ * Used with %NL80211_SMD_CTX_ATTR_DL.
+ */
+enum nl80211_smd_ctx_dl {
+	__NL80211_SMD_CTX_DL_ATTR_INVALID,
+	NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP,
+	NL80211_SMD_CTX_DL_ATTR_SN,
+	NL80211_SMD_CTX_DL_ATTR_PN,
+	NL80211_SMD_CTX_DL_ATTR_BA_PARAMS,
+	NL80211_SMD_CTX_DL_ATTR_MGMT_SN,
+	NL80211_SMD_CTX_DL_ATTR_MGMT_PN,
+
+	__NL80211_SMD_CTX_DL_ATTR_LAST,
+	NL80211_SMD_CTX_DL_ATTR_MAX = __NL80211_SMD_CTX_DL_ATTR_LAST - 1
+};
+
+/**
+ * enum nl80211_smd_ctx_ul - SMD Dynamic Context - UL direction
+ *
+ * @__NL80211_SMD_CTX_UL_ATTR_INVALID: Invalid attribute.
+ * @NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP: Optional (u8) TIDs included.
+ * @NL80211_SMD_CTX_UL_ATTR_SN: Optional (nested) last SN received per TID
+ *	for UL individually addressed frames.
+ * @NL80211_SMD_CTX_UL_ATTR_PN: Optional (nested) last PN received per TID
+ *	for UL individually addressed frames.
+ * @NL80211_SMD_CTX_UL_ATTR_BA_PARAMS: Optional (nested) Block Ack parameters
+ *	(uses &enum nl80211_smd_ctx_ba_param).
+ * @NL80211_SMD_CTX_UL_ATTR_MGMT_SN: Optional (u16) last SN received for
+ *	UL individually addressed management frames.
+ * @NL80211_SMD_CTX_UL_ATTR_MGMT_PN: Optional (binary, max 16 bytes) last PN
+ *	received for UL individually addressed management frames.
+ * @__NL80211_SMD_CTX_UL_ATTR_LAST: Last attribute, used internally.
+ * @NL80211_SMD_CTX_UL_ATTR_MAX: Max attribute.
+ *
+ * Used with %NL80211_SMD_CTX_ATTR_UL.
+ */
+enum nl80211_smd_ctx_ul {
+	__NL80211_SMD_CTX_UL_ATTR_INVALID,
+	NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP,
+	NL80211_SMD_CTX_UL_ATTR_SN,
+	NL80211_SMD_CTX_UL_ATTR_PN,
+	NL80211_SMD_CTX_UL_ATTR_BA_PARAMS,
+	NL80211_SMD_CTX_UL_ATTR_MGMT_SN,
+	NL80211_SMD_CTX_UL_ATTR_MGMT_PN,
+
+	__NL80211_SMD_CTX_UL_ATTR_LAST,
+	NL80211_SMD_CTX_UL_ATTR_MAX = __NL80211_SMD_CTX_UL_ATTR_LAST - 1
+};
+
+/**
+ * enum nl80211_smd_ctx - SMD Context information
+ *
+ * Top-level container for SMD BSS Transition dynamic context.  Carried in
+ * %NL80211_ATTR_SMD_CTX with %NL80211_CMD_SET_SMD_CTX (target AP MLD) or
+ * with %NL80211_CMD_FRAME (current AP MLD reporting context to userspace)
+ * and %NL80211_CMD_SMD_CTX_EVENT (current AP MLD reporting the requested
+ * context on behalf of the target AP MLD).
+ *
+ * @__NL80211_SMD_CTX_ATTR_INVALID: Invalid attribute.
+ * @NL80211_SMD_CTX_ATTR_DL: Optional (nested) DL parameters.
+ *	See &enum nl80211_smd_ctx_dl.
+ * @NL80211_SMD_CTX_ATTR_UL: Optional (nested) UL parameters.
+ *	See &enum nl80211_smd_ctx_ul.
+ * @__NL80211_SMD_CTX_ATTR_LAST: Last attribute, used internally.
+ * @NL80211_SMD_CTX_ATTR_MAX: Max attribute.
+ */
+enum nl80211_smd_ctx {
+	__NL80211_SMD_CTX_ATTR_INVALID,
+	NL80211_SMD_CTX_ATTR_DL,
+	NL80211_SMD_CTX_ATTR_UL,
+
+	__NL80211_SMD_CTX_ATTR_LAST,
+	NL80211_SMD_CTX_ATTR_MAX = __NL80211_SMD_CTX_ATTR_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5df145ab4ab1..d2cd03d8b0c5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -789,6 +789,51 @@ nl80211_nan_conf_policy[NL80211_NAN_CONF_ATTR_MAX + 1] = {
 	[NL80211_NAN_CONF_INSTANT_COMM] = { .type = NLA_FLAG },
 };
 
+static const struct nla_policy
+nl80211_smd_ctx_ba_policy[NL80211_SMD_CTX_BA_ATTR_MAX + 1] = {
+	[NL80211_SMD_CTX_BA_ATTR_BUFF_SIZE] = { .type = NLA_U16 },
+	[NL80211_SMD_CTX_BA_ATTR_POLICY] = { .type = NLA_U8 },
+	[NL80211_SMD_CTX_BA_ATTR_AMSDU_SUPPORT] = { .type = NLA_FLAG },
+	[NL80211_SMD_CTX_BA_ATTR_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_SMD_CTX_BA_ATTR_EXT_NO_FRAG] = { .type = NLA_FLAG },
+	[NL80211_SMD_CTX_BA_ATTR_EXT_FRAG_LEVEL] = { .type = NLA_U8 },
+	[NL80211_SMD_CTX_BA_ATTR_EXT_BUFF_SIZE] = { .type = NLA_U16 },
+	[NL80211_SMD_CTX_BA_ATTR_WINSTARTO] = { .type = NLA_U16 },
+};
+
+static const struct nla_policy
+nl80211_smd_ctx_dl_policy[NL80211_SMD_CTX_DL_ATTR_MAX + 1] = {
+	[NL80211_SMD_CTX_DL_ATTR_VALID_TID_BITMAP] = { .type = NLA_U8 },
+	[NL80211_SMD_CTX_DL_ATTR_SN] = { .type = NLA_NESTED },
+	[NL80211_SMD_CTX_DL_ATTR_PN] = { .type = NLA_BINARY,
+					 .len = IEEE80211_SMD_CTX_MAX_PN_LEN },
+	[NL80211_SMD_CTX_DL_ATTR_BA_PARAMS] =
+		NLA_POLICY_NESTED_ARRAY(nl80211_smd_ctx_ba_policy),
+	[NL80211_SMD_CTX_DL_ATTR_MGMT_SN] = { .type = NLA_U16 },
+};
+
+static const struct nla_policy
+nl80211_smd_ctx_ul_policy[NL80211_SMD_CTX_UL_ATTR_MAX + 1] = {
+	[NL80211_SMD_CTX_UL_ATTR_VALID_TID_BITMAP] = { .type = NLA_U8 },
+	[NL80211_SMD_CTX_UL_ATTR_SN] = { .type = NLA_NESTED },
+	[NL80211_SMD_CTX_UL_ATTR_PN] = { .type = NLA_NESTED },
+	[NL80211_SMD_CTX_UL_ATTR_BA_PARAMS] =
+		NLA_POLICY_NESTED_ARRAY(nl80211_smd_ctx_ba_policy),
+	[NL80211_SMD_CTX_UL_ATTR_MGMT_SN] = { .type = NLA_U16 },
+	[NL80211_SMD_CTX_UL_ATTR_MGMT_PN] = {
+		.type = NLA_BINARY,
+		.len = IEEE80211_SMD_CTX_MAX_PN_LEN
+	},
+};
+
+static const struct nla_policy
+nl80211_smd_ctx_policy[NL80211_SMD_CTX_ATTR_MAX + 1] = {
+	[NL80211_SMD_CTX_ATTR_DL] =
+		NLA_POLICY_NESTED(nl80211_smd_ctx_dl_policy),
+	[NL80211_SMD_CTX_ATTR_UL] =
+		NLA_POLICY_NESTED(nl80211_smd_ctx_ul_policy),
+};
+
 static const struct netlink_range_validation nl80211_punct_bitmap_range = {
 	.min = 0,
 	.max = 0xffff,
@@ -1203,6 +1248,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ASSOC_PROTECTED_TWT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SMD_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SMD_ROAM_STA] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMD_CTX] = NLA_POLICY_NESTED(nl80211_smd_ctx_policy),
+	[NL80211_ATTR_SMD_CTX_TYPE] =
+		NLA_POLICY_MAX(NLA_U8, NL80211_SMD_CTX_TYPE_MAX),
 };
 
 /* policy for the key attributes */

-- 
2.34.1

