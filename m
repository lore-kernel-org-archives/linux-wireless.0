Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C63AAF46
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340013; cv=none; b=ecs0ZT7W5T7ADqLG3yksgG1qVKsCnSA5S/DTD6RBUkFCZ8m7tPACanV77zGoUAf7ixKR/b/dGdCAG1myi4HzFiMHPCqANBWfzG9q0gH97GGH+aANWYLYWmKk3kMqiOUIp+CqY+19YpKaH7PT8rBJosdMP6+J8cc91zAu3SE4t/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340013; c=relaxed/simple;
	bh=El+1fI8XTHDf81KiNNEaQv40VeSZPjbo8Tw/ROQhe/g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mVfrDO6emf2k4iPE5BissZ4qWqnbQO0XLJWmqgUtXWDVb4Sh8mUteJcodyWD0/lL9aWiu4UtLJjMtvIJ1f0oJiEeXeoJR38O2C33nrkQ9mgZsML7RcTUMmFgDlapbP1ixr+5oqrsv/ZuHwk9wTyZnIp7anKWHKWnPfe6DV2pLr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j3ClpX3Z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ifg6pi69; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j3ClpX3Z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ifg6pi69"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF3DeC2593196
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TIzR5huQxeeXpvJuvDI07yDpu7ARuYqyzKtVILpu/mY=; b=j3ClpX3ZXN+9pdvL
	RAqJsAHVGoLCndYJIc6+2KNWXLUchYx8SA5EkdOd8f2UdLXhMuT1BSclfGFhyJ7S
	qdDiq8SClJsLez0xyggArAyUNAwak8aXNIEBuVwOJ0Xzh2uVGJwt0gAe0y6Nsfde
	zXKseC+6wjsWg4rqO4f94bXidCqg96Q2SPOmEgYLS527kEMinRBQzflRlTGng6De
	X7GkVPQcPJ/0+nvviFm722FVTgKI2kYCA3P7PWieMrdAC6TqofhYfFC7F028M8qg
	GpL0lXjXtbSoHNAw4JIDv0+I2ZhLgoKq/mk87X+9/wQ+5IPWgKrK5c6GGCscE0vT
	WBXzAQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqke08ev4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:51 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc86a9ef97so21898715ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785340011; x=1785944811; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TIzR5huQxeeXpvJuvDI07yDpu7ARuYqyzKtVILpu/mY=;
        b=ifg6pi690AqtJH2U3ZXQnQnkvBbk88Ap3Tn3xdSOH0SxR7nYBGj4MNyN9ePzqQRh54
         gDlrzw1FJzLnZjFHmQOL72FRbAKquGGciRW2FcDb4nKr3yCbMFYFtkDWOZoxSdxxgUQg
         vrjKMXsfB6//nBNCAA3o2fHJYZ/ZxjI+xzVCkqhtUbw4MFm1aPCtWQy/wbOny24JrrUj
         IYnWqjE95B/4l6cwi4Mc+OfEwWufvIy7QXH/7rzBor3JPUJssynESdJFmJT1n9EftqhZ
         bNe/zBFqb6lCEncmQ8yP7jTjit858fIr/D0mQjYqYPsSEJVPzEmxi30c/+WZq3cKEd7k
         6EXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340011; x=1785944811;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TIzR5huQxeeXpvJuvDI07yDpu7ARuYqyzKtVILpu/mY=;
        b=hhx4Bt3NVgXeFrmaAi1DRAJsLDO211AUXvv5nfnZ3FQVSIDBUtrsnvOcmMC7G+TO9s
         ze/kPZ7YUn0KVNWYaz9hcLbzwQWnTZOmenRiI6YmMzv1pZ1zPArpQG4vOIVQAUMH3E3u
         YC4XdJcvFnjfPN2wjJjaUJeV04GLm+Pa6/vKcm1FCzQMdTnKhFThahCiMAUDe2Ca4Trj
         71X7r+9jFBMX85fKtD2dwOyJxuCYTyYy7xkXBl3cCwTq/Stvw4yHV5w5yA5kyve78Pum
         AMqAQ2ZMa4KotQv5m2lg8Nc8yXlDNJFEkg6tyn1DFw2jzPNrtjoCMZL+W2IVBWOG5JL0
         xIDA==
X-Gm-Message-State: AOJu0YzJ2KHuXdInMkGdJRMvYgARRUPBy3fedlqZqO7b84c7qx3+/NBw
	Gd5QcKnfm8gft5Pia93G9a+EL3BgNIfAp18PvdSARmTXOA1TTA1oR6L6FZEZita4+j7ca0axA9s
	a6OCy4EwzBZDrD3qq8Lj+bZEYE13svrdnF20gdIbQZ/n3u3Lg8yOAFB+RxtObl4CZ4gHLQpCA6f
	v8bA==
X-Gm-Gg: AR+sD10qX+80OY+VHlA3f30S5JE4wcKxb5FjP9NQ0wvkfzO9zED9TMNmz+xkWExeMmq
	hVYLzJhG/3QktjDjXufNjHRQeEi7sax6pZDK6LogBkbBlMZmwOHcr4MQcb+VfupiLAS/BU6UJUg
	eN8jyfhLREDHI1EfUDLMbQRoDaWRrJfOdNCnPswZbEJktHgWqu1Y0/LhmMfCe3CuZg8ZGz1Yh5D
	jZvpngaq2prOZCXL5QEsjP8+zYn8/zjsXt4tJZAUyS7Bi4WC+ujOSJXSJQn3hvJIbgMYAt5fhY9
	0cMXEKUTT3kjCN3dmPjbPd0KgUc9yvaeQlyMzYzqKodwMpr86DMZq0kc9lb9qfu6gbcXOovPL+e
	Gpo2aS8kzlm4WfUeVYUyneu/2SOtXLxVLRgMnBpMLeIUHm9Xjt4q5yk4=
X-Received: by 2002:a17:903:1ae4:b0:2ce:8e70:3210 with SMTP id d9443c01a7336-2d015c2ab52mr86647765ad.16.1785340010601;
        Wed, 29 Jul 2026 08:46:50 -0700 (PDT)
X-Received: by 2002:a17:903:1ae4:b0:2ce:8e70:3210 with SMTP id d9443c01a7336-2d015c2ab52mr86647495ad.16.1785340010193;
        Wed, 29 Jul 2026 08:46:50 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a76a5bsm13577185ad.35.2026.07.29.08.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:46:49 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: add MultiPD support for AHB
 platforms
Message-Id: <178534000893.2826154.6954370843674398249.b4-ty@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:46:48 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfXyamfT+L9u+Qv
 VwVhyKe/qqXyzZHex9DZnXGq0haajBXMhIM6OQJu3fB4nsa+kYjq2UYvhwXwDxywhljOkw4jLPX
 lBCwau6kQs5sErdjUKBHEC9sAypNYHkKV4LQ1Cx1oAfpgaTRU61wG7og92iDAjAT89s6LC9AKxP
 yke6I+p81y1pDJ2JNGYjuFAFPLF9OVgmhHnbAjKjxlarKC/jRoLBNs3kjHwxhyqhXy8BO4Pm8ap
 cGaboTzlNLb0b/xyYs0fbJfmtfT+LXf+xjMW5XLyV8ENhjgc7EhOGooCgUI0GFDkl3L3owXTgMA
 yucQWYMz4ERgHVEy8R7a4jllfI6NopBJm4fNMCQD2HDQfGLB05IqHwsbQ1g03mco/wh4C7SMFrm
 9gPiDkB8iqVGZqcHV7nmAgWmL15HyjifkZP4GAme6fmn6ePfCPGj47MSn2CztRgW4CNhLoX0Sn+
 ZYiPSYO6goBGx59sOyA==
X-Proofpoint-GUID: 9VeBISF34IoQJnDdSbX1iqeGytzJ3hjf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX0tBQyVluCwOU
 wHi3TsEDa+T4Mo9zKD9dTi1ctUdV4pqZ3Se3mIr/0RnjLca9Xc6IfwSG230rWyrXzTxSGBdxChh
 1AjRZG4bxaJ0i+YOXRnqypf+QinDya0=
X-Authority-Analysis: v=2.4 cv=ONYXGyaB c=1 sm=1 tr=0 ts=6a6a206b cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=d9bybJ0-G2pII4xQ70gA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: 9VeBISF34IoQJnDdSbX1iqeGytzJ3hjf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290126


On Tue, 21 Jul 2026 12:20:36 +0530, Aaradhana Sahu wrote:
> On AHB-based MultiPD platforms, multiple UserPDs can share a common
> RootPD. Each UserPD requires its own firmware image and PASID, while
> RootPD resources and services are shared across all UserPDs.
> Add the required infrastructure in ath12k AHB to support MultiPD
> platforms.
> 
> The first patch introduces a platform descriptor to keep
> platform-specific configuration in one place and provide userPD
> mapping support.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath12k: add AHB platform descriptor support
      commit: 96f46607bbcee8aac00c4b5a1213b7d82ceee36d
[2/2] wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate operations
      commit: c6ab3b1dfa3e62dbf42c66121037de460a182642

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

