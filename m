Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D724749DD
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 09:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365738; cv=none; b=DQwgpsKOpF3gvMEDL+jfng1RlKnicp73PPL7mkcI4M/slQQY8AEQodss2leiTMmT0as3vCAw5RPmKkokkKYfix+4axJOkywnY5VLBjFVjj1iyMHdDK/I0Qq6b+jLYtpRwIzXiK123uOoRyQ2p/lZjVXIiN/kuXhIKBaeQvyI2Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365738; c=relaxed/simple;
	bh=sukgP5Yz3NvqLS1QVziCClY+uJh7JmyNTFZNJP94JnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmbMpOkalbQWucpr7oqmw3OONB+h/UNzJ1+k7UmBa2RS7EiW3vadpCwn1px462jsBusdoccuqajo0esp2Q8UJ9S+jUOXBdBqg9k5a1SLgcjcUra9mlJccetPNoI8MdqPDyXectuL0kbCT0tsW6WIj4N9xiwGFMlthikMa1fqw/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Kj116TiJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VL9M9w17; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Kj116TiJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VL9M9w17"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6977jrw52312929
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FWHBpKt1zMgFknbQah/VG7jCcJ0lGDysyv+pzjzXw44=; b=Kj116TiJ1liFsAdP
	EPU+WEWBIHdO1GVW4MLVqZK8qsjfeqw7LLRPlscuIYy9UE3V09Av4qHBWVLrG0iQ
	Al2go6ZFr+priuiQov75UVvbuV1VLd5WgmiRbmacTdxxE/g2jFYofOJejNWEdtl/
	8x9uu2gPiJWLAqXnWpzoMOoc/5OydJtojgsrRTFDrPAUE4zVrMw0gWnIJmD4keQB
	xAsDkV4d1NTQQoouh2K72oeOfybyOxecxSlQhJi3T6DCwMvrPgxLn9BoK17F+QyN
	8uDuEsQLDY0Wu3xSvKJX5n5228lSbni+M6GokcePJt0dtgUf0/drhqVbNvbgSCZU
	76rGQA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h53asksf9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:35:23 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3510a481ae9so7485265eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 02:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791365723; x=1791970523; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FWHBpKt1zMgFknbQah/VG7jCcJ0lGDysyv+pzjzXw44=;
        b=VL9M9w17kQ76N04nJBtQQVz4KmKbfBaSMlWEinQ3PKsXlU4oNmvGI+IRKg+ZZFGlcw
         pBFS6NGvI+ff7P9JfB9jxvSNSuLD6lMV79TLtdLSvInM13Ui1srK1p5uZbTtaUlTnay/
         bASik4ztdT8x7i9qYVuzetPrIpBA+y4KoMbLR3Iv/zn5BtcjmxKqZPWvp3m+ko6CeSHQ
         bZQfodUjhwtMPL5eGh+VWmLmeg1F+Cz+fGD615VOm29ZFuNmN7edxixJ4K3dnyMveYRB
         jZEZoOR5gxD5O6whI860ax4KO45KA7zvyJbG5rL/aqWZrh113Pqq+oEj45n9Z1OIpjqt
         g/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791365723; x=1791970523;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FWHBpKt1zMgFknbQah/VG7jCcJ0lGDysyv+pzjzXw44=;
        b=kq75c9In0OU1R00AqImvQ/1wiBeJu/OTwoHwKuDHX3fq6GUVSBtBN1X253lyVsnGpx
         9ym1xeuEAeXDnhT4a2Y28t2XJmWda8oVccLkitQ6Cq1JXiSx4pnfQ013OaRisVGr8NOi
         H5NRWttmlPJAzABvGjFFz/55HAm4HlpcEhlIdPjhTBmOlom5sZU6VpmgdKE+LrDBrIVi
         FPpJkA5Tc3L6ZhjGbRvnMWytFr2771JIfei6ucDavqKSOV0uKxeO4EMHlpC2nvY7xezG
         BHm0vwo3jE2WRV0G2bCRpJPDSpkgit/ovjy9MO0g3lGu7XD2y96meOQwCdqxO8qRwTof
         aEqA==
X-Forwarded-Encrypted: i=1; AKwUvBzh8dUTUcZFPA4LzClmQOagTYUHjCebch4bOOA/1Uc83oow48YIqFJYKJ9AlvVtBAJox7CEJvbOGLk14J1giA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIFgvOjaIg4wzbLQnJDWczaBAC7yQw8HiA9AIx6s4wd5Z/bveOK
	TBmpXofECVYS4n4/lN6+0j19VjiBOko4GRwouak5jnQ7FiuRAZOb+78idout7aSwJiZd0G52Sn9
	l8DQxdhe2TwJUT5EdtwiM2iwsa07rvnfIw+ngfFNlUNt88GYr3imiwjo0er6klA/SgqEJGw==
X-Gm-Gg: AYBFou3E/wenIu5DzDitPM30mvT9zGxbrh1REYtD96G4WHONQDhcq1UHwmtaqqV4UXL
	+/1rE2PiNOIHa7CCiPFGbg8eh3wC4PTTb44ch7X6aGRn+j8MRDVfMEZAsn49LSYddbjap95BU0T
	T4QQoLCwVUewhEIBi9vQ5njn5nVnEAolmYGm0/+WlpirmLbGEdmbWaQU3Gcdk9PDcmMIH6BbDey
	UZw//9becgDwxBonJsT8B4GGf6tAG0FPxNGohOr0csnNxZM7UqsN7M1YGwpwIs4msxt/Ni8toOQ
	+fqn0JBGi/0Q99FrGx/UvzRhD9dRjkxUaZpeHOHSd6pcpqwAaRlM0ZhEgFti597Kfet8hyVzlhs
	tCrUs/Jodm6/o3qqvvvOrhMma8dMK9zwTXxtWL4rP
X-Received: by 2002:a05:7301:670a:b0:351:4d03:c6a with SMTP id 5a478bee46e88-3515dd4c790mr2842778eec.12.1791365722823;
        Wed, 07 Oct 2026 02:35:22 -0700 (PDT)
X-Received: by 2002:a05:7301:670a:b0:351:4d03:c6a with SMTP id 5a478bee46e88-3515dd4c790mr2842036eec.12.1791365714103;
        Wed, 07 Oct 2026 02:35:14 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3515afa61e8sm7406692eec.22.2026.10.07.02.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 02:35:13 -0700 (PDT)
Message-ID: <6f6efa34-8e87-49db-bef2-e552c9abf0fb@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 15:05:08 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4] wifi: ath12k: advertise interface MAC address
 pool
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        baochen.qiang@oss.qualcomm.com, kang.yang@oss.qualcomm.com
References: <20260922200643.1133491-2-ivitro@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260922200643.1133491-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: LIiEbt10lmrJs62dsACsbYawmwy0V7sc
X-Proofpoint-GUID: LIiEbt10lmrJs62dsACsbYawmwy0V7sc
X-Authority-Analysis: v=2.4 cv=Xt5vqlF9 c=1 sm=1 tr=0 ts=6ac6125b cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=m8ToADvmAAAA:8 a=EUspDBNiAAAA:8 a=PJUtwoy5LLMsS-UO4yUA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAzOCBTYWx0ZWRfX2NRSdp12jxsq
 LuE7jZHQIULYS4aXm/nxWxEUY+WUd64B552he4Ge1/DtHSwBYPIjO0ZBcwfzvOnwN27ClsS3UU2
 ZKXxpv4T9EXMcpqLkDdSr5x1kilZ60pPAMNMnngoJ/nE5VVA2l+cCnKVWcpgT+MGtClCoZU0w9p
 DNhAowhL5ALiqWGNQnbW7No13XV3M8eL/+KBhiy6U/cXm4Q75HfyoZmCmijmI3ZVfESK3bdS9t8
 om8aZ/DLoQq+hA5hCacoVuTtIo7hROJrB4ghTx9fKPla0zr6SMyvKKqQcTGYa2CalmkO5/uLzwm
 siy4qED56DNCJsKSUtOOZKf7vlB3Jni+jSV/Tg91haLHMshDw+4qhRNAHPVEPu+8LGeIzBGMFrb
 59dINm073d0k8Y5OKuciA6xx0KmCFfzV/a8f7riB019z+EZlTUgDxVmZQdJCnEdXPmHE0HCBg8K
 fWjqIDeOHmBQMZi06pQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAzOCBTYWx0ZWRfX5SckjkJQvdf5
 /qNlhbhcCQlZlY2X1SHwKN784NJ27HM9YGaku+8HsC3mBuuv1RacA8z8btByHbK20ZYq4PxRM54
 W8IbgAE0ZeXAFzd8zhqgK8IRBG1GzJI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070038

On 9/23/2026 1:36 AM, Vitor Soares wrote:
> From: Vitor Soares <vitor.soares@toradex.com>
> 
> ath12k supports creating vdevs with addresses provided by mac80211.
> Userspace can already make concurrent interfaces work by explicitly
> assigning different locally administered addresses.
> 
> However, ath12k does not advertise an address list, so when a second
> interface is created without an explicit address, mac80211 has nothing
> to pick from and falls back to the permanent address. If the first
> interface is already running with that address, bringing up the second
> one fails with -ENOTUNIQ.
> 
> As in ath11k, provide a list of usable addresses so
> ieee80211_assign_perm_addr() can hand each new interface an unused one.
> Keep the first entry as the wiphy's permanent MAC address. Generate the
> remaining entries as locally administered variants by changing only the
> upper nibble of the first octet, which naturally limits the pool to 16
> unique addresses.
> 
> The cfg80211 definition of wiphy->addresses does not specify where the
> addresses must come from. Some ath12k platforms use it as an interface
> MAC address pool, while others use it for firmware-provided per-radio
> addresses. Gate the generated address pool behind
> advertise_iface_mac_pool and enable it for WCN7850 and QCC2072. The flag
> is read from the first radio, as all radios behind a wiphy are
> expected to have the same setting.
> 
> Other platforms keep the existing behavior.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> Tested-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
