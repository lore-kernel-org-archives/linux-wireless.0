Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394571;
	b=gpWEWMczRMPG/BN31qqzQSyZwV61PxCuVQ2g8kG5T2tSzcEqIXwuZllREAPuOGzJdR+P
	 Scy8A0JFef5sRPU8v3n7Tg+XZ6+nNcxkLf2lKO/eGfcQ4EsOnDzftF3Uu5oPe1t4YficW
	 BidMeUkF4tYVWtCCGPK93Mj5gTPDEBeAF6PcwIMMNmIyVUJ053fh9HTqhDFkw539c2xKO
	 t2h6dDsZquzLBUaYc3Fk6bGWoCLkpfgmIAlx3QStqge5V1Q6V1GgGmV/p+BBmx3azmPx/
	 C4CFK6gDcPFYz3CP3PBok5ZXYef+rCKhAm+bYEOndUIEXq1gcNB3eiLfLtHm7M2YJhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394571;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=WyqmVzX7xZ8NzVi/5Q8p54DyZ0b9jXCdRbzCnZn/r1c=;
	b=n6d8sIPQpH0Gd7G2rTxGxF/rFKHj1R63F4qWG0FBPjH5OoPuZ4CrZWexefoWqBwnLP0N
	 REVUxjKirpNhnOc2sZnwSU8SW0riR2qjZ7yWZEZeoPWeReQZwt4lIamo7JPkwOtnt+g19
	 eA+wMHIFCf1t/v4xtcXuP92iqih7yynJzPwAcZM4DK6Zo2G0JbNWCZqYZh1xyEQkpv/xB
	 NlriYs5D62t+at3BiG150N99fReXr/0EXQG2EHaRHqYNl3elJObUhF+rypvuNhtu+uslk
	 q1CJrHdimNYWDLpqgY81zAnFxZuy0rSz2k2WCrTi50lXQzRaPvSSx1Zbfeu8Xeeu7vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CypdlOSS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NGvI4Dbi;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D344606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:09:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D344606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CypdlOSS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NGvI4Dbi
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UIiS1J514346
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WyqmVzX7xZ8NzVi/5Q8p54DyZ0b9jXCdRbzCnZn/r1c=; b=CypdlOSSajFHnoDj
	0/CsXLC4vGq2TCnPC1nXPvvQHSQL7VAg4TfLDpcT1JVA+2ZlBOj5dSs3+AyD/HpU
	ffuAalABjBiIwk9Vt2sxEsGuyD9363kEKlweElchT6MulJwLn44vyNKxYCuroV6F
	GC9aJx2/zSUjUI+1RL9bkNfej/6NITLxVXvrNTPt3vKAhLhs5OQ7V622HcRN/r9w
	KvilI34xeHRJ5V9OXq7X7AA3RsKYp5L9tGlGZZCqj+UbkfJS/OWsGkgOck1leZIj
	YDlE716cQUB6AwWMnldKmq3AbDMxk0KjhdIaXqQOYQo1jzoLqbRf1SJM3y+JxUpc
	V8kgHg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn0sj8d87-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:09:27 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36637676140so1678594eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793394567; x=1793999367; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WyqmVzX7xZ8NzVi/5Q8p54DyZ0b9jXCdRbzCnZn/r1c=;
        b=NGvI4Dbi9B2EBfWE8wxN/w0KFPVv7KLJky7V38TOL3EzDaowLFiMK8v/alvQwJWH8u
         f7HoQYgonxZYuUA6C1IP+rls2rghom4mGiqRGl0oimOpfryE3qmmu4LRLNNzXgiuaUrM
         zoIgCDGNv2068wA75Q943mzRT1xKv/OmtFXUkGNtMdbpV50KXaG4aIxSoP9xe/0rxM85
         Tume3gDMAzLetjIK/GxKo/dbwYEim8RhK9k0a6/GuWhWHtekGEzgv1RX8tTIELZwHJZ9
         tO8VpTYsNgLswkX3Ef42Fss1bBJE91W1aEq28UFZ9HalsngB6NAZ+1KP6W30p+/0iHqN
         vgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394567; x=1793999367;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WyqmVzX7xZ8NzVi/5Q8p54DyZ0b9jXCdRbzCnZn/r1c=;
        b=pVlb2iRkMe2yFBkBsF9tpb3M3d6jTrtLSIJgWZCVmL7ReralgsRnzfp4BDD/oOD2uc
         kBDBXVJrOZRQ7tmfUtBrJodhJm62DD9V1Q340xWteu0yNwr3tQKgc1vfkYTx/bqbrKMZ
         L1Hv9EXb2lVRiAQrzEvkfrWySn6lPdwj9XOvYJbzBXqwxrToJ94ekHG4/GbjnxJc5bd+
         8VH0HzhwBmJnHmDWzQTlPefLk8F4mtYqlyCePC0VbFPP5YEnrmjVFgpTV4VsFNrF+uTz
         02a01LzhZifLDX5XO3P4eMMtubr9WMKV7LZJwnJOJt7SIbCrdENNiw/VxASEsbqc2oN/
         /UVA==
X-Forwarded-Encrypted: i=1; AKwUvBxTE/U6lJNMcog6CEcQNhgHT4rhkkc3O6v5BaVySCg/05La2bLnK/yOr57a1pyrxjqQ2KjQgVAzYRQCTxCKRw==@vger.kernel.org
X-Gm-Message-State: AFq9FYId8FI3TlgRlVKp+WhHgqYvu8iPlHAhlkLDPdUwG9WSulMKuePT
	/+dm9unetLMxfcoGqyL9hSOAD2CAQVxWa126gifAtyKBd0VEP3hIoWg3GoQA5MdNRMScAxYpAKq
	4vCTmNHw0nGoKWePxyqxBialm+eKPUPh69vB/FKC8gFIATa+o7iaiymdQbe5HfOG8JP7KoA==
X-Gm-Gg: AYBFou1keOEWr9STHqa8Ha2LVSrC/BiIlGWyEI1/0Us/bHqmkbTSsl8VvOBii1j/tin
	hOfQIRpdgg1Y6tzSymild++haS+M/xcUZXO3Yl6ZA41OmvCzdM2JVVgUWz1HX0CdBA789F87f+o
	btiUhjeBEQPxAP+VkdjumEzlkYjzwVNsoDN/y6IKmxxCvrKEXdCfcLmQtU0Fx9p4oETkNYOYfmP
	pichNI/JOdWdf9QWEAMVSUqob2Dc59iqRusgRyGHRj0hY7pkbVg11ZGA6+XLTiGxZHeth7GI3eg
	qZfvq+cZI3c+CDE/u7d+CCLXavE2uGQVlkQIngE0iRl1sBmWLPA8ETsJES6mGHFRNWFJm6ZjTOj
	6Vh2P2cnwIQeLEKq0/SALFaN30C9h236vZV7wtg8GEC3W1W869Q9yS8E00jKJI6SW3eUoyANQSx
	8VHC2Lacg35VM2kskSQmBzxeMn89W409g=
X-Received: by 2002:a05:7300:c01c:10b0:36a:50ec:db3f with SMTP id 5a478bee46e88-36a50ecdd21mr1043565eec.7.1793394566719;
        Fri, 30 Oct 2026 14:09:26 -0700 (PDT)
X-Received: by 2002:a05:7300:c01c:10b0:36a:50ec:db3f with SMTP id 5a478bee46e88-36a50ecdd21mr1043508eec.7.1793394565946;
        Fri, 30 Oct 2026 14:09:25 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm8561611eec.10.2026.10.30.14.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 14:09:25 -0700 (PDT)
Message-ID: <44bc6f1b-6f04-46ee-8578-caff30ab25e8@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 14:09:23 -0700
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
Subject: Re: [PATCH v2] dt-bindings: wireless: ath12k: allow calibration
 variant for WCN7850
To: "Rob Herring (Arm)" <robh@kernel.org>,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Cc: linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Conor Dooley <conor+dt@kernel.org>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew LaMarche <andrewjlamarche@gmail.com>,
        devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jeff Johnson
 <jjohnson@kernel.org>,
        Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
References: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>
 <179337193753.3936464.10436179036151297295.robh@kernel.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <179337193753.3936464.10436179036151297295.robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: k4JDgyIntdrZ5_gtowD47wuvJB7jPOM_
X-Authority-Analysis: v=2.4 cv=Uun2pOwB c=1 sm=1 tr=0 ts=6ae50787 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=m8ToADvmAAAA:8 a=3poil_INJ9H8gjXqE2EA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-GUID: k4JDgyIntdrZ5_gtowD47wuvJB7jPOM_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA4NCBTYWx0ZWRfXwous+U8zcZgO
 NdsVyW99134tWoBnjuC1aTPre2JS9Ezm2eTXBdQOOlrFjCIjRbr4fnHTYsyzbKpCzV/D2sPWpq6
 EHVFbt9+gwEopB1wIWeihFc+TrN2/RtXE4KWqDTFeKEz6oRsfDPBvEc0WobrAdwmKArmOyNCiu7
 jmETMQUKuTDWJDWylc4Uypnd2Hu4dVNAJP15y9PbYgzsJzpxZwaPjc8TYtYs7FXgT2pJKLRthA+
 YyZXRBYBJNHyBM0YEIi9m3xIa2DePbklDPtzaSYoPjvWufrulxK/GikmutPzF8YAyyjEq0cRlhv
 Q9VAXE8vf23gaKitncWAKE1m7eZ2vzpzwsss1qv8W6Xq90a+8c7drrLBpiBfbfXSKU9q6VrDniU
 dtpig4TqK9WiFxWSdkDnPsPoEUph9SB3SOvCkXsQWPjTw56bQmXd+bc1bXih9q1IYs0ECI0CHUN
 i6Yvch0EHGTlc8UKkSA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA4NCBTYWx0ZWRfXxMqLTS2y+zBv
 ly47QfsrveF7oFyV8yluiGwJHpNoZVtCyVWHIyxiBujFaYGNu8YoLDm0ttxsC/vpQlh2Wc+XkVQ
 fOaDj4N9VgzhlVfrq8TgA6hOtKqUOhM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300084

On 10/30/2026 7:53 AM, Rob Herring (Arm) wrote:
> 
> On Mon, 07 Sep 2026 16:17:20 +0200, Ernest Van Hoecke wrote:
>> From: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
>>
>> qcom,calibration-variant is the generic Qualcomm Wi-Fi DT property for
>> selecting board-specific calibration data when the device identity alone
>> is ambiguous.
>>
>> Commit 06cca100ad08 ("wifi: ath12k: support calibration-variant from
>> device tree") implemented support for this property in the ath12k
>> driver.
>>
>> WCN7850 can be used in systems where the PCI device ID and machine
>> compatible are identical across product variants, or across regions with
>> different regulations. For regulatory changes, the hardware description
>> does not change, but the vendor-provided calibration data can differ. In
>> that case neither the PCI identity nor the machine compatible can
>> identify the required data, so DT needs an explicit calibration variant.
>>
>> The ath10k, ath11k and ath12k WSI bindings already allow this generic
>> property for the same class of board-data selection. Allow it for
>> WCN7850 PCIe devices as well.
>>
>> Signed-off-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
>> ---
>> Changes in v2:
>> - Rebased
>> - Updated commit message
>> - Link to v1: https://lore.kernel.org/r/20260701-ath12k-calibration-variant-v1-1-d3eddaabf026@toradex.com
>> ---
>>  Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
> 
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> 
> Sorry, not sure why this wasn't showing up for me. You may want to 
> resend it in case it is not in wireless queue.
> 
> Rob

It's in my queue, will pick it up now.

/jeff
