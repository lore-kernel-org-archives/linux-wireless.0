Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907620;
	b=zDTg6KSvPL76SI7HW0fZHGE/gMYk/Hm4ecshCCgwy65UsYybaBFA2RiiCnNJjk3SiWSV
	 N738z02WaU+Bayht1O8ErI4pBbT5kP22cQrkV8iHc5O0L+DRpK/etYZjhRWei1UHUt/VG
	 EX3fvgP7HJ5uOZfAhDKCUjr0KlkmuVJg9L+RvOje0pFAryIYMsmfN25QEOJEuMvaJovnQ
	 8simFRpo++lVGMxuPVVjdI7SsPIzlEAZsFtN0gu0cQRyx3uAcpx3+FxuKUz3vIOk1gMBA
	 TrjhW66FnIg0+R13nwaVjg2mlTnOeCwXw6k4PI0RFBjq/MjyB6EVBgu9HflPtdx1KfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907620;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Z8XHujJiBkcagFsfgBICSH9wnbIRlzmSj2ubDb+7t+w=;
	b=eenfTVTkNI4OpUf/7vqLwFmX+wr7/O7dRirFzdWYdWu/xl7W0XGCPmpJwo0z+WYX8k7s
	 OzgD6TU7xTSvpfNyQA7ZeD7s5pdIg0wi9xhF4XJ9cbaciE+DG0cuAo1yExlGICZbcjIC8
	 noBlsJZDHLVI17XECZ5OGETaLIE9BGyzMQHha90mbNFveV7EMHwXBMM/Ch7xD0F0yRQhN
	 UnlCnZ7PMMaEM/rCMJYDtfiK489CuDGY8BR1D7OxEbnMQAtEugwZfJDRRAZ3vmmpYECcu
	 jBCTL/Lyi/MBTk5sz6BzZyIByvJaNCSGqCMuFR9rJ0m3w6OTph28LVwt6NG7IieyOKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kf8HthJ7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bLYmwftD;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453B6071FA9
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1453B6071FA9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kf8HthJ7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bLYmwftD
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeKIp1485061
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z8XHujJiBkcagFsfgBICSH9wnbIRlzmSj2ubDb+7t+w=; b=kf8HthJ755bsNh8g
	VRlBb4h65hEIU3uhp6aGtB2U1sht2wcfKdy93BKZDzl+5SP+tEYj1qQ2SCxuv60Q
	F9R2Cmqenn5YgVqEqhgPWT+aGZkTf3O3iYOWOrY1osB1Pa7TwSuGv8TDywVa0r+0
	wVPlYe8nlc+6SOwUEqDdJgWPErlD1eV6yTo3Rv2gRCZZ5I/ETLXzSxSurFXyUeoN
	3vMZLz07j8SwkCCrYia+on3M7/jq0HwLNhvZ2x6jnvohz7NZ7ZjjKnQA6xF1kc6L
	3cG6WPOZirLwndRIdE8C1atQeONI2bL/lj6IGkTbEniw0HaUd7lRajDlyLWM5Kb+
	oInqWA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrpaajycn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:18 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36cec75d8caso1164475eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907618; x=1794512418; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z8XHujJiBkcagFsfgBICSH9wnbIRlzmSj2ubDb+7t+w=;
        b=bLYmwftDcPeyJV3296LUEWq83YmXOpDY5w6qR6Yu6chRu43PP6uh4eKS/CQg+1y5fd
         DOXTe0R/itIZGJ/GyIe/av90WuryIAVRmpmcIjQkwqL6rHgjQGro9NcK8pGzhN3m7C9K
         G5lA4DJlMsYuYs1mg/G6NRDtLQXyqOSPnbk/ofqHDM+uA/K7ZSqkBiu/iBHLR3pdx+1b
         3nLxcA8L8Pfa3wy50L2WMpXB9rHy7zGQGAVGnooENEFu+RqQjdweojA08JSXG/A4fVFV
         7ni9GZqLSGKVSqAb9QC/Nq7aBYhBi+o0dtEvLZkczGXKUAQzyPQC/W6tegU/+O9AKe41
         Wh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907618; x=1794512418;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z8XHujJiBkcagFsfgBICSH9wnbIRlzmSj2ubDb+7t+w=;
        b=vSdaQX0d6PmUF6S+I3PV4mBlIN0UZyFy1ar+AXPvYKEoY7q9Q6e3yjQzxMr6lDAn/p
         stVEI4+x4yJ37cg3n118ABDifMhnngvgfFS+OlQua4E5jdyEAi2/q4mzsohv7o2UWld4
         CyS9r/ujFox0qcKAWsalahPDUyCY1myo5rkm5ot2KgxcDSMO36/mRSfYgjb3qX3/gqxS
         6kxAJIGCIfW9/YWXczrZbFjcX8XkRiWSV1yBss647p+jO0sl1WjWGTtOqOWRJgFCp964
         9vdaljDdofJ1a7fABr1P2r4oL6D32tTz4j05qgpvJoU1+nQ0w+6PjT/229eupQCcQEtp
         2Qxg==
X-Gm-Message-State: APuU4Z9ycdwxe/Ben1dfYJvp6E8SetPpMvTmkw4EvtZKRpQQmz7U9TjN
	zFpZKL5+mFBuuaTNMfsaPDLkarR5TqtZFuuSllsaofN+wkkwBOz6DQtd2uNBpVIFlZthjgaC+1+
	Ip1u4Sa8dVO/3/TXd+qUMYz1VbYYugNuMY4/w9bLRYHtohKxUJUZoRlGmZ5q4+vOgD958
X-Gm-Gg: AYBFou2CneYTiZOcCCMguZdNghrALR1bdmEZsQzOwSPn8bZzyNitxcnuqEWAwNMBWI+
	Pvme51wetAMP0iCSWd4Ito26uv7UHy8vWJw4Am4FeFbxqsU1T2voLrl4TSzxqM9Z+Jj9XsvBihY
	Evacf9zkCNlnxr4p6NdgS/UiSzj1lC0qUX76Is3vuK7PFPTm1QzztFJSdz/Jl9I+y2MRz/+LYFo
	gn9RJyjiTyqWEiK/ZvI+e0mlF5aupwUPKfK7CEWlv+SqvcouqopnSKcWSiKSK5x65X28ES8UeZR
	F9+CAGVoUB77FsjRFDJxDEJiNofjtbxGPpaVcsT8T+/OFQsI2ei3RSCRYnqw3Mf9xwDTWFZcwdp
	/X1gL69OkTo9thQZcuVACpgoqLDwDdhq/zW2ZBsqzp/TwpKVfVrwJhwOeb1lzUvcwC3o91yRXlg
	WbKXHEDR4FLWp6kUIpX/AT1zfEma6x8jGg4pvq2oG0rqA4xvnxctW+y0VVFKugVHFkRfdOLg==
X-Received: by 2002:a05:7301:4208:b0:36c:a3ae:936e with SMTP id 5a478bee46e88-36de5f70a05mr4629961eec.5.1793907617801;
        Thu, 05 Nov 2026 11:40:17 -0800 (PST)
X-Received: by 2002:a05:7301:4208:b0:36c:a3ae:936e with SMTP id 5a478bee46e88-36de5f70a05mr4629928eec.5.1793907617220;
        Thu, 05 Nov 2026 11:40:17 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:16 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:36 +0530
Subject: [PATCH wireless-next v3 01/21] wifi: nl80211: define Seamless
 Mobility Domain (SMD) device capability
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
Message-Id: <20261106-smd-v3-1-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXyP/kbSLUDCN6
 SE+Fl7pTAxqZcbd4C8OP2KI9RVyAiZdTTCPIF3PgOIWCMr6NZXwOZzJ73f0ylPP8YtL6FLzPPEk
 QGJLHksuPsPkmKQLfSrEfo9eYLUBqDkZFeflrCMz64COLKISQSl3RD/qra77kiv2YiRouhrRDP6
 H3M9bC6Pi+Qdp0rfny2Cs5u5e1xpzkVD2GNO6XQDdJ22EsmkwGmjcEQghzlmFEyqlaUelTkS9NM
 smdHly8ZXMSIlYHh0aiH+pWlCZ6UVAdmLvtNZ7Kz1bH0FZUstgNN4TpMj6OP7n0Avje3mmYV8ij
 ckuwU/c/sp1DmX2A1OMu05sYOaUts0F+l/JpvdtfJPjPIxrXL0d7IUA+F7059EA1pvFSig3DlV5
 6eYtCe87pK4J+2kZDe9hsivlpY/NWWO7ivxWyfz8XY30ecfe5VM2X3eTiLrDFl/UWL/KVJUWzJo
 iyPqkgmFwfOqpPsFMIA==
X-Proofpoint-GUID: FUTKLH584XAtkEKXraI50qLS1SnEQd5B
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX0G051bF/VFLJ
 eu2fT1kvvAm+h1NVvKCNqtOXT0CtLcXfnjA2qiAJOGbWLsaR0vab3FuFLruQrLb7GDzIV8VDSKj
 jmxPBWPwtZ9F0VkgaeTuDTgtZOKsl6A=
X-Proofpoint-ORIG-GUID: FUTKLH584XAtkEKXraI50qLS1SnEQd5B
X-Authority-Analysis: v=2.4 cv=WOXqzXsR c=1 sm=1 tr=0 ts=6aecdba2 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=mv3qBhzh20y5QnxvG48A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050078

Per IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16, an AP MLD can be
managed by a Seamless Mobility Domain Management Entity (SMD-ME) along
with partner AP MLDs to enable seamless transition of an associated
non-AP MLD from the current AP MLD to a target AP MLD. A non-AP MLD
advertising SMD supports association to an SMD-ME and SMD BSS
Transition between AP MLDs within an SMD.

Userspace needs a way to be aware of the driver's SMD capabilities so that
it can enable SMD configuration and operation only on capable devices.
Define nl80211 and wiphy flag interfaces to advertise SMD support to
userspace.

Co-developed-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 25 +++++++++++++++++++++++++
 net/wireless/nl80211.c       |  7 +++++++
 3 files changed, 35 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 46ba0fb27b14..b4f384ade47a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5796,6 +5796,8 @@ struct cfg80211_ops {
  *	STA) basis for station and P2P client interfaces.
  *	(Note that if userspace doesn't give the MAC address, the AP's address
  *	is substituted to allow for older userspace versions.)
+ * @WIPHY_FLAG_SUPPORTS_SMD: The device supports Seamless Mobility Domain (SMD)
+ *	setup and BSS Transition.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -5823,6 +5825,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 	WIPHY_FLAG_NOTIFY_REGDOM_BY_DRIVER	= BIT(24),
 	WIPHY_FLAG_CHANNEL_CHANGE_ON_BEACON     = BIT(25),
+	WIPHY_FLAG_SUPPORTS_SMD			= BIT(26),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b56a96f57bec..3e71564ce87c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -343,6 +343,26 @@
  * processing of peer DH IE to generate PMK.
  */
 
+/**
+ * DOC: Seamless Mobility Domain (AP)
+ *
+ * Seamless Mobility Domain (SMD) is a mobility domain consisting of multiple
+ * non-colocated AP multi-link devices where a non-AP MLD can perform SMD BSS
+ * Transition (ST) between the AP MLDs without reassociation (hence, seamless).
+ * ST is done in two phases:
+ *	Preparation (where the target AP MLD sets up the links for the non-AP
+ *	MLD but keep in powersave) and
+ *	Execution (actual roaming where the non-AP MLD transitions to the
+ *	target AP MLD and continues traffic).
+ *
+ * To use this in nl80211, multiple commands carry the %NL80211_ATTR_SMD_SUPPORT
+ * attribute:
+ *	Drivers set %WIPHY_FLAG_SUPPORTS_SMD to indicate userspace about the
+ *	SMD capability in %NL80211_CMD_GET_WIPHY.
+ *	%NL80211_CMD_START_AP carries %NL80211_ATTR_SMD_SUPPORT to indicate that
+ *	the AP affiliated to an AP MLD is part of an SMD.
+ */
+
 /**
  * enum nl80211_commands - supported nl80211 commands
  *
@@ -3243,6 +3263,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_ASSOC_PROTECTED_TWT: Enable protected TWT for the association,
  *	requires protected TWT support (flag attribute)
  *
+ * @NL80211_ATTR_SMD_SUPPORT: Flag attribute to indicate SMD support. Used with
+ *	multiple commands to indicate appropriate SMD support (refer DOC).
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3850,6 +3873,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_ASSOC_PROTECTED_TWT,
 
+	NL80211_ATTR_SMD_SUPPORT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..16d00ebed10a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1201,6 +1201,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ASSOC_CIP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIP_CAPABILITIES] = { .type = NLA_U8 },
 	[NL80211_ATTR_ASSOC_PROTECTED_TWT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SMD_SUPPORT] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -3824,6 +3825,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if (nl80211_put_nan_capa(&rdev->wiphy, msg))
 			goto nla_put_failure;
 
+		state->split_start++;
+		break;
+	case 19:
+		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SMD)
+			nla_put_flag(msg, NL80211_ATTR_SMD_SUPPORT);
+
 		/* done */
 		state->split_start = 0;
 		break;

-- 
2.34.1

