Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367046;
	b=QXLWOf13Gdbna4IKFE1cS8G8nvRusNAx5S7MRHSsN1VsMbk6DLFxQZZQIHFbDZ32LO51
	 Mx/rRdqbTqdAZ9h08JJd5P7x6KGSGu5SbvPgazW0HD/Cm1mVj/j9sGNSqZK6DQHHzv31o
	 GRw6II8tWroPdJKrKopffyDDc4kkkglBWzWV7wkQTPNpNe5/nyNZPE43OsJdeMfnzV8zf
	 8t546/HrXOchgXmZkg8KWrBDAP1KoNG/P7fK/AiqJXn/52j//vJ93PiYCnczA2WRveCuA
	 VmqFsuLHmBcUvEivVabm1jThFS1KQzUqQYWG5YTKf6YSFoOOMm61yp8gfIkLxD8PVuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367046;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+nWiKkBddv/FpNjlZUT+0ofjv6dN3IlSqc6YQb7f9do=;
	b=ec8/kwMRijnQpI98nFkaBUZtifTG6PTQWPq7+dDjfemXXcAb7N86/HDkBONO2pgqHe//
	 WKURp4wd6dx7CNyHylJ0T3dHA4A1FWbm0QFgDAExEDlUyaYNWc3GbzUCGSLtNrc9EAqTU
	 4yYUTBtkjGeZZ2mQG3gGYCp/a9d3xhGDcFkpFI25lKFBJiBPRkLee1rJsWCYIfeSPURq9
	 keoZjISv0JVkmDgiOUWCDNqqCoGUNyU3CLQpDOO4TRBB9g+AHeOZ78jmwykxcmfekX3xG
	 ZRCgoWYizrKOvlm6Y/JdoRZtLe4rYSF89jMwbHfrcxE5ny+V5cfm2RF9XZB4avWNkxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aMeuv9bi;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MxBuDZFL;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF9606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ECF9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aMeuv9bi;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MxBuDZFL
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBGNU13130313
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=+nWiKkBddv/
	FpNjlZUT+0ofjv6dN3IlSqc6YQb7f9do=; b=aMeuv9bivbQsvGTlwraM5P1Hy8d
	+WKv77j2vNcHVAFuvJJoEiShl73wn4fDZ1NRmsKSuDwlacr8zySxnlxcWEExyUiW
	h42jCo4WI6RxijTyzFPZ1j+mF2aOgX70SOqHdn71JYnMh+xFu0fianlGAEQnVIRP
	RSf73yYqNcDEKKxEMaqDQ1ilqEX9P/vQ2Z7N8z3HYDmhwNh1jHaRnI9anA0OlIkZ
	qA/hdOXFMCuCWJT11MW78s/4D5J3e/xGdLxOzfo0sCmo4guJB9VJJVzSVLsBSwBt
	lrN6/bYE4SHzjCZ6LcamIE7i9zQlab/kuAWUQkbIdynagIz/oC2tzzlZJcw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk6ap-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:44 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ac6795617aso602579a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367044; x=1793971844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+nWiKkBddv/FpNjlZUT+0ofjv6dN3IlSqc6YQb7f9do=;
        b=MxBuDZFLDtu+BBtZktEozBAyWVRGz/Tt8IAQdCl2YJu+iySQp0Rs03xD0473nrVZ8h
         fsOjacz4LA74ncgfdY/+aGfSJhbHI9FN/J1YMQeOfpAACp91hCq2MZ9ewHL+qMRCjFud
         sW3YQI6Vi+DsmV6vz9uo9VDuj8Ege2VUvoCDDM77aDP7RS4rIyMuidvfJlySZqfEMMGO
         sTXGewhheXOr1ERIZfUSDO7qzmRp1l6Ze8YlyHQ224Ncnu4eZXqiyPHk81DLHupaYAjE
         6x0qm/mK9JfrMq9Vy89r5z9owEocDc1c/xg+N7yQ9QdDub2SCuj8+OJRr+mt7L8FrsUd
         dg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367044; x=1793971844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+nWiKkBddv/FpNjlZUT+0ofjv6dN3IlSqc6YQb7f9do=;
        b=h1gxa7XneSx7G/NrtHmC2uJUulROVdATgf7Y/U+PyQL2T4zSCgknaqf7+fy+5cjXSG
         1iCCBnpwaSSvbHy1VtRmPEP6XZF80FG3olYqgzMqhQbx15ZK3h5tdQk3YV7Z5eX4FtsW
         iU1n1pdl0kZUdOYAsBdWg55WlOjPqtXBaONnMGxvCODun7n9TvlFDZJQ9FlD4Kmnp1x1
         NdN0zO6vhqedLKOBSxPUJHaP/m7FcxeZ8i9YNtaEQOSGLYT6gf9nRT1r7agOzdDBrNeG
         9ILTK79bcqSC185/0rjNvn8vWknGDcan8NfDU3BBbT2RxKoSbPGNS8MGuRzvqth27SMW
         cPuA==
X-Gm-Message-State: AFq9FYKk261GlrqP71TldMJL5WAmfGNg2gyOEF7YLBt804tlJ5iVv4Uq
	VgiNDQ7VNyuVdiVRNeYD4M+M4s3ofBsC3+H1AT/AgoEgyETolOSeVEHC3t3opwMR3hxkrNVjhrw
	mgchg4RlYNg30X0ETq7NY3hrr9hbXQ5B4DltmYJhmmfJibim6eucwNmJfPRAzCs1ZFnNtGA==
X-Gm-Gg: AYBFou1G7iHG08485Fv0wpwMnmIP24wJSPlYENiOx/EhJzjDRoPoq7tvN+4aZfvzKsL
	rx2HzrN63hrsGOagio2I0nfbE/Tk4X9A49BlbzzWfamJlx5ArfS+f0+ztMrA9QPJ968LGS4Ow2t
	Fgtjd7rkikSi3m/LODKjUqd7/2qcctZBCwYApB4m8g3cTVBodopCM6TuH+YMgP12JaKpuhgBdmf
	J+je4vfN8opq7EaQY1IeXEF1JIIo3mD+zLBPkln5o7Rvh3ojSwO0i+hQDauwifjoobdhtwATP4T
	sCSG8R+cBcjjn6qTfYUuspX0gOspZYhioZuqiCliLoQmhuYMfhio6rknrKkvvtjN2a9ymMFX4SE
	/+aUuM4FfWpS4WRz9WXlreOSUmOL9206dk39gv7ENaF1DBhgjgw1suQJTfXTulcWfemwLhTKfJO
	pqUfSHwADxGQ==
X-Received: by 2002:a17:90b:1811:b0:3ac:9176:e836 with SMTP id 98e67ed59e1d1-3ae897ccb04mr1874579a91.21.1793367043739;
        Fri, 30 Oct 2026 06:30:43 -0700 (PDT)
X-Received: by 2002:a17:90b:1811:b0:3ac:9176:e836 with SMTP id 98e67ed59e1d1-3ae897ccb04mr1874523a91.21.1793367042919;
        Fri, 30 Oct 2026 06:30:42 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:42 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 04/16] wifi: nl80211/cfg80211: add NAN ranging FTM capability
Date: Fri, 30 Oct 2026 19:00:00 +0530
Message-Id: <20261030133012.3009774-5-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
References: <20261030133012.3009774-1-shivani.baranwal@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: EJ0shQLcwohctyibsO4BNaZv8wWNI8t5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX+wYphZTFfGPz
 KhbhEs80s0SDTxBvIpCS33AyNoVp3n5tgNKuurU54b3KZzLzllNKG3PPKcLheZ+MD9HBQ5hJZGG
 ophX9Ay8zz5EnIOixDVtySrISJMzFkc=
X-Authority-Analysis: v=2.4 cv=DfSCOftW c=1 sm=1 tr=0 ts=6ae49c04 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=iUW0qKhjulv4phxyPqsA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: EJ0shQLcwohctyibsO4BNaZv8wWNI8t5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfXyR1OySwuV95c
 ncj0fxrcd96HKRtwsIcjoJHTTVprKJDGB3ygePFrEUzzxKqjc7ZoX3vevZ4gMX6olwWrYMa+qa/
 JdAa3Sb8uH7p0EVYahuuBaR43kg9ei+iRyXD3hbU7x2fuwaStXTWg8NwnkpihRyBcsigkcWGrCm
 kiiQWz7BUdm9HW5ryPtQ3GSc4seOt0fCbcr/JR39PnfbVOv3YW3Air63dCnfbtiitx7MNQNbJVU
 u45t/UEpwqGyHYrDi17w6ErqI13QjiP80eAMPjmH11SQ48dsITxDkTQ922MFJ1NQyOlDcbxT1AB
 WGYcs/mVZOXlrFiYfuVTWCFhGcUwImMetrfpxxDIwiUEJMwhm+9p000u8cfZ5gOZ9ZHBNcMCT8C
 UQsjEb7f29O2qq3DC2rKqG9D1z+9SNDNMBFWP04OCrXBsPV3rRjUlXFdc154HHEOtHWX6FHtK+c
 6ne4cVk5l37J4m/xXfw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>

Add NL80211_PMSR_FTM_TYPE_CAPA_ATTR_NAN_SUPPORT to the FTM type
capability enum so that userspace (e.g., wpa_supplicant) can query
whether the driver supports FTM-based ranging within a NAN Ranging
Session before initiating a NAN Ranging Request.

Add the corresponding nan_support bit to cfg80211_pmsr_capabilities
and include it in the capability advertisement in
nl80211_send_pmsr_ftm_capa().

Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 5 ++++-
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 7 ++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 83b66473f8d1..6fc7b2513904 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6246,6 +6246,8 @@ cfg80211_get_iftype_ext_capa(struct wiphy *wiphy, enum nl80211_iftype type);
  * @ftm.type.pd_support: supports peer-to-peer ranging as mentioned in the
  *	specification "PR Implementation Consideration Draft 1.9 rev 1" where
  *	PD stands for proximity detection
+ * @ftm.type.nan_support: supports NAN ranging as defined in
+ *	the "Wi-Fi Aware Specification v4.0, clause 8".
  * @ftm.concurrent_ista_rsta_support: indicates if the device can
  *	simultaneously act as initiator and responder in a multi-peer
  *	measurement request. Only valid if @ftm.rsta_support is set.
@@ -6296,7 +6298,8 @@ struct cfg80211_pmsr_capabilities {
 		u32 min_allowed_ranging_interval_ntb;
 		struct {
 			u8 infra_support:1,
-			   pd_support:1;
+			   pd_support:1,
+			   nan_support:1;
 		} type;
 		u8 concurrent_ista_rsta_support:1;
 		u32 pd_preambles;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fcbf613b19a9..96d1b072d4a5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -8473,6 +8473,9 @@ enum nl80211_peer_measurement_ftm_capa {
  *	the device supports peer-to-peer ranging as mentioned in the
  *	specification "PR Implementation Consideration Draft 1.9 rev 1" where
  *	PD stands for proximity detection
+ * @NL80211_PMSR_FTM_TYPE_CAPA_ATTR_NAN_SUPPORT: flag attribute indicating
+ *	that the device supports NAN ranging between two NAN devices as
+ *	defined in the "Wi-Fi Aware Specification v4.0, clause 8".
  *
  * @NUM_NL80211_PMSR_FTM_TYPE_CAPA_ATTR: internal
  * @NL80211_PMSR_FTM_TYPE_CAPA_ATTR_MAX: highest attribute number
@@ -8482,6 +8485,7 @@ enum nl80211_peer_measurement_ftm_type_capa {
 
 	NL80211_PMSR_FTM_TYPE_CAPA_ATTR_INFRA_SUPPORT,
 	NL80211_PMSR_FTM_TYPE_CAPA_ATTR_PD_SUPPORT,
+	NL80211_PMSR_FTM_TYPE_CAPA_ATTR_NAN_SUPPORT,
 
 	/* keep last */
 	NUM_NL80211_PMSR_FTM_TYPE_CAPA_ATTR,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 40966cfe5d86..d92673c67407 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2739,7 +2739,8 @@ nl80211_send_pmsr_ftm_capa(const struct cfg80211_pmsr_capabilities *cap,
 			cap->ftm.min_allowed_ranging_interval_ntb))
 		return -ENOBUFS;
 
-	if (cap->ftm.type.infra_support || cap->ftm.type.pd_support) {
+	if (cap->ftm.type.infra_support || cap->ftm.type.pd_support ||
+	    cap->ftm.type.nan_support) {
 		struct nlattr *pd_caps;
 
 		pd_caps = nla_nest_start_noflag(msg,
@@ -2755,6 +2756,10 @@ nl80211_send_pmsr_ftm_capa(const struct cfg80211_pmsr_capabilities *cap,
 		    nla_put_flag(msg, NL80211_PMSR_FTM_TYPE_CAPA_ATTR_PD_SUPPORT))
 			return -ENOBUFS;
 
+		if (cap->ftm.type.nan_support &&
+		    nla_put_flag(msg, NL80211_PMSR_FTM_TYPE_CAPA_ATTR_NAN_SUPPORT))
+			return -ENOBUFS;
+
 		nla_nest_end(msg, pd_caps);
 	}
 
-- 
2.34.1

