Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63937CD5A
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787249542; cv=none; b=VvtJiZLJKBj2tOgfflqTGT+vRtez2NHcLCs0GsofLQrym+Bi9xxAqS7Tq5VV2tGi/f+3kBQFAaLDMFg9CY6MZ26WFVqxNj3nf6PsFCjsQh2X/22i7iqMGlRH7WaxRSV1thVxqVhjqgx36S4qmpZSHhbgYBvZTe/+xaq9xDDsuxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787249542; c=relaxed/simple;
	bh=endPAjHLMyi2dILBWWSlvh0Bck2tRJ5qYiY86L4mh/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKzS7D7jlaCJsiuHXFPLQ4o/jT4B5MHWq6S/4HCce3ojFe3jIBngzXK+4gMcngWsT60JaIJjNphJPKH9T2BxIzIp00KH93MoFt+X9hFBCEGXkBhchQTz7iqNoCNue+vc5vmLwHRvPZuYJhoFOTtj0bi5Ax8nx1qXoi5YBbEinPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kY2p0y3H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hUHQllmM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kY2p0y3H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hUHQllmM"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KG7BrP2969017
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 18:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cKBy0+k7TJpzBUIpK0d3DuP58yHbMebRi/2/3eUJ/ns=; b=kY2p0y3HW8RDLH40
	T3FRoWAJ2fmHWAtkPWIL/NbBXWfbN2CFSD7QsW6XnZrABR/i4WhCeoN5poNBpkat
	Uc2JPxiHQm4eBxriVUU1T9sMJNE+oxJ2MEy0yXtKOb7i0UTIUwXZoqUHM8OsTfVn
	1Hi7b0Na5218CUbo6YQr0MNkqA+kIqxS3SHIQdoodpXL3j/7+HeGIHAeQnlmdV18
	K8V007rULIV9kzYYdnzrPyTOk4wy2rc3lA8RloEBN5mGZJiEpnDQalylN3LwxXGt
	eSspdIJULnA1sFGcSeZ8WRPBFAnzouE3tvhtQtcaDIsOc3zh5J4Cq72uzQgjSpcI
	v8sRhw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5ytca517-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 18:12:20 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbedbd182f5so37727a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 11:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787249539; x=1787854339; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cKBy0+k7TJpzBUIpK0d3DuP58yHbMebRi/2/3eUJ/ns=;
        b=hUHQllmM7uJOwlwn+yQbTNsn/+03CiZAwJFIejsCbu09hWuUVtEw6ECsQ5JXlLQA2A
         vJJ9xBnqryGLbZPofb1atFG4MPYl2Cd25b1GRj7WQ0FUOLxQXADPAuLqkZhWh2+ZqgP2
         /mIKIMvsqrQrR863SHos8ak5JB2aksxG/xKSDkjPcX1i5HrMj5PgBktNdPndj3cIpFUp
         KFG6iT5rgMvGnr9nlGHySNNOSq4N+TPlHc3IBPcOmlX7jKkoSxSt2DwX2yaKO27YxCC7
         lzibGo8IFtX1qH1cZ2+E7pvoEHSyuehCybZcC94i4EGhHkbv4NrpWrhyYFwSHq4jifqv
         qmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787249539; x=1787854339;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cKBy0+k7TJpzBUIpK0d3DuP58yHbMebRi/2/3eUJ/ns=;
        b=bPGQc48wvAXM6pvzImnQ0ZxC9zYHOcGiBFtjJiqI8GckM3gqHRLGK2RfeO/1kG98na
         W5aHw4zxeV5S0p9C0cyoPSBOgk1xNmif+e4Wccq3Cp3K1w5IyjQy3olkN9j2sIA9xTsK
         hGyFqWrvLVnL42XKTnZmuDYMhhxQm+ymkYhw0KQIMFTx6JnmNGtIg5J6ZDGuO09JlFqu
         DRGwlpfMm3GS/YFMS+KYZV3mEi5VMGEp/k1klFSCmHRuWwVX9PQnlHMpiyn1tsx7hG2t
         2Kvhhl/cKnwMsmlFKgdb48+2f6sAHqCoz/q/NbnsDJUex6Y+0rNlwLdJ17AkRMROmuhz
         mSjA==
X-Forwarded-Encrypted: i=1; AHgh+RqoRLAGAPqwLoBVPOHCCQ2cH3smqpHFHkvGW/FsWCNMZw5f38S65DNBEFk7JGoWw1BxqxqVt3wmfNdpSEvdZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGbu3aLfixVSqDjJAtO070eYZrKJFa48l7gBPfGlYunxdr0hDX
	ThQcaOsEundq95w8fGxaG+DTRLTOedfE0KHT+7JGTWoUH+nW0gd4S3RtO/jPlZciNDIrLC+4Owj
	CSU1ym7fjNTLmqugjjnXCRvMd5q11Kl8MUyD93xySFjl0MZ65YUZKpj44GLsr77FDG5FvOk/Iez
	lbsQ==
X-Gm-Gg: AR+sD13PXsoEstLey3b/LwfAMY6FSYZeCQ3dsdsXvFwZGPrCVowwIi1UiwN/IedHUel
	7/hcd9ZWE4dOt6ls72WjqW+8hMtTLZxOFQr/Zku3LUYr1eaadwarTnCj1a22rQRzMNdxIvL8B80
	n6nLwvoWBJYJ6rkxMpIC7vnmb7aLep5ZmvzFzNval/EawFv0+OCv1Rw/M8OwFuwrzcyovWFmN+I
	wYuK0yZ/crz1jH5gXjHPOgCO41vwYljA8yUK+l696g3aQof4Md4vkhAZ0Vevn2UCOCwqUWPODOE
	BnuA2w6EU4KgRFH8T92WlXbp7a5xi3BDdIndP7LbVQ+h7YvBuEeYbm1FiGKMbVXQe+/N7DYa5oT
	4WGO6hMn/zcTzJv//nxowCZm/aB/T5u7IJaEY9VRGszwolvRfruwUfjg=
X-Received: by 2002:a05:6300:6bdc:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3cd14d2c28bmr9766219637.5.1787249539396;
        Thu, 20 Aug 2026 11:12:19 -0700 (PDT)
X-Received: by 2002:a05:6300:6bdc:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3cd14d2c28bmr9766171637.5.1787249538963;
        Thu, 20 Aug 2026 11:12:18 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad564bcsm20080476c88.5.2026.08.20.11.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 11:12:18 -0700 (PDT)
Message-ID: <60e80a6c-c579-4d5b-99ea-c239c7048c64@oss.qualcomm.com>
Date: Thu, 20 Aug 2026 11:12:16 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v3 5/8] wifi: cfg80211: add attribute for
 TX/RX denoting there is no station
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, Benjamin Berg <benjamin.berg@intel.com>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net>
 <20260819155703.4f0cd22452ae.I4cfd3db83ba3dc0267575f919ba613ea5d10abd5@changeid>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819155703.4f0cd22452ae.I4cfd3db83ba3dc0267575f919ba613ea5d10abd5@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=OqZ/DS/t c=1 sm=1 tr=0 ts=6a874384 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=hHivSj7PwCqv1rpHu2cA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDEzNyBTYWx0ZWRfXzqRDvuqMiyHT
 RPx4EVxRTjepUWg/+k+wJThTZTu2kj18Iy8aC7TFZ4XcxV8wmBRxHoPt6rD6OayPvtpZsDJHZSo
 sgUzmkhdcxy6Ce2QNrHvtL0+G8OAjI6E1r3NxhdMegnt3ZPKtKigpalu+Tdd2Z3/AFmxXjc4Cj9
 jv8q0/nk6DL593rWg4Zp7vcx7RMO5lV5y0cmkUqk+yTgvdTf/Hp2MC0yA3PDT+gqdPM+EiXleNn
 u2KUZQuftXKzBEpZVwSYUt3SPBgAZEbzf927SIRzGuXs9LN4xqn/tJB6gJ1g8JqoPXRRwCDA7gQ
 eEmRpARYEXUVp/bd2eg6Sl0Y/gwueL5o9G5DlICFN55YrqTTihjrEYSJpsnujZzBd1lQxhOWyAb
 y2t8yuTjGNMRLBcbe53qhMveTwDaY1LwqmCcpZ/TiRnPZ106ucIURKTECdu7tL4Pr08IDa4NGbi
 uR1vH/QoEiBMkJc1p+Q==
X-Proofpoint-ORIG-GUID: B1ykrp59eNfOOqJzQidZ24IY7qfWxMsh
X-Proofpoint-GUID: B1ykrp59eNfOOqJzQidZ24IY7qfWxMsh
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDEzNyBTYWx0ZWRfXxwCdKQQekZdN
 /8lIxyCFsE3N8tqa1QWpSSz71i7Xu1Zj95+mRcFFLQdb1hczZI1zB9p6C8ETqpFyQI135bUiLmB
 uoegps0sRw/rXFykCrBSvPgKU+soZKI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-20_01,2026-08-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608200137

On 8/19/2026 6:57 AM, Benjamin Berg wrote:
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 020387d76412..4653f8f26ee7 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -3185,6 +3185,11 @@ enum nl80211_commands {
>   *	The aggregated message always precedes the per-link messages for the
>   *	same station within a dump sequence.
>   *
> + * @NL80211_ATTR_FRAME_CMD_NO_STA: Valid for NL80211_CMD_FRAME to denote that

**Minor style concern:** The nl80211.h kdoc comment is at line 3188 but is
missing `@` cross-references to the commands that actually use it
(`NL80211_CMD_FRAME`). Standard nl80211 practice is to reference the specific
command and operation (TX vs RX) more explicitly.

> + *	the kernel had no station for a received frame or should not use a
> + *	known station to transmit a frame. This is relevant to know whether
> + *	MLD address translation happened or to disable it when sending a frame.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -3785,6 +3790,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_STA_DUMP_LINK_STATS,
>  
> +	NL80211_ATTR_FRAME_CMD_NO_STA,

**NL80211_ATTR_FRAME_CMD_NO_STA name:** The "CMD" in the middle is awkward.
It implies this is only relevant to `NL80211_CMD_FRAME`, which is true, but
the naming convention for other per-command attributes (e.g.
`NL80211_ATTR_FRAME`, `NL80211_ATTR_FRAME_MATCH`) omit "CMD". Consider
`NL80211_ATTR_FRAME_NO_STA` for consistency.

> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
from my review agent,
/jeff
