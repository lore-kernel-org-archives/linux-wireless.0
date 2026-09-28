Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732E04E80BF
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609211; cv=none; b=A9J8e2+3Pox6YuGNid0nCVSRfG41nPRSq6X7Gcsa+7E4/UBNQYpGRrwB4PwVqO3kynMRVMY9wfOXg0/v9LTMINbW7iC+FtwT7rd4AVhS4/e5V3Td4eizYub+TJZlC7SjhhBLyU6uXbjtNJ/8lVQB5+xkZ99RK4fB4k7+GX405Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609211; c=relaxed/simple;
	bh=Dqvg11DbnRk2zmgrSPsi4PFkVSfCPoWkfkc4MJ1gLCo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UQRdeDj161Ng1aRy1trDKfwBCZxuXjxYqUVRTSkRL8IqKPsx8PAssdfG2ryqpKmnUZTB5Kb6egrYOUFmEaO5Q5ILY4vwI3xlrU6Xc4ddLNFP5gqK+twBmZGRST0XpG/GQJR48ayKP2CghNpCw4ukzZ+WTX2got8VM4omi07DHcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TZk2SS0k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dEIX/txS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TZk2SS0k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dEIX/txS"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SEduan379019
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 15:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m8I30bmzEkxiQOSTZb9FMgwhTXv2mfHqXd7wNca/new=; b=TZk2SS0kMHDhtF02
	OPKyXa+8okiuK2ku1qWwqBsXl0AdMf8weR0x1G+vghoQU656fkU7lOqVVniW2mLP
	y9yb4kv8vws+RjZsMGrw7XDEzeXfJM+Kmy+vpj2ET96R5m1m7fXRAwyuRkbIR/zG
	7T/9b5GHV8tJJMZOsaqrvkY0+Uu1pIKofpaWpWwVhxeWaB0enRK4f4Dmx1yaUVyF
	z3LkHrbjcQfmOmK/uWSXBull1HOGP9nxEsww8JMAs6padNyFMmkMa6M2RIG6xCOm
	Wm49G6JzrOw5dYkeVbzcKIysm92XuQ4z1B7auX5VbY5C+ZQqZnOHsYdsrIL7mHJQ
	ixkxeA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyqx38uav-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 15:26:49 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-342b66c0b06so3025118eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790609209; x=1791214009; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m8I30bmzEkxiQOSTZb9FMgwhTXv2mfHqXd7wNca/new=;
        b=dEIX/txSxwv4GZSbql+eM3cz8j9Zp51w1zmT9HOaqzOgkci+8IHakER+Zx62h/Vhtx
         Oj9oUxgJxqHzU+eW3UTClyo+wZUHI9jdDuTrDeoEhKzk4fY/gjAbIR1xYGdf8/eIrGc+
         pq5POMOSZUfzcQ+G6MpoVwllDGRtSojItPp5gaqc3iEHAcHi4o6mg8X1eVh7lSNDnEI0
         qLNKSpsImxH6uci/+8olJVF+iBckuwWPtXZ897hhdXgA/a8KVlgxxwLNC03mogWuIooE
         2h0szj1Du3KHGtkpU+zdWpCm+TB3U+L+ih+PN6Himy9ncWtg6q2y9cneSGLbfilXcoBt
         VQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790609209; x=1791214009;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m8I30bmzEkxiQOSTZb9FMgwhTXv2mfHqXd7wNca/new=;
        b=rqI7B6xAG4x4SN3pVfkrOBrdtEyKUT1bQIC8aQcH2ywKB62GPVEYKQJWJkguId4Kj2
         gihxOyZ2rNZCmYHKQ/aPihv2u6nF6zNk7oLuj6wl/+UWMF9YAnX48RwmTcaEuMHo0qzB
         e4uLzB8MrJmzDCU8zKHzA0vLh7tgjd36JI+sm503B7WpzyPGsO4OaQ4eBr2qrX4iE06f
         g8P8wiZozoEupeXKGGgN49wLe9xHRwa6wtytBK3MxBPyCRE413NAU5LtS/Xd0G11WBHJ
         K9zVwq+nt0hH2rsBzSKzpkCXTHUy5zXxk8+bKKPhSUjfym1/h9F6UoaztY5tXyUsnsf4
         pRJg==
X-Gm-Message-State: AFq9FYJWsWQPwlKq7u2ykFe288m53HKCTwXpb1ZAz6NHcPbDvSisEzjS
	bO+IKFg75k+ovsvHLMZThVmsRaZSGazmc76OUO9qVXdWBIEQDnhA4h/daKRB/rwxxfsZ7VJ/DBW
	c5+O4saD0zA6DuJeZaKsezNvrSeT9sKbB8HESHPM6hHL+ShOpaLzgKlP5xg2Irk4Nqd2npA==
X-Gm-Gg: AYBFou3R0eUpSg0jPjPpLKElDBvH2rK6wnX9DP+t0ll1NvJ9kNP0yF7t6mKsG+loqqb
	oQiNpMpF/G/NcDnfXdeHRePk84U2FFSULM/+lKv1gsEyum++ulwmLe3fqRWNhen/5QeYZ+T/GGS
	UpDiuFo2UuI5fpFCiM19UmritqHTqcwI82KaDtbMnPc0978jJCxj2WRgRKLBTy10uNAiiSeAy+G
	ulYzWuRRmJ0Iju+xQe6MRB2qfnc6B/YK6kE6n0+KwfX3Deuo/u0L4QJ7Sw3lXvoz4M7LCLCxoUr
	8kpwV2cGqrWWoVQeX6B1O6uMRDok7BHxP0Vnwftba+uYbSSeY8ZKZ+0YzMPg4vVP32n1pCysMYw
	4BkfXLeS+augBShlBzR5s3WBStWxVrxPEMpVEZreLrAs=
X-Received: by 2002:a05:693c:87c9:20b0:347:a3d9:dfa3 with SMTP id 5a478bee46e88-347a3e9232dmr2971499eec.7.1790609207758;
        Mon, 28 Sep 2026 08:26:47 -0700 (PDT)
X-Received: by 2002:a05:693c:87c9:20b0:347:a3d9:dfa3 with SMTP id 5a478bee46e88-347a3e9232dmr2971437eec.7.1790609206721;
        Mon, 28 Sep 2026 08:26:46 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144173a2asm31407404eec.6.2026.09.28.08.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 08:26:46 -0700 (PDT)
Message-ID: <3cd93e83-6103-457a-8879-bef8521bef9e@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 20:56:41 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: ath12k: order hw group devices by WSI index
To: Benoit Masson <benoitm@perenite.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        stable@vger.kernel.org,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
References: <20260927012314.34857-1-yahoo@perenite.com>
Content-Language: en-US
In-Reply-To: <20260927012314.34857-1-yahoo@perenite.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA2MSBTYWx0ZWRfX4ocy+M2tYbPK
 MLSuz51CcAMGuoKrVq9FQxopDQpSyBDSdAkEdKMMLG/j48ZKYkn7Sw3U6kLcbRADxtWqk75bBsB
 iOur0w/beZjuvTN/8L1U3JVU73O/mZL0PA08ZXUG9omEVatAJZJTYT/N883ioiwFODzST/E8ua7
 1Ul//LQK/z9Fir6n4tjS7um6pRJs8XNd7no6q9A3bacZcz6YDJOneiaBynZupbm5iejIa0HBj4T
 I/1+QnNdsZA61dXCAyf6cyp7KwLZpjDYG7foBk//ikAkf+yM6pazAW6m2VVnLGwho6ITcld/7SA
 /ejJchMCoJoLlwpXztyvoKaU/jBuuASvQ5FxeMPaFtdO0gVxvy5hSsSZfuRaZ+9oIAwe/OnSqid
 A2zyQrf7xByoQ6Wz0hKfEVR88JD4wzXZ0wL7y0c3IE/PCQntVLCvlKGBseELFKIFEhvUH8fbq8A
 +B6RYF4rNR07iM5xEFA==
X-Authority-Analysis: v=2.4 cv=f7jdl+yM c=1 sm=1 tr=0 ts=6aba8739 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=LV5C8B2hAAAA:8 a=VlrtaSc80NQl5BrU7SEA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=uiVh3g-rw18WZz7NjXbe:22
X-Proofpoint-ORIG-GUID: iYKb27W-3cGhyZY1bVVbM26NpHfABLpl
X-Proofpoint-GUID: iYKb27W-3cGhyZY1bVVbM26NpHfABLpl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA2MSBTYWx0ZWRfX85sWR7wa62WU
 72fVyBF1CS0GIW/zB7VL2dXZ88rOKv0JSu16bKCu7xNXBx8lq3Pbq4tKNuM3nXZXwn3rea4+247
 0CEG5lRIA/PAtFpzsopZ7re3GB25Sro=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280061

On 9/27/2026 6:53 AM, Benoit Masson wrote:
> On multi-chip (WSI/MLO) platforms the devices of a hardware group are
> added to ag->ab[] in PCI probe completion order (ab->device_id =
> ag->num_probed++). PCI probe is asynchronous, so the order in which the
> chips complete firmware bring-up is not stable across boots.
> 
> ath12k_mac_allocate() builds the wiphy radio array directly from
> ag->ab[], and takes the wiphy device from the first entry. As a result
> both the wiphy sysfs path and the mapping of radio indices to bands
> change from boot to boot on boards such as the TP-Link Archer BE800,
> which has three single-band QCN9274/QCN9224 radios in one group. A
> persisted hostapd configuration that pins radio0 to a band then attaches
> to a random band.
> 
> Order the devices used to build pdev_map[] by ab->wsi_info.index, which
> is derived deterministically from the device tree WSI ring and the
> qcom,wsi-controller node. ath12k already uses wsi_info.index as the
> canonical per-device index for the firmware link IDs in
> ath12k_host_cap_hw_link_id_init().
> 
> Note that ag->ab[] itself is left untouched: the unassign path indexes it
> by ab->device_id, which is the probe-order id.
> 
> Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
> Cc: stable@vger.kernel.org # 6.14+
> Signed-off-by: Benoit Masson <yahoo@perenite.com>
> ---
>   drivers/net/wireless/ath/ath12k/mac.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 99bf5cf..6505255 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -15444,6 +15444,7 @@ static void ath12k_mac_set_device_defaults(struct ath12k_base *ab)
>   int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>   {
>   	struct ath12k_pdev_map pdev_map[ATH12K_GROUP_MAX_RADIO];
> +	struct ath12k_base *ab_order[ATH12K_MAX_DEVICES] = {};
>   	int mac_id, device_id, total_radio, num_hw;
>   	struct ath12k_base *ab;
>   	struct ath12k_hw *ah;
> @@ -15467,6 +15468,21 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>   	if (WARN_ON(total_radio > ATH12K_GROUP_MAX_RADIO))
>   		return -ENOSPC;
>   
> +	/*
> +	 * Order the devices deterministically by WSI index instead of PCI
> +	 * probe completion order, so that the wiphy and the radio index to
> +	 * band mapping do not change from boot to boot.
> +	 */
> +	for (i = 0; i < ag->num_devices; i++) {
> +		ab = ag->ab[i];
> +		if (!ab)
> +			continue;
> +		if (WARN_ON(ab->wsi_info.index >= ATH12K_MAX_DEVICES))
> +			return -EINVAL;
> +
> +		ab_order[ab->wsi_info.index] = ab;


Maintaining the ab/ar ordering in ah based on the WSI index feels like 
the wrong layer. The WSI index is a property of a device's position in 
the group (ag) based on DT.

Did we consider placing ab into ag->ab[] deterministically based on 
wsi_info.index? Do you foresee any issues with that?

something like below in ath12k_core_hw_group_assign(),

-       ab->device_id = ag->num_probed++;
+       ag->num_probed++;
+       ab->device_id = wsi->index;
         ag->ab[ab->device_id] = ab;

If that works, ath12k_mac_allocate() wouldn't need the new ab_order[] 
array at all. It could simply iterate over ag->ab[i] directly.


> +	}
> +
>   	/* All pdev get combined and register as single wiphy based on
>   	 * hardware group which participate in multi-link operation else
>   	 * each pdev get register separately.
> @@ -15483,12 +15499,12 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>   	mac_id = 0;
>   	for (i = 0; i < num_hw; i++) {
>   		for (j = 0; j < radio_per_hw; j++) {
> -			if (device_id >= ag->num_devices || !ag->ab[device_id]) {
> +			if (device_id >= ag->num_devices || !ab_order[device_id]) {
>   				ret = -ENOSPC;
>   				goto err;
>   			}
>   
> -			ab = ag->ab[device_id];
> +			ab = ab_order[device_id];
>   
>   			/*
>   			 * the assumption is all devices within an ah


-- 
Ramesh
