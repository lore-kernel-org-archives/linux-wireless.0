Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907634;
	b=oLlDpvbtmJ+0FQZGit23ChMp5pL/6PO2boEPHxnVIzTIlbZ1AgI08+9HjUTBQeSQllyR
	 UbnMn+MwZA472FBP/Tyx3ZNHWeyboYcWJxkS6CKQ60TpsUBCBMkyK6m1P1Q1yjxXNBTDH
	 QFAYvCvH4/mfVowX63B8Zlavgt2YG3bZ0mUCU1+ITG7ERGIFyW2bIc9jlFiy5ZG2ZJYKK
	 16vBiQpU9XEngzWQeEIe906b2R9BBDNOl6iJ9v3Yp2FH/AOVPc2QA++6w74KYwmIEHnsS
	 psCJmI6R5i8yGSLnLq0uzkMGC6dtGFm/Qyk71/38mZnhqWmedvr1r3Zejhg9krqElAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907634;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=;
	b=XYwVj0SOKW7mxcD1we/Ry58V2qv0AJL6J38x0BFZRIzJX8HIIjioOd3X2BQ31YS8d6x4
	 a2gSNzD4pA9kxqUMuq227aiLDhRP3yIAtYPpcvyHzKClCSVt6ZGSZcX9m2q3NJxyQOWh/
	 VdFRVu/RFkOcRm+4C1WLpbCRekuY0h5cMQj31AYu9hQ0iHBTbI1APQK1rk4Hv4Q4k2qvs
	 uMxaRXJUuX6+i3dxRZ7EUkflFzm/ZzxBcyOCdkSaxnDIK+k0BlQsefppcofLjNHrBaG7D
	 c3u59a1YwRu8XnYJf9LqUmUhyOP94Q1uZp3jtBkOkbnUq221grlpj0zTQyikGj8KowA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lICFUt19;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=b0vbx2u7;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB7860A380F
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFB7860A380F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lICFUt19;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=b0vbx2u7
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5JLNVK597527
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=; b=lICFUt19cPudNs1p
	gt3LLcixl2VrlE1PW9a4d4TTh/JevYYsbggadMWY6xeFjyr5YnGM99z+4Zb+LOXF
	18sJovqA3nC9dIP4qszatqd6z139E+P8Kr4VZ0lshGsg4oUhnHGmv57ZOobi/la2
	2DpPExhHhpW5DJznqfjL28OTDd54HpLKrpPeOG/MCLy05DusG88cv6WikkVhNXDj
	5uElfxRh+0wdUmYSxUvrLJ174EgaNeVnG4RmTgDS5kZwV6Rct3GLTJ1ov/ymH91N
	u7anRA4H244gUkrmqYPOJqrBCcksjb3G+GTdDBcQdrdAvuaYPvs8VxhTgEUk6nB2
	CQ7j7Q==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hryvv02sh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:32 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36efb506f29so667798eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907632; x=1794512432; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=;
        b=b0vbx2u7zaWjyNj5BT+VuGMj6i+4a5VBSEXKaOK5ukOKgnDHH11+mVkxEdjtIXSKZh
         xGuBX19uwN4kDQy5geku3gACJwAeY4O2EciQV14nS/+l5yMku+3LsffmgF/13t6veSxG
         39/4al/+i9tgtxrDET7qA1QIioEMWr3sapFxuEnKZNcbvVQzNZ+A14j5t+r5g6EDVHGt
         k1QC9VxQeRc0XTMdDejzVXdMosj5EY4O7Hbm2sPIR4AhcpC5RNF5pqm5jgz1+zdEGjlK
         Ifv43W0J3Ry0BL/+8nFpMCgGUp0uL6ig+5Pmom++vxcR6+r2OSDWS/Oh3dyRu2Hn+iym
         NQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907632; x=1794512432;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=;
        b=N+jgK8duVDXE2eyMDp45DUZuxzDZBkKjPDVT1RlV9xdlKDYCWIubw1IwwRe2pbie6/
         FPJSdqBxChqBpCFxQCv98iVP+F8BLEdrK6dsz0A1wFWOaDEyVMgEAnBiUiwq6QzPfYUC
         Jk3n3MlXHlGY4J2UzfBwGOCpQAcZNgJwvGpdpqme/AA3QGpWhxhHfocT9QsuTd7ApQDF
         /hJlxrkrf7LszVWZb96XXz0RHEYTUoBsIABEYrSNYXaAgV09KwjWJ5LzssJOd5qLhfR8
         4ozdD3pc55bg64pdnz8vTsjlf2ZHT9igNg2GvqQwFpLNaXZMzGodqbI9VQ1BB0oZodPE
         244Q==
X-Gm-Message-State: APuU4Z9QbQ6/uPtwKDDK7VEv7t5x6rktQVbIiKHcaLiTBddsxLGikKGI
	BFZp5a9FwP9g/F9zpj1PjSSbR0UmlUs0W3XdRNbUiOfn+8MQx7HcYyFfAO38eQ+OIklGXMr7DrS
	N7YtW9EmSLv4MojzAPm+5Fa8DPCA/a4R4BwOdKYqihwIAG6BzGEcdrOSNt5nqg+q6RPNW
X-Gm-Gg: AYBFou2N75xUTKIxh4TXKAEJ4FzKnfWvGzdvHANvWuRWf1rnJ3lpyzscQM/XM43MNuJ
	HiUwsHw5WnGuvt+jLV2H837/9aeJO54ObBCf5SNIj1ywVg/AQSNpWs0NdXJpXBTCswFfSQ+c0V3
	FYHgesNQd2gRKu0VK7+93D+I92RVGNU+OThs8po73C/mktttH/eRerukIMtwWyM1JuJ2rXzHPT7
	KSTFe3H35BMjfO/c/sdKi1TSpZTapVAJw/a3zSwT+OPDjFa1BRI6qnj4KcjpT5c+R7IF6xZjtnc
	ekxofjSBqec79nxcXOmOKFa6xzf556VzvMO5bmFhRncfw2nY+W+PTkG+BqgxSa37mvc4GgXIcY5
	YEti1SU/OsEjwuoKe2dXJfTeaksS8KSftQLF/kC6itHxg3jdlbg3Yw+FCnHKA5x4ptyKo9p6ri3
	oILqzCu6YxEyXtChHAaU2FoYj4TFnWr7LJ0myonTGGy6vKApR9lNV0cUhD3Iz9kEV+TWceYw==
X-Received: by 2002:a05:7301:f8e:b0:36e:3a0a:2953 with SMTP id 5a478bee46e88-36f775f83f4mr152684eec.41.1793907631557;
        Thu, 05 Nov 2026 11:40:31 -0800 (PST)
X-Received: by 2002:a05:7301:f8e:b0:36e:3a0a:2953 with SMTP id 5a478bee46e88-36f775f83f4mr152653eec.41.1793907630996;
        Thu, 05 Nov 2026 11:40:30 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:30 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:41 +0530
Subject: [PATCH wireless-next v3 06/21] wifi: ieee80211: define APIs for
 UHR Link Reconfiguration frame checks
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
Message-Id: <20261106-smd-v3-6-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX8uj+Bcw+1YOc
 /BxMKRDxRhc6rtj2zAiaXNY7VazgglOT66FOhI45c3ryZXugucw7dn0lwgMHA6pTSNVh1mHwzkE
 OEVv6c8EhhAo+Gx+FMMk61TTR5QgCLs=
X-Proofpoint-GUID: gSfw8UwV1muyPH_c78aPJKxzgSma9QmE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX0fU/WUEFhoWb
 J1Pv87WNdnIr03D63RWkgyLFasTImw1tixU5PzxnzaWDtDp3QSfQhMYVT8iMFNzXz/vDnOemmZt
 uOE5r4U2rKY25dhhkLxCzyU6SisarBQ0WbhxGMmqM+o9STUtsakW/iqoFPsw3yYsPNX3ztd6kqL
 1qWvIEe/8VgL4Jdi53gISToP51F/hImu5hxsb60+9iG2MPvntPpXKIwfC1T9S30xV7IO93IT3gR
 WNGFjYb5bBevLM+kpCqwPKFNJat01j/BCMW2mmQyOxZY7Zafa5mIAMtb8/BLi92e73jOOb6v6zw
 z4a2s8F0Q8ubv/I0VcGBGVbHKWcoLnlEDaNBfLOYnA2WleEvXqOvt0h7e82JLd0E62yu3hRAeOK
 2Zn+/YKccgtWNprAes01+Ssno+Fbc9FLqxEQfHtM7/LgG4pnQ10QbZfWmQ75Vqnechh7jrLod7v
 ZvXKHAldRXC2YQYBpVw==
X-Authority-Analysis: v=2.4 cv=dKUzC+Zb c=1 sm=1 tr=0 ts=6aecdbb0 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=oDYSrMgdSjg_aXkkWaUA:9 a=bFRUnEHUPHmmGGYb:21
 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: gSfw8UwV1muyPH_c78aPJKxzgSma9QmE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

Add APIs necessary to check whether the frame is a UHR Link
Reconfiguration Request/Response/Notify frame and subtypes to invoke
necessary SMD BSS Transition handling on the AP MLD.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h | 125 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index c6c89e4562f4..9274fa146f01 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -699,6 +699,131 @@ ieee80211_uhr_mode_change_tuple_next(const struct ieee80211_uhr_mode_change_tupl
 	return (const void *)((const u8 *)tuple + needed);
 }
 
+/**
+ * ieee80211_is_uhr_link_reconf_req - check if frame is UHR Link Reconf Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Request frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_req))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_REQUEST;
+}
+
+/**
+ * ieee80211_is_uhr_link_reconf_resp - check if frame is UHR Link Reconf
+ *	Response
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Response frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_resp(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_resp))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_RESPONSE;
+}
+
+/**
+ * ieee80211_is_st_prep_req - check if frame is ST Preparation Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Prep request frame
+ */
+static inline bool ieee80211_is_st_prep_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_req(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_PREP;
+}
+
+/**
+ * ieee80211_is_st_exec_req - check if frame is ST Execution Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Exec request frame
+ */
+static inline bool ieee80211_is_st_exec_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_req(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_EXEC;
+}
+
+/**
+ * ieee80211_is_st_exec_resp - check if frame is ST Execution Response
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Exec response frame
+ */
+static inline bool ieee80211_is_st_exec_resp(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_resp(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_resp.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_EXEC;
+}
+
+/**
+ * ieee80211_is_uhr_link_reconf_notify - check if frame is UHR Link Reconf
+ *	Notify
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Notify frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_notify(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_notif))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_NOTIFY;
+}
+
 #define for_each_uhr_mode_change_tuple(data, len, tuple)		\
 	for (tuple = (const void *)(data);				\
 	     ieee80211_uhr_mode_change_tuple_next(			\

-- 
2.34.1

