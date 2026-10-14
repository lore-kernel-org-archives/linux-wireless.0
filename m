Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA050240611
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974064; cv=none; b=r8vVxZjNhGa7q1BOLYhSZoZFMLq/bebxZdxnKl5f6OBXLdeOsLxyR+TeQacEfwDQpZW4aF7JWMG46JseeeNKFaTvLg9uFaSiRFq5g3I92sgThMmSpUnbo0sXCNFwbaF5uk8ojrmwwyj9d7JWci5i+F+fGTTFZ10o0DL2B6fSArU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974064; c=relaxed/simple;
	bh=z8iaQ+ffIc7lPJQXiH+BN38KSFfYlaoqGpuu42HzIT8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UM0zHrw6O5EGp8cLZPLEBOEcakhXGrKYGRHBimLgdVCdn7bYMYjGgaSktCzf48zo9FyWMXfUoGq2wkJjNUnQD31RdzG3wJdUEpPOpVozfF0Y4gCiyt+79i51A0v+CFAvZUEKPc76DNSODZ8R5RHAiXcblLVQnHmO9Bg7NnCn/7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GJAPkVYK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T5xn1lqz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GJAPkVYK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T5xn1lqz"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E685UE2515934
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Dh38QaYN03QZPQqJml6qOIZTIymMQPimBI7
	pDgi9Wsk=; b=GJAPkVYKhg/wObIikupC0xutywuErXViNTj+MByU5qZ3Of1CEyT
	bLMokT3Wajf//Fd1L1nS4hi9ESClrj+0xWiK5g8Sa2tlbFjx0k4u3V+e+5pKp+q1
	8qABh12o73WNWKceXdcyVBoevcw/KGgtBcB1ejBSRp7sUjJwzPdXmyItXWaw/XKr
	Ni9J1oOaVG18fd/a8Iu2o4/fBpb84oxUvNK/rFYp6F+ZgGJPIxKQO5J9wg+E4r0E
	GudTy6DCLuJn6SeWWHZ0x8k9vD+cfKFFWUUK1ltZTdCCXugWG6hG3r/Po1bjACoM
	nF1vaf2ChQgdW/Y1qNfu33DOtNFRRlaqftw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha4709384-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:34:22 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-341eff9e381so11027872eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 03:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791974061; x=1792578861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dh38QaYN03QZPQqJml6qOIZTIymMQPimBI7pDgi9Wsk=;
        b=T5xn1lqz+HNsHRJZLdlwGHFMzLXYiBFpWPd7MPTFbxgg78crKnX4kChpy1Wso3Bybi
         GIxFCvVl9YeVLgXv0xcmgkordh1UfU+vU/J7F96kCtXkPJod0vRRhOjzKMluNUMfo44a
         jkHtKVIiHzxadLbAlm6WCmG8zZTWlh+mQhrrllwEpxBw2R61ss7vMroBAf7yz34qWRzM
         bEgwbx+LVAgRVG8GmOtHL9+tZYMOuHygtUwwhhv8yWF+0A8jq7SN5xjSqY1+hQ4Zwi6u
         iJQAjQT+hL8on1xS6qpJs+N4ET/7kib06qBmJo2uAXc+dc3zx702ssXnTqKyOQ2U0zFt
         AfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791974061; x=1792578861;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dh38QaYN03QZPQqJml6qOIZTIymMQPimBI7pDgi9Wsk=;
        b=WiYV2gb/DV/Z4q6iw0pk8srFOt5B8wthj96f0v0dbKoI4BsDis1dI77G08i+PSOAY5
         pKUwwF5zF4SEftGMxTl38syx1s6G0aniavieplm5s6+idF97nMJkpXbRPpYmpmrW+U7d
         z1u26rI16cXqztnibUWRgmvtN79M3vwOD0UTd3ZAzxtexzv+bIMy0yfk5np2OBEx5xNo
         uAxdhgQQXTKIkyTeftQoolHRnmrNSUWPxJMramgFrWCx6TAq3RPe2qDNsAJKM69Mre+P
         gIxmLhwcxkF8YgRv5Fg+YSsdAFNlO13d+FFmuhIfb1CU5cdsJRlTcr7blPWYy9/ShOeB
         Lw+g==
X-Gm-Message-State: AFq9FYKz4fc04QuWqr5kQxiejkPLB8UsDUEvya+dnNVgwxSiCvmRLdGz
	hRipwL5pTq9mFD6OAu11ZRTuYpLfzbfBgYnPygm4teAy2nuT3BL8SAvYngt15WSxX2w/1uxntFS
	wmXzSuxjv7YDOokutU05RzCnQWZvcpMVeueyXr9BD02PwMHXiLXKx2F175FfszRd/3G7pwQ5yhe
	WoPg==
X-Gm-Gg: AYBFou0MBP3qo64+udgHwy8VHNjjJMr6z0Drh9HTl/833weEJf1uNIm3OKju5FX6noG
	VqOH/r6x2trihHGtkcU4IZcMTZuLiWwszY9i1Rn5usZCRfj/n5yNkxM37TDRX+4XJU3bWAnnuGL
	OT5NtXCv9vs0QQWJiLRFA1IIMrnUBH1XMczAxDPu+S/ZkMw9bLtbwkAAQaYom+OTvsmiiqBN+U9
	S2lGr2B69ufJrxEeRcEjOrKC0j2QtVya+SsmoFN9xrPTyEZ4P7MXnDYC9NyOdKj6+6K5qTScxjr
	K/I4YKW1F3t0vFDS/F8b15mOj5Be1U46aQoo66YFQSSP2L/V8ZLBq2NaL0ZrhbygL4jJbgBqz3r
	WPV/4J+5JG/GkRYbub4HUQWTnGLvzBzJzuW1v
X-Received: by 2002:a05:7300:e9d6:10b0:354:1db3:674e with SMTP id 5a478bee46e88-3541db367f0mr22425321eec.6.1791974061312;
        Wed, 14 Oct 2026 03:34:21 -0700 (PDT)
X-Received: by 2002:a05:7300:e9d6:10b0:354:1db3:674e with SMTP id 5a478bee46e88-3541db367f0mr22425214eec.6.1791974059231;
        Wed, 14 Oct 2026 03:34:19 -0700 (PDT)
Received: from hu-shivbara-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca6d20dsm55846300eec.12.2026.10.14.03.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 03:34:18 -0700 (PDT)
From: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kavita.kavita@oss.qualcomm.com,
        vamsin@qti.qualcomm.com
Subject: [PATCH wireless-next 00/15] wifi: cfg80211/nl80211: add NAN offload support
Date: Wed, 14 Oct 2026 16:03:44 +0530
Message-Id: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfX2cCKArnshowK
 Pws4K1EaOdg8r6XQCizoVSX5VHTOscM9V5qKluPaSwy2kJoDeuNPGMPqmCBy3zQnClCSQdKkqxo
 cTJCu0l9t1Q2+93cg8lSmXZfRL5kx1yid+GHb2DKcECc2X7UqPug4rgzu+1bENWM2PhxMM2C4qf
 VqC35UO6xUs/jBemt6LWuZbvNiGLzzPZ/dYPgFxK/CA4g7HpUw8GduyfhWNJ03wzu9O/nW21oH5
 uES+yb1aAmGjlbp0i2YR8c1BF9L/OTz13NVpGa2GDXmEL+TEKooCvwzKNn8rBpkh4H6GjsfTuYG
 s9X3Jf2cd5dfweck5BYcz3n7ymLPurlLrsuPA/2k4DvM1jvdic+UBAXrCWfW08srsS6q5ufbgE5
 OHKXPwoFkA6Mit5BEbnqnqcwqg9zdOeOS6WQn2eWgQJJnliHZtDmq5cbyDX4+Ey/LWPJg1GCvk3
 mbUQjWtjMImTWJDkSuA==
X-Proofpoint-GUID: tqy3sbDY-xb5c0Ns3OSnl-6BESSiTpno
X-Authority-Analysis: v=2.4 cv=P6avFSAu c=1 sm=1 tr=0 ts=6acf5aae cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=aBgsDGZfazwNXzvly7UA:9
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: tqy3sbDY-xb5c0Ns3OSnl-6BESSiTpno
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA0MSBTYWx0ZWRfXzg8razw+Qko1
 39JT6+nd6B86iajJ2mNv5NCpNxEbzTO5HyG74M5f/4+bxjE1V1Jkq+AuDbqMaeeeHn9DpwHh4l9
 jeJNN+21L1RmvofJPNzTAw0fCVYSBFU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140041

Add cfg80211/nl80211 support for offloaded NAN ranging and NAN Data Path
session management as defined in the Wi-Fi Aware Specification v4.0.

The series adds interfaces for request-based and discovery-based NAN ranging,
along with NAN ranging capability advertisement. It extends NAN function and
match attributes for discovery offload. It also adds NDP offload capability
advertisement, commands, and notifications for session setup and teardown.

The new behavior is capability-gated and does not affect existing NAN
operation unless a driver advertises the corresponding offload capability.
Driver and firmware support are required to use these interfaces.

Kavita Kavita (5):
  wifi: nl80211/cfg80211: add NAN ranging FTM capability
  wifi: nl80211/cfg80211: advertise NAN ranging support
  wifi: nl80211/cfg80211: add support for request-based NAN ranging
  wifi: nl80211/cfg80211: add support for discovery-based NAN ranging
  wifi: nl80211/cfg80211: add ranging results to NAN match event

Shivani Baranwal (10):
  wifi: nl80211: reject NAN add-function when Discovery Engine is in
    userspace
  wifi: nl80211/cfg80211: extend NAN function for discovery offload
  wifi: nl80211/cfg80211: extend NAN match indication for discovery
    offload
  wifi: nl80211: add NDP offload capability advertisement
  wifi: nl80211/cfg80211: add support for NDP initiation in offload mode
  wifi: nl80211/cfg80211: add support for NDP response in offload mode
  wifi: nl80211/cfg80211: add support for NDP termination in offload
    mode
  wifi: nl80211/cfg80211: add support for NDP request indication
  wifi: nl80211/cfg80211: add support for NDP confirm indication
  wifi: nl80211/cfg80211: add support for NDP terminated indication

 include/net/cfg80211.h       | 343 ++++++++++++++-
 include/uapi/linux/nl80211.h | 267 +++++++++++
 net/wireless/nl80211.c       | 826 ++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h       |   3 +
 net/wireless/pmsr.c          | 120 ++++-
 net/wireless/rdev-ops.h      |  48 ++
 net/wireless/trace.h         |  70 +++
 net/wireless/util.c          |   1 +
 8 files changed, 1673 insertions(+), 5 deletions(-)


base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
-- 
2.34.1
