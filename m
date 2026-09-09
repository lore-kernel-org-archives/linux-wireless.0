Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495363955E7
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976673; cv=none; b=I/zVi3FB8eXmSgK3NWbbCR9Ir2tDIPqZK1SINKs9hFiXYE5gs1JIT4EL/YFkCaDtUS2UAIzxMnlArosCSie3n2jLpCfuBcEAWxOFS+jxRBOkEwwk7KD83IPyAC/ISUIpDR2y12tAPCoxFvXnFc4nYvkXBtq0VKZNSAfg4PbZpms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976673; c=relaxed/simple;
	bh=3NPLBG25V52WEVA0T+bxcWlBgkVPZwOS61fz//H+weE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lBYBcrBrg9crWs8hRAtBWWtGeS6f2X7hUSca+AOqGA+joRczHhakzgtUjmh4RvsERJ3BgXfrHQXO0nxT7+oZSfSsTuT8RjeYF8IYF3DqT6Uj/1/iVh5d8JdI/QQYKwkCUsomZUucT5oKaVcf+RWd5MHiBPH+UNhF3mWNPuGy40I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SAE1JLhU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hJn1gVBn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SAE1JLhU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hJn1gVBn"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H6x0Q1389004
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oVSiJVg7iYewYL7oMPCyOTblcroO6eMx2rR2SaZTWqQ=; b=SAE1JLhUdRfP0yFK
	M0vuplRk083yCO9ycP5+uYllzmFsUQRnA/BVpfkYyjLQk0Xk8CaVya3UhHqHamHZ
	lNVZTikzuLaLcx04hsbpxXq9KRa3ey2OlJRlZ69lcLcjslcJrgJHuhHRAIjGhqkP
	B+ji+pV8XqJQTgjTf+Mw5ODg440TIjxQlRlrdtuzGeM3ZhkfvQE2wKgrMXXpJp9u
	g1WBBc+tjioIyGzRyD5koox1fkFvqNyAROh/nJWHsoWDL2VdYStohXHfPT43ngVy
	6SSzH8o8ml5Zbz0dQAnVHwiwzLuNTRkyHCTaWVJO75l9IDkM1tHKbPAYOboNuZR4
	ENyL1A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk9rh10te-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:51 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39512608fb1so12868723a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976671; x=1789581471; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oVSiJVg7iYewYL7oMPCyOTblcroO6eMx2rR2SaZTWqQ=;
        b=hJn1gVBnRu5igsNIEdHraFsTKm4moI9LYDaELU8MZQ+dqUW0M0UyxaoqYAjoV8yCKs
         RDtnT7A4mn9Z/k0SO7tDYQl8UKLNz2jtNXIrZ18OQ6CyZEMVM84wxjywMr5uMONO8Y6Z
         ijTcihBxCWd/OBIj9UVyQdQekqCw5cR/mFkSmyBw1zfC+wjQHzsFNsVtnq4hcBM1CyRf
         LfqRC+waMIIT6poe9kel3qpgqF4wmBJc/uApHi3HFzDPu9BT3udf8cvkgVJ+muHN8XvU
         1sz4S9OPP151f3dBcBHc0TaqmHbpRRWcqBNgpPktAwjTeOxQhtjxNJzxso0+SeVUIvLs
         msPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976671; x=1789581471;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oVSiJVg7iYewYL7oMPCyOTblcroO6eMx2rR2SaZTWqQ=;
        b=m1ATWQblExGdKLrRbGCbOxluT3tE1OVbN9SUlKQ+yCJuzfyavcH6j4iDpzpACCaxoe
         qX8OQTHfLWIGaoujO2JGl623YMBGEo0LpvkdMg4KiQa9VTHOFVhoH+lvdtAfi7GKIPnE
         UxikJKvRVsxqsnTJQK740nPcpQI5X0DxmVDPidggGaPgFzhJfFvci60XCZCqL/l3302f
         PKVPlF8U1j2Mf4KPOcn9shNsQPikJcXu1zl9GByUeZL8dzncBuXES7/prI7oRlrAnitF
         1JFeBZkOCUKPZEaJtmBPE7hgzo4d1b//QKfoa5tV75IpnDUoMAJiaQDfvQMBmqoxv6Ml
         2GZw==
X-Gm-Message-State: AFuF++nPFFPv4waYkRkYjEF1s6ea1UVKlydLeBp5U26riz7k79ZD0bs3
	3YjjrYua/XNbSnqEWgPoaHLPUCyq7peU2GNi3C7M4KqPNzs1CNvmFhcVZxdYqGMVfVter5kthtm
	TTcD+cRwTYqil2OdcA22kxh0DZjAubtcoQCu3K8OrRn0sAnzz6dieyAg2kGwiC/qsbphOSA==
X-Gm-Gg: AYBFou0PJd29rIvOJ7aNaMxwP+11Ck+hRDhH5KqXSiVqNxVXGIIo/d8jB95gNxWrvVt
	oP3Y42xNNuvjBCF8iQLRIByeuWlSq63jSVp2QklrcovP36iM6SJ8TDV7gZ0ezXV2W8yiJLhgB9H
	JrHEGkeaimIuvYgQRHMLOnTXNkntvfutOMWylidL9YJfojJ7dOQJ5d9WFs+v9vVHk5itEP2Raez
	c2szanA3a7hS0u6gLH/ozL56F5VHO84DUOaOXa3+7pxYlKYiKy2zFsznVQZu9Qvv9FTnlfWCFS4
	nwNyzRV1Kir5oaFDLNGQj3D2qi/Tw91eVTtsQFdHRZT9BYjJCJd2SzjZFmNrhhfdgPyCtF727ul
	YcxuDv/PW2cRzuq7WIYRtmNXRA7ec8RqeObkvOhHx2ZpXCqKoooqTNFE=
X-Received: by 2002:a17:90a:1c96:b0:39b:66ee:a14 with SMTP id 98e67ed59e1d1-39b66ee3442mr19656024a91.25.1788976670638;
        Wed, 09 Sep 2026 10:57:50 -0700 (PDT)
X-Received: by 2002:a17:90a:1c96:b0:39b:66ee:a14 with SMTP id 98e67ed59e1d1-39b66ee3442mr19655977a91.25.1788976670182;
        Wed, 09 Sep 2026 10:57:50 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:49 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        P Praneesh <praneesh.p@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260813-ext-msdu-fix-v1-1-c5e80ccd061a@oss.qualcomm.com>
References: <20260813-ext-msdu-fix-v1-1-c5e80ccd061a@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: ath12k: fix DMA unwind for ext MSDU descriptor
 retry
Message-Id: <178897666910.2048605.5900469756207740270.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:49 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=Ff8HAp+6 c=1 sm=1 tr=0 ts=6aa19e1f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=hShXsiTv-2AdAf_wJi4A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXy9Hlpk1CJ/2F
 +HNpmhdnKQ+Cxe7GfbUDyi0rHr519L6G2EN7+0pi/ebR7KHxzNV84/On9aKjS19CWYPeeO9xP90
 YbEJj8qb2NvYE/YggugAqzbuUyp4tdV0bXtGZ+rpKxYbmATLpShTIGws8G9looyHFlJxCYKQtXV
 xfpTQ8d2dWhoL0JvuUZEojJpGzJgtf5xETaXDn4QvLsVbamFsq+53yVPqLF/Kz5C/aT2qskzE8b
 EXr3/1aXwM984j3RIg4Yl/bOecQJ9fGRUUzumoXdVWi5aRLpSeajszhFTi9IWpaypsiEtI2Yetr
 fycnp7eHF0cs5iGx6vxGnMQXC9ZphfGst6fSZNHUdx4gLGzSWxmP2yvgzKPwxkxpQT3EPG2n2rQ
 vd3SluZECwz9oXAcYdGwg5EH00DipFNzxgk8WrAdLud5Xr4JG8/sh870DdQe8roW5GltBEEQ+UA
 YbfjYRiqWR4WVCy88Fg==
X-Proofpoint-ORIG-GUID: 6zN0UciZD1DLTz6ZAJ0h7N4yWUDP6w1O
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXzmWG+YAciZND
 B+MMi+1z5rXYFr1fyrTLvhf1ud2qT5CtVjNR7BkST3q3U8HdJmKY9ePTX48zqBp1N/xghBYn82b
 ryHQfqY7DRglsb8lHmjq/Ue8QLOoWl4=
X-Proofpoint-GUID: 6zN0UciZD1DLTz6ZAJ0h7N4yWUDP6w1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Thu, 13 Aug 2026 23:09:20 +0530, Rameshkumar Sundaram wrote:
> ath12k_wifi7_dp_tx() maps the original MSDU into ti.paddr and
> stores the address in skb_cb->paddr. When an extended MSDU descriptor
> is used, the function later maps the ext descriptor and overwrites
> ti.paddr and ti.data_len with the ext-desc DMA address and length.
> 
> If TCL ring allocation then fails, the error path first unmaps the
> ext-desc DMA address from skb_cb->paddr_ext_desc. It then falls through
> to fail_unmap_dma, which uses ti.paddr/ti.data_len for the original
> MSDU unmap. At that point ti.paddr still refers to the ext-desc
> mapping, so the ext descriptor is unmapped twice and the original MSDU
> mapping is left mapped.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix DMA unwind for ext MSDU descriptor retry
      commit: 4de5a8a0edddc453f1a4c93b6d9f09013a23b72e

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

