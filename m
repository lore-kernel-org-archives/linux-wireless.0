Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AD83D647F
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217697; cv=none; b=TwnLJ6yYQ2Z4XigiXSK+ov+CXGGCpSEUJWNP7400UhLfRLhGGmo9bPubtfrsi69Ubhpc9wiHIDqZ8TxC56E/+CVtIsXSbgeMFNRmffe0bEYo6ehQyHTir8JIGQzG0mGLW57WeR6xC0Z2SP0rfINV18f3rk3N8OVIgzCNXXfswm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217697; c=relaxed/simple;
	bh=EyWLR8HT45CAln0XcNXl0Swx1iiDzFpgEV+ivaL8IlM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jzEtjGdT5KpuXWIqDsHsztW7XYjJ+/aaGFxU+Ttn1p2OCyO152BZTHrwRZ6RTN5XnIT9LeZ/lX+6y7Te3T7YxqdlKaH0yEuJ1TlOJ8U5+jvBF7535dIyG9lDoIwwK0EwaR6wECcPM1ERVAQfKF6DDK1zX3SveIAiRH8rQTRHalw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WT0ALLL8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZJmYicwO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WT0ALLL8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZJmYicwO"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O2Jr4V1994462
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	28JFi8aQFyfFe/wqTpKPLr2ytagGCO4P3M2TiHnNNmg=; b=WT0ALLL8GCdyvton
	Eok1FIZvqH2OxbrwYcXSxfwlkecLxdZOatKff2W1cNwGd1uJg+PnvszVHMzxtgkN
	9ezr+k3+5FI6a9NMsm+dtgFTXWoqmYHbbKzb9BGrseVWSMe862vuqFnxo8zLoJR0
	HHRE0cZYL5Mv2yowRMrRDra8Y15go1gvWGit38bZ02kuS5PtEvS/Z0k1f/8akXoz
	XLYTkvqSyVaMNFqbnrmFN/BmFdNS8N9yzZNn28rY6mqTUtUdIEjVj8G8SwpwOtrK
	vpU5pS2lpym2+giVe7ryFJUMMJ+PKcgLK1BBwtCNTV5CGXIXu/OMj2K0blYxsLKZ
	6gTO5Q==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvstug9k5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:41:35 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-32861f5448cso717686eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 19:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790217695; x=1790822495; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=28JFi8aQFyfFe/wqTpKPLr2ytagGCO4P3M2TiHnNNmg=;
        b=ZJmYicwO7dJtq4G/RC5X0fD56wmdq+iRD7DWtjPt7vnHmrtm1MIfnRMRwxbQ56GqXJ
         ojncJIFdpyV7mzlKosWCu6/VsAuVkejE7XFadT1R3w79GMrv8+PR1RJUlrkSpnaFl5oX
         Z26LI4lDx4HbDDR5+hQzcEz3thMRZtkSSeXJR49VlyGbOl69DgzRco4MMUJ6655nIV5x
         RFOOHFqcl8Lp0CT/WAumTROND4jVypijK9DDFAZB4Go4ZIuxVZgDlf+6LfFwURxBzo/X
         N24q6L/YuGBDWubjyjENBgJtgGQ7AvOACe+HYMXIWk6C4gizBi2cJup5jCQrHVxqOn46
         XiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217695; x=1790822495;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=28JFi8aQFyfFe/wqTpKPLr2ytagGCO4P3M2TiHnNNmg=;
        b=oCPP7ncmZ1d9ym0b2kwIyA7gBHWvdszVqmh7Zie8jnHulAhppEV0RxCUJkqqWctqhW
         fAmpYHSOnLHTdTX6IJz4CitinTrIgvNv+TED5ih1IDOHSkcAzoGztYYNrZ3DdMiJEt7L
         YU/RDyBYcyR6D9eaD0wS6z8Rtk5MPvpo62W6lbJ8aXOuiSH0ExlDFD36tlRxtKWH2K6F
         CnUrY4cxYCoAk0MX1WRqH10aV1F60Mualxmf4R/JJqn/yvjweClApA1lf90LZo5nxDoC
         QvXL/woxkz8MMDD04J/adGKICjAazCSUnB299o1lRFtUESw9iJjivUjeeSDphvWrmD3v
         7F9Q==
X-Gm-Message-State: AFuF++nVqB4iFmFVAPdI6GcvLpU7YbAsV3iNMXmL8KR6JNwwqv0vz035
	eTt2fx+y8NeIJbBNdFCKg037sp11i0Hnh6T+LcnlP+sFQfArtvEXvCTe7CqykfRS1hknQYJY3Zr
	m60PWC/egwsoG2K5Zr5WhzV5tBsPcBrBaTg3Kj0dShprLplxcB8XeFPElXFB1XCa8lieki/ZTFJ
	R0
X-Gm-Gg: AYBFou1Mn6+5czqWtWYp0TGhJbhFFDePk/GbqX4Tlq1j2CcztA7JtvnsBEIPW2IVCCG
	wEffHjiWKK+YsqhrK6G548xGYYFZadVkQXGVuVrW1JFgpcFMJj9Ok9RBvGRXE/4lMFvPjb9/08N
	XZvY7U1K4wlPswuCBhCtEaJG89zT+uIeAFen9684jAV5kq+2dJFsM3lHkHbYV/saKkIQ/sSEjwj
	eWDU7HuyWlQesiIhRwNtt93/H9wEMedzdOaDuCQmt501EyyZ2w9pSIMKSFDXoP+AZJVJygET6nb
	ts5lPmte8BDJfqKYogx+aZqRxInwdulcvQDELe2yfeLmWVQkZkICRvJA0inPh1VoFyrC+GFnegG
	y98sVRePwhuEMbBt2x2lvHVzutvrzijVSvy6ldAQjddGQPszNpaRqKafiy/Q9JQ2S7YTjc9b/0a
	ddryL7CginvCHQWyMtCowC8Q==
X-Received: by 2002:a05:7300:8189:b0:33c:3515:daf4 with SMTP id 5a478bee46e88-340034c1e5amr1109991eec.27.1790217694790;
        Wed, 23 Sep 2026 19:41:34 -0700 (PDT)
X-Received: by 2002:a05:7300:8189:b0:33c:3515:daf4 with SMTP id 5a478bee46e88-340034c1e5amr1109965eec.27.1790217694179;
        Wed, 23 Sep 2026 19:41:34 -0700 (PDT)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258351sm9692263eec.12.2026.09.23.19.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:41:33 -0700 (PDT)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:10:38 +0530
Subject: [PATCH wireless-next v2 01/16] wifi: nl80211: Define Seamless
 Mobility Domain (SMD) device capability
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-smd-v2-1-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
In-Reply-To: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfX72yutugY0wa2
 2q6iIzFO7NI9wbOUVOYMIddZxlOESXKwrSA7DoRsw/B9GRku0ULu3gz72CdH8c4g+ZB3Fx8KXxW
 VYqsMDi3BpaFXh9xSoAKOOzbNHnVnCU=
X-Proofpoint-ORIG-GUID: K5EDlRxmTtmzd3zim3mgJ7zbtVMg6kOu
X-Proofpoint-GUID: K5EDlRxmTtmzd3zim3mgJ7zbtVMg6kOu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAxMiBTYWx0ZWRfXzSHnQivsrcd5
 eKc0BFBJtTflGXv9Oi/t71N6CcvNxXwn/zRWyfg/mTWWp+WpudJUq9rRV8hbKQCIvlzI5bJ728W
 zkqtocku32f/niLlfQTAprw6jPUi2u4lsNMOpDD9i2iXH/aV4nYLB9Os74L6AV2JBO3f2x8EBcN
 M3IRYpzUniVFNTI/ds3lGmX6+BGaN4AWHSu9twKR4IWTFQn1TdXMsarZiDwtHKqkOmBSb/cpBjk
 W/EqFh7jRyUUwOjqRe/MUXMoyPEGUN5HmdcmsdMfYrjEuk1hPbMz+OFhUQzu9L2rXEnBMAs5aoQ
 29it4HQc7P7ev4EFKLeAnwzaJPgopgysryUN8hM4lZtC7k/Xj0SyUvKXIYt2u87+yWSXFSJfno2
 YWqE5ZzqDvt9puLhsgEFv9zqWlbt7VrKSciCpj0e3/corwYuAzJE0dOYi/3Ih1ZljhUGbiLQ+Sd
 nsPdhuxW5k5Zbp3mlAw==
X-Authority-Analysis: v=2.4 cv=cKp1IVeN c=1 sm=1 tr=0 ts=6ab48ddf cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=-9rhnhb8Ej--qkh-m00A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240012

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
index 9a2ccb8d66b8..d05103889912 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7126,6 +7126,15 @@ enum nl80211_feature_flags {
  *	offload in station mode, including Fast Transition or Opportunistic
  *	Key Caching.
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
@@ -7209,6 +7218,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
 	NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD,
+	NL80211_EXT_FEATURE_SMD,
+	NL80211_EXT_FEATURE_SMD_DL_PKT_FORWARDING,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,

-- 
2.34.1

