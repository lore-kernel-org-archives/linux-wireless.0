Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907630;
	b=mn8kcepmFX+pAheqdWgCw3JqRaVWJcb+oBajYaGCtXTVpshWu122Y5DJBWmQBGE3Un5W
	 xySe9dVGQ00zHLltoSLLbvhMLqHNtNwTIzseg8ZSICvx2s6uu2RcRVWxe6nS2aB62pzoO
	 amupdpX3uoo+9YlMqUxVGbQvI+YHtcm6wfXNn5GsF7cMy420OqYy+1G6sAC+2hSrDAIsS
	 wuhKc3BRrvOx6tcplpg2hK9SOQp47cknhbaPRnnmkPwB+mq1kxtVBCVDfz+5Wquzl9Gu+
	 3yrHZRh+uHr7OmcHLoHroNWUkdCbFiZHUQZZPgz5beu5AR5ng4m3TdcTr1iCv089wpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907630;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=;
	b=d6v+oGqwnrqPOy5oXbxlTeedIGS+Q3J1mZc9pAi1uFbXmqzdtoQetYwxCSXEyrBHwS5C
	 HOhkunmojUkQdIvvjCnBscLGg5yZ5sudBzGDOuYbf+wggGXYyHax1kLlGvoBdKkuzv8JK
	 VEY5QUBzVWQmLCfFlkiqovrXFCejHolML/cgeQZk2bNeGMzqdH6Pa4VrE4a8mQjZ5oN3f
	 8G/3VRKjwY2AMzYkjJjho8Zh0HyprUDjDCymzJWmRmbjtIgqm1kvZJdgSX1yGRZ5/zcAj
	 fS2dJQqVj6HZBIZZITdbQPD0gep/7tllV094O7I6hommAUPNbzYvJafRqZUZ4ifGDTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Bflba8CW;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VZrQvME8;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11326075322
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E11326075322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Bflba8CW;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VZrQvME8
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeEB41474583
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=; b=Bflba8CWEPdoabhA
	R20jruyw3xnOBQe3HDRGXH3cg34Bqd00IRrTY4h/Oj2OmQWMYndrLUT6WZGN7CXF
	2hiAbiigaTsZJezGgL/3r63kvl1PawqzazO2JfKydYLh+67K0owBcMzt9jmZFK8x
	rhp3zM8o0+XElR251qsgq1XJdTwvxSbTjMJ9Rui2qAb4V4LffO6KtPhPrBoDC2pa
	Sp453QkOACPvZP7WEMC9Y182zz40kt2xSeL1KA5Rv7v6zJesUckXaEin/RfGgywJ
	5aIzT0aYM3MAFzjFOW2ps26nZ7uEQZjkFwOwEzt0FX6TdTQh9Lfkzz3I2wa/sWi9
	QIrohA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrmcdbfh4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:27 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33713e5e6daso2632051eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907627; x=1794512427; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=;
        b=VZrQvME8YKsviP0NosXlQ2JtIWIWCgOHExzTQbsSbJLDsY3aC/fODQht8SI7n2mYI1
         HgEtfzDCIYVS8Bij5IjKfhWHsNbTRUD9zljRLxcd/AKZk1CaYVdWu9lh0tZVBzO7uhDW
         OV8FBZx0YKMA+1BC1QHsYZ1C2tG+I2CblhTPV6XYfqor9HI8BRnI3qvaOn8gw9AzZXJX
         0cmMfkPy80cE+/wCQVQyw7CSPAEp8cWPGXIyn+zUGHZwo5wDzInNZQ37HeiUzqSTu4si
         +71n5gOZF5e5wGYAtbrm5Hoze+Fhg8sf8ouUWTjBvhauVO4twL837yq4JEi3QTyS5CKP
         G5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907627; x=1794512427;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=;
        b=2YxVPzAqORJglgw8xR4Rv7Ru/t9KgY9zKRihF8ni2FMgAuYy+A9Crdu7T/4dPzdFDG
         wJjOUH1gcjauDO0d4E+j5O1OoQSM42I2vx9K+2HrFIe7KlexkbWQKuRkmCcpPZ31IEHL
         waVVS0OQYNzgdOqay8JYOA4OSGQAAdcrfEjsARnqxObSRaNsx1Vu9DaEAObjQESHLBR2
         HyeQIfRo3uEOEUIDcNOSid4HJ3extovVXb2NSVKVwAO/SdnzmreXWSS+G5JejGRWNAXR
         LzI/vzbgcLj967+mlrJpGziGur+6AhlAATJ7F9LCPQLQjKghweBwkXrN7mRtWDUod8Kb
         P9cw==
X-Gm-Message-State: APuU4Z+8664AZfmlas7pI5tVFnYs5/sM3q9qdfIs3u3KscbwGmtCieoc
	p5xwVPl3qJzMrxIKjxICgmdUAdMYp8yoo5GWwzEhg5+gFqiHG9NH5TYmT8pHZoovOsSChvOJxRP
	xYn1//wQ7Igtkogj3u2+Mm6CZEGMUgDsafyNT6GbYM0Yy1qQtGkgXR1kpXVaMcW6PmdIl
X-Gm-Gg: AYBFou3TiPfrTOqz3bPEgE9DgBWklO3kiNmcffTtK1Vy+2/lf7yuYWWMY8gOe4UhZHV
	Q5TojMuaWxLgLOGHL/MGD1tX6GSvGuH3Pz4ewuvxbqXVjHD4tu2ir1SLBxkOqqxODQWhyJ1lMVA
	I5mE3RbISeZ35hj7tuk7Y/DaMu2UknOnPazQKM82UzPl1hff/GKrFSYlABQS4Y5/HrYAGWhc/EZ
	BTonRtEepkq5DABQHBLpQa+mf3l61N1l2TVCclZsmoFuOuuQp8Nw16wkgsL4yiuI4DXtOs2uZjQ
	tLrIPDbBf0fiLTw1lZEHSY/bitdMHny1pQOGOjEf5wGXoI2/aaOgovEJuerAuNI7iHiE0DrgqsW
	jlKLlB4rfpKPvK6wHbQhw99pKsvkvtKn/ceEdySI1ZX0OmcqhGmGTrJWuP7c+D3SJZqLa2yyKTl
	MvTgM/tekSdoWA1vjcfXkJkpUuo1MRxFi6JuIgnam1GvTr1aobfunYNh3+S8rEXur1s1L4LQ==
X-Received: by 2002:a05:7301:d802:b0:36d:2704:6adf with SMTP id 5a478bee46e88-36f7494e265mr157920eec.11.1793907626577;
        Thu, 05 Nov 2026 11:40:26 -0800 (PST)
X-Received: by 2002:a05:7301:d802:b0:36d:2704:6adf with SMTP id 5a478bee46e88-36f7494e265mr157880eec.11.1793907625975;
        Thu, 05 Nov 2026 11:40:25 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:25 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:39 +0530
Subject: [PATCH wireless-next v3 04/21] wifi: cfg80211: define layouts for
 SMD BSS Transition context
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
Message-Id: <20261106-smd-v3-4-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=EOGTQFZC c=1 sm=1 tr=0 ts=6aecdbab cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=J_Cd7DG4o9UVoa3JfjsA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: u_8_zc5y4bhv5h0XkM4iU43RDZ9uNj1W
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXzxYVxgqUyrIn
 fhzUUJw8fCqKYvuJithSJj0k5AAeWCz+axT8kYnMJBkNtEjx1lCDV8lpLWF3kxdDyZSdkQibtE4
 zTSoZgQVnQmA7lSmdRwmLNKrM5KJEB4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXyAmLN59yQSeN
 hYyblLS8ohI/uEpnJRCtUJafkysXPcMUHFhHcviyY6P/HpO64xjEW4aeZdi+jVUQvEVWFiqb+kW
 iFsRk5MW+gdmFblFx/xg8g0mMobi0d3oN4SZEHHzm9EIQ3s3haL0izKC4cJxlHC+lqJhgaPiMC6
 WUpsqzWieVLJbhULvq/HghfqkwwGUYTtzRhSKgr3dsfbeWOgo7x45LJQ+Psa+oIKjTre4O5NkKQ
 yvzA7b+FgFAgagvt392HFoaR9qmyDAZeClH96Y93dJbTGBIf6PxPtDyAufPHVAA+XC7vuNZMW0I
 wnBqINX55eAWZPZ547IGAxokwqPx58uK1SNe9PUlta17c7mJxUxEMe7SHmw8+2JEyUIFN6hnZte
 ufX6rjxbZG15METUJbEYVy7GssG+1oFDIHsaEdZfT5XxwNX09aXGudmrZUqwhJOSTlWQFRxSXlQ
 Y264Zx9DqGt7ZnqxZ4A==
X-Proofpoint-ORIG-GUID: u_8_zc5y4bhv5h0XkM4iU43RDZ9uNj1W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050078

IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9, defines the context
data to be transported during SMD BSS Transition (ST) laid out in
subclause 37.16. The station's context data is attached to the ST
Preparation or Execution Request action frames so that userspace
receives the context along with the relevant frame.

Define the context data: per-TID sequence numbers (SN) in downlink (DL)
and uplink (UL) directions, packet number (PN) in DL, per-TID packet
numbers in UL, per-TID BlockAck session parameters in DL and UL,
management SN in DL and UL, and management PN in UL. This data is used
by drivers to report the context along with the frame SKB.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 54d549afd8e3..938fbfe0e71d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -11147,4 +11147,86 @@ void cfg80211_incumbent_signal_notify(struct wiphy *wiphy,
 				      u32 signal_interference_bitmap,
 				      gfp_t gfp);
 
+/*
+ * Context information carried in SMD BSS Transition (refer IEEE P802.11bn/D2.0,
+ * Aug 2026, subclause 37.16.9.
+ */
+
+/*
+ * Data TIDs transported in the context, IEEE P802.11bn/D2.0, Aug 2026,
+ * subclause 9.4.2.364.
+ */
+#define IEEE80211_SMD_CTX_NUM_TIDS 8
+
+#define IEEE80211_SMD_CTX_MAX_PN_LEN 16
+
+/**
+ * struct ieee80211_smd_ctx_ba - BlockAck parameters for DL and UL
+ *
+ * @amsdu_supported: Peer's capability to support A-MSDU within A-MPDU.
+ * @ba_policy: BlockAck policy (0 = delayed BlockAck, 1 = immediate BlockAck)
+ * @buffer_size: Reorder buffer size from ADDBA Request (10-bit, max 1023)
+ * @timeout: BlockAck session timeout
+ * @ext_no_frag: ADDBA Extension fragmentation support
+ * @extfrag_level: ADDBA Extension HE fragmentation level
+ * @ext_buffer_size: ADDBA Extension buffer size; combined with @buffer_size as
+ *	(@ext_buffer_size << 10 | @buffer_size) to get the full reorder
+ *	buffer size
+ * @winstarto: WinStartO of the BA window
+ */
+struct ieee80211_smd_ctx_ba {
+	bool amsdu_supported;
+	u8 ba_policy;
+	u16 buffer_size;
+	u16 timeout;
+	bool ext_no_frag;
+	u8 extfrag_level;
+	u16 ext_buffer_size;
+	u16 winstarto;
+};
+
+/**
+ * struct ieee80211_smd_ctx - IEEE 802.11bn SMD Roaming Context (refer
+ *	IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9)
+ *
+ * @dl_sn_valid: if downlink (DL) SN Transfer is requested or not
+ * @ul_sn_valid: if uplink (UL) SN Transfer is requested or not
+ * @pn_valid: if PN is transferred or not
+ * @ba_params_valid: if BlockAck parameters are transferred or not
+ * @mgmt_tid_valid: if management information is transferred or not.
+ *	@{d,u}l.mgmt_sn and @ul.mgmt_pn are still bounded by @{d,u}l_sn_valid
+ *	and @pn_valid fields.
+ * @pn_len: Length of PN in bytes; varies by cipher type
+ *	(e.g. CCMP (6), GCMP-256 (16))
+ * @dl: DL context data such as SN, PN, and BlockAck params.
+ *	SN and PN transferred are offset to reserve space for DL frames sent by
+ *	the current AP MLD so that the target AP MLD does not repeat them.
+ * @ul: UL context data such as SN, PN, and BlockAck params.
+ */
+struct ieee80211_smd_ctx {
+	u8 dl_sn_valid:1;
+	u8 ul_sn_valid:1;
+	u8 pn_valid:1;
+	u8 ba_params_valid:1;
+	u8 mgmt_tid_valid:1;
+
+	u8 pn_len;
+
+	struct {
+		u8 valid_tid_bmap;
+		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
+		u8 pn[IEEE80211_SMD_CTX_MAX_PN_LEN];
+		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
+		u16 mgmt_sn;
+	} dl;
+	struct {
+		u8 valid_tid_bmap;
+		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
+		u8 pn[IEEE80211_SMD_CTX_NUM_TIDS][IEEE80211_SMD_CTX_MAX_PN_LEN];
+		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
+		u16 mgmt_sn;
+		u8 mgmt_pn[IEEE80211_SMD_CTX_MAX_PN_LEN];
+	} ul;
+};
+
 #endif /* __NET_CFG80211_H */

-- 
2.34.1

