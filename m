Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B577F1A2C0B
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785287136; cv=none; b=UkCo8xHix7kO+FQ5xiz+vBeMahNAL8maHDIdrcc8ggH6RZ0xyutHc4qXTWbFjxwZgBFhES+VTHIJA7XhDD0cmtn8yG8Pk7FiHmAYyXXCpiEaJLSMYrTR72qwlQzj0naQhiDFm+4HwFi1xM99eFGAumlbVwi8v5J/z++8NrvJLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785287136; c=relaxed/simple;
	bh=GwDBM9yinHi98jy8aq34Y+BliW9ODoMllpMzxhxbsR8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hH6xE1F9e835CIPP4PF0zDsqS8lLiGvU3+R1oCwJiBvaSSz72UwFKo4g7lyZihQ0raqxbI2M4ErmZPQFosWgeLAKEfiXttqT5oz6aiAWZXBDeg46gdQ/v5gQ7Tf9Kg6VuRFTJNGeKwYbKlJ4eaoMRnhuMCJctyQjk3bX2uxV3Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JKSl9Mt9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WNtJQCET; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JKSl9Mt9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WNtJQCET"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SL30Zr3959352
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=MZOKf9mSd0crSLc2wh8F4z
	MblAYXsOwHLgHJ66RKogc=; b=JKSl9Mt9+gt0IHs6Rf0xu63xOpDPX/vivq7WaV
	+aQVM28mZvKa9sLgrd0BqBIEDub399c91g6al5rLjkyRxJLdty8ShQ+l5m7TG3Na
	+jhN+mDdYqiRCXkjsgKeYsf4O3Xb37RC0E74xGXx7orShoWY05IHA2zgeY8dIueR
	dBWUw/A22dnJoegupbX3ebDGyEKBILh4l2HgzXM6wLRAxDxYwh5x/BGxDLnD+atQ
	fgkAg7tQtYtvDDvUITraA3DUizGpuSHBYcXbpRYj+un3Lzi+riwEmUDjNhYFwm3c
	2zBDsU0Xc+QeWzIeAV4OZyQto25c60T9LsDimS7177A7jBzw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpyuksuew-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:05:33 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbbb9c9bfc3so217594a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785287133; x=1785891933; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MZOKf9mSd0crSLc2wh8F4zMblAYXsOwHLgHJ66RKogc=;
        b=WNtJQCETeQ7D98wX+QYOBy8MYhJQ2j0sQAgE5gay5ed4+h0275VIInk4Exn4Fmb2UC
         zHZhhdoG5NG036CFcB01gapRLDhkuy8FDbMObxcuCNcWjNhyEqbnJ5uyCu1ZWz5rI5/3
         G7rOx8myGe6Ia3F45RxlRBTKOzxExAvg/0pe9RNtXk1p8Jv5QrMRYofISPOv9V1ZVZsk
         JBiiv4Wy/zdq2IKnNED9sz0yt7PuSSUFhhpM66+MSpE/f1+/NCvZlTi91AZrxAiTxsLC
         q1e3ciM5QEPyQ1zTgnCzhxLEEYcD/y1P3z6A7OegYSmhxDwp+UEiJcYtwB5A/nfSuC57
         Pjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785287133; x=1785891933;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MZOKf9mSd0crSLc2wh8F4zMblAYXsOwHLgHJ66RKogc=;
        b=UGC79yxoRsl0NIFT7cRX7huTRAWkJ+QRgocJQWmEhAuMtsOLh/B3cHYDNrRXCm7DpO
         dXiPerMcEdgtnVX60oWZwN1aXOtDcxZDNs5aBVTuXUDwKPr+g/z4mx8IikX049yKAwB1
         j4IMeFSb2RSSTm+vfxWIiJiJoQByLfKxgl7Kn91KP/OPKVB10ZAxZFu0DKYV3KXXsWWW
         cj3NVNp/eSg6s7xl2A8qjF9++JMjHBPFNYz1UuAfddc92Ahv5o1Ngv1n7w8kfaovm3d/
         v4k1eQb1I8alLQEFd1mqIBoi8X2FeWTMUJv+egayH77+9XY6noncA4jrZGZFzZYBTm8J
         2kzg==
X-Forwarded-Encrypted: i=1; AHgh+RrC2IR1/rS6pB7RNoHKBhAQTwIFaUlMpO5bpxRlz/GN3OaRGnAAhJ65uKpzzoVMh+mI/5peuC2z81NfeRRDKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyywSQwz7MlJjPbOag9piu0/ANpWnYNhqhjXKRBy7W/qXG2kqsm
	Ue6ZvtBspBPRsRqdC3Xqgvnd3VL8MEtOTGKJuhZ2egz+SPfWEbnQuS5G8YLPnY5zs2weSu7DkKs
	+UvokLdrZMtjlBvBC9eB9bcp58hqSEWybHTYeGV2oMJL25GWHGv6HhvQAQsbum3ith160FiayS8
	GX3Q==
X-Gm-Gg: AR+sD11IPvTzON3UdwqARBcmNwbwI6b1S3WHbP/65eUtS5xZWcP331ye0PlbeIt0MC6
	I1Y+3u1/aN5G/PScKbhCiYxzL5+WNp6zj5sKntX1pwtZ+RSogT0qI3yoGn1SwT/HUm8rDWAgkNK
	sJojKAxiYRzk2+pHSiXZsD/4M8xvbRdr6XshPSEYrZr/cvTpXwMA202YcKTgfjeBHVS/rHBFgFA
	1+lYZfTRP/BpGLoryBHOeOjQr1ZllIerGzgc8SuQx/5G34mborQ8+XocrxReEALtQyEhAxSettp
	dzKcqKnwMiJbGImXoGnOPRt4FolIuMIlz9f5ob6+uhtqoXDQifdjuleBfGRcx5d8V/K3RFctB9s
	ePoXPRf5AuMaEt9B8PtaAu4f+1Ey9ko6maTUPBjMk7sLg6rEVCRiPQDw=
X-Received: by 2002:a05:6a20:908:b0:3c8:e313:8d42 with SMTP id adf61e73a8af0-3c8e3139510mr383622637.31.1785287132687;
        Tue, 28 Jul 2026 18:05:32 -0700 (PDT)
X-Received: by 2002:a05:6a20:908:b0:3c8:e313:8d42 with SMTP id adf61e73a8af0-3c8e3139510mr383600637.31.1785287132249;
        Tue, 28 Jul 2026 18:05:32 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b67063sm3699381eec.9.2026.07.28.18.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:05:31 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath: fix stride mismatch in
 mac_phy_caps_parse
Date: Tue, 28 Jul 2026 18:05:27 -0700
Message-Id: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANdRaWoC/5WNUQqDMBBEryL73UhMUWu/eo8isiRrE2g0zaaii
 Hdv8Ab9GXgMM28HpuiI4V7sEGlx7OYpQ3UpQFucXiScyQxKqka2SgqPegh2GzQGHgJGJsEpOkP
 CO/aYtBXUqk7VNznmAeSjEGl06yl5AiYrJloT9LmxjtMct9O+VGf/j2iphBStkYjXkZradI+Zu
 fx88a1n78sc0B/H8QMAKsWj5QAAAA==
X-Change-ID: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=O/kJeh9W c=1 sm=1 tr=0 ts=6a6951dd cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=rUlN9L5Rg0sLS0zbAgQA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: _C3Qv9lS8_bASjcXVx_rucRChS-vFvRa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAwNSBTYWx0ZWRfX9dQcM/1XuTjR
 3SSMi132vH7pv+fGbdTwxghjV4Z7HA6rVXcH3G27L5Gvms+UODyBCEw95yFFLQiPAWOSJCdaSm8
 W++cvvg6a8DcoQubmeAf5LZKzFlwvkfC6KjhwZwMIOPET4Zp8xVsFFuFi0G1oIUKLb6EEoUiH18
 ymGIseGkisLf7epT7Jivh9J2TAogHjg4QPl6Qxx3PfJF/ZOWNq0eRWyOIEyw/4vKZ4F2cDOFFnl
 5COvhMWIrtHN+v5/GQlhSNPUeVPKH3NkqRY5F5XS1AFIczZwKKsUDxvhVtrKd/tHKGBjIg058QF
 efjABDI9+qZNgtrjDLxyDF8DE9bzwaepMIuaF/QZtmorWb0zpnKykufq5SFCdIkjKA/w98U0H3W
 luZqIqNYndRD4P2SGolNZSMz+6UYNgRgeyM8+Ody3KDpR+M8gFcHgqxAzSanoXvGJkzx4sTty/J
 VFK6FrhLqIfqnCccjaw==
X-Proofpoint-ORIG-GUID: _C3Qv9lS8_bASjcXVx_rucRChS-vFvRa
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAwNSBTYWx0ZWRfX2b4BFulKldck
 WngovulG2kyLH9QwqPJVlYvxQLqjZ0vrIlKjg3PUY7fGUA+nljwWzdpvBgiIm2bG+6M4GDq3179
 fvfbMP2oxpJSEU1bxuzlT221uhwj34o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_06,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290005

Both ath11k and ath12k have the same issue.

---
Jeff Johnson (2):
      wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
      wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()

 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)
---
base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
change-id: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072

