Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793683236;
	b=HaZAcB8ILHhPvXXb3Xyt4uE2Bg4m4WDGHPU/A5hKqRgKwYzEXfWKoPQCS75VtnSWWlNs
	 UlFTEqf61Wdf3ifiorJCXEZn8dSp6gFsfwZ3jbtIn5/c78/MFBcT8QFOYqddF4PR79Fvk
	 YQYPa7kcqo+FKQ2V8GX8GAj7VRFsPt1ioz8dOflFXwUvA9GDxoaNoIr7u+KK4JOj4NxqJ
	 a59+5RD8qpnlZDBcS4h4XT1M9Z7IKhXBsOEA0KOcfUbZ+AE+jU/eUYiwvU8n287DvtRCX
	 gSX20KBP+TofFIsg1anv3aNbhHKs505TTObpGP3xw1h7lGDKWs054xJfWk+GBUYFEog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793683236;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jZY5YnVRTBPVc174ls57YUx9K1Cuc0oktWC0Xo/THb8=;
	b=aJNHa6Lv1PKTgWef96eE6sqhyu+q/bhTsHwKSd4ZNS2e1scGmk4+JcIHpliuwjjRLnho
	 5b1ht1tCCOUf/7wTfSbQxusJ77lSkFG2Ke5RGtrNBKRKu9Mp0H8FcAs95fWjgQmpTzZEU
	 WnJHykgocpRFA4M240RkjQ+JvyVqAxSZoYcu0yNsVMG+B7pOMwUb1eJN5Qr6MW97vOyzR
	 xYZ4C4tVrfQTKjYv/KSzYoPsSfSc9Aq/LtddgQYZKbwboakzByQceu9PWr31fdGBZfb6p
	 mcYJ7gtO6MxFrURcphr+f8eGbNEUM6q8OIZedrdZcxSoqdy9PrALj7Y+QyAQFfjE6Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=k3aZpieE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tm03CPEp;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968D6606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 05:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 968D6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=k3aZpieE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tm03CPEp
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A32ButN2106691
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 05:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jZY5YnVRTBPVc174ls57YUx9K1Cuc0oktWC0Xo/THb8=; b=k3aZpieEHZfx+efe
	nEe6HofJczZnIPk0MrYiMvcp/yvfkBDTxgKx1ykTXUM5E8WJuMjiNltkT4r9lXb6
	3OHy3GGTsV2oXTIBN+BlXJQ8J1QKATGZnGOQPFajA0ZTYOCXF9AeJ+oOADk6AjvK
	9PBgSoqlIL+h/fqADDJb9VJuUPkUU6JA12kcwCVdwprtOftR4tQ7Kt/2+lNWKCgn
	/p/TIA3dZiJPUlKYu6gX8/Z7znqAbCVI+uDImLbMFbY7tDu2u4VhkPoanvbzYMBU
	pzyz0l1VG6LLAqaa6vL5BVRfZCtL4DB+9cu1o1703gEnPrxT8LRgb+KUeuGYVuCA
	0nQ1zg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq6m98jra-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:20:34 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2eac6e96bd4so56426825ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 21:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793683233; x=1794288033; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jZY5YnVRTBPVc174ls57YUx9K1Cuc0oktWC0Xo/THb8=;
        b=Tm03CPEpI6yl714S7VRwD6D5RPVOtW4A9qncKHG0hZPcl4bkXFT1GnrBB4aRK82AX1
         asChNbOPQxDI/bQQed/BeJl7ZmPrf8imaEHS9LH9Zve55i8qXz5AKxHIiHQLsUk/+WHg
         gUtJgj0OuZcuNqUlYKNXJhII2Cyyi3k9Mx69EjGgX3vlxMPNOsnNCZNfNebm3uWy+Qfv
         lPEt/qw7ONv6Q0d+mKfO2ZSxDWpMb74s8iK79L42TuMe3Puq1mmSabd4fQoPhEkCbfry
         xUIZcFE260hPC68ytPGEALiIUyqYhwreXg1/l0EQj1GLe3IDf0RxY2tw4KlZPZgYBlmD
         Wl7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793683233; x=1794288033;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jZY5YnVRTBPVc174ls57YUx9K1Cuc0oktWC0Xo/THb8=;
        b=Yf9EjJOno1XW4AwvgJBr+Y4UTJ3CnvpFMYCpiQ0FODhv611zgDRQQ2bY74gu9TBTQo
         7tdQ9/f2mnSSWoEdovgRKe7M1F2aYCP4uCf0w1Jdhr/tmD6ZU/BwIRWWoMZnwxY2E9Vo
         rvqr/rx8kgqCcIPHbAspBCdCvZqb0NtoUNvxJgCeXL88lGR52mOIIMpoizLBSBu6TS9L
         pWPTUu5+hyBseVNMZQs4Dyg8ylTjjtMbUEjU2kDY9vaC/ToCWvF4BhuQ/M7A+qMcmF1y
         dr9ke5KXyzWugpFzjB3rVc1SHgSCIxxAiqm6NGnUs3EMecnUeDhfOSw+aH6w5KOzsDyL
         FOJQ==
X-Gm-Message-State: APuU4Z8YhqIxOKsFmkOK4/Wy7Dcd/JGfqBzNE0DMgusrOPdZ3c+OsjrZ
	+ONHBtQ4hIho3IevQgDfznouBttfsTPCwtL1RG2oKMeRKEKFc78L4rubbj4SMQaOk0O+3GXVI7M
	x9LfKGqQtm4oIBRUzF4xAmHnU9qdf7xFGQMAxJm0xH1vA+yNd+agTYGhjrhtSykS9U7RI2Q==
X-Gm-Gg: AYBFou2B2Cn6mI3JJWxtJtWy8M7k60UtUxZdfrFhRsQpTynEfPp7MP6V6xxmddT14vk
	N409BlMsMqAwX+QFmBhEiZHJqB4tFPy1oBuTiF1K3Fp6qiijvXvslEjR3M1trufCkqRJX8CmBsO
	KJo1JyITNrxouyYgU753UjwHcYEnzT3TqtIcFXrrnY+fjdn+uE9QcsWtrSsUTwVw+yyy1EXW1oM
	CxHrtGO7Pp4WoT5Bs+KSnTQhyVITBpj+SoN4g4pe1fQQmcBm2fTKLhe6I3KAxMfVD+YNTJ2j/nt
	dLwHrWn+GuY03S4zvJV4jxZUWCn+p1S8BeZ9GJ/kQr8kC0882ReD8XU8ra95iYyZT9XuXCr3jBB
	+sxRrJPH3JbEP2P/wtPiJINvUR7i/rZojpKZqxYkdypXGf3lrFBFkLiSy58JLJafXqs8NXEEzAs
	zsAtuLdsTUY1Gz0MHyA4RLJhvEnVpN0c0/cQW5sQhXSTo=
X-Received: by 2002:a17:902:dac9:b0:2e9:502a:ddbb with SMTP id d9443c01a7336-2eb364f0f6cmr137697875ad.45.1793683233357;
        Mon, 02 Nov 2026 21:20:33 -0800 (PST)
X-Received: by 2002:a17:902:dac9:b0:2e9:502a:ddbb with SMTP id d9443c01a7336-2eb364f0f6cmr137697675ad.45.1793683232907;
        Mon, 02 Nov 2026 21:20:32 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb392b15f0sm35838775ad.73.2026.11.02.21.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 21:20:32 -0800 (PST)
Message-ID: <f154f553-6739-48c6-bddf-21f429b34bae@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 13:20:29 +0800
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
Subject: Re: [PATCH ath-next v4 00/11] wifi: ath12k: resolve RX link id via
 logical link id on WCN7850/QCC2072
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ccwdU8T4SRT4J2Tz_KkyZ_pS4BQlgNKa
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDAyMSBTYWx0ZWRfXyiTfhw9xAfvq
 dXSRBvHqzQgYO6jzLWDe44LkLR6LaSU9N6RrCIKuB9YkQVITGZ4/ztKRNYxdluY/Un2WkM8B+el
 FUpp/S5FLtoqlV2gqiLG68/6kMyj1gM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDAyMSBTYWx0ZWRfX6crw5r3yVyy3
 AkIsGTh/O/AfbhOhrJTrNhJY4z3prcmz0VZEpCHatW3Y3kY3h7g6HDyWHASdgm4iNmy2uaKVXUe
 nP/us2YODNms6/Y3/7VYkxT3qdMoS0J/b3M6PfdmK9FQyFNuG6+qe4NcxyNIutS44f4fJUb3Qtt
 bFU4lECO/VQxKwaU8L9m+BfeG2ZTNBaXF6lZJjD3D/MPQGylA8b+LdR+jz9jJ3HiwcRqZ//4ORI
 5FG4oyloZSpJQA4PGu2A3Ar2s1WEgAZAV/c2Mzwe6jm46zrPrx7yzdhduy9iSyJBLEiw5PtkMjd
 vsk8RogDYuABh+fCva6kkJ1MsnhMbVglgjZLBo/RusCV515jSNkUBpmYsZu4D1JwE5pznV6XJIL
 WQx3eWYZa36zosuSgPTLv1qyF/L+aWmAIq33b4rT6crnlQeCpnXrm2+VD6N7Ea6LC29F+25ifuB
 6TBBhp3FCsA2UTO/79w==
X-Authority-Analysis: v=2.4 cv=C7B8WgP+ c=1 sm=1 tr=0 ts=6ae96f22 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=C9cPvLXlrCZ_zlmpmt8A:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: ccwdU8T4SRT4J2Tz_KkyZ_pS4BQlgNKa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_01,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030021


Hmm, forget to reset revision number ...

Jeff, let me know if I need to resend it with number fixed.
