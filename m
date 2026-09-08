Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B55E5921FB
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887413; cv=none; b=oRt/Rfsl/9ap7EluWPtefaFMQNGy8SW+ks223Br8xvGJAhbKQkVn6CKz1Qg99bIpCRvbaBD+SGR7GDP+b2DkPtJBBjQBxZejylcU618OmfNCTpoekLsXYmqQQINCb1V2DCz7214rgpVPvQPBSJtpsU9yREgJISLUQ/XNvCh68dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887413; c=relaxed/simple;
	bh=ODuW2nybW3REfD8SbUhi8QOhAYOU2HQqcQkaxRn64Q8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxyvyuRDFi+Z9z8jPXT+OGa090ulvStvmcYBbDkzbcXqonRC+ZQxooe3E/ANLzKDJeD3zKzDTgEatK2cSd/qLLlL6BcjcMgYDm7VBWWUBOpeOkTDBbl2R+Eb/60KjiiYVaCIHLLc4d76ZadKJOkk5n0QpahlpJt1/jurf7E4Jn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fmeleVvc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y+XVyUwX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fmeleVvc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y+XVyUwX"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FdZjH3757086
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 17:10:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s4tTeUVXrP8PDX4fDGv3MD0jVy8bbBgnnC6+ayxYRRA=; b=fmeleVvcLmVg/F+L
	67ClZFMqSQOuWGLlkj0g/0Y2g6VTbZltqahkldxXSwRv7UPzf3qAsrroIYSmUONx
	sOYg5wntLKNSdlv0q3Kuf/f28AtfIY0m7OVMQ3QtsLJmSA2VovpoapJYcwFVHnFz
	EKiIWJeJLd/GDO5HJztDlN8YQQWNPssd8dPqIsz4YD0CJsU/6BK1+PdFWz28TePE
	meubVXNpG6YR7KKTgUjLrKXt37UPuUyryudKKk4HbLK1sCaM2o57AreZDtckJSe9
	Qw6TnzRoAAY4AjlpUa2jYo5KJS4EAFeft3NxvEjGcI0jamiW2DMYR0auwVPlk99m
	TdeJ3w==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjcv7jy0r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:10:09 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc489e7a701so2105420a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788887408; x=1789492208; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s4tTeUVXrP8PDX4fDGv3MD0jVy8bbBgnnC6+ayxYRRA=;
        b=Y+XVyUwXcuvKybd7cYGFw4Z+UbtnLFDr0L2W/XjlcNmUoDA3WNZ2kkN1dDTIYXirsq
         q3pJvBdAYr5vrBFyESshbskAs1/GTDNJW58rPCDu7IPnwpRkY21mlTJoyRFNqmZIF6/V
         jjiVw5LbPPwt6UBXODmU3z4c0jJY9ZOzd0TcfbDeVHNb/Y9ddt08bl8/l+WWtK7oqxz6
         1g7K1gGBsbVrgRk0XubdUYyqTLJjqtTkDNqAVSAV4/CSlmZNCRYogRkuQXha34lcMYaL
         iJAptBIyLaUqh8YsiE+88xkCy44JFRbkxuBOXI1pfiU+ncOweRi9hfXe+bgyUatGiEiB
         K+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887408; x=1789492208;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s4tTeUVXrP8PDX4fDGv3MD0jVy8bbBgnnC6+ayxYRRA=;
        b=UQfgWBx59VRlkN9JpfftvZsVIWaUsUw+CLzkPnoVHWFlYK6nj3hFb6rMPclLOplCNS
         fTuVI3WkD+MaapKFRWVwwcBIUlG4Zb325E351nNmasCKnGJbsggrLRt7KUqbllaU8RGQ
         g0cf1KjUCsUmhqw6MDDfJOF9GumLuQ89KbYoG9oZrSzYgbjeXTEKpLIqqsvLutWzrg62
         Le5urkiCIA65oPcom03YtsPTkruqHfnX8oPec6gdBpJAN6krGHDAhHgvlAQ0ER4DAMqo
         dpWQsXhmk/bT6VQe9ZsRzlniynUzWSfa6oHCpgo+nNxGkjm7lQRaMniohZo55B8bpXLl
         2Z0A==
X-Forwarded-Encrypted: i=1; AKwUvByUp2cmzmvW8QDXqNvifZzmQ/11oCFHqSOJaJ05fysvEKkSnGfz255NRXYX3h6zeJay9YOtKWR1LUyh1BkDXw==@vger.kernel.org
X-Gm-Message-State: AFuF++lK46eDFHnSq+m73xSFLzOAx1GrQ5qVq2VQ7nbjudek9x7BteYf
	gAw2Ej1YVPX9K6b1Zf380L8vZxQZsk8LAeXXtOCAncAayleExPH0z7/n5j2oZGD2Ug3e171/vri
	VOuWBZJawT8hBGG682DctszoARSRorPOoyrJu0mT7MyF8UzrZPjhGjEhLgANVWkddo9PO
X-Gm-Gg: AYBFou0uh0nlf1KfFgzTY68zVsmgc6Tkax7Zxs4J6oAJxvOWWpKBz56iQ0RNoeOWD4+
	VHRRdmD9m4x9ZGjcJ5VdCDV5QJjT4wgkW1FpDYDJQFX8N0qq852CY4uFxfsVtd4nXRw/j98Flby
	zmhilLM2jVj17FRdEuL5632B1NJw70OH//GSpHG7yKiyJ54UveG89inXpsimubpewAUa/IhaI0L
	+qaA31AoGifjQwLu2oCsXs4nVwrlGVxzkGDjRPKZEjv0qtxnV3rn7HmBeNyMaLvlPCFiARDKQI3
	j+nZlajRCetmUw6VsrY0bULeLMqLIXmwdwc6OgPWb0inxsZtBBscitFS9ScC6DXQI4dUvhXnuen
	o+Hq8pR12nUZFG61HCyISAXhQFQMlTqJ/8DRtcWKIXNU/uX1zjmkNXNnR8fgTexbwlbfCEbzcy8
	wDJxVU15Ep+EJxMeMJ1LPBdQ==
X-Received: by 2002:a05:6a21:2983:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3da3a03ccf1mr51867765637.17.1788887408459;
        Tue, 08 Sep 2026 10:10:08 -0700 (PDT)
X-Received: by 2002:a05:6a21:2983:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3da3a03ccf1mr51867662637.17.1788887407858;
        Tue, 08 Sep 2026 10:10:07 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33450e140d3sm31773675eec.4.2026.09.08.10.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:10:07 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
To: "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Subject: [PATCH RESEND wireless-next 02/18] wifi: nl80211: Define Seamless Mobility Domain (SMD) device capability
Date: Tue,  8 Sep 2026 22:39:30 +0530
Message-Id: <20260908-smd-v1-2-9fd2d876a1fb@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=CMEamxrD c=1 sm=1 tr=0 ts=6aa04171 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=-9rhnhb8Ej--qkh-m00A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX5ZhWiEmnR9w8
 mir+eosulpMjo3DCKgAmaTjU+Z3HaUTfKjxqvvftSUr786Xq5sZa4IdoJPArGC8aKrsZEX76iX3
 jj3ycjI+hZbW40p8deK99Y7pj0hHtSM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE4NSBTYWx0ZWRfX9F0ba6k3EOj3
 gN7TRnVyqg7XJeg0E2uIXZDySbXgQY2s9TBRSQFZ+3Boo+j9iqni90P/wHEvoCTFBzfP45efy+g
 RVuWU875c7rO5GoK4Cgbl+Swa6KpFVOA9nC3T40tmeFvqsMbn3OwGvzK0nVFYD+8Pf3d6CvaS+/
 N0bqaCsQ5nGSFOuBKLcnp7HRbFWT1cRQfIN+oys9xBh68e/gHgDZmGdbIIDZ+zlH2aKuPq6ScZB
 H3JW16gUtHO5J6kUa/Hzzyt5poP3M084tmgXYhsRJh7IqE6kaaDtY4Do6C1uk4/PIg5d92cZUZ/
 jYywdz2RPHW2vw1aZIQNfvXsR/zn7MlM9vS1RyLZPgH7R7bbPm3i0eTuuNOCaIrLSRshX8TT/cJ
 1HaUUqtcOfC9+jUgHEVE8R+TtK0dTwly4c+1h9VCn+sF6Y/CC4bqMWvrZxl2suhir8wHzRjtx3u
 AIskq9pMKP+hh6L5MOA==
X-Proofpoint-ORIG-GUID: oEZ9B3x8BsUU4SdcCteKLL6XF5OpX962
X-Proofpoint-GUID: oEZ9B3x8BsUU4SdcCteKLL6XF5OpX962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080185

From: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>

Per IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16, an AP MLD can be
managed by a Seamless Mobility Domain Management Entity (SMD-ME) along
with partner AP MLDs to enable seamless transition of an associated
non-AP MLD from the current AP MLD to a target AP MLD. A non-AP MLD
advertising SMD supports association to an SMD-ME and SMD BSS
Transition between AP MLDs within an SMD.

Subclause 37.16.11 defines an optional capability for the current AP
MLD to forward buffered downlink (DL) data frames for the non-AP MLD to
the target AP MLD.

Userspace needs a way to be aware of the driver's SMD capabilities so that
it can enable SMD configuration and operation only on capable devices.

Define two extended feature flags
 - NL80211_EXT_FEATURE_SMD for SMD management and BSS Transition
   capability
 - NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING for DL data forwarding
   capability

so that userspace can gate SMD setup and data forwarding configuration
on driver support.

Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d8fefefc11a9..d9ce185b0ef1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7114,6 +7114,15 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
  *	in STA mode using @NL80211_CMD_PROBE_PEER.
  *
+ * @NL80211_EXT_FEATURE_SMD: Driver supports Seamless Mobility Domain (SMD)
+ *	and is managed by an SMD-ME to support SMD BSS Transition in AP mode
+ *	and supports association to an SMD-ME and SMD BSS transition in
+ *	non-AP STA mode.
+ *
+ * @NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING: Driver supports forwarding of
+ *	buffered downlink (DL) data packets in AP mode to the non-AP STA during
+ *	SMD BSS Transition.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -7196,6 +7205,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
+	NL80211_EXT_FEATURE_SMD,
+	NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,

-- 
2.34.1

