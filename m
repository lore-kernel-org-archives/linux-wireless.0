Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606584;
	b=1ylOyi1BSZmSIsFoyGarP5Y2ky1EulVUFeRelJgln546y38XzJ6FI4vMPZm5CX+06MbO
	 66r9O7XTm9SpmUnAoYaq8U4F4D8zKoWYasDKm40BSdbkMP1TpN+RfT4Jw+vexr0Shp9Mo
	 eWGyu0QuNgImD8HjCTrlf2+QKpN0gBc/EnS8eBL9CUrOth6v9c9BvTHrU2s5T8i0TGedW
	 PAFqVzKmGN4aU/otUc4L4kQPit9WeOuhCz1TWhjbh3QbhrtGBYn39k8b+k0urVQQ2k+V9
	 ZT0Q94xkpSJB2Dx6lFpG8nI6LQvBeEoLsVorP/cCKRypA8BRtIoH+q/5/7tkCgTZ8TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606584;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=GBXtj47H1AmrCrb/cFsvOivhArZSKH3hpZ74KxcsUDs=;
	b=4pM/Ja6jVFm/64GxqZ3aNwU5f+xgJ8lCYoo6HyxCJRybiHmRho3jQ7fu82k8ro1mYPD+
	 b4vb0Oel5rxVcZarcVlIjbBq7OZ+EIbOZDEm6GYHjb+cC5xNgWr09SqI/duq3tB2KuPpx
	 lzjf3rtIzuj05aIocd7Qh/iAXnRHz187+lJca5gpfRn0XqbEFLE/Dm2C8QQtFzFMh+0LX
	 m7iQ+OGSSsNd5tirqi7YeW8c46xFPwUQ1TfPgrdparhPLU0M3B8OIRbLS5VpZjpm81knH
	 TxhIqCUTX37yfp98QNfqP7HlVvSJ5iNSECl8jxY+5U40QgiPQkb/n7lpchrLri3rDtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="MRh/OY9F";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tc0DxnUg;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E61606A335
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 08:03:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42E61606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MRh/OY9F;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tc0DxnUg
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vMIA3324761
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 08:03:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GBXtj47H1AmrCrb/cFsvOivhArZSKH3hpZ74KxcsUDs=; b=MRh/OY9FT5UJBspw
	BLi3nxzPJ5B78cgCaFdVqjMwS3VwIwDYR7pu0Dqh4oKeKEDRZWhiReCqfBFK0XD0
	cxCpKDfr79LXqAmWgQqxl82nqHhSykSsXyw7Hibl2xR3raia7bvarLaQZ4R94JpE
	TvqCmCNouCEDpOGoYZgC6WPbjdnQjzxJ1fBi4CK0N3O8D4xpjY8qMNADBlyrz3G8
	Hpqw8lKLjmBD3UUIiGEcK4jzcdiuIlDcEanq/Z1vtL6nfDfDd7XjosjOFvzxsEi3
	GiMBVdEBN+TfENR8l5yXZE/9xiEf/dwxhhfVtknkEpNVRvr+34PCH0mCjtYjzWgi
	tLFTXg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7b6ny48-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 08:03:02 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a06da65d92so1728712b3a.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 00:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793606581; x=1794211381; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GBXtj47H1AmrCrb/cFsvOivhArZSKH3hpZ74KxcsUDs=;
        b=Tc0DxnUgXrTsk9TolDnEvcW6pBlw3nKoub2LIBGbl5mikNVOGOYfkGCaHNAgnvulRw
         MUf/oEfhsH/rW8pOleezRK6B06+4GN+SxQH18GkO2b4NWPmIzs+ewmahwQTaq4qqxV9C
         n9WpxqxBhYsjzXUwi04pvlsSbqO2s2LWyhg3VWIPUbLzmCRvcpmtIA879rnRRAT80mPw
         v/p4HLeRCXGBFPkLMBut89JTE77ogg0QyE8Ab18x1miuUTo3RKtCp+uEL0cWqrM+yFKD
         G+WcXjeWsRSXRW91WOilfcyAZyswSku7eJLR2Hv2ED4RsKxF5E8nCsHjFPz9BZOXSV5/
         X0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793606581; x=1794211381;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GBXtj47H1AmrCrb/cFsvOivhArZSKH3hpZ74KxcsUDs=;
        b=01yzvBWo7F0k5rA3WS+5emJz6QtZc/VXnruQ0dPbr4iWZOdX4XNaUChxul+jlVahO2
         9bNiL6XfXOWQkKapoLk7U7A1ozqOZS8JT4Bs4LZ3ht8WSGTE8150cFLrNymw0KBPCX5n
         wtu0E3Bi5rIYaEGKTr4/OJtzF60eg5ldNwCbUf9BC6xq4EOwrp6JogPWD8lca4pPd4C3
         ZneCVfn3PGsHHOiVK268vPOOExOyXrcV3JpO2NNQm5h4B5KRzKKKSKZWMNEEXlDhNuQo
         yVpbC2ANfJSVYgONw5AHLIjxMhAZajmLIjGWKWpUbGpBEx0BbHE+a+eLuffIhi/B+d0F
         Ro5g==
X-Forwarded-Encrypted: i=1; AKwUvBx4n6WNZh/SyOXwrCB8m9YA6KrkM8EWoFmiCs9t81uGDKf6/cuQZzb3zYZfwWaMXMZa04TaOlqqBZp3LPkZmQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9jcctSYzrzf/QlKT5k1fYpokLH3t2f1ioWgXcGkMpWAk7OMA39
	K+rWb8tsjEcKpKyNmYJE83mUN0AKf89T5mH9cKuZQvsE+0yyRCf7rxxo6FGoSGzRLKFQnPDG4MK
	Wwa6B0MyTaznqWiwt+fOBvPsFXiB2tgWuW+zSQkI3lHdY1wBpjiEQVq6CHvOmEe8SUjbpOQCZ1X
	LffAsP
X-Gm-Gg: AYBFou2zd5lN+J0EuZeLC6HyeqIME2HEeEioSEHQ/zj6JeS+wTQeEU+IJjsiAtKJ2ne
	G0SJkn1N4EdycAUJIfsk6AtteZxK7jXhZ2kLoDkxlJDmknyE+fDXtqJbOKSbYK1sag2UL/XlDuw
	ZcuuE/YioHwNiu2vS5lrBWW9svXEbWDhhRxlQaQvjPw0t5LYm8CU5pt+aJQx+DHATY6bZyNrHV8
	HvSCCyHEppnWDlWF7BZqDOHB1K5s3ODTTMCkFHNg67I+RqAsBXZdBhgnTYA2T2m/UrY1oFxPUVS
	HG3UB1PYJnX6GBmCpqKyMhVFEylc9qntgrnKjc9lzR0su5xXZB32dTyeNK8AazAB1+PdHKzCpHU
	wkrt+TcOhcLkRcwU/abd8NAGv5H7PsXELvv2UwUGixIJpcVhh586HqPM03rcVsuotZX9c3FDSPR
	x1ch5KgAWn64AFiexM8LIINjqRHbFXsoYMzJFQk/RSg9lE
X-Received: by 2002:a05:6a00:6988:b0:8a0:8848:8c28 with SMTP id d2e1a72fcca58-8a9bb0cf0f5mr5846941b3a.2.1793606580960;
        Mon, 02 Nov 2026 00:03:00 -0800 (PST)
X-Received: by 2002:a05:6a00:6988:b0:8a0:8848:8c28 with SMTP id d2e1a72fcca58-8a9bb0cf0f5mr5846925b3a.2.1793606580450;
        Mon, 02 Nov 2026 00:03:00 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad77fcb8dsm1710896b3a.1.2026.11.02.00.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 00:03:00 -0800 (PST)
Message-ID: <492ece60-a670-48f4-a808-f09394b3db95@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 16:02:56 +0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: fix MLO 4-way handshake timeout on
 QCC2072
To: Burke Cates <burke.cates@gmail.com>,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Cc: jjohnson@kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260815014329.3748059-1-miaoqing.pan@oss.qualcomm.com>
 <20261030041902.2740757-1-burke.cates@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261030041902.2740757-1-burke.cates@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: UlS6RNhX53_XDYKZAqFoGvmiUcEjjDJE
X-Authority-Analysis: v=2.4 cv=QuvLTlyd c=1 sm=1 tr=0 ts=6ae843b6 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=_XthKnSfGIqTua6Bb7wA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: UlS6RNhX53_XDYKZAqFoGvmiUcEjjDJE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzMSBTYWx0ZWRfXzWLXI9UKUrMg
 1O0pgEGdvkZolfyk0zb2t9nBEIp8UQeH0+LxGq/aA7/JR2mGSlaAjbn0jQb2CjJBgVR8tstSZ+Q
 nfPUkZjB8l2sp+AKeZ0dO4VtQNB4H5I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzMSBTYWx0ZWRfX+kyQbyhD3soG
 wXaFKKFvda6axBWdpRbzRCy8KA3GOchp/6148T6Map0oTf/YCESppZ1p/eBOM7U6iQPgNixmU19
 VJ7OjXAb/Kc/QRONbvOq5vAtALvb2njyhgVhh/GSMn5B9lmkYGsqsmIJE2RCENxDtk7MO34B3Xk
 ISArOKYJLxGA7EWohRHwI2swEGDMpzfGkcVugrBYfVYCX6SlnSdvCue3MzA7aOZinMYHvQZhPr4
 DyV+G1r6hk8vUmj0A5q0CFhi254QVkrgDBBt1M0O51Inqm2wAp7APqgsX/WjuON2mPgyy56522i
 m14MKkJPSfWZbLHcZxNm8N9JAwH0NP56nPk6hZYj63+lf2CpTdrajo1ElGajieTGQutn4nLFfgf
 iW9OlrgRb0Wd+lqz+xiZSOGPM1JYe5ovUnEO/BYtrK1mENBxiFyTTk+zlZKCtXKJZEBZi4ETN5Z
 qn86ihhH7vJ1GmbS8YA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020031



On 10/30/2026 12:19 PM, Burke Cates wrote:
> On Sat, Aug 15, 2026 at 09:43:29AM +0800, Miaoqing Pan wrote:
>> This is observed on QCC2072 where EAPOL M3 uses the MLD address,
>>
>>   deauthenticated (Reason: 15=4WAY_HANDSHAKE_TIMEOUT)
> 
> I hit this on an ASUS Zenbook A16 (UX3607OA, Snapdragon X2 Elite)
> with the on-board QCC2072: Wi-Fi 7 MLO SSIDs (SAE, PMF required; one
> 6 GHz-only, one 2.4+5+6 GHz) failed with reason 15 whatever the
> association link, with M3 dropped by mac80211. Non-MLO WPA2-PSK on
> 5 GHz was fine.
> 
> With this patch, applied as posted, both MLO SSIDs connect. I tested
> on v7.3-rc5 and again on v7.3, each plus out-of-tree Glymur
> platform/board patches; on v7.3 the tri-band SSID connected as MLO
> (on its 6 GHz link) and rejoined MLO after s2idle resume. That tree
> also carries your separate dp_peer fix (8b6b871332b5, "Fix failure to
> create ath12k_dp_peer on MLO reconnect"). I haven't tried the rebase
> onto ath/main that Jeff asked for.
> 
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Tested-by: Burke Cates <burke.cates@gmail.com> # ASUS Zenbook A16 (UX3607OA)
> 
> AI coding assistants helped run these tests and draft this reply; the
> results are from the hardware runs.
> 
Hi Burke, can you please try if below series can fix your issue as well?

https://lore.kernel.org/all/20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com/
