Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818794;
	b=N4BKMCLjBTzxjjhW2RCY0l46vCnNCVm4oEPg8+9qqyYhUbd5zFEs+jxKtHlBN0kexgBy
	 HUFWVWfJh2fEOvZxYQn8H0zgwWMhg/vThh292JkcUGW3C4++P42dFnnb8Axp8/ELKSHul
	 d6XSNpfIIuC3fEcuAr8HMnanYTfW4J0Jw5lMGrMfF4PU0ak4ijobmKX/kQN01swwdIH+h
	 f4U9pD7qsGAIvmBS4/NfH6AiC41fVJidDSpT720rsn+Lbm+xpwPcPV+bk97NEzsKY3/3/
	 15SOfs2QyDxzfVYLV/vxvKKxRvyteRUuPztEFeP89kFMf9FRPCDILu98N22XRugcTew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818794;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+AL3vVJujoQWo6KzL6QcnfTX/uMtvYEe2+sDd+kjwIo=;
	b=hBevkra0cNLzLimlTVOw0fzF99GgLhtPfYCv52IEVRbIoyWdJRR859KtCIoadADjx3EW
	 7YvDd83jUjuBgeoGaxVGbFlD73nd42ZIY8x0KsWD96zmuLaAowFfzKjIvEmlhWYevICyH
	 Iau4MmeBMRVuC8TGwbsF5MIEfjAMsdUf9QlqRLe+jCOdIAYni8zRWp0KQlemfCODYqz8V
	 RZy7VDKz63RWhIQTUyxPzV0Miq/E/OV2prgdOwX+0yUDHuKFQKp6zSufxIX3Z7GQcDKqy
	 ggJ5R5P8wjh0aQPRT2bgQJj2wffoxAQ2Tc6eg1lNxn4m5AKNz11RwRwBhFmnF9FDt4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oL0yYGPA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IvQjAGpi;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B52606D80C
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 18:59:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22B52606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oL0yYGPA;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IvQjAGpi
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4Fj6YZ3208773
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 18:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+AL3vVJujoQWo6KzL6QcnfTX/uMtvYEe2+sDd+kjwIo=; b=oL0yYGPAouoaNo8S
	qM1vUmyDp2purnoBDMraK0tUmAiatZo0Cz4/YPxbeAhPWg7ERgppywjMs9HOnGuX
	RaqRHfCSOXp/GR0vUsuS7nButWWuHFgNse4gPobVoOI5hNlowWwqSLF1XtJoAt+T
	C9VQ9q4UM/SNPqZfAMg7m2R9XFNNFGpaZfN3Ibf6aZ+9Autil478sirtJufV3wM+
	hPSGjUWVAVXzT8KA1/O+R1zAHSyvawZpJ1CaVzfWmDs6zxThXChrW/uC8bobaeWR
	IzebhghazIQxwaK09eWiMeBrsMsVbI13KCt32j2pyYjsBexEgt5uUQ2fu7PO3ljn
	pSkwDw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hr6bj167n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 18:59:53 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36cec75d8caso963118eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 10:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793818793; x=1794423593; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+AL3vVJujoQWo6KzL6QcnfTX/uMtvYEe2+sDd+kjwIo=;
        b=IvQjAGpi6BQO5ds99yE/w+6gBlsAoddhxclkj3dJMAKCdm/swIXQud/5mmvuJMmf8a
         bBFhjJs6hKlrJY7FqanjDEcnxZb24kBDNNFVo1hT1PBrrHmhOPC/uXx3JtpHG/piNgyC
         QFNEWLSJI1CtuSW2Ois9CTHrFxhD7gRgtNBJ6yquhdvgIsD0ozvzZbeEIAQTSOj/dB5s
         8YjaEgD3Ocdbv9OZyff9Xw7CGnGCeOFahnoN6Vk0fdpIc6QbQHxWqcBoOxM7qfa9Y3X8
         B4BHkLDijedWRWg9qdiy1nY2bgn/JEXqd0vpghSWIT57DWXyI9EwN9l2Q2A0g1v38Tko
         PbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818793; x=1794423593;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+AL3vVJujoQWo6KzL6QcnfTX/uMtvYEe2+sDd+kjwIo=;
        b=IaoQdKiz+T7iPxv6jgLH9biFzRUnDKYLVoNOJLzCkybRvjfR3MizcdVar60nmJlh4U
         fncN9bQS+/aDhbcHKxURGGkR/3ADu6O/ovzVO7HEdKuGqVCVg7PlS3TIc7bZVo7+jC1y
         Vnna68c4/EYCSAy1LKnhQNOfKBX4DFVJzv94LjSJOyjYP6srmkC9KjZiuzv9u2nKsWoB
         kq3h9TNW1UdI8N1ZQsZab9FjttGeqBcui+NvxqAKTscUUhzI+TuMM7oawwbQTL8ea66E
         TLwDi8bx1hdOtNDzBPjQxUdxFwPs96qznORTbUwfW0/iU9WAaAnAN6piiOqMGEWGK6FA
         XJgQ==
X-Gm-Message-State: APuU4Z+fa+yakR0SR2etfaZr8o4M3N12i8TvJBZDAlkNVJnTxZUafEbl
	kll4Xg3dcwYqY/ymvjVwLjccQOSQ17DQeIZ+CP15w/9nDNCEjh4WxYg+19XiniMPbG84WCQWmRa
	uDvXFpGEpBn9evMsZnqyAua4ZyLnZPAPuQpBElEWhTMGQg13aa+sEMJPkxMzE8qLKyEG2Gw==
X-Gm-Gg: AYBFou1uiffBQMzWCvx+NrkjTHpJynb1a8qGzEq9vqaEQ0zwwOu62ZLs/mOSav41Peb
	j08zpKrkBomM3szdLe2K+Ap/YsHD/woltlMdQ1UqECapJq2qflDLQTMltt3V6DP51Icjqfn44pA
	0yIKu2SzDHDYq6WxbfIIbqiElRVhzYfSBWY+tZe7ddm7B/cuWYt23xpDtmssj1KwWpF9WmOZ8De
	RyM+PsFB115F9aTeW21l3Sj3jv/5zi2EjFllFa3/mtAeVfH4I0CuWX10Nbp2J6yQHEwWj3XjGFg
	cBqwc2PMhYygyFZHf5L6CpmiG/1EpOohhot4xSs5jrLUSd5q7CZK6XHcI9gYd1CrPqh6ej6hzEd
	LQzyNwJ1EElXZeM2x4BJL9N4sjeMX3FrOuWXdRbnkYnhFB0+kQJRe6mwc26kcCEO9dPQtQ9VLRl
	Bz25liNvlosxRiZiFAZijJTJW14Vc=
X-Received: by 2002:a05:7301:4710:b0:36a:79cd:12df with SMTP id 5a478bee46e88-36de4d892a6mr413656eec.9.1793818791904;
        Wed, 04 Nov 2026 10:59:51 -0800 (PST)
X-Received: by 2002:a05:7301:4710:b0:36a:79cd:12df with SMTP id 5a478bee46e88-36de4d892a6mr413608eec.9.1793818791183;
        Wed, 04 Nov 2026 10:59:51 -0800 (PST)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d36besm14596861eec.11.2026.11.04.10.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:59:50 -0800 (PST)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc
 firmware memory handling
Message-Id: <179381879048.1666903.4827075101285181405.b4-ty@b4>
Date: Wed, 04 Nov 2026 10:59:50 -0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA3NSBTYWx0ZWRfX1uWMb59w82iK
 ybvLB8YNCMqoKNtpKhZN3cRXxEc6pEy+ETKMgLi8WoTxu7cI/Rik2QKL/NBy0pl4Ff6yEEoQ5k8
 Qz0Ta0Aj+sy8GkwYh5N3jNz3u/nmbW4fB9MCnuAvP4Yk+nuiYblJ3MqTAU3US3EGwuMSaf5NGSP
 +gqEjCixfFmPutOddXOgMDxGcVihd5pLJL/d6fyQ7aY8oKFcAr1S0c6IJ4cRxCjiCcEnsWI6fTD
 dYLFRPh2f2laxYsGksPoeTLkyXYzUEtnoNbSFBuQIBEpwAHDnGv4Uw6GokkcE3TCJxN6vg/0Hk2
 DPt1pxKUHvMEHy7aXe/y3J9Ii9AQ7lizV2HcAyaoxtuITOfcAfclrUjKLhoQRW+uD+4MXqDn5fr
 Wecv3BGK9uFSbPMIzPhIn54ebmBTu/iNbXBIFjdZP7OnOSy9Bvsotq8j/oPq4VMYw0dl9/2lP+i
 W/ErA4ElnYMReziYv6Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA3NSBTYWx0ZWRfX6HwSaQrZeG5P
 5slpAJyM6b8vhmLI1oXoiY4bZXv3TZqv1BmTAiCxetGy9w2D3oxpK+FnktI5ggN52TBxZMPv7sZ
 gKkWTZAbIvvuiV0FSOhkFPor3zp7HTQ=
X-Proofpoint-ORIG-GUID: gvl5Iuv2f0CltZshlk4seUy9JZF5Hl9z
X-Proofpoint-GUID: gvl5Iuv2f0CltZshlk4seUy9JZF5Hl9z
X-Authority-Analysis: v=2.4 cv=N/u8hG9B c=1 sm=1 tr=0 ts=6aeb80a9 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=ZdJ8wbgfcnfs_pdWuegA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040075


On Wed, 04 Nov 2026 12:00:06 +0530, Madhavan Ganesan wrote:
> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
> logic for freeing a DMA-coherent firmware memory region and loading
> firmware into it. Factor the shared logic into common helpers.
> 
> Patch 1 is a preparatory, no-functional-change rename of
> struct m3_mem_region to struct ath12k_fw_mem_region, since the type
> is also used for the aux_uc region and the old name no longer
> reflects its purpose.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath12k: rename m3_mem_region to ath12k_fw_mem_region
      commit: 8a2640239052145072d1ee53d014b4a544b011b9
[2/2] wifi: ath12k: refactor m3 and aux_uc firmware memory handling
      commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

