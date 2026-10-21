Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601368;
	b=j2SJqfJ1Ggfrtzxe4+L9OadVr1Y3xS6C2p3aKidab0CVafygPredJMy4i/U0b/2wFO8C
	 FtmSCjy5DBgWxFfY4dQDtzOUsc6z+Q2f/ezjkPiYBKUgGtgVHZSLWVMIc/X5WiUw/Q6IB
	 TS+g7gWl4tAURqh9TLLe5TwRUtM3fchGswmCN9t1n4doJ2z9bB0O03jGG7AXIlrJRRBGl
	 O+JnBRyhqPBulopRNhiqD4lgOaccCKqxOwNfZJZ+RH86RZhxR3Tm8Pqxo4BspYisfeYiZ
	 JP2U233LoyaZVjhGMm0SwG14JZKctOQ5QBFlSB86kAUGlIHuTi3hQICqQp9yW9tDV2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601368;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=aScArLj/kav6iD0/o6beXEYzxhtPHu8K7/dEbQLRbs8=;
	b=iZWt0SM3ApMx45cI41ztHJVxP3cEoWGv1TC+y+Xkdzvp11BC1xLbJ2Cg5hXZHTyxe2FG
	 rC1rLxp0eQenf7fl+x5B3w0oCyrmjEwvGj+876MijzRv+UPD+UJS2cPMkgz39qtLkDagh
	 KQUB+1G31C5+YuA8RmVyKvEqlFHjKEhrj4d63nqyTE6c4JFnaAM8Pnr/+1CbzhPE1zhZt
	 k7dmMbMqpH+540oLYOUOUqk8wY+djmbZ9H9vtYZ6gmH9DKKhR5Vfh25ZbyipPTlt5gFt9
	 ShViq9NRagoa6iJyUSoJIEx7/sXwo1Yms85GBrBo1/+K8eTLxILOXYaRn6XMonu/L1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=goC+a4OQ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RosBYId4;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4E606A322
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:49:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FB4E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=goC+a4OQ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RosBYId4
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU19B4158405
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=aScArLj/kav6iD0/o6beXEYz
	xhtPHu8K7/dEbQLRbs8=; b=goC+a4OQMFZvZcJVwwGnrmMdn+Hw/jb8LweDtqux
	Ymthk89zZy8ibRIh2OsnxcuKrtrteBnDQahcx5CYa18x3UcZr7yyPQCWwzPt492p
	T4YwA/ZJowbdD+/HjUTLfXtZbZqN6oMY5kLnanhl9nydCQ8gFT6QbLEOUrTdKdKZ
	IXbxj4mkUZfhTNSqFtMfIKpO+SVuD49VXv76OCFtZ5BbtaJc9PbHBSdTiKYMNUwZ
	OoHe7unYesBmOts0ZNBgz8Aw9214R37v2egEXSs/jwlopYBHSmEKXRaXxOxOQiYy
	cpWgSr7P6W2FfurS3kYLgKvk+TgBQCB+fw16CdWXqluFhw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hex5q8xnc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:49:26 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f1f2fafeaso137324485a.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792601366; x=1793206166; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aScArLj/kav6iD0/o6beXEYzxhtPHu8K7/dEbQLRbs8=;
        b=RosBYId4ziubYTkwmjO17n/xYu3RJlRoRB8N+PzCJ0e50WG0Q8fuuesLpSvU69CFb2
         MgBXSAcIzj11wbiGgVjv/Ccr0YMFp/5EoHZWYVvUFUgiwADEmvmxpw6SsYSabXqp8j9x
         MKQYBqJWQGyHZu2NPVW8ML/qHbJWMnhG4e3oKB3R3nfEBqtXTHGCKNjX295q73J/q2rD
         ROr6iNB9TnznGToEnyXbbiisQVdxtuxfe1PfW5SghE3a00pIJYTfiGqAuoiiiAMvks2v
         ZcLkN94EqC1h4pvYAYSM4O+BmRKaZgkBS6PrLRwSF8+tATtEj6X49L7v4KVG5VcgJrAe
         HEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601366; x=1793206166;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aScArLj/kav6iD0/o6beXEYzxhtPHu8K7/dEbQLRbs8=;
        b=qKZfOaIObnz4BdCXicgehaDcD5DNZamQ75L0BbaXtEpfaIM4qP+yYazNrEXlt/bTCM
         gk3OFGpeVWZxNaTW02OPI+d0NfXMgnKEgyjoTdf1QfB64qg1sDUGELg8gh5Gnq7Lq9ij
         DUWLWntfjPguJh4/Rk2PIfEFwoXrvpQAdzzo2HYtx4GxciAGvufCo2OYx40YU7PKZ5Uj
         KOt9O6DjVt6UONUfPZdTmuUdjaheT40NHZz0yvr8H30z7WgN38FpvyWYDNZ+xvWu384w
         7s03MQl5wCty3LVDUNeUNs/u2T6+tUSwYw+eh0qx+O684UelxDNubdJBqPrw5EkjJ0aJ
         41rQ==
X-Forwarded-Encrypted: i=1; AKwUvByJmZ+o8uZR4JXOkXTL+GUbrCS4ki0wTPUtKwJmKLgY1wxSoB0KzWY0HedahHfeUc3DVzhR62U3J03Ewn3icQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKp4VF1CZs2ieWr3Cyxw/wNIAS4FANEfdraLiSqU2AO1S/GhmNH
	2O6XwkR75NsSV5PF7bH7mSOKEf40lkmn5e44uZk8Lhv+MdEqdKuKR4b24HTjooTwgFhKlUHa6Wc
	IF3AI2Ob2ibCIbvKVqBw6agGCM4hPdET8H41VJdhOpDRMzMo31Dx5BWSApB749U4nwhyWxA==
X-Gm-Gg: AYBFou0JYd2xl1oCK4T2NBpyLhZXNpfETqUtGwZKIlff5vsMR/qKcu+kc6D7cfPcqSt
	knRfAI3jyBb/3oDccP0PrrWBu7B5jH6TJvNV+jRFfa2bSBv92GEyfqeg/YjD+zaaQRwq9mRXm2J
	7zePtUytsm12c0e0CGjOomUw+9pjLVVqNxpKKi+CwnYJG3o5TlS4DpRyBBZ8VNdPyxluviMZU2Y
	dNtmD+86TO2bahaAzO/ukA+OZXkGuxXXQLXQn6GPBeeix7HUrcorMAQs11hTBZtDUF6EZjxfLZe
	YTsC/A7MRBqZuBBj2KjCXZojcaIG7S0NKSntqKRmwcqp9gvnBxFZaWjSax5B4c8bOydyVW/B/Ci
	bJ2JpcfI/QEX/rHDzXwTL+sLybEdBMArSiSi8ci8KBpr7A2rSvlOGXFoQWmBn6SSWAgqr+jtwgZ
	oWnJeIvIGwTLTR
X-Received: by 2002:a05:620a:3186:b0:93f:571b:c72f with SMTP id af79cd13be357-93f57f05bb6mr541416485a.20.1792601365664;
        Wed, 21 Oct 2026 09:49:25 -0700 (PDT)
X-Received: by 2002:a05:620a:3186:b0:93f:571b:c72f with SMTP id af79cd13be357-93f57f05bb6mr541412585a.20.1792601365178;
        Wed, 21 Oct 2026 09:49:25 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ac4f4df158sm1332271fa.2.2026.10.21.09.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:49:23 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:49:22 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20261021
Message-ID: <tnbl77vafrjvgfyryd4zfyr2o5myg3vg744zglzitnpxpt2uoh@wejrgjjcbfzi>
References: <51c9bb4a-e86f-47b3-96a0-38288b460bcb@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c9bb4a-e86f-47b3-96a0-38288b460bcb@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NiBTYWx0ZWRfX+2r3NZ4YryZs
 o461LLgYfxFUs2ASk/C8BKAi1Aneon+9cKas0+1XeAbkGwTecd4P2Eg9j9O+hVnWhprSBlfIY9l
 JgmOPeqpmjDMiI3DSXTcyNMP9Z+NcwQ=
X-Authority-Analysis: v=2.4 cv=eJaGH3p1 c=1 sm=1 tr=0 ts=6ad8ed16 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=Cll3ooqCA_IsHNaTrZ8A:9
 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: YUG857xCye5WE2Pb0TYR-_LTHVJY5ml1
X-Proofpoint-ORIG-GUID: YUG857xCye5WE2Pb0TYR-_LTHVJY5ml1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NiBTYWx0ZWRfXxZTCM1QzNUsR
 5ukAmSbVciZF1Linz5w/QfHYSHeWnyhYeKe1Hai/fEktxKShyr8APXgJY9jQ0rKw2MIr7j0/ysY
 veh2ZrPBgUdDW18RWVK3wkmK2qDff7eR/+wwEZdk/PkdWtjVnpj4wLw8wee+PUnCJK8H5PIYuYJ
 f9P7uaml0GMfGZtM/kcJWnCMWzqVIMpfPZuTzI0XCcNFMDQJP+qQizCFjLvJWUvL5qkSTdZiEks
 qvgik/IqbNWIB1SaljPrPX35weqpbgvEuLTsiaVYi+KtIbS7ccghdhyd3WGyVzLeuoRnJeDQoBj
 yKjY/UaML5K3+n5lwYeTbRkbLYQJSymqWrd19p8nLPLr2mfleEsIu1NglNembGqdanIcrGfvVSX
 yqLujXUUrX3dutDzNQGJVixvA7TCguY4ysxkE8tn9w7s/mJzyGGIZpBTga2rYBbuAsLBmjWDty/
 vyGpVeBgG+h+NsllCpg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210066

On Wed, Oct 21, 2026 at 09:30:17AM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> There are no changes for ath11k or ath12k.
> 
> For ath10k update WCN3990 shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226.
> 
> Please let me know if there are any problems.

"make check" failed:

1. Missing "Signed-off-by: author information"



-- 
With best wishes
Dmitry
