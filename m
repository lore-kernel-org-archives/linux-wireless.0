Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115566;
	b=NA78x3WgL5z0a6JVdFalelvq3A+KOl4dITURoA9oq3HE0YKIb9PzsHHF1RcpPkapCOls
	 tB1yqFCVIQPEefKIwMoKRYYDCZiYvuQNq8hVhzgpoYRqlLugeHPywzERL1ckFOYQs+j4K
	 67ATM9XQ3R2JxBYdSTKdOhsGUobWvNaCxZJo9PTWDqDKuSB74TdyOriz/VjpusjWr2/jh
	 mczeGO6yLGCMsyNb6PMi9ZUyLwipUvmzhhoNC72cxqvkt9Ruhxy1pOpVaAjJWUeyaCV+e
	 GfeR88jCZQIAN0Kgz8g74PHnjJAjU6X8wV5lug++1oYiKyxDtaD70/6MJpl5aScistg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115566;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=X38EJh2ju+IofiObRyhlPmCV4WP42LFOQnnmfYLHgpw=;
	b=Iv1UqbDAxRWuToajKn6RM9ImfewEeooybW/kePt9Ygx49922d8BCGv8UfEFvTuvQ2fKd
	 o/HjN0NZ8mJv1TmCE3NRJ8m7LuCydKfziCrL7/0to1RPfWFYsQxo7/striqbNiPgx4WNB
	 Le82mu8LdoGQ+rKNF5TH5t3r9yf04SshbvcncFflMBNizbGpbfk5IglOkWPAHgFoUjNYN
	 /wkBblHiyu6RwLs6mPLyjS5F7gOXFvqmY6487EulFBTB32Px03n+Jdfvu/uWausW0HtHt
	 V6E3/+L/S2it6a/R3TWAD++0bXqaQ/F2Hki2RSktZ6gqXg9Tsu7FG+yEtQUapA+O/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BOiGqC7J;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JRqBhOCc;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEEF606A320
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 15:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FEEF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BOiGqC7J;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JRqBhOCc
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RFKwXG2600883
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 15:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X38EJh2ju+IofiObRyhlPmCV4WP42LFOQnnmfYLHgpw=; b=BOiGqC7JjgxF30yn
	5Ca4vRnTTOQOfyD4zxQd1iiBRPDHCKwDHQPIw56yR0IOV02jW/REqNkSWo324nxp
	FqrhlX9NsVhx8nfzVARsjlmQJYGTc1UqAClQtMGCdnPvh2dWbkUz7QPhG736ZpY/
	SXkxK2DgvV2yc30hAzk092/DdGvUEdHld652asY+l+e/wHXVMkQZo0aW8Vod/bxw
	ICzLs8MVKJtxvBRSHn1ENLBRMKeg5TdbgazSvdkRnT2Dc7jUmmXAXiKxYGFmfEFH
	9DiFgIPP7Mh5YasXyRWIAYUzuWLBxrzVntOSgs8f6rbNFg3n3wdl5TrqBI+HsU62
	R3OdXA==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjst1hca5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 15:39:25 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-19dbbe4b1d8so2620655c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793115565; x=1793720365; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=X38EJh2ju+IofiObRyhlPmCV4WP42LFOQnnmfYLHgpw=;
        b=JRqBhOCcL5FhfWyfRj7WIgH6pGccig3cn+J0NEw9wshEH8++qsDe/w1UmT5G18SRyz
         svqp2t3smi8fAxTJD4QsvSqhftB/Rd6VXdLa1P1bC3+/mFd12uJBXbqD8Mr5crfAsraO
         QuunwmJcJgijxh5/go24t8vQNfjQwvi3YY4L6koGx9m3HKGhS6gI95UZm1/Xk60zbhlX
         drHbrL3Ka7LAI/UDv0Gno9vX7LnlPNJjo5kUMiqw0pPA/QHG76H7RIC8Z8s2e5G2J/Fu
         7ZlFPi80wYvnrdBrH0NdL7QyJITFRXJtrGMUqGCS7+I+HjZQdUpWFTPH3UhnfEEVUBZD
         pT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793115565; x=1793720365;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X38EJh2ju+IofiObRyhlPmCV4WP42LFOQnnmfYLHgpw=;
        b=wrHE97GtlRfAckxA0QeoYV1TG0x5eRxeGG0ZdLY1bvfNwlxF6LmCHzNBoooD6qqtXH
         +99IpkHPl8Pjx4VJp7MDADdDaory34TONdXBnoM6jdAt8SChN7KtlW4fjcSp0qbYkPi8
         2Hgj5hiCOn01mgNAsQ8DrW49yZMeMZuvJ1cF62SXpiZdFrkOp7LKPZoWpFBZ+FOC7VrQ
         LJhapW5EYZTUF2yXqamkyTuURy45VlrqCNUY5awfM4YB4M/3kATZjBXhV2PKWVkjmNLc
         ppn49Y0RvFT2Fkjdrav3oykm0fSvCjx5rbnpaA6fpR6e6mQe8t+3zNcWSJi4CuDfBHPR
         vS9g==
X-Forwarded-Encrypted: i=1; AKwUvByZFBHxZVTeJSgNDA8TmfBJ3FolsNOTF1THQm3xBzjylw9Bc8i00iUMrwVP0xDGJynYeiKqlxySoQVOWhnqWw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK+pBahqMPheN1bZwq5ckZwa6hAVXb2xvDA4VRvJLG41nHZWzMf
	LMUg8xw3IlzCJ8nd/lERoUixRXnbd9c3qwVm3ps/51Ot5nfCwYxwaMgY5XUF1WgWXPJXmmCj0cR
	vwuhRbkSfDg7kJE0Ikqwh/zFyee13rAdDmgSlMxjf78NVFHXBF1qmIUEqyiwy9RdHBj/hFA==
X-Gm-Gg: AYBFou3FXHUyLqfWGBgssyPWSRuPXWwEkZtjO9TzoJ7XMPtNWB1cCD1ojy9KLXHh4jc
	lJAn+V0kZh6NnJOs+Pazr/XPI5DvqPWoKPTNeJuHzWQyTa7Fjnmjxd9C6cLgoNh8Y8YJ9Cg+ndy
	NEPJWWjcThVzSwGjt3IpeLSPjGlvzUBznRq762rziV3cMLQuYijpGf81TJEtLOfkQgMdbPZmXik
	9lEzvAGfIywuX/OtJdrOqlYsIy0zPYdmpwjEai6Q3cCLnpitXq4TtrxatCO3Dyo4erZ0hrphV74
	2+b1r/48g3SI62yJIXR1TkhaVmY4z2W/PVgbZTATncbSnfISZj/qujdjcIdam+q3r3ZWuVV7gAs
	FyOgSNDsF7dOOPDyTt4SsEXS7qLVUotgvpa1IOFj4GS4=
X-Received: by 2002:a05:7022:43a0:b0:182:9071:3249 with SMTP id a92af1059eb24-19936b55bbfmr20976576c88.30.1793115564589;
        Tue, 27 Oct 2026 08:39:24 -0700 (PDT)
X-Received: by 2002:a05:7022:43a0:b0:182:9071:3249 with SMTP id a92af1059eb24-19936b55bbfmr20976528c88.30.1793115564010;
        Tue, 27 Oct 2026 08:39:24 -0700 (PDT)
Received: from [192.168.11.106] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19886f790e4sm33278121c88.0.2026.10.27.08.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:39:23 -0700 (PDT)
Message-ID: <c1acfddb-2132-426f-9a23-472d8339dadd@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 21:09:19 +0530
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
Subject: Re: [PATCH v2 0/2] wifi: ath11k/ath12k: apply the 160 MHz NSS ratio
 to the radio
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <20261021165138.388593-1-julius@bairaktaris.de>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261021165138.388593-1-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=HJ1WhYtv c=1 sm=1 tr=0 ts=6ae0c5ad cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=3nNfWbzjcN_1ptO5P9IA:9 a=QEXdDO2ut3YA:10
 a=vBUdepa8ALXHeOFLBtFW:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: erdCmTLMvmKP3r03QR-Gw_6VYl7Ylqyg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA2MiBTYWx0ZWRfX/gJMljk9s+Ho
 whY2/YCY6zTKyJ0cRJiqA1f0XiNdngYmRMjL2LPgb2DRSweGAShJlSuww5sRCU4yPM+ggU3Jfhb
 LxaCQ6zN6AEagB8dQvS7Tw3y5pQlhts=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA2MiBTYWx0ZWRfX90tzHKNFYSBN
 eE7oyRkcGXBEg6KnRjRpg67QTtb8oRrQgG9eay4tnIejPjzp8X8a4PBLDGpVC5BpkyYeZkCrKJP
 EqlOz5bhU8wxeu7GPTsZjIz7SHCr9oC/Vvri01jk36h3f7Oi8aXdMygvP+/DZVNZtUwVSchzxLc
 47K3qlsEiWAVa2+OI5WSIKHLVPTHF0oMOxMCj80tvoRYuiUnZ7ga2n6r/O4cb0zCupiEC2nKLWO
 8VjJIKiCyGshaNvrvJ5LcCJvZQrFQhgMwnhrKnWboTRVb66PNzFMsqSr+NPpu3C0dj7bI3kDmpQ
 XJQd+oh+Q3+h8lajRqdyxiMFqQVXc+vYl4D0Bj5n2K+jBCDWdBtEXSs+NtBaSDiZxtank/Env7R
 Wo9NZWmk/nFYGNBt6ySBMJWiqcT8/rXhc07GiMxaruHxHYBQu9LcgmdYEo6m8DsoI+/uO4hosfS
 Zz+DRY0hPmBdqzAE+FQ==
X-Proofpoint-GUID: erdCmTLMvmKP3r03QR-Gw_6VYl7Ylqyg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270062

On 10/21/2026 10:21 PM, Julius Bairaktaris wrote:
> The firmware reports the 160 MHz NSS as a ratio of the radio's 80 MHz
> NSS, but ath11k applies it to the peer's NSS and advertises every chain
> in the HE 160 and 80+80 MCS maps. ath12k fixed this for HE and still
> has the peer-based calculation in its VHT path.
> 
> On a Xiaomi AX3600 (IPQ8071A, 4-chain 5 GHz radio, firmware reports
> WMI_NSS_RATIO_1BY2_NSS), `iw phy` lists 4 streams in the HE 160 MHz
> MCS sets without patch 1 and 2 with it. Patch 2 is compile tested only;
> I have no ath12k hardware.
> 
> Changes in v2:
> - Add Fixes tags.
> - Use the plain Assisted-by form from coding-assistants.rst.
> - Add patch 2 for the same bug in the ath12k VHT path (Rameshkumar).
> 
> v1: https://patch.msgid.link/20261011123631.1664734-1-julius@bairaktaris.de
> 
> Julius Bairaktaris (2):
>    wifi: ath11k: apply the 160 MHz NSS ratio to the radio
>    wifi: ath12k: apply the 160 MHz NSS ratio to the radio for VHT
> 
>   drivers/net/wireless/ath/ath11k/mac.c | 24 +++++++++++++++++-------
>   drivers/net/wireless/ath/ath12k/mac.c |  2 +-
>   2 files changed, 18 insertions(+), 8 deletions(-)
> 

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
