Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A74B4AA570
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212994; cv=none; b=ufmnIRkpd620K5JnMy0mSiWbBVG1swVeB0rbGL0zCpetYDGYzK5+5G84GTWqGIXcFtXiFhg62BXq1JNtSoxfCTxjpBm/1RUkAPY4QTJX/rLQ0X0nv2A/wic7rv8KVPwD2xMklvpyAOgVanx7WTxMNtDVYXcx0KwqsOp5EhCinGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212994; c=relaxed/simple;
	bh=wtI7oVDUhsht2iKk+bjn2I94OjNNDcnadTbMhHCgNyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UFt3WPrLXR+vx/bnk+S/ACmFRCqTku2S27IdQ9J3e+EmlI8RkdXdN/BS0wHXRQFhBq+S6l93asENUSUpldSl1QLpusbcLlrT2SQ27ylsR1Bbk3Faqssg7S0+zWw3MBUqAPH6IhOnbwtjcHYjg3VzVmoGlIFOLztkxVIWBd0422w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VPgqw66d; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F4NbScrJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VPgqw66d";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F4NbScrJ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP6m81583525
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 15:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oVaB5GQWmscg0rsYJbxE8vQsJhAyc7OQmJS8eF/75jc=; b=VPgqw66dCbZZr3T/
	vYEoQZULY6WyvCrsI/P22CIqOIEadYzZVxzY14pyaJlSd+yltII6PJxxBHl9k7J3
	5oxliKGHkUHU90GQRkFDEd3tyl1Ec7nb6LYZLOSRTJuqBQczZW/jOLweqb38AU+q
	ky/Eon8/vfFpLt03MWF0F36i/Et/sa6/GNdA5qO6YbpRJManxLQbNa9R8vyNVq+J
	4CiW+TO1N8wFKBNuszUVlQHF48fPXxhdT/970tADddSWuQLQrPX1yVj8TsBPIR1q
	yg1CUFnnoSYmB8v3saYAzx3q+QYgMvw4wCcCTTAl7fV/2NXLiS/wFvLPkHeOnWfQ
	+Uz/8w==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h41gnaecp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 15:09:50 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e2c785aa62so28843555ad.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791212990; x=1791817790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oVaB5GQWmscg0rsYJbxE8vQsJhAyc7OQmJS8eF/75jc=;
        b=F4NbScrJw2JA/WrD27NlTBEtS1KVgToyP0YPQxo/lAlwyMzpPSp4yRJ1rTIxOqNOtG
         lmCD9s8vsM+QQBf1tJukryCCdWXFZX8SXlETGj/lD4R0smpFaTHJU16wbZti7jZjyu8h
         GIXMoXMEuFgxjhDoxg6/jwLwP2G9mn9XusMMr2UfjfLcNrZiaD2Oft9vZ1tB22mPMMix
         Eve3D1bO8eoHVyglD8A3Jk4bpNDx1CEGF/WfN+izWK35QfRzNU+et/3oXNVvsLIEd4EU
         ETpYUGxf7ZnD0t7551JOxDJa1/OPvDNrRT1ZLd60tmNEDGwxoOQwN8F4OOzc3i2aL+PK
         V2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212990; x=1791817790;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oVaB5GQWmscg0rsYJbxE8vQsJhAyc7OQmJS8eF/75jc=;
        b=OqFyf1ZFARBwUcx+CNmmvpqeQmuU/T5bxn5p5tDYMw8E7j5HiRolHX7HPeExrb37C0
         ykbtFfAQ4o7RckdpPSlPzJl2fYRSe/457sCd8CGsBXgN/EHytsE2jx0J1hlSwO74eCsm
         Jhx9XtkjkaKfn7PsXPgubdi7qmFNNrnNxKwrzivDOcHlINLUHKFfzM8DurGQqiCVHg//
         y1L83bPWJNr7zFoPgPRZbUYdOOlwHTX/ovSgA+IZzCWZvAXxNkDUxIasDuyOz7HncXlQ
         qa+dHcWLAarLiYQlUtqWwK31E2Hxp+p8R9YXd/zlyjuUmGyXRUz/RSYFfKtqDb/ho8wI
         H3nw==
X-Forwarded-Encrypted: i=1; AKwUvByw1V+CXDGAgST8BnrU6lrUok3Z5LdHXfpKeD5s08Fm9iSUXFwB/AP+hlfiuKFnZf8Ra6e8kJyfwKxnQrlIew==@vger.kernel.org
X-Gm-Message-State: AFq9FYKCm4AccpDFvpIUjL0fa+3MxEduSNkRTQ/R/i7hZNifcw4c/9xJ
	D6g0P5JOxpj4jKLessaD4FoW91HmVSuH0EQsbgtVlo9vrohu0KpdnLR8qvTjT08XwTpLC/nIqTF
	JBojL9eXjjBCo8F5eTILpOfqsFgZ7JR+QKYJfwdtP1Vopjm4PTtqZfUy0MZypUS12CiwZvwRKrN
	wcIA==
X-Gm-Gg: AYBFou04NGQunAZcXWtYFy7HmMNMGk3VwZsS+bcmK5Y3H5+fGt5NZtr1ATzDv5ciJSg
	RY1mQrUcBxvqsq6HnjZ0+zYEa0VBM2BBo0K9v3HcgpwJM/3Uhgn/kCzTgqpPCMDZjX7J5De7kEZ
	n9nTHqfEuJ+uTOeu0ZfZcObDvdh424pugu1uclcW6cC37iteY/B89A6JNgsH4sn0xyYEkDDQrKI
	qj9fZI1J9/5g4REhkUQheX7sXBWSk41ccJjaIUP3BPKZrGzvNAkxfKVN4/niYJP07/aq1qUeNjJ
	MI6yLTswoqttvjZY+znWVeDH42dCQX1LW45ukBpja4GQ6R95i80QDTfK/2c2cX36ylXh4CpbZlc
	EWaS0YKP4IIBDlcsGSezAdSXwohUI1MfVCl9U/7N9wAjOCB7g6mFdT7E=
X-Received: by 2002:a17:902:d4cd:b0:2e5:a350:34f8 with SMTP id d9443c01a7336-2e5a3503728mr21624135ad.3.1791212989848;
        Mon, 05 Oct 2026 08:09:49 -0700 (PDT)
X-Received: by 2002:a17:902:d4cd:b0:2e5:a350:34f8 with SMTP id d9443c01a7336-2e5a3503728mr21623775ad.3.1791212989310;
        Mon, 05 Oct 2026 08:09:49 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5cae1bfsm9130075ad.28.2026.10.05.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:09:48 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Dan Carpenter <error27@gmail.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiale Yao <yaojiale02@163.com>
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
In-Reply-To: <20261003095913.575108-1-yaojiale02@163.com>
References: <20261003095913.575108-1-yaojiale02@163.com>
Subject: Re: [PATCH] wifi: ath12k: Reserve space for a string terminator
Message-Id: <179121298789.2358654.17588785788531487721.b4-ty@oss.qualcomm.com>
Date: Mon, 05 Oct 2026 08:09:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: YGIJmoRepJWr4n3QVnH3TCUCIrkjofz7
X-Proofpoint-GUID: YGIJmoRepJWr4n3QVnH3TCUCIrkjofz7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfXy8OIJBOn2S2e
 4nIRBE/3RlhTIOwpufi3jBn1xYoujTlzWflI/QDENoXJFLUk5QcX8NUUwf0WTkC+fK2RqDWW18r
 a51jMxf2lNrnPYJUSXJk/emRu9nmS7DS0ivMN4DkfYCHrc9FwOZbCmdbzj5yiUa4ciHkDQn+Id+
 bxQ7W4hdGSwKVPjFyzgLJ6GwPS0Cyih12bpLjzTrad3eWabN+6TmSHdrCmxXCyF8HV3AjCnGDGF
 bvzUvR41jP7cs4J7saZG4F9t77d8h40W1quvCnvdvyg4GEfFXr/SUKDFs0t1LcMKyAvB+x11SMM
 ma9MOAqvP8Qf9Gna7fpQ9iByzkBOVZYfKCUmDW2jD8TNktns9X1qTAUVmniMLUSazqwQkACLJbZ
 slV533QA1rTY3/qx8pqxpgGdBW+YAOpwEnmIDQiByY3+Ku3AI0YgJcrhbWPUn26Wwi3ZVyU+KHh
 B+SdJZcky9YyOD+olXw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX4sRmPGUbqKNA
 Jglyzm12VwtfeySwGh8L7DpCufwp+R4F/IPifyWAHyExQ6sOMQudcKO+KYY02Tl7QwfdwYTQvfD
 jmI+vFLzsqTGnK6phkzcGdzdiP6wIdk=
X-Authority-Analysis: v=2.4 cv=P9WvFSAu c=1 sm=1 tr=0 ts=6ac3bdbe cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=oz8bYcBotx4uxxnimfgA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050059


On Sat, 03 Oct 2026 17:59:13 +0800, Jiale Yao wrote:
> ath12k_write_htt_stats_type() accepts count == size, which fills the
> zero-initialized buffer without a terminating NUL. sscanf() then reads
> beyond the buffer.
> 
> Reject input that leaves no room for the trailing NUL.
> 
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Reserve space for a string terminator
      commit: 13b15eabe2c541b80406166964cdc8ccb5e9c32a

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

