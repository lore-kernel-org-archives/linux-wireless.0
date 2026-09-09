Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CEB3955DC
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976682; cv=none; b=eYft3sxJA0pUgd9IpJjwJtA6X3vrgws2fN2Mrvi4RUmvbIra4cfdhIkqEKozwoKBTN+8BA0BcrpNVnRAqBY3xEsfvoxVk5eHlp4c7slDLaUXgy/TOM3HUnxzzhhbipcvSDGPDvz0U6cKNiseihNcTeEHeXNQr7NiBMlR8XH/PR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976682; c=relaxed/simple;
	bh=d9c9Wa806ihjWjw1dJL4ZvmwxfH6RzfHsspDEjGk9mg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZHtH20pZWIqsuT+vcK/9eZsSiqRUBMNyDLWMwtTTLRl0iS1pWBRakZHvuRNFaSrU5BSqAKjxmLV8nyjU9rGRc54/7BWEe4zcBv2dl2JUpyyAYjEO7tnS3FoalyNgMqlBg0WbU+FgHLubdqCyPQJerCJMa4DXZ9VP36w/zScndGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a1e+N8+5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bhvxRquS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a1e+N8+5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bhvxRquS"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689H77uA1899443
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 17:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jlUBBr80kVdfFPvGMsK73nviWBviEpjJrpNGHlLZvak=; b=a1e+N8+533LeAnjX
	eR8UwtoeyTgQ2AKkpprep+YsFcopJg+wKyWkHhrvNVZzunxty8uR5Vl9tgtqg6zU
	owN0OylFBiuTGuP48ewFdM9BAN+TYRMBMCmKuZJoQe2AoBCsS3iAwvU+7Z+96nvS
	Q3ycCr5OAsEmM4fPBtTFpJhSawjP2onZl5Uq51+hfanJRoUcgq8A3byNoIIMAjoz
	Zy3TCe4zv1i/lXp09aLBeV+jh9BmVIH+pvJHyPy10T5l23ctNhJDrZixzU39YY/x
	hp7o9Rn/i8d4s0NuswPRqwFo3niDfTt4Fhr7AF0f/CvTc8YLenQFPhtKhVLTEuW5
	skwSzg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gk77vhngx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 17:58:00 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb835525b10so7236939a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788976680; x=1789581480; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jlUBBr80kVdfFPvGMsK73nviWBviEpjJrpNGHlLZvak=;
        b=bhvxRquShQvLWyWks0zdKhE2Go622OttQ32ZDaJ3rthnW8SummenGgGBp1yUVSplui
         BZbNo3CPlC2WigLASXR+/d2E1qXr+oUjrhqwl6MkF0pN4Je75CbtJKNaj+F7ud1zUVQA
         tgva+HTKHU94jPiepaBn3QU57igYRkcUzpJoztrF0InE3uh65/Asdzss0tFVoblkSKb1
         aQCT6KzhR8EPO6zeRnx8WDAg1aHIeuhzMNkGVloN0kNzKF9hVDLRit2OOMp0nqkvT0G+
         LAIB0LYp8kMA2zbPzDi7ELsG4JtXVRPktxWZpoyiNN/cB1e1xmByME/3urNW4Qisg9sT
         3ZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976680; x=1789581480;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jlUBBr80kVdfFPvGMsK73nviWBviEpjJrpNGHlLZvak=;
        b=cBBxjDUC/XvRKJEeqWzuOguMn6vhhF7aJlRMKYopwH1uWSLybGoBE5GL3gPgkgJaov
         Je8lGwz8gRhEL2h2frnFKbxUUW290t1zanEIyebtg/TnO2zs2GcK/xXKUeEER9otP/iu
         UmTFbQFIoAeoQSYTCvj2tEb44+4+xRCDwNQglLm+xBeJuLB3myoGMV8g4fwsZE8eGk72
         uoYWkGzPLpTtbSxjFRdn25/DO9G72n53eXTx0aCETphIWjMyD2a7djt/k9kGKTEZBQP+
         a9g+qMZqfXZnA9EyZxy/FdDwT7o/1X4puVoGzvw3cH3yAuFHUgJuKNd0CyCJVyvhTDn2
         ECcw==
X-Gm-Message-State: AFuF++n6vb9DoNYK/2BkDuu9Q6zula5AJdoXTES2zCFnHqgf9uElvRLm
	+x0x9K62K6F+gVP/2a/ab7E9ZVYVZefNCNrpulPqGA3wnGXGCB+I40AtuybBX8JsUcbPzbXPbrK
	vkQjTbGdUSSIAU96gXIswXHpagyiYrStr7pI3hqeRQB2TIvKpVDBMqm/JCShB1H4yTs8WB10llu
	QWoA==
X-Gm-Gg: AYBFou1XLpdQhc7LSpMJc5y245Bn4QsNlx2CLUEM89Ut5qfMJj1D/PGGcgZtoZ3fo6u
	2wi+Fr6nis1fXIAl87zs+1B8M/JSb9x4XAYMf2T75FHtx2hS59OZvfN/5kWVSalUfXi7lfzxLa3
	dt29zHpFW/k7intzFObtSH/vvQgOAViIak5t3mlqj5b+ORU5K1hjCz6FMTxEjfGsknPpWRd8NYP
	mfoYKb84CBl8zS1fwZ9gPSc54EOqDRJtVqlhWsggBdCvk0sQdLRIIZobxUE/4EDdpR1YWvaNbif
	Z4tkNB5sNYfOt598DScWNZtSVAiVwN7g8C0ZvBmesM/ML2aUX3M3HTREsy5oJVycbRASmpMYspC
	JIoo7StG/P5y2AII9JcMv0mj4Y+GTXFpEFnJsNJc01r8nzIIW7MN/ark=
X-Received: by 2002:a05:6a21:a97:b0:3c4:1c9f:d7e with SMTP id adf61e73a8af0-3da39b437d9mr56708942637.6.1788976680084;
        Wed, 09 Sep 2026 10:58:00 -0700 (PDT)
X-Received: by 2002:a05:6a21:a97:b0:3c4:1c9f:d7e with SMTP id adf61e73a8af0-3da39b437d9mr56708887637.6.1788976679569;
        Wed, 09 Sep 2026 10:57:59 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-339770f0489sm14478225eec.8.2026.09.09.10.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 10:57:58 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, Kang Yang <kang.yang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
References: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: preserve PPDU state across
 monitor status buffers
Message-Id: <178897667862.2048605.2420696819574029448.b4-ty@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 10:57:58 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=GKk41ONK c=1 sm=1 tr=0 ts=6aa19e28 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=7yRbvbv0muN7hk5lIxAA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: mLCB9UvmNGQ_CgWvSd9RE77360pF8pmL
X-Proofpoint-GUID: mLCB9UvmNGQ_CgWvSd9RE77360pF8pmL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXxuojb6s+uV3q
 1Zgr6DvZs1rWFbPeMZTrRJXsPx3Zc8tO7gV4tmQY0vFTMhmiYBc0bEIa9YnuFRz2nQOdHtrDGkv
 edMsC1Lq5imrw3vjocmNtLbEjdCdsug=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDIwMCBTYWx0ZWRfXwkWx0G0Leypn
 Ygvm8r3wk0wjpUZy+cUt859i1wFKW+qRAK2/eXQxOqPlqDVTAWEaSsekgIjzKydDsSIxd8uVj2J
 q63JwMJzK/WuKg+ZIFN303KvsXx3jKH+iF4cMco41vS2q74toKdgGcbYxd629HfRVBIl8DJQ0B2
 XAO3MrzIyNSlZLsqZeGnI9vROM9prAikb5R7vjqAzN3jNDc7F9p/GCY8VQgcn/Dx6o8UXt2Bp8j
 B1HkqlWbDN2jRTKtlhTkf4E88FfbHjMNhifIvVndBMzM1oMrXbFV9183tiwlcIeZVB3tcBLoT1g
 1h93924QycQB6+Z8XkKrrCLg+oA2V07VoDEOaVr3M3NPa/8kMIZI5P11yeGr7DaF3Se+Meav46r
 aKZuuoLjuvdjwkye9fkyraqE8OSnH3YYO7Iy7FB8FbDTgmDKnNwWyVq9YRoApheo/9RPn+E2NSi
 9qX0x2+tlaS9xR9+utQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090200


On Fri, 28 Aug 2026 14:55:34 +0800, Kang Yang wrote:
> A monitor PPDU may span multiple status buffers. However,
> __ath12k_wifi7_dp_mon_process_ring() clears mon_ppdu_info before
> processing every buffer.
> 
> As a result, continuation buffers lose PPDU state collected from
> earlier buffers, including ppdu_id and PHY metadata.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: preserve PPDU state across monitor status buffers
      commit: 69b2d06dafa4a61b718704d655dd370ba660052a

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

