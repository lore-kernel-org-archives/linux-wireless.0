Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994664;
	b=317siabJvb3wA91ViuNE8f3C+RNfQIUxL+Ptgs+76gaUBFutwOq8YXLXxYQi3qLa8Ij7
	 YfFdCtWqH1kL+klifgC6WttIfwsfGPXrxwXMgMqaTOrWeNoI1Vi8B1e500E1QzNPfjmi9
	 +Qa2Acla+/dWQP+denmZEUxe2h1VxfW4wYlU+CRP6J7DG7+wk0jbmr0zGSuSc1k4zvpzm
	 D6ggYsnB0C5ftHR5IXuWZXbAUPOwdJFsVaTs53aTCZfpILf84RXBxtssYTJnk3aby3kJu
	 tsPHGBadvIAPwHKt2+6iXjvIurUavBDL8XEAGSyfqEUCj0K+a8pgaMq/Uh6uRFNAjew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994664;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=E4gxzQnQxSt/e/zJNl4TFEc4jblevNCbaEBBHPWrVV0=;
	b=p/wsgTmcnLo9gpXgRNjdviDqIMDMB0cIhR2Nnx5vm/YnVakZBMbSaa8d0ZJtP1MX2FXo
	 WrHwgMbr9VgeqzveHHGk0irujSjK2maGzgBRCHTo+6F+CpJNZ/JCPGQzUH1a3we1SGZup
	 sddjSeNaW4KMiqki2WbNNciGFSWxVPBlSTgL7cURbk7DAWxjC+agmKnJYro6cpxTul+ni
	 ZLp4+OrR/xghD3Qo0mE/sK69giW7aHEZfaurGhKAiEuPYTI2FQ2qbG/mPeDSyDJw+vHPh
	 NqcdQt/WdPbPvzRbLL/Gdu+ndTpwwE8tmBsSa5RxLhjlenYFxQiCLGcA3Jea1Fpdeqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZgOAUXCI;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FjfV+lE5;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32735606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32735606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZgOAUXCI;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FjfV+lE5
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4aqHB1181738
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E4gxzQnQxSt/e/zJNl4TFEc4jblevNCbaEBBHPWrVV0=; b=ZgOAUXCI/uogjmGf
	vE6Z+6CTlJFkyQqKh39VbkGSrr3a/Py/RL4/zXanDlb3ntpzWraW98/w6xkP1gOt
	h5UxUJGz3xyq282OrCyHzWS0Q5if35XmO/r4vJ6fJNBFJK082TNzyggokOpTL7It
	DKwWnGHIUjc0ORZlejGWlEQX2QVcmVDe27BDZJuogN9DHww9KEbIkNGQBLfLWeov
	lY3RlBANGmEFjZ92KmV3qDSVMRbdyTzw41q1mBbo0mdPAM+a6kuyTLUNAonxrnyd
	HZ1rPsFNWU5+XuXTPyrXhkQ4SawE/9rIhtx+PAIbtPx1B4eRrEN1CF0OfLpqy/HB
	ONkEKQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgn27w04s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:04:23 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35c3c370b17so4899110eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 23:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792994662; x=1793599462; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E4gxzQnQxSt/e/zJNl4TFEc4jblevNCbaEBBHPWrVV0=;
        b=FjfV+lE5NHJhgUQZxwmVRCxbNDVBUL9ZVQ5p7SR8SjaHygby+aUbHroX4racWgZhVP
         qhTZn11zz8uj1H643Gzc6bxcxK9hdXxeS7GguAJi1ZQBQluNYPPtP1lISFP0qo+jctwl
         hvI3/s9hbTgwrRlNUvf1Xahfy3QWMpplO93s6Gda+6pfJRISOsL94e2uPVilw4UQTaVN
         5hSDE7TMWBD2+EdYBunzHzuYlNe3dzZnwf0WQcwZbREji0AVU17kom6WX0r1h5IeZlbf
         moeRR7oMk0Nrhi+aZ1Mnx+ErNZ6yItNbvmai5WZ0En0Y6IHqs36zVt2Rc+8DKJqd/ZGR
         W1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792994662; x=1793599462;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E4gxzQnQxSt/e/zJNl4TFEc4jblevNCbaEBBHPWrVV0=;
        b=k+HltD0hCzPl4E6yl/UXTyuzZGXOnys8W6mycFfWmcpM1xhLYVkzH4u7e8BSBV5Z1Q
         DYVFUmxwdPXbkMoOXdk0cnFwyd7akr+nWfibNvfl2Hg7xsxib8xMfTyKtaNkAjOolUEA
         lwaCkIiquXkHVV/6jyPgtAPpT+ZqG8tI45TJr0Ey81l+2q8rNnXtrrsM71BasnrLFH+j
         DxDVVV4PgBSJUdCcFWtFlZMuC6JjSNPXW3OI/5U66BuhruKrnSjuoTKr2QyqO6vbJz1a
         YRt3N+ptzoCIkFubgiBxd8dWgyChsesMczGrRsMmuQwWIP2Q5+X8Tu3BBGVmwOXS5O7A
         4YgQ==
X-Forwarded-Encrypted: i=1; AKwUvByeJnJA7I/gS4BeenjBY7pBoTpKGJ0CUpzJRXVjKXHXaiREQ/bvmjgoxADr/EL7kIi1xU9rsy+Dhosqdgu5Gw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIXJMf4JLUQGyx3F7ataF6/+syo0vVuctV+xen0xNg0w1w7Egvp
	8OSkhmlOaL9frlDr1plQnWpnb1k/EJDAFr+HjuBDYCS7d+GWTBKHjXGFgbg9K8gHgD+cME+bedv
	YlI3wscmjI/21dLfmS4wJVk5e91VFzMlMuuxWt3GIWhh2eqLDp34dFD9dWNmSEKkQTCt3zg==
X-Gm-Gg: AYBFou2nJgcNruzNZ5KxnttgzN6f+PGMsQJXlLDJJUpOrtR5hwHy3uuDFK4xVIXElLh
	yqQ2pID7SLUYvLNG7WWAGgpHCTWVdmea5+3bdKN7cLwfJjkFn9+LWSk6rgmAVbT28W2anyz4v+n
	t08H8qyaXIhe1eez4kMKX5NQDDhygUe/XbJqelCz/bQdn5whd677szZb39f44WZugO2wav/M7jd
	ATzcDP/H9b6e2yATw0vjSHEDyUtBC7AZdzpsSeLLV9SAtdh54oLQNsSJb8hrL9e15zaqEoY74py
	w+U6uV3RtiZmFNL9O5SZ2EL+rTSTyKPpt1zGCwiFjnzjtZYlslFktyTcmR/FeYW4iemHsspUAZH
	CQKFa19ecdtd1T5RHaq5WAju6MjB0RK4sIjfgQXHpi3YViwY=
X-Received: by 2002:a05:7300:84:b0:369:2f25:339b with SMTP id 5a478bee46e88-369e849503emr10171396eec.8.1792994661903;
        Sun, 25 Oct 2026 23:04:21 -0700 (PDT)
X-Received: by 2002:a05:7300:84:b0:369:2f25:339b with SMTP id 5a478bee46e88-369e849503emr10171347eec.8.1792994660976;
        Sun, 25 Oct 2026 23:04:20 -0700 (PDT)
Received: from [10.152.221.90] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d8a690sm21955696eec.12.2026.10.25.23.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 23:04:20 -0700 (PDT)
Message-ID: <63e5ab21-cd8b-463b-890f-4c3c93bdab68@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 11:34:15 +0530
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
Subject: Re: [PATCH ath-next] wifi: ath12k: set MSDU payload correctly
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20261020-msdupayload-v1-1-1ca9a5936727@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=G7GJgNk5 c=1 sm=1 tr=0 ts=6adeed67 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=grpZdo2CoZbIzhDbOCAA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: iF9avvuJjQm4Lao61a82tW_UsgIwzMbf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyMyBTYWx0ZWRfX7VdiinvrZ3+X
 NVZ5Lw+RD1Al3pIYJleMkRWVKlBMXAUwsf+KFqlYgDASQqjwIbQuToVubtissNjCONOdG4I0A5O
 V/HcwVjyCnjjRW7fEyXRvHgTWozaAHM=
X-Proofpoint-GUID: iF9avvuJjQm4Lao61a82tW_UsgIwzMbf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyMyBTYWx0ZWRfX2DVvThDup6Dk
 3U5h0lKCf7y+wFCzmd5FHyyo9bbs4Ff4pqgNLTvwFeDe1zbWxzJsaScc2C+FBB+6gDl9b3Su/aw
 ex3H/cOVIfD4KvAQc5vW8YD+mXorx5jgXzXUREdnO4UImDzKSgpFAjPia1l8gnZe+ynZ02VoRQk
 2gD8xO9pHsvCK4p0bhj7Qh3vmZENqGVGipMd8nGQvw7xoOo0CrzVQMJjA6qpNwodKGRtnaZtsff
 JwklykuNiXL1zTeWZbaeOC/nmE30n/SZjmTPUAFR3k8NPJ2AfMbAmMeff0qEgbWlr0U5LvgLYkT
 gcdz1Ko0uMsrq52IAnIl+xcFbQVmfIOd57hs5+bcagCTPhUFHbfRNAstApwsBDUCOP4DtRtj7/k
 jKXlYOC8ys9Vl2IUPre6q9DSCfD/FrQ8Jarslc26haCpdQ9LdnJ93/JTSE9J5dGULJa6zRM6HPT
 MVmvsWNc9y7Cr5WzLCw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260023



On 20-10-2026 13:22, Kang Yang wrote:
> ath12k_dp_mon_rx_merg_msdus() mistakenly passes head_msdu to
> ath12k_dp_mon_rx_msdus_set_payload() while iterating over all MSDUs in
> the chain.
> 
> As a result, skb_pull() is applied repeatedly to the head MSDU, whereas
> the remaining MSDUs are never adjusted.
> 
> Pass the current MSDU instead so each MSDU is processed exactly once.
> 
> Also rename the helper parameter from head_msdu to msdu since the helper
> operates on any MSDU in the chain.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 1cf514fdc790 ("wifi: ath12k: use different packet offset for WCN7850")
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
