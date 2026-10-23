Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738877;
	b=0CUvV5OrHAhcH1Leh3gwz2WVzKrobYHi6Sq2P/7loNITbbYerYWVozGVpQO4jTKKbLFQ
	 C7vhr5/iHxplr73It5FF0sfh2BjsSKo463Pvpb/dD4BtMgOBKUS8Hy3zwTQl+MbXkfiYU
	 iwwKjyEKujpevVqcY5xffJUSrO95VASLfC8Ba89ITvHzR7pEsTGgQtzipeOjDRjMMyt11
	 /XKZ0l4iDHM3F5UenOtzWmDcoBHBF8L+jAowPeu7dX4d3et1iKkJbXIOk5IbtEdcOY50m
	 gJd1O7LliCBVpQytuOOmykD76KSAuVR/8jT73oug9xKEK3H/tZEW2oyU8je685p3JeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738877;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=p8K8L3wm/2TFwy9MEBg0/j022FtSD7ewKzpYCuY3Up4=;
	b=gazDVVIFq3wawL3WN3ewuofACC7WAbAUnuSJ9/uLg+YvnleZCse/HDT1m2wMjHDAL7Xb
	 KxJ/uLrLoCtzk85VeOljwN2K6iC5OCLw5PSROhe+gY6z8D0TQD4Nvc+WZZ1Z+SNNR3yKR
	 LZi4R5mwJHxTJN/btol5Mf5TfHAQ31E7ejqNrENpSATN2J27spfAHadCAnQ18TSqasMVK
	 H1TqFdmUBSiCqCPpbK0zWMzVPxZHth7QG70i0Wki45DKHvfWQDjGXKdLXHEukv+l4UTXj
	 CVUE10d0us02QKCcxUvsehs86qA8Dg9JXC75B46W8sIWcVrnwEYdqQXS5/pugjWY/mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="LqEZs/9C";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TQyFQ0Er;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2A606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25F2A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LqEZs/9C;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TQyFQ0Er
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1G6Lg1795935
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=p8K8L3wm/2TFwy9MEBg0/j
	022FtSD7ewKzpYCuY3Up4=; b=LqEZs/9CtzveTW1BQmCuKGsRV4Ouli4SjIZIHw
	Kb42DKaWDD3kTRLwXim4TKFL/0VSJ9Cigi2lKKyfGIF9wVVu1JwXsw7DyQENjOJF
	GcBAFyGT/T2QR5Yx9hDIdUpmzaF130CMLw/+Mr5cggLF0Y3k+yLVI4U7hYFEcySU
	fezzCshxBfCfK2+84fgpGxYFwkSMg1z0h81jFjBXm8K3SiFVDt2+jpK+GaSb8oV2
	V2NVi+C0gxdLjyHvTOAGVeFDs4jKzlf/t7N0X1SAVuZCu87rHBSXKUuQQy2jX420
	LiQ1QBFx9Z6lsWRNR+07spaJpZoNDrBIQZU00b87Wgex+wNw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfnq0jwd0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:16 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86261e66700so456789b3a.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738875; x=1793343675; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=p8K8L3wm/2TFwy9MEBg0/j022FtSD7ewKzpYCuY3Up4=;
        b=TQyFQ0ErsxKQjebb6LIqAHQh6FWHYCixcj311dvvQ7oOm8AdxAcuqMlvH5eHLO9iV2
         6/+QNcruh304LmTUVxT+DXC47WMNSsnGeFgORZCz5hlsVN1rgOo16Y2eHKnhXqz5+wQr
         eJjF1WfRAHQ8i5Iv2K3mB8j89WkXApkgdc/rN/aTdy2LXi7kOzuW6qi7vUtGLU2TwAmF
         rKCVyRxNRLMx4U9lH0GKlUOgPzK2JpFynyYQEGZbxNw5pvAurGkLMCdd0IJfen7Ipp8j
         m7txvGxdC6Iure8LeUbOIl6hp7N5RdyjGCkZ4+5ZuK5K+DM46spnN5i1ONbE1J9q9aWW
         mXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738875; x=1793343675;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=p8K8L3wm/2TFwy9MEBg0/j022FtSD7ewKzpYCuY3Up4=;
        b=KcQc6k3oBQB14MxiluiuMDaHqCvsBiq+fyFmY76UFonLh9imkfSPFVucd0T0r23pwY
         54KAs/8qAy6W9fn5Y8aFhEhGCWqotgml+91TYvKu3ySEmVT9gxwBhpxe1NdyoqRKhAuj
         d2LcvR/ez4F+Gn3jsqPYiof1bwJE8UXK9/ZFtc3kKZD3f4jVp+7q74F/7KTCdlhOyyo1
         G8UfavD9sMCE4v3qfUyee7eCqM4QebgD3C0CpcaizC0uJOs8jVTzIyeukH4p89Nzog6I
         LWslt4rA83r+nwwfESpvmk8s+cQyWSefSYHUw41bUHUReuIaqjpo6gSdT1tNNZlTLGwY
         8pjw==
X-Gm-Message-State: AFq9FYK1v0pEmU8Tjdo5xSBKUnfoEE7IaG9Y+xyUICimy8bWtpi4q0Kr
	A9mfk0qyVYV3SflUt0h02g0kZncDmF+pc/g9ODF0S4LPYzJInuMPbe6JkjYgPlnqQmfbWrXnu07
	OUnWPZGIoPI2zgiMYWgkSKZMF2n3eDGWNc+ybSZ44Zj2xZImAGx0r3TPwGIECJGTAKoJxXQ==
X-Gm-Gg: AYBFou3zEsn7E/lBCIOQ1pgGOf6+I4v4k3PjGg+Ayy0hTRBnIwosU3ybcsQlQ0y6Em1
	7Gsmgakha0BaOpUw+lBvnHgL+8N18EyVTn8GvBLamV3o7F9hi9w/6EH9IPs5vn/ZZc7pjks/b7h
	bxlw5aseBsLEoDclzQWsw4rk7F6zgiMEJG4WWFgGYYs1OBFkvVLsxYIgKt45DmVqR12par3xFtp
	cNUEhRfZbJgmxnnEhlOorgc/14gEXG3EUG0oBtulRY+JAoLS5+lnrm7QPuzx4I07ZY2bDy+39pe
	nhKi7O87hUkdnvgZxXRXM+gU0Qn0GiUI1Bg6nog82rwsoJm+G3vFZ5IJZavNETosxSZPfFfd1x8
	VMgyCTgrysvnUFI7FBE4tpVyHhy5L6nbpPFxNpndE3VwGE3m+yNqxqfNZPlOsYVapI3ukUwKSlO
	EeS3wTcUP7HQohORvxFf1z+g==
X-Received: by 2002:a05:6a20:4306:b0:3e1:c04b:59cc with SMTP id adf61e73a8af0-3e3767aa572mr965989637.70.1792738874944;
        Fri, 23 Oct 2026 00:01:14 -0700 (PDT)
X-Received: by 2002:a05:6a20:4306:b0:3e1:c04b:59cc with SMTP id adf61e73a8af0-3e3767aa572mr965967637.70.1792738874414;
        Fri, 23 Oct 2026 00:01:14 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:13 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next v3 00/17] wifi: ath12k: Add support for QCN6432
Date: Fri, 23 Oct 2026 12:31:03 +0530
Message-Id: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAC8G22oC/1WNTQ6DIBSEr2LeuhjEok1X3qNxIfShNBUooLEx3
 r1ou+lmksn8fCsE9BoDXLMVPM46aGuSKU8ZyKEzPRJ9Tx4YZVVBC05G54jw2vSTIzVXZ14LVBd
 ESAvnUenleLtBFwdicInQfpMwiQfKuJ/t3UGHaP37AM/sWPwY1R9jZoQSxQsqy1IoqXhjQ8hfU
 /eUdhzzJNBu2/YB6TORMMkAAAA=
X-Change-ID: 20261015-mpp-bringup-75f457bef8ee
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: XMzsv1PSnMkvqxixZbxS3t3-HxRsv4Oj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXx069ZIBTm8OR
 C9hQ+D0hV7qd9tPkrz2+5iRQb0InHTuAuNJibQ/ZfOnpivGaqh0vhv7ycj5Ys+mBiEMEtAbRu03
 hWg05b9sl4mC6aS0URz9/G4dacogmYwz/B4A96aYupvFHLpm7VT8c63rlFi8z0GUb9hGFyAwsrt
 ujo3ds6bBQA4ebjC2e62aUJNWQoPQwUk5gRhYu53l7IEypChuym9DZ7Zt/DMKq0zh8l/9A4Dm2K
 nmGrA5PEoFYj2NKwSseHwnEnOolX3cljo6GRw0xQ47Bzm9+2pK7ydHpNJ/tYMfyeRyNV3fd2XwZ
 jJOeKyWPrYGfgwZ3P2T62QUh3sOAlLdngvAxcIzTuIZEN+PpD5RPqWV+6/KBSI48mTFpUGJktp0
 bjd/rmYqr/4yMkHHjiWSuYTwgiwXgOmTfoCTMte1qPnaKVJsDycqiqTcOqllHl/wTTi7qMnWUS0
 cvoeYLBqAB7kbV15EBA==
X-Proofpoint-GUID: XMzsv1PSnMkvqxixZbxS3t3-HxRsv4Oj
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX9NebUCeh11+3
 iYutR5znjsMCzTTa/KVNqanLM2fL+Rx2OXpu6+WPCDTAqvn9xEGgxe0udKsLpieKeynGL+M/5+d
 x9dJj8RZycyOx5xpwQRONjMbuTvJ5IE=
X-Authority-Analysis: v=2.4 cv=UaHE26SN c=1 sm=1 tr=0 ts=6adb063c cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=j9mdO8TpxRXb4I9anNkA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

QCN6432 is a PCIe-based device attached to the WCSS Q6 processor. It is
registered as a platform device (AHB), and remoteproc APIs are used to
boot and shut down the device, similar to other AHB-based devices such
as IPQ5332.

However, PCI APIs are used for device setup and register access. Since
QCN6432 requires both AHB and PCI APIs for its operation, a hybrid
AHB/PCI approach is implemented.

Overview:
  - Patch [1/17] adds DT binding documentation for QCN6432.
  - Patch [2/17] refactors PCI operations and MSI config structure to
    support different MSI configurations.
  - Patches [3,4,5/17] add hardware parameters, ring mask, and registers
    for QCN6432.
  - Patch [6/17] moves multi MSI vector flag to ath12k_dev_flags.
  - Patches [7,8/17] add hybrid_bus_type and HIF operations support for
    QCN6432.
  - Patch [9/17] adds support for unified data-region memory allocation.
  - Patch [10/17] moves MSI config to pcic for better abstraction.
  - Patches [11,12/17] enable MSI interrupt support for CE and DP rings
    specific to QCN6432.
  - Patch [13/17] uses CMEM write for PPT on hybrid bus devices.
  - Patch [14/17] stores and uses per CE DP MSI data for QCN6432.
  - Patch [15/17] derives QMI service instance ID per protection domain.
  - Patch [16/17] add userpd ID mapping per device.
  - Patch [17/17] adds support for QCN6432 in the driver.

Changes in v3:
- patch 1/17: Update the commit subject and change the file name.
- patch 3/17: Initialize qmi_max_chunk_size for QCN6432.
- Link to v2: https://patch.msgid.link/20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com

Changes in v2:
- patch 1/17: Update the compatible string from qcom,qcn6432-wifi to qcom,qcn6432 and remove the | character.
- patch 11/17 and patch 12/17: Fix resource leaks on probe error paths.
- patch 16/17: Move the NULL check before the loop.
- Link to v1: https://lore.kernel.org/linux-wireless/20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com/

---
Aaradhana Sahu (10):
      dt-bindings: net: wireless: Add QCN6432
      wifi: ath12k: Refactor PCI operations and MSI config structure
      wifi: ath12k: move multi MSI vector flag to ath12k_dev_flags
      wifi: ath12k: Add hybrid_bus_type in ath12k_hw_params
      wifi: ath12k: add support for unified data-region memory allocation
      wifi: ath12k: move MSI config to pci.c
      wifi: ath12k: Add platform MSI support for CE
      wifi: ath12k: use CMEM write for PPT on hybrid bus devices
      wifi: ath12k: Resolve userPD ID per device
      wifi: ath12k: Add QCN6432 AHB support

Sowmiya Sree Elavalagan (7):
      wifi: ath12k: Add hardware parameter for QCN6432
      wifi: ath12k: Add hardware ring mask for QCN6432
      wifi: ath12k: add hardware registers for QCN6432
      wifi: ath12k: Add hif operation support for QCN6432
      wifi: ath12k: Enable MSI interrupt support for DP interrupt
      wifi: ath12k: store and use MSI data per CE and DP interrupt group for QCN6432
      wifi: ath12k: Derive QMI service instance ID per protection domain
 
 .../bindings/net/wireless/qcom,qcn6432.yaml        | 149 +++++++
 drivers/net/wireless/ath/ath12k/Makefile           |   2 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |  54 ++-
 drivers/net/wireless/ath/ath12k/ahb.h              |  10 +-
 drivers/net/wireless/ath/ath12k/ce.c               |   7 +-
 drivers/net/wireless/ath/ath12k/ce.h               |   6 +
 drivers/net/wireless/ath/ath12k/core.c             |  10 +-
 drivers/net/wireless/ath/ath12k/core.h             |  24 ++
 drivers/net/wireless/ath/ath12k/dp.c               |  39 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   2 +-
 drivers/net/wireless/ath/ath12k/hif.h              |  30 ++
 drivers/net/wireless/ath/ath12k/hw.h               |   8 +-
 drivers/net/wireless/ath/ath12k/mhi.c              |   4 +-
 drivers/net/wireless/ath/ath12k/pci.c              | 111 +++---
 drivers/net/wireless/ath/ath12k/pci.h              |  21 +-
 drivers/net/wireless/ath/ath12k/pcic.c             | 435 +++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/pcic.h             |  24 ++
 drivers/net/wireless/ath/ath12k/qmi.c              |  83 +++-
 drivers/net/wireless/ath/ath12k/qmi.h              |   1 +
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c        |  45 ++-
 drivers/net/wireless/ath/ath12k/wifi7/hal.c        |   7 +
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |  85 ++++
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.h    |   1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         | 143 +++++++
 drivers/net/wireless/ath/ath12k/wifi7/pci.c        |  22 +-
 25 files changed, 1214 insertions(+), 109 deletions(-)
---
base-commit: 2d57db8fbf72b1872e7411e917166bd12ed5bc98
change-id: 20261015-mpp-bringup-75f457bef8ee

