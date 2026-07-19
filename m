Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7224B3A257E
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473380; cv=none; b=b+nlE2Yo3NfOhqMcoiJeWfvqDrgYfrFyGKH8TvzqMqyHZdbbEuhjRFRtRT+Iu9OgTwpIw9wcXtWbKkQbYyeGF9sCVMyAWmA7GO8qkb5+peJFyg5y4mSqWv5EZng17lyppo/WhIllgxfiaoEQCjBjX87e12pD+8q5SI6dUbGHxPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473380; c=relaxed/simple;
	bh=nhs0cTRgQM2TX5BYnOhc4RVoOOZO0UckyHq9RgxyHX4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n3mzJ+DB+pe3BvMbYlmf0/TMbWqUB8+KH3IjlvVRGpZjZ/BrUkWQ2Vy8kTNTlJeXtAQsZv5T7hWwq0qlTSDW/rV5myVpR0ilCCLK4Q0McWKRAEBd/QMPVQozrQYkNO19Y77wVuxz4XwNuvm6/NoDiRNffpU9BZowVM5cuTRuhdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i8+WBJJX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aKfFI9uc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i8+WBJJX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aKfFI9uc"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JDvdeW3609101
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 15:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Fq9QnMonyLkUiObCO4jyCIbIMkb+aIpQ+1EkpngSiEY=; b=i8+WBJJXgOzBuTij
	gqMXaC+7RFv2NzgsdUIMeng8eae0brVZy5MBkO8J6pnlZjtQtTqOFBiSBDGbq/Rw
	ZXUrd8Ib7QNwO6JyslCyT0zIny9xI/xVLx+F9HA+HPGQ9ac/jgPrsWKMMAJ1JsCm
	zjOQfflnwahKg8dQLcSKQ9IgXSzgknXlALKZLiqguf+Eo6ZsiSeBnxGYRAavI/Fm
	PmUmIipbqqGQ7jkRWQLONUMvAr/m9HI7dloWPfTy6A3aqK7zLx0q5jSm8oYFuryD
	vYEwuekCah+FChsbmtjNEt974eU2Wx7VncU2AtapZaTDhm7f2zHfPWJ/Sq0wfT0N
	n0+05A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2bvtwwa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 15:02:58 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso12387678a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 08:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784473378; x=1785078178; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fq9QnMonyLkUiObCO4jyCIbIMkb+aIpQ+1EkpngSiEY=;
        b=aKfFI9ucAx6yGIMfjBJ6VdzoWoNj9htNtBqUhZl0t4P3fpczxYq4ErNSdpcq9f+ntL
         2efBXVP/B8XeO/xmBc3fCI84IWiiAFt5RHVEiZ2L53MXAStYqrDKAWGDgIqCXOXZIDIr
         YE+LoN3vd0O6HuMYf4aQf+MKyTAsb5lMZhRu9JR8LCKJwH0rQS/t8MMP1Cf00ZAO/GxO
         zqTSmiPIfU/iMrgu3eIM8oH5gRaAvMWaa0Wmz0h6qOo1PU2ckDuc79YmMt6yUZThgPIq
         fPH3IE1eoZwFa4TZ9pRWx3wHJkjd5x6XNFUkqzCYbBQQALWn0GV/sI2hp/c/rGV8Neh7
         UXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784473378; x=1785078178;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fq9QnMonyLkUiObCO4jyCIbIMkb+aIpQ+1EkpngSiEY=;
        b=HBhKcL/YAEnOoMDRShcWyYNLiNPmwGg3xGMPEHC2NCEruiSTtlUyQT7X30TnGSWuk2
         JGhkUiZKkaBXls+PxtLcygMR6Elhi4QjAmCT+pq9YKDbwATtL6023HLPFNZ736Jk8Xi0
         w3QpfoArJDIKEF5ZmNaEo/X/CYTW/rQY6m4O2kv++hic9OxG1lQU7cXl5e8uAAI5bb3v
         wF1FILP7pqyIfs3BFTg3isKhSmMH6g/Ivgn5FpTDljTCfFSXj6qmvyK7kU94hOLSXx2n
         u/f1XscuoPK2gjxX3pipX/mHFhia7gskrhsVthrJjxtkM7dJoFUqsIRgVnIr4tnEasAr
         6CLw==
X-Forwarded-Encrypted: i=1; AHgh+RodWAUHOnmY5HUoq5olSw4yVjeWvGY4CXfIekAQ5Mom6mefL0D3R+sjCaQgiBdZBfOrA8IRXcVUY16u47nyaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRTAgkVSNC44iD0rC4BpCdkKMUaA5gYretqL1/S0pSOQf1SAZ0
	v0l+T1Bl+WwFjagke0hZ1AQ4I88QmO9PDa++hpkreKpGXEQXFtZPT0GhoUVn/wLOwDxTb9NCxTj
	6iu+43awrwDqcP/MefglSgpG9nUCKPZeN2Y1yqI/mao2H/ZYuIC68w79CTiLav7b828On4Q==
X-Gm-Gg: AfdE7ckguaTm/BS5FugrbBw+Fdlk26t80TX9nkp8YrtjFIIyIXDr16rYOkb+/PF/5AB
	/d5BM/yIaatnGvuADeXN/tY7rQ7XE7Nyngr8A5zkfNwHmGbKGSkgG78Q8QWYTIiXtJ8QfOtjPa6
	uGUDLQiLuF4qacAxyNBF64MFEil0izfwQigu3EKUVDCSCdFlINHeumb7Lz03RQsJ5ejNW1JWV/G
	A+k790SRnybTAvOzRqjHCmP2JAvs8RN0WmKaC/e6kxctGE5OpYAwI6mOjuuZnjIgpwBZ0hJE0K2
	ahc+BMTmsOjs0TPfdfUkF+WymXJRNkaZDA1mbGnn2lBN+c3MQFIcc0hTh09KktZ8gM3O9/k/WX+
	TTUG12TPNuY3PnSLkIXtPYvPJCwwuIHOUqGkQOVi8lwmizj5C5MMPeGQ=
X-Received: by 2002:a17:90b:58ee:b0:38d:56aa:6f32 with SMTP id 98e67ed59e1d1-38e4b588b44mr9985534a91.38.1784473377716;
        Sun, 19 Jul 2026 08:02:57 -0700 (PDT)
X-Received: by 2002:a17:90b:58ee:b0:38d:56aa:6f32 with SMTP id 98e67ed59e1d1-38e4b588b44mr9985475a91.38.1784473376951;
        Sun, 19 Jul 2026 08:02:56 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429fe4677sm24638707eec.11.2026.07.19.08.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 08:02:55 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org
In-Reply-To: <5aace954b6ef5c42017b83a1bffb859618e9498a.1784013180.git.christophe.jaillet@wanadoo.fr>
References: <5aace954b6ef5c42017b83a1bffb859618e9498a.1784013180.git.christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] wifi: cfg80211: Constify struct cfg80211_ops
Message-Id: <178447337569.3680261.4077948974065934846.b4-ty@oss.qualcomm.com>
Date: Sun, 19 Jul 2026 08:02:55 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 11k9zqTbFDOr1lwBJKmauBmwwWQ1N-yv
X-Authority-Analysis: v=2.4 cv=EcH4hvmC c=1 sm=1 tr=0 ts=6a5ce722 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=9dWoPoYX7bWxMb2dZPYA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDE2NiBTYWx0ZWRfX5WQwm4XyIyHE
 R8M2L61/h7YCxlqPQlkFT57pJRQMvtcQJck0FxyTa4QKQaj3xNJuQxgGnZIgn9nsjV9hiuCdtUX
 g/Uqp3+UaOqvqaC0SZ0YdyPhZJBSGj1OBLEMd1leqcrcXWugU3FzeCl+/Dh43x3kjwOasZyuBte
 hGYOvMrbL8chPsYXUWMUA4inLcqpOfwFW2SpumKxt6weXA7EUvv6XiTW+8ZugWze0YEYnNfp+7e
 l5PcXmJn9cEXDdX+41iKQP54sbjHPuSkqEJS+/NFJyy5jfDj68HA/FxA8qZao+KULVXbtryk3oG
 hEofjMKs/JRVCo6+V4PKtw5eFQ+XufSkS9UjfwRXQLY32UP3xdN9Y3YGMuWKtYQ/LOJmjlokGlY
 H5merKhhU1WKLD3F8FpqO/79uhypp/UU/pA2AcyZAFwc0BHdQE0lM4beIzNd1uoAnv/v2qnT7W2
 NQMwSef3sK5AImhhR4w==
X-Proofpoint-ORIG-GUID: 11k9zqTbFDOr1lwBJKmauBmwwWQ1N-yv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDE2NiBTYWx0ZWRfXxTCm9qIxFF1z
 zUq0frP6EL6wCTvWSRdHrVYWorny54BCaSNn4Ijbnt6aB6rq9e01ATV3ml8/4qr+q4flL12ikBO
 JtIQWQyR8u+J9xTLTiX/jbjg1dTDdeg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_05,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607190166


On Tue, 14 Jul 2026 09:14:00 +0200, Christophe JAILLET wrote:
> 'struct cfg80211_ops' is not modified in this driver.
> 
> Constifying this structure moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>  143726	  34579	    192	 178497	  2b941	drivers/net/wireless/ath/ath6kl/cfg80211.o
> 
> [...]

Applied, thanks!

[1/1] wifi: cfg80211: Constify struct cfg80211_ops
      commit: 612701854b588759c0df3094197d415869ada159

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

