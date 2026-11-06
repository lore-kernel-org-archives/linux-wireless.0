Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951977;
	b=CvHm82DbcwpXBBJm9DEFw877K5tsX0myoRmCx58wFK3EQAVnHHrnqPG0he265Pmw6GRI
	 WmBhvL6tSfOspSUZhxjorhtNFrTMZ8MvII3t/6aXP6OUXT/ZAhw//VkllDQkOEKxogVYQ
	 LFnXFKT1v8s4HgOrs0aPlE0uN9BQK6+Vyq82GQZI+qfGWS4xyHMc71ZT+SRujYayDRnK0
	 yv5TZBH/9jDYpMjpAEEvG0uggxkFzxmtSR6Ct3YjFzPwm9b/IpmSvb+MapMPFqjiidNsB
	 lTKhzplxUKddUze45lcbKnayRvXU+2d0vgvOxsHCyfzxgLP8slIHlJAjx/Cwy39cY1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951977;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=;
	b=YIQ1u1f2yi8lYzUeQOrPaKODhGKuNtFsN9kBbzG2HPnbMlne3Yd0O3aDUmCShK9P1N7p
	 LM8iT7JAAtDX8VkUMokaw/7BpBi0VMUSMTx8Vcol50VjvKR5PMvuihQJE4Y2D9Z3Evlgo
	 hIPHur+8KfaXknMsaCP8AblfDInMhJ+PW/BNpB6YRzX9GcG9Eqqdj8+KB1EmkZ2jJkh3N
	 4aOZqT7UXjWgyjqYGd5SVRgkoY23fSmVo+bhaI9flSqvysHh5xDd158gt9fnxIKuRKQ9P
	 UiEeIuUywIjwbdBuAdNalz5Xy8wafCEMwFUB0JPguthBfL4X7hlwZFJb86ssx1fHX9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="bax4//5r";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KtJ0AVEu;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2F6606EEA3
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D2F6606EEA3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bax4//5r;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KtJ0AVEu
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RQUH3301565
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=; b=bax4//5rv231+xe9
	auAT1UNUzmeEjsz5si5TuaqIRlHCNDuNvWYCnPQtkQyjp5ZnooClH1MK63Wb8cyQ
	wOBuoq36rjrhrwVA3r936jNatK2HX7QCELTqeH2hN4yWr2Jms6/tqUeX+GjxXPnS
	3QpfNAGODhri3JVpOGwaRQgMnfCruGaLuRtt1keGHWQwFNEIN+o1+8d47XEDwvGW
	94KfW5C0M4x8WPgIWne8L+iYJSGlWZW8A61/iArejkmCoQriBT2NE/HDphUfrPjO
	pAlz1wcerafysjnrmJaUwwyQTPjY4OuNSMUy/mmJiE7Usnj3Es71AdbCrknrcaY5
	4x/A1w==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1s9m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:35 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b09a466295so366073a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951975; x=1794556775; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=;
        b=KtJ0AVEu/QEhEee/aHo0eFLkrEZpxq/qj/2UZa/qqZNlhASZh4b6VjdLpY3klGQYUF
         kvkc/If+Y+7mHBSZba0quaR9KaXT+/40qNiczAtdbaL2P77JOESkrhNkOXbf4fylg8MS
         8BVcq0i4t2Uw78+tMSx3iPvOgdsQhCJG2mgoHB3ax+pCcRRkqI6wz/NY0cufe0XDe0bK
         XMcHYr2wdVIOaMar1PAP8ObO6lWo0XPIiIEgoHzs9YNcJT7INtAnoBP8Mryyed2rd/YR
         pHzGwPnJrNzJyE0fNpPw9QwraeV6PKFVXpz0BtUYrCjtEQELzUAwqj7/AuUKDxWeXqpO
         pnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951975; x=1794556775;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+2GmO7PaqO9tj08Vy5ZqyiEv2TnteeQzM548W4k4ww=;
        b=hbybUoqJaxQvLBQgc94O+PUj7HbTK0m3UXr6TCsiFh9zta7Xa/bbUr2+L08uBWJNED
         mi/GMYpv6tf18ErGeXGbhBaLhEUzrNN0VgXPHQ3A+6G/Igc2axC70TX26gXVjXCh050P
         rpDutewpsXS8q8hnzq9FuLJFxkMr9C0mywcYCWwUQ61TMxws2WoaVSuVMc+5Oo34wTkm
         r2g4cqmAm+PxLsPMXSvql3FxV95fCcDi1ECh6bwlXgQ+iSrTanmV7+y4+Jzd1sdXLkHw
         Ir29KTP6sCmMSyA/86enaz7Fu0wJmKa6esJzuRM2VHjT1Dltkhsx94rqluRAjeee30dK
         AbaA==
X-Gm-Message-State: APuU4Z+EvYT+tj5iytStlwFAyqijX5pjH+P8FFrrLWpf7aKCz2d6bjt8
	ARgnEUtsH+nhywYSwedSqJLPJuENNbdxCzvBp5wg8yDzSvaA+9AwbFDltrytmRSyi9zgO1TTmbh
	98yFi3TXy32msJKoXE0FXRq3Qu8UHi8aSJTPiE6CdrqrPzCP3RTbnNTCaMIrGAw+N2Ad1
X-Gm-Gg: AYBFou3O0VOGvZqASC+B/ciTTJ3e+96cg/lEAF3mxQFlntKXiTDbxymCLgA5U70wFR1
	QG35kzkt0tvr1PbqlunqfJn7cz484JEnQR/tJ/o8Vcb9WVzJ+gzQbbHL6eDXfIfHKwxCgY+Obgf
	LTjlbn4iPtpQFFUnSxHy3MKIer3uKSq5ECXrwz5D6MO7kN2ked+tJ/ELRCxuImKK3rG8Y6VzdNz
	c0V2HB2R0BeYD4QAGRu/yjYYOTmh9t63dpEvAl2jEC3a490THxNCH3IQFVN4/VcIjGAvZ1tWZZ+
	DUsqcc+Ooh+uM0JMOJc0Sq/pOAmYJbnGCW9iowPCMFKaEzs+CiryRmtCLKziVgHjdXRPxNasgIv
	rC0l34qd1yNEq0h+pQE6TqlKtvXCwSfGCHPOAQzjgLejG4LH56MpSAOYU7F7u12P9mcWEkK4PM+
	fgptplR1i8wA3vucH1W3O6bnF/hA2qfidOuOn2+JARBlB2ey6vdO62OsDiPaJM08xbTYZAc9Y=
X-Received: by 2002:a17:90b:1a87:b0:3ad:5c64:c7ae with SMTP id 98e67ed59e1d1-3b0db718899mr1666256a91.57.1793951974855;
        Thu, 05 Nov 2026 23:59:34 -0800 (PST)
X-Received: by 2002:a17:90b:1a87:b0:3ad:5c64:c7ae with SMTP id 98e67ed59e1d1-3b0db718899mr1666236a91.57.1793951974329;
        Thu, 05 Nov 2026 23:59:34 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:34 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:41 +0530
Subject: [PATCH wireless-next v4 04/21] wifi: cfg80211: define layouts for
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
Message-Id: <20261106-smd-v4-4-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX3uJl97QbVW0a
 1A8VR0/2vuEKZG7dyuj+T8rt0uT8DM44Z7+JB5xkTb0e8T5CpQHe6QTj5oDqcXofFXCaOj0Quku
 aPXGEhoqE3gl6WD19/kbnrroMbge61rucger9LJlNwF3G5/iE505m7ItoZsFSUrdxnKKAf3mw4c
 DaTyplStM8B4AXNsan+hr38igG713i3Ni07t6kIpeRVF11ByDeKQiNRslRxkcCOCFjt+W4n3VY/
 5TShV+fGzvrVtni/fFIChX7/pSDwmclcgq+80G45Sxnvo8t5IUeWyvo//E46DDvy8bhgHDKgb05
 KYnx/vY/kAMnFo/on8b6+xZIbIitk9a1JTBegnkipmi9+p4+1oW5e3Im+z7CkARKklgHDf/ozFD
 xetXqA3JTlzydPZv/8UOcgWCkZNrbujnMYdFGiD0M+Ys6DlT3nsnqyv9gqyHP8xEMWEcy2urcX/
 SfIO/oZ2h/ht972O/UA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX8U9dIdI0x2Jz
 rC9o9lcXyHq7t3nm1eJmhdYc8VGV6wSAFH7qBrQ09/TYxpb6cX5M626TLHQPKYaeNMajG8iqbaw
 GTORPLcYLMVarNX6yQ8MSqARELyIGmE=
X-Proofpoint-ORIG-GUID: ftfIXmnYyMM3aTJv3DLw6C_bnQeFVLOT
X-Authority-Analysis: v=2.4 cv=GpzXaU1C c=1 sm=1 tr=0 ts=6aed88e7 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=J_Cd7DG4o9UVoa3JfjsA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: ftfIXmnYyMM3aTJv3DLw6C_bnQeFVLOT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

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

