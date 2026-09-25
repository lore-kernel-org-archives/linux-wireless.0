Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1C349CE2
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339214; cv=none; b=RMjhxcmyIFyb7VvXYKLcc9yNtQA0nSCvJUKOX0+iJUwIS68IxOw+Ql5mjdFVWBR1NmQIXOX04epahR+FKVMF7PzmCCI9r6ggglQo6tFW6lOmHntcpv8IFqqy1jsL+0x/eD46ZK5p+74QtbiMofBWCiGlbXAcwZ/UMM9f9mGkYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339214; c=relaxed/simple;
	bh=99ZhWm5ib2vFmSynbfS3jK4Wjk6UiZl22jnPjdGpxQA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=AxCe4h/PeT0l7fML2YwWdRzW3/sOGVDxrFHzygIXOwBpjNB3T+f+514LGWmQuGCri5nqONE/46XjSQYb2us/BcsEkWFZ0zhx6IuzShmwEZhIk50Qlm4RJze2zupVMFWRoTMgHWZx7DP/wNpuhs2dWmLb4sDsdu8qoH7Rhm6WUvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f78eA2bL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YH/+wXk8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f78eA2bL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YH/+wXk8"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PA4Jrd609258
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Bm46YzSdldmp4+oNTJBO+W
	7nwg5CxRXmyqvIauGB6BY=; b=f78eA2bLUfoV5Ok0frAY9NCvRECjhjUxK+CyPO
	JBwyq6/e/BOjsMPYFgkfuCLVLg1CuP6G1ZwAoyGMTt6+yUmqCATuD65ROkYdKIV7
	YX5/UuE1cknU1RtLVvW85rki0bq7+unOBbCWbjrD00BJnlSUHoZzfPmkokvFWtqx
	V3ODjp1h/YfP0buDNu2ljHiIzbOQVokRTBhr8e1Jn4FQwa8Py9NjoZo/c0vNK1oj
	hsdrGdslgn/tnTWZRMuk23jnDuvc5x5zgc1b+8Yeu0kW4spEeSuLbVX13TDIUgZ1
	iVYkEO+tz8H5hJn9GonuH+p3lh3UftGL+lDdsANhLsK5AtGQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwpvnrdb9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:51 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so1004367a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339211; x=1790944011; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bm46YzSdldmp4+oNTJBO+W7nwg5CxRXmyqvIauGB6BY=;
        b=YH/+wXk8Jb/T5tpjlAK3vMdIFrTJ2LX8kO3MRAnfnKYN+kRO9ekF+cRKfnjZl1ycDL
         bbeYgYPxwlwFe2Ew7snqrY30JmHtjSsEKdvUgEv3R9Bsi7e8fT7s2o7WRq5Olv101Nw/
         AEKZIgDS4DsyNRyPq6LpnhEBXUq7WFxzHFW9hnIbH4Kzyib91jZJP6YCI8jtY3XW9p+A
         X4u0r1Mbvu0+1jFcJraFASbIcC0HhH6MsIT6Qqa42CQHWFZzpXImbb91kj7I2GqivHDO
         7UKSkBPqHe76A9OMTtgUgSbDuMQamANPnQqzRBNlMMeV19kjRK76FgBZDIWwBEcjsPdb
         HAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339211; x=1790944011;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Bm46YzSdldmp4+oNTJBO+W7nwg5CxRXmyqvIauGB6BY=;
        b=vznl055XByUHnvBNfGcj0YsjhjnZy/h6K9OkAe8c2P6rzEavxatKn7hEXIhA5ybNgH
         VNp8MTW5ya0vOLM9JVKY2vU1fNTmwPdXKd1AuGeK8YzkhItz6qMzrwkYxKilPjuf+b24
         6HwjTQz9PFr5GY0FFnWAmGJs0xowVpSqLSUSjV+ngCZ0HKwfRQnJrsSWMRnsxvjm9stT
         zy+mrgk3OTRosC3JbXfjXVCBiOdbEiq5yaJKPKixA/kUrgL4tf19ICjKv+UqAukVpU44
         SS1g3UnpwAODWklDghE2XYdSDTDQSv7avV0oKaYG9XW32HbHMZklSMmL9HdDM+Lcj3OG
         GJvw==
X-Forwarded-Encrypted: i=1; AKwUvBw5ECxLZi9q6zkBvrljGC83U/6+6K7AU5eE7uNj2+08SPLW8uU6xCYGdFCpLDdFTk9ihA8aRZ4pgIRHAtDy6w==@vger.kernel.org
X-Gm-Message-State: AFuF++m/oL1CU+YlM3q+/Vip15b8qzjLwalKpTLVTz8nAAuVY/RuUwCj
	QMWXd/RuVltQ6qvr/Lr6zSBdDUJstF/QPeUZXQW03eqMBPwZZC8rjzHOWO74D7D/Hca7EaSVKnP
	KeGBBYuKRAsx5ylSTX9pfYxvKhR3JX/pZ1NzMcOam973XRzRPjCid58McJRQDcx/iQvMmU9H/WW
	iChcHDDqE=
X-Gm-Gg: AYBFou2Wo6e3IaXjO2RI6sKYOTEOdDYAJPbXO6H35g/VcVDqoEU4PE7tgdCF/+39RyK
	v/DpijxTCIMb3vP1vU9EypzWKVI50BLKFJMWmZ3rI8Jm3TqLZKXcd+4YU3pKodcw4+e48uG9toe
	B1S+IYiJIwvmQE/7cd8o7hGVZmQQK6XgJAcPF7bB1CEYLrGXglGXt8FwKpU7aN2nAOyqSyTiL0n
	0azF192WVw7ArPmW5A8XiNybVgVpxR0GNjKwwMJ3F+LCM1q9FZumwrX6Fs4oYdYDvubIhsVSE6a
	VR+YyyQiDxzu5a499WZqi/hTiBSf1b747mnPcB0K9FyL9XORh+JpTa3H8xA2m2W1lwAbYNdIpkD
	pi4ZBSLEg+Xh+6gVsuF4fi2Z30O0RCLuSiigmIFuYkQTmRXZXddk=
X-Received: by 2002:a17:90b:4b83:b0:398:990e:1587 with SMTP id 98e67ed59e1d1-3a0986ed065mr5067320a91.9.1790339205967;
        Fri, 25 Sep 2026 05:26:45 -0700 (PDT)
X-Received: by 2002:a17:90b:4b83:b0:398:990e:1587 with SMTP id 98e67ed59e1d1-3a0986ed065mr5067308a91.9.1790339205432;
        Fri, 25 Sep 2026 05:26:45 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:44 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Subject: [PATCH ath-next 0/8] wifi: ath10k: fix recovery and WEDGED failure
 handling
Date: Fri, 25 Sep 2026 05:26:30 -0700
Message-Id: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHZotmoC/32NQQ6CMBBFr0K6tqSUgK0r72FclHaQqlDtlAZDu
 LsFt+pmkp/5/72ZIHgLSA7ZTDxEi9YNKRS7jOhODReg1qRMOOM1k7ykBbtRNNZR7RV2VBhuBOw
 rJk1J0ujhobXTBjwRFTo6wBTI+fPBsbmCDitv7XYWg/OvzR3FtviliYIyamTRNnUNWhfy6BDz5
 6ju2vV9ns7miPI/Ra6UxlTKcFaxtvxCWZblDW3ws0UVAQAA
X-Change-ID: 20260923-10k-sdio-crash-8d2d8e7509d3
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=2070;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=99ZhWm5ib2vFmSynbfS3jK4Wjk6UiZl22jnPjdGpxQA=;
 b=xTluDUbPL5s1J+gzYcE+movRY6wWWqtCZDBCvvs+Jl7T5PygQHVcaXO54BB1JL1PV2xwnZuzf
 pBewMXHddt/AwMbGolt0lPi40duMOUf558WTHNBkJET5ovuQD3l2so4
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-ORIG-GUID: EJjtb8YPCM2q6XbUvK2CoO5dVgFlWK_r
X-Proofpoint-GUID: EJjtb8YPCM2q6XbUvK2CoO5dVgFlWK_r
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX++CRZQn8UOUt
 71+Bd1ypQOmbkOqs+LycV7VwAfJlX03E2v6RvlS0fz4GJuXoQzr70F5MFbXwOjoE+QYwgPusvMI
 RNM6mSCZBozpt5Ca2PcPQa9Lp6RU8Qs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX+Fh7teVp0oxG
 VJZs9GWlho8zLf4EQ71mTGd8MNhXbQJymB6ncQxtEq3PXLdqrtcCnAKAd0H2POZCO5zeAVYS9t7
 xSTG9GZlDJThgk23AisjzeNN3hi0uFjxyvBwhYV7eXLosz9QWILTsFojtnwAXwDhNtQQQI2wJ8n
 q8wDxZoCs0N7L0GZJf8sANRFjIYzpiItnUiOgM6nwU0TuO0iwlW1MGKbrxD41l8kwv+rYBEQ+nF
 crlcOHRAsqtJYOR7orquktPdIhwJRzsWVof5TkU1/LqoS8GrUOenlNJP9oQ/TCPfK16v0xCq8Sr
 DnXxh1QfkfshwgcG7H3grTQjVRjLwN1hyVfWcqn7/eHj4Yozk9//o67WJNduvpMdw4pv3qy5Wk9
 asn8nQAEpiM+A5wFW1JSQs597iZmGbce6iT+uELweatUxMfSj2+5jtmZIf6O9+YTrh1zO1F8HjG
 061xZFj7+W04voypKmQ==
X-Authority-Analysis: v=2.4 cv=eNmGH3p1 c=1 sm=1 tr=0 ts=6ab6688b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=AsZdo0PIdGKIJ8m7CAQA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250049

Recovery failures can consume significant time before the
driver eventually gives up and enters ATH10K_STATE_WEDGED.

This series fixes several issues in the recovery and WEDGED
failure-handling paths, including recovery detection,
recovery time bounding, waiter release, and PCIe error
handling.

Several patches fix specific bugs and therefore carry Fixes
tags. The remaining patches address closely related issues in
the same recovery path because the fixes alone do not fully
resolve the reported failures.

Taken together, the series ensures that recovery either
succeeds or transitions to ATH10K_STATE_WEDGED within a
bounded amount of time, avoids unnecessary waits after
recovery has failed, and reduces the likelihood of watchdog
timeouts on affected platforms.

Google has reported this class of failures for an extended
period, with more than 4000 observed crashes over the last
month.

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
Kang Yang (8):
      wifi: ath10k: fix SDIO aux workqueue starvation in recovery detection
      wifi: ath10k: wake blocked waiters when entering WEDGED state
      wifi: ath10k: also wake peer_delete_done and target_suspend waiters
      wifi: ath10k: bound recovery time before entering WEDGED
      wifi: ath10k: check the recovery deadline on its own timeline
      wifi: ath10k: hard-block the radio when entering WEDGED state
      wifi: ath10k: remove now-unused driver_recovery completion
      wifi: ath10k: trigger recovery on PCIe MMIO wake-up failures

 drivers/net/wireless/ath/ath10k/core.c | 136 ++++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/core.h |  13 +++-
 drivers/net/wireless/ath/ath10k/mac.c  |   6 +-
 drivers/net/wireless/ath/ath10k/pci.c  |  27 +++++++
 drivers/net/wireless/ath/ath10k/snoc.c |   8 +-
 5 files changed, 135 insertions(+), 55 deletions(-)
---
base-commit: 10cfa109c880092df32e396647b4afdca9be8350
change-id: 20260923-10k-sdio-crash-8d2d8e7509d3

Best regards,
--  
Kang Yang <kang.yang@oss.qualcomm.com>

