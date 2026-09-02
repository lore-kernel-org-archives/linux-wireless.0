Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962FE2D59E8
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 07:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335037; cv=none; b=rf8GhDqdmYaf5n35fFUs1Dev5jjTsbBmsah/9sW4jJ1SWzbDH98PcOiec0/D6ry2tGsx+5vz67WInl5xeafxfSksknVknAAfqnkUbyodyjBLI7lo2dKOH2f8puMGIfCX89UhQuMnrZv2ueDunzX/amwtUA9N4m467d0Bpdaakgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335037; c=relaxed/simple;
	bh=terjOL5a3Zs6lbcZY9S6dNfLGRy6Z70StRpT0xFZFZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrJrZgntzn/9tNyZgSx4J5b3S0bCvG9voB25BqbtI9Te1pkX4R8x0y0bTxGKCWTilBCFvbkbrV9lJCFbBwyqZHcX5wcpkPOLE2rxvGsI/kOyFBfMIlrfbnSHKqtMD/juUeD9dEIlv+hLpY20qvPeRIzLR1mvP/2pTjgg+Nhllfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jJEw57KC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=imuqI+5Z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jJEw57KC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="imuqI+5Z"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6826Vkwc3758956
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 07:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	37uu6taAU91xhz7SXKEmRucnGk+Ox84t3g00a5LtrVU=; b=jJEw57KCbL7NKk6t
	jCvGYyfzOKezm68+GEGc4AW+DsV2WrD/J0A/YhisDwcCHJdwcMCYjm4qVZWi+EG7
	ckgpbZIWF6Un29xTpUM+vDnGZ20H/UXPoUXtCoG+snWPXg3eCbipsa5Gd8yeiRCk
	zYCcSMEGBy7W8t255cs9k/AnB2+uWz+6AbEBNiWSsy4dvLNP8Sew4BKQ7jBDhjl4
	VNhGSF+6CeuBO2gEQ7s5A4zlPrx/s+ovWmBNFZBUPw37EB7G67HcTXmAsmKUqbz9
	aB//zAAwmG0hXTMMQPp+AmbPYm6lLtDMuljaXmcA4ffHzAUFgzdTpZfbYU62xyi1
	nQYiag==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge39cjqmw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 07:43:54 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-381250979d5so1007723a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 00:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788335034; x=1788939834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=37uu6taAU91xhz7SXKEmRucnGk+Ox84t3g00a5LtrVU=;
        b=imuqI+5ZhQeLSD2G9t3WBmkmrSbBlDIi5vckAS4Qj+v8gjy9qwPEcqUycH8ReIJwri
         8Q/50pXBUNhUaZ0Q6YIS1o1m5h/ZqcKxrKp7rcxiF9f9GwNGsMxwnYanAM/pJOgQd8+c
         ocZlXJ+AxQjK3KbAbzh86RGKl4ku0oI+Qclg5JGUazzht/EUP2NW37UwFNrJQ9UiBJxS
         DC2Ai7kdNNDsJ3Ix6CDkp/Az0jcjdKkRNYFkJhP9RHmdF0FXQixD0q5KV19dQa8119aK
         kaTHHecgqMDq/P5I46KdDxy1UojDXcc7rTm49p4WbqCtp/g75s4I5KqKC7vqq07YcnBz
         Mipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788335034; x=1788939834;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=37uu6taAU91xhz7SXKEmRucnGk+Ox84t3g00a5LtrVU=;
        b=md6rQdRD81F+5u2VrTKKIJmiF0iKrKvynmktvFAxtb6uTtQHxvsQ2OeZ5VrxcYjHrV
         bvdto0rnJBGpFISTuNyth1DabrWju5ib9+M7WfJ87q5U489RjPvtUb+rWuAj9WawoCZ0
         pZAe4zgyJhHxWI/esx7nySjg72rrtVrgwb1pY3IxiFPb3avdUmsTmCMWQNY9Parq/Zys
         se8XOV8Z0fb55VklA3QPUFb+W8ZaZ70BdW9AwOno/C5gVenHIW9SfadBAvC8RfNX4nhj
         P6+Frs1yVPd107Eg6TWealzrPh6dNduFdZYQ4A/8jccPeMKhbxlP0vbKLdsYtzei5ggm
         1NuA==
X-Forwarded-Encrypted: i=1; AKwUvBx5skkTOjml/WMTaXeKPAcGDtmUlrORS3khslk5lEeWzSR4ph7cm7qpEpZr0kLcaTZItKpT0e3S3zn3kBvyrA==@vger.kernel.org
X-Gm-Message-State: AFuF++koUPE5jPacLtdo9W4Bk2XQZ9D5vsinqMqphFO/qEFNqzxN0ZDu
	OU7ADEauogw8EDL2S6JxVC+chdTQMweyMPX3TOc7VJQSPUVEjmkKiW6YAY6fLJldoT8sbP3eeJb
	+8VDGaSXUx6yRUbzrcU2I7pGiwFIKwSnkBO9WQhfJpzolC6+CiHbSvSl/bV3f0xVJqe7EIA==
X-Gm-Gg: AYBFou2btwjAeDpSxIykuPkwpYGiT3zAKwHMQKu78RrM6txW6wiEI8A6z95yL6Tf3fV
	3z5PISN6o+6lSFPe8W3oU5AWDpGPMspD2dIXlXil+8c3rMpqyf+0DoF0NE4QqOamjqBp8mYZ4/P
	q7mfa2ATGWpPBW8e6ogSnlSZDuUj6hbePdh0yghIhy0enftGJV3I8CuvV/jBLAVPfMKZ8hrgr39
	4COHp21uuzBHBHbG3TRVZ4Q7YyqNV1eDc/8pcp0JOhNv/eMsyVscbl96OJnbwLq+7BPvpbaiNC2
	cZTBfCfh5emCX+rCXEw6qij3jOFtysizXqMTVFQqrU+8cMh+5EYX3QIKY/ex7eAUE/MCb84Ruz/
	FNrf4AnGdzj4M5fvLT15kq+L94RkgR7Ll6g/JRfhy
X-Received: by 2002:a17:90b:4fcb:b0:395:f0e8:9e13 with SMTP id 98e67ed59e1d1-39aedf22274mr4775057a91.7.1788335033628;
        Wed, 02 Sep 2026 00:43:53 -0700 (PDT)
X-Received: by 2002:a17:90b:4fcb:b0:395:f0e8:9e13 with SMTP id 98e67ed59e1d1-39aedf22274mr4774985a91.7.1788335032956;
        Wed, 02 Sep 2026 00:43:52 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1430ea09b6csm3942023c88.4.2026.09.02.00.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 00:43:52 -0700 (PDT)
Message-ID: <001a3142-c2f0-4f9f-9675-1bf1f6f640b1@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 13:13:47 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: fix NULL dereference in hw scan cleanup
 path
To: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: Vignesh C <quic_vignc@quicinc.com>, Mahendran P <quic_mahep@quicinc.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260902010117.3225320-1-acelan.kao@canonical.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260902010117.3225320-1-acelan.kao@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=T968ifKQ c=1 sm=1 tr=0 ts=6a97d3ba cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=DfNHnWVPAAAA:8 a=_5F5FPPE-e8PIXcV8AIA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=rjTVMONInIDnV1a_A2c_:22
X-Proofpoint-ORIG-GUID: -33nYi2WUNSONk6iDspCrcGFD5f22DBb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA2NyBTYWx0ZWRfX6gPASm5Zi4Zn
 sQ3eeaYrQrilwi8UXlPk2TTaovvK4dt2gkVgwPX+plxkKjyVr/0knj172D68TY1G9/Wvm5jy651
 zcCIfwgonzEW1XeeHfAN1NvAECte2EQ=
X-Proofpoint-GUID: -33nYi2WUNSONk6iDspCrcGFD5f22DBb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA2NyBTYWx0ZWRfXz3RjJx+dn9ae
 VI+YgCKfq9TVJwuOG88lcE3v8iiilzWuQ8/Dvl7UgueRlXibOGllStw6y9xqxdp7JOEzPdtOeCk
 Fi2P8lYwrGAp8BrobfMl6IggejlC1ftDa0wqipnt3HuvSvOwoC3eDFx96po9bE2Hsr8jBkbnxh3
 XAkyKMdKXiYG1A/IHYqU7ReGsbNdeCDuntfchMK7E3UmNlevWZ7ScmKcfiBjGSP08ALgrxUGcFY
 eX3rLe7GXhO+VxNUl8lhM3Z6uGHjLnxlDaakPR9cYj52yukS5P9pI0TlRqYQ3E6FdYZ8ohIA1a7
 icyWtPrpL9Ab8vnsBdhO1SEWr4Ym6j2y398A1TmVUCcvAsjshjRnFnRPV4ppf4AubmVHFsD1/Dl
 gn3KtH/1o9ICNTldbr5RRurmYlht+ryMQe4FZ3mT00HkJuNz1yE5pZdw6YynYeIpHDGgJD2tJYX
 INya0LOnjrSWjl4rnIQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_01,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020067

On 9/2/2026 6:31 AM, Chia-Lin Kao (AceLan) wrote:
> ath12k_mac_op_hw_scan() walks ahvif->links_map in its abort path to
> tear down the scan vdevs it may have created. It skips link vifs which
> are no longer present:
> 
> 	arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
> 	if (!arvif)
> 		continue;
> 
> 	ar = arvif->ar;
> 	if (ar->scan.arvif == arvif) {
> 
> but it does not check arvif->ar, which is cleared in several teardown
> paths while the link remains set in links_map. When firmware crashes
> and the reset worker detaches the link vifs from their radio, a scan


Thanks for fixing this. I'm trying to understand the recovery path that 
detaches the link vif while leaving links_map unchanged. Could you share 
more details on that?

> request arriving in that window fails, enters the abort path and
> dereferences a NULL ar:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000001508
>    RIP: 0010:ath12k_mac_op_hw_scan+0x170/0x8a0 [ath12k]
>    Call Trace:
>     drv_hw_scan+0xa0/0x160 [mac80211]
>     __ieee80211_start_scan+0x305/0x7b0 [mac80211]
>     ieee80211_request_scan+0xe/0x20 [mac80211]
>     nl80211_trigger_scan+0x610/0xa20 [cfg80211]
> 
> 0x1508 is the offset of scan.arvif within struct ath12k, reached from
> a NULL base.
> 
> The oops happens in a task holding wiphy and rtnl locks, so it takes
> down the rest of the networking stack with it: subsequent scan, netns
> and NetworkManager operations block indefinitely in D state.
> 
> Check the radio before using it, matching the existing arvif check
> directly above and the arvif->ar check already used elsewhere in this
> file.
> 


One sequence that seems to leave the link vif assigned is:

ath12k_mac_assign_vif_to_vdev() :

assign_chanctx -> ath12k_mac_assign_vif_to_vdev
       -> ath12k_mac_assign_link_vif: links_map |= BIT(0)
       -> ath12k_mac_vdev_create: arvif->ar = ar0, WMI fails as FW 
crashed, returns clearing arvif->ar
       -> returns ar (NULL), but still links_map has BIT(0) and link is 
assigned

At that point, links_map still contains BIT(0), and a subsequent 
ath12k_mac_op_hw_scan() may de-reference link0's arvif->ar.

Is this the sequence you're hitting?
May be error messages from ath12k_mac_assign_vif_to_vdev() help confirm 
that?


> Fixes: feed05f1526e8 ("wifi: ath12k: Split scan request for split band device")
> Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>   drivers/net/wireless/ath/ath12k/mac.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 99bf5cf79d102..64a636f3ae3c6 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -5821,6 +5821,16 @@ int ath12k_mac_op_hw_scan(struct ieee80211_hw *hw,
>   				continue;
>   
>   			ar = arvif->ar;
> +
> +			/* The link vif may have been detached from its radio
> +			 * while this scan request was being processed, for
> +			 * example by a firmware recovery running concurrently.
> +			 * The link is still set in links_map in that case, so
> +			 * the radio has to be checked before it is used.
> +			 */
> +			if (!ar)
> +				continue;
> +
>   			if (ar->scan.arvif == arvif) {
>   				wiphy_work_cancel(hw->wiphy, &ar->scan.vdev_clean_wk);
>   				spin_lock_bh(&ar->data_lock);


if above is the scenario, along with this change, would it make sense to 
call ath12k_mac_unassign_link_vif(arvif) when ath12k_mac_vdev_create() 
fails in ath12k_mac_assign_vif_to_vdev() ?




-- 
Ramesh
