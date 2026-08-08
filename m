Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B9C32F770
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786202775; cv=none; b=D0VztOghmWetNDNTq36tjZpUHCiYJjH40xVFSPEq8m7lCZf/siQ0IyPGPk+/AGiNA+iXg64cjIVp9A5E99YT4+vwxbU42j1byFeJwIBriZCFQmkLUv5qpne++jj+WDQO3QBIMDBY9t/ftxoedul4A0GvxhGxwqxAdn8wzQkzD0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786202775; c=relaxed/simple;
	bh=09fcP6NsRPleUcFr6bL04aDepvQsn/37vE6Yi/WlCyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTN+b6iYEmZXCeVRSiwKKcuGuY3Jow4W8wkKhfIdAvWy5pJuZWbKJu4d3aq9YORH6gtL0bSNsTP9Cuy+tPYYpVL8doXW5n0NUuMeGZfgPhRILiI+7BY5ekVhaV4F/Cy+OjngygV8t/9yqAVWPwB45Ytdt97AOlBlIU+6ZL16R/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z+KXoaS3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L7Ic3PKg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z+KXoaS3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L7Ic3PKg"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678DcN0e3876535
	for <linux-wireless@vger.kernel.org>; Sat, 8 Aug 2026 15:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	r9CE3xwkshxnXLN8j/UUUlWXuJY96hDqpREDnP5IHL8=; b=Z+KXoaS3eQiQxIyn
	ePjEL2lTj3zwQ8au5S/WHjSIlSHl8p9rf8o3YOohKOGVWDa9mZ1/UfgXqOaOf/RM
	F9db/dShGza/JA514S4LOfin7Lr5kJYOKBLZ6BQ5yEFUteLwmMe5idzvVoo+8jZP
	tlTlg7BbPdfKNdyltxRBDorNtXjZuWdbs1N8Pk+ehnKG86vnCoRVGplCHeh6Jq8P
	ZTYPgUsNukHZv9xj3c/z8jNfS9h9gRIZuC7ymI6rmI7BgE4iSzmVH4819Y1Nx/j3
	pirNcJviE/WqebWYPxz1oj1XeFOh2D6Z7Mf8voMS6/fvXUX3poGH5jD5IjlmYrDo
	8LhDMA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwvu8h32q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 15:26:12 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c9c26587e67so497692a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 08:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786202771; x=1786807571; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r9CE3xwkshxnXLN8j/UUUlWXuJY96hDqpREDnP5IHL8=;
        b=L7Ic3PKgSIbbOXSq1W0dqNG8Z3m4kqqNZN4fhbAug0s6sixLb33a7P+Lcysmmn9ZOr
         B+gL6ur9Xn7K2NaAm7s5wu6sPjOrOYI13FZ3zas4273gOyHPHXdwS4ufum/+p3eie+pw
         a0mnP8WV1cL6dWZfaJp9TJfS9oCPS09v0G4lgQOXf8c5Y59cSGEWEQoiQB3cmvU+0bYG
         ice+DkcB1jzhOBzI02ZsbMtIvyAKRAmfGEPf+67TLoDzfascb1MNZgWsjaaAlymH8RzE
         qI3tRDLMPZIzpJslObyscQ6Jjtmfpk//RN9ndXDvff8Q5dLA1WNo5JvMqjKuGCKc82CR
         1G+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786202771; x=1786807571;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r9CE3xwkshxnXLN8j/UUUlWXuJY96hDqpREDnP5IHL8=;
        b=IQ+rvMnYSkWwQNXzswQghP5Xvll/WUUez8N5fKmAWDaw9HqzLJliNKa/jAF/+Spa/n
         G9H5vP6S4JIvZqd0Sv/4p+omW9Cap50Sst5tNpThtGxuyRNF51Gk4435XOPGgk5QxEWu
         W0CyLFhgO13YJivbJhWWKCMqb7FN1pikMSJKJxRDperY8YrS7sfkPJcO11YjoeaAc18s
         tys8uADQKrjaXD/cgDZBSZC55jbr8mpUeTvkhmrg7VoaZ8f4hrYnSe/N51UXaiiD96/R
         F4kGZSgmTDLf87Vyt1yAnY9Gd8XJmKEX5d2nX6mxwt03gbKoiat3Se29OB7Gedw0A1xn
         4J4w==
X-Gm-Message-State: AOJu0YwOWPVtEJahPKkNnfsRXWtUFPwTmYxwBy0PrnaA5FxlFJpMJfEn
	dt9xUV2POMxtWMnkA++DrUSNesLdlXnODPa1iIoh0XopUQMQRcZVnBtXXGjnlxsZEEbL2cf0dRY
	TAKKU5huTrJOI54Uw22PiIwuSpYb1HH7FpJNdAQOleXo6iLj26uQVhrFpk3SsUOYMUVNhjwnqJO
	g3CQ==
X-Gm-Gg: AR+sD13YnWSo+uKtU4K/NgB6/rhQMntiAPXYgf1U1ls/alLifXHX1/SRycNNVz1CbZw
	sxTCjDXRlDkAiv4MO2WmQ13bN5sIHKLoS+ZqdD/orQz6MA7AAiqcjo7SMwqX4kHpkRcNEZxnh8M
	W/0nRDA2sFYQELuZ1W3B5Cj/SQ1ERxSqT7bJ1Fwv5G8cFy+pXAsvRUonHnD7ktuZuMz82gCqAdk
	PdmMQPzlvqAM/CW+81R+J5wzzglfdSdT34Smvj9FsXcwPqQR8XO/Z4gjhjBi2Yz1P2wvXJ4STh/
	kqEcTZpzpBK2jZlEPjP9nXzsJfcR4xGqgdGak+uYUcsxjKhy/DJtEA5+N2/wa3mx8Fj2sdHndy7
	nrseg2OYSHGJnz2Y8kayOW/G+37mlTTrQzyL7H6yuxQYgazePc7ScmzOCEb4n
X-Received: by 2002:a05:6a20:72a6:b0:3bf:9bd9:cf54 with SMTP id adf61e73a8af0-3cbd38da722mr6921821637.8.1786202771498;
        Sat, 08 Aug 2026 08:26:11 -0700 (PDT)
X-Received: by 2002:a05:6a20:72a6:b0:3bf:9bd9:cf54 with SMTP id adf61e73a8af0-3cbd38da722mr6921786637.8.1786202771020;
        Sat, 08 Aug 2026 08:26:11 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb883d9sm20509821eec.15.2026.08.08.08.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 08:26:10 -0700 (PDT)
Message-ID: <746f106d-f435-47ca-a33b-32e4b97843f7@oss.qualcomm.com>
Date: Sat, 8 Aug 2026 08:26:09 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 7/8] wifi: ath12k: fix 1-based ring index in
 REO Rx Received debugfs output
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
 <20260806132427.3704828-8-pardeep.kaur@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260806132427.3704828-8-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 6KYZnznnt9gtbMZTfDSdOpxmMDRkHWY2
X-Authority-Analysis: v=2.4 cv=M8p97Sws c=1 sm=1 tr=0 ts=6a774a94 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=2czXWg7JwIIyxzas3cwA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: 6KYZnznnt9gtbMZTfDSdOpxmMDRkHWY2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDEzMiBTYWx0ZWRfXyhuvSQxBf7Lc
 fD0scCg03NJlg4+sZvKmWpMaUZXsIBoSKro5M+8yq8I3ZOzBqPcVnc63IftHTrS3MJvG/vxAEF5
 OaKG9QGFtj36Oe3QXL6hkedT2cO8ESzNSdFJ4ZHZ5bovUqNihTTW2kbqERSY3ustNQWy6BJru1g
 Q78vIs9gI+VQEXCaerSFENLMoSUdkbjZONOe3xtSWoKsrzKtHp5+v1Ir4sYqCn079lZAUp4YnRt
 nd0vJOvhqgp+8+NigtsYFEDKkGMaCbiIyec80eZE978D9BCC3V+CsFsgND/qozTHjXuPJfOgrBE
 IGy4pwaC6MZKQOV+HEof9BeSO2C152P7of5CNZya/P23AU13r/AWX3GnqOxUeBuN9rXMxoo1+ik
 I8nvkJbMjL4QRtXCo86hcLvYvrM00rBds8U5359EKOwJ8XUXY4jpQhfN+N4fiAs5SjC2lpCsnfc
 brMGw4fazAyHPPaA4Xg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDEzMiBTYWx0ZWRfX9aP3PLo2L33d
 VtcupeRWl7jqP2MlZjI2xaMkZm/9ymRXeTHcx47fpsgoPZ90w7uto7V+dxIdW3oQbvSIJcrvr2G
 +bU3xON9RhEmEE8IcD5jyjTnHpDQPFQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_05,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608080132

On 8/6/2026 6:24 AM, Pardeep Kaur wrote:
> From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> 
> The REO Rx Received section in device_dp_stats debugfs uses a 1-based
> ring index ("Ring1:", "Ring2:", ...) which is inconsistent with the rest
> of ath12k where rings are indexed from 0. Fix it to use 0-based indexing
> and lowercase "ring%d:" to match the style used by all other ring counters
> in the same function.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 84873d542e95 ("wifi: ath12k: print device dp stats in debugfs")

drop the Fixes tag -- this is not something that needs backporting

> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
> index 216a1af22898..d4ea21aac21e 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
> @@ -1215,7 +1215,7 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>  	len += scnprintf(buf + len, size - len, "\nREO Rx Received:\n");
>  
>  	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
> -		len += scnprintf(buf + len, size - len, "Ring%d:", i + 1);
> +		len += scnprintf(buf + len, size - len, "ring%d:", i);
>  
>  		for (j = 0; j < ab->ag->num_devices; j++) {
>  			len += scnprintf(buf + len, size - len,

