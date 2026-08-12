Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706CC25B091
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500245; cv=none; b=Dr4OPhu+ivEC/E8pUJMj/a2WeTgdIPG4745S1tqP/1RTEhYLy9w/4rIYLbtgV/66tD+WbVJ4ewdwReaUDG6FEv8uRLrX0isstQq/GX//4uHKtt0Toeu6R86kc0xzTbWrMoYpbekWKTgMExBhOWu+utpP1fxYyrW43fS7VVgmWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500245; c=relaxed/simple;
	bh=5KUAbzPHtQsKQUiyxm8qEbHGXWF4cJ08FjJRPf+6xC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eD87il32J8gw1ST0SugdyQU/eFQjKcQYupJwbcYKi9TltrmCniBNSIKQKTl4txRJQ5MlDigd92r9DLElpO+2+W/w96u2kFCSpNU3l0qpZweODAczzUT8/0FmbWzYdLktQrscTE68RyZhRkvpQmBQWKOQk2wHoQt2in8zcDPQyI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QWLjisjy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SmEfw/2e; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QWLjisjy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SmEfw/2e"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67BNGrjD1305721
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 02:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0+p2VqFnG+b4Yjdtv9vxJ3+xVa26z7klBBHVeltHih4=; b=QWLjisjyPMYvjo1f
	ZwOddq1kzkbhj4HR5Wsblc3FPk+kSY7gY/temW+jBeEX5eSdx6/uonB8fWR41yuX
	mLPR5b3SiSYc3Ao45vgisf9iVz6zTvLjlDb+wasrWnuJcd6qXFoSjVr8ptPy1k/a
	spufAuaigoKRkKZNL15uEglZL9QT80KE2fNxK59uj51mLSDfbighiHdkHsHRL4iJ
	4kzWWkqZm5PDSmF7p53N9ip7zkE6k1iG0dPPBdG6i5yVwDT0hIxh5qIxMDVw2DgS
	Lxe/BNdO4gxCypiGvMSTkUGbDAlMZ1rZTRie1GkMk0oJ2o1AmGF0+TSgOHyN1qhb
	F7JoOw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g049g2yqf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 02:04:03 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfa4e4684bso15478975ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 19:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786500243; x=1787105043; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+p2VqFnG+b4Yjdtv9vxJ3+xVa26z7klBBHVeltHih4=;
        b=SmEfw/2e4uGsA/HRu/CiVS7sJyBsOwEOoRnler4VNXWr8553Vvx5pb1Jzkh9oTKM3O
         fwL+45d2Q9VtlbVnKrTnkPfV197g14jXY2kxG38rXdiD2/NdL4nnqIAwZ1iF4kbpGLXs
         y0Ru9zON6uqGKPbzT28JV1U1zOr2veMOhXb9Ss0H6BzdL87hGDbREwDD1JHlT4DVS25a
         ig5IdWY9QL8R4gVti99feEaR9BcPCecs65IwMyEpTjUMR3bJviGPQHazi0Eb+8czeV7e
         vrb2mLkOid9CWF5HwFBA7dcK7zpEQ0oFXzaj3zASzn2LGcdSqjvJACoBkUvkHIFkWoYF
         Cvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786500243; x=1787105043;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+p2VqFnG+b4Yjdtv9vxJ3+xVa26z7klBBHVeltHih4=;
        b=GC3qckQMdPnQHSDbJONI466L20V/X8dqzea0gen7DaYNppDOoHnTMdHR8ow+SN3n88
         QPq8YGihl3HLgF3Vx5iOy19UArR1CMztTp8xOVzzge1cDDnOCXq1OT8q1090OYO2x3DL
         wzCkEbHXbAAGDtvHtpVcmuMBc93PvfRIhf5hXIkay2n/LhsPMlP7T5C5lXXvvMSCGLmN
         akno2K6wvIrIF4oH+ZmQ7MViTjpO3hFQy4vUsvigt2vlR7E7gAIy9wdGdC0L7ZGI31n1
         ePk1pUZo2CXE1avSPE07k8SMNp263gb17S2FKjpUiC0ma4eK57GJ7nuF3yNjfSzTkrIz
         rCzg==
X-Gm-Message-State: AOJu0YzpEfe4EW5d2h6BE1C5RjOTlBN7me/UonZ2C1o2VZaN39ZFdjxI
	mKyRjvq8DQz0z7cYnZxhMY3xn8TTdkrt5nwkVkKWsjWOpdvuRLTkHDxZqorTu+DJR0FwBmc3KNT
	yAVi14kwwGQeMs0VGbRZAUI8OkbV9WLmfdIBHa+T+uwRku9Y8Yez10yIU8UIvilvGt3ddassGGo
	ghHw==
X-Gm-Gg: AR+sD11j/dCX5dER5Z/1rYTvCd3UhwP37LKiCcyfYXB/guzQSRtZMdq8PI3zk+8whMm
	DNIwKDaj6rhTpwuCNKSzKbHk3FnfZnFnuXHy3J/vVR56QMDjTXck/jZmfbuW8ktOs8imsT2owJb
	OUVBHwVWiA/8obOR8jVHCw7o5BLAXLfneA6aL+sL3ivx7dGtDsjrb0vjYag6fhmyOLp6hHA0eDU
	aR+8O66dv2IkQ8u7PP90mIjn07kFfklQmEvlXuQkAIUejnRkIaEYtmzkI6GnXXxqEOOSqLdRgkD
	dYp/FDvk//MGZTP42zb6nz74bswTeUgzlYygP19Ekudfh1bTZe224JjoGPCLE3EIPqvbw1wxJF5
	vmThNNqapIhGZp9DktTQvv9Zx8W/qnwU22s5eBfT74uokuvXS1gVrb4IpTkveWVidqUjslZuC
X-Received: by 2002:a17:903:3c28:b0:2c8:1c05:16aa with SMTP id d9443c01a7336-2d34560cb74mr22408465ad.19.1786500242768;
        Tue, 11 Aug 2026 19:04:02 -0700 (PDT)
X-Received: by 2002:a17:903:3c28:b0:2c8:1c05:16aa with SMTP id d9443c01a7336-2d34560cb74mr22407915ad.19.1786500242305;
        Tue, 11 Aug 2026 19:04:02 -0700 (PDT)
Received: from [10.133.33.43] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d35219d8e9sm366245ad.40.2026.08.11.19.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 19:04:01 -0700 (PDT)
Message-ID: <56f52bf5-e6ef-47de-974d-fabd24fb2329@oss.qualcomm.com>
Date: Wed, 12 Aug 2026 10:03:58 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: add support to load shared
 firmware on multiPD
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: q3V4NP5jdncqNPuCpOkSTWkB_aDZBK0c
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDAxMyBTYWx0ZWRfX0GnyQ5ugTGgE
 OSz1RoF/8inW6fJMSOhZ3Yt7ZbMV3cl99zyR8Uc8eizkiovtzwtxaBPk7Qbw0qDM52TY+baIA+A
 fLT+ceatFyzuVRhZafJmk9lu9aTpEYE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDAxMyBTYWx0ZWRfX3/JeEiLEVnbW
 7FrN0uABrTnS8eTd2q98wAU7bdrqO/+qFVtkKHpLyGhbj6tNCuC32tg7IvlKhae4Ga5fZpnfXt6
 E1YjyCIHE+tNTKwXd0nhR/wXoE7zE6D+UXu60eeFJht9/8Vkjo8vGehooawWTVlgTyi1DGIecGW
 nqkUxkayiTofXI96Yoz/6Zwp79LBStx6x8jrvUUnRx1t9a3gs3SKwqo0+EQQ7YR5VTN0v5mqHKR
 SE/W8MqZMaFLX7HBxk9Fm67JO/uS2Bwd1n5ePz/b9rnVp7aot7orITu0KTjsBR9Kq95miFUYGsN
 ANDCIeT/PmHkCIp7BkxAN7+u+HYlR8BTFR9SKillMFnD8SVmAguY1fNr47cJiHlaTvcHBCYfvZz
 GTowS342HilqD5orlbdvz5ePDB8OxTR96hdC0kTvvmmP1lOOkiRimfXl1aO7dZTs1C7t909VCqr
 gFcrbJ1XNgd6ecAaTkg==
X-Proofpoint-ORIG-GUID: q3V4NP5jdncqNPuCpOkSTWkB_aDZBK0c
X-Authority-Analysis: v=2.4 cv=LIRWhpW9 c=1 sm=1 tr=0 ts=6a7bd493 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=_noMR-R8M9vqBXE3qqEA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-11_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120013



On 8/11/2026 1:43 PM, Aaradhana Sahu wrote:
> IPQ5332 platform uses a MultiPD architecture where multiple firmware
> instances share common read-only code segments. The driver currently
> loads only the per-UserPD firmware, which leaves the shared read-only
> firmware unloaded.
> 
> Add support for loading the shared read-only firmware once before the
> UserPDs are powered up. The shared segment contains common code that is
> identical across all UserPDs and reduces the total firmware memory
> requirement.
> 
> Store the reserved memory mapping in struct ath12k_ahb_rproc_info so it can
> be shared by all UserPDs and mapped only once. Keep the mapping valid
> across UserPD power cycles, and unmap it when the last UserPD is removed.
> 
> Shut down the shared firmware from the rproc deconfiguration path when the
> last UserPD is removed.
> 
> Also, pass NULL for the reloc_base parameter because the driver uses fixed
> memory regions configured through device tree and does not need the
> adjusted physical address after relocation.
> 
> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
