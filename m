Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975498;
	b=wLB3pQ79eZo17Gs7Tbw8grD9Tqc7IIXBsGCevNaAOk4dAcczR8bK/AMHhHBDpgK9nLif
	 XRk5F2gvTMMhN71/v8JXFQ7nF7SNkThUaPDaMjuxDDgMEnciHMlMdtKBtvBPh00wiCsfK
	 80KPnlyjFU6iXJfokej+RJOC81wkFUXdW787AhoG5LA6ZBAl5qKjuDvcwHGSBSkaddQe5
	 H+DlKw1Z8wfUmr4y/FOvL6Xzn+JjFkvHAUcw9ClXFMP9VlU5wwTfI3urSxIVkO7fPeLLE
	 nIOg4xVJaux5jv68jCK1D/mxYeynA1I7ZuecTpbglkQgDNLhYfm7ALgQLfCDIKKys4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975498;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=qboeitKXtC/ct89Obi6R+XrF8lt4qTTqD4J1BPDmL80=;
	b=dFAehxQtfzyTejuq+cFDV9g5eRAcFrGLgKqUELl/NDfsMQiRv9LYSTSwBjJ7CV/SRJNp
	 ss3Dt1MEx/X2xjLA2wFLb3DQxOvcd6zqtkj3PRa2PyHeD4/qyE6+GrHc3lqH8Li5JACGb
	 EbNcKT5TfBq85iNOAaHo/sQqG+xepSKZ8FzaF8Q9QmmapDpcq9ezQhWCULtnoD8/h3Yhc
	 x5BgyYPg7yrsDYj+KKr+9KW57y/Q0vWxM0gE0mPwqj1T6fYbuCSgC4A1nDo2bcbIsiIpV
	 lj3Uf4jUcE9KZnB0tCNKGdLat0GpYeYjA1N1A3XJVWXz6/t2NZUzdPXE8IljsFOtHHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LjOtuIDV;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dQ2kOt7e;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FD0606A332
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 14:31:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57FD0606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LjOtuIDV;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dQ2kOt7e
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6EQMtl029965
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 14:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qboeitKXtC/ct89Obi6R+XrF8lt4qTTqD4J1BPDmL80=; b=LjOtuIDV6sRjD92N
	7H8s4sCuCODz0mIII3apvA8KSBgYUHOHKtC13oJM6GBPNQaPjQVms6cHGzLVIlHo
	7nVl7LsxMjEizQGMaByVyDtfh8Fm0WCnmp0e0wBw6szVUetRL/1hQSi7g2XKCqY7
	5rkK+dUwv2xVdOv+HdPEQ6a17Iv5N9UDBKFg0NFIqk6BgbxV0xXDjN8xrrt5xYHn
	RFVXN2R6kNrTst2xxgh7Z8ykYFFSjRImAzDdRU53Et3i39egiIBEK9CA4yuCjZrj
	2mv7wxHpDNNVKpQP9kdIMbsRaLs7WOJYu538GBubQ38x08/ZpQfswjHu1PQtZB9W
	csuFyQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa36nq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 14:31:37 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36d69ab3c2bso939901eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 06:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793975496; x=1794580296; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qboeitKXtC/ct89Obi6R+XrF8lt4qTTqD4J1BPDmL80=;
        b=dQ2kOt7eOnHUWNKA+a3FfukW79BB+yCug+bKaYwpEV4qvMnqBcbSWnBvocqaHDZ2xU
         zE6XifIdo1lQOENMZQFHLM40Rzk6f0SYlHdDzeA6pJR06J8gdgsF0tVV8CWbXLI6UEsm
         Ng276X8yt6HtlZk2cFhp4vGLUUr9Zt6EO2er/C9oOUl6f4/b0ji2NJVM2ta1aR5e60e9
         gITpDwCMIJWoudKoINZ9YJsgPtFkkTHdpXKr/2uKQkRC7PtdUj8oi0BXPNXjX3oAGMyr
         +Jr4PQb9o1tSHaIARtfWZ0NdcbWsSsPjhPAN1D1kufZxHPK3iLnKIEz0RtQvPyl8oMkm
         07og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975496; x=1794580296;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qboeitKXtC/ct89Obi6R+XrF8lt4qTTqD4J1BPDmL80=;
        b=aT0KrcQ/gQ5OdvMHuSjPAkDjs9/CI76bcbLyynBL9ovpURzwtIVC9PjrISmBOETYOj
         S+eknUUe2BnJYLxLLnEOkoNoRWSBBLXhbBxVa06iugzPKi0jpkcXb6SHOO/jgSiTVqDG
         HYVoAAQnp5E4kWngK7JNSj4hqKxDaIkjQD8UxgyaDTQl9sGY09HDEEKy4TfBHn+6GEnX
         ZwkHG8foCOcjPqJnqZjnXArqu3/jxb0G5pIOQqD0mvVdk8VnYRKX6JuKLsTYCLvSbl7l
         hOpjB/6MnvjONV+H7trrWNY+me3MtaQJoc7HUVLoPcteZtMbi4PmUAcN1IMMj1pRWXBt
         vl0Q==
X-Forwarded-Encrypted: i=1; AKwUvByRpkVS2JH3UJA0WT1omoGTuTb7lXxy6CYOChbFB/sNar1JfIxQOvCnfx8vAGEv7+a7iR16LPj/NDULahrxuA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+4Qj/GSISWbpzH38mKVhaC2yp+Ut1ojSst/NJZbFHYXdHLooeD
	kIHKTNM93rsaepH/UNTsjQ+b+2U85GxD++88gTBsSy9H/ZVmilzM7b+Ba11PwX+HKSRzS0kNJlC
	Glb5A2R5fTScjtcWPXtV4wOW827VqE7U5511osWDI6S7wPKFZjVvR7Sw9WWi8BDOnupxwnA==
X-Gm-Gg: AYBFou2KrOHscp8IufIPpby2rRcaJWE/jz+BfN14/C6rqx6Ox0rRe8mc8fn+HcCUQzh
	nDTbDdcLuB3O3zMY8XmWsDAM9YPVijXij0L4zTN6T67S0JRpvp6Vv4EqYqUfjZVvEsBXdouvnc3
	lvBk59TJzr4yhh7imaOg831wSmrF0ka3SydfoamyOmBqSxL7D+qZLoEqXhLtuZEYCb08a/xRSo6
	LVYVq32OK+Iz6QDjDgjsBG9Gv/jZ4h3SAzjAF69aE41hQXY/SzoGmXqv/Qk+TJDN4xfl+xr4FWN
	MOizeWxyCrbgCbZxfRuJRV8M2v2/p91STP158qWc4CJCQwDpuzVp+NBAP4lJLrHb4+FcvJGrOxv
	XPuD50bEB1vB3xUOSve28g0PDExyxEvtMGKcF8DzMMYo32W27AAj+JKOx7CT+8bG4/EUCFjl2wd
	k12cWRzEWszvSzzoCL+EHeaCAQitkp+qk=
X-Received: by 2002:a05:701b:2205:b0:16a:b995:dc7c with SMTP id a92af1059eb24-1b25d34efb3mr2989537c88.21.1793975495931;
        Fri, 06 Nov 2026 06:31:35 -0800 (PST)
X-Received: by 2002:a05:701b:2205:b0:16a:b995:dc7c with SMTP id a92af1059eb24-1b25d34efb3mr2989503c88.21.1793975495150;
        Fri, 06 Nov 2026 06:31:35 -0800 (PST)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa9ed126csm7361711eec.18.2026.11.06.06.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 06:31:34 -0800 (PST)
Message-ID: <01da3719-51c4-4f0d-a3f9-f0e5c95dbb80@oss.qualcomm.com>
Date: Fri, 6 Nov 2026 06:31:33 -0800
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
Subject: Re: Issues with ath12 wifi driver on WCN7850
To: Rahul Balakrishnan <rahulbal29@gmail.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <CAMOo2XeHzsWR_f5j1+ukPn97CpSNtPM7WLm1Y8cWqdGm3=yJFA@mail.gmail.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <CAMOo2XeHzsWR_f5j1+ukPn97CpSNtPM7WLm1Y8cWqdGm3=yJFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX5/l690oTRTxN
 w0xqOLXCtcgFPq3BDPy1KHbcigsh3ghDDwwA9RFaacTLoc0i9VJ6MkM0Cb6YpEUYx/Olkmlvrhz
 85NyU+2B1Mj1sPPlVyRrgAGbpKJFqFcr0gaDfC34U7H/BA4BieyyllmpKyP+ubzKqg7cHLH+4nQ
 Wkix26Ozv4KBsuoroZfrD25L5d6hnlPSy6BrvKqMQ+91+7oJG3BkLoyTc0KE5bImO4OYKy82qfN
 8K/Jpys8DKcYMId2XZ9gqnDUcQgIwceJ3hWinhF0SfnPtvgjoK8PM/YXeAvb650MJVIumUbuCpB
 I4HSF1OYqWGb340G3GIkNNsab3MwFUyaSW2ipn2nh0Pu7lrtG11BPSTarjmbZrDCjG/HgbEG4Bf
 r9GArhVqVYyzZsmXVYndYxDxFiG/pjE1Hly9qeLcOHtgZij0Nbznf33aX6Rot9wJMi1+VkN5ikK
 7G6wgjCS53mJ0TYfxfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX8gA4z+ZiYh1e
 6T+FydvLvVzkMHyd6mTtKu98GGIuUTHoyA4sx7VNaP+4UXIIKYTHgynl8jQ2nZ9pXW9gvj9uXyT
 1jrOloCZMEQDuzkeDepGZR0LU2BEJIo=
X-Proofpoint-ORIG-GUID: dhPjuP1zqma2uji-WRPounNYOnfWrYBR
X-Authority-Analysis: v=2.4 cv=GpzXaU1C c=1 sm=1 tr=0 ts=6aede4c9 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=1nzeiQ3qHfAZu2nQ3WIA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: dhPjuP1zqma2uji-WRPounNYOnfWrYBR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060057

On 11/6/2026 4:07 AM, Rahul Balakrishnan wrote:
> Hello Mr Johnson,
> 
> I have been encountering an issue with my Qualcomm Wi-Fi chipset. Here
> is my currrent system configuration.
> 
> Environment
> ===========
>   Board:     MSI PRO X870E-P WIFI (MS-7E70), BIOS 2.A52
>   Device:    17cb:1107, subsystem 105b:e0f7 (Foxconn)
>              "Wi-Fi 7 Hardware name: wcn7850 hw2.0"
>              chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
>   Firmware:  fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10
>              WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>              (Arch linux-firmware 20261019)
>   Kernel:    7.2.11-arch1-1 (Arch distribution kernel, not yet
>              reproduced on mainline)

We only work on the mainline kernel here.

If you are having an issue on a distribution then you should go though that
distribution's support channel since sometimes they carry their own patches
which are not upstream.

If you are able to reproduce using a mainline kernel then follow:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/bugreport.html

/jeff
