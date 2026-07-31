Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788C142DA52
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508908; cv=none; b=t4reUT2lLjfVRZI+6TLQximemEB08YWEuNEfC91gAhaH+vkHVUOE+kEeyKh1Az6xiGGWoUxAmfpf5nf1Z9tMTYxBEae+6cZ65n7aEanFAJvKCHK9rF3dW64rHvJyWBgfMOOcutLJiOieEbcDl/kY/Ik3AMNTyMLCQAIERPM3UdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508908; c=relaxed/simple;
	bh=UA5YONDg/7gkW7oucsRULbI5u0JrLWlr7sz7FLwPkZk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Dcv/I+ATa/354WOV3t/4UjHJopMFsm7r08X6s+OfsWEgzmnhUZkRTcCbcjjFNpI9hL9NIWvhekfg33kG41TAKoDzxkFoYdRdmE96ELsz3T9Sho3orHMyNxl2aV4PMbPcKMr/qJvnocXsZQ40orXj9G3v6GRko3cjZiTmb71i/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l7Fwoig/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OHgp8s4a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l7Fwoig/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OHgp8s4a"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VCCAta3778247
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zPwG7E1/1GCwuTyANB4YMYv4v4bb/VChjUJ/jYPzKYE=; b=l7Fwoig/F5CGEy1R
	8z/Xd090sGtxDU5FdZTT9lvIgHHieRNQdB7h1MVcjnDeE3d7kK9CXN2lOI1Xu9DO
	jfZQ8cngWyneLb3L9h3FDd9dtPnrRtlarNtG58a9HORTU2ZBwbhpwBjIHGz9b6+c
	c3rD+UDUfYhKEZYBTVY7hyo7fBRjuwF55yaMNeFYcRJT+dUX85SQIvaI5HMgo11a
	W7YI5g7StA66bmImwiYUmN64WjqG5aSn3sdLTew90BZBA5TMo1i7NNmHf79IVXDK
	Z1MBpuQo0iSGC+xR6Uf1oXTSgGMQkKgjH1ti5VngjCO5d9k1VjxnUaVOyI5g2+5U
	3Y/Qjw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frugh0m9r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:41:46 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e7621655eso1897957a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785508906; x=1786113706; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPwG7E1/1GCwuTyANB4YMYv4v4bb/VChjUJ/jYPzKYE=;
        b=OHgp8s4a5RtvBNvcTzso9piboOP6cXIUSiRZ1X7XrEyJ7JNYbGb3oXVqIWQJdqNSXn
         6VRWlvKRX0Zrf6wVDFmz0/Z9ifIsEJjPQLGOy1KWOxmgHvR3NjBVvuj5UOjp0MbKicJE
         6U6KREQsUsGIvi/Km+aWmvWSzqHBtCGGEK1EeVInFIkPdLuRtZ2uf++sGGUCmTm7v65G
         tFdk4fHe/WyKkTXbr98XqSeVToJBKNIMX/c9yoTKFunNe58lG9/UkKpT/waH4cUYb+8V
         +t2TRJQ8hLIYZa9mf/pDAl1n9uRlvy6diFNl9goMvC2jjSxgOeirj26IIADHfay7KFoU
         q8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508906; x=1786113706;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zPwG7E1/1GCwuTyANB4YMYv4v4bb/VChjUJ/jYPzKYE=;
        b=Dm6mwDM2tVDnHoFGM8zn3NPAZSmz44OL3RWZeoPgcpbdIuE5S6EILvW8oJLKcruy1o
         WSWa1lBWnIkRqaI9Kk4lo4b2IKa/nEGU0szlbaT1jwLZ8IWGVR7QmlM2iakr3IhAdas1
         XIWydHJuZlw+eIi4+Y1T75zRQ/IyEL609tQEFiMrjbEH6GpFIgUd4Gcm6xf48010MKVM
         IJveCz8TXGSpYyhH+egmC2TUV9jp/3523SlXjrpf4fEj5KyNPj1YM6IBRIOiSQagk1sh
         hVSfiyJSvmH/N0kykrswF48GPODn0z8Ly9KisNnTpnxDJgzWkW/rvrcSmDAqthCDWDOK
         wKpA==
X-Gm-Message-State: AOJu0YzReBJkqXdBYYk3M27hhKQgUG2r2hgnn75qF3ICHQn1yQIUPgGh
	7K1Y348/RjmhPiuZZXTS5OQTfobllcnCq/6OdjsogARB6JSriHvsRnxPO63XxCexBhVr6MBiyrC
	Vvo/SBVa3diUMASem34VQLJE1w1Kd+HyLYYeGtuCy5uWWaHyDqWr+H8sR4cotv9fnfKthLg==
X-Gm-Gg: AR+sD13PqIvaJyJsqe2IUPnMBBGqSDndK3cUrubMJ699g3+N8tfgX10403NjRMEwf9e
	kOhfGKMuXFpawmi2In9q8qM9F1AR9Wkel0aoi9ThxP6hc8pKJLRM8xX4BlYEMIeah30XAPbthoI
	NMj7qD+D3DFOvm/AzecnriWSKB41mxI1T4LOuVxtUgoRwBnA+OB9zSE44S2C2fjuUVfXBKJoYU0
	byEF3fu4GqvfFAhtQZUjZ94a0bcrq3KH3Omb72WkXJCHd2gjjm5XRmblzfbK7dOB25PdyRwjAus
	T95Z8zMO6bW3YqGWEqFy/JGHpEmK+ZlzU/dixJtpThvg3I/lMRKdrcOAg7OzGlj6WFx1nz23Zb3
	6hKWm8aTzTRwzCvB2pVt9zOImRSBDqFKomyAX8IpycYc5IJ5LT4aFYvU=
X-Received: by 2002:a17:90b:4c44:b0:38e:baf:6087 with SMTP id 98e67ed59e1d1-38fbc55b78dmr119373a91.35.1785508906011;
        Fri, 31 Jul 2026 07:41:46 -0700 (PDT)
X-Received: by 2002:a17:90b:4c44:b0:38e:baf:6087 with SMTP id 98e67ed59e1d1-38fbc55b78dmr119359a91.35.1785508905430;
        Fri, 31 Jul 2026 07:41:45 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e04491dsm9622360eec.16.2026.07.31.07.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 07:41:44 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        ZhaoJinming <zhaojinming@uniontech.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260729020005.219253-1-zhaojinming@uniontech.com>
References: <20260729020005.219253-1-zhaojinming@uniontech.com>
Subject: Re: [PATCH v8] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
Message-Id: <178550890449.2242004.9963469369675962849.b4-ty@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 07:41:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDExMiBTYWx0ZWRfXxPnHoBjVsSVf
 uJOWEtH7P4Wbya4UtIih6ac89VSghvxgk+b7sjRNLrHhkHI4oYKZMSQOG6IaqUS6iQs41KEj8Ue
 axgvxbxAaMe+5zDTNh8HHd2q5Fa0evIy5cYwd+UPeBeYv7WtspDKy06j2hggrT4Ivc7UTjrUu4a
 CQ1k5EJHZeP/GyfJ+g4HYE1WcMYx3szbVnZLV5JddgnAIDxIUTtpD7xXERlxzLWJWsJpnmrF1uw
 fi6mRBw5PFxVvgW661XZ6dpw+r8Hquu2ciwNiiOvIsunfM9Z9bTxWqO/IrrG2BjeGK3dvDLzlmL
 XUbPEuv8Q/ti53PnsD3M1tVqeLQxKNa+aPnWs46nz4Z3SF11cs/S4FLI5oIbWoXaX3lhUIbWSMS
 5cakGFyoiGc1M/YgphL0rV3WMI4LipL5PKHg7HRUAjztlYi5GJkAvm6JTMOBHp5IJiX46ErmnpL
 PmeTASnGwfAvZ3hoE/w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDExMiBTYWx0ZWRfX/L56X2m0NKyF
 PiEPMNoVrCgC4pIQagn+RbrvvbwfWN85yAELHUCnTvanzbefoNCX9ZzI10WP4/ShEZxMywcmeOP
 hppcLk0iFxB9jQJrowMpfOe76epnec4=
X-Authority-Analysis: v=2.4 cv=U+iiy+ru c=1 sm=1 tr=0 ts=6a6cb42a cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=WD2RVSGR4ZOmZR8fVjQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: ZfWhgcNZ-ppRIzTh3xYAZ2R2OFFBy2RO
X-Proofpoint-GUID: ZfWhgcNZ-ppRIzTh3xYAZ2R2OFFBy2RO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310112


On Wed, 29 Jul 2026 10:00:05 +0800, ZhaoJinming wrote:
> In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
> returns the error immediately without freeing the CE IRQs that were
> successfully registered in previous loop iterations. The probe error
> path does not call ath11k_ahb_free_irq() either, so the previously
> registered CE IRQ handlers remain attached to the interrupt lines and
> are never released.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: fix resource leak on error in ext IRQ setup
      commit: 8ab38bbac02298e3fb03008ed4a0227485c0fd62

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

