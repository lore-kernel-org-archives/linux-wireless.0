Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB92355803
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974074; cv=none; b=uSl8B+VmJ6TwTv50F8uDwOhmtadIRBWSnjsWA/djOwrT15cX0n7i+SulmA81ihZslu5szst9MisZPbHvqgYatQAXrnSLM5D/wepSZx6TMclnXOpfvqJiKFO9BVaXbukmpmiTwk7FY4VXBsz1TfxtoJW3wCdLrZCG1a8hStfaK3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974074; c=relaxed/simple;
	bh=daJrFuzoAIEZLku3fEWHPro8Atqd/Xn6A+xHkMnP3iE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XxP6OwDRRCQ0HEYv00I+m++a/6UMqPj8XD9wTcobP84JnI8///OVL61YWqmeKvjapyTVYHsP9eT9R0rZ1mVuNldp/XLQLvVcsOuSy0cevzapCC4dC8/Gh00x3+mvnH8JOMu0gNvMOh0riuZlSPf203wBqzCaWGHfTPAnVREvzy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iEoWi00S; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bob9j356; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iEoWi00S";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bob9j356"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E6894S2516002
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=3m/cAhmcKSV
	VW65yA/2KVjsT8Vmm2+KCZGylwJN9Mgo=; b=iEoWi00SXQgY040EzwzQe9SLqNS
	Dep5bHJVNheYBJfqyz4xLwuvWDs8Y7eck/mYGFVyP/K9g84WSDlljtAfzdRv98ws
	I8wsjPcvxOq3uY5mxQfb7EiH1X973LyX5uPXyPDPhbMUyENzK6gfQU+emM+gBYsr
	eAPgfe3fP9YOacCag+799k1vJ3eVRVpOt8/e7IEBz/W9bGbmyMimess/pRB3YNl5
	5EsVrPCHmfL59D32rrojdejvn/98QPXjI8AI0Y5vH+4bZ2A/ImZSX6+iNB4MXsAA
	j/WKMw0poFRlVPie0n+RdaGYshTW+ZdzQCLnHrQtXkjRohM/KIDUUWsRMgw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha470939b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:31 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-359b81ad4e8so1297443eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974071; x=1792578871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3m/cAhmcKSVVW65yA/2KVjsT8Vmm2+KCZGylwJN9Mgo=;
        b=bob9j3563hYlWH4EA373rx2MSmDgzrtLP50bm1AJuXEE4xI+tiylN2Lk7inPX4QoZ2
         ZofWrgs+wbkxFYhVneklX1WJUIsaMQDrPZmzZCxI3xFj7S4UW8poZVizLd1WoWNaQUjV
         noZ6KoLMf2u6khvWvPjzDqSirj2xUmJx4HMcwyL7jcSgt8q+ORduFyfhWYr0bSysaGRe
         67WP8mWKVEnFfi++tQmoO8IcCguCRhJhZnDBR4mjTnkIde1cOw0vbPuQLB4IB9Uh3s9E
         3vPqEGaKadpyPR8QbONO6Yf+JAAZoBbLc7vrTG43QEr6HbCAoLHzV0TReMRNPM7Q2KpF
         Xgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974071; x=1792578871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3m/cAhmcKSVVW65yA/2KVjsT8Vmm2+KCZGylwJN9Mgo=;
        b=ikL+SuyO2eNwRFrX7X6aC6YclF09CyX0ZnpUiGnfCIwcKCKH2nSVlCks2zDLp93cit
         jOeX6Pfd74Ih8pOgt2P9D+9ykkIYc/+jpTi+3CsG3WBUujAmClj7fi5mvfgSAn2zdphJ
         myUBcz8zoPVQGaQdRgFg2NAdUBv6+NGRtt2R2UNdSIupJyAD5BVfZ1wEbd/o4TqZOiKR
         0QpzS4bUBrDumZ6dxMj7sTnNcDgdwoOFW60VOheF1kn6mVK41v2+91TFUE91PrgLuJn7
         YNmcOaEaAhIkWpD66Zm30IuVXPbSVjZk+9l0APXpf0sF0FTxozngHmzie8RYa7T0XgjU
         Ce+w==
X-Gm-Message-State: AFq9FYKSJ7OKG8IqOl54619+hHz0jSfxT+lLEY5joN2ZD5p5l6mTGQGz
	TdksMKUmqOztGd/TY405eRwSNJYoajUNXAGYk5fLCfVb6BZXdPAinVf2NjuHoNViSTasN8+E3fi
	3Q5RrdJYXGD2Tqnuq2Lscg/5ufXijP1yJMzpCi+8fXI6M30kLh4qe8rcZQuwzeetTyupMqQ==
X-Gm-Gg: AYBFou3kn7WwSequSuc9rJk/2EDGNr9pi7v0Of+wsKcEaot8/auu5QRdB34BG1oAw7Y
	HefyugcXqffpgual8vHq6FJtx4A53Z78x913+f3iNRHZQ/IYmgW49JURzDXVwc563Z7S9TT3lq4
	ykwszf0rCnP+92W48gIDtbF5SqZqI24IXU8RZ7XxP4HGzkeqPHLoPDJmTGpChd/sQ9vIkSRI246
	6A78hwSvn0R29nppf9upLRS4rcfFx4k3SNAibmXOkjJUrp9hlnc1I3yzzmy7vS5f4uk1QQ7Xp91
	/VMrjIm02SlWaDekNvF41lsdTVmoLxpd6oOYFluWCjoks+jZiO9rBXQu9c6Wp7lSK1ASt+cGvTG
	TCgYfycO4PCZ1bqzVp9/VcFh8zYQhuM48Dud2
X-Received: by 2002:a05:7300:6d23:b0:35c:6ffd:e91b with SMTP id 5a478bee46e88-35c6ffdf3b6mr8631172eec.40.1791974070800;
        Wed, 14 Oct 2026 03:34:30 -0700 (PDT)
X-Received: by 2002:a05:7300:6d23:b0:35c:6ffd:e91b with SMTP id 5a478bee46e88-35c6ffdf3b6mr8631114eec.40.1791974070134;
        Wed, 14 Oct 2026 03:34:30 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:29 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 04/15] wifi: nl80211/cfg80211: add NAN ranging FTM capability
Date: Wed, 14 Oct 2026 16:03:48 +0530
Message-Id: <20261014103359.1508345-5-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfXyf1EvkPITLEb
 pjhXCAvAHPaHiOHVmRRKMmUgng+mAq0iV/vrmHG7ejyvKU708GjFcoZ5mZ31ZewOXLzoNe9E8+6
 cAlBUnv0GHU95Ff4/1/0HikfpiBMuc5EXZYNhsBoc5ZWJQNYxHJPXjUKb8rX7LwWxOTD5SqQipR
 t0kU1qeZA2vxy8GFL7OWI/hq54PfoiGzanJDZxUnJtZBV5pDM/lceupCvxUamR1NKJPir996t2s
 9FyDGCGDdQ4nHng0Dmqc3df5kP095ASxApsCyg2cHmV83jfWAcXt+/sL1U20rmLveSB6KTRwugT
 CQz4kO4tcE/rU/C/RzdjLcS5aZSlHdAVrdHfefYDmJxrMLZpg4cSO1b8hfTN5DcKctJGs8RiAse
 OkZ5rvAtI08+c1Xh9nGOOuJ2T437TfUpEurGnNRhEjO4bURxgwf7Rd0HfUX62w3zYRZ1VYxmQ5D
 rn5PCJKHbGE7K0PSGew==
X-Proofpoint-GUID: 6LqGtVo-hnPtmanQesMLIKN1hnIEfuuQ
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf5ab7 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=iUW0qKhjulv4phxyPqsA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: 6LqGtVo-hnPtmanQesMLIKN1hnIEfuuQ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX7QurNRQHSKvA
 JfLmpIq8828p+ITDrOn3A0DFaFIFxR/2ZGmzsjtzcsA5ggrSxwEmx9IFXSEffB+oZkZ61gxoZ+e
 xlec/elyIq5vd6H6zAOY6KMRz0Eoilc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

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
index d34b2be0edfa..76f2606c2f0a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6239,6 +6239,8 @@ cfg80211_get_iftype_ext_capa(struct wiphy *wiphy, enum nl80211_iftype type);
  * @ftm.type.pd_support: supports peer-to-peer ranging as mentioned in the
  *	specification "PR Implementation Consideration Draft 1.9 rev 1" where
  *	PD stands for proximity detection
+ * @ftm.type.nan_support: supports NAN ranging as defined in
+ *	the "Wi-Fi Aware Specification v4.0, clause 8".
  * @ftm.concurrent_ista_rsta_support: indicates if the device can
  *	simultaneously act as initiator and responder in a multi-peer
  *	measurement request. Only valid if @ftm.rsta_support is set.
@@ -6289,7 +6291,8 @@ struct cfg80211_pmsr_capabilities {
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
index bd547f4785d0..4009ca4ccd1d 100644
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

