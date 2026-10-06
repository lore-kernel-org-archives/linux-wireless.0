Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55A2931C0
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791288192; cv=none; b=VrIpo9NRZaMAso0Kvp6d2I01Z90a6yTVQRB74i8h+AzF3GELqOyx7OQGwhWNU14Mo3nSQ1ICLlf+rexlmwvEiLs00sAIUN+b7nRWEShLdD2kaYenj05pURgzSUPqlazuz6n2sf8YCc4yyI17WuAhUnYDQ/0pMHq+YGIjSevazDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791288192; c=relaxed/simple;
	bh=UzTy1j4JhIx+S92+skllPIMGKGMx0OUV/ToA986MjRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ebsKVtSmmOE/Il9hx3NtdiBPiQQnuwAPUGwNZfT7Ocnm97KNqE88R2lUTqTjGZnFHggWZ+pb3QnioyeBERQrdMo4mXWc7fJ4Q77ig3z30+titC6yFF9u8qEN7Xh7gAxRTCDMPXqIOFTKFigzvp3+uGq94ADfS0nxssCAvgfC1X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VC1ibpAC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hSxIHX3u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VC1ibpAC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hSxIHX3u"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696BPIQm4054379
	for <linux-wireless@vger.kernel.org>; Tue, 6 Oct 2026 12:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LnWIFVH7MtC1BufK84r37hUKPcu2nCWBjQY0FtW6tXY=; b=VC1ibpACVcIULulG
	7gd6TeT5B4hrarAk0zbbEFTrllDvaYlQ7nWDJWCRpY2rix8BJQS6NmtB3BqenqVh
	FA1jJxl5RqOqmMu18zULY7Z/pbaoal+plAF05V26akjy1ASt0jb042m+YUJ1J5kZ
	dwPf9AC4cLgAsbRcfW6x3RDlb1jme30A/H1xnk1/rFXbG5ytoT5dwlC5PBxHnELt
	/+WRf+tIlwePAQx+AJD0H1ycmR5OmY2YKo03RUhJj67rn2c57kxj1gp7jqxTqq4F
	NTc6eZ67mLWS9+v08BGnA8NEwJjEQfmuXpwF3hyB6u4ih/oWoE+muPDcKc4xEh0N
	7wAXfw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4vmrrwky-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 12:03:09 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3510d0baf63so5606916eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 05:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791288189; x=1791892989; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LnWIFVH7MtC1BufK84r37hUKPcu2nCWBjQY0FtW6tXY=;
        b=hSxIHX3u9CpQpMkd5H2+CQN+9oaqLEI/yPFVlZAhMiUtUSTOEkrWVZszOnt0l5NTm1
         5xIzLiRosTw9yL8sQzCsbo/i+0QoXPm6CsQ7TSyj0ttllt6Ue5nAE+WcXPg+VNJZfTDF
         LVSbvT5enWDYsnC+a1f71gmm6JzVkyT2IhkRa5wCNk/EUoM+hQN2rSuzS/xCCdMAR0ms
         Iyw7vaHU2fIsZW7PqRIp4OU05IMPay9AUfiKVnRcAGaUR6tUWNkK8CAq1rtIipqWbPhY
         3/Y4sVFmrCtfaP7XMPk2cat56WGOBkU+oA9iBBerAEgCoLC5rIhOVZbm9VSrBisaZOVA
         R2bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791288189; x=1791892989;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LnWIFVH7MtC1BufK84r37hUKPcu2nCWBjQY0FtW6tXY=;
        b=tHSB0Wwd6cAZf5HkSD8776BWZlS5kJi+m3hEIxedK2GR43kCrTRy0RZP5MO3R5eaeE
         c7p3e8//CDjQ7A71mWWq+mVFhqVxQOY9Y6VHnvhPHebYMKVtdudupcFTptrBy4AIK3P7
         SiSRpiSJ/4h4LLRs4EOPIQcOtbj9tU1RLgyhQz0zfte28OfcCuSsSmLE8xdnTMg5W7rP
         0YzN4mXe+slDbQPNKnC+Fc0xbhoZlZylPqExDZ+JJRSpWsMXlgYKrfYggoXwhN+dhyZe
         A6BgyVVCJRm31gOGN72cW/aFCU6lZct0Upm5xwo6NX86tKYlqJJsC/5OwLGuife/1n4e
         c1Mg==
X-Gm-Message-State: AFq9FYLhvuNU7Gq0HnNkgponHw82Gb1YHJYJ2qq0MtYdmeFe2GQQHuQm
	kaLp3rhWKjfA8MzLPQGokb/Nz2vo+596NMeygcHFzk4G3MtR/LB8U9IdT7nvmqm8o03VIALDu44
	5h5xE6K2XiBSLm2N6N35+gFsl24CoNZMaebkDzVbdOsENhAg4J7NxWu3dDvPygZ2+b4fT7w==
X-Gm-Gg: AYBFou1g3F7furP66FaH4L9Zr0ezOEvfmBInMxhJa8SdCJVd/w7C8mfp2/8OVKLAvkY
	dwVOi9T3SRv7FRQ2cK2CZjU6YVm+UvSn0i4VrD0jKqpiWYEHQ9Pf6v4FPOfKb1b+47GJN5aWRRv
	8lhtcgBYEjCOOxTqS8Y5VDDFo8WiiuECufURpT7iY8JWvjhrrhOKBzLORUe6YTdGVu5pRgU75Ig
	MfSvUP3MEJ/3IUqdDJtHsqa0JViPww4VwoG7WJUh0267vQ97C42/BvQcT3TKsJxP4rAHyDF5xkf
	HePk+fJlk69P+EBIeBNlvBFqxNri/gEr86LW6Ra9LN4R4Bhx3rNYMtHJpe1emDr3vC4YYOKCTfs
	6lu9MuwafqCTPoCI3Jn7s91W94eSNBQt1CUcdztwU+qg=
X-Received: by 2002:a05:7300:55a2:b0:34c:fb30:3e30 with SMTP id 5a478bee46e88-3514df98487mr1473215eec.7.1791288188870;
        Tue, 06 Oct 2026 05:03:08 -0700 (PDT)
X-Received: by 2002:a05:7300:55a2:b0:34c:fb30:3e30 with SMTP id 5a478bee46e88-3514df98487mr1471398eec.7.1791288152612;
        Tue, 06 Oct 2026 05:02:32 -0700 (PDT)
Received: from [192.168.11.105] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35146a2add7sm7298163eec.13.2026.10.06.05.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 05:02:32 -0700 (PDT)
Message-ID: <c3e204b2-47c2-4368-adf4-4f3f9d30e790@oss.qualcomm.com>
Date: Tue, 6 Oct 2026 17:32:28 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] Revert "wifi: ath12k: add panic handler"
To: Yingying Tang <yingying.tang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=XZ4cX455 c=1 sm=1 tr=0 ts=6ac4e37d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=nb6wtAQdZFIURrQIQuUA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: Z23cu2nn3pDoMqv28A4GuyyTAK4UObKY
X-Proofpoint-ORIG-GUID: Z23cu2nn3pDoMqv28A4GuyyTAK4UObKY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA0NyBTYWx0ZWRfXwY/DMAufT+i5
 L131MQtUXYk7Xc71RCOhpsq4xrIb0jiOCrXM5D1+neAOlRBw6O23cd5Xwin6zAqnJZ97MWw8zxq
 od2AEXsGpMVOP0/W4zfxDlEv4HzNeHbmrCgtBBTtyGUE/WbxUD6TOQDsCulvBxgh2nx1hxVxZDC
 EDdeauF1IlU3avveEcw14zrsuJJrYlOa2sWYtszYq2X67N3sdoW95FiJgEygTkup84LELvYdafo
 Ls2pMxn6WRmALa+B93RfZydEvqYvyBnNU8bR6l5ezxGeKAqf5c49ahRV2KBzWWPb6B35lccQ3kY
 Y0Ak9P5ADA+UFTbdqqtbnzmXxjchpAenZ1RQT1U/B1W33+SgFsJYNLSvXvsrkzmjmJ9lJk5IFiP
 1jLsvcrvM+JFspgv2SdnPlXjyleotR9pqQq9qva33/uXt0rmxSf/vjQohwmBSkUg6ME06pJ9MQS
 k+OAQ0aG6ry8aS+MYsQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA0NyBTYWx0ZWRfX7Gvx6fHPeI5R
 Un1q/+tC9kw8XkSfTeb8W64rqqBPWe48Jl4ohO2FOdyEXVVeOv9Xn1+IRRVgzjT67wcdX1ZbAVk
 E8xEcmTAefwWNOxFpeFXjay5hS59SXI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_03,2026-10-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060047

On 6/12/2026 8:53 AM, Yingying Tang wrote:
> This reverts commit 809055628bce824b7fe18331abb65e44d02b0ecf.
> 
> Call trace:
> rcu_note_context_switch+0x4c4/0x508 (P)
> __schedule+0xbc/0x1204
> schedule+0x34/0x110
> schedule_timeout+0x84/0x11c
> __mhi_device_get_sync+0x164/0x228 [mhi]
> mhi_device_get_sync+0x1c/0x3c [mhi]
> ath12k_wifi7_pci_bus_wake_up+0x20/0x2c [ath12k_wifi7]
> ath12k_pci_read32+0x58/0x350 [ath12k]
> ath12k_pci_clear_dbg_registers+0x28/0xb8 [ath12k]
> ath12k_pci_panic_handler+0x20/0x44 [ath12k] ath12k_core_panic_handler+0x28/0x3c [ath12k]
> notifier_call_chain+0x78/0x1c0
> atomic_notifier_call_chain+0x3c/0x5c
> 
> ath12k_core_panic_handler() is invoked via atomic_notifier_call_chain(),
> which runs inside an RCU read-side critical section. The current code calls
> ath12k_pci_sw_reset() synchronously from this context, which eventually
> reaches mhi_device_get_sync() and schedule_timeout(), triggering a voluntary
> context switch within RCU.
> 
> Revert change "wifi: ath12k: add panic handler" to avoid this issue.
> 
> Tested-on: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/core.c | 33 +-------------------------
>   drivers/net/wireless/ath/ath12k/core.h |  3 ---
>   drivers/net/wireless/ath/ath12k/hif.h  |  9 -------
>   drivers/net/wireless/ath/ath12k/pci.c  |  8 -------
>   4 files changed, 1 insertion(+), 52 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index 1a9866061f82..6705a8a73de1 100644
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -1793,29 +1793,6 @@ int ath12k_core_pre_init(struct ath12k_base *ab)
>   	return 0;
>   }
>   
> -static int ath12k_core_panic_handler(struct notifier_block *nb,
> -				     unsigned long action, void *data)
> -{
> -	struct ath12k_base *ab = container_of(nb, struct ath12k_base,
> -					      panic_nb);
> -
> -	return ath12k_hif_panic_handler(ab);
> -}
> -
> -static int ath12k_core_panic_notifier_register(struct ath12k_base *ab)
> -{
> -	ab->panic_nb.notifier_call = ath12k_core_panic_handler;
> -
> -	return atomic_notifier_chain_register(&panic_notifier_list,
> -					      &ab->panic_nb);
> -}
> -
> -static void ath12k_core_panic_notifier_unregister(struct ath12k_base *ab)
> -{
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &ab->panic_nb);
> -}
> -
>   static inline
>   bool ath12k_core_hw_group_create_ready(struct ath12k_hw_group *ag)
>   {
> @@ -2212,18 +2189,13 @@ int ath12k_core_init(struct ath12k_base *ab)
>   	struct ath12k_hw_group *ag;
>   	int ret;
>   
> -	ret = ath12k_core_panic_notifier_register(ab);
> -	if (ret)
> -		ath12k_warn(ab, "failed to register panic handler: %d\n", ret);
> -
>   	mutex_lock(&ath12k_hw_group_mutex);
>   
>   	ag = ath12k_core_hw_group_assign(ab);
>   	if (!ag) {
>   		mutex_unlock(&ath12k_hw_group_mutex);
>   		ath12k_warn(ab, "unable to get hw group\n");
> -		ret = -ENODEV;
> -		goto err_unregister_notifier;
> +		return -ENODEV;
>   	}
>   
>   	mutex_unlock(&ath12k_hw_group_mutex);
> @@ -2248,8 +2220,6 @@ int ath12k_core_init(struct ath12k_base *ab)
>   
>   err_unassign_hw_group:
>   	ath12k_core_hw_group_unassign(ab);
> -err_unregister_notifier:
> -	ath12k_core_panic_notifier_unregister(ab);
>   
>   	return ret;
>   }
> @@ -2258,7 +2228,6 @@ void ath12k_core_deinit(struct ath12k_base *ab)
>   {
>   	ath12k_core_hw_group_destroy(ab->ag);
>   	ath12k_core_hw_group_unassign(ab);
> -	ath12k_core_panic_notifier_unregister(ab);
>   }
>   
>   void ath12k_core_free(struct ath12k_base *ab)
> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
> index 4edc8f4e0cb5..a81cb3032145 100644
> --- a/drivers/net/wireless/ath/ath12k/core.h
> +++ b/drivers/net/wireless/ath/ath12k/core.h
> @@ -15,7 +15,6 @@
>   #include <linux/ctype.h>
>   #include <linux/firmware.h>
>   #include <linux/of_reserved_mem.h>
> -#include <linux/panic_notifier.h>
>   #include <linux/average.h>
>   #include <linux/of.h>
>   #include <linux/rhashtable.h>
> @@ -1121,8 +1120,6 @@ struct ath12k_base {
>   
>   #endif /* CONFIG_ACPI */
>   
> -	struct notifier_block panic_nb;
> -
>   	struct ath12k_hw_group *ag;
>   	struct ath12k_wsi_info wsi_info;
>   	enum ath12k_firmware_mode fw_mode;
> diff --git a/drivers/net/wireless/ath/ath12k/hif.h b/drivers/net/wireless/ath/ath12k/hif.h
> index e8840fab6061..42bb00c13ef3 100644
> --- a/drivers/net/wireless/ath/ath12k/hif.h
> +++ b/drivers/net/wireless/ath/ath12k/hif.h
> @@ -30,7 +30,6 @@ struct ath12k_hif_ops {
>   	void (*ce_irq_enable)(struct ath12k_base *ab);
>   	void (*ce_irq_disable)(struct ath12k_base *ab);
>   	void (*get_ce_msi_idx)(struct ath12k_base *ab, u32 ce_id, u32 *msi_idx);
> -	int (*panic_handler)(struct ath12k_base *ab);
>   	void (*coredump_download)(struct ath12k_base *ab);
>   };
>   
> @@ -149,14 +148,6 @@ static inline void ath12k_hif_power_down(struct ath12k_base *ab, bool is_suspend
>   	ab->hif.ops->power_down(ab, is_suspend);
>   }
>   
> -static inline int ath12k_hif_panic_handler(struct ath12k_base *ab)
> -{
> -	if (!ab->hif.ops->panic_handler)
> -		return NOTIFY_DONE;
> -
> -	return ab->hif.ops->panic_handler(ab);
> -}
> -
>   static inline void ath12k_hif_coredump_download(struct ath12k_base *ab)
>   {
>   	if (ab->hif.ops->coredump_download)
> diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
> index 375277ca2b89..65a780e74d01 100644
> --- a/drivers/net/wireless/ath/ath12k/pci.c
> +++ b/drivers/net/wireless/ath/ath12k/pci.c
> @@ -1469,13 +1469,6 @@ void ath12k_pci_power_down(struct ath12k_base *ab, bool is_suspend)
>   	ath12k_pci_sw_reset(ab_pci->ab, false);
>   }
>   
> -static int ath12k_pci_panic_handler(struct ath12k_base *ab)
> -{
> -	ath12k_pci_sw_reset(ab, false);
> -
> -	return NOTIFY_OK;
> -}
> -
>   static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
>   	.start = ath12k_pci_start,
>   	.stop = ath12k_pci_stop,
> @@ -1493,7 +1486,6 @@ static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
>   	.ce_irq_enable = ath12k_pci_hif_ce_irq_enable,
>   	.ce_irq_disable = ath12k_pci_hif_ce_irq_disable,
>   	.get_ce_msi_idx = ath12k_pci_get_ce_msi_idx,
> -	.panic_handler = ath12k_pci_panic_handler,
>   #ifdef CONFIG_ATH12K_COREDUMP
>   	.coredump_download = ath12k_pci_coredump_download,
>   #endif


the commit in pending looks good

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
