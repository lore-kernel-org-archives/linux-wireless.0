Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AD3B38BD
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 11:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781002853; cv=none; b=TV/QfvK/MTlNAwRxqV+LsI8Pht+JzJ/7LAtLQ3K/bn1nEgauSkPM1tgGT2yNyBjvTKsugPdo6iUMw+5m/AEWWINT8iaeiV5bKsx+BYqb+SInSTRp2H6tE369xYfMIXaD0+Gv+34DmeKbdUuE/nxByT3Qxj6SZmXt8TZI+Jpxm6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781002853; c=relaxed/simple;
	bh=y1rowJMxQaGWb4JIfksAagTPim0cmlPxRHjXj8mdpeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isZlHM2L6v7MEqMrfHaUNfC9AQojUC+xfkfYylSpU4UB1dJ5k5zCslHx/65QI3WKn6qRWHkfm85lf1LBumdabdYSnxKRSgQPKIg99ohuidway9WjGrMeE05t71tKV/FN1+EYYKJFK85LVwDRR9w0U3AtZBG61TUcZqiFzvZ0B/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ROLS+Rf0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NWyOzsBO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ROLS+Rf0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NWyOzsBO"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6599xO5K2287584
	for <linux-wireless@vger.kernel.org>; Tue, 9 Jun 2026 11:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QGn80Czw+Q8aNgWthHK97QTsMBMg/HtanGxumcKLgUM=; b=ROLS+Rf0RgXL7Gvn
	tkk8FHreJAvZqLmANpC9Cqsjv4rLZno2Hp4Xb+0FGvV6Gf7TUuZHcgyeDfXhFBDY
	b/KAn2USklQFfwhU+8eCn56An2IqQeaIbyy79jTXUdHJxBgvl5tOQ4JE8R7hgqkL
	n4WwzQxKGvVtN4/1z29X3Qi0LXzCSuhGyYYj6kIK7VhWmFKA4kW7XGUFxUENsYf6
	kk1DDCD8ROHxI4hckxJoymPl9retNx7KIYSFioTf31F7EZDqBNyZlo7dRK9clnLo
	C2j5Bb0Yml+Ib6QrndeDwj7rXGu0WmMQ8iAkPLR+ki9ntHijhP5KE7Ze7zVK/BXK
	VI4p9Q==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epe25rxwj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2026 11:00:51 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bf30576aa3so38209415ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2026 04:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781002851; x=1781607651; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGn80Czw+Q8aNgWthHK97QTsMBMg/HtanGxumcKLgUM=;
        b=NWyOzsBODN68Frm3Dck5lbkzU8uQ4W6U84NeeO94W/X4Bg0ougfgPrXNelHfnpRlxi
         9e7T9LB9Ci4UDFrtqH1pUGhJebM2ySwJV075ZzDSjhBDaH2xk2dcHDTB05u0rFOv+ymt
         UQowsEh1cZguwAgvvzNFZ/b0FWyO+zKpOi9nvBDg5yH/gv3zrcOQxXoElptEY2uTNIH5
         8qR4OYLNi5CRWzWiskfdoblZpFaA0oK6jLRfZTcidoBodAmgj7NwZc/kdeGq4g+Mqh0L
         9lFqUPPoDBCc+t3HKQm8edGqZE88hwRrGjlmH0UKhEt1juZWLn5lpz6vJzS/kPfg0scp
         jC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781002851; x=1781607651;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGn80Czw+Q8aNgWthHK97QTsMBMg/HtanGxumcKLgUM=;
        b=FMTDBuaDreORMyH41hid4WXSZW1Fls/YNwe4vW7QaZafmp/BPWp4OslOZypho/cGYB
         RJHIKKjb0Jfs77Yziwl1DIWNAe6wvd34eo1mpsyjW74LujHxZu+01ynk/FLCDGiEornC
         zTfEejsmTYgIZtva98zFqljO2R4ik2ftyVE23hqlo7MjhyH4nY/R0n6XuOPQF0Il5e2g
         CpKhPXCf3h6KfZSns7YEVTHN7HTh31JyUQjQ80ZWxO2d3YMoNLh3GtHmd4FIWiB91Iml
         3GcnGtFNhPhBAKsEP0RnRGxaXS6S/I9BWH7zx3Eo4FM73RIrtJFl0axKAmxCNpoWMwrP
         7WuA==
X-Gm-Message-State: AOJu0YyeERG04tkZxRJTfPwYHFCu7YZy2c66Y/f2Q2ILEog5ouWnFA3x
	Q2zGN3qAglrgW3QQ35tSZaYktLB5houtzBZKUNuufhZs63pIjKl0tYyFOq6blWR8GmACfpPv2WL
	yeT0LtMCzxcIlOuRuMu5QHY0YDUxTabyfE8pwn0Ed1F6whgfCTbn91R7eiFKu0whFyC929g==
X-Gm-Gg: Acq92OF0HegS5F6oA5FZSAek+20OulboRUCnYdH7By1ecroIluz6D1Jko3T37nsihIA
	EJkwhjhmnrDNmQIpqm8uj7+g/Sjhqae/Gce6yc6svI+KQw8+x3OQMHV2+3OVSD2QGMRv8EH25j3
	0teEB09qbmX9RrNXcyGLL47JGRy7IXbpFlU+nBzuiJkuOZeNRXGSSBsJJ5RiTBkPq/a1YG6Vcls
	5GSf+TXXsCZvIvoYDTpCYZEUmiN9IH1mK2ydQQPPV6xZQuRTCwInALM7kexI5W2L+IWceHYOogx
	29IN8j41Uzwsz9gtP5n+ZrfW57WqV0+pa7oO0ZVgIeB8q3I8e3kZY51NdJzKzzpfqzGaZy+msXl
	fFIIWfqx9i+fNlL68TODOC5qaJydN3aXEZM8F5z/2x014896ovXVkwlhvET2JVXuQwNUYzd3c
X-Received: by 2002:a17:902:f541:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2c2a1bb43e7mr30142235ad.1.1781002850445;
        Tue, 09 Jun 2026 04:00:50 -0700 (PDT)
X-Received: by 2002:a17:902:f541:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2c2a1bb43e7mr30140895ad.1.1781002849195;
        Tue, 09 Jun 2026 04:00:49 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f875casm211576805ad.22.2026.06.09.04.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 04:00:48 -0700 (PDT)
Message-ID: <6545e04a-eded-42a2-b773-92d9e9ed2226@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 16:30:44 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: fix refcount leak in
 ath11k_ahb_fw_resources_init()
To: Wentao Liang <vulab@iscas.ac.cn>, jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260609092528.220547-1-vulab@iscas.ac.cn>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260609092528.220547-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Z8dcyIzp0IdIsFNxfSmcAKZ75baAkI6l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDEwMyBTYWx0ZWRfX32tiErM+e/jR
 a/4dHG5zCBsQ4OmPyQlLuEmCpQkKJOJdwn8Fh0TXyw8Sk1BbFU36x812LICkzl64juDkWDPktCm
 VX8ndvJnzOwa/ExoqMcHAzsjbrXq/7KHr9ThNDDUjecAKgcg8w5+Z01b4LhIXlYADX6LJu74TSP
 T7uZUZVLuCIhfMkbEDY4Bs7xd8HUSO7tL0q5gpBwoRV3lvvAProHVbSHC2yRe8HN/BjBleYqmo7
 UXd10csSjr3/0u5S/FzujFXilGqVBf1MK1EQkzLZtrrc3ca9bKeMhrU1NeeKT3NVS2eOvzuFp1y
 jsFl7xu+x1vIwmRq63b2xL01uEahJFZmijrwE60TYHF9c5Ys7GWpiVjOHxBViCLUoGLCvukTjii
 ho5Rv8AoMns2CCgWa6eev42YQMwbMoSIzqvfiuKQkDUqF3IcFpef46L1C2d2xzGkK0CzkiZyjjK
 QRx/WuiXYjsBGWEZLNg==
X-Proofpoint-GUID: Z8dcyIzp0IdIsFNxfSmcAKZ75baAkI6l
X-Authority-Analysis: v=2.4 cv=LoqiDHdc c=1 sm=1 tr=0 ts=6a27f263 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=q36DTRNDronnURX6cDEA:9 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090103

On 6/9/2026 2:55 PM, Wentao Liang wrote:
> of_get_child_by_name() returns a node pointer with refcount
> incremented, but the error path when ath11k_ahb_setup_msa_resources()
> fails does not release it.  Add the missing of_node_put() to avoid
> leaking the reference.
> 
> Cc: stable@vger.kernel.org
> Fixes: 095cb947490c ("wifi: ath11k: allow missing memory-regions")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
