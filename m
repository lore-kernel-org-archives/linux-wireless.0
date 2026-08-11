Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9D418340
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439317; cv=none; b=I1jyxjHRpsu6yY/3jNmWRimsN6DzhUL/Xnig9djUIwzOAxOwGDQqUz3bzBlvINoSQDqk3IDECJBS/XJJW7PdzHqaXsPwq6nL9eUhwvgN1v2fX/8ma0NWmFE6aQDtQMq0LGH+TK5ukzazBfa0UXBteYTHtzsdEVz0ENsG044iOtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439317; c=relaxed/simple;
	bh=7CbOcwWZ7ZZr53jmxUWNeG8P3y1wnw7lQL+FlVMjxt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CP3IxxJCNtif3ULcu6wiK7BLNkU3/4AQi2uW+K29wJd9wm84Kr5lSfw2P5TeptlqL8yw6QjIjfkzm1ndc2JyFOy8P9vGF6MEk3eUwI9yICKnmdXEBYg16KfYDSnAKxRYFZIWuFP7Ke40Z3Pw6fFCON9XnCpL5sAaGXD52CNWbMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OORMp2yK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=df9VOvsj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OORMp2yK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="df9VOvsj"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B6orDs3307992
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LjUuYXbdt0kh11on79yWHneJJYx9txmfhYypn2EGBjQ=; b=OORMp2yKH/WfTg6A
	rGNXjxzrLHDLY3+uI6ea1nqX7qpH7qBSjq+GcgIpN+MigoVhsf6on7sKH7asMj0c
	NvFApJqu/nrpa4SQTckv5X/S5iaebjO/FxfpxX36QMlSNAoKeuxCYJDNcm9SGocf
	PbjlQkKbc9F6m5flBgc5xGGYT78F5A0QhkOg67jX0DNGcrYGEFpFWMxDgEWX8h4x
	MU+X57poVt0rVky2P6Cog/llWLzJojqaoCWC7xuw5FYzS1qIMC6WUsiiyfvFMGKb
	pmo/k33Do3mu3pQcEaaj7aw+LGKPiiYr/1eTTi7ogXfMsHbkrSVxeFjZXt31xJRH
	JrLfQw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyjyfu9ff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:08:34 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84885a4fcabso3047173b3a.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 02:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786439313; x=1787044113; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjUuYXbdt0kh11on79yWHneJJYx9txmfhYypn2EGBjQ=;
        b=df9VOvsj/wNNRTZKsKZJZE2NhNv56d6GWaSU/kwCkMFm6+siHRU1iD9O8NkX6TAqNy
         nEthZHhyT9+lYU5woNgRFbhSZ/YeFCfKQVOT6imSfulOK0BZWPCmnSp2oLOm/GJTrgIp
         rCCGhelXVABVk5gWPoW2HbaXRTr4YxnDnEq/yPACbsMmB7TcPmcqcUlS75wHgbfBT6gO
         1uhoaPXwE0DTQNW8ps98ehIwmKVR0/Bp3qhKPLEZhCB2S02CwxNcnaHFAOsT7Lq//GuQ
         oTaSzTAj40MUrhzPRZv9kF1JPwq90Ktxnm/W7G6vx+BwtcByjNv3B2Y6Cy1BUiORZR+H
         T0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786439313; x=1787044113;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LjUuYXbdt0kh11on79yWHneJJYx9txmfhYypn2EGBjQ=;
        b=S7rtdrcW+lXPeJVqU4Cpf7576TDB8AoFwS1Po+yWZrdhcGizNQ95fUH9wPNHcmRTjT
         G+G+KRDb121nLssQRqzGbVMA4fD/0exXKGd96IHIjGe6GqNhQwnIZZB51ER7+Tv/K909
         L/GINx0lHxC0jqW3HQhGSnwhnxLZcWBXpM+EC/Y6KRnsU1DMTSMzP2MCdI6MesVxVUjE
         1vnUFEpXkifk1x7mI4g8kZ4hbCRcOM2aFd1AVyp2Pvm+JQfxG9Er3/i8GvEKMXEMEKeB
         dsY9s7UOLPQTXT83qPFmuZQDDJloVCn+epuy2x2oxGgl9+2Su9a4ZTy/h+lHXL9H4Erw
         sEzg==
X-Gm-Message-State: AOJu0YyDWa52YQmXgA4sNtgxg+/BlZ1kqg4Y0t7JgBZcTN0ctx0ijB8V
	9/5bkUlszTSemclPv79cJnBTL9ZKqjXsMk2hyae5o4Ai3peCFEr23TfppSWg4sH0icReCayq+uM
	gVbtu5aPycyfUVk+f9OTTga5ZFN2weUMZ5Ql8DTIyTR7HY+euReaubCTbgzGOj2LAi+pdzg==
X-Gm-Gg: AR+sD12mr/aoG8TkMOOEPpjv8LVf2T0BUIH9PMYMi9rz0898CcHKJAfajPRq7PliXu+
	DrXaLCfN83pgNvH9Kr6/bdAZefJQeMyC7rddGWhSP7UiIKnOgxmoz2lRhjTNBvKYrHpjytdOtMY
	7wGZty+nHk2dyJwngVJuTyvQzKYwrrQxF43+RmU78yeO9Xl9JnZG25g/XqcPWLHLV/G1Kxtz1KT
	eDpbDP/bwtOGltWvG3O8dQxojNrH+zs2fQL+fa+OSZGYURWY/7oEbaoU4NlSlCB2vtGDMLxkuKj
	SbrQnwnaofw/KHNyBCawFELMOfS+xTUdbw4HEkME2+QM7cuXxFAB+/u/1WkRxXd4VfzdmNlmOl9
	FEZMRHmeca+KV1nCpstKJzWVr04t/YTBRDKUHaAFuDWdE6sg=
X-Received: by 2002:a05:6a00:4c98:b0:84c:1cd2:142e with SMTP id d2e1a72fcca58-84fa8877ed2mr1890569b3a.23.1786439313075;
        Tue, 11 Aug 2026 02:08:33 -0700 (PDT)
X-Received: by 2002:a05:6a00:4c98:b0:84c:1cd2:142e with SMTP id d2e1a72fcca58-84fa8877ed2mr1890513b3a.23.1786439312577;
        Tue, 11 Aug 2026 02:08:32 -0700 (PDT)
Received: from [10.152.206.38] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed881a102sm565034a12.0.2026.08.11.02.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 02:08:32 -0700 (PDT)
Message-ID: <c66e03b5-4f49-45e6-ad18-96bb8370cead@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 14:38:28 +0530
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
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com
References: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: NzVq2gwKqWzk5kmkPvzbLU4zSiEHzRby
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA3NSBTYWx0ZWRfX5xcNYhLri+xJ
 kgswAYmK5OEWFQYnn1KhS69ZraUxCfc5QxmLIZkWkbj3I7hNIKkU+RV2spzjYMtja9nnnQTF/VW
 74UfwnyDB4ELMhG0FwVsKJrGK74vlJ8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA3NSBTYWx0ZWRfXxiqBHTYX+LPS
 Zo4kqzzBPFXZ2EvnnlUv+c1zGAGkmAABILUog/6Aqd2qtOVfNge8KyIv1ifn+wc6DYvBqQ9PRaR
 e8h7GCbpir5JvQ6nUWLF1Rsn96mY7e+p9h72U1sg1NGYG6G+qtsKxqWJZLRfUXkqEqRxdwBj369
 8VZdm3L89W1jf0bZ9lxJMFxGiThApO4ZCBYUFCgcl8A2jdYmq9yPj9O6EgRNXhW4UlzQ7bSYh+z
 gVM8W7SJi/+ifhS4x8VsRf8r6w0IsbRAti/AZi+rCOpf7Zv7FSgq83Mca8bZjc/l5i76Qo2bOA4
 RgYX02YJiG/3LuX+Ak3xjLfL3/4Z9Ic49bb+qvNdl9f7LJMykoU4U+NMvagC7ixcXPW0xFrufQg
 lepBjgVOmFQuzKGGUVwERJPhVLpsK5D9aYh5bG4zlzt15mB9iVBME/Dp5wPzAddzvDfh32pCqxT
 DdzvzQBefZfulnt65TA==
X-Proofpoint-GUID: NzVq2gwKqWzk5kmkPvzbLU4zSiEHzRby
X-Authority-Analysis: v=2.4 cv=Zd4t8MVA c=1 sm=1 tr=0 ts=6a7ae692 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=dUED-PE9xrSGjoPRRc8A:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608110075



On 8/11/2026 11:13 AM, Aaradhana Sahu wrote:
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
> ---
>   drivers/net/wireless/ath/ath12k/ahb.c       | 166 +++++++++++++++++---
>   drivers/net/wireless/ath/ath12k/ahb.h       |   9 ++
>   drivers/net/wireless/ath/ath12k/wifi7/ahb.c |   3 +
>   3 files changed, 157 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
> index 0fc55c9169e1..3985f4e1c067 100644
> --- a/drivers/net/wireless/ath/ath12k/ahb.c
> +++ b/drivers/net/wireless/ath/ath12k/ahb.c
> @@ -347,35 +347,60 @@ static void ath12k_ahb_stop(struct ath12k_base *ab)
>   	ath12k_ce_cleanup_pipes(ab);
>   }
>   
> +static int ath12k_ahb_get_fw_load_region(struct ath12k_base *ab)
> +{
> +	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
> +	struct ath12k_ahb_rproc_info *rproc_info = ab_ahb->rproc_info;
> +	struct device *dev = ab->dev;
> +	struct resource res;
> +	int ret;
> +
> +	if (rproc_info->mem_region)
> +		return 0;
> +
> +	ret = of_reserved_mem_region_to_resource_byname(dev->of_node, "q6-region", &res);
> +	if (ret)
> +		return ret;
> +
> +	rproc_info->mem_phys = res.start;
> +	rproc_info->mem_size = resource_size(&res);
> +	rproc_info->mem_region = memremap(rproc_info->mem_phys, rproc_info->mem_size,
> +					  MEMREMAP_WC);
> +	if (!rproc_info->mem_region) {
> +		ath12k_err(ab, "unable to map memory region: %pa+%zx\n",
> +			   &res.start, rproc_info->mem_size);
> +		rproc_info->mem_phys = 0;
> +		rproc_info->mem_size = 0;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ath12k_ahb_put_fw_load_region(struct ath12k_ahb_rproc_info *rproc_info)
> +{
> +	memunmap(rproc_info->mem_region);
> +	rproc_info->mem_region = NULL;
> +	rproc_info->mem_phys = 0;
> +	rproc_info->mem_size = 0;
> +}
> +
>   static int ath12k_ahb_power_up(struct ath12k_base *ab)
>   {
>   	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
> +	struct ath12k_ahb_rproc_info *rproc_info = ab_ahb->rproc_info;
>   	char fw_name[ATH12K_USERPD_FW_NAME_LEN];
>   	char fw2_name[ATH12K_USERPD_FW_NAME_LEN];
>   	struct device *dev = ab->dev;
>   	const struct firmware *fw, *fw2;
>   	unsigned long time_left;
> -	phys_addr_t mem_phys;
> -	struct resource res;
> -	void *mem_region;
> -	size_t mem_size;
>   	u32 pasid;
>   	int ret;
>   
> -	ret = of_reserved_mem_region_to_resource_byname(dev->of_node, "q6-region",
> -							&res);
> +	ret = ath12k_ahb_get_fw_load_region(ab);
>   	if (ret)
>   		return ret;
>   
> -	mem_phys = res.start;
> -	mem_size = resource_size(&res);
> -	mem_region = devm_memremap(dev, mem_phys, mem_size, MEMREMAP_WC);
> -	if (IS_ERR(mem_region)) {
> -		ath12k_err(ab, "unable to map memory region: %pa+%zx\n",
> -			   &res.start, mem_size);
> -		return PTR_ERR(mem_region);
> -	}
> -
>   	snprintf(fw_name, sizeof(fw_name), "%s/%s/%s%d%s", ATH12K_FW_DIR,
>   		 ab->hw_params->fw.dir, ATH12K_AHB_FW_PREFIX, ab_ahb->userpd_id,
>   		 ATH12K_AHB_FW_SUFFIX);
> @@ -400,11 +425,13 @@ static int ath12k_ahb_power_up(struct ath12k_base *ab)
>   
>   	/* Load FW image to a reserved memory location */
>   	if (ab_ahb->scm_auth_enabled)
> -		ret = qcom_mdt_load(dev, fw, fw_name, pasid, mem_region,
> -				    mem_phys, mem_size, &mem_phys);
> +		ret = qcom_mdt_load(dev, fw, fw_name, pasid, rproc_info->mem_region,
> +				    rproc_info->mem_phys, rproc_info->mem_size,
> +				    NULL);
>   	else
> -		ret = qcom_mdt_load_no_init(dev, fw, fw_name, mem_region,
> -					    mem_phys, mem_size, &mem_phys);
> +		ret = qcom_mdt_load_no_init(dev, fw, fw_name, rproc_info->mem_region,
> +					    rproc_info->mem_phys, rproc_info->mem_size,
> +					    NULL);
>   	if (ret) {
>   		ath12k_err(ab, "Failed to load MDT segments: %d\n", ret);
>   		goto err_fw;
> @@ -428,8 +455,9 @@ static int ath12k_ahb_power_up(struct ath12k_base *ab)
>   		goto err_fw2;
>   	}
>   
> -	ret = qcom_mdt_load_no_init(dev, fw2, fw2_name, mem_region, mem_phys,
> -				    mem_size, &mem_phys);
> +	ret = qcom_mdt_load_no_init(dev, fw2, fw2_name, rproc_info->mem_region,
> +				    rproc_info->mem_phys, rproc_info->mem_size,
> +				    NULL);
>   	if (ret) {
>   		ath12k_err(ab, "Failed to load MDT segments: %d\n", ret);
>   		goto err_fw2;
> @@ -877,6 +905,7 @@ static struct ath12k_ahb_rproc_info *ath12k_ahb_rproc_info_alloc(struct ath12k_b
>   	rproc_info->rootpd_booted_by_driver = false;
>   	rproc_info->userpd[ab_ahb->userpd_id - 1] = ab_ahb;
>   	rproc_info->num_userpd = 1;
> +	rproc_info->shared_fw_loaded = false;
>   	init_completion(&rproc_info->rootpd_ready);
>   	ab_ahb->rproc_info = rproc_info;
>   
> @@ -961,6 +990,76 @@ static int ath12k_ahb_boot_root_pd(struct ath12k_base *ab)
>   	return 0;
>   }
>   
> +static int ath12k_ahb_load_auth_shared_fw(struct ath12k_base *ab,
> +					  struct ath12k_ahb_rproc_info *rproc_info,
> +					  const char *fw_name, u32 pasid)
> +{
> +	int ret;
> +

nit: move this empty line below after the declaration part.

> +	const struct firmware *fw __free(firmware) = NULL;


With that nit addressed

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
