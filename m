Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF5E37DAA9
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787134866; cv=none; b=liSZbi0Rsc/kbH+P7rKOtTxlWSh2YUhycVzYBnNUsVt4jgnFbHK2BuPTP5LR47qyDiafpEXuCyupozGoD3naKst4d5dh9tuHforL7bOqPT0Ta9rFVajlroCspn1Fd2PUCI5PPj8VgnldkleqkGqK1g3sKjuekpL5PYHI4OfFEWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787134866; c=relaxed/simple;
	bh=09Wja3Lua6ZclFTzMwzn5epLhlTwhXYUK3433dOCzaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BLDf/ewOkkMTfvVc5uTAiyxdVnkU2FoKAp5IpFVafPBdJIwWp7tojsPcsnjOrS49Vr6rXXRG/FjWy94F8V56I8shRzF7oauPY57phb4bTLIkWudoUaeu1JF9IiMgl6OFuyrXE4/JhpUn4RV4R2cHyjB49iKDYMSouOQmiqWLOyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HEYCFSg5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I/iynUx6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HEYCFSg5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I/iynUx6"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JA7x0g516010
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Txp34vbTY5C3QHBb5kcsCTYB4ex7ke1L2A4ilPvEFKw=; b=HEYCFSg5qFUhLLzj
	lx0Qf5QJyJn7p+yeYBe3gRz3XFaqDwUeDR9BM/q0roQrmIBytTYJxQIuAEpGpFE/
	7uC7Qi0YWdHmUp1TzKcjX5oSZoCp86SG3aWnzjbAvZtVWFruzSht+7onfeuXh6AZ
	qpq0781FZ6ENSdmTii8vMdcBhMdXVTFaLF9PqZX2BoIfjD5MHSewSS37fG24CMP+
	bw3Mchc//+PfdLy/H/pQyQtYWf3j/GlMJfuVTyrpVJDdZ99UJugya5+h9XHA+10t
	MNXaqvS8zo54Kd7OisWDsjdrZqABm2Gm/Iju5pBU8c+gSEdWX8HVJUeVvDHavpOG
	Z5RDSw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfptkc2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:21:04 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so999680a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 03:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787134864; x=1787739664; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Txp34vbTY5C3QHBb5kcsCTYB4ex7ke1L2A4ilPvEFKw=;
        b=I/iynUx6qJOTGZjW8xM+acnB0/kdYX5a0aIhQMwuMSXIYNpEtfbzlVTIqllTCgtxM0
         wJCiCGmI6FPsstH7AUYDxMYazON4K5B/1CKjPxUXO1z0K4DBmhsD7wfWAmO5ZTYcQwPI
         xCKro8oF0PBKWzvcbbwF18cXlrAw0PjTomUAN36vtxXABKqOWNUFzB1sdfuEdhOEaXh5
         jh9CNlunv1ZFwCUTC1LY++jWT6Ajg1heOG33umbWTKsYjTwb19aB0mM2oQe4HyeXVN61
         0IH4i4xw7RWC1mv/h1UJMdNjGODrDgYbz2FEZ8bntlTtDTbiHnqs4lBNiasrN3mDTOEH
         Cdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787134864; x=1787739664;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Txp34vbTY5C3QHBb5kcsCTYB4ex7ke1L2A4ilPvEFKw=;
        b=e70iOTQXKsTDrlUn2UwmK5hhvdcFgfx9yvD0jZ2scALpqGTkCiNeq2l8ZKupNE+bUG
         v0dB7sqmyC5Is6SfmhwWMewLPbUHOP/o0CZhr3LNMsX+hjWiu8QjbIKW1+iiGiClmi1/
         hqurBuu3ySjpM1EEDu2q+tJRqmg5lR61Pm3Hw+epX8g5hl4CTW456wD6RYoRQITbV7lP
         mVk8GIMu4RpHWLlyzaZ0aj3TzE4bTyatzRLAQcNWAxcBve5kuPGbG0TErOky80YjdDO8
         s1lc+cB3CgWbAyerFesxQLDfKUTotR6gSxA0qQBJriLgU3dAANph8k5mQ1QsMc/iiNBU
         rH4g==
X-Gm-Message-State: AFuF++mTt6aVRtjpwV42+udyXxufweIqG+vwPRBzO0OQU2j9AakrEYx5
	X7bZ9KrLpxzTT1oLCbjI8Ri6Pb67yjqomBmCWrcBwJYxCiUW2C/Z+e5G8SEJ45muCTvGI7kSZcl
	1qinfVmkUGdvzhIYXgko1jNsYtkKn83IItfZ4XvgUwE/j6TdXGH6MgI39G7IGBW3565U1cw==
X-Gm-Gg: AR+sD13d9pSoQ+Kh6d87NHn4mNiWgHLsY9Sj+Fd1Bwk+YpoYKiPT7GR5UpzRu5F5G67
	cc6UYvhxplk6De+RWNZZk9gPlG4I6ucv4Z1njMEd7JROW5kJ16SJFsr14fXKkN40ENVggbi0Ind
	8NE1NiRThK972xNIIkmD+lsf+eT0H3hL4bnU+78OTmjluekI753QtsK9EF2K+E5bjMut1JfwOad
	LpL4M7r/C0p1JANi4TDRBN7Bd0p++H2cF6Gxb3eg2IdhmumZ3kPBP/sCuegvhlK9GLiBy/LZph6
	3fyPnNBEKRd8ZYBPnakUcbu9SDru582jcCtZpT9ivHhvzv41f2xD6Yuh7S1l/yEbsPsgiRWu2g9
	xOEO/oROZRqP+QSWu4AZqBCn04sNG1/lC9g==
X-Received: by 2002:a17:90b:2b4f:b0:38e:67e1:15b with SMTP id 98e67ed59e1d1-39580f0d585mr7179831a91.6.1787134863636;
        Wed, 19 Aug 2026 03:21:03 -0700 (PDT)
X-Received: by 2002:a17:90b:2b4f:b0:38e:67e1:15b with SMTP id 98e67ed59e1d1-39580f0d585mr7179728a91.6.1787134863070;
        Wed, 19 Aug 2026 03:21:03 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf175399sm10077903eec.26.2026.08.19.03.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 03:21:02 -0700 (PDT)
Message-ID: <d1de686c-5e46-42b7-9dc2-02a4dba5686f@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 15:50:58 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/2] wifi: ath12k: Free allocated CE IRQs on
 request_irq() failure
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
 <20260819065425.2044186-2-aaradhana.sahu@oss.qualcomm.com>
 <3be7c1ed-6298-4d85-bb47-3bd0337eca6a@oss.qualcomm.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <3be7c1ed-6298-4d85-bb47-3bd0337eca6a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Csz3JIWBTDnjoEUYJegSfI4TEvxgcEEU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA3OCBTYWx0ZWRfXyUWOKIY41W3d
 aLWftjMd/wdlfK6l+V5e0v9cyekHJmzTXiTa450ZwY4BO6fa2V/+97P03pLdzHOhPJCy1Iqhkxw
 Hj/PyTGmn6KrZtKg+2c/aPgfRja7R83CQaZ+UbLFy2ZRrJb16sVh+xn+2n57pY0g3FvXs8D5uM+
 u8Z3BUzON9GNKYoGhLdjt9k+mKA6lEx7c0guc8BWQfYq3TvXNsLnht+MgmXHWW9npp/FflSWaDS
 0NrOBXG6cjwtmQPw0j5DLYfJLyKHxmzEgZox4vwd/zwIyhzQgjXHGh3fp8U6nlzKoT9mx04L3Z7
 kT7FqiKYtBjHGbmO7/o14L8+1KfwT36yONghs+s0dqtlsSj0hj3QDijdiqmUMlT/BZ6lSoT9Znj
 97viZ5wPBXuuovIkXmdNyGUvIdhVdCizzG3fVO/rUo7GAcWj8kh7ymhAtQ+FY6r2iL3pCLcUWpm
 ftMw3CPizvXrYFt/4QQ==
X-Authority-Analysis: v=2.4 cv=aMrAb79m c=1 sm=1 tr=0 ts=6a858390 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=vnLL-qGiFqK5JrfbvNcA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: Csz3JIWBTDnjoEUYJegSfI4TEvxgcEEU
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA3OCBTYWx0ZWRfXw+aWk4Z2dZFg
 GHn8nPIIIc6JuLR3axPdzDcP3RhOkjv5dsUQU/tWB+ZI0GBakMQjcZOmILzp4YKp/DIbEL9BUu3
 9uxAtEryl3ioo8gsTusWw6MCQsRzJec=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190078



On 8/19/2026 3:43 PM, Baochen Qiang wrote:
> 
> 
> On 8/19/2026 2:54 PM, Aaradhana Sahu wrote:
>> When CE IRQ configuration fails, the driver does not release all IRQs
>> that were successfully requested before the failure. This can leak IRQ
>> resources during probe failure.
>>
>> Free the previously requested CE IRQs before returning from the error
>> path to ensure that partially initialized IRQ resources are properly
>> cleaned up during probe failure.
>>
>> Factor out the CE IRQ cleanup into a helper to reuse the cleanup logic
>> during both error handling and driver teardown.
>>
>> Also free CE IRQs when external IRQ configuration fails, before
>> returning from the error path.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
>>
>> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
>> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath12k/pci.c | 29 ++++++++++++++++++---------
>>  1 file changed, 19 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
>> index 6441927b5382..9a78d2f69f94 100644
>> --- a/drivers/net/wireless/ath/ath12k/pci.c
>> +++ b/drivers/net/wireless/ath/ath12k/pci.c
>> @@ -313,6 +313,19 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
>>  	ath12k_mhi_set_mhictrl_reset(ab);
>>  }
>>  
>> +static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
>> +{
>> +	int i, irq_idx;
>> +
>> +	for (i = 0; i < num_ce; i++) {
>> +		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
>> +			continue;
>> +
>> +		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
>> +		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
>> +	}
>> +}
>> +
>>  static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
>>  {
>>  	int i, j;
>> @@ -330,15 +343,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
>>  
>>  static void ath12k_pci_free_irq(struct ath12k_base *ab)
>>  {
>> -	int i, irq_idx;
>> -
>> -	for (i = 0; i < ab->hw_params->ce_count; i++) {
>> -		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
>> -			continue;
>> -		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
>> -		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
>> -	}
>> -
>> +	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
>>  	ath12k_pci_free_ext_irq(ab);
>>  }
>>  
>> @@ -671,6 +676,8 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
>>  		if (ret) {
>>  			ath12k_err(ab, "failed to request irq %d: %d\n",
>>  				   irq_idx, ret);
>> +
>> +			ath12k_pci_free_ce_irq(ab, i);
>>  			return ret;
>>  		}
>>  
>> @@ -681,8 +688,10 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
>>  	}
>>  
>>  	ret = ath12k_pci_ext_irq_config(ab);
>> -	if (ret)
>> +	if (ret) {
>> +		ath12k_pci_ce_irq_disable(ab, ab->hw_params->ce_count);
> 
> ath12k_pci_free_ce_irq() instead ?
> 

My bad, I will fix this.

>>  		return ret;
>> +	}
>>  
>>  	return 0;
>>  }
> 

