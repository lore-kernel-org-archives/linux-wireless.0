Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC4A4F473D
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017097; cv=none; b=fGznQtqD+1p5RgnKGddtLPWqCTNR6+xs6Eidq/cJwJX4hVwWajYXI8V0PzgIWMcDb1wHfKyXanvmHHZ0qkJEYa80XznMTdYG16K4NMz+ABH5vkoN+0dXkdKrXTyLn/XRPB/84PSXNcmDpO4/VSUWHcUCAC3A11x24gjbtWwzccU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017097; c=relaxed/simple;
	bh=n9CU+q1/33hGZjT1gnD7k9FSN75j/I3GChJAF3U4AB0=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=hUYazippcFEdjK/BRiQOEuT6lrmj7v/EL2hJq63K7vUFD6Vyy4XP9jAaz9sqQJ2pM0ihSse2fZLv7he5bmY95OLwwpxv8EiUiX/5USwsbLL/CkYSXvXzPZTtOxxhRQpxz6POjzll/MVjmoMSxkQfPsBbUbdpv3AFaoBP5bF6akM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cjmgIUGC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BxEI4DA/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cjmgIUGC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BxEI4DA/"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LFAsTU885071
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=uUXkYzIUsHG+2keQKojwyw
	n4Tl5BjL8Kz4nL3lPB3pM=; b=cjmgIUGCxQa56erxyQBavuIbHcWHKDZ+Gy4C55
	a2f/Te4QnMEcd+E9MIEYYLfZvirzvgJFbOeJCXprsFBiVRNsF0hkilpnwuxQrGrd
	JZGk6G/3WNEn8hY2HKYYoFqKa3g0aquIKeYjcSxPhx/CBx+UnaDh2KxBorO8e0jV
	B2X9QVjF6G9w7fsjb8ybyyV8ZI7yDW8UXEEZ1O54ubymAILozlqcbx2ArKnhWqR0
	RwYCOK2pY3pUavF0HlxZaPOx2sZz16PgeX1aSs7TKIPzb/ieQEdd0YK+kfmPiHFc
	QWaFrs5pcy/kIqLGGSr5JfmEGgeSejS2wkf1Ay6ZqG4DVK/g==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu0rj2q9p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:58:14 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-86fa6b15ed3so4764164b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 11:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790017094; x=1790621894; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uUXkYzIUsHG+2keQKojwywn4Tl5BjL8Kz4nL3lPB3pM=;
        b=BxEI4DA/Zaf7w63+rYTFuDtOW94re7LwssOum0otgtQ6AxeDWDoJiQ/FUis89XTTo5
         6RnIWs7W2jVRMXdJCYfLOXx9tHNgpLo/7Q+NfvO7v9UOL9Qg0ax5watRS7x2HB5cFngy
         RtMLfiUx2Gdy1LuAw+x/QMt8+7I7ns98kj3mH3m0QJeMHdHVMmmR7ogFZ0ODeJK2mD5y
         /EYDKz6JuddzHFvCK9uKc0EYOOAfEu7+7GmzhJBZLzGExsf3fEBGDl90SLsRYF2J0kYP
         Uu4Oa7MujaPvUaDtmGb5obj7175g2/705t2TxVul2Wu8TdmCFDs+4t3O+re4aaJa6ur8
         /iPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790017094; x=1790621894;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uUXkYzIUsHG+2keQKojwywn4Tl5BjL8Kz4nL3lPB3pM=;
        b=IQmLoaJ6IL0ZhwYR7rfLh7A/dUrgV/ZP6gsM1pyJD7CfGL1X58ttpNpAAadFATyROo
         sbLb1HX9BARH9o7xXAbP+kLA+xdQElCSwTK+1bfr+jn8/O0oWRYlL0l9n4Z4FmaCgMNJ
         jmTWl66ePex3Rw5z1oCf4NgXCoB2zT+rUARpPZeeq9ODIkAkYRj9NrAhqecOzYHUvDLV
         saLC2WXdTuvDTwwaZmnBGenDNsVeySO+NPwcZXhtjrxddRtarPn19QS7kxrGhXFUxucY
         6ShW8OO5Bm+7sucQW4zrkkbufLyqg3ELtGZl55uLwjwuCvIHbXWKCmzIXee64bjRSz+L
         fZSw==
X-Gm-Message-State: AFuF++li7QAF663fGfMn+LGkrvCgqoY+tz8EziBLpDp1JMTbdlTujOsv
	y8xNJQad7jxjC/6F1eP4HgD+p2uUdqA05pDl1oN+sqlXqZ+25blkQi3kkBREZQBKfmZ7zbUiDk5
	ADkR+Efr0N7OnSBXg74k4An5bH6bBdnyi7U5Pe34XL11Q41e3v+JXnFUrA10OQBnAMDgsga6h63
	SCFQ==
X-Gm-Gg: AYBFou1PZu3I924LFh+RcQhZUkxqy84UCOtyHOnlNGurGNrQnhbUDc/Y79QvzcUMWmN
	Ipy/L41Fyh4GzehUQnpHHqdS4LOqVFUb0J064CBRsDtSOBUHRauwY2ClRHUmUu8SkceDVL4SoHI
	HWtONKvHaGi/eyrsA+vHnyeO9vu+dH8EM2WloR/YWaCYZYw/kVS/itG7HMVNxS7ny3dWua6Xa3L
	+BFGhCZgg1C7tbP/Aol9NmzPh0KRSLbsnNYOMb+5t8fenR59iG5H5aqsAgzUVbqH8nUtV1ECSC4
	uVNQt+r6SueCisjsmyqRzQrfQC1vZK5xsShI0jDbx4KLZHe9SuY08U1AZD50SMDZWfXb8HvFdVP
	3JcLOs2EdBn/6zF2j4/RkpzflDpN3WNpW4oQ=
X-Received: by 2002:a05:6a21:482:b0:3dd:a006:559a with SMTP id adf61e73a8af0-3dda00655bcmr14267309637.40.1790017093661;
        Mon, 21 Sep 2026 11:58:13 -0700 (PDT)
X-Received: by 2002:a05:6a21:482:b0:3dd:a006:559a with SMTP id adf61e73a8af0-3dda00655bcmr14267268637.40.1790017093097;
        Mon, 21 Sep 2026 11:58:13 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d54b248fsm11523188c88.1.2026.09.21.11.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 11:58:12 -0700 (PDT)
Message-ID: <3c89c245-3a4f-46f0-93eb-a138f10a1ef2@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:58:10 -0700
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
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260921
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDI3NiBTYWx0ZWRfXwkbK7P8j5ySr
 Rz38oke7RDmsk7lDWl+AYTZhEVJDthA+CZXBGuWE6ypDlUEWg2HTgNsvD39LwweYqhGwb5rUDFi
 KM7PrHLRE5+3OZw2fM51PzVhLGsDdtc=
X-Authority-Analysis: v=2.4 cv=AsR7T+9P c=1 sm=1 tr=0 ts=6ab17e46 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=E4bmoj0mVIXTqPrLO-AA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: ZHq6k71AgnzHpa58AmukjuMpKl164Jsy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDI3NiBTYWx0ZWRfXwXNfge02Af5r
 GF5Y9riI8znOEiUoxrdr4MM6jD7Gb+mUJQow3WJqVlGjeh41xXIrh0MaliUOJV3NRY7m7xH1hQ7
 ibdAaMMooQmd9fMjRKQrLkNe+Wa+erj1ZeQEIx6+RrHR2RRggR8VLf5c+ZeKHk/MNGN9bPZBZm8
 QjxOolVo753Lw0614dabyzD232fw6RZBFXpuTAeeoiJJiasqm3I1WJelJYIIcEQjbfD5RVDVouH
 Pqo0QVHpuMrXFGAw0NTGX/eR7bHIDOSIz886Q3OtU6X0l1E5Q/N4lJ5z22HnIfsjL7xcy5GMFT+
 UFTU6q4P8KYzrsMAsB1uWlItfLztETPYLDfFgYeh9I3cwPhMW+BdfL+Yx10M/PUV2AdF0wYPxKD
 WNCJmhW5QB/GKl06cA7UHbQS+KTw8Rnz8F/aWhLgUZgTazk8mUoeTsdW5efLk9L1pW0z7Dza5DL
 a8PGlJgwBxPI2vMMSHQ==
X-Proofpoint-ORIG-GUID: ZHq6k71AgnzHpa58AmukjuMpKl164Jsy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 impostorscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210276

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

For ath10k and ath11k there are no changes.

For ath12k there are two board updates:
QCC2072 hw1.0: Add initial support for CQ2390 targeted for IOT platforms
WCN7850 hw2.0: Add support for board-ids 0x201 & 0x202

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit 2b8daaf611fbade74f26a5b58ec1defe6a02f5e0:

  Merge branch 'qcom-fw-version-diff' into 'main' (2026-09-19 17:16:57 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20260921

for you to fetch changes up to e88807ffbf0fce50130cf1f7475acfb8ba365c12:

  ath12k: WCN7850 hw2.0: update board-2.bin (2026-09-21 11:50:36 -0700)

----------------------------------------------------------------
Jeff Johnson (2):
      ath12k: QCC2072 hw1.0: update board-2.bin
      ath12k: WCN7850 hw2.0: update board-2.bin

 ath12k/QCC2072/hw1.0/board-2.bin | Bin 401232 -> 526720 bytes
 ath12k/WCN7850/hw2.0/board-2.bin | Bin 2253964 -> 2431852 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)
