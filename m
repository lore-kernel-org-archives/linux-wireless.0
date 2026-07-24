Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC337C908
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 06:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784875243; cv=none; b=kLwroJq+yAPRaxl1OeYnAG4oGX6ddyVyvJU6xBNsgqhvVuSti2fW3Lh5jugQ6L7m1O1zchnSVf+vSrPzb7KiLsmJWmvSoutC6gJxchs3NpOdMsY+Tx1ipMI+IVPYU/fKded1Nix7iMEkXMD+7GFASnHghp/Yjgzu6KfHLaU9Wlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784875243; c=relaxed/simple;
	bh=zfxrPuScVaJYDoCnaKfZ8rallR6dtcVYHncf5jxw8qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pfB8LOc16aowEVyA4wQivBSe0UcCWHwL/1NngukE7HkQ+X5T6g4hIMyNmmvNqWhzlTc56j3HbCM49HCYqlppJM1lXbyNjFLcGqSHpYPgniwSUFYZ4XARhUrU7ikMEvJxJ/SG842XMs9yUdTQgx5V2cXbjediqPe8xHP48XLYnJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HARW3d9D; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hiDojg4q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HARW3d9D";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hiDojg4q"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4lUse1510144
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 06:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/4lo6fyaz1U6++WuUAn8IYQA5d5uVJklp9nQ+t8eM4M=; b=HARW3d9DPm1jfzdc
	U9u6KsVpWbwJ0fpt3Z/uqiInWi7hrUE+CnvmLvz6D2Yty6CUhXwtIzM913G7fvfT
	I00rvc6ezVXTLRWQREv5X546GGPF2NSpEzq5e9M9on2/YAyHDgSCTqpzduch8Gsd
	Gi9dRI9Extm2iMV2wsqkCuXoV5gp7dL1BerOXWJZanTLHw9+GEPUdhVvmIydfM1J
	QZUvT6Cjxx+GoqTEPw3QM6p0Tc5Ybg4MOzqYregzFuF6EPk+o/ORVT7RLvQHK3yT
	msIMw/d6gT3Kiab/3JrvhWHqEv3yQyfojGc5MrvsWXL8GPbFq720XDdZ100z8wyC
	QQeKYA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkusrsbqw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 06:40:41 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb835525b13so126141a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 23:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784875241; x=1785480041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/4lo6fyaz1U6++WuUAn8IYQA5d5uVJklp9nQ+t8eM4M=;
        b=hiDojg4qSlkJPwUF2jZBV24nlrMOFDtVSeY3UNNPvariPX119p6G3ge1TGiMsMJNUu
         M9chuKPNlZrVMoZISQJol4NN/OJCRZyU5SmGahP1YuMoyEcEn5REpi/hxh3NeZkjNCka
         ozehOV2MCLR1opDvttgRIK7T8zqQ/K43sshs/m8T5Of464jt8+dUr9qM2WPf6d95cOlc
         YKArll6wplQbueBM+P6uDHDfaOtOlmg3xeuAs7AF7SaM57s6T6Rkwhm0qf+BNJKWUAOB
         Skgd1kn8lPXadPR8D0PUfPMMAcZGss9imzMAipqaley/D7WlokOrVajGPiWCL5gMw5hD
         WD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784875241; x=1785480041;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/4lo6fyaz1U6++WuUAn8IYQA5d5uVJklp9nQ+t8eM4M=;
        b=PuCRhWMoTwG22f1MgMWyqFY7EVMslB1prbDoDnxQlvhrd3WCw2yHK5/4qQCy3mR0Qc
         0ZVGEx4aplL1FwrK8uVEbHYgNsgNQMqSWjNeeV6Yo+qSmWTqVIjLc1xTfQFhWksmszNy
         KwjFp+QHYMiQXDGZEfe1oQtE7Ac2BTJgtYUu/OlBZBOEBwKVUaRW0oykMRZXeeo1gW6S
         axExfI6OzOTqhezirdtPw9d5h5I8caiIfJgrtqn16s2tKnK5uKPAdzh7kA19us0j1MY9
         GT7roO4QCxOAUCsEEOO1lMf7v8cBj04uM7dz0d3URY1dCYnNFRRsvGA0AGlKAxLJ593d
         EEVQ==
X-Gm-Message-State: AOJu0YywnQRz/XRag3aJGUW1roP/TPMXLPRMMcCPUywHXu/PNkqEZrro
	jT00qsvd2jfh2JtnJfrh+kWbRmFn8q7LFHpqMhw9cPUKHKueglnnpuhMp433MEP+Kgo/zr7sKXV
	aNKM/7s9KZ/DoTCOnCdtPtpZ9KnsIP+s7q1S5i1aNHvOfRx7YXjAoO2YW0vbL7aYUeyfc0pNuYn
	C0XQ==
X-Gm-Gg: AR+sD13YY6muDl2xMV50A7TjmBFY/eO+aAejol/9VRCnYSYX5gtworBtAUv9uWRCBUN
	saAk6L+3kCVogw2e1KQLaBG2RkqK6ZhWswOsxUafJGuhmgKUd2M40m63d4ydsO74xaCE9tNPHMH
	ox/ECoUk9TYUnScn2lABF2uW8V2gUca595K7Iy0VEmpYhZTT1+uwE2ZN0q2RVpH6fUL7YM4nBhK
	g6tiaQbWgqKyNT/pCEGY9Jw/dppw3g9iP3tTjnLvSWnFrnWaSQ4bS9vvpwtUssb2BIbsGi2yoKq
	Uq2p2BWLiup7Cb15lgin/AqPB40hETOG1XmI9Sxg88gT3tBN6uQ9kNAdK3hwldvJKwY3+jf8obu
	aWwanwyCNF9ZW43tYmmVG6FH9rSvfv/AkOxallsu7
X-Received: by 2002:a05:6a21:710f:b0:3c3:9070:96b3 with SMTP id adf61e73a8af0-3c44afb2743mr7222450637.3.1784875240949;
        Thu, 23 Jul 2026 23:40:40 -0700 (PDT)
X-Received: by 2002:a05:6a21:710f:b0:3c3:9070:96b3 with SMTP id adf61e73a8af0-3c44afb2743mr7222428637.3.1784875240556;
        Thu, 23 Jul 2026 23:40:40 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df06864sm27015380eec.15.2026.07.23.23.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 23:40:40 -0700 (PDT)
Message-ID: <9261324d-7139-42b7-95d5-f9623773eeb6@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 12:10:35 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath: Fix buffer overreads in CSA
 switch count event processing
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org
References: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA1OCBTYWx0ZWRfX2yUV2v7qsSMj
 bJ3PtRs1mx8PU4sbGHhdf/YZy9gW7vSpE+FIMXDUNU9dHndAihbdcSFEGRWHWR2jT0GrjNgaz/h
 9lyrB7EpC3r9QXF4/5ocJOQPxOpeL18=
X-Proofpoint-ORIG-GUID: Ql1DDBi8M-btkIqddAdk8m-jFARAf_lU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA1OCBTYWx0ZWRfXzuD6nkxJpp0g
 gl5n34mN3jG7szHOh6Rvr8X7c6OGsTISyqzxgR9riYVSeX2qi3PhMDcdCG4wOdmTvhB9Suylil6
 jeeG4DOPF7btikeiuPOrjB2A1VWAFWKbsucVFL1jyVeNItp3orgmsjVc2Wz33bz8y5n3vnpX8pf
 G/zTKTh7MH93+UuDKjJKAqmj/YPZWiceHc1hn/XsGRc7+SOWyK9pFzg1d5H6FmdH0T0dxh5OnCk
 p5jBKtKCxEIPod86aCBp0vx1zDgumqWJS5I34MiXm56oIB0UasArLszgAcsxJNcbKrQE0HIYzTS
 D6MwrVX63kp/7i6sflzsZZT7/krmX0ZK+9tboSVdHNI2rcLDraYuuMHMk1BYxC6QC0bjwT3UahC
 Wi4bbIvdCDNt286J7+w9YWSK7Aof0P5UEuJEy9m+VqPr7sfzoaSLY7B2fyxiKdn4O7b+w6dYExc
 SW0809CqxZ4hu7D56Pg==
X-Authority-Analysis: v=2.4 cv=PtejqQM3 c=1 sm=1 tr=0 ts=6a6308e9 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=EEee_W5yMqs7HOlhk4gA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: Ql1DDBi8M-btkIqddAdk8m-jFARAf_lU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240058

On 7/24/2026 7:01 AM, Jeff Johnson wrote:
> Both ath11k and ath12k fail to properly sanitize the CSA switch count
> event.
> 
> ---
> Jeff Johnson (2):
>        wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
>        wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
> 
>   drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
>   drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
>   2 files changed, 35 insertions(+), 2 deletions(-)
> ---
> base-commit: 0ceb105245b5e57f803bdc0e79dc077fc06ff384
> change-id: 20260716-ath12k_wmi_process_csa_switch_count_event-cleanup-7fb191b7d7d3
> 
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
