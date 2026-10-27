Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793127254;
	b=sY8pD8k+5gIFARi7A2ttUub8PlsothWO7502OaPlH1hHDYlFNO/cQJF2cb82jbOMKu+i
	 T01x2GT2c/MDZ2Wr7A2wFBonjkRx9I8TxUeDKKgHgG70nrntItFoqdT2Z3tMLf02eFbAr
	 u8RPlAzDTgtcgHJOfkiKQqLKJUrv0xhm7JQEai07WthSZ4YAm/DPBp3HS5M27RToAPNOQ
	 TJ+9M0ZRlFm4G94sCNK3qzkG7uovDYW9EQQdgDGRh4jtPPJ89U/Retb5g5Yc8WoxdsAdW
	 l2VwWM1et3lNW+zuN/+crYRbhMUhggU8TEmvWxXbTQ+jiTR4Q+O0gHS5P+NMZ9jzcaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127254;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=8XFT85wuLsnAuZ+7nctOOH8ib1XLKOpS422jcqy89iI=;
	b=OU/RZiNTvakOcdpRjDr86TiETY3jMrxb9KI5Tgt8x6wRf8GRHOA2U7p3Bvx+KM+4TJrf
	 OsppJ/UbNuCbT2V5rAbm4T+4fdYCJMoFM50PABBQ9Pfhh/fSHi+mT9jnB0Z9dCkeCOm8/
	 zD6nJEXE4iU5pb8h8uYluTEMy750phwKxSdAF6FVIFVtNK1r99lUK8JJhg2G1mpnxOTBe
	 Ojbfm7HdMZ/MgeYUP3RpbdqbWde1X2HANEoQ+0wB6/SL0r/ifSSYar0C+nPvix/IXEUa2
	 tlu+oJs0XOhmGH2/k4FCXCJr7w1lBg5D0KlC/3B+AKnF/AUTIiOg0gAwrabfBegoMpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Z2eILnp8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JnEaQ0lG;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09E2606A327
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C09E2606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Z2eILnp8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JnEaQ0lG
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIHPlT3553880
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8XFT85wuLsnAuZ+7nctOOH8ib1XLKOpS422jcqy89iI=; b=Z2eILnp82PpsJedw
	LIGYWdssU9J4SVaJex+vYYcWPc9VbKiP4ckgSu+WWkAKtxIjTTLEAutqdlx+wnTy
	t718FnjwwSXqE8eJCNYpB+qFpoPPDu9+L7GVDnIVfrRoHP9r6+075AwQpevxuHkp
	RDKCQswSL31nC/LrZSL3oLxmKYLqv8l+viESGA8UsWB5ODSIQXi9KefsFV8zqX9v
	feqF4kmp0e7VaA0g53ksm4xDpS4FVgvaqiNO1pmRUOV9Jwvu+wFTQmWJIJUb12BN
	qceWNW8e4T7PariUool8tKdA67rlpkJFnNgFtrebYeMf/DfcacWhYfZARcbn/gYv
	0KffqQ==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjqw22spt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:12 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-139b62317d0so435108c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793127251; x=1793732051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8XFT85wuLsnAuZ+7nctOOH8ib1XLKOpS422jcqy89iI=;
        b=JnEaQ0lGrolahwb1FronG8Z7T8Y00BxHgzmMruXTm/AJPAh7myomSNqyIBvNtH5O6a
         YWT5qcV/g/nlfkz+6yf48tVvB4Qew/2okQKXktKX1dqLk0wJnyoEjfDTJK6VhE8S3mLw
         0Y1nvHXivUun6DdJXJM3OD0JSDIm+fp/8j6S6kZzfataTSHvpOmkW0xmZH71RZ26doWL
         oGVtLjQ2+KtDyFeZM2kS9O3CflDnNG+SZnuKShGTlL2IANIxvQ6GaUgEETaxYOkDx8Nn
         ameR97illWwVRPNed4I/SpvBpioU0tPPSw9cNyb9N7jFTa4ZBJDh/oBHmqCgCzN2bXIJ
         uqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127251; x=1793732051;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8XFT85wuLsnAuZ+7nctOOH8ib1XLKOpS422jcqy89iI=;
        b=sj4mLBkT/udMGbZwxD1ctRprwW+yoEMBoYvToljSNUN+qo3uH58qokAyQqX087QDT/
         Vp957T76OhhWGN/SlNDMmSXzXV4cfTsjJsP5gjibtez0nG/szpScQfrMBIZh56u0Shzf
         M5PrPpAY9BDEVPgpV5YDto8yTFRLl4KkAs1uyFj4gmvckweRVPJtWgeI+0BRt380k8XF
         HlVQjiy5mXqGm1IYGLsKiddCRsn0orPtiVFNs9DWfu8Up6MxRe9/O6/q3hSInotcCLlZ
         sAQmx1tO3pEUdGg0rmljxYuy3nVUw9rHeYc3H7imi92Rbz4WAONaGDMy8Vjr+l0Dv/1b
         EUgQ==
X-Gm-Message-State: AFq9FYKP8wKRYxyB25o33g8otkpYocHrtn4OoEXH49BV2j0vzEw0MMQl
	K4lIgL7CJqg1nv3rED44ji2DCsWqk9OUsjD1GGcprl79KljXaqPUswLkNnmeCgGGgiKUx1qaEb+
	m/LxZbUZzQi33nBJcTgH0X2Cu/XXrEOqoUAddZBpeCk9CYZsvah/bIRVaEQTu8bu5O9cy7w==
X-Gm-Gg: AYBFou0rceNr4DIZKzX4bltLdr5H6VO3NIDUXGr1St8oStgY9YiR9Ycx0utmLzZJvG0
	PVmvZ2+hKdr5pZbq2dkM7BNDlxffZ6p6LMj+p+Dq6bu/7JaNw2RDrWvaGhNbewWO3ekWsYoxawu
	JhxBLOdDnPI/IV0+Qz1rxfGizSmo8dWpR3j9fx3CRBkyqDzKMx4q7M8MShCQbrfv6hF6zKPVd1c
	dLVzw919+0cG1z84zHtvEG2n/nGKKgEnQjiJNjMmZEa3kk9bImhPhTLVj6auh5ZYjJTL1MrEs1P
	PDPnmfjbmSim+Zd1UZQCbLAv2KMM87dfNifzkmGKXHyYyxO6Rm7p+5vmZX5drRsAkZYhlSFpaHG
	4yqZiK6eAckvrMCvyvf3VZY+X6q+tZiaqKJgooP0ZOmxTODdDMtfunQ==
X-Received: by 2002:a05:7022:258f:b0:172:c87c:2c46 with SMTP id a92af1059eb24-1a6cc34d4a9mr190074c88.9.1793127251283;
        Tue, 27 Oct 2026 11:54:11 -0700 (PDT)
X-Received: by 2002:a05:7022:258f:b0:172:c87c:2c46 with SMTP id a92af1059eb24-1a6cc34d4a9mr190046c88.9.1793127250560;
        Tue, 27 Oct 2026 11:54:10 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a14383b02sm8989983eec.14.2026.10.27.11.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:54:09 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
In-Reply-To: <20251219173217.768713-2-u.kleine-koenig@baylibre.com>
References: <20251219173217.768713-2-u.kleine-koenig@baylibre.com>
Subject: Re: [PATCH v2] wifi: ath10k: sdio: Use pm_sleep_ptr instead of
 #ifdef CONFIG_PM_SLEEP
Message-Id: <179312724971.435197.4267734363881376863.b4-ty@b4>
Date: Tue, 27 Oct 2026 11:54:09 -0700
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
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfX2/7egEFEkkG1
 J9sGGeI3JyBJVo08m48sNjp6g5Hr9M7IMUHpPoT+uF1Edpl5zXd3Tu/B7vQrlYEsdAoXUFsaYLB
 EvBHn7ieYAoXGQ+1mWGV7Rzchksgc/zpGOcwDRaeuj8pxNvMFm/ebCv1j2OGxD2uYF8K7YPLfks
 z7w35X1fR5srsKl2YP4Zf+ikZSqdTySWE7u02d42AqRCrkmLv2a3J6ePxLAOAAHH136WnWwdYzy
 VW7LB02WuqVlzUDn0v6LnmY/WkpDKP4jDCQVIOh8O/rhe6yDcs0Rc+rP0HKq5ZJAqwXfSkLD/GN
 zQMOUO42x7CJjv+Yx727rVU8bTrWZ2xVrRAceg8yu7YE/HtVKzjWig4F5Qzb5XjnsFrU/mJ3gkD
 M8dMRiJl91TMHJwUPw42cbbCBQJjMkOMaW5WEj22Ln9RqAtUDpg0iECG1SEcoXY3cmqDUuC20mH
 R9dwjb3Q9PwSj6QnTSg==
X-Proofpoint-GUID: cUwwbN-Pz0RH2hzKo-ZRUzMibksfibyC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfX/Vx6QPk78iM1
 FB/YLS3HSO5a1jI1zP9LgXcr6h8ITYyDzLAxqCsXw/6JdVwajXSAQjzAJ01ZalNGvtmCCAwFTxN
 DsIEa8l/eZL+YOAr5LDCWl8e5alEaSA=
X-Authority-Analysis: v=2.4 cv=PsYG/AM3 c=1 sm=1 tr=0 ts=6ae0f354 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=RqDgkBQ7Q9aaOx4vuq8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-ORIG-GUID: cUwwbN-Pz0RH2hzKo-ZRUzMibksfibyC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270075


On Fri, 19 Dec 2025 18:32:18 +0100, Uwe Kleine-König wrote:
> This increases build coverage and removes an ugly #ifdef block.
> 
> To prevent "defined but not used" warnings use
> DEFINE_SIMPLE_DEV_PM_OPS() instead of the deprecated
> SIMPLE_DEV_PM_OPS().
> 
> 
> [...]

Applied, thanks!

[1/1] wifi: ath10k: sdio: Use pm_sleep_ptr instead of #ifdef CONFIG_PM_SLEEP
      commit: 48166d60f0c7f874196a5a02d9b13f2f07193f7c

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

