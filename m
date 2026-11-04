Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793764495;
	b=tKXyk71bY4Oq0Qu6lS7rokmJJSe+ev74k4jMSH5sOTgcEGDT/eZyhHSSQuLNAh2DMU/x
	 umTVnucKVU88aJtEa96nMAVPEKY0EID9/LRcPgt+JDlbmfZQirXoBK9g/MmLJhRRsdaLc
	 SKYuq8HHONMmq4ldmgCo4lQP7SbKWR6UoWrqvnCmB6J0HO6JeXAgnDvOUznnF5d+3gdDo
	 lhgDXS3+DMH4N/mDnyuA5QS7BpoGjOIR9b5FOtDxfm6FYCF2uVOiNzFe1m6087bJNb9ni
	 Nf/I/0w9zTS+hAm/d+Il2HNFU1X7M3dWMtruXLoJ3VrHb7BdTYxo4ZlJLIQ2kvIbASg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793764495;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZGsdm7ECwxa4fqXlpHPQLCedahUTjcPZ09cWyAaDufw=;
	b=FSaueDgxsD8LwmFc79Svi1HXMMLbthx4bQzDoRRZTRTHPDXJod3pJg/InR7B0YK9BAsU
	 QmLqujaeDXl5uT+aZj3uQfYVobKM/iVJM8jbUZu8Q1hO7AtLBWJT8Jz7VA6KQcWuK8HzG
	 2bHBfHZrQJqAbI6D8XOhthulI5udtYIg2ZCA6mX1k21SlCy1eM5pB9XzULSffjCgip2cj
	 mDx1coRKlqC+nDaN4HZa2JXgziusgv5wIVXoBA/C0rnSGcPB/43WvG5gMZKK25VbFGEJt
	 H3FHHut7kPtjtJgpGrUYSRWkDhez+Y9vqhCGU9A/cafLwOpoMcI6En8SrK5c25MWGJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fIGofGSS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WAC+67Y4;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0770F606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 03:54:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0770F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fIGofGSS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WAC+67Y4
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RFY8838281
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 03:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZGsdm7ECwxa4fqXlpHPQLCedahUTjcPZ09cWyAaDufw=; b=fIGofGSScLv97ose
	faXMoZPzVyctNtKeZH7oT39kbyAENOMO+DqPgJh+dvlUoTp3XEs3GicB1AjXkncm
	1VoOSub+KwXOXUGnedpPlt0lemocjtHfEgcNBjfThAfdRkfTEJhkVXznvuXYdmoU
	e9IZc7DLgXpTT3iSJ93K+kt3+Zw3yXoKzeqOpjUGRFZgNNa7rXu2PIYojQox9WKa
	IsW/QYLx5fwpR32d1KKGw0uYEyk/cQqF+uZs6t36eGB0JwYRAXu9BDWH/mGUpyWx
	ubFdQ03aw/N6LTXrUC5YNg0/LKUZ4UZVJPjw+K66/u5ghyutzFfPf5JPsPQh2w4v
	WTpQyg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8msug4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 03:54:53 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cdacb64970bso207850a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 19:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793764493; x=1794369293; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZGsdm7ECwxa4fqXlpHPQLCedahUTjcPZ09cWyAaDufw=;
        b=WAC+67Y4ffhgU1eoy05dm2Rin7HJMwf2L5VdBIjlnRMAvo0FvuGY2CODWWRPWR1GYo
         bNdCS6jmVUfkOUC5L2djwvunrXQ4605ii83tqCG2RrRjfUNN7stfjCP/ztcbuGpYo4D3
         +WMUy2LW8d0Ibo/KhlXWlcy759CFmMOdD/rZHdj/aDJNTCbd2JhsYjS/fMEO2M7fdkol
         CeSwVjLU1HDeKrjc3AJHJ31wTZHzyClU+66TRt0+HVynHsJB1MSK0ukPg/nJgKpusthW
         z2I45ZoHTTtTJPCKzmfY90/erVKrk4l5FOiN8tChnAus5pj43YUPofBkWKyPtG/J7O1a
         gc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793764493; x=1794369293;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZGsdm7ECwxa4fqXlpHPQLCedahUTjcPZ09cWyAaDufw=;
        b=HN7buIBRpUG+eXD01KeZBxRgamf/WrE42DL+I6mOpMK5OKDogbXIXqdQHFkpaxWfQM
         8GIxwlZNOctdu7QsuVA6N9ZOOEyYPYxqC6Pd62LRx0HqvCx22QGV3JKbtHISWMlz714B
         nTrYRjPzY5F37I+B9IfnRF/fQujKGR5NImZAo6/q5G8L17F/JpTp+m8sC6kb3GHAYGIC
         F/7xx4+NMxna2DGyrd5/jOLjegs7Ejl5iYmu5A6TDYBMWZmLm9jZyz9JshqLTHYkUu3z
         FstyGgg/w7pSdqWxl/c2P5VDRTbuYVNAmfdbSUpUAdRUmoM8wgcios3b708BUNFlFxM6
         p0pg==
X-Forwarded-Encrypted: i=1; AKwUvBzvFksrEOLc83FmhPakoC6hF0JHusrjNomAQJI2wl0qX+ketRoeFbCJtACfpbgr8Qa7+FDCGUaQojlt2kD30w==@vger.kernel.org
X-Gm-Message-State: APuU4Z8/bG0lm8E9WcxRDTmadFsVU44UGaNAOLx7ALniAE/KtuXHTqlX
	0W2JiSDoizzp6cuk5XR9wl4ALP05SUbl7D+4zQnM9kk3c77G36Z2WtoKbFeySSS1I2qT/V2L8+M
	GAGIJzKxDMubnQR9pEuYV28HzCzUNJAeotDIu4+fScm3VCNXeCAiRvGh2UqHqnZ9Y2CBH2qHzI+
	3guQ==
X-Gm-Gg: AYBFou0nmU40AZBWMxJ09eCrAB/tGWjV0oUAlguOu8iiyOUqCkcEYgb5W08yYjPWaV6
	FPTA+H3lybhCp1hvNyVfzA+o/cYoRu18C1uV8jStPcjAtcNDhthTWyLZ4d73x2Oj/QBJmy+HrXW
	Q5Xw3lrtD6ENA2P/2wGA5lEeH6U7ftGGkforDfkqPl6Fy7/4nOVRzUiTBjxy+kK3coAztQTUlny
	IGZAK3qj0UVY/rekCYRujEXmT9uoS45zOxxvtyzkrXZCskK5caAz31Un7QKCAdCoIGQY1PELjuM
	DNNiqxetqYyUTuQK7/7b5px4VbSY9rG24aCOfRWglAHeXVtjQXIS3jA0DHbR2nZ7pCXVHiE4Z+J
	yK2KAI5LWNCmh9SrX9mow765qTcaR/8xH/LDA+z6pxJEr0ANo5CNfKDkAm5uPfzCy2PolLHK2zp
	P9wmROyOHEYeTVuqJ5Gsd3FRcl1mlbklnX5uGjyOR0xOm7
X-Received: by 2002:a17:90b:5404:b0:3ae:6fda:78ab with SMTP id 98e67ed59e1d1-3ae897b2faemr11997997a91.25.1793764492872;
        Tue, 03 Nov 2026 19:54:52 -0800 (PST)
X-Received: by 2002:a17:90b:5404:b0:3ae:6fda:78ab with SMTP id 98e67ed59e1d1-3ae897b2faemr11997981a91.25.1793764492372;
        Tue, 03 Nov 2026 19:54:52 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c9928d1sm7300015a91.14.2026.11.03.19.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 19:54:52 -0800 (PST)
Message-ID: <4e0d6173-d908-4b6f-9696-c05a8fd7714f@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 11:54:49 +0800
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
Subject: Re: [PATCH wireless-next 3/6] wifi: ath11k: register regulatory
 before wiphy
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
 <20261022101836.148512-10-johannes@sipsolutions.net>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261022101836.148512-10-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: D773Gu5a5gFVTjLU2pOylSdWnKxjxYG4
X-Proofpoint-ORIG-GUID: D773Gu5a5gFVTjLU2pOylSdWnKxjxYG4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAxNSBTYWx0ZWRfX4VuAhQ5RvPfN
 r9ROU+tPZ0Vsx0Om6g0SlkFhsdWUCtqOsqdeIrigDjAd68iyp/iTd3ygaeRzTdUVpq3Qp0IbxL0
 1CKqx4RRjXscY5zqx/VWcVyLVWfl9eIcjYkDcRia6ajDyvoiQzK0tVdeI9zjTGKYaVRlwImmFsw
 PjPqsB4b3K1lh/s/0RSOFb5Pjpcgl5MAiPDmVbuhkJFOU1QEKsVUgVEntCJVLGd/O+BGL/7BWmd
 dL/4iP9pMC/8LVC+qcPyV/O5dnqKgVEAfvuaIU7zkDlLmJ2kaSvewXLvCUp4Kb/R3quRBHMbnF9
 9049/TnJ76oxeilsTS24sIN/Ah+xt6MmP9eelaV3NtowZgpkHoFVXV6WhqYE9ZdxQlrbkRX3EAt
 sEqXGnap/8KBYMG1U1D9EKwjmUDDDYcUdNXN6k69u6XTKa0an+B2zMuxHtsfCz9n/+VZURrntVA
 NGNALbLRuwYMXFSnovQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAxNSBTYWx0ZWRfX0lb+5j+fudpp
 bYD/+CKYNzKZu6lGwYrzFr4+GiOQ8KWDUIEO9J6S+TznfnqsxaSNeM6Y9r04rcLJXSE17Pw/ttC
 9DwVYjouPkjhZ16zDwUTx4uKjrUURNU=
X-Authority-Analysis: v=2.4 cv=HbWB3SE8 c=1 sm=1 tr=0 ts=6aeaac8d cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=m1vWl0tTxCWmHZaFBgAA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040015



On 10/22/2026 6:15 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This order is going to become required, since userspace
> can query the regulatory in the window between the two
> registrations.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
