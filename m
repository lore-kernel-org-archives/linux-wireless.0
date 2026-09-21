Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB69521204
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030110; cv=none; b=GOrnbxw4Y68ntF1k4AsbbGlKD+7Gp0Y2mDK0Qezre+7rZ1/2ekQHc4t6As8jnCIVYNMIbLAyxcI5KDvmMY58NdzvV9g/rEHv6PYF9TKHxioy4LPYwpC/4c33gidvXViKag0acxAFFG2j2TypGlhsINi9ol4n/jWqIk9uY6S5qWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030110; c=relaxed/simple;
	bh=Ib+b6tSQi15Dp/Pl538pLpfZBOpDvIo124gdzFdbfYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EAV5yCrfq3TaP4fn1tMq8zyC6Iz5tNTjx3uebqbj3uv2HR8p+O9jGNSs3+Yg/FvQ20bJgeXhujnHBIBlLE6BSeNb3K0lF8OOxn/7HIRL9IlGmu6Lu6uxNFF3pWHBfysdUtNqPKjGIOWa+XDlopHmP7tJfZqK+QP66boRFfpyfyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gvkVI+ua; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LckOLiSa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gvkVI+ua";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LckOLiSa"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LKewHO1565376
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 22:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZmvyhwYgg5sbh027kGBFN4jtSaonNKU0CwrVCoo4oq0=; b=gvkVI+uaH1E+NajV
	hTPaghdnDsTmtV2C98OXXhTiAas4EnxSzMbI4TYYuQQrENumFJBf/LsjcEL2Lqcx
	hduKC2F1DxIUMNEJqxPFHquit7h1lFygrORU1tqlo/87YtwSDyOq21UKFQn1LLT0
	ig5v9yc47OmytOMP0OBlbPzyCIsm2XZiIdURB75I+ax7IEQCoDfHBf3n/a8zPdJe
	QvdDM/6hhD4J89bKjW7rnnNl8tafcHL4rLC5bYLYNOE+da370HnbKfkhFeJoNuUw
	rzcWAukzENJGi4Uj3OV40zv8hRTT6vKAFrqW/Kfd2nXiwVNcyiYQujIf1c/o9BBb
	ugk1RA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu17gua49-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 22:35:07 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0fso335759a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 15:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790030107; x=1790634907; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZmvyhwYgg5sbh027kGBFN4jtSaonNKU0CwrVCoo4oq0=;
        b=LckOLiSaVPAXkVs/20IohK811l+5KNDou1POVnZ6ly96w6KIKlKT3VcdZF3ACcW0NW
         fVjaCiOI4QFbXjfIGB1kV7HkvLnjGhQa3QIwQLK9it8JsZjsOEfqVEi3aaHcmaACwGaT
         lUfLYwVr94FwIEDarxB9Fgd3de2Fx81tV77JXGG5Dh4BWLyOVRPNGwoqGOejjSussYy4
         Yh7qyzv/VURPGMkXhFMm/wpYYKMMLg9tozUYrI+SmZT+6sr6wRPcT+04mIY4lKPvcQol
         k313LTbDKlVINSIhdfQOg6oES3AnpLBljs8Eme+fAPJQVxkX2F+jR0Yq4M9/wkvOiqrc
         FX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790030107; x=1790634907;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZmvyhwYgg5sbh027kGBFN4jtSaonNKU0CwrVCoo4oq0=;
        b=XsDOWmvxscYdIQq1JoO3ZO3sWwfCePS9wgApqHmvxi0LTMY9h98+NfKPiaRX3DHexx
         Q5MgEpf5dR2QX1pZvGQAn6S4FhJWDgbpNKNp5xom88bgWx10wtNYzjcSttIy+439N7nj
         BO867MRD3mabN29OOBYhwioTGwJ7k/su29JeXJJ9pH8Nc6j8aCwmIiNj1Nci/VoO+C+7
         w4UjNfFsUdorixGwNPedmgaEnVZK73Z9i6z+1dUBYuQtFtOiv++Gq8gJlE3xw/sjGQVs
         DxjS8CNP9Z+H7likwEiCOSVEuHt3zt7VA4AJ8vnyU2Nlyf4gOK3ymUuq1TfVVVhFRHTr
         mrQQ==
X-Gm-Message-State: AFuF++lAKpoB7Zzfmuqm3ZphfChkyc3gxCQjitqJgVtUGl7HiLYmBwCD
	iKdx/vvGjaoW+gro5xEVwlxJGKyyi8b9FrEUSHJWRYo/HJ7T2x8ntgSJIacW6DFZkn0nuSB7s8o
	/h31hBtpGkCAlNLFkps3ZBlIVdnwd5TSILvbSiAKbgEO41G2reBON+P/9dZ4M/qHus7Hzeg==
X-Gm-Gg: AYBFou2hJIv4NIIiR+8v8IFxRS4FkT1I3/ACkEnBQdzG4VjQ17abafnkaKMUuQfgo7z
	3g2ICAPhJYSIsChKLIhGPGaOpnDY18RvkTZhBNZjZOb4SPH01wZVSii+qJRF7pMkgGQsbG7b5D/
	a2sFdCceQvQaN7PHHIvYi8fCVt7hUogY6SUNaYAZrqrX1esLXpXF/uWLFxJe5cc4U+1uciNsyB8
	CkltXqHsCUDxdb40MYjlCCn8Bz/lS8Ya4cJJl2LiboNCHlUo6gxd8OmP1jVkn6jLvuYjXHJXuS2
	GlRA1AemmAVr9WvstnAMmPTDQwn6zGZ+TP2BN21u/XVIlrmV5kpfvVVEGN7ivSEhIuh48c6Y2ko
	TIB9Ksk4rYQyAP6mdUiu3ORFEvOYzDpxNWAp43/Ibypos8Oc8AkAkF8aL9A==
X-Received: by 2002:a17:90b:4b0a:b0:39e:16e3:44f7 with SMTP id 98e67ed59e1d1-3a0669c780amr868401a91.6.1790030107278;
        Mon, 21 Sep 2026 15:35:07 -0700 (PDT)
X-Received: by 2002:a17:90b:4b0a:b0:39e:16e3:44f7 with SMTP id 98e67ed59e1d1-3a0669c780amr868387a91.6.1790030106661;
        Mon, 21 Sep 2026 15:35:06 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f0cc3100sm681215c88.13.2026.09.21.15.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 15:35:05 -0700 (PDT)
Message-ID: <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 15:35:04 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: Johannes Berg <johannes@sipsolutions.net>,
        Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: igYamvMThY3ffhq6-RHKrKexnIr6vs_3
X-Authority-Analysis: v=2.4 cv=IewSymqa c=1 sm=1 tr=0 ts=6ab1b11b cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=b1gTVRIz6arP1Kg95IwA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDMzMCBTYWx0ZWRfX7bgeia1PeQtd
 WexTulswhBryf9gfWxvhzpVpzqXNtxSt2AaAJ+Ud7cV4vt8Y96NoB6g3z4PmsSHGPhbzQLg2hWS
 e1i6kgsUrYb6iD3Zr9/He2ze3Xutpuc6tst2LGVxpNW4HG6DEtPXKc1UHb4mBuNFXCq+nqtjnJP
 7DPLNdG4GcfnY3KhhYAzKdf7zZ5GNPaZIbXbeW2rfWxIYaOX1l27wyhHyP8o+E/N2jAt9PvYg2F
 1g934O68vLPJ3Q3iRD99opW6Mnj1fQmyn5z8B2HbqZXOA6TgfjPuG8j1bQ3pPDbl0nTUmGD59fp
 ohhgfN3eVOfz210zwJzFFdaMylFrGMhSq2+WE3l1jSAFWtAw0zAWbKBK/FmASkXsQOf/Qeu3Rm6
 TjfR2AoywsPIeiL3cnBdO7DmDujt7bBNaiiWv+4u9dpaXvrmX+6EvaD9FS4BqvA3uJZuoitQ4fW
 xEGPiAdYyGmkUJUmP3Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDMzMCBTYWx0ZWRfX/bnUkDtt+Qy6
 pv0I1MmVeZmXPcVZlVx7JsP3MoWbJ0beksprMJCJJF8sKA+6lrN7DC2GtmJklmEinoCRkdHqzLv
 vHFnJF7HgwOe6+XvenqEXXfGJ8zpU6A=
X-Proofpoint-ORIG-GUID: igYamvMThY3ffhq6-RHKrKexnIr6vs_3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210330

On 9/21/2026 11:14 AM, Johannes Berg wrote:
> On Mon, 2026-09-21 at 16:49 +0000, Luka Gejak wrote:
>>
>> It is supposed to work in the same way it works for other driver
>> maintainers. I would review patches and provide my acked by or
>> reviewed by them and Ping-Ke would apply them to his rtw-next branch.
> 
> I don't think we have a lot of folks below the driver maintainers who s
> end me pull requests (except Toke maybe?) - but as long as I don't need
> to deal with it I'm happy, you can figure it out between yourselves :)
For ath.git there are sub-maintainers for ath5k (Multiple), ath9k (Toke),
carl9170 (Christian), and wcn36xx (Loic).

Toke has a linux-wireless patchwork account so the ath9k patches are initially
assigned to him in patchwork, and he Acks on the list and assigns the
patchwork records to me when he approves patches.

For the others the maintainers just Ack on the list, and I take them from there.

So the question is do how do you want to handle this in patchwork?

/jeff
