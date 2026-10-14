Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C091240611
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974076; cv=none; b=UlXFPDBZ6JrBzCO2GW6blKgVvP0M6fomxXJuOKZlERPMHXYy+/DN8PNQVttDQi34f3CIXxjl4Oe8WWWooFpMWjtoktY/clGpd0vZcLQpPpcBObAcNmWTbQyu3EnyAEsEkGj/3iz38XjvnkAhCQaF9uqtt0vKTXleN4PHXpGO2Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974076; c=relaxed/simple;
	bh=ig7K7gm5nXrTGj0lJqKVArUrwouRbTN1DkPA9rXxLpo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y28xTSOlcqm8e5OTZhgUg3WLIbe5OabLJj/YMfFjoWPSWffbdxP0br/+7Z/Gq1oU1fKjNebtrmo04HyLyUhoLY5KutrDqC2YBCAf12vhYXdE4QrSywnLAgYxsCAO/eb5cZuSrDMmBF8AOPqbFIV7dzt6Fd44GaxV0oHOtbV4JAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HTMMJw4L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aakJ3r44; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HTMMJw4L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aakJ3r44"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E684362515922
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=nPzrl2tG8BC
	xGc2uuNas4/3ITgQLxBf0eg6G8PKA61k=; b=HTMMJw4LMe/F47UlRHkS6JdlLTR
	l2Hs9OwIuJTInYX8nyhwFsZHrflxBDxJ8/n6N02eTiNFh3uVr0F59ZJwUZJ+E4iW
	NhC8VG7N92XgG0ZXDd0J/gkLf906sRDhMvlOi3vGy8DL2JGkhg/tqvsK0FSwgbtZ
	MCmUfQ8qOi+9daS+hU0SjbpxC5wZN+0gOsLoZ/wca9SWMZxyuot6CqO9j77KBBPs
	6q/ob5kjz7tc6zcwrXzikzHpWqIxnjCL+444bCLiXsnBvwiFux4SMSBsM4L2Tfwg
	S2czPyGMrlvQSg3ucvdbRPlqtqx+6GuiIM/xslUwzlLk24j/gLJDCJnY73w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha470939s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:34 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso8848400eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974073; x=1792578873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nPzrl2tG8BCxGc2uuNas4/3ITgQLxBf0eg6G8PKA61k=;
        b=aakJ3r44m+U3zFc8bPTB5lTMd61EFQbRN3UpMTWWqfJgT06KHvPhki4B/0BfGiBawa
         DVMhJeeUrTrDzX3Qyf4Zk4lSXbGkQKpT72fcvl06UT/78KVmV+Yg6SYoZNHvaQoKkNqJ
         h3kny6TOee9gS5koPCkVh+U+/1dM44xCFCJ/LU9BF/NQYtk1p7DFCcWZcMbfggzVUGfk
         MViNl1Ye9vHJWlwx/LZdgpawy1IfVixvC1adajhnWk/5XLPFZq57bKDDyUHUxngT7PCX
         MSjkAPwg8VgRASkdDoctjvLcbyxAMEg+5Bho1UCy+m5VqrYaXJnMqNldZgFaSafBcE1H
         QmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974073; x=1792578873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nPzrl2tG8BCxGc2uuNas4/3ITgQLxBf0eg6G8PKA61k=;
        b=mA3nbhluRyykdrDD+DqEqZBaJFTBV7HIEySsqtuXF+7J5VHFYwfqpYGU4qZa1UEAXg
         E09nuvJpRRZJeKZffQLFkshC1sYT1vQuTvSIZnEEZrtnOQPyku+F8A+MKvri5YDOx0w5
         K92j5KzL9IXvR/HZrLC92NsrphtDP8UuUY1bjxcCLg3poZtxOJ7gnDZ1kiNLmF5xruqE
         tKcCvmXKf+SLukxX4p9oJI8iA6v2PkAzpJVOwRooinDCCtFbwH6qJB0ndejs1rQiabuV
         CRtXx29s1VQ6m6ROkF6968TNQOYFayyAUU8buOIuZ1BAruArjQ6rqzrVNhR/hIY3XyKl
         jseQ==
X-Gm-Message-State: AFq9FYJItxVFjsZImwJQ0svxaIcpQNadDMMpgiVh0speyEEEENUU9hLg
	R19ySZKh0hOSCNSYdcNWKkD607Xo1rWXUrxirhu9GOVbi/sMtZwf2CHo8YEClip1D5s6Iyr+6fP
	GHRI7niFY/Y9PpVQa5B4DtD+nwHy+dW9nAHlMpnQ8eIod42x0Gj3T8N0yJ0bTQPeca1S1yVjMFo
	Mi2g==
X-Gm-Gg: AYBFou050TIstNYRIItSxBH7llL1g+CQjRzZrNA9oVDGr0f6kpB2TSxb9Ue7ToztQpP
	z+ZtJc4q8XlZ0PGESAQ6RZ2ScOmW2Ba1Q59XQKKmPemKcrNnWNnopcwTPAl3odU2mUYWm+N8v33
	F1RD5tVL8Zje/vLo9QTPJV/Ogjhnx10QG+sM5o4QSBrOF/Fl/5NiBgv8e/Q8ArQjtKq2pjaZxEH
	j1aAhodCdeqA3wkbwltVvWDDa6sc5pI+VfkSqX4qI/jfQV0qvGEQxzL5ChlChznp4Xx2vdsvchr
	3gmEDKWe9bfGAmWT/76kdQfuh8vXTO+G0Ea9L50+vwAeN1FXLiU91tiUtdqcuQ6AaDqzyA9Z7Su
	NquwCkDkCcDpiLySAJW++I/lUK8Bc+gul0YcV
X-Received: by 2002:a05:7301:e10c:b0:35c:3941:c7bd with SMTP id 5a478bee46e88-35c3941d34bmr7402191eec.19.1791974073347;
        Wed, 14 Oct 2026 03:34:33 -0700 (PDT)
X-Received: by 2002:a05:7301:e10c:b0:35c:3941:c7bd with SMTP id 5a478bee46e88-35c3941d34bmr7402154eec.19.1791974072706;
        Wed, 14 Oct 2026 03:34:32 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:32 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 05/15] wifi: nl80211/cfg80211: advertise NAN ranging support
Date: Wed, 14 Oct 2026 16:03:49 +0530
Message-Id: <20261014103359.1508345-6-shivani.baranwal@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX0Idgsyjx+OmH
 /1uNsjRvooVYwU5yjp1w3huwv46SAaAqAi2oqX7Pv/AmNfwrAeWG0GBA+CYe88G55MmIBrBOleT
 DU0l9Hr7do2gPy1ac5HrQK3zIVy0AVNihdfoSL+IAHoGVOCQZ2yexEmzHI7GaSETYgQz4bIh+IQ
 JAMlHMTXDOiLs1/kj0NBbrO6KFi8foqf1arnbTHlD+EPv6xeSUTxIQ6EuR11ltDlRMwR3+Cf4gf
 RQORjlQ3sFZtf4eFx8otFvP4bnbWK5Asv3oPq3iyw5wEC37d4jC8pPX4cVA/ziOPMVgismtWXU8
 lBJI4/mVC0AxCm3SErwEyiR+68CfFGKnf6ndycO8iNxd2lm/8uxjFphHofv5Y4A0UYcu+BImIrh
 GQGO3ZolI5TasAgZi3+xThFj9X5wPeyWjHlGRRfi2r9GAzTwzH9qTUiEzpaPk81Tmb0dN0AS6Xw
 akbaQVHNMjHwe4BplQg==
X-Proofpoint-GUID: 3wCV4OWynit0wMuv0QiQcaL0p27aU9jB
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf5aba cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=SO5rY5YKhGa1KnA-FeIA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: 3wCV4OWynit0wMuv0QiQcaL0p27aU9jB
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX+qs1FO9IJAnU
 ujfOI9JkI04inZoTZDubBH4ElqeHBrVXpbWWPN+g8NvqntBONWQ5M8Y1w3JrQKqMV4sgvg2ozab
 ucUvjAecCl0KkD3/bCl8Ovr3cdtA0Q0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>

Add NL80211_NAN_CAPA_OFFLOAD_RANGING so userspace (e.g., wpa_supplicant)
can determine whether firmware supports fully offloaded NAN ranging
before starting a NAN ranging session.

Add WIPHY_NAN_FLAGS_OFFLOAD_RANGING for drivers to report this
capability and expose it through the NAN capabilities handler.
Fully offloaded NAN ranging includes ranging session setup, update,
and termination, FTM protocol and procedure, and ranging report.

Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
---
 include/net/cfg80211.h       | 4 ++++
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 76f2606c2f0a..124480276b6b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6377,12 +6377,16 @@ struct wiphy_radio {
  *     (IC) mode. Can only be set along with %WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC.
  * @WIPHY_NAN_FLAGS_OFFLOAD_NDP: Driver handles NAN Data Path (NDP) handshake
  *	frames and data path key installation autonomously.
+ * @WIPHY_NAN_FLAGS_OFFLOAD_RANGING: Firmware supports fully offloaded NAN
+ *	ranging procedure, including ranging session setup, update, and
+ *	termination, FTM protocol and procedure, and ranging report.
  */
 enum wiphy_nan_flags {
 	WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC = BIT(0),
 	WIPHY_NAN_FLAGS_USERSPACE_DE   = BIT(1),
 	WIPHY_NAN_FLAGS_INSTANT_COMM = BIT(2),
 	WIPHY_NAN_FLAGS_OFFLOAD_NDP = BIT(3),
+	WIPHY_NAN_FLAGS_OFFLOAD_RANGING = BIT(4),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 96d1b072d4a5..793015750f3f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -9233,6 +9233,9 @@ enum nl80211_s1g_short_beacon_attrs {
  *	of the Wi-Fi Aware Specification v4.0. Can only be set if
  *	%NL80211_NAN_CAPA_CONFIGURABLE_SYNC is set. When IC is enabled, the IC
  *	schedule is expected to be configured by user space.
+ * @NL80211_NAN_CAPA_OFFLOAD_RANGING: flag attribute. Firmware supports the
+ *	fully offloaded NAN ranging procedure, including ranging session setup,
+ *	update, and termination, FTM protocol and procedure, and ranging reports.
  * @__NL80211_NAN_CAPABILITIES_LAST: Internal
  * @NL80211_NAN_CAPABILITIES_MAX: Highest NAN capability attribute.
  */
@@ -9247,6 +9250,7 @@ enum nl80211_nan_capabilities {
 	NL80211_NAN_CAPA_CAPABILITIES,
 	NL80211_NAN_CAPA_PHY,
 	NL80211_NAN_CAPA_INSTANT_COMM,
+	NL80211_NAN_CAPA_OFFLOAD_RANGING,
 	/* keep last */
 	__NL80211_NAN_CAPABILITIES_LAST,
 	NL80211_NAN_CAPABILITIES_MAX = __NL80211_NAN_CAPABILITIES_LAST - 1,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4009ca4ccd1d..18da5cd456ef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3152,6 +3152,10 @@ static int nl80211_put_nan_capa(struct wiphy *wiphy, struct sk_buff *msg)
 	    nla_put_flag(msg, NL80211_NAN_CAPA_INSTANT_COMM))
 		goto fail;
 
+	if ((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_OFFLOAD_RANGING) &&
+	    nla_put_flag(msg, NL80211_NAN_CAPA_OFFLOAD_RANGING))
+		goto fail;
+
 	if (nla_put_u8(msg, NL80211_NAN_CAPA_OP_MODE,
 		       wiphy->nan_capa.op_mode) ||
 	    nla_put_u8(msg, NL80211_NAN_CAPA_NUM_ANTENNAS,
-- 
2.34.1

