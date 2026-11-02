Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793621652;
	b=E4TKySzMpdN6fU/i4VauBEnafCrDVWHyJNODoFRR0vCZqo9mgSYnSrFWzoCds8dAZ2Ms
	 YSYbaoCTNGtDyOw15tym8iWUsgD81i0HCvodTGDR597LPrE3VeuIasmXGPbuB+i7xOVTf
	 DoHOxJWbSQ7b+fSCs6GMG76sSH6mEGi1yb0MbF/cC6U/bbu0+/f5ONz2896XkW18j/XqE
	 XIX1PkZPH10bYwJXRnp6PLdVnyit5MBJ0u2xc+ZtFOZ8Pyj4ftAFm6wt4Bo3ftU+MdhiE
	 OHj/tEQtpyvYF5GZEcvkNFaGZd0B4znJkuwMe7iNxSmX2TWGDERZOa0ld9IVj6xfoPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621652;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=4mgNax65RQ1A5TymodSxjwmvCQM0HUk79b2XvQLf43Y=;
	b=FNsTmWG3SBJV+xs5ItRdyXAKXlSCiC50rzFU15XVYj2wjkOGgqff/Lx2uyTZhZ+Vp/zk
	 kZxJgTbSnafppWM+Yku/VeR+kT0Z+LrxeY4rMI3r51RECGIAQiBZWWpcU8QuS6VUpiosz
	 etxcWDbYvN5wYz2NWh/R6CYELz9W138GxoWyzjMtXpoBd2WUZwQHbPoUncwJyV1x9kwik
	 gTa/UXGaC0/lwCK5begVKqwohETs9H+jLqzmkFaQLHy0R4Pj3efMrWRfbIWSyzrRzd3Jz
	 foHzBFAUNFi/dShprjmjimp2ryTymwIr2lfAu/d5IQSo5H/VjZV7InksX8FA99/iT8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AuL85fN7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VSZCYPFz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E13D606A32C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E13D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AuL85fN7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VSZCYPFz
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A29AJUA260836
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 12:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4mgNax65RQ1A5TymodSxjwmvCQM0HUk79b2XvQLf43Y=; b=AuL85fN7LCS4BdlZ
	bNwaPpw3VJWzjsI7E2FfuzsmKmcdWbWF0LT1GP+M5e/z3pw6Gp+W/S8ASjymPQXa
	grIMglL+rdT/FYgmOWDNCYXds/zBQohJvGzE9eRdyo5tumQttuyKbmRCPQNzMt86
	W0l+i84Bfon6Mc9jC72zEsqOBTZ73EyloEEF1qMMxyZUI71Ywu7jHsk9QX7IwQKV
	HHrD3yZmeCiJoxDnJJ/gOmPtlRfDhqhcvQQcsQ3tw4qgrCFuLcqYQIG/c0pZp4VR
	WNDkqtRDkM4Ilq5EPVl3JyhaPdunf7qsEGdnftYeY5rxBmEqoKs5W3nAWpwDWEOF
	3TSiJg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpqmvrq3d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 12:14:10 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f20addba1so530952985a.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:14:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793621649; cv=none;
        d=google.com; s=arc-20260327;
        b=ZsRg2wEnbWv66jq4AjT+GI3iKYVcgzpDb6+zopx4lX/ubTX5C0oxjhnWQs6gOBbVON
         QSIySscYbsG/HszadBbpPVs03fP9NIwSlA8pOS/qxfF4K38B0p9c4QsQEQqyvLSVc2E2
         f6ZBR6S0PCdQsWaS3m4rs/Y/ynVViG9VTisn22+0lh+esfU9Hgl3ZEQCLvrHklxw8IXc
         zSw1z2BN9HFsXiqPKdQRhZBs/k4BQ821r3t0diK7jnoVRI9p1wLKXNc/XK9MwhzCIaO+
         dgP2LVrKFY8Fk6zMNAX5sLoxkEo8CP5ykqqB/Eo6OuksRFKy1a9BsV8ZzfXgWzwnbqmh
         WQbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4mgNax65RQ1A5TymodSxjwmvCQM0HUk79b2XvQLf43Y=;
        fh=g2wJ+szQpy6gBgmHkHWiSI8F8XdrIEPzcbm+WNWgkrI=;
        b=O1LNaLtKS/v5WU32ObzR/efCvTtu6lIO7FCjdx8Y+7iGGgayqWmF0OSjP63GYdszLL
         U2H8emD2Ru1mbsb5fp0cpF2fX8/iCPZO/WEHsDZsFIxEk+51VToF7aheSO3kVQ1PshOK
         ANml74CeFrdK78QxaQGLzGbcdqW72Rd1JtyJYnMo36YMEG4vuB06c/kgDuxYCHwJat25
         kPdGhPhCbzDvbHwDZbsbu3Qs+uaQvsZUHozALyMoxvcllWTR4rh4AKDabhSg/XMr+EGw
         wxEM3cCSiLxaQILgc8ZCApJV3sASm+a5LzTr29lOQk8SC3tV/QKQUOzpOtef4wvDRcKP
         MuDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793621649; x=1794226449; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4mgNax65RQ1A5TymodSxjwmvCQM0HUk79b2XvQLf43Y=;
        b=VSZCYPFzWGbimrnjRT0u+pzeYVIcv6WobNkBPSm49nkN4mGeVNjWCPqs3uMCAN2TXO
         40A5q7fqnbgSPIBPsNf2kvoreamJHMkmOS7oDzHmrKrkW1inblVoMb2bDdS9+66Ot97n
         8aGi7H91YRHkVC/XT6vOWJ06VFmDm+ilzO0euaUOjOsRTZZ4qnYhndWio1MgRjB00sFT
         4rZknMl8TiPrcaSNcFtp158PgQmXHrKXbECSdO1uwcdxXuOCwgz46QWEz0mAYcQran1S
         71a0ZVS/IQndWcpS6t06iyYySJ5HQP7l1RRSg3dok0W7Q7Mv+ODDB4SvYwUMuAjq9ppU
         eRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621649; x=1794226449;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4mgNax65RQ1A5TymodSxjwmvCQM0HUk79b2XvQLf43Y=;
        b=F/jEpBi1IOiEMnfwyodk+V6nllJFdDYorUHHXV2hfOQ8I0oW0pSmJZ3jB4Xi/qO9hw
         TdJWnbQd/wSZdHs2zDd+7gsI3/Hn+zSl3wzOI0ppY05IpJlfHMgq0diEiIDzvD+BbcBf
         MkbYrifiVjC0+nIb8cvvYE5X5Ev1UFnSOchpnOKnsjBQncKgiiRKf6oN8jZCeJYWR7v9
         0jWa/nsvBsllhWyYMgSm3AGTqrXmZhvjmOukvOciC6NJ07UzzU92P4EM9hTroUbDObX1
         qmS8XYL/dX7o+jpM//GMPuHg76+PlvffkLRtRl40oBGQSBSKs79pJD5awSUW3bQWqIzS
         x3vg==
X-Forwarded-Encrypted: i=1; AKwUvBxaK0plqng5rNmh5AJMkz/PVls2WF5d5iUZreVV9LXGr3j1czBfuKXefxwEhBSb26f9/X7aqoLpvzvSfb0P3Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKGrzJTV3JEyKLkWmcCuTkChsOhtiKW7703D6amMQp76PYPnpqK
	G0hFeaqSFOENdH8NZ25iHx0fp1jFoVsiq/LqwhGJBNATaTgBwls65ncdlKhofNe9wVTIHPGf2AK
	v3J7hisWTZeVMjwvldCs8j7dgg5eRk9mQsGmNs4wsAaaeHNXgLNMWjJCd653M4tY3bxCYpuCfE6
	Tdvm0SSZyyycCJSPQucsZIJXSfSMSoCbivwlrgm4r2EiIY
X-Gm-Gg: AYBFou20GxruBNuFSztjxPTa5TP6gNdTFD3vt1Gun7sTOpfIFPqlINfkbbAHPGBb6hc
	NtDxyfkese8hHR0vBSAxev5f1GBgBm5tLFxmGoUjQ7KouRwrnWKHaKLFHgoKKRRk+81UR7IdQix
	NkbSJ2k3qP1Gi4GIkbCeJUYE3THAZq5X3U4GH/BSZdTn53x010RtvGFsNWRLSbC9G+iX0DvmnSA
	2ZWiihylUvqAElCG4t2n2OxxeDn86nvQwKueqHcW7eYrUvcKhLugbIqxxhHhKi3ie9eBBK7U78=
X-Received: by 2002:a05:620a:a999:10b0:945:b1a7:fe4f with SMTP id af79cd13be357-945b1a81c6bmr414534385a.41.1793621648947;
        Mon, 02 Nov 2026 04:14:08 -0800 (PST)
X-Received: by 2002:a05:620a:a999:10b0:945:b1a7:fe4f with SMTP id
 af79cd13be357-945b1a81c6bmr414531685a.41.1793621648418; Mon, 02 Nov 2026
 04:14:08 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101164247.258200-1-julius@bairaktaris.de>
In-Reply-To: <20261101164247.258200-1-julius@bairaktaris.de>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 13:13:57 +0100
X-Gm-Features: AclHuK-mJLI3vhrxkV6Cb90_ogt0oCov9vd_N4l2QccyJhxGU5TxIqOa6IopJaY
Message-ID: <CAFEp6-3iq_Pc0UgeCi7x16w6J-VwgGQ37QaP=dXp_OaTEi+esg@mail.gmail.com>
Subject: Re: [PATCH ath-next] wifi: ath10k: spread the PCI copy engine
 interrupts over the CPUs
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: Jeff Johnson <jjohnson@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=TMDQ2Fla c=1 sm=1 tr=0 ts=6ae87e92 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=-bX5D0ki1FL7K08LthAA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: CJDvRPq3v6r1cLBqXF7MUzW7FdyF1PrT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA0OCBTYWx0ZWRfX4blPHHTGXHgL
 NhuGsiqG7YwsK23R6WdZh1twdG1ptjPP9ZkGy63MkMQafXcl9cwzb1zDcRip8A3stP56fbaG4sJ
 fVCdJxeBp3fNuBsIKTEnkcutV8cDE44=
X-Proofpoint-ORIG-GUID: CJDvRPq3v6r1cLBqXF7MUzW7FdyF1PrT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA0OCBTYWx0ZWRfX3/ojSt1eoM6U
 iXQkqkjPu/KA2VmMY80szb7Wn+XoS4Gqpsb07DSLqxqQlsPR+M/1/fcxnQM1gOLR85WsxeEgQ3k
 TT6vuaRtcR8cNGUk4CoUqsVupuVkLWgWz/iVQO2lZJ+OUAAS7lcqmg9tSe8oRmSLEghcTvW779L
 B7gYYR2WQsxddvBFG0o1FK7m9SJxC6mb3oJuBB9gTCsCEk68/YeRSljCpqQSg+6hmjYz4JeBclM
 efF36F6dD57pYXPMV9xuyLNi11XGCDVwckQOm+r5JO6SFLZ5Qnw9n+Ih+NJ2lWvtk0+Qcp+vKWI
 wibAtRr6keChoGZ0YVT21kWmrcNAftiY4pAH/hLsqfVuPKM9eERqenxnolA3UIhQfj/l1pF26XV
 a5s13nhAbaoz081UT03Ig+mmm0RWJ/80mN1JERwX2cqlV62jLHUKUykKhKCpVDeTtqrz4yd/0Za
 Ib/DqPzwurU68brq+dQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020048

Hi Julius,

On Sun, Nov 1, 2026 at 5:43=E2=80=AFPM Julius Bairaktaris <julius@bairaktar=
is.de> wrote:
>
> The PCI ath10k devices are capable of multiple MSI. The QCA9889 of a
> Xiaomi AX3600 advertises 8 vectors in its MSI capability (Multiple
> Message Capable 3) and, when granted all of them, raises the firmware
> interrupt and each copy engine on its own vector, the layout ath10k
> used until commit cfe9011a05a8 ("ath10k: remove MSI range support").
> Since then ath10k asks for one vector, so all its copy engine
> interrupts and the NAPI they schedule run on one CPU.
>
> Ask for as many MSI vectors as the device offers and spread them over
> the CPUs, starting each further device on the next CPU. Every vector
> keeps the shared handler, which schedules the NAPI that services all
> copy engines, so the copy engine to vector mapping does not matter for
> correctness. With one vector nothing changes.
>
> On the AX3600, with a station uploading 87-88 Mbit/s over the QCA9889,
> the HTT copy engine raised 36891-37590 interrupts in 14 s on vector 6
> and the WMI and HTC ones 165-313 each on vectors 2-4. The receive
> softirq moved from CPU0 (21-25%) to CPU2 (21-35%), with CPU0 at 1-3%.
> Measured with idle-priority spinners, the CPU time of the whole system
> stayed within the run-to-run spread: 25-42% of four CPUs against 22-34%
> uploading, 14-35% against 10-37% downloading (3 runs each). A firmware
> crash forced through debugfs recovered as without the change.
>
> Tested-on: QCA9887 hw1.0 PCI 10.2.4-1.0-00047
>
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
> Tested on OpenWrt's ath10k (Linux 6.18 with backports 7.2) and on
> ath10k-ct with the same change, where the DesignWare PCIe MSI of the
> IPQ8074 lets each vector run on its own CPU since commit eaf290c404f7c
> ("PCI: dwc: Enable MSI affinity support").
>
> I used Claude (Anthropic) to help write this patch.
>
>  drivers/net/wireless/ath/ath10k/pci.c | 64 +++++++++++++++++++++------
>  drivers/net/wireless/ath/ath10k/pci.h |  3 ++
>  2 files changed, 54 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless=
/ath/ath10k/pci.c
> index 335bc7c488..4de789cd06 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -38,6 +38,9 @@ MODULE_PARM_DESC(irq_mode, "0: auto, 1: legacy, 2: msi =
(default: 0)");
>  module_param_named(reset_mode, ath10k_pci_reset_mode, uint, 0644);
>  MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
>
> +/* Spreads the interrupts of each further device from the next CPU on */
> +static atomic_t ath10k_pci_num_devs =3D ATOMIC_INIT(0);
> +
>  /* how long wait to wait for target to initialise, in ms */
>  #define ATH10K_PCI_TARGET_WAIT 3000
>  #define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
> @@ -1943,8 +1946,10 @@ static void ath10k_pci_irq_disable(struct ath10k *=
ar)
>  static void ath10k_pci_irq_sync(struct ath10k *ar)
>  {
>         struct ath10k_pci *ar_pci =3D ath10k_pci_priv(ar);
> +       int i;
>
> -       synchronize_irq(ar_pci->pdev->irq);
> +       for (i =3D 0; i < ar_pci->num_irqs; i++)
> +               synchronize_irq(pci_irq_vector(ar_pci->pdev, i));
>  }
>
>  static void ath10k_pci_irq_enable(struct ath10k *ar)
> @@ -3164,18 +3169,42 @@ static int ath10k_pci_napi_poll(struct napi_struc=
t *ctx, int budget)
>  static int ath10k_pci_request_irq_msi(struct ath10k *ar)
>  {
>         struct ath10k_pci *ar_pci =3D ath10k_pci_priv(ar);
> -       int ret;
> +       int cpu_offset, cpu, irq, ret, i;
>
> -       ret =3D request_irq(ar_pci->pdev->irq,
> -                         ath10k_pci_interrupt_handler,
> -                         IRQF_SHARED, "ath10k_pci", ar);
> -       if (ret) {
> -               ath10k_warn(ar, "failed to request MSI irq %d: %d\n",
> -                           ar_pci->pdev->irq, ret);
> -               return ret;
> +       /* With several vectors the device raises the firmware interrupt =
and
> +        * each copy engine on its own one. Each vector schedules the sam=
e
> +        * NAPI, so they only differ in where it runs: spread them over t=
he
> +        * CPUs, from a different CPU for each device.
> +        */
> +       cpu_offset =3D atomic_fetch_inc(&ath10k_pci_num_devs);
> +
> +       for (i =3D 0; i < ar_pci->num_irqs; i++) {
> +               irq =3D pci_irq_vector(ar_pci->pdev, i);
> +               ret =3D request_irq(irq, ath10k_pci_interrupt_handler,
> +                                 IRQF_SHARED, "ath10k_pci", ar);
> +               if (ret) {
> +                       ath10k_warn(ar, "failed to request MSI irq %d: %d=
\n",
> +                                   irq, ret);
> +                       goto err_free;
> +               }
> +
> +               if (ar_pci->num_irqs > 1) {
> +                       cpu =3D cpumask_local_spread(i + cpu_offset,
> +                                                  dev_to_node(ar_pci->de=
v));
> +                       irq_set_affinity_and_hint(irq, cpumask_of(cpu));
> +               }
>         }
>
>         return 0;
> +
> +err_free:
> +       while (--i >=3D 0) {
> +               irq =3D pci_irq_vector(ar_pci->pdev, i);
> +               irq_update_affinity_hint(irq, NULL);
> +               free_irq(irq, ar);
> +       }
> +
> +       return ret;
>  }
>
>  static int ath10k_pci_request_irq_intx(struct ath10k *ar)
> @@ -3212,8 +3241,13 @@ static int ath10k_pci_request_irq(struct ath10k *a=
r)
>  static void ath10k_pci_free_irq(struct ath10k *ar)
>  {
>         struct ath10k_pci *ar_pci =3D ath10k_pci_priv(ar);
> +       int irq, i;
>
> -       free_irq(ar_pci->pdev->irq, ar);
> +       for (i =3D 0; i < ar_pci->num_irqs; i++) {
> +               irq =3D pci_irq_vector(ar_pci->pdev, i);
> +               irq_update_affinity_hint(irq, NULL);
> +               free_irq(irq, ar);
> +       }
>  }
>
>  void ath10k_pci_init_napi(struct ath10k *ar)
> @@ -3235,9 +3269,12 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
>         /* Try MSI */
>         if (ath10k_pci_irq_mode !=3D ATH10K_PCI_IRQ_INTX) {
>                 ar_pci->oper_irq_mode =3D ATH10K_PCI_IRQ_MSI;
> -               ret =3D pci_enable_msi(ar_pci->pdev);
> -               if (ret =3D=3D 0)
> +               ret =3D pci_alloc_irq_vectors(ar_pci->pdev, 1, CE_COUNT_M=
AX + 1,
> +                                           PCI_IRQ_MSI);

Why not simply using pci_alloc_irq_vectors_affinity()?

> +               if (ret > 0) {
> +                       ar_pci->num_irqs =3D ret;
>                         return 0;
> +               }
>
>                 /* MHI failed, try legacy irq next */
>         }
> @@ -3252,6 +3289,7 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
>          * synchronization checking.
>          */
>         ar_pci->oper_irq_mode =3D ATH10K_PCI_IRQ_INTX;
> +       ar_pci->num_irqs =3D 1;
>
>         ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + PCIE_INTR_ENABLE_A=
DDRESS,
>                            PCIE_INTR_FIRMWARE_MASK | PCIE_INTR_CE_MASK_AL=
L);
> @@ -3274,7 +3312,7 @@ static int ath10k_pci_deinit_irq(struct ath10k *ar)
>                 ath10k_pci_deinit_irq_intx(ar);
>                 break;
>         default:
> -               pci_disable_msi(ar_pci->pdev);
> +               pci_free_irq_vectors(ar_pci->pdev);
>                 break;
>         }
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless=
/ath/ath10k/pci.h
> index d114778edb..252044dd63 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.h
> +++ b/drivers/net/wireless/ath/ath10k/pci.h
> @@ -115,6 +115,9 @@ struct ath10k_pci {
>         /* Operating interrupt mode */
>         enum ath10k_pci_irq_mode oper_irq_mode;
>
> +       /* Number of MSI vectors, or 1 for INTx */
> +       int num_irqs;
> +
>         struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
>
>         /* Copy Engine used for Diagnostic Accesses */
> --
> 2.53.0
>
>
