Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486391;
	b=2pqh9MPz7h8AAWcfqWiSTqatapXP+xSCh1yan+IesGh5zXJIEV+3OSQ6JEJ++KBEdlEb
	 5L6RK2/FrIubhysUGvO5G0+md0seqpQqxK8fgdzMUvIzEZ7eyOHmuDwXdmWdTbRc/NlGM
	 QgELmAEUso/jA2e7RGhM/EhCtQlJwcirnfEc8vmHcAQJbpRy9YVRE4M4+3Id3CwI7obXY
	 fqK9VkZ4Lutdrng45BrSEOAH4054CiVAR0jSVBq4nHjtVyVdgY9QktdEkVssOYezym017
	 okht6iwKAYf5QKX5GjfxaaIBGzCdTN30o0jqPOjap6ikNUEScM8K7BECsvV16th2fNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486391;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=WlvSUhy9NQS9KPGPiYSnQtbj1YWbn4EqiF+2amxYei8=;
	b=EIgSlrPWy13ZvzoGfjRCL92HToSavkWW3fVXnwIRaiPXsOb+7Ci5QI2RTMGM2PCVm7DJ
	 rRwxvi3Iz+M9bJCFPEcdZQJENf0u1ceP+h9wyGOpLzNTMbKEYnxU4sQMRveaAmcEQCTrO
	 TnAzepMnB3Lk1edBqSwaGvrznK9aQVz1XAebD/lRQI2gTRnRoVVDLQcZy1U7cHEKdVRPP
	 p7evI5/VE4EoeMRvpTtFFFJXd6zGcYALF6ErmrNpdJzFn1xoLxm4cOUbZQFp28dU054ur
	 tlryFeIm6jasxtXpnzf9hXSr4b8U8iaYUGgJrLeR6mx8sOn0K/GVMPVXTLMRidJzqZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MKuSlqOr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=P922Vvum;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5894E606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5894E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MKuSlqOr;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=P922Vvum
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K8QrRq1254226
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:53:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=WlvSUhy9NQS9KPGPiYSnQtbj
	1YWbn4EqiF+2amxYei8=; b=MKuSlqOr1MM+K2c3lV9aBkreZDdS+7X4gg6fZ7xQ
	A3gWp1J04TcSKHo+Cqivfr9CyaNl/XGsYxZtmGs74g/OSbe2DmeTqV6mDHWMrV1h
	6rHKhKDpWzlJ5VTfc862Lf72+YY/0DRjkyx7KsgCUPOu3gyNk1UBxe9dX53rHZRS
	z9YYngdReEEG0BInhvyP0dFVSToeL056kSdQ7EGcd2gb3jP2hkDqcvnudKi+LJ0i
	OyC/Sd8oXiNVqohNxM86OyNWZ9mhzbyQN8+U192dhoXlAoByYewQ7FQ7NQIPNTge
	UtrOthe5bkp+PLTtilB1lsM7q7qr1Hd5qkg+3Dp9mYVuFg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5n9ppy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:53:09 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-351788121cfso9262531eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 01:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792486389; x=1793091189; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WlvSUhy9NQS9KPGPiYSnQtbj1YWbn4EqiF+2amxYei8=;
        b=P922VvumJwicJMfFuVDWXVRBuPd1awZU1nNxkRiirWl/nVT6EFkYhq14hWBX4E8sUv
         uUyoDSH0wCnPjcE/bD2tEFcz/QmLO/H+LNo3tQALcGzMVjD2uVF+3y5vVH2dP2gzqHdH
         jmi9tJ+4Vk0ojixQccva2x+fytCcKGYfCwLAfri9uOw0UaZfRfEC4K1N23jZ8LbGiKiD
         nDndCgfMV54gbdII3K3Yad4dJwKgydFZsldmOOQfLh6Yy99MFtAgSQct4/6D3yq7IL3Z
         7tPV12GxOpTzGTqK3T3xYlURj0TjNNZh8stHoMOw/UVfvlluHawt0+Vr24Nwm5kinu+9
         bt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792486389; x=1793091189;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlvSUhy9NQS9KPGPiYSnQtbj1YWbn4EqiF+2amxYei8=;
        b=gCfH+QwjmDkl7n1jQxCSaff0pUvwI9uJPXUyqqYdzltMXolaAJkJ+9HXoNgkUpxNo7
         a5PR5XKSxuGL73CxgFjMI915gV25kzE2tbORst3YQUr6aIky6r3ASsWajkL/c1trs5rS
         bdQKm9+A8aDuAUZ6X6L6YigNoJjp6rrx6vkDEhLIW6HSt7wj1gbbaIwP/5viafvWE+mF
         eO4p95dOfm8QG/aOAlSfzuRbzGCyQ6YRs8bQYaGmwD9slxQKIhB27UlR23LOfeTZ1LvW
         upLgJBjPMM8M/ywzwoN7++3B1G5fls6dE2ltpP6+neq1T9JxLdIRmlEDk7MLBV/aLcCh
         Z51g==
X-Forwarded-Encrypted: i=1; AKwUvBx9KliDJitWNnu65aNUpu9+ZrMe3LOPls9wYwN6VfBKH1ptky/vRn7F29zB0hHGEy0nLehsJSnok7T1QROObg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJhOpZnb/06Hkdo5ii0aaLl61bkECWcu0rmFcIlRwvvb3KahfpZ
	DZo1kMrbm0UkUar1/CK8uO50MJe5j+2EdWw8DkUJ2aCAW8B0uLs7DMftMLTKEp9Yzdvur7ryIeB
	B9MzePCU9lgK00GSt9ziVj3cr8hTsbPeIK6BL3SMaglPd/4BVigB3oG9p6mme3DSwM42VXw==
X-Gm-Gg: AYBFou3Ti2ooFe1RDZ/xVmjaRsqXSgBGiQpnIb0+xSiMNIIwMoVBuctXBxzzCfC711t
	PIrMQGeyK2m8cID38RSwrUapnR6ZeHFwVpvpqwN6l0lzV4U3BpRj40X0qInCgYzxeXCczWh4ENP
	Zp8PPDE6x8P9BfvSkqvAnBXQdnlz6JqBu5IwZz3ofNYSGshCplhEtnpf1WMtPKZrDBdTaBmeac9
	WmAXvU0E85ClHrphKsebwpSOJtQSIyl+CM6yVM+bvdFgvb8JcVMq8+/PkkSP5xTW+A1NksSq/Rj
	a/aN4DoV6/90ZXqEO7+EQx51CMgkTTmg19XQq9gmI+AnTjNvzNERCTxnk3VSXv+8P4U9L8ghu8s
	yOLJZ229uRB3OfPK/b/Fcm5CMQNn0xqFkDMs9sdU/NQ==
X-Received: by 2002:a05:693c:6081:b0:35c:4800:4da with SMTP id 5a478bee46e88-361a2c36c2bmr15915706eec.41.1792486388779;
        Tue, 20 Oct 2026 01:53:08 -0700 (PDT)
X-Received: by 2002:a05:693c:6081:b0:35c:4800:4da with SMTP id 5a478bee46e88-361a2c36c2bmr15915675eec.41.1792486388216;
        Tue, 20 Oct 2026 01:53:08 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36082f7f6e0sm44011807eec.27.2026.10.20.01.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 01:53:07 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:53:03 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: _XH41H_c6vNhHpqXLxe-aoroONufWGhk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAzNSBTYWx0ZWRfX9miaOhnV7D2e
 M2gRL6HzEQyuk8ANnYODFlySvN/5CD5L0eqRYEgXJa2BqvNmkNQp/uN19e1S6/isYGU8iyh7rai
 ev3Qtr78ET1MXT4zEXxc2XBDOmB2QOisDmovmobj8JdN6jM7HDGayyRLsLBN1rYQ6O9d/e0lqd4
 /9/cxPSIT/hgneuGEVA2kGRHS5fVpuI0YFWYWklTcDJyboQEP7JVz3JvqDBrdKi+uBQcojtRGzx
 BlGLSX4G97rYLKQ/PyDX6GfhMryiyMHCFsy6IFWRL0mNgI+njW/Uj/q/Ym4bceToYoKh0133rYS
 Q2Bgr2zQP3QugUwe+5QJFeM3qvYXi2e1Wkbw9H7UtqTup1OhsJ0QntJg24WKr0fQLWvuxg6+cko
 q33JEwarY2NzXLxOQnf5iuJp2Ht90odxwPXHbcpeq8JEBwVgIeK+B2x+FpP5kNU9Oj61QobsaPk
 u04vTuSs3R7xZJsOGYw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAzNSBTYWx0ZWRfXwEHS8NYtQrOF
 k+i8CA9qu/9cmlSlh4ZF34Fd06s7+uF4a8WCl6kesiBhPJWHJHTMgk6KtSzcHTELHM3QJqDcKfG
 kN5AvxnbnhWvhAc9/wYBj+8qdP6b/ro=
X-Authority-Analysis: v=2.4 cv=VI9IDNPX c=1 sm=1 tr=0 ts=6ad72bf5 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=2JoaeQ_52KTGIJA8Ts4A:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: _XH41H_c6vNhHpqXLxe-aoroONufWGhk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200035

+ linux-arm-msm

On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
> For WCN7850, MAC buffer ring size is updated to 2048 in
> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
> to increase peak throughput.
> 
> But during the RX process, a phenomenon can still be observed where
> the throughput drops by about 30% from its peak value and then recovers,
> and this behavior repeats during RX.
> 
> After increasing MAC buffer ring size to 4096, the data rate drop has
> gone.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> 
> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>

FYI, in case someone else runs into this: with this change (merged in
v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
working with the older firmware that Debian trixie still ships
(firmware-atheros 20250410-2):

  WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Probe and firmware download succeed, but every WMI command times out
once the interface is brought up:

  ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
  ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
  ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
  ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11

Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
reverting it on v7.3 brings WiFi back with the old firmware.

Unmodified v7.3 works fine after updating to the current linux-firmware
image:

  WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

On Debian trixie that one is available from trixie-backports
(firmware-atheros 20260916-1~bpo13+1).

So nothing needs fixing on the driver side. I'm just leaving this here
so that anyone who sees "wmi command ... timeout" on WCN7850 after a
kernel upgrade knows to update the firmware first.

Thanks,
Shawn

> ---
>  drivers/net/wireless/ath/ath12k/dp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
> index f8cfc7bb29dd..6596089d4168 100644
> --- a/drivers/net/wireless/ath/ath12k/dp.h
> +++ b/drivers/net/wireless/ath/ath12k/dp.h
> @@ -205,7 +205,7 @@ struct ath12k_pdev_dp {
>  #define DP_REO_CMD_RING_SIZE		256
>  #define DP_REO_STATUS_RING_SIZE		2048
>  #define DP_RXDMA_BUF_RING_SIZE		4096
> -#define DP_RX_MAC_BUF_RING_SIZE		2048
> +#define DP_RX_MAC_BUF_RING_SIZE		4096
>  #define DP_RXDMA_REFILL_RING_SIZE	2048
>  #define DP_RXDMA_ERR_DST_RING_SIZE	1024
>  #define DP_RXDMA_MON_STATUS_RING_SIZE	1024
> -- 
> base-commit: ff49eba595df500e4ddccc593088c8a4ab5f2c27
