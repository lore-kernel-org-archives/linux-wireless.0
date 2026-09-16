Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CC53859DC
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789571116; cv=none; b=raloE6oXIcrBZfORLm4MojlISy63huAwexHdvMUltdnUxD2+iiBqw4f9pmLvP7o+L1lQKFLILLuC15aqWazoaAlewi5dJ9Ojgg674CETpwoJf1ydzZvGZYaaV5ZtHlEu3+5AaF1Kf+6qeV2IOKPB8qNOKJGTGeUJqWAuQepLbq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789571116; c=relaxed/simple;
	bh=WFZZvXEreJte5nBGMpFEg3DhjYB0tZra7/TJ0VEudps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBP8x6nkm6XNzEaxeQHYKEaHYkMfT4A1E1aHdKPdGSc4I92iDMtUzsFJy3Yq+cNQIsWA/h4+GmnI1Da6AYVWlKUL8dhhY7SG+2dXx5YDSolFMWrnyRg8exnWYSkEtC/CoVXvYBWA0kRY3+2DvtTuHRKQiDOJw6GnYv3WijRgx5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V5S9uLPB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G7cJsrMz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V5S9uLPB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G7cJsrMz"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEYfPm2448966
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8uXNolMcn7VWBrYpq95LoEiUSffaGyw+nlxj/sZcvx4=; b=V5S9uLPBg09h3bTM
	XtAh5/C+atDPq7dYnJgm4MvHjon4GE3DZLkwoJCiupIwGFMRy2ZeyrNY1Vk9wYvY
	PRkfVNdjcnkpZSEv9k520lzbf+J2dQQe7qh4R47rqLlhQ+Ey82uSHYE0IlPBPI4J
	98UgpYOV4xaVAJZkCl65ZMnCwq0kFqK8DUHEEsCnBzgLREUmQrpbCSPpaEmyqY3P
	8IvzK+pAdsNAJz6onJkkjYFnXosaeC9cLoVwKA34dF2DHSIKNl6z9fKaJfhgvMDn
	LZQxeDaFL46X6vKwA7WLDlKWmfeTF9AEo1d+5scH9RkPGsQfGxFpnmE3RNMiSiej
	Yuct5A==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gquwb0f3j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:05:14 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-809f1af7992so3487352a34.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 08:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789571113; x=1790175913; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8uXNolMcn7VWBrYpq95LoEiUSffaGyw+nlxj/sZcvx4=;
        b=G7cJsrMzXjWPGGchtr0qzOURlaKIJxqiZE4tZDzzR5kY6ZE++q82obtC5Pnh/2jrl1
         whVfe+M7/nhGRZ74kR8Tm1bsi6lZkDjSdNgwcEu3gkGykfvF28SsBZDrhwJPYhCE6Sjh
         Q1S31sfKL4pLpboiam+/9Oj9FEyYc/JlUXO/FPqWRGELfcYrPDYvTaWpN/xWXLkbK8qS
         SHzkUBnC3R3+QmXS5ilTfZoltxpdp2CWNEFKmKwGbTHIILiuHffTU5JJ8xKN6UwiYdiY
         c8tIsCBPcKXTfncoOPuyIkvxbeCUK0yrcscnpYT5l40Xbvs/MIu6xLIMsmyGx9QamxvG
         hK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789571113; x=1790175913;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uXNolMcn7VWBrYpq95LoEiUSffaGyw+nlxj/sZcvx4=;
        b=YcxgrrKDsNYhbNzUA5tfoNgULmZvdujFey+Ts+9S0HpTVoRO616jgcZ0/Vs4RqbJjK
         tZQA9W7CytbpyyVG99owWrLGTXGFf3t0Es4vGa8W7sgBbfBpPUPu4lynZb2qIWGurY74
         NJAy5XAKlDmzhSbdeGuxhK3rndgW7j3Rs0azNFP+6CgnpLi+IyMq0ZBuEFQBoON60ndJ
         QSH8ZMbLD0xgVcD/w9hkJDzDWW7smabCQd0X8zAtz9Wq9RmUCet+u8+BDEXNyetFI1DE
         GuD65N3MdxyDEcXLL4uYDzW72jQf2bBIpTwJp/TqVZgEWH1L6KNLDnJ9CI43blo7ttIf
         pM2Q==
X-Forwarded-Encrypted: i=1; AKwUvBz+9WjLYS62AI/QV59hXmKO2I3clSgKNsuetPtfM3vBM+D3pVKwslB/L/N+84Ji7xgn4+0LGagQuqPQFajX3g==@vger.kernel.org
X-Gm-Message-State: AFuF++nZ5SoNj3H4A7ed+iyHzXxBtBtdkT5pXg56W0/c6WL1znEMqeAE
	+F81gFFa+rIt//8aRQczj4YNTM+cb8L0V6WsPDBB+T0IJDS+dXUuKyXuHaDI+YEHy6OIsVszT++
	d47tKNZk5MphYULLPieOrmGrPR4tE0wWSjJrIXd5t20ET4kqTGSMduPYEvmJrqmPbif+Xxw==
X-Gm-Gg: AYBFou0NyLPdCpH1oSI5H2YtufoPEZNJGmFOUKGB8HWgg0+MWnAxbTfvuQ4Z7YGmrSR
	Mi4Hw+eJChpAxsQ8VRa2m12Tb4U3wOcHGVFWPHRlfTSkjfXznkTuumxPJohWj3doHGcRN6wRf7d
	9VJs6nsgIOQDYsa0rBC+o0G0J1TFf/WufC1fCbgYxHwoOk/ELGGOvBVIrVbchvOEdtT9bEkHxgD
	PGLHcYNvHyCjL5yQY90nYMWV9KHS5+RTl3SYXfdQDHraMzNYNGK7ZSrjOK5oxxVL1JQGN82zJtP
	iRhbz0iTBrvBBPyo5j01dshSgHGZjGxaWBR6/F6rlz8us8gwbCQzMUMWaeGshFgbOmsYnJin/AM
	gXwrD7Lk3LgSqVEkfCMDH95j3NALiXu9UZZGXB8us96gIh9SYAZP9hwcCRXhF
X-Received: by 2002:a05:6820:1792:b0:6b7:46fa:1693 with SMTP id 006d021491bc7-6c7d3af57c1mr3029333eaf.40.1789571110749;
        Wed, 16 Sep 2026 08:05:10 -0700 (PDT)
X-Received: by 2002:a05:6820:1792:b0:6b7:46fa:1693 with SMTP id 006d021491bc7-6c7d3af57c1mr3029183eaf.40.1789571109343;
        Wed, 16 Sep 2026 08:05:09 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5a6a1a5sm9336952eec.5.2026.09.16.08.05.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 08:05:08 -0700 (PDT)
Message-ID: <fcebbc78-63a7-44ef-a822-2313ad5d7517@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 08:05:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ath10k: clear QMI if failed during init
To: Albert Esteve <aesteve@redhat.com>,
        Brian Norris <briannorris@chromium.org>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com>
 <aql_xwEy5POcVmyU@google.com>
 <CADSE00JiEr+k3ykLq+D9C-WxAcPpzXdF3uJnv_P47G1V_-jeNQ@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CADSE00JiEr+k3ykLq+D9C-WxAcPpzXdF3uJnv_P47G1V_-jeNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=H4JOUOYi c=1 sm=1 tr=0 ts=6aaab02a cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=cm27Pg_UAAAA:8 a=BEXexABXWyTRsNrkf64A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-GUID: W9t94IPxOmNEcySFXcX3-kSqTZzpPC4_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDIwNCBTYWx0ZWRfX/scj5mwReXji
 9YGiNyJdCG7NEEKbcNUqgcxx8WZ1IljFWqjJSuanETH1/UU4lw/jbNNpKMirAcxm9Lnx3sDCSGf
 hj0gF+K4L2wdsfcEDngV8zvj71duSGH3MeCPyc1ribZxuc0DMqWazImsV0wo3vnNEZNtPAAHtX1
 ZUTpxa40F6Z8Sb3t7c4/70F+dPUXHoG+VPMZc0ri5uPeGkOXSx0UWqkCRvs8Vz4jSt04cjJTsa0
 fT9D+iL6aGbHX464zq3D1aA1JpJxvrdkHWWtv3Ui/0uUexd2VxmALb9kNfY8IsNjj36jMvcQd4/
 ztMPbCGFwMp0KLXHZXkWukF6fYGbQDcao8qs0X2DNpYyCGobL3PEms76lnDIKcunBfXFFJXHVzF
 CkJX6JxgAbwLJ7dxJOqY9SkCk2qgzxnFIn4FLUHXHJUXPFqoFhZJeg896CzKt+b/YiZqmWBdmJM
 uQn2RI/V+zGk5XtpwDg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDIwNCBTYWx0ZWRfX3Vn5YcDiArJx
 7PDH5yt0J+8DLkiLHAemDnD+Ia63byZy/MSxIz6AEWcdSii49AE7TqVqyyt5MBkFH2QbioIBQpC
 n2KDH3RrM7WQmAXJnCSVnKYfZ1D6Su8=
X-Proofpoint-ORIG-GUID: W9t94IPxOmNEcySFXcX3-kSqTZzpPC4_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_02,2026-09-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160204

On 9/15/2026 11:55 PM, Albert Esteve wrote:
> On Tue, Sep 15, 2026 at 7:26 PM Brian Norris <briannorris@chromium.org> wrote:
>>
>> On Mon, Sep 14, 2026 at 03:05:19PM +0200, Albert Esteve wrote:
>>> A failed ath10k_qmi_init() left a dangling
>>> pointer (ar_snoc->qmi) in the cleanup path.
>>> Clear the pointer on the way out for hygiene
>>> and consistency with deinit().
>>>
>>> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
>>
>> It's all going away (probe failure / removal) if we get here anyway, so
>> this hardly qualifies as a "fix". In fact, in a cursory check of the
>> driver, it seems the NULL-ability of the ar_snoc->qmi field is totally
>> irrelevant to this driver -- it never is actually checked.
> 
> Yes, I agree...
> 
>>
>> I suppose you can still call it "hygiene" though, and it's probably
>> reasonable to do the same here as we do in deinit().
> 
> ... that's why I phrased the patch body that way. I hesitated about
> using the Fixes tag here. I can send a follow-up removing the tag if
> you'd prefer.
no need to repost. I'll drop the Fixes tag, update the subject to add the
missing wifi: prefix, and edit/re-flow the commit text to use the 70+ columns
that is preferred when I take it into my pending tree.

/jeff

