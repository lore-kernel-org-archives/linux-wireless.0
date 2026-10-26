Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994440;
	b=TWZ40n9P8F2WHUTOP+7bvy+NQOmKyeuFI791ysDBRcFG2KjV2IZPcBq+f/MrvaGaWGI+
	 7nbhJKuvdVrMPej9/lSACyggJR7MtKsO7c72QvjqS/NPYLh+0DPjo3kUMosK4iiRsoWfG
	 27BgPFeX5fRWVoVN8t2DCUmR/pLWE2q3iFFSvDK5nM46cnguqa7bjWJeTEgzON9T+T6h4
	 bBgbN6B6eLpo3H6cJgzKTVNyTb40+wnEeySl2CYiVI8e9epgMyNHibLbzqPhyS7TLlMBl
	 vKZU6p/HTbB0+Lu96VjyUgMvcffrZQ5pJZdy48r7FYpbmMEp6V1zEgLRvbzI26OkuJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994440;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/HIFyJKOlRqsffaUB3MiFb99f+rh+OGZ3T7I07VYqgs=;
	b=LH9xxZ7smt+ic/6sO00Y7vLH1fJIPiNwxJaT6KDsHzjV27+D99LIs86p3sBqjGJUNrnG
	 KAKd3viaX6R01Jhm8MUy7hPOgqsBicZXnyempbHtIKNMJf4k1iznsV91I4VInYO8DWrXb
	 0CL1cBX+PGqUhLHna1wrDQjlMcRKu+NWqB93foT0uXzxJ27qGS816s7AqroXxAUEZKhZJ
	 KpjjG92LgeCpgExZzprGEpuYnZZD6n1MjLUPDXZYxQKVlcxd3QWytGoqv98gD2COxR1tZ
	 9NLCrDhe0SmwSYuankz56EXIPDyvNI1FvqBPOt96RVhLQ/tsQUPafkyvLTiBeGz5Q/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="Je/S+Ibg";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DytZQzwI;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44BA606A31E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A44BA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Je/S+Ibg;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DytZQzwI
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4ar8V1181759
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/HIFyJKOlRqsffaUB3MiFb99f+rh+OGZ3T7I07VYqgs=; b=Je/S+Ibg2hgqJcin
	qVSCKTGieUFYA4cqFMgz2K9nL3GZIW9oqdzuntHDIlJUfpHK4Slfu72pwKQ6hVc/
	/TXFnhfsCHnCgPrn6nRTgfu34Su9tMt8PVppA5KravgCM3f4oTD9lIXtcRxe24Ed
	w4HmC01144OJBxoxJzrJF0EpGtx8y2X/iSQYnW7vqbCqUtBgVrPMSG1ZRThzqm87
	oevuRJTuF4c86SnyEvUM+kJ6mNTpfJo5/yFpx9oUpcMAdkFuJg6XrDdTsXPS2h7k
	GLvSbRcpTkpWIc5N4wDBW2/yI8K6Ty3PJ4nD3yQTsIBN4aKnhTQXgLS+zAOzvmVA
	e+24GA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgn27vyr2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:00:38 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3692c5b061bso10292557eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 23:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792994437; x=1793599237; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/HIFyJKOlRqsffaUB3MiFb99f+rh+OGZ3T7I07VYqgs=;
        b=DytZQzwI6FwxnpcCEqcUSeR3S9kwcY7jXsoZZ7O4SKEZAP8MYqZs11EY13Sk6R5x4r
         vpjbrS8OgGp3OpmPIP1RzUbE0sWzpmLyLqHXPmSqCUu3iWBF0tr1xWHoqdhPhPJDD7pu
         IPp8yXTpoE09OYVf48SMObV5GadU5r4VKCTs5Ck5ALQQHVi9KyK69aHXz6/HvX6Is9qq
         F4yX5UsPyC8tGs38zkBGS6g2g7KB9ynom8LzwZl4BxN1+gRBmHJjztCR4V0Fnc3Rwxxh
         F5bfx33fBonyL6uAdRZNr3EHf/8hHIXrhhN2lKxLr3L9p9DlLzIGbDE0/KkntBZPZySl
         ZpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792994437; x=1793599237;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/HIFyJKOlRqsffaUB3MiFb99f+rh+OGZ3T7I07VYqgs=;
        b=w5RqumRlAvXc0ddKKT684HsrEpWmqcJ3jrvMuwoIChOFslHOlgmkmQWRMIEMR/+kOa
         LinmAnQRGd4e+3Bn0N144io7vOIqFT+8eUnEtNs6k4q3XG1S3VMY67cbRPA5vjgbJa5q
         97M0fBwRsuu6PshS54DbTuTB91axXjmUCkNe6elJwOdEqvOic7V6z6LNJjFoVYEdYzgO
         CvmY7U4DzBcZWz7yoYKVutzG5I8J+HNE3HJ5V6k8n+AsiEdwf4ixAITu/VDgiaemHoA0
         0gf7xabfVh8UQ2cUt2SFIkZTdkg9+gq3q4isuXfN+w+UGohnS5GJ0JPuAiFjIgONI2Fo
         MG/g==
X-Gm-Message-State: AFq9FYIpYs3VYNgRlL+hB9TcvSDyFQKepjekMYotjrofosEvurZWEu2z
	ykxy+VIScVy0FvQzy/6ougeFMoZ5mwGmH0fDkMvFsOjUyQFIXKQBr53iCDDn96zE/V5qd5BvZLm
	fdUswKMsMlt2nAnJl+TZgsqMDxYMAloiysutm3jX5etTMXrjBI6oXeXXDsEJGC8fDGRwEQg==
X-Gm-Gg: AYBFou0kYBfPmkZQenX+UkfVOQdsF74WtHPyYyVlOjAJ+Vmwz5lEh9n90yCPbcG+ty+
	XMpUoXO8ruQSWa0Z1nP4tFQaOiDfowxL6oQeOvEJKKENMj5Gpcu8qO0rUSoRhqcqWylU8ta01xm
	J9o8MYRFHgKjt7xlQXLs/U4WiopEBHVNTIvw8/zPNSP8w8Qf5CbSbOUERowLdTU5yuNkUCKWFj3
	Wyf807spZD5j3aeJhYs630x9PGTrCNnnGrZpzDRyN+guVbSNysAAxr1x0CLEUUV/x3d/MKyY0hx
	1jUT7XRQlWXcIpQ0SkfMynuUe99/Tpwi9n3026vu6eESVqFaJG+e6Nm41TtVlAKxb6YRjBOlwog
	RTyXqmEn4Y85QMcMLGQI14TvKNUlcto4XW5/HDX6upTcuS+U=
X-Received: by 2002:a05:7300:51f2:b0:366:3257:771c with SMTP id 5a478bee46e88-369e84ac697mr9820329eec.16.1792994437138;
        Sun, 25 Oct 2026 23:00:37 -0700 (PDT)
X-Received: by 2002:a05:7300:51f2:b0:366:3257:771c with SMTP id 5a478bee46e88-369e84ac697mr9820278eec.16.1792994436291;
        Sun, 25 Oct 2026 23:00:36 -0700 (PDT)
Received: from [10.152.221.90] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ec864fsm26842570eec.24.2026.10.25.23.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 23:00:35 -0700 (PDT)
Message-ID: <48964cb4-bbc7-4115-89e5-23ec6766a845@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 11:30:32 +0530
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
Subject: Re: [PATCH ath-next] wifi: ath12k: use hal_rx_mon_status for PPDU
 parse result
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20261015-hal_rx_mon_status-v1-1-b32d5a7383fd@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20261015-hal_rx_mon_status-v1-1-b32d5a7383fd@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=G7GJgNk5 c=1 sm=1 tr=0 ts=6adeec86 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=g4tz2Ay1j4hv8wUIq6UA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: aSphA_lpCIn75fdWmarE6mfdscWBH3v8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyMyBTYWx0ZWRfXxjulNG47o5Z5
 zu5aTGDTPqWdCl0mCGBtH5iF1EZe0Dyvt3jgRpBggDlQRExNvmCdeGCbHsqsdY3StRSdMO/PALO
 3TokmLlaWyfUh4OO0gQ/WUjV5bhHLUU=
X-Proofpoint-GUID: aSphA_lpCIn75fdWmarE6mfdscWBH3v8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyMyBTYWx0ZWRfX2ufG6FJ3VcIU
 MFuMg6PLj3E5OBlT4tbhRFDjYZvsookCrXl9AUwj+c6bxQO+S3lI2vDpzOurH5dGgWPOJuj8iGu
 8IA9uiS8LtxRyGYnjUWxxvUZ8YvL5QyR0uDTldlMuN73TlFQ1jeK2SZU3w7RdWLmk+FwMba5e5G
 gH1ystnePRX1usqzrxKm6a4CZpBrHV3jorR4HBeIllxsVqnxhVmQPoWKSd4AEQrYIo0wuB/eNpT
 IoXF1clJ6ZfX+DcbbBIsZZJspgnTkgF4ttMQDlindJq6TIzud/7CaghuXzreWApgmNCq2hKSwFe
 H7QvHvCMO3bm4mmVPgbzRehzYe8cIAVzpT6nxPX/9Q455Ah/CKoJSzyE9khtQydRJaLBRLvM9uL
 JeZZyxMclfwam6z67XZK+7CaBMFBXgKyb+Ue8xZPQjHn3Eou60QuqzgcAePlTT8Pb1038m03vJ7
 f8v4REFUS3Irmaey7JQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260023



On 16-10-2026 11:19, Kang Yang wrote:
> ath12k_wifi7_dp_mon_parse_rx_dest() returns enum
> hal_rx_mon_status, but one caller still checks the result against
> HAL_TLV_STATUS_PPDU_DONE.
> 
> Use HAL_RX_MON_STATUS_PPDU_DONE instead. This is a cleanup only
> since both values are identical.
> 
> Remove the now unused HAL_TLV_STATUS_* defines.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
