Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE86F3043DE
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785462093; cv=none; b=G9OLIKTQOk0XBL7SMtIqxCOeHgusUCsoHfuzBsi9MPmL3tzi8XgKRwPSlOTyT/mElNLY5dzeg+Z1eE/YocmXm+veA+TC5BunAFN7oNo8qga2HOSchQJNmH41H5IpDIaFSEGtWMQ5bYDDnUl3ggw63mPMhbqggk/AdjKOcNIDcf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785462093; c=relaxed/simple;
	bh=mjnkSxqc/tJaMtT9vktFdEMRbn/cqZgaLBBxm9xCHao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hEtXuKJXg0NUkV4daLYbH5dUM2qeT5y4DlYh54SC+DsrkNCaYSdS4N39+z1uHXAbKcEDMgAPqFOPehm6H24/pi3DqlSO8rAXSKkuups0sKTsxG2wsNhsAMxU9wqic3WNjtEnWmw65MNZqpPNeIe7BC15+MQbutDouZqgUV6aIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=axctEDfJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gqsv190S; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="axctEDfJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gqsv190S"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V0Ls3v2306156
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TvsrvQy2V404Co0+jbZbMTjawqixijfS7FDoOdJXilw=; b=axctEDfJyDPPXp6H
	00S2/ZOi997mHr9xDi967jEVbDvky74eUGwgZbTnKdp9iecdsMqR4mDkSdBDruEu
	fAfHxtYZQXacWNphtUHK7hsfXp6u4mbx1rFjkRUItbBx9QkOyVIbXI4YxWQmUbwI
	r3rFUXb+czpu92PbCwP58guJOL+wKgdAD/2L7Vd02d7B3qnNim90kytDEz61uz5g
	6YQs5ikhr3wio51RFfdKokZNfWbAzuMhnlUFg1BATa3IyUwR+8WfEYLnFOcmQhHN
	kTSh1kSIYA5fHGXuCLFc3hBiFwcVb5wx2x9IOM5guNGmVDcuD5EH59nH7e9Mlvr2
	yjcBog==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frh3nr6e7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:41:31 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8485b7e18b4so994283b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 18:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785462091; x=1786066891; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TvsrvQy2V404Co0+jbZbMTjawqixijfS7FDoOdJXilw=;
        b=gqsv190S1INKJrjgK10aalK78P+oZkVgU7uT0f5nNREpZVUNKMr/PdADqGEKQRVwkg
         hosnaOW6SUz7f9oOQlf+6UkvkaOdNygyjhbv0I6lXsStmii5+C4EAwUW3cy4jt5523eo
         iineqswa4E4xbp/B+PFV8dAQrG2AmMtY2E6TX1ZVfxCV4c6H7o2N0LAJkeGZziU0IWez
         3OVyLA99ZtbE/3gW4vGxSXQJN/SMFqnjBdeAj3vQ2RF5cj1X6tLS+UUG+xc4IXusVRwn
         FCzcLIDHu2zTtP+2VfzdAY+FVCZZv6dZHCN0Wr+D4E71cTF3uGrAluEoNELrsHiVjJ53
         ZYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785462091; x=1786066891;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TvsrvQy2V404Co0+jbZbMTjawqixijfS7FDoOdJXilw=;
        b=JAzLfEkAl0H7nzNW3p3rtcO6t9Q2YdDdMdMq8D1rsLKGiU9O41YmJ50XObHnnpQ2bX
         3K+lIdJCHvpbyEb/XHi+HYijHNjdgid3UAR1aJB7kp97xRJfo1zcRYz9MQUGh42GqvbY
         LzjE7KCJyBgKkacPilqDZrOwH8ETLKcq65mBDHNTQ6TScZSzlZBblTWm935XYmipKGsb
         U43gbF1f7KriJfauwKVJposePRw7gL3I6keu9EFSvMAqxFqkMM6Djjy/5Fl046ES8C+S
         3hbC6xdbHpg2nNJIT5U36FWOifwnR/5uG8jMTYz+KfRSGr1kf1J0vSZsWyEh1aXlMbJ1
         t1wg==
X-Gm-Message-State: AOJu0Yzra42LFCMKQeOJqfr/4F5r2vrgESGJLBhqsfPWMsLNxz8Esg0j
	80rvLO4WADyxm4qTEeXaiC3AMWa6I0G1NGRQnhbFRsLasKSgrvdJ4zVhkLsqABatRk3p+veW7ZT
	k0LxIkW9+E3tR04u4U5FQOTm6aCFGjNJC+GVK2MKU/5uleTXnY0CWNXWl/qeyriN0c/E6sw==
X-Gm-Gg: AR+sD11feb1ZRafcUp/1a715USgLG8o1MWr1QA1sbXIuwuF982kv3CTLciHmiVm4WjE
	HTglcswLNdBS5d4i+XSJBoPcxFas8c25lEzShW8ibJRZdPKBPcHzV5ICAdL96flfhpanZZ7ULJo
	aCPxpa50B4DjCNPGt+QD7qB5f2SMqH+tgUjM7/MfmZFH4gkoVzCM2JMfDASQrhgeuS6xO6Y08gC
	ERPpCuRLdX4mZ1SwgFpZ9eclGFtLkbxC2K4+O25pb27t9hMgRWYWWn/XMO7JSUK7A3ZlMOlBKUy
	T0DZtzn2ahBNgz9JzT//PqH57HR/k9GRDKP6cmwPjFblrWdfPDK624lHrcc/R9z+k8xoZcIia2Y
	TD5odfv0sdiUndeBSJve5saxUXIqo4oK4wYC1oqdit14xhHsj68UEjO/+IfXxza+ZTzYTNYRj6Q
	==
X-Received: by 2002:a05:6a00:2d02:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84ed6d29e9bmr48096b3a.2.1785462090867;
        Thu, 30 Jul 2026 18:41:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d02:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84ed6d29e9bmr48077b3a.2.1785462090446;
        Thu, 30 Jul 2026 18:41:30 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ed5db8d36sm51110b3a.35.2026.07.30.18.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 18:41:30 -0700 (PDT)
Message-ID: <ca84a4d7-ee3e-46d5-8727-6e412e3e7416@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 09:41:26 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath10k: filter non-UTF testmode events
To: Linghui Wu <linghui.wu@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAwOCBTYWx0ZWRfXx5DE6Mpewi5C
 G5RQn8qtR6tcfkEEjeaRf2plqAA4kVutHFg4G9ijGrXYsXOiPyxWocso514r/CTTN8u+tU5CwTn
 FVnaYkYFHcwPTwAEmWGqBH34asWfYBk=
X-Proofpoint-GUID: vsI42FOmzSV4e8nXfXu6yeSjHVb4JWNx
X-Proofpoint-ORIG-GUID: vsI42FOmzSV4e8nXfXu6yeSjHVb4JWNx
X-Authority-Analysis: v=2.4 cv=W8UIkxWk c=1 sm=1 tr=0 ts=6a6bfd4b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=J8ee_osQro5uhysJbSQA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAwOCBTYWx0ZWRfXwYcH+yfWlWK2
 TDpD5kEF718hYyTTMir7bH40Q4iDIQiXqNPTAyPM5d5/jVj16CyW7ZW1HszJjV8F+7teizG0NYV
 cmW43aw9ne/JEHPVmkN31+Rb6pDzX3HVOBJN1X1fA0pdUIcfquWdeD0Gszrh6/7cSrcNmug3mco
 pfPEVO6hk/erSyOMq8jboxLDSDb0QwivtizX42sDiOwbMBfeC2nUL545yLqGUUyBt/mfkiOY6qz
 rFtXtVlRreZQGzt1UIWTIAXcoF2BpPyilx+8E8xOCtLPB2asKVgFr5TbOKHtb+INKuYcycou2vD
 5qyuvxMpMcEqYgqk0I+XiSXDz6p9/M9Re1GR4oLm04XAYoitSKApiPsMdCpl5NW16NTY5dzuoqm
 0aX1oiCWql4MQZgL6jglUZsubHj8nTIou+ytPhsgHrkyW8BVyQET9N7apBK1h0w+CpJEKUCGgHl
 MDmF9jYjYPXVD17q0Ng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310008



On 7/30/2026 10:32 AM, Linghui Wu wrote:
> When UTF monitor is enabled, ath10k forwards WMI events to nl80211
> testmode. Non-UTF events can therefore be delivered to userspace and
> confuse FTM tools which expect only UTF responses.
> 
> Only forward known UTF event IDs from WMI event namespaces that route
> events through ath10k_tm_event_wmi(), and drop other WMI events while UTF
> monitor is active. READY events are still handled by the normal WMI
> receive path.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00093.2-QCAHLSWMTPL-1
> 
> Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
