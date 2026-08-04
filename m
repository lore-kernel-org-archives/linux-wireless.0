Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06A2E2EEE
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 01:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785805525; cv=none; b=HO5VRkB1sW9u3zTrqhfv5lqXRhndO4FsmX3s7HX2up0ADUKbPkFd5kf4J2kFcocc+3RPYXCSp4+TJIyrRcQO/pgZbzSLFtbD0Eqg/0yIZc0p6Dg5YgBHY4fanxDwSN7yPqdpNundk4syGciDWEE89t7fQy7jUrWbm5x87AXjUMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785805525; c=relaxed/simple;
	bh=LKhytjTjyDYioFTDZB5nkEvh/eVhAK45VzLfo8AW6dw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8j2LS9C1nrKr1AcSyY+h2AvD+Lg07LyxsONQk+Fph2uwerMbrAvo9Z7YDF51OVW75E9c3Hav+EwerWjkrrjzT2jI/JT5KmseeFtEl/5UP44gUMYIDQO+/UxmHfYQ9I1xYRVPBjfijTrCqKjNKI7Bv15ZTsTLCIIFsvJPP5lzY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IRJQOKXP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YkLeDhsh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IRJQOKXP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YkLeDhsh"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673JkrmM990431
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 01:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/LbEgpSMFNZGfRfUuT05UPTIEVzlUc3E5z7lGNToJYg=; b=IRJQOKXPm2b7bBGU
	gqjjwsDObmkatrZgD9OND1CavG6jFMGSc3d2G+jQsm6xPS9crDMKF02rHrNR8aJX
	+YODpP9+x86wuf1vGf0g0GvgpfBFLDRz2d9nbY6gpkBqBmFWCZPcg63rDsf2dgH8
	z7XbzSaYk8bx4+IldKY136XkA/IAHWad0c49N1PZKM+AEuXfBo/MlKokuf6d6XD3
	/5Pu/ei3nMvvbqVn7ccRky/J7Lh+z6jZCd5Xg1LZ4vgoT8Wy84CALi5HjuLW4VCd
	S3xmgSn1w8mGfFO+qQ30u90PId7dAVfXrJQeFHAEektkrquX2w0CnPsUlkY+gWOQ
	Veh/gw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftx7m2381-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 01:05:23 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e22137fb3so6402588a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 18:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785805523; x=1786410323; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/LbEgpSMFNZGfRfUuT05UPTIEVzlUc3E5z7lGNToJYg=;
        b=YkLeDhshZFTbpx9ZRfGvDPl7xepARgqFYZMxmAIn1Bs7p+6/A2/UOZvNOMk8xnJsP5
         NmlxZwIHEB+fEcwUaExKKzTbBPeIV6u8hqIMpJ7IlQYak/2GiynXpd4xEjyQOMLor48K
         umCgXPOChAHBPDi/ngvUKu2m60mnhH1MnTaRdzWZ3O5+tlngDDw57ufbeiqNnhoOnIn5
         1OUkd2oOMCK6pvHGyOcU6EkYVKUxYEJQ+vT6CxJ34Tl1iYPqgE1IZtqkPewzWn/pzsZr
         O1gKHOFpXbNJDdOa/8N2/WMHZdyt9+nMUteNX7+lfGLSzzTcll7quJUGNGcDhPPBQn31
         CJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785805523; x=1786410323;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/LbEgpSMFNZGfRfUuT05UPTIEVzlUc3E5z7lGNToJYg=;
        b=Vl31JxCJYPd48vHLFH6qo6pvR2YqwdN6rg3knQ9DafQ4X8eP0XAa4ZZgR6tQghLY90
         oLsCmvLekzkCpDi2jAsQq+VIoLX5eZPa2nSGuBXh3xM/EgXY2CYMRIPw1ffU/MNl3St4
         xb+4LE6xYi6dNh1eMhwz8+D5CB/Zj6E7ttEaAex1VMVuJ1THPSvZdO74wmokdTwdswsv
         Fw4KM+Yhktx1pF6uUfTHiXWknTZHU982ktEXHOSf49u2FXkVq3fAeXY9U95nrPR0UHSX
         FuHedqAhgdv5RF6l8l1MWtEbweAxjxoAVUJfy4aHkgedvBv6k7mGBmirmPtW88ahytPm
         Cq5Q==
X-Forwarded-Encrypted: i=1; AHgh+RoOmE5iTyGe2LX7ODKRtpQkTQO0cKJ1KlCcet8fv9tE2f7/+dhCDxpxHxNWE9L/ia8+5mRMlskskAhojZCuDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzjoQfFyQXa1jJTJOvuSHdxaoIKc5z8yUKBoZzPTCx5qr93TYW
	NdKlcmxa0w0FnPmsYQ+KopjRm60Ciet8NvpdQvjXW1FPs6ezuriUMWz3nO4pzDUUlLsGa2R47MZ
	5hhkk/3KgvvbggxJP5by2Zd7uQ70Jp/h7Jfbn16+gYzNhzPUbpVxBG25vrP4NVX0CapXRTl9NBT
	q+Hg==
X-Gm-Gg: AR+sD12tBytpKVTbX4UnrCu/Ffzm0neRNpEnQ2B7+3BZ1AFBZ0ZlnFMFOazpwqtowSD
	KHjFr+jLsS7bFV7NWPGDFMPf7/reTHywZ3M+I950GRR8zdlUL6S1Ews3xKw5ZqN5mqj7TA7pqxQ
	TUAsTowwptZZ1uriEQpMnfmMrmm3gNWuw2ohZgwVX3nPwJaL2DlMwUJ6SKU2pHnsNUgtiJQoTzR
	qadrXrACujJVQz7p4CBidz4r+Njm0MFwJAvi65aIOD9TKE/IrBms/efIRmqpNV/mHYeUKkvzYFc
	yuMjQ2ScsY2ePkAcCOL4NayeOsuQ5NfuuEDllbekGmVqPMdRZisbVkai8430QBKR/Ul39rS0GHp
	eU/El5SeukwET+FtkjUujSYdZnlxpHk2coSqRlnvBLzOK1ZWYw0GkE8F6mabA
X-Received: by 2002:a17:90b:250e:b0:38f:caa2:5731 with SMTP id 98e67ed59e1d1-38fcaa28718mr5590475a91.40.1785805522938;
        Mon, 03 Aug 2026 18:05:22 -0700 (PDT)
X-Received: by 2002:a17:90b:250e:b0:38f:caa2:5731 with SMTP id 98e67ed59e1d1-38fcaa28718mr5590462a91.40.1785805522496;
        Mon, 03 Aug 2026 18:05:22 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e29a126sm45747701eec.31.2026.08.03.18.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 18:05:21 -0700 (PDT)
Message-ID: <3d358696-6d97-41c0-bbe1-199179d6630a@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 18:05:20 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next 1/7] wifi: mac80211: fix
 IEEE80211_TX_CTL_REQ_TX_STATUS mixup
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
 <20260803141309.292711-10-johannes@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260803141309.292711-10-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDAwNSBTYWx0ZWRfXyKxSShcRfWTP
 avO8tQEWZMuTjUwFrxt/RlbT7NE9aSrrcH3hAN2LRPukMPeW/SHQhnwFXpPN5hhRAMPIZ0YpSIM
 e9XDQmDvdZTBfK2NxeG+6/2+jeBoFa30kdoWHenW4u1biWJSIZ0doocqLWyIBa+B0A8xq6DihpT
 h/CcXbf3ZXqyVJrINJfkyRufPduWQdT96JYWhnTa2ZIrT6XPzu+8sb/WB4Fsya5QoYMDeVTVmke
 4UyhJI1cZk9SdSDUPkm5DvUkTbHerCPHieoQeJhqJFkFWccX/LRcG/YBRHnUZmgKBiOKr5r5/MF
 o5JeuBNHKGZeM8ViFOjjT+LvWF1Bfk93OpInTCkJfPjugSiqYRvMazD4/MXxSNSOm93EbmSVvuA
 AkI2hEYNB99UQc69y95KjLVAmExhrGE+nvL3jHMXX8sxwE+LwyX6KSe7nVETxRNhCZc0weVOKtg
 2UrvlxFo5FmLD24bK2g==
X-Authority-Analysis: v=2.4 cv=TIt1jVla c=1 sm=1 tr=0 ts=6a713ad3 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=QyXUC8HyAAAA:8 a=jm5SFhSk8r0fvC0Ct98A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: bri-cyW2eCXkEpq4j3FGWUrlarYC2Nfh
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDAwNSBTYWx0ZWRfXwYOqxZar3F4H
 tmqBxlikIJBPeBS+fj3eVPfv4gHgFKtwxcEWzrAQRPvaS05sfV6/5iWivJp7ThA46mFRpR2pVkh
 aQpz5ZDifyHIzLxannkBvYPRc2JbloU=
X-Proofpoint-GUID: bri-cyW2eCXkEpq4j3FGWUrlarYC2Nfh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_05,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040005

On 8/3/2026 7:08 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In ieee80211_build_hdr(), IEEE80211_TX_CTL_REQ_TX_STATUS is checked
> in ctrl_flags, which is wrong - IEEE80211_TX_CTL_REQ_TX_STATUS is in
> info->flags, so the check is for IEEE80211_TX_CTRL_PORT_CTRL_PROTO
> instead. This works out OK because the only place setting _that_ at
> a point before this gets called is in fact ieee80211_tx_control_port()
> which was intended here. This is actually needed for correctness, if
> jt were checking info->flags instead, TDLS would fill/leak the status

nit: s/jt/it/

> frames created here.

