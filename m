Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B75503BFB
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789566887; cv=none; b=hShPYdMQspaZNnyjjWWt7mjZckKsBukdS/u3+jvZ2QZ4I1FekP6aCLCLNpTd7VnEiP26xJ97Dkk+IP/9/4pGCP6gX7WlTxQvOEpkdoNYoMVcH05f2ao5XMCe18vUyN4XaAa/BmAy7e3b07JuqCmhd2gEzkSCd/+wMHObbkJSqCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789566887; c=relaxed/simple;
	bh=S8NWcBLj+YrdoibjwPvcuhbTPkW/z/oArpfMYHy6MOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A5b+VDjgzibQit/N0+dt2qqmjn7GhTniUQLD9++XOq6vSw3vzNp1hDwxGmsJQr14ssA9Ejz+fT44JIcKrQ4v17xpIVRNq5ihbFBvmoPPH+/rn2N6sa989hWgWr+R6mJow2Pa8Pl7U5YqkIHaibQPM9VbITbCA42OlfjBDp4Yp80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HkxpW2hu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EsfCwpsn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HkxpW2hu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EsfCwpsn"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GCYjRK1440612
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 13:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xBKa9qbG2JJqXwZ4okpjJqBOx4+RYdnl36N3XOUIuDM=; b=HkxpW2hucq0jdZf+
	/bYiS0imzXwms3eeNFPjBIlvRW4wWfRaC5ghTLWUqkPm74iaX9FenOzTKdMxFU9q
	nP4uKTq9Wo7YY5oW48Rl6fkgPrFa2ttuvZSsCkNeyXgkMeD7v5ys4WcMe65CBUgG
	2g+bk1ALz42Pflh434NS825jEL01Z9J4ZqAOsGbS9O8ag2GpxX3PR3GB9jyNK03u
	NVvG14NZdTDV02sTxMeEFoNy9uF1ygBXbPuYe+qAPqmG29u3CWkwgyVRhvGFj1zS
	2SUA4cvtrzPMr10jZ360KE96+q8TPlbtQgVvKYt5vpfhTyXsWsJG/RG4yGjQsUfF
	9LAcAA==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqqp3s9bw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 13:54:39 +0000 (GMT)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-88b853e209fso37773367b3.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789566878; x=1790171678; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xBKa9qbG2JJqXwZ4okpjJqBOx4+RYdnl36N3XOUIuDM=;
        b=EsfCwpsnguUJbMMC3KdsSAQvVrwmkCnb8iidJrSzJRF1GqJwKY+0PX1SuqfrGluTlK
         VhIVaOvHwX+MA91NJnPMAPx2kcra42IMc18suj9+4s6apidPdbA4aDrBZi6fqhUMMWqD
         lohFbAO4IlsxLdxy85cd4EcBMTl4K3BRXo6WNHaxhySpQjhNxjVoa6qyH59uThqkU1YS
         c3hWcgz3Qmrraw7eKtSt/+Elp/UF/l+4JoaoWyxT75I3c04ZCGENBxmQ75NT0snWX9JW
         5aC3n3hX6zhG3sRYQFP09Y0rnKA+ZgDN8lOS2KpgiBEO9HSjIRqlc51Ncr6VfBHP75/R
         X4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789566878; x=1790171678;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xBKa9qbG2JJqXwZ4okpjJqBOx4+RYdnl36N3XOUIuDM=;
        b=viSOmn+rUnH5Z6fbqR+iJ6JKZlgNjeCiAXVWsZTpP+X8+YHajQ9qcia/b0vGv1a0QX
         WnS3bV+FcfzAf9U7xGLUTscESo4AYawbjOldvGsWcAkyk8GM23ZYWK1lMrziPsrfzntn
         Ymi0cVYnNu0mhHCcbFeq6MEvh/Q8XVr+YdfM/teJOc5giLiUsuHRtyuQsHicYtucplnl
         +/h+l58jJp1E9c4Wdp0aIpTnYJpVkRatFu2Ycz2MAqkY5QaJRgpmNikn9BQCZVAUDJQF
         CzLtkMqYlULY8CotP3EbImmTUbpVJwO55qGwcBphlasnjXVwitV6IPOoLwuuVnfvBLz1
         EtbQ==
X-Forwarded-Encrypted: i=1; AKwUvBw2llBuIEh9z5MlI5Zboo3t4BzMO/iaeUw5RtKV0z6cqJv5zlmpDHKU7kLBp+vcNiSHuPsgy2CIHz23PGdqEQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mA1C/FDEDThEO+cxC9BO/64JYehMLl2FThktvNUoEquuB51U0i
	THe7dVhrkRN0ElZCs2C9KQiimBu7DbyUntSosBy73E7xkDsOCLEISvKZkJQ9mG8UrToeSXpTSpA
	e41QKfw0zaaU5j8y9wW6r90kuecgX/8Osnx1DBnJeqH3P7YgXyBVbf4xm63f8wA4YyuFIfQ==
X-Gm-Gg: AYBFou2UAmA5elbJaSgWa26SktSrBewVqAqPzBSJwa/vibzQWiPm8xzouJ33z3IJgMJ
	cp/iQ5LZ2e5Wy9LqmyZfRuMtXb32rxy6To9c2C8uMRfnCiS/P+qzUxuPWuvwNGKl29pFeYkT5iP
	U7C6KZYE7MEfTFigCUL7b3PWAT839LpgaE/MrBRpictkQtbg7kMq+rQ7sNDr0blT6YswbE7jszY
	an7ZRdW1vQckG0VrDtb90ZA6kh8irDNtTF7bdpKtxZ53lSaWLqAEwJzGzsDvOjZ/reGjFU/iZGH
	j4aiwGmwMYH5eodqxpQDlUOoIm+2yFQIq/KMqlzUeXswSxtsDDjN4dJ9ymAVwHPwqbneB9VwWz2
	jyI3Q1qDqLZvJJebuQ+IHuUuijKX6vShsnGdxOBU5HLgA2RMm5Yb89DUY2EmP
X-Received: by 2002:a05:690c:c3b4:b0:886:b87e:fe50 with SMTP id 00721157ae682-89224b96d19mr7288397b3.37.1789566878523;
        Wed, 16 Sep 2026 06:54:38 -0700 (PDT)
X-Received: by 2002:a05:690c:c3b4:b0:886:b87e:fe50 with SMTP id 00721157ae682-89224b96d19mr7288347b3.37.1789566877969;
        Wed, 16 Sep 2026 06:54:37 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-891efe024f1sm7428377b3.28.2026.09.16.06.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 06:54:37 -0700 (PDT)
Message-ID: <9892aac4-392b-4683-bbe5-0ff9d35cee2e@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 06:54:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: nl80211: rename no-ACK bitmap to TID
 bitmap
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20260916120620.823bfa05f5f5.Ibb334016129512921b0aa5236ee4c670d83d0f95@changeid>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260916120620.823bfa05f5f5.Ibb334016129512921b0aa5236ee4c670d83d0f95@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDE4NyBTYWx0ZWRfX3a3LP5mbH0df
 g2im0RZk4snrLAMnnl91ArB+7SFCGVyZNDTkKd03q6dlXz4iLTv7fNXOP+Em8KVOTTqUPK8kcjs
 V0yU9njXG6xxcKBv1x6jhdNC1dMMjYAsHlSgS+NE0Mv6KsojtMaloshy/jRogWCMWO/Q5YaUnrY
 2iVwDiqPLPSpIinn6A+PkqUw79vmNw6kdY1NylScx0zcHcDMsNjxPWUNMzPZFzO5cLnC4m9nWDC
 yvkvHMUMlIEE7E82NB5So2Pek6yYm3t0t74iPZLJuhM/Itnc5HNLJ7njqKu12jk4AMTADbG7Jbb
 bxmuDlnzBN3S4L/Vj2JEdKsyq9951+it+KLdStU1slIVKY7lBphzUsz4E+mjwZVuCcffbmdnfYC
 ULpL+wzxIE5FL+xStOajxj8LPEP/vNDodsg++bt+V+hWQk/sbBwPmwyCO2+53lzS779npgiHPNH
 UzaZZ/sSzkhb+SMt6sQ==
X-Proofpoint-GUID: 1Uzf49YX89EpuClugJn6iO67wvM_Ab-h
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDE4NyBTYWx0ZWRfX1tH3Tm1aPXAk
 ORnIvIlAWPwyyVyGr0PIy4wGp4F3Pax9AufSLFX7cz80ycYKmV+f/NLzGdSDbBoYjXztCIkCAae
 nmA9oQyAG79tiMRpLkLlhgsNCKFBKHg=
X-Proofpoint-ORIG-GUID: 1Uzf49YX89EpuClugJn6iO67wvM_Ab-h
X-Authority-Analysis: v=2.4 cv=F/DC5ahN c=1 sm=1 tr=0 ts=6aaa9f9f cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=ksgKcMpKofSm1mqu1mMA:9 a=QEXdDO2ut3YA:10
 a=kLokIza1BN8a-hAJ3hfR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_02,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 phishscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160187

On 9/16/2026 3:06 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Rename the NL80211_ATTR_NOACK_MAP attribute to be called
> NL80211_ATTR_TID_BITMAP, allowing it to be reused in more
> contexts. The interpretation stays for the only command
> using it now (NL80211_CMD_SET_NOACK_MAP.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I needed a TID bitmap attribute for SMD transition - I'll
> post those patches later but this seemed reasonable as is.
> ---
>  include/uapi/linux/nl80211.h | 11 ++++++-----
>  net/wireless/nl80211.c       |  6 +++---
>  2 files changed, 9 insertions(+), 8 deletions(-)

My AI reviewer didn't like this patch at all! Just goes to show that human
review still has value since all the issues it raised were wrong.

Reviewed-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

