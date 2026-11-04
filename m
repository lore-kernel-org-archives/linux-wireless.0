Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793757759;
	b=I+ZgOFYawi47g74yb2ZN29iC1MnGc71xuiQL4vTk7LFuC0/qHYC1Ih4exwQc7gZjJgqy
	 GOKvj+LiHUeD1Jt+42p3WmBe8ox1jTFlgabLNtf4K4PkXns9xpEADc5x3DTdxduRckaeD
	 jxYlL7fuqVtHJPPadnvH8PJFLro64OOHKfw6kH6+yZ1KT5aj2Ind1rTuJs8zIOogzmUoA
	 McFEJKv5hM6aatczNvinlve5LutNp34skXDobcmwLmQHccSXPZWubHdXwiiwEkmrk7ZGy
	 1ufO+gKG5Ls7Hc467VUUNgpk9cC1l2SVHP+wNAySDpDou9u5V4UxY9DmTypCSGCFOdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793757759;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=32vAGZ/a1y3hLPzftJbPpOIZU7el/7vO9DaLkQmD4nw=;
	b=d/6FV4Co3ZjS7jjdKdEm7pVuKV+2+uWCMnhHP3PumQZF78wvYJ9h5i34e9bLZwhFLRis
	 F8H/L2ZH30yzgXQBZS3r9wavpNXc6uXC1U2yeiXImUr3FdSC1VL77D7JHoHm6mNZXgUMH
	 MysydlpeJc0k74iU4yHrhiNmmQdEgwggEb3a49WKI6IDhTp/XqKzr0R1fR1A5bd0WUc5K
	 RAvpCF+vAUaYoQjs0cScA+u+kvm9s6uKIYFqokcHPuyZ64GxgdfgcQJx+YqddM1W/Y4ZY
	 VB8NJ1V9LH4o6K2rMehJW3jH763VQLgDnue1r4X3rMEnkeKL59ePhNJqtQzdNpSkGaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DBCtrizy;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="D/tNRtDn";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0583606A328
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 02:02:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0583606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DBCtrizy;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D/tNRtDn
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RZ6c3867645
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 02:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	32vAGZ/a1y3hLPzftJbPpOIZU7el/7vO9DaLkQmD4nw=; b=DBCtrizyk7dRQcIa
	g/gOru9rbw3+nT+/G6I9DUmyBcS5kkTXOh/Fzir4LPv1ihThiAHTPM2i3kQUYxo5
	OZi/Mx1M7ZkJANh+CvNJIDVSeUO6T7wwpkUMphEPntHSoypOiiIZUKBbzJ4ql4L8
	X5DjOkGbPv4oHZT3TMFuVDpFO54AUsHA4pU+gqnFOVsRTr5W97yyoGRWuhcVf7rf
	ZAPTmpVPykmHBSCecHL+TIEj5Kom0olIVs0CBpZd7+XhJEryUxlIV+KxfA0IYEra
	7u0UFZe4Arrg6q6OE30A50zewiIYdX8P3uJL9PQYSU4NkxUGYleCdS2BRvTuKggB
	DiMGCA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8y1dd7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 02:02:37 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac0ae43900so293834a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 18:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793757757; x=1794362557; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=32vAGZ/a1y3hLPzftJbPpOIZU7el/7vO9DaLkQmD4nw=;
        b=D/tNRtDnvxNRwuVXe6dKiEpc6QU/8tSRx74n/CdKuWH+VAnnH/l5QSeq7w10fKumCH
         zuSvZLRwofqh5GihDnHoe03QFg6g73rdVoUs6VGx4tCahVp+y5U+Px2nWZ+K6YZpooOX
         0Yk53kLnpGdG4m1U+eBwblmUo5FPc64wJUVN6tsQB7eUySBBRymKZ7pWJbz9BAmy23LK
         pS4yrbPMLiPqjmZ46Xen485xUCqpEIEKKX9dyKxQqly6UpQYG9JSlFkhrRoouMzBRvgm
         ubvLe3UaW2ZQ73LCxUX3eZ4oAIVkO56gzWWdekz6e/GxdAHSOdGoOcM7bkDY6CZ81iW3
         mhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793757757; x=1794362557;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=32vAGZ/a1y3hLPzftJbPpOIZU7el/7vO9DaLkQmD4nw=;
        b=UTXjKb4vqWD5lTiWRzwhYiJ5yWQYInaaeUnMvG9RGIFwh4lAjRucltVTbX+y9PhvAd
         O+DFYkRfUzp2fPklh+PgBY7lKvzMVf4vjXGRPGRajdja+1XCNGm2U0I7BLOQs2Ibzzf3
         Sxo4sx2PRS3C1MaEXv+fmOd+2YGiVH0ZQjUaYZptuUs089hmXgjMj0CTBQxRyuUGSOZM
         oFRN8FCIRLbyekN6U+xpKte1mcJb2piGQ8su7TOe93jB4VS4qW9Cl8YCuNcTgZN34PmB
         vDwWPZ3euCOxmM4Oq/ZTIgkVixp7hixRSRsU1O5HZ0T9qVd07Lzd8xLqBGNA9iewd7aR
         MZwQ==
X-Gm-Message-State: APuU4Z9aGXH8RI1w5Xlkciit9u+ML+HhHttnJR/cMRbTrXeyT/mmk0BV
	SuraiQJXRiOE8D5TdsIQbIEnLxGVm5HlOmEYyW7lnSxYGY4A6/xDiKqkJ889YlVGFQrjETQFNlZ
	pb1m9GVk4V6hnisWh9EQudCs0erO9XRnmimTNfYAdAyuWEgkVYe6cTVW8KjL/0k4fOfT/Xw==
X-Gm-Gg: AYBFou3Yzdq/rlZxHPx4ReTzcn5EFY73tAs6FCH1M/RVJ1f4nzkUSUHw9Qhr+84Jvn4
	T6Zg/amILPhOH/YhRIft1OgQ1PvL0qcuL2yBnKXQJ1XS1/c0RAzW9OHPkrVYIBHi3cpynaBWb81
	AE4WNZirGc5rLzQHgQpyvWAtq3NTUWAQ+/c+oTOSank+i0oJYgHUSFOLUqHDQ8PmS+UZngCpfne
	hnMhKAZIIrr/ahgfNnnSAU5f6p6hoUF6ueYKRbgORNJn/ezRjufRJ9AblE7F5eHF58NyFvrjgmX
	J4vttXSO9TP22zuF9o9nJeMkJUE3Gjm+8H7Bl91qJWiRtoLmXFGBeTmbcRdslnSv0yIi1pRnRuV
	k/nOLLLLr34paLJYTSLPee14nmG2hvx/tKJxrbPJi9ysR44ngYzjhIMZTeiBCsrl3/Cwgisd84c
	qvSlgrgchEPqeKxla6NiHkC9XzCCW7hgxQ6SqhpyfVQG1h
X-Received: by 2002:a17:90a:8398:b0:3b0:9984:18c9 with SMTP id 98e67ed59e1d1-3b0998422c1mr266156a91.11.1793757757190;
        Tue, 03 Nov 2026 18:02:37 -0800 (PST)
X-Received: by 2002:a17:90a:8398:b0:3b0:9984:18c9 with SMTP id 98e67ed59e1d1-3b0998422c1mr266144a91.11.1793757756626;
        Tue, 03 Nov 2026 18:02:36 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c9928c4sm6947487a91.15.2026.11.03.18.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 18:02:36 -0800 (PST)
Message-ID: <7d07b4b7-42f2-4367-b3f2-aa2ce5258747@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 10:02:32 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 2/2] wifi: ath12k: refactor m3 and aux_uc
 firmware memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
 <20261103-m3_and_aux_ucode-v1-2-e14f13fdfa41@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261103-m3_and_aux_ucode-v1-2-e14f13fdfa41@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 1k2NYO4rYF2uV99UZoJY_GLdoYHqDFhB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNyBTYWx0ZWRfX2l1bAiupsEvG
 O9CWN6/EXABQSEdWq3xkKC5J935XP6a290bAmUM73f2K4sVhKQDZG7mGIQXdoZqGTAi1ur1Ky7C
 U4LjP+9+JowaDjKKalrFx5aGhYydhY3GUSZHvjAbP+721z7GAHOBAET8ouwK7QG08hLi42aNCnJ
 hTwdpBeu5h+3SopJFBRK+BdYiUxmjzJj8twOuu6hNK6Pf/2FyhBv1JqAkNptA6+TxXZ42pvqyaq
 vNC73mg95E3LLraEWiXIVUnBxsk7KJMONT9jBZnBBLTmh3Fxec5qPjH6IA+623TXez1X5PqTgxy
 PuSnJ2n9KydONRex0CmhRkCD/wmjhkSA6+6qmsMQwG6I39eL0KSG8OQWBYV5te582NlA3Jz3lf6
 AqEcWDzo87vQX+zV7++b6zH2f8W/grLfZun5cc1g1c04AvBT8V/bRrjillsMPRvmaeXTPz3RX/Z
 N+jDBf3yEj+1WVJj8Dg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNyBTYWx0ZWRfX4swcVGMc+Nmn
 omSQ+Rm7Ks4WMBLqUUZwHH8O7JYg2wCWNsachM7juODbmU2dde6yHiB6HSD631rsr56DliZ8PjJ
 ZrWljs6f6QH4Ru6oUdxhJTDRLCFqd9Q=
X-Proofpoint-ORIG-GUID: 1k2NYO4rYF2uV99UZoJY_GLdoYHqDFhB
X-Authority-Analysis: v=2.4 cv=NP5AaE6g c=1 sm=1 tr=0 ts=6aea923d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=j5APcU90v0LWm_mwTeIA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040007



On 11/4/2026 1:26 AM, Madhavan Ganesan wrote:
> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() implement identical
> logic for freeing a DMA-coherent firmware memory region and for
> loading firmware into it (reuse existing buffer if large enough,
> otherwise free and reallocate, falling back to a standalone firmware
> file when no embedded data is present).
> 
> Factor the common logic into ath12k_qmi_free_mem_region() and
> ath12k_qmi_fw_mem_load(), and have the m3 and aux_uc wrappers call
> into them with the appropriate struct ath12k_fw_mem_region and
> firmware file name. The shared free helper also clears paddr, which
> the previous per-region implementations missed.

I don't see that paddr is cleared in ath12k_qmi_free_mem_region()
