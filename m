Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE07039A075
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976677; cv=none; b=jX8YHESLyTtqabNLDc10gw5aon3TwXvz/4fmQ9HKX3ybQ4wBDzgzJHDEiL32wJcqOBBqai5H00PApvwn0yGu3VKo8BrH5gHHmaFqhJ8gvt/+maPCcfh6M0/fBs8ccVJqGLGQDRP4Grs26Bjqq/bcXO673gIltMAHjIG3gysmYTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976677; c=relaxed/simple;
	bh=mAGa2R1GWA2KJG90Z6KGi9pYiXAo7VnB9eX3l/OAByI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XH0ni8ZHa8wQJrtAAyD9uDXS9TTcralOebsM8tmGJeSHHmvSrFflfL5OzAzlpkPRuoGdvlCgCF6p9kFuG/QdhaBao4yVwP1YDUFHLd6g/6LecHycZUJP4cSFlvsAdLiAi/pS7xT1Qnu7jj4nKOPLFEXjHR97KWIt7RonMVGR8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pccJ/OmT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cqJ1mFCT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pccJ/OmT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cqJ1mFCT"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H7EtA3412084
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lq+E/DtExS/K2hKw8F7y8TA3RGCSV6t53wrhIK3MQfM=; b=pccJ/OmTFYGee8lO
	hhBBBimkFHu0e8FUpFWQl+JlB1dg2iKC7w7/UL0qoKKxGEPssJYe8cRMIMsx9Lc0
	jCedFLFYFkeBPcfevFx40YPUbm6s2qHTuaNeLuWWjWFgT0DeOUML3A3XNv1956+b
	WsXYZAKsqzuiho7moDgWUmr2JksPvkLzzI5QRJeSX2ydzq5rvr/MsubEbsmiO9vL
	nHjvn57eCsB/gai+tChRsej+TfK+c2WT1LQp4wGwTiP8mYCXOCxb91je8AcS4z+i
	Sg8iXPUAuj35IAX7NownqQC34UmcySBlJmfuV7IiNrKp6QwVg0ZNnLgbaGzdptuP
	cKol4g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk6xh1ren-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:57:54 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cee1ec30f2so74132515ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976674; x=1789581474; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lq+E/DtExS/K2hKw8F7y8TA3RGCSV6t53wrhIK3MQfM=;
        b=cqJ1mFCThNN/+TGDnatACO0Q26qCiJKHf24Yz3oPsKXYwiFfDXep9sp+kFrsTiak/s
         5nYYDQGIMbN9Bg5FlMrH7gzXCXRCsdaAOQSHiHKKNE3YdGd5+Sv6SPzCbNDAmX83LgZI
         a6ybFqTq/H+NU1bLZFfQRHyXFUe8+RFjFKZ2bnvHl0CMxZunjeiDDi9xrms1/soyK2aV
         JlH+iUWLs2Mw64V22a4aSvHHxH/1zyzwVSO9PoN442YUiug6cE8fSELwkmvi4dwM+IR7
         3N7WTYuBWoILlkQa0vtzVJlrjpjFAiEi4jBpb2iZKr0KTX9MvAY4Y/wylE7DxaqynFSz
         gm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976674; x=1789581474;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lq+E/DtExS/K2hKw8F7y8TA3RGCSV6t53wrhIK3MQfM=;
        b=majZciFRawahl2xm4prNImnO2Rs7AmTbG12Nwx3bWLeZoSiJas+rI3R9DHplm0rQM+
         QrMMSUnXFzFACXfQazlimzuefCSF45xGftusNlC6LHPpLv3d+vzLBHMp5fNNypID7w8h
         S5NN0sNu6PMnhUxADgfQ3X3q0QkIkwOQSN9O0aFKIHwmoE2o2/FnQwUCDheZAN+I8qiA
         ChzjX2bISTJvShAQEhFJ9B0LmKtmHs5r3J8/heA0DMS1Ik71tfLAXvE7DQHnBBv3LTeM
         09pwPd4/6fyEWG23Hj/JKLwbhJ56bz5wA4KBM1K1IWwf5bj3mZ+hRAO/hXw+pkTf4rGM
         6hPw==
X-Gm-Message-State: AFuF++nbrfr7xS9JsL78Fwlj0AMCZtP+Sxfc1BlHQI2z/W9DdGNXqpnF
	oq8g/4M927RSZiFY616LDh3f6Nn1kRUONrXJnJqNxWUEavwdN2O97ytKu8g50AqOBxO5vbmv+wd
	bgf2RF1QJfZJVwnfyyyV0M8rPE4cYRwl8Z3PP8cKBmT+tVRgPlPM2EHk48w9hC85VR6QIPw==
X-Gm-Gg: AYBFou0HVdu4NxyWkJDra007L8TWdD+7Hw3iT3JdoRvCHfEo/Mumo6kd7jIIVOL5nLj
	RBUKrwSgA6cagiy3rppqqlm6ZEUIBgB54dVZR3aD9ov69Xt1bi+cIa+HMCdys9KaKYUUHs27fO8
	gS6BDY10rPX164f3zUcYtXl0oTfUzbpE/9mhoWEzLlHKOU3NI6nOqkYR/iiGsKvcftD/GHSA6bn
	mTcsZDd95pZr2s62kxoddtqmN0SQX23rE3ZhwgcWkZPRFDmE5TNueL/UUvR4kgDUeDI079MGElK
	b6ALzHQwsLIDFM1uVe0ODR1DaBRJX6FlEwTnOfSpVwJZxzEPIwBPCelQxPsYFRcQMQ8X+u9or3k
	C+GeCgESpqdHNRxGVbiNoJlehvnsbfTA1eU/l4yO/riHwaxEpHGZy+Qo=
X-Received: by 2002:a17:903:37c8:b0:2d9:50:a91b with SMTP id d9443c01a7336-2db12667eeemr526584485ad.16.1788976674162;
        Wed, 09 Sep 2026 10:57:54 -0700 (PDT)
X-Received: by 2002:a17:903:37c8:b0:2d9:50:a91b with SMTP id d9443c01a7336-2db12667eeemr526583945ad.16.1788976673672;
        Wed, 09 Sep 2026 10:57:53 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:50 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
References: <20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: fix stale skb pointers after
 aligned TX payload shift
Message-Id: <178897667030.2048605.17567905467516940923.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:50 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfX7b6uva6COZ1Y
 viEIw41rlWbCLxh5rrFhGec0RpEvCZkHBg5W0i2DbrT51ruF3TdijeJdgQTeehOIApRCBXqiss2
 ikbFLSUYFnNhb20MGbs/fWUPOmiumnvfNnH0ZHujKrpJ+ELK20E0pSoQE+xMCl7JMcYsx9grjFn
 1fsQCo7Gixd0p/vPpeRLOA3DAGyLYDKZXxxULnqEY6YbAsdHwc+jy3sKJxPRdRc7uWhVPRUpa+/
 T+uRB92/sXPHjMUa5yLGA2sF3Prc3vwCFlCVos61Yz0S15cxBC39jfxCr8tRfdT53Z1b7zRS+ID
 iOfzc+sIC8s5GpYtjcg/4f1h8NtWFP0UZQ7S/WN1t50vL4TKyjxmHRDKtapkOLlcGBSAFSwTVIj
 tWDQRouBgmFRpOd5MxOkkAbBAgHS8FZh+emxCflBvNjf0sO3YwoVh/vEstTttsluNSfk1uIaIRE
 Kn0mAUKo45QYp3+1i8A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXygV2VP3hqBUF
 cbdBWTP552APpQ8arFbWEqN8ASFdwuxaVirkUSGuOV2GrXKoW4em9bFx5V3o3KV6xqP3tCEutCi
 yGYT15s+7Yc9d90J+I7SfoQSwRxYZLI=
X-Proofpoint-GUID: L6tt1zHpsWlbH3_HZAtIWCs4_6tZJivE
X-Authority-Analysis: v=2.4 cv=KOlqylFo c=1 sm=1 tr=0 ts=6aa19e22 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=LZryh2L09-yJbEDcFkoA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: L6tt1zHpsWlbH3_HZAtIWCs4_6tZJivE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Tue, 18 Aug 2026 09:44:48 +0800, Baochen Qiang wrote:
> ath12k_wifi7_dp_tx() caches hdr, eth, and skb_cb from the skb before
> calling ath12k_dp_tx_align_payload(). That function may shift skb->data
> in place (when headroom or tailroom is sufficient) or reallocate the
> buffer entirely via skb_realloc_headroom(), freeing the original skb.
> In either case hdr, eth, and skb_cb are left pointing into stale memory.
> 
> After alignment, only hdr is refreshed, leaving eth and skb_cb stale.
> skb_cb is written immediately after (storing DMA addresses), and eth is
> re-read on every TCL ring retry via the tcl_ring_sel goto, so both
> accesses are use-after-free or stale-pointer bugs depending on which
> alignment path was taken.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: fix stale skb pointers after aligned TX payload shift
      commit: 6c40719489c8d799798989b15bc07b0700c132f8

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

