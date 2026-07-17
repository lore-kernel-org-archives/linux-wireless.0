Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8979E42D764
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300773; cv=none; b=vBfAgyAMPjlJlySnm/+noRP9BCR1BPKNqr6AQF25XWt51TayHGQsa170Y68ecqhAktGzluRGjvm2votvV0K8JcBjxlilWvxhLchgGH9XFLcqzRxFIzg3+PQXSJqy2J1PJSuj0WTnLQH2eY7CkzRtz1AQaEVFzqVL0pYyS5Mi9qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300773; c=relaxed/simple;
	bh=9VkWsm4QRs9dUSd6/6dOYCgQXmhzoHK39y/6eyAkwfE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=e1Uzi7Hz7BSEront8deLOt3JzGphei8gXi//ZhBqjJsPnmSpQI/JOtSF4Xfkm/HdeD9WJx+TI2PxTzf27ZHCgBG80k+/61g4mrcImB/OUylU/bfeelQDW7N5Np4fY/KMQKl0DQDWIr09pDbyVasYOCJ7MS1Ym2hTY7DzSAx8uaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nA3Hz/z8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A2ogfWs1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nA3Hz/z8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A2ogfWs1"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7uFS2106276
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	l4p3TEGAo50xViMa0mLxtrvMyupxCIU52JinKAJuBPQ=; b=nA3Hz/z8glHnVomw
	/n2fAZX85ZjXPngXvYzPTv4qtmvLPj5Tr7Dtr7Mh/J5HqOQacM/ZxWHS6Z6TeC+5
	Hp4bXR6Fmx/+YJupAAIxFmSKOaKm5KIDDIObD7aZ2ojuULLsg4QocGZrniM5uRCb
	vy5XpmBjXxzujYOqV3tm1AqG39J7IAHMAx/iMgEPgmxdGD4OieKKIKACwYsCvwdw
	Kg69ELGMmKqC1XLImEMLHqEgLJGjoES7Itf7sX9Tm7nQGnkm5uhMbml6C4S75axN
	CPXcmpNl0wzFw4imPUP5TXTf9XR2KBxO2rnVssUfqvosM4GtlJpLmsHxRUfmg4qT
	UWXPwA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffhpfh9yd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:11 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1504235a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300770; x=1784905570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l4p3TEGAo50xViMa0mLxtrvMyupxCIU52JinKAJuBPQ=;
        b=A2ogfWs1wcPxeDsDa8haOqo2lGr4ps2lpJVDhncuk8uGCzBhP6O3AIyOFnxxq9dEnB
         e55xkJsWjHXiREP5SnMDXyeykIT/1EqfKGlUMny6LsW2DCHHQQEGU2vffM77pzN60xWu
         H5/DlMJFU9u2spRFkXlotq4HM0ej/v7M9/e5KvQ44h1vpdNNSGSr3cEiSWM5yJl0DJzC
         3DCLzvKN9EzCrC5fUQkpLhwp1kRuQDOuKZZ2WsxPfKkTDzalxhLfP245MgEv2MI83gwt
         kP72Gkgia3WQ+wLlTzgAEw9GHVcnuiXZfFbLlPGX0BQcdOf2lkFW1o2GNqn89d8olY2r
         yidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300770; x=1784905570;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l4p3TEGAo50xViMa0mLxtrvMyupxCIU52JinKAJuBPQ=;
        b=iOq3uJTVZ6p04I6ZNoqJn4jb9xtNcIaIHbj+rqv2pYZ0QeBwpMMybMFnZUz2/rrgWC
         jz2KM3RSEUGaHCfQW6YSIvVfVj89iXiDngSqP+Cs6f++MGcYsSaAHvJsr9W0kH11Z0pQ
         kwjKRWEk6lJQr76wrKoYG9MEI9nsKs1I1jhAJgfVcaT+VVCilkY37okbIh8Ds9jLDvw6
         TF6rdOKYE3B9cM3SR0avOgfGzlksHqGao5UepPBoQ7qu0d6gc9R8QQuasubC9IsoNtEu
         vQvfETky1FH+rgTQ7brzLz5ffWsSbDLgua/AqNGv2zGMHk8ERlm/WeUU12nBIv9XLh5/
         xtBw==
X-Forwarded-Encrypted: i=1; AHgh+RrFWXAZ6BSXcfCsQH//nVPElMz8LVjJl8x6bU69L815rV8y917w6J7jKUOtBRxr6znV9poeNGuc/ptncj4YEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNAnFq2mDYKXKQ+dAyVj6ff32MqxIlt5v1IsPDSDufZ7zWTfH9
	tyUy64Udst1O2yS5kBljtO4Igw3t44swabRHIZ+/wUR8PUVae1AoN3Y2QdtsCjLBO1hgKdm4a5p
	fEU7BDg6hGJj1xvWvFlfxFCTTRCcteL1Cg9Z6z0A6MgY9MYOecFjm9RtjL/8pc8VLEhjXzSphKf
	ENKA==
X-Gm-Gg: AfdE7clEaAt5Ue9cnqdOj/isE95yXoukyDYyY99pr3RV2YDurlSgRixXnQKKUZQaOQp
	E5E3zl6vfsDe2vmANactC3v0YA8BjuHi6VkxtSW6COKC17d7BE2+4f2OFJYDYJ8omJib3dEwgE8
	M0PJxu70Tlew1koIFfw56T0q2jVWyegBRQYSGIk9s//cdav7kx70g8rxCI25X78JsKGrsQPDbKD
	bWf3tPXKZSzYYozPSPrCjGD0FOiLN9F4JJqRdPIQLs268idIdtWsbuz69a10/Xxg5zNPdVUg9ir
	CsM35BTRypR9seUCw3L8mYMcOvkicEp6JxTrTGT2go1wr/1K2tNb6eSCF5xXp+h74iHZoUPpkK/
	22ZNkLw44uyqH77lI7LmRM8vVMomG23+w8p32jqw5YDj18skrTbORGmQ=
X-Received: by 2002:a17:90a:da86:b0:36b:4d63:4a93 with SMTP id 98e67ed59e1d1-38e3d21fc15mr7255018a91.13.1784300770089;
        Fri, 17 Jul 2026 08:06:10 -0700 (PDT)
X-Received: by 2002:a17:90a:da86:b0:36b:4d63:4a93 with SMTP id 98e67ed59e1d1-38e3d21fc15mr7254971a91.13.1784300769630;
        Fri, 17 Jul 2026 08:06:09 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:08 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
In-Reply-To: <969d732e2c6f169e1aa5e89c7e01743a1adb55df.1784010931.git.christophe.jaillet@wanadoo.fr>
References: <969d732e2c6f169e1aa5e89c7e01743a1adb55df.1784010931.git.christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v2] wifi: ath12k: Constify struct ath12k_dp_arch_ops
Message-Id: <178430076786.128359.10643101937455909473.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX9kWdFVtxFstt
 e+3bPRAM7BqeyQu30q3QasbrVJwNzcKtmMAKDfith5AugV7J+Y+nkqFYap36fjANwsO2+T+v1qc
 B7oBsFzxsdyXggPhSqNqQ+oElbNBupuN5MdObTtfH0q7beLqaGiKSjRpjL03xH+UpOIv2f0e8Ck
 6eO/AJsRcstJW/M33mEWZrBl+OcM71BOPEDoiu2qEh2G8zViewwh6OoZEQ6jw9N6MbtzX1sbwz4
 AsSYUkPL4u4LoHSKgrHahgVDV478eCxwVIt0yd03Ke2RAyvq+NtPU8JCjmDbjJm2eUiCTM8l/sD
 IUn3fx85yJ1tV+lyXG+iPRy2aKPv1ex71nMhppUfcpOvWodPFsYTNHag5AtS2AHOnmS33dmBn4r
 QPuCYXsgWK7pyqWdmuIQ1wTmtALW1D2R9bKroPi2cJeDoA3ELIbK9+yek7QbAIg+0sF2cp3LSPy
 VSteABrTJlQdd7a5taA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfXx7DrAzojTwwN
 b28m+FxDtx4pLYW0471BofgkjLrCmNvF1SIrKHUN6fLDryI50/g6iGRd57Cj9FLTo/+a6BED/ge
 hpYoQD21z7dt6GtakuPo9ngg7DGvMoU=
X-Authority-Analysis: v=2.4 cv=YeWNIQRf c=1 sm=1 tr=0 ts=6a5a44e3 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=riUHQTvyFV0r_oIck2EA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: jtswSrsxLpCmFxMmqFG2IKUbzLgbGaO5
X-Proofpoint-ORIG-GUID: jtswSrsxLpCmFxMmqFG2IKUbzLgbGaO5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Tue, 14 Jul 2026 10:39:14 +0200, Christophe JAILLET wrote:
> 'struct ath12k_dp_arch_ops' is not modified in this driver.
> 
> Constifying this structure moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>    6318	   3384	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Constify struct ath12k_dp_arch_ops
      commit: ca435fd0650ac512ab6c5bdfeb90ed130b8f7574

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

