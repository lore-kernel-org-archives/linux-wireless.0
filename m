Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793354560;
	b=kjFCGMoS3xnuTAvEqpZL+WOR4LURO0OW8ntWLVnkml7cEZ2ryYr8uACA27B+g6PHtqsj
	 08A6gwYnyRwM101zPwzpeyjS90QU8DOq7DEIlL+NvuZaDgA4dNCwDRx78pkVQe9eH6YgC
	 XV5G7YygsMtlfD9B7B098zMwC3GxzJnewhvf6dWClVoGbNAEZKRkmRYMT09/rBDSKelKb
	 vPqDXm3QH0X7+1a2ei780yW5ZIvIqBqYri4MIumYFthDgyX+lbCfMaFcPKwtLLkDWPTNY
	 Xp/uhtBMcjg1k0jm0NZazq2UFqERrXDj+95b5pMu7/xpFxVDDKVSkEbCRZ8AZ0UGD8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793354560;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XPOou6CQafNHNZDV+h/LKdSD2kkWtiLvC6RPPBJtYFA=;
	b=ye0zc7t5gfHqijLLjRSNPDLTJZIRLOTwQotlpUllIFy8N38Il2mdiA1Sw/X59gDFs1fD
	 jO0LSRuIrIgzFJtwIqJum0uX5Ef8QRI1ULj1IvX9+/lw4/IqWQ3NeCb1r2ZwZmzr79Z3d
	 KycQ0mIUyEhYhht9tadr9cijASCwZ8i9dlvThAwEB63E1ltpr/IqFl4tIYQiPGsxN94LJ
	 Jje8Uu9Xdvd04bsqvILIAac0fwnfrbeKTmQ1BZXdbxOdDGXuhwPXB2baQUcMbkiFrpa2u
	 x8Onp4LRI6Lk0RHwrvDRQllGHkNFi+Oqagnn7sku1ERAOYhziLpa/4BnEkZ9J1cRNRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA9606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 10:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2EA9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8F21Y2721737
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 10:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=XPOou6CQafNHNZDV+h/LKdSD
	2kkWtiLvC6RPPBJtYFA=; b=KBFHhwPYr++jbg4TF3vSjdJW1POzBYkAi3+RvfSd
	RtzlrtdMwBBDIaJx7+ddGCxoPXXfmqWm7EkxNxwTiKaEcrFSpMBa4iZEtM3d+eTU
	BIylE7jUINtqtnmJpg37mM2mJdqS08SL1ZjE755XYPuNUalOxi3xRMeTeZKKCjeZ
	EbOL8tbpLV2lQgWI7m+wpdOue51XGnlbu50aUMb0EZ0v4QVqy4tmZbIl9PIM0J+J
	eiSzVyUm/6rX/jfH+EPgir2UQbmcjw40pAZwGygoR1r5wIuOiTq6yMx1YdVlZIEN
	ad4DhGtxKOQRaFQQ5SMFS0d4E87WWuYt78zNnAjLxqNc6A==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qjbtw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 10:02:28 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso1467277eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 03:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793354548; x=1793959348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XPOou6CQafNHNZDV+h/LKdSD2kkWtiLvC6RPPBJtYFA=;
        b=U4giFQcwsLt8O88iH6fF/3J5vLMK0AZLuczdL4lXN18ry31u43LCXFz/OcNNCU3BQA
         CzcnAoyfclP5+Pk4yXSPHrW1OGIB32+aO1klCCIDdHXz3xcaIZkHJpwFYXnttyCXsTG9
         cAhffzpEQDariNokkBMlEFusJlkBcDoBaVZZMxgtv0rDWcgSfBBod0RhJMk0mD6zReFc
         Iv/CA6aOe5AJ2ojj8/YMkJ0dsaDJ9UsWTgS52GqP3hzpPUKwPqdV+yjLoFpM0UEho4d7
         kAl2HTnDCtmM++K98RA8v7+sJkl49OfeY4iIClunqZ3LpTuBX3EwQXl9zU2idNHqlNyY
         qsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793354548; x=1793959348;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XPOou6CQafNHNZDV+h/LKdSD2kkWtiLvC6RPPBJtYFA=;
        b=uwkLPGN2SNt6U+NCRFen0AZIF2rOX/pO6roXs6wj2O4mue0Cpqbkek1WDK/OGzM104
         suQ/khQLWjyO1P+9KppsVfm/NXNHkiwxKufBHgmg5G74fjCCoio9YQn67/WAamARwfKL
         OPAi1G8whXsdZfUcvm8Vs3RO1M+wB017TL/5tlQXpP9Bn8OPZXR1V+rrF9PHQDZrvh5Y
         4S9CJS5MY+6d9G+mY05d8Qe/ds2h2VEAMjIJvv78a+TGxftIwjTOHq88QrgE6NRv6fov
         yxm5hRy8PrJLATXKoElSycFRtVGxIQEq9MGaacGF9yex7f1yuEsuj1f6FN8pL/ngmOYx
         lf4Q==
X-Forwarded-Encrypted: i=1; AKwUvBz2ix6bQ7TVmMhmKa0pU5iT9dG6IqrV9klQ16Ynanm42PMnxuzJibok3FNrpiUGxXOc1S/drqEmFKav0asAnQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLbEQjmVBVyIH06RkUSniSZvp4HjcocjIy6e6WPRLQV7h9zu3fM
	aeNPZ3z4C6lMyrG7HzzHXIkG2AJrOeEA7AOfcCQUrjr/mz9yCDktonCiS/FDv7YAKiqdANmE/lV
	ikl75qL2/f7PESXQYbBNMF036vtdyaNcKZW0Wz8BKbINM/+7hBma7KzeGyeZy57kQTv3HJQ==
X-Gm-Gg: AYBFou1TUlqtEcdLqIu3MhxGiZe4QkLHg/IKsvKW4Nv7P0ouuiZdezPvjBDXzN5dPXp
	Wb7/clSINM6+SomABNB2J8/FSzhMhrSjdEQuPu3Wuto9uBzopyqFp/NRJqKzo5Th4IFbSlrp7LS
	waKwIbJ9xKW1vjtH08nTiJFAvF9kD/RoWh6Ofjxzt47HaPICUs8/fd3t/wWBXlVVGVVWoT0AHwb
	E4wwJ+BdldHnQMsr6UnFEINbHy8vTyo98Kzu4pUoA2Ie3CbEd86ADE8jX15FJAIxXrurBR8pLWb
	/eNEvMhm/teGTFyrw8fWVZe5awA83k1lfMxoLjKmbQL7jFIFLDb9y65xCJlO9qtv7hA1AUxDmWe
	FozywqEb7S/ganLndB/OHc5yGG/8c23CTaRa4U9pbXk5jgTjjgSxxVsD9GLzSzsnJ5csdKkKk3j
	8+/EMVh5MHx8MmNhU=
X-Received: by 2002:a05:7301:6183:20b0:36a:1089:9836 with SMTP id 5a478bee46e88-36a423c8988mr2702559eec.15.1793354547713;
        Fri, 30 Oct 2026 03:02:27 -0700 (PDT)
X-Received: by 2002:a05:7301:6183:20b0:36a:1089:9836 with SMTP id 5a478bee46e88-36a423c8988mr2702509eec.15.1793354547051;
        Fri, 30 Oct 2026 03:02:27 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42aa8999sm6925218eec.29.2026.10.30.03.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 03:02:26 -0700 (PDT)
Date: Fri, 30 Oct 2026 18:02:19 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Yingying Tang <yingying.tang@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: Re: [PATCH 7.3.y] wifi: ath12k: Increase RXDMA buffer ring size for
 default memory profile
Message-ID: <auRrK4JWN-7rUcG5@QCOM-aGQu4IUr3Y>
References: <20261029095541.685879-1-shengchao.guo@oss.qualcomm.com>
 <2026-10-29-1-daily-reply-0011-ath12k-rxdma-ring-7-3@kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-29-1-daily-reply-0011-ath12k-rxdma-ring-7-3@kernel.org>
X-Proofpoint-ORIG-GUID: KozV8pziO-yQJ7xZFkrmAd3IRF2VBOoz
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAzOSBTYWx0ZWRfXzZc3V7tBu5/s
 rl3CSv1+b9ZrTJMlsZ26YwIGX1diHB3lOVP9DHnILxKGmnfJiOio8haWjwIF+IWZAgirq/+EynW
 zFUgaEpf0/e9/lLNL40jWSz5W1NVE3E=
X-Authority-Analysis: v=2.4 cv=DfSCOftW c=1 sm=1 tr=0 ts=6ae46b34 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=3Y6tUoXcgYOYlkcqMpIA:9 a=CjuIK1q_8ugA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: KozV8pziO-yQJ7xZFkrmAd3IRF2VBOoz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzOSBTYWx0ZWRfX2pQ+KsiwKwWc
 2vTR2fThO2vmHpPKs2KiOuekRmQQwEdtNCLEqZWdAQ6B468PN+YhirbhYoOIS3sN8cCopbf6dWx
 q0Irou05WHYo9B1ruwGlyDA9Zjt6QfltTZ9bNXk71DZT0bq3BRU7PNOwXizHxm5X7oIpPalo4Kr
 LDuBxdJOQSEjTEHh4IG/43N5rCsDkvVxN9w61W6+L4YPE6TTmBzXDp2iJaBO3Ltn5SSypNdZPI+
 J7UTVxP8FxPhUZNOkTIr9hkJfJAhv9M0CsvOJvbIlzi1V52mgTeqtHY8D3GSlhjamE8l/7j50nM
 cKPlLsoh/UFcNi8ienv8+9Laed1TsJHCwfGsvjMrzh3wA/6xrz6bhBpDUZCa4nBMhaTfD1rQDiA
 qSDjN3gK6AStdlESRv/97031BSphQP3y0aPCMD0Co/5GEH7SR9mhUru9JkGls/LwX+ivtVo/Qx2
 gRlCYKIlKKHmH7O1WTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300039

On Thu, Oct 29, 2026 at 02:43:18PM -0400, Sasha Levin wrote:
> > commit 15f7603b69a83a0acc7fcc8992ecbea6110f9424 upstream.
> > commit 643f0bf936176c114d5631da7547e991b5d99f10 upstream.
> 
> Queued the upstream chain for 7.3 as Greg asked, rather than the folded patch,
> thanks.

Awesome! Thank you, Sasha!

Shawn
