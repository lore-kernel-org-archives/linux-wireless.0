Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9613239A4DF
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976678; cv=none; b=ke+033QVe2BK0jYzdSFbyQLLi1tajpK7C0/OTWVMX2gcQxy9tT/uZFOQNp5Lfk+63g+NygsyRegbm0oIVZzaK6o2fSPrTScMAwTLNiSbnsnRtIkFXh1QP/Tc/cq2f/EG3FZvKyhSjoyvRIbp62VVlCkS8e7oZ0/UHGEy8liRlzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976678; c=relaxed/simple;
	bh=k+Ne/BuOokTjlO8SVgEIsRKEG0qX5ffQcCt40Zp23aQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nkk37fjDLbJXd1xqbrZdgVh5PiBJ5gtVhBUYcauQThq31NT2jhcrtw0toN/edkhLamNonKjCtzgT+jp4iSdB0XhkzdBBdo07QxYBHwx6b8bWlf9T+XhJo+kpwjKL2LmsCUO/DXf4YcXmCUyMOKG0kfzRqc1lG07+kUrKNa+8UGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CZQ12EHu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RYn6EWYe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CZQ12EHu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RYn6EWYe"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H75V51899350
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9S9gu/y7ay9hekveedVqwK9AwX9nbbJAw/gGWatms0k=; b=CZQ12EHu9LZ6Oe98
	Sm9ZT53r7zieXOnScohRICKpzEsLAINny0jjZd4QUudBh6JkQ42tp7VmN34iQgp8
	5Kv45dQHjoECObSi76HQMRFK2cVlvz43gmJIolBYtOePdgcroSWBwJltBsrET+Ar
	W53O4V8n0M8A74mISp+uqFSHrJL4yjxzu427eO9NFnQe8tCrCYud6f93yfa97OAp
	ZXd/6kPTndsePHUhK2b8HnrOBCObXeY/B+iz1cUZZyyEgtRgceUFG8/YwSTlKyF9
	bOkEfnCeDMfMjdIw837tU9FSkSnem5bdApfZCDGbELthXrcmZBaeHLa09Ml8AbxQ
	YK4wwA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk77vhngk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:55 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ca8aee88725so9669232a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976675; x=1789581475; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9S9gu/y7ay9hekveedVqwK9AwX9nbbJAw/gGWatms0k=;
        b=RYn6EWYeUgWj2mFjKRNkXz/IZF6papfkF3xQdUJcmR9/EibJbNsdZ1yKvW6clYMhyA
         e8L+I5kq4OLGglXl6OR2nGejb64fJ9HIHn+5Ui1G+liEvPFe3NbCL7Kf6BNHrgLH6+Md
         g5MzpLU1mwF771TWJFGMBsYzIqjjDIXlKSztqfeBdHf0v6Hf6mbzkJfqGMcNoUqjlVmu
         UG2zFFrk9/tab2KJrHGNRrV/1IJv+FG6dRjN0kRS6zIWn9NDYa6ybpruUd+0o3EVzQgS
         kjYoZNmHd1J2XtGiG+LyCtHFlu7bNfNzmdEtXdH1EM9VYv9aGNlSDboeDqHgRtwsm58I
         W/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976675; x=1789581475;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9S9gu/y7ay9hekveedVqwK9AwX9nbbJAw/gGWatms0k=;
        b=Jwcq/8JDmUVhhRDGYz8ZFD8dhfDfkXAYp4SxZUYkah5mLidGCs99xFQFxOZx94TBRI
         aXn1W4nkdyfa428VdTXnDt3g9U1w/b31dP31z75bB/6xMuSRvKSzb6g1ALxvXGVyXzvy
         hk6V0CRpKLOuEozsr+YGP2A2gqrF3bFHqXecSqFd2/NkyQKgkG/U8HZm6eSIrlVllmpl
         8GWF4myevUvjc8ijsr/9GKeAexMAa734NUNk/70D+9/DCq2CLjRhdblbEtYR7iqzysnI
         93nSMnSHCYIbZzDGZfQSaGfWSloH8cacN2PvcnCzuJOFW/EAf8TbjFHKfpdCO/JzsZae
         lH2w==
X-Gm-Message-State: AFuF++k5J0ZjaM2vJSh1529v8ZZlIsqua6dOpHniNeeXLrFKV/CBoFBg
	TnJdvlauhhk54PBVq3cEmUoudnI3ckzs2tq/d8CkqDv2JNNIg7e9oIE0YQtBEupNIo2TZD4Mdmn
	VyrFz4O7aXV2/eAbTv9kjSQnqjEV95a9dihDK1D+/z+b8SFERen6PwOkQq0vnIR8CNVrvqA==
X-Gm-Gg: AYBFou3V6bvCMM/0w3wiNERShD8FeK+NUqnFdvauAxJZchZW/kA9aT0p4MQzZ5bQJ46
	E78EmwlJLtJBgxNNptnGGiiwOeC2uGsS4MFmXgldu/rtGiomyhtD/LH0E6wYjQ6gBTecfOMpEFi
	pHR9l4CSrRnAAd56B/1IQl/PV4tLRvKsqAhj6HgWG7VQth85nH2Rc0ktx9bPgKYYrP4ZmIrE//+
	ICIO8sNTK3+WdH3z7zlMWsmv8aeYKoVc0ToXwpwvHtCkJz04Qjczyn5NYlf2/PjG6K2FW4RJEKx
	g+blBgDnYAIGSySX6ghhzs8rtf07ijRuiLIF6ZeFvKD7kMonfzH2QXwBGH2ww4sb2jYDs47/b/S
	xG3zwXrpht+kWbFt8bXM/g75/94HmHgkCET/RmjzhccdWcUf65nhMRkc=
X-Received: by 2002:a05:6a21:460e:b0:3c3:a3fd:db0a with SMTP id adf61e73a8af0-3dabb1e916dmr11028577637.16.1788976675235;
        Wed, 09 Sep 2026 10:57:55 -0700 (PDT)
X-Received: by 2002:a05:6a21:460e:b0:3c3:a3fd:db0a with SMTP id adf61e73a8af0-3dabb1e916dmr11028529637.16.1788976674792;
        Wed, 09 Sep 2026 10:57:54 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:54 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com>
References: <20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: fix truncated TX buffer DMA
 address in MSDU ext descriptor
Message-Id: <178897667384.2048605.9756082164278318649.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:53 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=GKk41ONK c=1 sm=1 tr=0 ts=6aa19e24 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=79Wd9Z1qq7BCXqSp0roA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: Swroa42_URv7mvfc4il9PMpSnknaT63u
X-Proofpoint-GUID: Swroa42_URv7mvfc4il9PMpSnknaT63u
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX8lcPpn0FjN00
 ax60zVURTn9RIf3HPvyFvVE6apa4HTBkRKN3RlTvA5oR/uAfZhioBYFIFOTmP12lZDpY1pdTFog
 qfY7COKexSQPc3z9co4TDkYTVSkrCJo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX+vNReqlm6M2F
 pgwmoTjROXVOgFPk0bdUaitvncQe9gpqx3LrHhRwvIx7S5daELEZU6IEqRHs4jt1WpLvPgN9EDO
 BNesJPptoxccS7Q8lKdn0haAvoqGCwsLoZq5IRDNVIKPemX0U423bPgwIJv4yb30pmdKOHvUzFw
 iVYb19r94GkPxZVi2+aupkFz2dpakPsOmcuP1UtD3PkQWyYmjhErt4DvARTYKi6BjotQFSRQY0z
 ENLBGr01J3FiJruE87Ldn9xCulTZgI4/9nrGG2IenYeXIbW2QJmPWiinF3y8t9TlkcVRHYDQisp
 gFrcw04nD3y9KKPd+gHiRSKdYwZSLtetNtYMgp7LtZ64El2vm9u+W+ksaLxry+g1ypaMMPKw8hU
 4QNRNSE1gsrFpfyIfk1y0S63JhyVyNr96l1/OTG2WvF8404PJvkFRNCPJ2M5gIBe0EEiX/Q4YuN
 yPV7aUTLpVi/54tlpwA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Tue, 18 Aug 2026 10:03:41 +0800, Baochen Qiang wrote:
> ath12k_wifi7_hal_tx_cmd_ext_desc_setup() programs the low 32 bits of the
> TX buffer physical address into HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO but
> hardcodes the high bits field HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI to 0x0.
> 
> dma_addr_t is 64-bit on platforms with CONFIG_ARCH_DMA_ADDR_T_64BIT, so
> whenever a TX buffer is mapped above the 4 GB boundary the upper bits of
> paddr are dropped and the firmware is handed a truncated address,
> leading to potential TX failures.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor
      commit: 979ecb88ed3528e08dd7f87b90b029374226ca84

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

