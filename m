Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400088;
	b=fqfs/Qz4SM0wfxqIy2Fe8MbpfYIQWzWWwlGHDcv7BMkZSDuptcDGBEmluf7o8ov/ANcu
	 ZQcbpsvPB1xZSFZoCQWNLCYvE4BdTtHkgi7PMge8JvgsETqVcRQXZmmYhYUAhdxKgah+0
	 zPUdVwVySaJpTJW6makF6czlK7/T61XoIKuQjbujCfi1nnyoo9aJgzBJDU/hDkMJs+IQ1
	 xLlf8rcupFPbH4CY2/i70YNIEEYRIye5SpLJ8VRA0ZkDQzEclxPvHXn+s+zNwe/Fk+ZyH
	 GJBhyppZOnI7qzz4xiQLWwY5BOZY5aHfbr8LZONSm5wUfQ1yZkTuMwKLjTG2PSH7BJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400088;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=fl7ddgUUfyFcUOWgCrUPWCqwQYDJhSCBFACJjcSWhdk=;
	b=d8wJ5ZhRB+2uaqNbZtN6tGAe0Fv+cjU7jN4jBnLMcmCmOlFsaLkI3Z4oOutVGKjWTZAS
	 3L8Q2d2AVV5N5Q04//9pSo3fPYxQBd8D1Z9Wg9csznqWHwYxqCAUuUMKB4yer2mD3rJmc
	 idC2BifqMu6ELPdjBcF5/LL2qKLYPp8G2cfpS4RVjAjGMeUVmQ/i8VThztPSmsLrZJnMa
	 OSoxzfUDtl03X0zCo8q+qaBrhIEV8dozLykK6ZF7cBJSA9k8J7OsDHytIZwDPBZcU8Dd+
	 +yE/TXppuYFme1uNELxCbQyzdgEy9WY7F+XSpNPOEnHF30DVg3EkIKISatwxUP5HdLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lvnc3Xho;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D5LbNqXa;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31C1606A320
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A31C1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lvnc3Xho;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D5LbNqXa
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ULtLew4185879
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fl7ddgUUfyFcUOWgCrUPWCqwQYDJhSCBFACJjcSWhdk=; b=lvnc3XhoqH9ZnBJg
	QYd+pKAXSa01anmX0lclKrCW+PD1UGRJ08m+sLd4jyRm0rmzfWZagAeokcL9y23k
	Yh6nvKbBbq1kH2gxyX7117FZINqzsmqXa7rMUtOr6G40npA4fpv/DApVIKPQycVh
	Le02so6Je1zmrMoZkevDaaJx91NSLENg2bZTROTslO8yPC1vz1L8qJ1SDD4n5lIe
	jxRP1DdLylofbd5R3kDGXKo3RigHhE5vMKBA0AVM0PMGqSEdbnawbMj0W60uvitW
	3AlgguaYrkkcycuqMSl982rAb7cG5wcrZOf+cVbnkYbqpXFagwlEPx7anWLucGZl
	Hl4inw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn2x109vg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:26 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36637676140so1756355eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793400086; x=1794004886; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fl7ddgUUfyFcUOWgCrUPWCqwQYDJhSCBFACJjcSWhdk=;
        b=D5LbNqXa08pyUqcAxTxsYlAMXzgEPYqHNrvsL/vw66ts7NMz6K3dOveH+syl/cA8QF
         tD/w+2V+dsTldmQbLq/OlDgCHHpjXkliXgBk9VIsBRIXhhYVuSfo3lxyQqhdIkzPzu0W
         m4qvlY7y5lD4AxkDBQfSqzJscwee76nBlwRnAWmX+uKdy6LZ29mFfbmcpW0nAvMeLSRV
         jm80P75k+aqVsrGOxcKosWNt1eOGQ3zhaiKDrTf42SbswB9yE5Mvh4MS7dVfivZE6Cpn
         6Lx1YGyIkI/l12gWGkrZOx0Pfw5mZqk7Y4YtYl4cw1n3jBe3KdNratF3TMAfNEOZUTvJ
         qv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793400086; x=1794004886;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fl7ddgUUfyFcUOWgCrUPWCqwQYDJhSCBFACJjcSWhdk=;
        b=Sh0mw3xC63CFgzvtbCE8OQiYmGmJmf+vuSQzyOqHwoGGp0V/32hWeGR2UVgOMxRA+R
         k3tpRbOAx3oXWVRhA1dV3950/fwl135CEaabUXJneGxspzpLxvg3qnbAgq6o3mSDwZwS
         Gz/THd2HkOqIN6+W+3CJrhKA7f9O5iL4n5UBQ3Jl16Kj9O/4Pj3vv/4Fs0/7phLdzkl5
         RJIW6PsEx3L6SzU3pi06hFUvFcBwmjWFijoSxfjO076NtIw9reOnd5g3EEkuWJuNB8f5
         3UOD5QqhBfQQr5YQvwqvouz9libgBrlP7RTbmNZvk9Hc6+MCDQ1cAFTDowSAxwWMXlQk
         PCAg==
X-Gm-Message-State: AFq9FYI2AZ03zjISA6fD5rkTZNKCz6sOhFZyqd9NMGnrzG/CCfAd7iWc
	UBmZuNTrhb7zKusgKaXaGKCRMdaW1IGs3kuy+pkZC7F82QslqYuFeJ55yJc8yAhhm+8NCUbNa5j
	FFl9K/oo/puN4eqaRe+uPIIoxNRwevl8ZUUV2CtqJpT/qa9e0ztorhtVL9f1U9qf/BMtXTFBMl8
	argw==
X-Gm-Gg: AYBFou0QRRjH6ioDQO3mfZ8Lx7WJyoGkcYzkIZghb/11GBrJjaa1nxNpNerxrX12SKq
	GlQ1PMqOBAMt68eDOWZnH9/JFRpqG34vxJLUPC24hMoCi/P37GvVlzh1zZ0y/wVvT+3gO00eEEJ
	z70MLpLYD2ZWAgrj1uL+YPs73pb1p/W5JcZCK4DSKhWXsu+uyMWoBBdCebT80NlU/ppuOYBqOW+
	B6p1PUU92079e7v/GS5UoglrYd+n0CTOP1z19NnK/tTqGtZe0k28JdwPVeHmgkHMEe5mixcFS86
	4MGhbwUzxttaQKDx/IA8sIs9+T7FD1vp6LYuw6K8I0V8n7f+oWFlaaobBOWJ051bKzqKJuzerZF
	+xgMhZJBlglWR/hA+a7H0e7Vlb1PNiZoKaGyMzSTrCSRhk1WDZ87+Wutf2l5BpLX+BFRsOPOFa/
	BKnJ0MT8sV/Rm++6oG4GH7I961vJs=
X-Received: by 2002:a05:693c:895c:20b0:359:ef9:9be3 with SMTP id 5a478bee46e88-36a4236a466mr5138200eec.11.1793400085112;
        Fri, 30 Oct 2026 15:41:25 -0700 (PDT)
X-Received: by 2002:a05:693c:895c:20b0:359:ef9:9be3 with SMTP id 5a478bee46e88-36a4236a466mr5138165eec.11.1793400084405;
        Fri, 30 Oct 2026 15:41:24 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42935b4asm14002245eec.16.2026.10.30.15.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:41:23 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: linux-wireless@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20261024053923.3585009-1-rosenp@gmail.com>
References: <20261024053923.3585009-1-rosenp@gmail.com>
Subject: Re: [PATCH ath-next] wifi: ar5523: don't select ATH_COMMON
Message-Id: <179340008275.1790611.11842450357073169068.b4-ty@b4>
Date: Fri, 30 Oct 2026 15:41:22 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Proofpoint-GUID: 2MdXJ_VGT6fTDnUWNuxs-1iMYNQK3plK
X-Proofpoint-ORIG-GUID: 2MdXJ_VGT6fTDnUWNuxs-1iMYNQK3plK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA5MCBTYWx0ZWRfX+TfDql4gVVAu
 efI9ZEFq+QvO+9NxIkgn91n72emIOENCLAElOYiGF5/lrCUqEZ+TDnyCiGRx3KXFqW/3Cp9cHFQ
 jjT/iww1vcTLL7/SdUN6HN/bLpDB+c8=
X-Authority-Analysis: v=2.4 cv=abD0Dhot c=1 sm=1 tr=0 ts=6ae51d16 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=zlQJhSe8P0IDTZ8m2KIA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA5MCBTYWx0ZWRfX9Q0LSBRzN9oR
 l5D+gGSHFE4KAp26aiMgKsk2mo4maD6GxjuBYxCsATaHBCsTo5UtxJRkIK1mTL84xmEfIRbLydf
 b+bxe1W067cELkY4NZNhRs4lxGNa2P2vJMLW3kk5JxxFso/os+lbcONC5vAC1cmC9u+WnlgVdi7
 RBIgrZCpdxRUyYuySNP2Ti4i4z6y/pBJhl/WtRUS3MPENH+xRaGDfvhaGnEnuk0xlLX6HBM0GXC
 eojLFkPXgR/7SWC2J0T5ShUhpDtqcLt+cASx2diB0T+5y+ddAkoeLwX/LPbu6ASJPfmSVXWJdgU
 XLnDl96Caaj/F/SkCXaRmyvcISCCrs/jMpebo6oeSYRaOuGt7MVjGP5HIL8VJXozEmQKa+3kKfI
 gHLh+cicohEYfq7Bxfo8WUiLrIUlLMqjpKeV8E4bw9L16T3TcIHVjMSHIuYgSzHS+mQJCbVpsB/
 Pyfh/dI2Yab9DRTgyBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610300090


On Fri, 23 Oct 2026 22:39:23 -0700, Rosen Penev wrote:
> ar5523 does not use anything from ath.ko, the module does not depend
> on it. Selecting ATH_COMMON only builds ath.ko for nothing when no
> other Atheros driver is enabled, so drop it.

Applied, thanks!

[1/1] wifi: ar5523: don't select ATH_COMMON
      commit: a3ddbb45768717b5c9f923489387cf55c838d1ad

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

