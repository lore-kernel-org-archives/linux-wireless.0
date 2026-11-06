Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793941106;
	b=hFNMwEAfOvxfPtwH9rPBbi6Chvssgvi6NGHzgMARtqEIWmE1y1vtNCErAq5UKeiq+/Ay
	 5T26YpH5Fkg2ukP5was0QTn6syT1jPYL37MNtEUSm154FbXWKpwp9VjsWJp4Au5Mcu4/M
	 7myJqpas8RWPDEAmhI+09VODmkf7oOnRO4aBW72CWv2Vgga8UYQ0JayIE62nR7kwi0WfE
	 SHJrGcSJTeUm34qmxnOV7uXKpJq9/duBg9P21rdkLiABPVGXMTG3tzlcS18clqYw2r8VE
	 dMxKkF/U6QSIoBJhxsixwFptCs5cdOwAOug/r14KkWyebJ5bbsQHQMQT8XBN/GKRpyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793941106;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=XsgzVUmQJNtfxzke+KkwGJhVOf8KyHdxG/9A7ILLhkk=;
	b=L9t0+vAncyFi7cF8tS4ei+TdqFH+j2Y86Ifr63gSAlR+aGaTDPkWmJfGX6Ou72Tkoj3l
	 FvGGy8V3NMKQ/7IS19YHd3CMQhpXqGZhLv9ndyicBH2Ig6ytDxi7ICS665LjWdN6Bupc9
	 iq0zrGaz63TB5N21y7vfdscR88VdAhf7vqAAJa6E27X8sQp+ZLaPdiT03R6s9I32z8cqj
	 zVcF7a5bOrc9QggeT5bez2eezPV0u/qjV0T90r2zUG70EqG7/AohabtV3cTnaElRiNBLP
	 fbnfeseoV69ykQnSXU9w9sKc2Z3Rr9qow0D1aL7IWIw4NkogefrXYeGcGros7fmmF/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BKXpZ0uB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HjcSWPvg;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E558606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 04:58:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E558606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BKXpZ0uB;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HjcSWPvg
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A63xwPa1866673
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 04:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=XsgzVUmQJNtfxzke+KkwGJ
	hVOf8KyHdxG/9A7ILLhkk=; b=BKXpZ0uBffnIXUd44jYNYymX8NvOygEOzTW1H+
	LO3hKZ3Ume2i74ijhKRAVOpCdH+if4ulzGcdwV3oWKFEmnKJBlHutPiIvx0t7hu7
	hQ09C2fPzCPG3AVEUhSFl1Zjngecfe2j9tjDCUDyZKSUESrVplx1lDywryYXbZDs
	q50wxuXhHGIqdjoSHUyz/5E+Y70FRUkX3DaPzBbqqogcrLFZs/kuYVTIurVr/QYP
	w+iyAa8nsyXsH+PKhTT5TPyBvCZexsa659FyR4+hRxs9IfQwHamLdP+cU5c4H/YC
	qLR6QyUZAAoqmfzy1bMDo4MbamZmRwbtrg8YOvEKD6DQEgZQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p98ybw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 04:58:24 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36f26e6abe9so499044eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 20:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793941104; x=1794545904; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XsgzVUmQJNtfxzke+KkwGJhVOf8KyHdxG/9A7ILLhkk=;
        b=HjcSWPvgRbI79bJLZwuzMZYxOYWToHF5Y0xvf43i4Lkt44mZMrHPmGfEBBCOWjcQmU
         q3gL0sZ1sToe1ksxSZZOAk4qiTk03Xvu8cV623FzONPbtwzEJTlzqONaOd39eUdF2tTl
         hxH6pELpP/Gd5p5U73doPb1U+oqM9Ma3YaS/G1IDndZYoyS/0JHNSdA9azqQF/WJcY8U
         VjeWkC9EJFsPWvmjJIsRcl4/0ULiuVPJq45ACIFKBkyvg1Mt4Xf6gtojPgdPwrPw/QZl
         Bhz11PJCG9xLT4tJPOF1331MDrz9fJHN/paQ6azhPwyenofIzFZ2M/ES7pgIUbtvyno5
         BR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793941104; x=1794545904;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XsgzVUmQJNtfxzke+KkwGJhVOf8KyHdxG/9A7ILLhkk=;
        b=jm1X+RuKefM4ldE1fWsSYgnrU8MfxqzkS/Avxy9SYCmUvRDkOzrpkHhgA0qF3ac/Z7
         z9d45O+LaNLoLatEuRRwYjA5+udS4alKeAj1skTEFLZPIx+QZqXcz8wREIngAE9KFe5U
         WDeEC0aXICM8mxvq6xhwl3hR8365EinnhibG1rCU3R5kvBvfkhOXYUnAwkAofPGk8oDi
         lGaf54dD0REVGRH67FcL4wNiJ9zyNwhjhwWxQ6kNQaHjJF1InyMGha82jr9/ml51jaVi
         Oec/ssR8R2boUuOQxxugZ4AM0GFAbnvzApHkccQdv0e3WrdqqesjPXDFYccknlLWK9XR
         TL/Q==
X-Gm-Message-State: APuU4Z/ADZmkVhLueD8h5ZNp8fdw0FgOUw/slu+p2+sJeZuxF5fHDDhF
	14BkJMU/vA3lwen6guPQzAMqHL4W1N6avQxepet8lvn1Ru54IQmm3NHk+jRYHAUmKlCOxfQEhaH
	JlGH9FuVQktlnqPwHbKSzzRKd9b3Gwznag8pZbYleP8I/Nbkr0QdwXlG7oZ3W1OE9OwYgNQ==
X-Gm-Gg: AYBFou1iBkpZjLNsvC0AA3nIh7UL/nbvsIjjKbSSbU5lE4VBAw29gQaTtY93f9Q+UTZ
	ZxkJaqbnc+gAifrdqQqmYhUPiuNiIYwKEWpQL6hpvyMWbbXjUUJmzJc6yiMMjIVSYDxZQEJKPVW
	5NApQuTbvOgkByaAG/thl5myZKbVW7byOHyv5PMQm2KdHHgQjEZ6x5jyp7JDzhctIu9qOaFrOo/
	/ggO4xdtOdOIvxQ7yaTs/4QhtuX0JEybbMaVVCifDY3xIZNKk9CIv1PWuonKHk4pwW8S1fjIqLr
	IwORNUBfPOtrlT/zWGkXsqBKgYm0ds2wTET+qDa4aShP+CGm8c0Y9D+lOMwCO9QDafdyXSK0R0e
	JaM29WYWE2uFxK7l0Ddb1tc8tvQEBxwkpafxq4ogwuPCwJwumGe4/2+Aub9k8aQ0Ju/5EFE7URP
	fppS13TUeqI8n7SnibhMoQbE/3fPewRXDOrjDTgvZVcscyuEUPTpPHVwxWoAaBSrkLKBlqTYkxv
	Ps1
X-Received: by 2002:a05:7300:d112:b0:36f:6b99:f963 with SMTP id 5a478bee46e88-36f76023b1bmr1859385eec.21.1793941103838;
        Thu, 05 Nov 2026 20:58:23 -0800 (PST)
X-Received: by 2002:a05:7300:d112:b0:36f:6b99:f963 with SMTP id 5a478bee46e88-36f76023b1bmr1859359eec.21.1793941103304;
        Thu, 05 Nov 2026 20:58:23 -0800 (PST)
Received: from hu-ramess-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8e3a47esm3021327eec.6.2026.11.05.20.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:58:23 -0800 (PST)
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: Fix HE BA mode and extend
 buffer size for EHT
Date: Fri, 06 Nov 2026 10:27:41 +0530
Message-Id: <20261106-eht-ba-window-v1-0-622f2272e582@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAEVe7WoC/x3MQQqAIBBA0avErBtwhKK6SrSwnHI2GioVhHdPW
 r7F/y8kjsIJpuaFyJckCb6C2gY2Z/zBKLYatNI9keqRXcbV4C3ehhu7TdudzMAjKajNGXmX5//
 NYLJDz0+GpZQPxE/huGkAAAA=
X-Change-ID: 20261106-eht-ba-window-5c2df1a8e910
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Paulson Raja L <lraja@qti.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793941100; l=1181;
 i=rameshkumar.sundaram@oss.qualcomm.com; s=20250120;
 h=from:subject:message-id; bh=rbcT2clgcen0buC6OtLy+ozWF59CI4Wkol1yGU9nElU=;
 b=gcqBGq476ntp/TuFBnNIyxk7qA7phEhnZv73IWeGFuOdIj96tGa0ZjaX++u8C725SdCkgLb9M
 OK93rJSLTTODWc1INGvjkNfy/0+dtmWLIq+zjyMQ0xDUJxs9m1jeTgS
X-Developer-Key: i=rameshkumar.sundaram@oss.qualcomm.com; a=ed25519;
 pk=CbWiiM4JikGBEWI7HtrEEE/Hwkk7TTcob0SwaFdAwKo=
X-Proofpoint-ORIG-GUID: rnXxaM2khhepHKAwQx8A_2sIpLE-GMYF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAxOSBTYWx0ZWRfX9M6YBXo4THHI
 moa0U6QXoToD7gXT57Xtqa8n58NeNpG3QOoeonMVNvfWNRSfYddjNnJ7a2hO3r3o33+yCU/F6bw
 s1xtGlE+SyjmWcox8SBKt+8Z+/uxMFYPMO9oBIF6PxTYEWqcDT269fr0tv8Xm6LOUrVkYf1E6HR
 EmmTtF9/YvCzuMrFCSJTAqYbunZg9toOSDQjE7FfLZz9xr+wt1axG/F3B5PIcThJ0i1+jeZEi6k
 EaRtBAawX4j6IZDN4pimUtYtbO8DMaIf1LLyePS6AZiTaajORBBodxaxlkVR8955dV4kR9/8s4Z
 Q+3WYN/q5FQuQ4NX3rh8S4r6Qi+6yQ9xTXR+j3C6tbaCo3DnHAbEvlF4Vi/BqQK0XZqi9dbNZKw
 cnudqIDp9rzQ9UjAY9BWKavnnUkNeytPLiyU87el5ipzhehDuzG0EfG4m/eXZVEqBN8axU2/4UK
 ny2hZM4tqAQU8Gmy2Xg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAxOSBTYWx0ZWRfX42PSgyHhyAmZ
 80EHYoczEjNHipVeC016XEdORjEMJFT17OV1Hvr8VvHTfjkD0CXuE2f5m1ddiukH4iSwA++egZ5
 fkw/GYQj+aPpZrJYYwGPOdD9cN4Om08=
X-Authority-Analysis: v=2.4 cv=WMzqzXsR c=1 sm=1 tr=0 ts=6aed5e70 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=2SF_I0XtRLf-0q3h2KYA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: rnXxaM2khhepHKAwQx8A_2sIpLE-GMYF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060019

This series addresses two related issues with Block Acknowledgement (BA)
configuration for HE and EHT capable links.

Patch 1 fixes a bug where WMI_VDEV_PARAM_BA_MODE was never configured
for HE in AP mode. The existing code placed the BA mode configuration
inside the he_oper.params check, but mac80211 does not populate
he_oper.params for AP mode, so HE AP links never had BA mode set.

Patch 2 builds on the fix by enabling 1024-entry BA buffers for EHT
capable links. IEEE 802.11be extends the maximum BA buffer size from 256
(HE) to 1024 MPDUs; without this patch, EHT-capable links were limited
to 256.

Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
---
Paulson Raja L (1):
      wifi: ath12k: Extend BA buffer size to 1024 for EHT capable links

Rameshkumar Sundaram (1):
      wifi: ath12k: Fix HE BA mode configuration for AP mode

 drivers/net/wireless/ath/ath12k/mac.c | 41 ++++++++++++++++++++---------------
 drivers/net/wireless/ath/ath12k/wmi.h |  1 +
 2 files changed, 25 insertions(+), 17 deletions(-)
---
base-commit: b9acb873d035fccc8824164246535ea6fc95c71a
change-id: 20261106-eht-ba-window-5c2df1a8e910

