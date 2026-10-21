Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560464;
	b=rbP20wY5DG6b3uiNN6YzddSxtKzhJlsNnEzWuUWe6QSXPJt3JecJCkjaXIBnzbsK6k0z
	 8Tj2atvDsDPMv6Amn1DOm+LzkHYIVCaucm/rpShUzyXQqOFM2dBpy8thMO+M96vbF9+h+
	 k8dWsN08ebT7G0p695pl385qROLVc+ewRTlzdYITEpyirz/R+TGJT/8SdDbGMUSLOeQok
	 Pj2gcxmYoQm2uM1kGF3xt/o2wEJRAmyi820Lmlus2VGuBwxoynoxYwgsSiFuXdiYOmzrB
	 1ih0z0m/Ou1EfkR6eSg7Ro/GipEtD69QBu3ei4lhPyBRkxYNIJbO5J9cSCWhGWt1Zow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560464;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=E0J+zBC+eUWxbZgcBnl0PcuBy4H53M4vl5AH7OP7Ph0=;
	b=VUOhYqveEHCbsKQHYhli3zHdMahe9olmHubBxyfn4DQ3+pB++evDmXK5aOT5ZmD/2klk
	 gaqPvLaoDyFGEB1CZyK7CC8SZT5ml0qr4G1f7stdrvJQddNrRTPAUIKlawEFpG4uxM5aU
	 2Y+VBTIuhuU+6tNz438IPZ856eGbWPYd3eHDCaAxIJydLpAV/ndbR/ytoTUsbY7NYuoh0
	 xrpLrEuO2g0MpqgxkPLNOR00tpTRZcu0W1KLOH8c95rystpp8y29oWf+0M+AJ/X9a0nJQ
	 JPZT+DzJSu90SB3fZR334fzx4gP1Li4G7tuo7GeHwnJG/NGeV2ABm2xevmDYFQOYrLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pI2HMskx;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JgumLhfR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72DF606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:27:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C72DF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pI2HMskx;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JgumLhfR
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L2Eusd3904751
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E0J+zBC+eUWxbZgcBnl0PcuBy4H53M4vl5AH7OP7Ph0=; b=pI2HMskxRT1GNUqj
	g7QTRwzmFvczF3NswYP5+FHFRSdqLbz/K7H76B5fnvwzT/fWtg89gynspxrg+MCL
	XCyRbZHcx/X1P4z6jBMY7ieN4Up9yH7zy9K3dkfJzQmMpuvpSUR6FRwFrzieX9IS
	A8YVCLpCsrunBsigynp7PlaTI7Nw4NMhvYAZo9ROuqhHTZcvOGVkYNb715PwdIGT
	dSkQ3+6zYhkkBC8gwMiprZZ7kgS2WUWUSbfxWqH2wykT6vWUkl8T0rYDFz48qO9f
	T/zbOPfRxuVN6r7G6G1vHNIIODkLLm9L3DTiOZ0zxV9JWRCEBVw0ExMGFn0LN7+c
	rySxtA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hegs01a8q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:27:42 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e9572e892dso3057485ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 22:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792560462; x=1793165262; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E0J+zBC+eUWxbZgcBnl0PcuBy4H53M4vl5AH7OP7Ph0=;
        b=JgumLhfRIQjHXW0O7uPyqYgmOE8XqCtd2Zmj/LENvuZZ2WWC5VmB7QpergINqmR7Bq
         7BClnEoQIBYMiEID1CGZgkcW2/Ym+cMwbYPzWtMQexuoc+C/p4B7TDYSo+2qMQDNOxwz
         W1aboRKmglhCqADLxICxYHl7IyhHkIwtO5+l2x1M9dpD7IHSb/e3HsOqFYJCXuFQeA88
         QIYKb3zH7gSnRGn8dki0UklSYbZcGZZHLXh+h6sE45WKckDUUe9Yf9saiTj51M+H1QdD
         c5eq8f5bRHpsdgvqerQN4tf8YzgyRo40XVdplmpO3DmAaaZhlVRb1GH/WNw/Aoz+tYbD
         zjhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792560462; x=1793165262;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E0J+zBC+eUWxbZgcBnl0PcuBy4H53M4vl5AH7OP7Ph0=;
        b=XH3tyoWkk0Jr/6+khkbDsNz0oKbP9R1c9yKU9uo8GLSJ9M+yE5Vas1bK1QYW5ul4mZ
         4JBQ9DTAsgjjFsYvYgjrRa5IFRSVHgKmPeYNov7Tg+k+bi5EPY/U42GgjTKQRc9WU0hq
         ravHI4WTvNHPRbR2NtZD7F89gYn/p5wsNSMU50DLajVK+Q9J2O5+llYVf0WQoWlk4unQ
         s3wKwG0mtNgQuQRSw2cpTyQ6m7vmJjrRZqa0BNKBMmcjgv1HuGoCHyVFXkYn91Cil8Mv
         6sHgNP1/t1zs6kdZW2NkiHEKK/lNu1ZB1yrtfJcSjd2k26uqPv8HABTOLuggYls8LRi5
         WP3g==
X-Forwarded-Encrypted: i=1; AKwUvBwJXKWlBg0BB5pn+5FAC11VnvABXmM2cRvWjgrG3eiiq4Rf206IF3FMbBTQP6hNZCCHMUgw7XAuTnmazdD9Xw==@vger.kernel.org
X-Gm-Message-State: AFq9FYL1M7yh0+a4XMECDD8miTT1WOAybFOcqcGE0iSKQppoUD53qnjZ
	+a4JkVUfAihO4Nh+duNZIlhVcsi7wPMLhmEboQ4HHMUcABstZ5ZvhV5u6kyirpVWdIqEwtDbDbC
	qTzSzj4YxBBLb6RtxvO9iOuRC/k7TsqBb/oCy1SjeY5UjrfUqV21zMmhyTehrOIm1d9CCwQ==
X-Gm-Gg: AYBFou2J7bBwjAvS/kxt24YBZCPQe7J0VzIxenNbv6TIUqU57wmpXCP1Ghas97W6FH2
	XCUBmsXhcP06XszIxY9tST3Nf+vapuQfUzodbJDZh5dIlIkrnUO10GFqE+JlZ2FbGz0W12uxHRa
	QFRcG4u5vuKrb8j2lh0uut1HU0uUfDAcgAH85XSf0PW84Yed5IggDyv07sc9SFaYk5sl9tTMVtL
	5Bi/sCR/Y8+mRZqZkyqbJLIeOtGrDmyT7dsEfqu7yi+ayaBVddrpwEtHhze+SfO4iad0WSi3zyR
	BqO8q37bVzWlotXGoOrLQpiarh2ECAXpSrDHahTc7ioO8yey7MeRRX8RaHwMxvuZA1xXJpO15qW
	r8MyvfELD45E+gMjwpiZP6gJvz5fSu/3NGA==
X-Received: by 2002:a17:903:228b:b0:2e9:4b65:369f with SMTP id d9443c01a7336-2ea43c62ce5mr8191855ad.34.1792560461659;
        Tue, 20 Oct 2026 22:27:41 -0700 (PDT)
X-Received: by 2002:a17:903:228b:b0:2e9:4b65:369f with SMTP id d9443c01a7336-2ea43c62ce5mr8191605ad.34.1792560461167;
        Tue, 20 Oct 2026 22:27:41 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b49caa7sm5949415ad.69.2026.10.20.22.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 22:27:39 -0700 (PDT)
Message-ID: <4dbdf8a9-8a91-4a95-9d53-b707666b28d4@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 10:57:33 +0530
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
Subject: Re: [PATCH ath-next v2 01/17] dt-bindings: net: wireless: Add QCN6432
 device tree binding documentation
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
 <20261016-mpp-bringup-v2-1-f510c33bfcf5@oss.qualcomm.com>
 <20261017-exuberant-benevolent-gibbon-86a45b@quoll>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <20261017-exuberant-benevolent-gibbon-86a45b@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=S/NMU4sP c=1 sm=1 tr=0 ts=6ad84d4e cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=86XGhZ5msFO19tOyMwMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAyMSBTYWx0ZWRfX7cXaktdBiJhF
 l8WUCNOWJPGV1WzhshbUom2N9Ec7WiaErLvQnBT08r8Uuo/VmQMlVNlJiR68zT7fz8cO0seA6gg
 0FedwtGmLfkQ4kanwjBpFDhxCg6quHz+WJJ1KfxNlpGOljZ7F6jjFmTATf7jjtv5HBixSz5e9zt
 JiKkIa99YgNDh5hhRM8gFmuGDU4fc3wp2sDk5bW5cZOYnVLP+AUyOdJKgVkju8n7OTKYOVf2YZz
 CRONcu7IUZwOS26hphbIm8SPTmMX9MIzkZvpZeRsrFZAMEICBUvjkhSBkqVBOBPkYqiJN3mqJKE
 bdaGoQ6orN7yRvO/7wReY8fQqWBAZjhAcSnZTRPT8X4053yFQZ1L7vH3kpLPaBeWii+ff1eJdTx
 qe7N0CnWcuAI1mWxit6sf8Yfr0IskLZu/Z2s9CafFzocq3jAp8kqtM8Zy8wznDhjLJswsmDWMsr
 PEcQxs1A6APEb+PB51A==
X-Proofpoint-ORIG-GUID: XiZFsd7awTsDHX34WjhKqKja-LJ57twh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAyMSBTYWx0ZWRfXzHl4r5HsBe/J
 hEH2gcuqqpK0UrYuf0GqMbdN8/2Lzk9CxNyuYipO7EJIqrD39IfNrnLJtYvm23w/1G1E7sd6Zeh
 vi8FoOUfGdp5ydFls5/ihb3THRbZWjI=
X-Proofpoint-GUID: XiZFsd7awTsDHX34WjhKqKja-LJ57twh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210021



On 10/17/2026 10:31 PM, Krzysztof Kozlowski wrote:
> On Fri, Oct 16, 2026 at 08:51:38AM +0530, Aaradhana Sahu wrote:
>> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
>> wireless device.
>>
>> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
>> platform device, even though the Wi-Fi hardware interfaces over PCIe.
>> Document the compatible string and the resources, including the Q6 remote
>> processor phandle, MSI interrupts, SMEM states and memory regions.
>>
>> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
>> ---
>>  .../bindings/net/wireless/qcom,qcn6432-wifi.yaml   | 149 +++++++++++++++++++++
> 
> Heh, unfortunately need to retract my review.
> 
> Filename must match compatible.
> 
> Best regards,
> Krzysztof
> 

Thanks for pointing this out. I'll update the filename to match the
compatible string and send the next version.
