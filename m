Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633859;
	b=HrRZOzgh6eDMdPBvWvByqdT965ipdDxwMnupeHsorONHd5MEzqEpk7QnfXa72npSaGqg
	 HRUBDcZXlWpytb0LmMsCqcH1gODGk5b+Tr05darUC/lBRpEdUKKydfGGi6BzGdSaFh2Gn
	 ZmfvnFI2/lh294i5daathxKYkKjb0jiCNBgyzxJrJKmRSECWtPhYbOoHGwMMGUIbGWDhF
	 SHjpPmG10D3iQloydBK0fQq7LHdz4fzakxmGT25WXwoQm53VdWAr0s2WSGatquOWN9uL+
	 GyMR8LQM2hMYNeOf6tu/w9VZHIlLEJiXsOK8VjIege6GkQTknZpGOOieE6bD3Kn/c0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633859;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:To:Cc:Subject:Content-Language:From:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=oyfnNpy1b78sl00t26qycUkL8HD/T7BbVQF3a+A49i8=;
	b=NRG/gUOdT85AGvEeghrbPgk+AapO/bZg+dtlXscMYpRKQgWgeL8LsGQhD5EKYCNbvu6T
	 IAhmIqMPpNxyFHKVzSEhVzeStgTZiAkd5CLVTv0xQvfTefwbjtBFli80SBZjP4Wz30qbg
	 jFlK0umCdqUklxZifT3MkHuqFtXPUT1vzwZJgCogRzRZDMk73UZ3UrUDdQ7FV7STwh2Iq
	 e8MJNfL9gY8XP1AZ8BWUcE/mQRPQrUHwC6EXw+j9B2eMs99RBAvQOsBydde6BJbdnr4oc
	 T2iWWYXbtBJxF4ELILe/OnZCWGPS0R/RoU29+LDGQfSyb6zM5z/G4qZzd68NCuHjCRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jjKN8T31;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EAkHy0kx;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC59606BA44
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:37:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCC59606BA44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jjKN8T31;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EAkHy0kx
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2Dp9Mv4033827
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 15:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=oyfnNpy1b78sl00t26qycU
	kL8HD/T7BbVQF3a+A49i8=; b=jjKN8T31v+jIiZZAXA8JZIFGeabOsy9Dd0Tkzo
	ntvNKWQkCMHHHbOUjti0duD98kwwbS6p7Gp+Mo4VNIGUa+g1LJjqYDdUT+PmS5+t
	4ixW8M1HIp9TFv8gOLuyRkndvnon3WR5suY1FsiNIx9UjdnAIUvZAblAnx+uY/8s
	URUYuCjBFU2lOtZZo/zsajPPkeIPbeQcW3GnnN9iQOjBTaQhMUVVa+OeG3SL2XVK
	l9FpLnDjEEl8DMtELI41liqUjeb5XYpweFbdpNrKJDVbDfEOzqOIS8PXWqojKJFb
	0TDqW1fuuitMPDsqwTfII4/xSM0yCwl/00MjUIoYyQVpjoJA==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hppfe9vfd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 15:37:38 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1acbaf81bebso3892287c88.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 07:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793633857; x=1794238657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oyfnNpy1b78sl00t26qycUkL8HD/T7BbVQF3a+A49i8=;
        b=EAkHy0kx2Ju50NDhN09h+Xt7G8xuEQeLcHX7nzl6+wmKS1VTG0D+zF0qSrhlRecJzt
         DbwdPnG+NpcmVc7bKW2Pu6Sap5nvgy0g41IpMEguk3ebct/+HpB8zuUpt+WJVToVPAgU
         adoCX/zyryGdfnsXbT8cn8KW9oFP1LpzJIPz5+OotwaR6ib/6W8n+8D1EpE4A5wknoTo
         WnMxJNM52sF+DFOPg7TL1n+4vxMSNc/OYL4FnYfl5WXUuTYmv+zMFs7cBBxjAk/CLCVy
         XTy+/LQYGps2pSvIBy9ALdoro8CVYFnPtmgAhhRvt8ETpj7aaB8uCzD349dLw2XHCzxq
         gOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633857; x=1794238657;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oyfnNpy1b78sl00t26qycUkL8HD/T7BbVQF3a+A49i8=;
        b=pc4cRecOcxmb+9WwNUPB2zVeCiDVcwWM3SQOvVQCGonxyqMAJ9J0JhcZUY1fOiFzTO
         D0HSuC3VglgOm46Y+/cSneeD++SWzqET0sFlvgRFU5xgkjSdmgrPZJRgkfrbPpLGKBOm
         bDh0PrVuSNwQXwSYIR6maKerdWFOrlgn15Pp6zP4skuHDQyK661vZgQ6TIutnjbGY1al
         vWUIiiJWXWlHQWpJrUXJEKoMPuETnW3rgZkhtVKFYV1PC5JjWvDxh/SB2yT5hb0Ub2bM
         U1UrMAceAKlWIPQjb7OM/i8VrH1I7nbXvlAUbWtoLDpNU31EZtRYtrz2iyvPjLaJRpuM
         si/w==
X-Gm-Message-State: AFq9FYKNIGdZp7re4aiIWRxTAQPndM+Za1KWEoXiQfVNTWJy/+/Tjuy9
	YB+0yUq5IDwoU1D/I5LWBUV+74X0HJoC9zrTxNWMT24FeoEl5lKj20ZOROEmJQRZlF5vjbJKNnh
	i3AwcM3eHEDBgkvOg5c/1BYer5H7FuWlxap+A7Uf2nPONH4V+1jNOP87rsUyN8NsxTRcO+ZJaxV
	J+ZA==
X-Gm-Gg: AYBFou21bOcmBTRSgB1FUttmKHxSGUT7oIvamfZQkW0s4KNtl/gej5HOwwpCQ+obXPp
	wTh4em4feI/z68f2HUVoJhTG6i0UbKz+oqIYkwieRK+NQxKu76fARYUg2pIui6kbucisYu309HI
	ZZHvFwSQnR2ZyI0sUgcorbnbKi3xxcSz5oKqQc50Qgwv1Y60uElMCl/qp5xyiKnb3ngF1GvahzQ
	UYW0v/YDt9NgRM8HiFVpSYYEp8bX2ixuwc/NkjmNKVhmnr+KvoE9MCc/3v2hwXgJs8GG5wVN0ju
	ZZsiyChoUkI0K7vG06x8hqm2oMqY16HQ4TqPGc4r9qUYZrRPVr1E12g1MBjJTCuDj8xV3nM2g4g
	cBt+iOyT7v2OKg8B+7unCLwnRM160OqflKIJ9eaRCXVhXBO6IV9mX8zQa7rps2oBWXDh5kJVnNr
	nDeQVgofk=
X-Received: by 2002:a05:7022:29b:b0:151:94a6:6f5f with SMTP id a92af1059eb24-1ac5c3699aamr15001761c88.10.1793633857091;
        Mon, 02 Nov 2026 07:37:37 -0800 (PST)
X-Received: by 2002:a05:7022:29b:b0:151:94a6:6f5f with SMTP id a92af1059eb24-1ac5c3699aamr15001712c88.10.1793633856334;
        Mon, 02 Nov 2026 07:37:36 -0800 (PST)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b0a628bsm36987053c88.22.2026.11.02.07.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 07:37:35 -0800 (PST)
Message-ID: <8e38f8dc-88f9-4974-8f98-687795fb360a@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 07:37:34 -0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: pull-request: ath-current-20261102
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=SeZi5fRu c=1 sm=1 tr=0 ts=6ae8ae42 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=qsoVpiIQ6ULyzOpuFuoA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA2MiBTYWx0ZWRfX6m9bA2ozqkO2
 nJqrMAempigFd2f8G+8/D1Ia6GL6t1x9GuxXMxRIKglTWKVPo9qX8V5O6BXpdnMqjVF/+LNfnDp
 PO1XjJyBXST3ahRp6Zk+cXI1+oAT59L9xT1gq6VdbkN8xCb6p8L1/2nEoyQBGwXtSmoFnMvhpHy
 GK7/cs6hnO5BIPjpye9+LFP3LjHV7a5XnDhpWkI6WtnFYetMnm34520arRQEMTW5dHj9C1IZKNg
 h5EO0a3mRyYnLCYeHSdWXRKBqv7WB7Dsr4Re5yKDU2EpU83P/kww8b1PspNrL7NhrwNidj1n8kO
 lrXGd107h/GxOvjTaRJJZm1Ji0yM7nrLM4DkcX/In6b4WxxZpvtejO4xn3Lv31xNez3a5eLDfH+
 zVdjdtOWqpm9k1UpzS5tHzmlgo2tk9tBYW4O6CNxfzKNtiBJJ5iX5XMmKUSOlVPWRe07+Xxg6km
 JniYKrKxB2y6D03kBBQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA2MiBTYWx0ZWRfX+Xa6K2druJub
 tWhZQtv8AANA+kj9bhcy9Gu9AFuilS/gB9NJ+6anI+LoF5VoMHJ/PhYkRf1vPxW/BNQLnqGttk/
 gbXKJ5jcDtJCPs4YD53FSitG3Oogd1Q=
X-Proofpoint-ORIG-GUID: 2UwdH60xfzkGHFZOe_4wn30olQS1Af5j
X-Proofpoint-GUID: 2UwdH60xfzkGHFZOe_4wn30olQS1Af5j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_04,2026-11-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020062

The following changes since commit 25e73f1d6868c759c8eb56cad4e411692c5341b4:

  wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg() (2026-10-26 12:20:45 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20261102

for you to fetch changes up to 83d689bbe8f90ce39961bcc3a64f2ca2ec184019:

  wifi: ath12k: don't advertise EHT-MCS15 to firmware unless we support it (2026-11-02 07:16:28 -0800)

----------------------------------------------------------------
ath.git update for v7.4-rc2

Fix a few user-visible issues in ath9k, ath10k, and ath12k.

----------------------------------------------------------------
Baochen Qiang (1):
      wifi: ath12k: don't advertise EHT-MCS15 to firmware unless we support it

Benoit Masson (1):
      wifi: ath12k: assign device id from the WSI index

Filippo Falezza (1):
      wifi: ath10k: Stop unanswered temperature reads

Kang Yang (1):
      wifi: ath12k: set MSDU payload correctly

Lorenzo Bianconi (1):
      wifi: ath12k: fix decap of MSDUs spanning multiple RX buffers

Mehmet Fide (2):
      wifi: ath9k_htc: do not start ANI before the first channel is set
      wifi: ath9k_htc: start ANI when an AP interface begins to beacon

Miaoqing Pan (1):
      wifi: ath12k: Fix failure to create ath12k_dp_peer on MLO reconnect

P Praneesh (1):
      wifi: ath12k: fix IRQ disable imbalance in AHB ext interrupt handler

 drivers/net/wireless/ath/ath10k/core.c             |  1 +
 drivers/net/wireless/ath/ath10k/thermal.c          |  9 +++++-
 drivers/net/wireless/ath/ath10k/thermal.h          |  2 ++
 drivers/net/wireless/ath/ath12k/ahb.c              | 11 ++++----
 drivers/net/wireless/ath/ath12k/core.c             |  3 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  8 +++---
 drivers/net/wireless/ath/ath12k/mac.c              | 17 ++++++++++--
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    | 30 ++++++++++----------
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    | 32 +++++++++++-----------
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    | 30 ++++++++++----------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  8 +++---
 11 files changed, 88 insertions(+), 63 deletions(-)
