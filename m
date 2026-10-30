Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793323908;
	b=fMGTwWvyLLyBkigE7CFSbjltJaZb9Nwtn9+rC2lVAeGIJHtHY73HYqOwal8SYR21lXLx
	 5wBx6X+5JAbS3F8rUQIEz9R5q30p9lgqdx/ke62IInD0LMV6dqrekESODpWFXC56tlyx/
	 9VcZOPPwZa+7frHOb8u1WMI+asTpk3/HbToQVvKtzgd8zQsdWIVpMa0buBkdmiEiho8mU
	 LeGmYCBNH/ZuoEtYTxFMDBNPK1Jz5Zi0z1MA3R4AX+R/1VsuI9uqZCPMzKv5hu4YVjvgs
	 VUNFCJ3ws12MYXo8htojf40gna8cGjKlNtTVKkby839cFWncCkCcuWVhKY4CZjOt8Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793323908;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=eT/HPf07w7QwH3g6LeLxxNei7FREDLCb8Yqf+D6CtEE=;
	b=yrNqnXDNWdNxgCE/qxo+4Xv8UOfQ6Ki9V9q2so8IJ8VJ6NhqhZzUwidtdAt8PL/wu+BJ
	 zzgOD09tKxnatRCZkJQAlmJ2TVS9CoJW3gaUM/K1S6OL1SPDtDXVkGUvn85+R12RrKg70
	 UqeElEoM4kQxDtg3/s3PFnMK08S0OnaIRpbxRwm3bh9smtDwqO++XafnR+Tr12Lx+/g/S
	 3Zp/8x2/KSLssmpX2RmJ69Q/hb/Q5L3pJwQS4X+nTVMyYjYtgrF73M0WwbF98o5ZU7as4
	 00gwT9dXmQZVwktrCwFnxFrgjVg0dAuT18KTg/PzQUB1pKv7U+XXD9hyf1azRQq9CgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="DLGq/NQq";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kw0IcI7K;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E3D606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 01:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12E3D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DLGq/NQq;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kw0IcI7K
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TNKuP24163598
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 01:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eT/HPf07w7QwH3g6LeLxxNei7FREDLCb8Yqf+D6CtEE=; b=DLGq/NQqm+ANe1oP
	hOsFyI1EfCbDClU5eiUDx02DwlMOYklVeaUL0p4fflp3xg5C6cgermzzE3AlGUpg
	ThY5ILAwlwN3R1wY1ygLCndljrxBwz6vJqxco/+7BIguzxhCSIVKqhc4eiV1p2l2
	Oy6hubxQHmpa9267oxh4+lTZBhcg9qlXv6BtgEZEOgYoBgypA32r4qmzdHEuVjId
	9QLuYLvG8SNIRuFba4tqi3ltjstCSm67bsEm3SU5/xxlfJrIY5CTakM2zvBVijk7
	NkDucJQW8c9KXsXp9hKqtygk8rIC6+kN/4nDQmcimpaN5E/Mcc82q6zmovtsslM6
	KG3tHg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6pgm3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 01:31:47 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36a3451ea93so414280eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 18:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793323906; x=1793928706; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eT/HPf07w7QwH3g6LeLxxNei7FREDLCb8Yqf+D6CtEE=;
        b=kw0IcI7KK+uYPUMUQpwO1kqw48d27sedsAu/ysRRq0nMYM3gB4Kmk7ykwsYdb5LMBw
         XYBArik5J5NCZmWPTYG1VVPO3+IllS4ZWEG9ZZAUxiS3zyIJIaf7YzHP3Lq00zMeYugX
         xV2/7faJTTZmho09/GpKhsp0YY5hJhS95+nseooWASg1YRWRLJEscceOT2DazV9IYqnm
         a9TyNLZtxjECPyocLgL9B64J+XxglkLIhY3noN+9tgjt0+/ozirRdSZ0IE1TEarUn55x
         +KNckOvnIBSE8gIXg2ZW7Z6noiXQ87IjeEuCC1Xakkm18lfNXFtoVvlKBCbBYztdFqt+
         yxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793323906; x=1793928706;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eT/HPf07w7QwH3g6LeLxxNei7FREDLCb8Yqf+D6CtEE=;
        b=tDkDExSNmusKVVTtevWROHc67eqAJedUQJ0+32MJ3M+beq90jvgnlt6aUKhMYw6xEB
         6Zaks2yunGNB+jzgTzDcMNTHgEBQtuwQaq/PQSFTexX/RgO8pOEnWKrwEDel2EFYEDi1
         jfv3U2p/M6ve9Bphp2p/i7SghQSrngvFN62x9GNV9Xz02CAhgS3I3+z6e2mzb12+ZIvw
         /R7SMWD20Cd2mzigl7CDVdKgSOy9bZTrtHWCyGRYlN98dM1LfQuiCpKBxcOJGAZZeL2e
         I45uDiXQ3c5eRDyPzfIoyUPq7sspElIWconsaeAg5V68buOdqwplcmDjIrbAo7UjG0np
         qMxA==
X-Gm-Message-State: AFq9FYKRwIvXunHyu+n8OA+0USuf6LJ6aC7jWgMX75M4SIsquzU2m9Or
	xWf/fKDRH4AgY6QIAJXco85Yw+pgQxBqzO3sjDyDFIIfWhTfhFMAHjqqqNDuQb9uv1M40yReupE
	xopcUbet1xwfxTD7QC2RuZxI9G6ZGF0imgiy2fBcZCBPC3EJ2QO6irQZCZdH6QiuK98HKtQ==
X-Gm-Gg: AYBFou2FkSf7rVAayhZsyZhVXpvNB435rCsjgiGooVHXSc9uTnjI8uN53B9qt12fDk3
	7OcmixJnLKriI7u4QYInF0zytJwxNTEkYO9+1lK0Cgf6rWzYeshog8Rw9FwRzRpwfvY9BzABIbW
	tfiDUaYqutqiK7LIc7leiuefObnlP0iKCBqwsVatgwihaI+clo8MN7c8YIs+Kl20+R/Aq09E6I0
	QWcxVUnfFyw5WzuAalunZVx4qHqfcPC2pDd2GcZgnke4IyvDw7na0brqTz3bAHT/s9LLiSywarH
	TbVdXow1S7no3WfFyhEPVfFt6GjxysCoyu81zXtdJmgchvEIYxKb2rWhikrdz+j7Npe6fwMNEZ9
	06RTbnUq1cA/AbisnzZMPtrnMPrSabvyw2taE4KIzXG6h5kiBKewL5Cioe/jMZL1ouyuE7RDqrx
	l+vuVnWYF87Z4DL6tggx+2GhpZfM618lU=
X-Received: by 2002:a05:701b:4206:20b0:1a4:9eaa:d01d with SMTP id a92af1059eb24-1ac5fd08905mr1066428c88.45.1793323906295;
        Thu, 29 Oct 2026 18:31:46 -0700 (PDT)
X-Received: by 2002:a05:701b:4206:20b0:1a4:9eaa:d01d with SMTP id a92af1059eb24-1ac5fd08905mr1066396c88.45.1793323905646;
        Thu, 29 Oct 2026 18:31:45 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1d4dsm2372200c88.3.2026.10.29.18.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 18:31:44 -0700 (PDT)
Message-ID: <b60d12eb-dad1-4482-89ca-155dfcb410b9@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 18:31:43 -0700
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
Subject: Re: [PATCH 1/2] mac80211: move static function from header to
 referenced file
To: Omer El Idrissi <omer.e.idrissi@gmail.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
 <20261017155509.128114-2-omer.e.idrissi@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261017155509.128114-2-omer.e.idrissi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAwNSBTYWx0ZWRfX7bagcMvNq59V
 ftYDCA6IUHkRTXLrd9bI8xSOw112EdjR/ZxReD8cuZq43f8TZwl04nQO9w3U1fyBmK8bU/qryOj
 2dezRhsGS9F0toP46+fpB0mLq73ZjRyEiSQLyUGflNnkgAbTmw7JNyb/O7GE2dHD4xAG9hF88A3
 V2u7r9Z8e8ktPzF3f8g9bdJON3jj62P2heP6FHPEvs5IF+E0hpreufhSfJrbQMgjOyNjxZ51lsU
 pbTKLpG1FlUb7POO23KyoKPXIx7G/3TWJeGJSozPki2tBOHXxyKvfgEgx9dKk9MDLtKdLHH+AV6
 nO2zxKRu63Gzt86khm8w2hl7xovt74c2ILGWiTPsJAU+wJ/W/so2tyjhIL4awanCDTWfkrKiq1S
 Go1Ir3thLOq7iiTMsFSYcPk5Z2Nf7Aps2hE+69q+TUlzmDvV3om1Fefs+idRxHHJC8LF6GMUjAR
 /z8q00hCqou1A70dWxQ==
X-Proofpoint-ORIG-GUID: mUDjbM-T6K-rIz6TDMQAJyriL-P33JKm
X-Proofpoint-GUID: mUDjbM-T6K-rIz6TDMQAJyriL-P33JKm
X-Authority-Analysis: v=2.4 cv=AJ83otAg c=1 sm=1 tr=0 ts=6ae3f383 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=BgYLVidRMrIr9upBI5sA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAwNSBTYWx0ZWRfXy/+OL7kgeId7
 gUV6CPZqCJa01NvH/bnYL5EW0Zr9XAKwhsbDJpFLP5aYW2PFSmT9nwd6ykya6InSVRfyUFmZm9e
 +xQWaUx/eIF7S3f4FUrudSuYiA9WASY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300005

On 10/17/2026 8:55 AM, Omer El Idrissi wrote:
> Move static function from header file to only c file it's used in.

why? all the drv_ inlines are in driver-ops.h

first rule of commit text is to describe the problem you are tying to solve.

don't add unnecessary churn to the wireless code.


