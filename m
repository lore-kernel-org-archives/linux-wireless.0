Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951979;
	b=oXkSk886uEFJM1zKuZqHuUv/jRlVncDiR1dI+ImSOg0UXL18CCeNAWlxzqslbytuSBTz
	 S7Wt6DjvsTt+vjBnKAyFebVwUwPE2udkeM5SbKEzdA9J8od1hxSesXCI6ckOtUNCiL6H3
	 Q8vEjPAOObkkBNHAzm+3YTwr4MA/o5CmOgdK1wkJHAGyChKElITY8hqbMVa9V/ynDDr8d
	 olIV5WfZ6HYZWlT3szYmjUsdFF0ODSQxqWCH59iyYzBrcTH55A9HZANUplKSHFVhwlnbr
	 FZvQeYEZMTB0ZVL1cxr96fUS0XwN70itGHq/mZNTJmMve0K4zLkGlP5K0XFMrdJdfog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951979;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=;
	b=qEpdUBeBripdMz4NUwMHFXE10QXsK2oaCL8JrOX24hEYM8DEb5zvwVGP19ldFp2UQKJJ
	 JM8buPlJYB+/xQQgF4KjZmEZPk/bU7pXo2Xk/RkDiN16Q2xRH/ToA6elQCn12oxOSDscN
	 p6E8q60qGeIZwwCUW05nRe9BktxF1AerupKov0iyiCdCpMRPn41kf9QQ5OpezrQcVyZmA
	 S86vP+4w5QJJXSrp6FMvhfID760tqdWpLHWoWUrzK7VQLNncy9yJYLw7veodG1V5wOLl5
	 6XCrnsHY8nsF7yOXpHUI2Jqv0tYqN5z9QSVwO46nGigjn75EfMoNHUOPZ/EEII4LXSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLvqAqiu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VeMzaBv4;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1860F606D82A
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1860F606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLvqAqiu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VeMzaBv4
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67R7vx3243885
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=; b=FLvqAqiuNtzOEt5Y
	eDCdwoeoEL8ttjQdTMHqi7CJT1fyT6mO0IhmA/CXl42LL84yNSqkOy76rdAOM9hO
	e5ERbR60JY54CZQ/KinvGA6XuqSU1Z1W0J8QEXYQ4X2INuw2abcSE+ODrthdmZEI
	MMDj7Z/f/VBhDInWjIPWHbwp0ZiehshWXFWdLSO61LdanQJN9RgWuYXG91P3/7Fp
	OojdJ3GSlju8F0UyPL75tDr2OKa7anRw0/p0B7uOTUow5non/VRw5HJlSSq+X3sI
	jcgUamZ+GQ3r0xPliP48E4bzLGPfakVqzZ4or3ZkyX9LbTTYcQD/uwaDXFFy6jfc
	ApP0ig==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1pj9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:38 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae7faf4ff7so627986a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951978; x=1794556778; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=;
        b=VeMzaBv4YXpDEy38dP6/APvKW7eGbrbOpuCVozPKU5vHmSH/75pe0C34pndcbcwjn+
         vv5/jtLNaqUV1fCyxh382fU3SwyfTFeAczybfzn0TzttznfKbHkkf2GkQRfIslo7Z2Kf
         PRrY/xSaIOMfkiVKPf79hOP5t1ArawwVNKi2BBTItTxzaVyY0kUpH3Jb6BjCgQDQ9SfF
         ml8c2fytMUiiTSbs9Yb4Dixzn2sz849dAohxZOFDHZmW9n/lFZDkaNt3JR7AhVqvBq0e
         5eRmGG2zhInO/O/mSXbvy90P14b2BJqPtVWZEXQNfDcYUz2mE62N2NVWxecx9/Q4ij0h
         I8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951978; x=1794556778;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x0QQjRlNHP0O5PIlx1OdLW0gzdTLxrN/TWp+snq7vsk=;
        b=ZAe3wdztSAdNW6ILzkwkQLPzGc8OHxmqohWaUvx7i9xc7MiT+Q2+wMEzKg2ah75WnR
         a0HFhB43FxS64xj++l2jjfE2xAZd5i0qx372eo8/BQu7x4DTWnxIxO+5A1EI0Zhn79Wz
         gZUhp6Va/k8oun0NmDtg2uEYybzhV2F7LwYmrA/SjY5QUMlY2CBEaaw1f4TBSa6kT0O7
         GGgazxrJfVI04ZjbDl5soHXLIpx7s1WsketAV5KJ792huTP0r0xGdU5Avw6CL0pG2VF/
         3CJURtqjpwvgzhG1xCwR/EyP5VjfmvqLMKCFpzcYPRoRNk+XTc6EG2wfDXqVEj/HK52i
         jy0A==
X-Gm-Message-State: APuU4Z+U4cAxzadu7AL0TcK04nDw7NNmNuA/fCTIzFmac5BpLDj9o3y5
	DbipvcPBLxVE5IKcqKP4AYOyiR8TQeJo/8KhgkaTC7ev586U/Ivzf4mBzOVGVcWchwYroLuNYgx
	9w0fUwf87E0GXcqx8uBgcy4gQ12/C/NLW/2ZYlgwu/P3i6o6SEItzZCipBfMS3lGQgRPS
X-Gm-Gg: AYBFou1bqDltm8a+qoZHtIc9S/wG8TR2mMSCAv+FepyNoTOGNq+X72fBPI+uaIYXmrZ
	j43stJb0RR8qe6KZe4HhBUYPA/8W9ou1kZ1T9QO0RlN3zppG7qgGPcCx6rPP+X6NP9pAn4xxekz
	2B79883DF7qMRDZXRqdE79no8oTPOKozgDCn0I9k7qNG6KdNwxd/pbdZg9M+knB2vo0+vzJ94eB
	exky5G3M8/eoUZ9ChcLkG8v2jw6cByCI5TVSer5eAZB//HQRLcGeAe6Lsp+LlRJIm1ZE1Yw8eOV
	BCMEQ7Rq3uzkXTrZqP58Al9esuNZl2L7F/mO2KiQLfr8rzr6Bzbp97DWv1sGoQhJnTx0x++YhZ+
	TgGwu9JyUJkS3atjDSWdK0M4r5NHPoDs8r+5YCBJcozRPZ7jHfe2tU9j7Wxg9d4Q+vx8TmhoWDE
	bT7BVHISfco6ocIJ15+D9fjbbZLTmfXpAKjJXIdKPZ0APgpRvfKiTE2+royyTh2nSiHBJutx8=
X-Received: by 2002:a17:90b:48d2:b0:3a6:e99b:bbdb with SMTP id 98e67ed59e1d1-3b0db705314mr1562212a91.50.1793951977300;
        Thu, 05 Nov 2026 23:59:37 -0800 (PST)
X-Received: by 2002:a17:90b:48d2:b0:3a6:e99b:bbdb with SMTP id 98e67ed59e1d1-3b0db705314mr1562189a91.50.1793951976722;
        Thu, 05 Nov 2026 23:59:36 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:36 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:42 +0530
Subject: [PATCH wireless-next v4 05/21] wifi: nl80211: define interfaces
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
Message-Id: <20261106-smd-v4-5-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=PLeaavqC c=1 sm=1 tr=0 ts=6aed88ea cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=A4pAW7IlmD6AYZ-BFbAA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXwc59qymlXVQ6
 auJ1HRoLkViOcD970zy+SOPoJLFXzM0SgRHGChl50nH2AjMGBO2fOHEs1ftRusZyMeLtMlLBRTT
 /hslvGnW1vTkUGclk2MOa9MWwI4bR4U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX8y403WoXUqzV
 P8ReYwxuPMpflyRRD4tekmX0OTii6ENTkchW7pR6Ns2knZ+MuYodaZJjCtPOaFB21B+m4tE5adN
 xZ41yeQeFCLVNsXIvTNmAie6/qamT3UiZT5qG7C8mRw41wN+POUlHc+2/NxcwvWOavUYqwtDNFS
 VYkanhNNA21UUqka3arlQUDmPq9WO+KWfn4/AO5OUAM06YeyfnOffs+PpP1Wdy7EAW/1B0ELG4C
 r7m914uoD7zAhfR6fzVWfBx+2dDfa7UsaNAkf2PcD6aqqR+omrK9hZs5UpqytTzmdCOKhulMKSr
 7D0MV+20cwU+QeI6++j4hBxxRwPba0zPZ1mXDwywF+uZL/tM7LNRcJ5TeKpJ4ykOY/XGGkohAXQ
 wB7r9gGY5CZ28K9CHhsC2AWgRtdpLy9hS23QR4/nuMI7EUvznB46SFVPpHqy2mzrqwE+YZT4THS
 YSrOUloRlm2ykxeGP9w==
X-Proofpoint-GUID: cFau0mo9VzvvpjFl0ftM4xUNOKZ1plqJ
X-Proofpoint-ORIG-GUID: cFau0mo9VzvvpjFl0ftM4xUNOKZ1plqJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

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

