Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367058;
	b=gbDmdia1V4QkycvgDObzMf/rl+m4Dop9GVf87bswAMdYDJsV5GEnP1qOqUm8VW/1J/hP
	 SUs14tg/rI2Tuf2jlAMMPEcC3iGkHG0KT3/1ed1QKHauNoZtroZ39zTj5zgZh34Zw/+Gf
	 WgzE9MB8S7/tTvzY+T0zAxIWdsbBnFK0gFR8PnHIT+JbTJn+UAMlqRX7oAni0S5oHARz1
	 CulI0iO53jryn9SAysmorSuZKEw6PjyowuGI62cygobooSkex5DYTgLZ1/k95SlOqj1Sz
	 cCmkVhMcKcuqQ1mAOY8vFVW6/9v3Sj/al/x88KJacUjtUzX+PdbfO0NCtuL+1a62tng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367058;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9JLhKtTQ1XaP43V5mTn9ZA3n903VuPjvKU4x+nm0xpg=;
	b=Sf1dKWw7u9Ye+r//FX2RY4qKWWkdLylIUTFYc83hYcVPpjSPQlJSgcAMg743MmDHHfnO
	 4A9ZVcFSONBF6t13OpXeIZwKw0mR1070WCzFMaWFhqLeiNshatoDvJmL1O9dcXoKbaYXE
	 PQAO2aUiyo2/5PC4NohBsGtC4+9ZMYessLYlra8/MZMTpk2NR0UHMVoon6A1yhbEzichY
	 /qPHmIWjIPq/lvSdk5wBW2775ewdM/b2sMxR5xYfrI+fIGcOTv2AvxQ3e1wstPTWZjij4
	 3NwPSzC7k1n3vKNcgcALaVjMIg9iQ0eKW7dmTl8vg2aOzrHnUwuYW3xbji4zR2uCgFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T46gAPjr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HuXPj2lF;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00B9606A33B
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E00B9606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T46gAPjr;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HuXPj2lF
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UBGWFf3679069
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9JLhKtTQ1Xa
	P43V5mTn9ZA3n903VuPjvKU4x+nm0xpg=; b=T46gAPjrQS+lpzTIS84fO8k38N6
	Ab3yfz4I3gItORA/qQLzsoh+4VYcVQJJGkuGVUgud068F7Awk3hVmARE2othT5pm
	XFVFRL+ytHYoso5/8v+arQeToXkDGGMLVlS2kBOTNvToTJFR31Nf/E+hDhRYW/Jw
	ia4A3kyLTsOl8UwBZj5J2WuPUMnqiiwtIM6iZVtMmHdEfjbL8sYBNPauegOO//ax
	s6zOkKVPZ8y+IxPZAqt4O/VRuep3RWid/lv9ydXc3wIXCe+wdz3O5lKJTv0xfWP2
	+1we9UhGrobwklIH3O+WAVi1llc/KAiXUDk0brbUtPr1dpaE6kDOFTRvHdw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qk7y2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:30:56 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3adc5b185bfso770738a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793367056; x=1793971856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9JLhKtTQ1XaP43V5mTn9ZA3n903VuPjvKU4x+nm0xpg=;
        b=HuXPj2lFCWcUA++qp8Auf6ZNH1dzvF+pC+g3MUimzlkkMBlbGYLIiztxVTFcya9HcQ
         MD5qZFln8d4hbIIHD5h5VsuAE0ZoWqvk+GluzYkvK5gVc68c6tpqQ9UqQrir/tDEDWtQ
         Kz+olnbr1Bfo+rJPxSZYXidAAZlstwuh1RLqzVJbNErPZK0GhIY4i/ZsBr2s2j2Ei9cp
         wE5m4BuYE5VwyV9Yb//csHSxSdxgAT2zUPSnFbW6infbJoipJELGe1PYN3sMLcVrfADd
         HH8vYBeNGOeYCTEJao+rW8ApKpe9RdUkTWLFRzxu11GWF9KCbfbgk8cCQXvnnoP3EMgR
         T2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367056; x=1793971856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9JLhKtTQ1XaP43V5mTn9ZA3n903VuPjvKU4x+nm0xpg=;
        b=sV4MTFXHUBBWfeEohSmuMt4gOgwNtiV3LWd53f59wDLS8onIKJurZrHfrZtvBHVV6x
         myZLNsndxFNA4txm46byAs9fAQwOBpat/n9ZKdHqZr/XHuim4In4dKTsVsX9VyG8zuej
         0U+4YE9k4dp9ibFpF0RvP1Bi27fJMeT9mR9XO4FKDsbUHb+0C6jsu7n66BcbRkuHU9se
         atJdJadhuFU3JY9lBbgPjPAnCvLGRj1JV+S9Tnwqtl0i59/7oNfo2v2VczbUtqRAgOYC
         fZ1LzcbVo9TEHIZfkOUQ3KObwMcc+KGJR1vkkXYsP4lXvE0dpQG5oEDRGZFK3Ib5vXN0
         BPog==
X-Gm-Message-State: AFq9FYKLLOfPiYeFuP7sjzFf4LuTSLnBc9HxchfpCxGtk5Cj8FNKye7z
	qoJ/dA13Az1ril/eCcfkAxSMSDkUwafIcpLq8KsUizUoycXv/evBaQM1C7mVzSXaw8kZlkfnv07
	F9aXRzC5w28QRwP4vks9yIJvPQr6vlZ7ztN8aAh8SDC3ejkieriRQEkY/fnzNx+fFOcoz+w==
X-Gm-Gg: AYBFou3gWqy5WOsz1IX4uqhZREDAcLT5/iEPLU9KX0t2TSiP7ncWmOHOfPdHfiRq1OI
	KNUItEYBC9Rp9QOB3oBSi+8gyGEVHT/bbZ/hLchILjS4az++aKvu1m4W6ndL1Y26/j8YGKwBqte
	l0K5UpH1bIYROfSJbVcofRRQTw5f7UZ8q9/r5XUwKhB5pDwRhjYiFZbNc2VsrWBDJ/+a2bTdzdF
	zwqMwAS1ZuI/nLHJoRtk/8oz7NNoWzjSXXWpGANS13t5w3NUvFk+gcUiP2UqwWLA0cTuMieU/NG
	GzO6YRvizwMQd2HR0wYiImnOw4EtCjSXlRypdFvyw7ERm9QH8ti9LK/n93Cyr6vqK/Y8H+dzdWa
	Ow275Z1ZY5PFCtjIro9fqKA+GVwX3Um4nAItyUYelRijUkz3zmr6NlhNzoz4wwtiTKs3dhXLhWZ
	gK6EaWCh+dSg==
X-Received: by 2002:a17:90a:e7d2:b0:3ac:4e18:2390 with SMTP id 98e67ed59e1d1-3ae895743d0mr2189911a91.7.1793367055675;
        Fri, 30 Oct 2026 06:30:55 -0700 (PDT)
X-Received: by 2002:a17:90a:e7d2:b0:3ac:4e18:2390 with SMTP id 98e67ed59e1d1-3ae895743d0mr2189885a91.7.1793367055203;
        Fri, 30 Oct 2026 06:30:55 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae87f99899sm1678718a91.2.2026.10.30.06.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:30:54 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next v1 09/16] wifi: nl80211: add NDP offload capability advertisement
Date: Fri, 30 Oct 2026 19:00:05 +0530
Message-Id: <20261030133012.3009774-10-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX3V5psQ6XVVwx
 Q5XB0ix+MzZSXRoaKzt7q9lu872hS8snhAcnRdY9xJSmD/ELmS2F7ulNbLPGrZINTc9V+xB5m3T
 9kENcAK7YEOsfXlfZg6vaUGhrWrToVozYV1AGkDTZX0US8XE/Mdv4eo7fGqYj91WhZfbDeq5YMc
 YGuAE5Ou7QCGOF+D8MxwvLv3gHvNDm2vk8z7yCoDTp/s9h+SFSDYEsR1kpsqOhskYSuZcTrDkoi
 B1eoQgewCHOojBfpc3o1tlXWpzO/nCOSrQ7pmGRUezMz/Jp4K9AqbWnXn99JsgtVotsSTdgrckf
 qbf48VhWKqpvM5k34NG3VnV2UzZ4imy7MN9w3v8fV8aO1slz/k84dnPP+M8So1XGi6fErPQCjLF
 scTEI5a5uYFWHeUVsij8bgmRuFK/RvBf41RP0y6Hxxb1Nw4ehsTWDIbIfqGPZfDyRRbNcc+MFIO
 puHR0Frf33IYAxUx3fg==
X-Proofpoint-ORIG-GUID: k5RV2pm5dCc-6QU_KyRxXpKIBfffd59X
X-Authority-Analysis: v=2.4 cv=IeoSymqa c=1 sm=1 tr=0 ts=6ae49c10 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=Ht1UzMXru-ymeY0r9JkA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA1MyBTYWx0ZWRfX7LHz7+rCzrFl
 bEA/qZML06rcE1k+5H5B57hJ/EULHInaEMBNHywhEKgh5Ju0tHZdsuM42d+9YjILGY+D4VTti4h
 CJhTlEuRQyD8lb8/z2wFMh7CFbR5DJA=
X-Proofpoint-GUID: k5RV2pm5dCc-6QU_KyRxXpKIBfffd59X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300053

Add support for drivers to advertise NDP offload capability through
the NAN capabilities response so userspace can determine whether the
driver supports firmware-assisted NDP session management.

Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index af2b3a12572e..154d76dbcb1c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -9279,6 +9279,8 @@ enum nl80211_s1g_short_beacon_attrs {
  * @NL80211_NAN_CAPA_OFFLOAD_RANGING: flag attribute. Firmware supports the
  *	fully offloaded NAN ranging procedure, including ranging session setup,
  *	update, and termination, FTM protocol and procedure, and ranging reports.
+ * @NL80211_NAN_CAPA_OFFLOAD_NDP: flag attribute. Driver handles NAN Data
+ *	Path (NDP) handshake frames and data path key installation.
  * @__NL80211_NAN_CAPABILITIES_LAST: Internal
  * @NL80211_NAN_CAPABILITIES_MAX: Highest NAN capability attribute.
  */
@@ -9294,6 +9296,7 @@ enum nl80211_nan_capabilities {
 	NL80211_NAN_CAPA_PHY,
 	NL80211_NAN_CAPA_INSTANT_COMM,
 	NL80211_NAN_CAPA_OFFLOAD_RANGING,
+	NL80211_NAN_CAPA_OFFLOAD_NDP,
 	/* keep last */
 	__NL80211_NAN_CAPABILITIES_LAST,
 	NL80211_NAN_CAPABILITIES_MAX = __NL80211_NAN_CAPABILITIES_LAST - 1,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index eb74a9d3eeb0..6188102ade33 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3168,6 +3168,10 @@ static int nl80211_put_nan_capa(struct wiphy *wiphy, struct sk_buff *msg)
 	    nla_put_flag(msg, NL80211_NAN_CAPA_OFFLOAD_RANGING))
 		goto fail;
 
+	if ((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_NDP) &&
+	    nla_put_flag(msg, NL80211_NAN_CAPA_OFFLOAD_NDP))
+		goto fail;
+
 	if (nla_put_u8(msg, NL80211_NAN_CAPA_OP_MODE,
 		       wiphy->nan_capa.op_mode) ||
 	    nla_put_u8(msg, NL80211_NAN_CAPA_NUM_ANTENNAS,
-- 
2.34.1

