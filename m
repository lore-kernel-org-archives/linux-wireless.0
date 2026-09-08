Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67374968EF
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 22:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788906019; cv=none; b=A/C0JQ7m97+YkKdfuWC1QVt2wjFUAdDL2Hxj/AlTWw+PQduHGOZhpWQiG9B1vaStL5/AQo8eFAr2QCNwi4DskcG3MX8GPGLtS3FCRvSYn26piINMP6Hf4a4A6TwVyj6mXl/E4qzbFSthsNW23HCFmdmrfHYvsJ7PUvWL5UzLId0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788906019; c=relaxed/simple;
	bh=YF7lwKnwg2iaN2v68QA8P8YHLT4eGZr11b1zN/96nFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HtqfuRcL0P7v1S0HjkpCORFfYnpe9+2QW6yIaLveobo1p6xmSPT7QCficfkAXdvITghudEWuOmXIZ7AQS2vtpjVy321AQhH73pq/q4byr/J8fMiBpLtsxFmc3+biJjN4SN6e9feaqyO06wdrhiNGRoQcZxXPJbaxpP/BDDoY4aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ubr3gitq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Id2jYxx7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ubr3gitq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Id2jYxx7"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688HLWnA2966666
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 22:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LamaiPs9H/4rh3RVV9PIJqA2A1QM6dcx2EoKi2xzveY=; b=Ubr3gitq9ylEMVBc
	yUOxl6/Q5pIEYYB3CTyyjo6MeUyx4VrIojqNsw0rB6QkTChDhkNImmHjKrXzcW22
	5C8w7uhEM6XUt1mS2JDuQxjfte31XT6E/8PeYSLXxsw3KzjKXR0WmmNpsq0yJgE5
	PkyldpOlettoDFTceqhhojqyWGuFts6zWqTubhi4JMunqKiP0kLe1pVQySY9cOI6
	h4PhQDqHZR/NkYnP5YFqY9qISE+2YaopfIFzMgj/qJNSfBGs756rxYoYo6HNIl25
	8PSk5qQM4gZe89C+nRZC3B9zybTMsBKoiTtlTG3Y+3fZ8WWQw1Y6Nz4Q10nvvB8w
	a1CNPQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjppp18vs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 22:20:17 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1b80835d5so7092978a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 15:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788906011; x=1789510811; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LamaiPs9H/4rh3RVV9PIJqA2A1QM6dcx2EoKi2xzveY=;
        b=Id2jYxx7IgVDB8t4xh6qmaJGWVAg11+DP3TgZV8JkhUPXCjclCoqBDdE7pxLtU4Y/v
         TGBWboK5sIWJPOu9m6Yn4Pbe7RxM3bNGmYz1oBAiIYGZIj/yWq3X6Ny/14dwZRlk9TQh
         YqKTfuTxYnRdXgC1njfxymJtYMaWqQzKRQCsWog8mQPhDk2k6YIi0/M0/T1gF6gOxDon
         lf3yCcxWxNFo6dtM1Pg8OI89OxCEN243kfkW6SoZJC1ww2c0JkkuQw6NHiHElKbRYJqF
         nTDD+SwdNS1r3uZmrj8XsO0DeCGwKQHlPEU/3OaBBpjVxOCh8PdYCXmZ66FveF8Y8uhO
         FStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788906011; x=1789510811;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LamaiPs9H/4rh3RVV9PIJqA2A1QM6dcx2EoKi2xzveY=;
        b=QclREqMOzhr2iSglbzjsE5Oo45dziMhTv/bvINg1oo8YxORyouC+qmt9U04xiTG77D
         sKJYtUW2pK13e45YFImapxSorumGxBA3oaUtDzLKEnDty9am+nJWrcwWGUQZ3CYCXfjD
         eD82dN+MNEm8LTd52lC3VQZhmyp92Xu7vgKkCuZG4Rko3zWsT78kDEms9y5vWxIF50fu
         J1qjRmupNVjhwCVM9Acr4Ggn2Jm70kEltNhWrKF9rlyuPdtUAzl05qyNoRmQCgiBCGsX
         V+mWAj4p4QhFmpxdlKDj261U9EflUyK3nno3VgWGEzck8jgNS8q9kd0AZ8VrNRniHOaT
         Eg9A==
X-Gm-Message-State: AFuF++kVVwUcDKq7MXuO/3M0a7eFZOK4coMr+lZ1Y6IeSZ5pubx65A2e
	WJPevLAUp2/Mj0Ndq9zy7ib3DY30NLr/fjHiCp+GYUVSKPR4CKwh8FwoIcKj9oMNaIFZozhDoyI
	G3wBxwECb2Ym1rP4WiZlnJRDJSQQ7uvzfWqDXbdX/0cFSn+a3oEvMPe+w6DSVUkQaQtnFwA==
X-Gm-Gg: AYBFou1CQM90LMpSW3G+uMgTd0n1yh8MHZ7I/MZ9HoQf3uyJAgGe+biGj5Uebyvqfzj
	MUFkoveQfn7vDzJxp0F+7r/jRi+ylTIu2I5U5HJ07ZMgqCRYhN3ufAsA51mbh68Eg/5RiS4WaD1
	/XfABw67KfvPp83VIzp7gtcNgMVsB1wOwrJ/OoLpmGNQxiOj+exqhRL3oxUJ68isSbbxSpyQS7F
	SF2b6ePgJTT6nPcH7Z6We5cA16j8DWsJLCRHRkFdVDjLEE5W5HxIx9D3z3/t4ju5+VlOz2Y517+
	K+rIehBY87qPTcnblnC/JwX1qKZ3GTf1iHNfryodO3cvvXXt0ee4/9Lr7g+zFLqgPFD6hK2OOvJ
	3GLJbODWd7JdIK+4M1ZJPi1F2q3QhWTCJ1r+iPiZ9E/sC72WrdPd2ucs=
X-Received: by 2002:a05:6a20:4309:b0:3d3:adad:f172 with SMTP id adf61e73a8af0-3dabb25c0famr3021602637.20.1788906010806;
        Tue, 08 Sep 2026 15:20:10 -0700 (PDT)
X-Received: by 2002:a05:6a20:4309:b0:3d3:adad:f172 with SMTP id adf61e73a8af0-3dabb25c0famr3021561637.20.1788906010404;
        Tue, 08 Sep 2026 15:20:10 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339bdf26c5sm40150708eec.27.2026.09.08.15.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:20:09 -0700 (PDT)
Message-ID: <6cda5b2b-34b0-430c-bff3-635df1080312@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 15:20:08 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath9k: validate RX stream lengths before copying
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260701053823.49801-1-pengpeng@iscas.ac.cn>
 <87qzj9tefe.fsf@toke.dk>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <87qzj9tefe.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: rompTYNL-JOb93NY3mnBMmU-6Y5Qm-Rs
X-Proofpoint-ORIG-GUID: rompTYNL-JOb93NY3mnBMmU-6Y5Qm-Rs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDI0NCBTYWx0ZWRfX8DMhWpIcbEyX
 iBu3yLPtmsG+m3VhR7q+Sd5JQyCEnHpGmFJnSGB71OTHdqkxrGagk5FV+fWQAPBiJHm+pUVkNZE
 uzU4agPRntnJfDupJxX8L1f/Qmh9r3PE/TZtJ7YszM7Urj2s6DrJPelKyS99XhSpPCJ8ezQ2YmV
 /0eHitIWXmyEx7qqXyun3rBk1GN7yoatR0zVU+oFTlXfPzCsrKshC1yhPU+IQJU108zR7RWBt0I
 x0QOHmcgI9y6S1I5b3Mgl1XWd+MXSnE2rJwYsh0cOBcDCZvOYLAe85mxnCcNKWbcWQtOsmgivPg
 iOtlM2CRDzM4OHWH8fYk4cMi7ajsKUOfjj5xdVFeypWDZW5IE2xl5h5IIltgOihySJHXtSzn4yT
 7LoB88Q8eRROQbWNF3owqKcM+aUil7Wo3b2dGQ7ugaM4zm+721wvLiQ2EUxQNpUEglpUBVxDiRr
 eo0Euu0pGfbyY/nibug==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDI0NCBTYWx0ZWRfX388FDrC6ooTe
 FbLlZDIA8w6n5nuKsFNqKhOZhB0dWG5JPy8uHuXhZtMG0FUS8xcIar8rviONlAgQnJK1n11yWi+
 0GAtUByEZ5TZxXILq+s/CJJe+ibSL30=
X-Authority-Analysis: v=2.4 cv=DcInbPtW c=1 sm=1 tr=0 ts=6aa08a21 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=YgZe7ON-S0xWIwxrQ_EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080244

On 9/4/2026 4:59 AM, Toke Høiland-Jørgensen wrote:
> Pengpeng Hou <pengpeng@iscas.ac.cn> writes:
> 
>> ath9k_hif_usb_rx_stream() reads RX stream headers and copies payload
>> bytes from the current skb into newly allocated skbs. It also completes
>> packets that span two URBs by copying the remaining bytes from the next
>> skb into hif_dev->remain_skb.
>>
>> The parser checked the stream tag and an upper bound on pkt_len, but it
>> did not first prove that the fixed header, the non-fragmented payload,
>> or the bytes needed to complete a fragmented packet are present in the
>> current skb. Reject malformed RX stream data before reading or copying
>> beyond the received buffer.
>>
>> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> 
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>

Can you check the v2: 20260814075716.18804-1-pengpeng@iscas.ac.cn

