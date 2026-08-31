Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370BD33D512
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788202181; cv=none; b=NeCYZRl7ZbO+2L0OFjNDd4SR5jv6CsLqsbeKi5uOeVmhQ8POHrhAOw2DDNriyvKRsEkS+9mMZFkXoN5Q7ovxYsL5quLrqp52s6VkYGB/dAZdhb2+oyHDWC+3vRFYjIBbgytQDZHAwW63D23wR8agIh4nJMgSA/XVZ9JFlsEjb6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788202181; c=relaxed/simple;
	bh=sjR2R6kvzMyP4eTlK+T/vVMonO2vB3x2Gk7Y0x9lLxg=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=MLHygHPSdHhpEdihfyhaQ+n28BYE2VguM4+/VicjRHX3mYerphaNLBYn7qeYaQLpcI3wFZZ/JfI0t66/5m2Zy35nZqt6I6YvGDgKt14iMZVXffVfQzDX7tLnLsIoU4BkztUZ1Y7k98O4h45RjUQatvCTAyoapJl9NGhuzO+5PmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YoaCRXvP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JQf6dD9B; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YoaCRXvP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JQf6dD9B"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VIYEvF415125
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 18:49:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=HZHW3hkiKEKh+3lY2MSqr0
	2obqLy+h9PcFgQfJDAbMA=; b=YoaCRXvPl7KaDCHPA/qHOt0UcWyYenPzyXi8Wc
	3y8z5ARu+VNYlcdCpPy8xMrMYnaN6gDHEjv0WmHOLNn3SVPKb1cCR+yxf2Tjukeb
	PiW8D0hAAt6N4rGCenhd4KPwNv0YpG3jB1o5BLLse8Qjh5z8QdUWvyQufvGhUpga
	o67WBhKyTeMAtr08pMHLrpapkNGyf+aqyHEMjlhzw+CsVrtPJdKvKn9o0LRsBZMJ
	BJcYap+dSdswlDeyJ4SaaVyxpDRnPK5CmuQgbyjNf5fFWJi1OzVhuzTjc4WlrR5w
	uDruHSUnefLr/vp+SLCBa4eenRgTAMetInoVof5ARSskZSOw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gd6jgjnx4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 18:49:38 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so119077a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 11:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788202178; x=1788806978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HZHW3hkiKEKh+3lY2MSqr02obqLy+h9PcFgQfJDAbMA=;
        b=JQf6dD9BYDfqAOhaanOt8jySje6XdUtIFxLm7epLZfyDTojmu04yeeKR+cwuEE9Nqm
         E3fZusJyTE7xfsw/nfh1cFOxZdsilwHAV2jpC1gmWPHiJgqSaH6fxRkbklcqwBtgVMKf
         rn68VgCJ+lwaU38SNKoi4qP+G1g6QCaONY9OmkyVBrxjRKZRqfHkfjN1X+qMs2z/BLYx
         BkAdD3Rid4EvWM/nB4VVntNV4vl0Eq5Zr+s1cvv5lSf5t0J6xlEq0BJQyArPNfTfyJCt
         qZHkmibL6M5iHncGluyp+33BXfSvXbU+bgrSNH5s6KmIgcR0Q0WZ1r86JekYOaTBMRVl
         uPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788202178; x=1788806978;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HZHW3hkiKEKh+3lY2MSqr02obqLy+h9PcFgQfJDAbMA=;
        b=pzZCNaFqlr5q7EJvqYb8Ww9qIZSHCToesKpfyoGpRz3MKBfrhs6HyOzKbys12o61WW
         8edFhRWDaooBSqLU/LxG+EfLRYlmxoxbUO/lsSese/9lEAkB/afg3V5wIkHh+pqwiF5w
         B1Iqymh6O8jgqetVV27zXWyuuThtvarFxCOvj5ppao85NuJ1BJRIqQ8VtzVZxUsxZp69
         owOhIEpHWEXphNDTqNnOIeH1DpFf+sUv1SzBDX/yespXqvWdJcsbf18mv85WNT7OVKUv
         nN5mIqf5/gsCllQaWmBS8Lyj8nmSeff+TEITWQIHEwIGbKUQ94Zj3c2X+oOt3U4N3qCO
         Xajw==
X-Gm-Message-State: AFuF++mdbUsgH/hdUtfZAUGWwrR5Ff3QMWjjAHxVhbGa2juLbA/5MCqo
	dcfmd5LfNolvJ86VgvtWrQdxOHp2VH9gjl+pOPIbbBRK1CSHJ7cakmCF7nRGpc2a3ERWM+PPk3t
	w9BKu2OEhS2+Gu2llC5A41LyKpmpGQG7+R5uQVgUtGdgjj8SSNEqoPjC/Ed9ZacfJ6t8zbA==
X-Gm-Gg: AYBFou33RfO/9juRiexLVn1LKqiNaIw2xwbcrhsmwBVhCBaRGT7J2fteCPEqVn6eAE6
	RhlIUv6k4beIxw1y5XO9UAXRxwJd8Gkyk16QIg2qR1neUyhG0T3ATLhYRY/ztmPan2V+OHn8FH/
	HzpjaFvPrm9s65xQefiDs/204nzidm98PPn8RETx5w47ylLYQL/4y3AvyXFRwxDRVPI1AzWOjYj
	21nfoN3PVtaGU6U5l6D6CCdkgGReZGbh+wgvQMm9clO9QynV+yP5VOn2I05rtufvQPdfd56Kz3M
	dPKFE7dD8tFdY0n8JWZAlS2F/SQnzrUw5t/f1KuJxWwFldlvsJcMElzR5/dYoCt3h7793Psfy44
	a2he2iSDIwHD9vxDuTpdKuPKDvIFl+T38ZbtC
X-Received: by 2002:a17:90b:2d82:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-396d0f2f709mr43742490a91.11.1788202177908;
        Mon, 31 Aug 2026 11:49:37 -0700 (PDT)
X-Received: by 2002:a17:90b:2d82:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-396d0f2f709mr43742416a91.11.1788202177338;
        Mon, 31 Aug 2026 11:49:37 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0bf8a13sm44942268c88.0.2026.08.31.11.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 11:49:36 -0700 (PDT)
Message-ID: <a1b69517-a18c-49ba-8ef3-9b5de089eba5@oss.qualcomm.com>
Date: Mon, 31 Aug 2026 11:49:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260831
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: -y0APuVn1FEZGIzGfnkTl3EBL-wrV92x
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDE2MiBTYWx0ZWRfX5Z3KQ/PjkJ+c
 krT1rv4ZaPms+pSx6ZWzSogrW0wdjC77ZQYfduUg6VxNrvuN3ro4/UGpH7rGbCrkjkoVwXbqH8c
 TDKya6eezGUGjMaVZdAW/RD3LMG4p7o=
X-Proofpoint-ORIG-GUID: -y0APuVn1FEZGIzGfnkTl3EBL-wrV92x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDE2MiBTYWx0ZWRfX3go8qS1YFuoi
 6tt4zQDnelCoTSJ4HMrqL4NQQg/mjW/fw8vOLO45ziJHyZxGCEIIR8RxJuShGcokAlTw8MgKqCl
 qK/L0rdm7c7AmBQNF1+Zx4NIlHmbY1AuTUU+ppGypAJ6BKnOli4ehRa5O1AHaYXuOyy3pBuVXtU
 z+WXdVbDiSMZXNFKeDlwZ22D5RmlL2HsyvKlrm3iKXUefamSoHZroxZrLadDgbkcEIcJBfcKbZa
 SQ5epUapjRuOde83oVwPDA+xJpJkYQjqtxolvZuOecLA2VQvfILnpzi2peGiltRDA/BhIv7BJgr
 temUD+7RhfYvMTrjJaZh77J3oI3UlLKfHTVd5CgzbiUFIZLXvb57K26J4nrEBZqM+tkIJYXVBUu
 HOrGZh76hf0rDRN2kwTOUvKAI6/FA3u/1tzB9h1+zO60R6MCnFfub2OJi1e+ftH4h5ZX5GDh2Sx
 iGgdVLpt6zPvrAB896A==
X-Authority-Analysis: v=2.4 cv=YsY/gYYX c=1 sm=1 tr=0 ts=6a95ccc2 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=-bKND4alXjPcxD5Ql1gA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_06,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310162

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath10k or ath11k.

For ath12k, update the QCC2072 hw1.0 firmware to WLAN.COL.1.0.c2-00228.
This version enables Multi-link Operation (MLO).

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit e981caea6ed33c48d25b7dbf473327dbd01df163:

  Merge branch 'inf43455' into 'main' (2026-08-31 12:35:31 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20260831

for you to fetch changes up to 59005d7898134a2898c5a17f37a9f629a3bc6807:

  ath12k: QCC2072 hw1.0: update to WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1 (2026-08-31 11:44:42 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath12k: QCC2072 hw1.0: update to WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1

 WHENCE                              |   2 +-
 ath12k/QCC2072/hw1.0/firmware-2.bin | Bin 7148724 -> 7148724 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)
