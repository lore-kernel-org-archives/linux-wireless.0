Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE72282F3F
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 00:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784163550; cv=none; b=LesJ+wOy8maj8r9x/PSvVBZu5fKowyOAz7CC8pbWbc0T+8ZSimrJ3HsOIcltW6XR+NcsLvIUYmLYgWg5hD3RjST5UVe0lF4XlDQrpWMrBVWERwOqJ2CzdK8qAkPvL1qLvtuz2jqa0Me8pYlmp6M12zxood+LD+2ZEtlTb+uDx24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784163550; c=relaxed/simple;
	bh=7WCmgTvezj+FpmS1E9fln81nR4vRY6G729L+61O1sNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bJ7Tp3+x+dMDLOD8Or6yDolT8cyI5o6toueVuzNlNmhJuxNtBbPzhaJ8aUwHjgx6eerl4s4U68ddzDgnti0ufkHRvxNKCqgbT342ejTuEtYA5WAIa+w8MdUQHhSOe8BS7y/vNGhNABGJp/6OTw6aHbZbGZjSp0Jzr7shiw5Gxhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kCYoa4PF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R52NGkpd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kCYoa4PF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R52NGkpd"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G0XY2X1305006
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 00:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fxSym0MG0DTsfrTZy5yY04eAKQV5OakSQtDa3iUK2PI=; b=kCYoa4PF/NvUiTHG
	6+87jHuqfpW/wdcMJteLafDiQmob/cw49hw6YAq7hUvZOwCNFjhgsP8w1uRWviTI
	KnOpag0pnRAYExClazyWzGCoQNiPvBis0M+wrUlU6x1j76cm8ZoL3Nu9Q5KpUn5B
	scF0S2pR8yb4i65bbJmobSmccSNLnttQkvM9DFh4wVX6an6uPh0zPF9c42ZSjedC
	iStyp4B7J6g6P76jvuQhVEA20JkilZfCBgS9KvExMdTJ6hGMq2bMoiZukp8AWQG8
	bZT3rRBKrqoxQTk0EpjbkbA5i6wFt+wf/JQ4ZVYjq0zh/FDEdZrHE11YYr0nMm5x
	8EIMCw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fe855bay6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 00:59:08 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c856470fe9fso2480734a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 17:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784163548; x=1784768348; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fxSym0MG0DTsfrTZy5yY04eAKQV5OakSQtDa3iUK2PI=;
        b=R52NGkpdZHWxwiAxNxC/DeAB1TaXU++fmCGDecfbpTQBs/1HUOgf7at+aPa79+TDC9
         HlStFZz9vRGQu6B4HNkag74e7a2a5JXES9R3oJUpYUQ4VNo2JMaiXYYCW+1TXLcnot8v
         U6TcmJ7ecS3tpEbdYVU3ikFyEecav9xLH5N7AKM3xc2Dl6AISnjmKbwFcqlbMVGFk91D
         ujkOF8AiiqQSlWh0eHPkayN3/K9q8dgBXEceb6q8yhIagWpcpV4isCBTal09lvaXOLrz
         fdroXHpY1mZeW7BMVKRBKoZW2vR5jiaZXNnXScBI6vJiYy1QnBZHUehRwATFnr0SbvGO
         iQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784163548; x=1784768348;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fxSym0MG0DTsfrTZy5yY04eAKQV5OakSQtDa3iUK2PI=;
        b=sStl1GBOEFRquXIV58KoO+3YwwvaPCNCLdL3pS8WmXiqkupOhMdZe6xXfcQHa4jqV1
         bZvHxuZIQA9ad5X5BqQNTHa7Ms9bIoSiNEnEUt5N4gu3CqEoMOi0U7/LBF5Dm0uKtqnK
         3AcUr0vfHa/ERAmR5ZvHZQkD7Do2qRjBVkbY/lKkpk09CvqCFjvuCikWtw8W16/xIXYK
         ennHRpxcCQdZfF33XiMdOI6SSpRhTa312R1yp4HqktStdI8QCOwHCp3z7CJ5XF6/hl5e
         buW74CszWseGHar0iwwgWn50cJq0DDXDECf6vdLvWC0eeQVA/ZytLcZB75ql7c386VmF
         DZ4Q==
X-Forwarded-Encrypted: i=1; AHgh+RrWM6hqfh29/qE7GbIv2DWZn9FwsLJV1vroH+8P8TM0ouPj7c7VhX0xe1f94cPDe55g1M6RbeUg9iqdQtBntQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV6aK46MRL44NbWpzWE9UZyIm+/bVs9dmeI2d5aa0eAzYnR7Xo
	zMXAXnMVtLTpKCx6B9jOjZOvyh+apMu17Uu80eyXyxRRICkZv48wxdE09X2TcJDHm4rk4OFrrsr
	2CZdF9wOYbYMbRY64G3fgKtk6TWZdw0Xddmg6BppgmUF4Qzev6sqdPQsVTMtQoPyOwLUqbg==
X-Gm-Gg: AfdE7clAQ5f/82PmLSTrhfjyChhgW2dfaci4vADj+bf94d880dEAhqM+9ev4/GZUxUu
	zPp0iMJdgBLvD7h0t5Qs6wFLwSCJ5irZwulSvELf9+Wet+10OEU5UXNkIb3+PIHAF7XtxeQdvKo
	I8ij1EF5SVWjvQQ5ssjiybxcUieJD/8l5EDoI0/oYt3l/e7JUlRU1fW780HSqdfG1LzCqIDB+mv
	sVGN/7Oa8TY3YT7sqhjAVi+b5K866uWG1C2KVAYcxJZxIZBmhwaAO0YqXM2EyEnhX/d+EHRRZMS
	BYfUCqSMgFMzQ/vNINBOQm9KNr4pybu3LN9JgINa3jOl4AN0tnVS4yaReAOoQG/Leh6MXR7mXc4
	lKpq0kPI5oPJ+OxcmmLOabVbWWaa0PSEi8loPZxQr5NJj5rOnh/X3zTNRfA==
X-Received: by 2002:a05:6a20:4307:b0:3c3:7dfd:22c6 with SMTP id adf61e73a8af0-3c37dfd2500mr2681264637.73.1784163548069;
        Wed, 15 Jul 2026 17:59:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:4307:b0:3c3:7dfd:22c6 with SMTP id adf61e73a8af0-3c37dfd2500mr2681244637.73.1784163547629;
        Wed, 15 Jul 2026 17:59:07 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e5306afsm5588023eec.9.2026.07.15.17.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 17:59:07 -0700 (PDT)
Message-ID: <faf48c76-373a-42c1-9c69-cfbc5178640a@oss.qualcomm.com>
Date: Wed, 15 Jul 2026 17:59:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath11k/ath12k: release QMI handles on late init
 failures
To: Guangshuo Li <lgs201920130244@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Anilkumar Kolli
 <quic_akolli@quicinc.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Kalle Valo
 <kvalo@kernel.org>,
        Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org
References: <20260715064042.1988288-1-lgs201920130244@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260715064042.1988288-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: FKUESnrmksLytkt3g2zoTYLy1MR69nV8
X-Authority-Analysis: v=2.4 cv=KOlqylFo c=1 sm=1 tr=0 ts=6a582cdc cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=pGLkceISAAAA:8 a=jDosp7zG289F-1VKxZYA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDAwNiBTYWx0ZWRfX5/+f3pupmbAm
 NjtxA+StSPk5fxRvZ2Mv0IwypVgijQxozXyawQCRqoSx3v5A8VKwFZNDtB5idtIgEYiByFkc/AW
 VVin/2OBx0nXsijFCL3JqIJ6PQUy4zSPFjFPEKOQ+98DTJoWMAMRVIzSidBgkj37ccun0oKuBjL
 QQNCIqvybPcTmAn0nIhJcmX0d8WqrNYNl8Eua4OU3pEpVUAe9nwt7lkVukIezHkFVYd2HZHsSDJ
 exLqcfVPfTpj6F4rs1+Zbbb/1vZjoutL3NAo6qGbH39j3nDbHCKD7Gsh/eK5pkOJ6xjDSK8fVXl
 aGBl9uIteePh9ivU7Tsfwo2KxUyJKpfGInXaFgjy8lZCJMyQLxQKIE8HEKGcQR4VdhpZuRzPBpQ
 xnw2GfdLx8B1sv8nN7IUouhyVnlW6NpAxr0jUDqUDK5b44lFsBJIDgRCy5EKOVBfcOs+NpoN56x
 qz+NKsH1m86vDJRiOcA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDAwNiBTYWx0ZWRfX4NoHJzeo68Vb
 cI+u0z6AQSAulFYmKQp0l6sJ4SwuCy2apALR2EWKrz2GqJqv8T/xm2r5z5u64wxoTglKhxSo3Ez
 lbU/e/DTrDNnNNqn9+zxweRFKl2SRcM=
X-Proofpoint-ORIG-GUID: FKUESnrmksLytkt3g2zoTYLy1MR69nV8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_01,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607160006

On 7/14/2026 11:40 PM, Guangshuo Li wrote:
> ath11k and ath12k initialize their QMI handles before allocating the QMI
> event workqueues and registering the service lookups.
> 
> If either of these later initialization steps fails, the functions
> return without releasing the initialized QMI handles, leaking their
> resources.
> 
> Release the QMI handles on the late failure paths in both drivers.
> 
> ath12k_qmi_deinit_service() uses ab->qmi.ab to determine whether QMI
> service initialization completed successfully. Set it only after all
> initialization steps succeed. Keep the ath11k assignment unchanged
> because ath11k does not use it as an initialization-success guard.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Fixes: 088a099690e4 ("wifi: ath12k: fix error handling in creating hardware group")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> v2:
>   - Set ath12k ab->qmi.ab only after QMI service initialization succeeds,
>     as suggested by Baochen Qiang.
>   - Fix the same late initialization QMI handle leak in ath11k, as
>     suggested by Vasanthakumar Thiagarajan.
>   - Drop the Reviewed-by tag due to the code changes.
> 
>  drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++--
>  drivers/net/wireless/ath/ath12k/qmi.c | 13 ++++++++++---
>  2 files changed, 18 insertions(+), 5 deletions(-)

Please split into two patches, one for ath11k and one for ath12k

