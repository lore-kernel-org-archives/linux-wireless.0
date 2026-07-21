Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AAA470435
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664146; cv=none; b=SC+Tto5ZBNUGHz+uv1zIJ9SXc+ZZVfNJYQQ5pgWZdH9hU0rsUJI1aJD6z/U+0sGE/6CWgg77IP2V/PkmkK0k3yqm17U9GopFp80nLg7kFvvz8byhhI5rKd8P2uoFJJckBbl2eCDJuMXGduwanNyViclrVFkdwnWDv3VycHCT3YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664146; c=relaxed/simple;
	bh=/WzOcuMETY/jg9ppCficWsEQtae0/tR22s9n8oyn3+A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ND/fs7rpOVmV9UaPY49ZKJLb+eSavr95AZ8sHa0kHV0Z9DIdDQFTnTkxUNpgTuZGLxSaxh3GDUGJuoEigxjnkQLbavbOJUCjWqaBGTYNlSt2Eb0czikhh+umfrQBAmgs3hPDd1pAIGJ8gAEOrM2UgffJL8cA3casEnFY6lJb37w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Etr5ynvR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KPjkjFGu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Etr5ynvR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KPjkjFGu"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LHROrm2494482
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dWygTX5Qf438gPLKLUw/9chHA39pXSe+DrGkrf6GAzI=; b=Etr5ynvRg4fBJdeI
	owT68X7JlqpvzM1kfNLkdMykWrWefTF/BTj7MNxvJUX8vB/sJuIxz5StutMJKMLp
	5IecILEE+BJyJszNsAbKPigQJQM9IDs2yPEQB/GZmT+lQzxfw7ZJNJxeKy5pPGzG
	h3pTTDWIy+rVVpPQ9rAY95Zzo2kkglKxOmw0bW0fgxGO77NarnOijYIB1eRoroTp
	jApcz8zhk1umI7zcyX5I73p7lgxfG63LDI1swmtQ/yMX8tQXZ+SJBaJIdrPZCkBu
	t/jB/kAXg5vVhjclFH4ES5OX8ZAsJWTW+ARmKwR5EAoHKspOKJOv+/CZJHWTFdsy
	wEhWbw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjd6d8ps6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:23 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc73f47bdcso215832395ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 13:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784664143; x=1785268943; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dWygTX5Qf438gPLKLUw/9chHA39pXSe+DrGkrf6GAzI=;
        b=KPjkjFGuHlLN/oMY39PX7awtVlRQzWHqUjBdkEoqy4vA0cekmnAo9EEsJQ0LnacMAJ
         3B5Coly6X5lGDfdMNGMw6SdulVAlD9AI+FVUjfAJ7WXZ0gvCindUBE5oQy6eJf83E2ck
         sLhQ/r9W25NEE2E3qFCoGinwDa9vTsMcstrauiqyK4hLI+jVRVqUw66+W7I7DENAgzZ/
         NQnfkH+fCnXmPXwBlIKl81Jm9Qi5WKoNdwyonb6NYRENONYP3M1ATDlc4uZJY6WbceuT
         pvnOJ0AQihA/KxOpd6w/6zZpz4H6rcBeIp3uS7PNPsc19R+B47EKpLRqEWsfcxU1MvKN
         S69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784664143; x=1785268943;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dWygTX5Qf438gPLKLUw/9chHA39pXSe+DrGkrf6GAzI=;
        b=KZKLEZdnRM2UULYPnCkCY7LwJg7NNC/TnkPxuXMfBI1z7UiYyIuzgoAWePTR0B6lwY
         2eTurR6/yU0pE3CUx5LyI2211MXUYF0rxCtM5fzkLt8Kg7+E+svPh2id/4Ezj1rMLs3F
         YJPNAEOAfWG9DU4tmsYo/YldbEz7wrxBWZmQ59+W7SnR61qNr5eaFpy2wMJLf9qdLnLz
         Vetyhqe7yyUCHB4k8ANL9mnAJBYTuGlDCUhuWxvxr3PZLtVJhSX/dIc4sm0Bk2BLUhgp
         0KqWhrJZjZTHGPoxNfwfdtXxk420d1GzUXzFs+co2LTjQQQXe+DRtxyd063ePGU5z+rJ
         a5hg==
X-Gm-Message-State: AOJu0YzOEfdOHKk3ms2S/sZU8dP+/+6Y+DOFThfGpjexAl/+kwokSCF2
	L+0WRaN3vIrT0LudNnMLs6ox34nuTbefRcjewEH8/uv+kF6/Oj6R4j3Pdl8tOB3lrH1//rVEJ9W
	lWMU3ctolbxClLlPpb02ia/KhQ7j6UtN93wnOQNctcmuqOXAn2wQ9gCGMf2jVb2FrhCoLPA==
X-Gm-Gg: AR+sD13rqb28i6otAnNywlaHvijyILRy8UfIZ82/NchsO/Tfk/YWN9HrqXI0j/f6GMJ
	zzLPYL6wS6Rtb91gjDPKBh9hu6AU2u+aRyG+QW09DrRCMpYbwQqVtJg8EFV8BSW3EJy64LTUPv7
	dg3fOButBHd5SE/TpqdGlW1dLs1xzffY5qeaWQ4kGdeTRkFx9u3A02vME41gdRPzZVSDWavBPdO
	xJwaE93wc5Iu4pLP70t6JNhcJm+bv61OiFsaFLPwJY9PX2N76oNC+7TBGRJRLlvC+glEol/SYju
	UmDsF6ZBJtI7egXxMEnW7NMT+ynxoBRH1zgY389UA4xTkodf5I74DwWpMYoowRsE6snKsMEKI3w
	oxrY48Uehhabr/FYwUgGs2OvBwz4GTOBo+7J5tRRayHdnXB+NeFLfzOs=
X-Received: by 2002:a05:6a20:4c8:b0:3c4:1c9f:d90 with SMTP id adf61e73a8af0-3c41c9f2e30mr3065829637.39.1784664143057;
        Tue, 21 Jul 2026 13:02:23 -0700 (PDT)
X-Received: by 2002:a05:6a20:4c8:b0:3c4:1c9f:d90 with SMTP id adf61e73a8af0-3c41c9f2e30mr3065797637.39.1784664142461;
        Tue, 21 Jul 2026 13:02:22 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc1b99esm1574958eec.3.2026.07.21.13.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:02:21 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
References: <20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: Avoid buffer overread in
 ath12k_wmi_op_rx()
Message-Id: <178466414122.1747165.8361004690432718410.b4-ty@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 13:02:21 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfXxHnbD75SIYh0
 9H2HHkL2S/Ce0sbrFlIES6nlJPYe6adeKT+MDxDETwgHGeOl1kL3ty57rwfgHstFEf5f3VP/Cas
 SClCwNwxnjZI08iP343y4tAU+r+as50=
X-Authority-Analysis: v=2.4 cv=Ipsutr/g c=1 sm=1 tr=0 ts=6a5fd04f cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=ymRfW-ZP9UeHRcWsrQ4A:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfX/yDWGbv9513N
 kLSkz+XB0E1L0kULJR0Yg7CJ6qCYBusJh2jG8cuNJVngIiKg01xGV0sDwRdS9GUUzLkmmAIwlRW
 8UXShl+W4iu1kIl3RCopH+nmbOpjdm0gndnHi5X/w1+Ox/QIEdxq7s72uNh5U2ovp5949wxEgm2
 Hio0LiQ560SOf/o6vPNAgSoP5ij/yiRjBOqBdSYcWDz6PVQJdIDJiBanaMrSLqRkQa6a8yTYHYp
 +wTA6N+lPU2/I9PxOqWwqH8yf5Os/K19TsUaHQiPEHxkuJjn9JJzMGTFpPHoyP0ttWbamiqIRVM
 TeWbkK7snyPARbzJDmrFg7vN/olXsmLNliANNWCQ9mVoGss6FAIO/twImAQgt0stQsSp0881uEI
 e8Usg88m6BXVGAmw+35eQxpS0nI3fw1zFf4tpVdPmsIN15cL6jQntUMcCLM/DtqvYz/E76ztCkc
 1QYa2g7TtjuCE84t29Q==
X-Proofpoint-GUID: 7nTrwa4XwhduT7Al8oyU7T6CU43a5SXd
X-Proofpoint-ORIG-GUID: 7nTrwa4XwhduT7Al8oyU7T6CU43a5SXd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210208


On Thu, 16 Jul 2026 13:01:11 -0700, Jeff Johnson wrote:
> Currently, in ath12k_wmi_op_rx(), the firmware buffer is read without
> first verifying that the buffer has enough data to hold a header. This
> could result in a buffer overread.
> 
> Update the logic to verify the buffer contains at least enough data to
> hold a wmi_cmd_hdr before reading from the buffer.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()
      commit: 485884f0fac28c8281fa66bc2c359d06e6747543

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

