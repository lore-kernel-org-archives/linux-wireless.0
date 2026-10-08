Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B3338A72A
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 21:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791496706; cv=none; b=ImOjXBN6miGar5UL5f9Nds9w32FXDROEzgQmiK8fM90bCsxaaepTZ5a34SxjBJH4xgLlhRP5IONr8B49L9P3u3rVGA8XRwfaAMmnCG8QhPQl73EGBcVRC7rwaFzkDtMOmf8nnwYGkek8vBPO8PXl+qQbZK/6sZKX+JPmXDlWV6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791496706; c=relaxed/simple;
	bh=8Pf6LAOxvXEGdVLyEuGMdA3nRhULWCsuZORNtgZ63Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6Q/zTsClIf5zTMu3KuLZY/PNaPC5/1YRi0cHetM0VAgQcbkwpdKnDAO9WH27hD5I2YVu/As6CapyrP3KABHvRCTkvRkh+tkgpCuGFpwvtNUyTbKDdpclj93Zt+7XAzHjOqjwRIevsv3r6gdt7ft2DtIlUkEVpRdSzm1CvraZzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DPwZ89b1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gGAGIgk+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DPwZ89b1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gGAGIgk+"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698L0CMf296601
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 21:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=bTmDvHbME4TFPnudbIvelUAw
	a8csw0mAjHsQ39CULK4=; b=DPwZ89b1oSlNDZlbCEK4iPDSS/zrKliHuZtJtxjB
	z3kmBixlpcCWTTPBLHVyrPrRaHGGhwxTC4HGHiRjSZaRMeK83bNf4/d3vYaLh2QW
	9mRjdIsQNCQsZSgnOUjYtPMH6OweE70WVOi+wSEpBm8kIdV/CRzoMoiaQ102kkPA
	/kK7T9y/Qn7hnLVxNwVjMA8pJOL49ZXQrHLvGMjndb5kxmA/T6K3NA6SAAascDKS
	PRNCrw0LbXnTfAMd8y59yCCeRJpthPE6RnaCGUK2n0tSedUl/pzsVF/7U25OQX9u
	+2d5WLkf+KES/MQYMD7Rzksail5ygHERtleIB9xFMsDHIQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6ekv9482-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 21:58:24 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93caa0ce0cdso739888785a.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 14:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791496704; x=1792101504; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bTmDvHbME4TFPnudbIvelUAwa8csw0mAjHsQ39CULK4=;
        b=gGAGIgk+PlJYzULVvxrS2CGThbSvlFjiBJj5ExQQBSfo7MiyiR+1UodoDTJdWGYSi4
         b5FvO/ZC0ksDxqaD1WZ9ZxoqjpzrZ/9MfWdDsMDyfUxWb6QDrga7b1qCrLjCTYkNW19I
         1sPdTbNjtYwJYBMsRTz10qL1037GU87pz1raY6j5sfeEp0/HD135dWu0Uj8XDIAmJRjI
         8JvO1xdfHuHpr8EetoJ7P//aaq4abzYrq89HwQKO3LB0v8tD/GSE82xTXdcNcP9GI8Oi
         ZW8sdL3QyMB1cyZEm2Q4hML03pZchmicZiJQ7VMsF527XI9vzHXwBcjun3lHs7qcCfIn
         x3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791496704; x=1792101504;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bTmDvHbME4TFPnudbIvelUAwa8csw0mAjHsQ39CULK4=;
        b=Nldl4CD+2yR8TpCiqG6QAPs2imsR+zvm/7KMp5uDzCchbKfoYdAp9OEJfMZL8g3k6X
         /FM06Joeo7k4HfcUOZQzlKugqKniI6dH7eSB2z+0fa8h6ysekL5YP2ZlqcV3p+28ORKi
         rP8EoR8NFxvT3ETnUvm2jaM82RvyYEGghFulM4A/76MPLoBR7sEGDAUmoGiC7gNul27E
         qMD3Ky+atI3QPKhgURqf30b0q+9TJPXr3CCp2CGl8VEzGqLYa142F09K7Ddn6Dsw6dGp
         DawSmlPRTXmDqTy5EDFdBTWoyCuB25MDqrnUqJuinu5sJxeSQjJ42xmsGgkh8IWA03i0
         rFxQ==
X-Forwarded-Encrypted: i=1; AKwUvByn/MfBK3lXqYb0tymSusZ0iyL+1MJ7Ncim8WFAUwKjzdXv429uojZKTxlcKihTB2g/ySzP4lsG1vBevS6teA==@vger.kernel.org
X-Gm-Message-State: AFuF++ntaFnzcjJfX2WT700LNUNHOYxY/0sR/6OGafnkcg2vjNTsaiyP
	cU/INnDVhC5F4AUs20UBuGeHbzAPHAxmc/ZwDc8gxmZMhN7Xb0H073e8HXUUNsgxXMJdfQI/o5I
	4kciNnO+ae9IASyg2LTnX5Upzpatt73I8kY0R0H8xnVg/fo1EQ+KLVPiCu++RzdYZ2l01Qw==
X-Gm-Gg: AYBFou0HLUL1FMqiRpCi8eDMBbloMbbRN+PWhJz6P/L/5SZHr+M2vndLsIecvbN8MIi
	wkX+Xi6whTNyzdXV9VAl1RWvL/foElzrcbqzGJ7YDwFrEoabSUcrerZWkxj/shombezvUzWtkwm
	ViaQrIFrQo9o4e6UArVu+bP3BTEdWWmaDad85aov36n5EPq4n0uLJLdrOzdJZ9Eh/tSMCZanEus
	4qQTtqr35Xw0WLf6ULkpvFfI9qdRAOjRcG1pk4pv/P3zzQLPl/A2MZXGItllYonTnHbCjS4DyPr
	LCSjNzW1IKRmVbs4ELjN8tCkiCvLTWVClgoXDXor+6uwEQZ5BGQdrzLs7TKu0J9sTxAMOESLnrN
	JL2d/02YUSL0/B9hYqkF3447b7MoB4/eA+S9tBbqtbhTjLZOH3MtQssFXiDYQWhzmCrf/7KrJBE
	G/bNV+3x5yp7x9
X-Received: by 2002:a05:620a:1b93:b0:93e:8774:fba2 with SMTP id af79cd13be357-93e9b7ec7d6mr1277725485a.58.1791496703744;
        Thu, 08 Oct 2026 14:58:23 -0700 (PDT)
X-Received: by 2002:a05:620a:1b93:b0:93e:8774:fba2 with SMTP id af79cd13be357-93e9b7ec7d6mr1277722485a.58.1791496703267;
        Thu, 08 Oct 2026 14:58:23 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bcdde36004sm102345e87.8.2026.10.08.14.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:58:22 -0700 (PDT)
Date: Fri, 9 Oct 2026 00:58:20 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20261008
Message-ID: <afoydvkyh6kc3n55eet6ubszuw6g6q6mwtghfismxxxlvs62dc@cl6zxhem475q>
References: <5ca444cd-9d83-4805-88ba-f551576961cc@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ca444cd-9d83-4805-88ba-f551576961cc@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: rYa8XVHrKYjTu6NnoFDGkyTgMgXtBviX
X-Authority-Analysis: v=2.4 cv=csYOAF4i c=1 sm=1 tr=0 ts=6ac81200 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=p0WdMEafAAAA:8
 a=qDMzh20vGZsPvAqjlPMA:9 a=CjuIK1q_8ugA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA4NyBTYWx0ZWRfX2Y7uqkctcUwi
 AXbU76BtQOKmlTMy+VbZNykacN635t/IIcgACUN5PU5udbJL513EIBPhNuIkQuyrRMaqe6FiZme
 Ozs/XZkz5eQIjKO1fBKlxw9gPPVdj9HClihIq9cioUX0NEYh6npDJDu6GGlTzH5llldYMPcdXpf
 Tml45nJ9Gx3F+nToxks1HF1vUrIRru9SDRJ8ms7ZpHfW7wKUty3xNWaFuCfTo376Gr8L4lY2j5O
 SZm9Fr+Yitarv6zuruwQltXk1yHuPQFLz1NZug/9uagl9mOKpY7Djc+GMq6cVfbGjBTmdu3Hz6X
 KbQcvH9RNccn5XTaqjzf0z94BSrf/oG11Vt/ITVkRJ/xHobjRc+S3eEsWsuy4LZN+tVZj3Ox43h
 E7SjzXHSNdLHQt22VU2tIc8Govoh+A/iF78Sal8nH1+IET078VnipuCUfzAeMpv7mbMtOpa2L/I
 19NfOJ/8qlK6s3oPUWQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA4NyBTYWx0ZWRfX+qcYABdGzomp
 SlM4wwIF2VZOFwhgViDBvtwwZu9leIGX2oOdHoq4HbPNbLOj5tE+HPeOqfABxsHOEhf5WgF5rpV
 VM2pnIbdKNRur4mQa/lnUOI+1Gni810=
X-Proofpoint-GUID: rYa8XVHrKYjTu6NnoFDGkyTgMgXtBviX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_07,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080087

On Thu, Oct 08, 2026 at 12:58:46PM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> For ath10k and ath11k there are no changes.
> 
> For ath12k there is one board update:
> WCN7850 hw2.0: Add support for the Samsung Galaxy Book4 Edge
> 
> Please let me know if there are any problems.

Thanks, merged and pushed out:
https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1296


-- 
With best wishes
Dmitry
