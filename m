Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E9768EA
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853815; cv=none; b=TD9AKATw1vufwFuR8Q6uDMbd7TSlvzij/NuaTJF1ivmkY9wb4HPhQ9n1I85bHpa3ZILrsAr50J/XZ82V/Z7bP0Rkl8CkLXrJHK5xPe7joAY+ZnAtICjdPkGS3UiAiqJW6SEFoLeFzLdhFMn6ltGcCBXVMsSBwsVZ1Pk5HXSdIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853815; c=relaxed/simple;
	bh=Xn9WV/7EUTd11zor2m0yknZm0GR7nrQaVMzncFCyd6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqk2F7EMSwXMbQxyKHjmY3GFYtf5Oj6Hkq7jZV7oVsCFbNjgMEiPXLcYiY91fmcOifyWZJWbwX76uWgdYzUlSHFIX4nubStWu45dlLqj/4fQqtCHcFFWcu10MQ6JuXpYaQoOIsh9zqnjx5465cVbjPDRbK4NuEZ3ZaolsaKYdk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JVTzPTJW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fNP5yQIt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JVTzPTJW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fNP5yQIt"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLeWmW1237285
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	W5oCbHR7p8nDpjIFLZ0XnVLrRBfnjEM114XfiUZr23U=; b=JVTzPTJWQuT0ld1r
	JglsgnuI1zYASfksAh2/lGhng7t44TJkNPdZI95+I27jD6FJcgVyV9CcS+bD9YQz
	0wRiXFjN+QdpEvJOdMjdOnpq3h1cFsB5KC2UmdVFVDemx9x4fUhNSYHYBeV2YeFO
	1qtNCcTXrzbBlZlxTcL119OstHtqr7x3s78zRB+m4C+4JUUnXXo3VYmcfkcsgMiQ
	LjiMeqwJ12sskRriGGy7QIKAUd/y9d1uUM5BNxBlBABmyE5Xzk5SQh7TqrnEB7Wk
	pWtm+88rTO+zpNpxpcLrNBiGv1Uv3F5wOEIuzp3pTS1gX37mph+Qgg6zQoii1+fz
	Cicfig==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkp5vht8e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 00:43:33 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb733fc5024so2059100a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 17:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784853812; x=1785458612; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W5oCbHR7p8nDpjIFLZ0XnVLrRBfnjEM114XfiUZr23U=;
        b=fNP5yQItSOeqbdMdPOBo+UPFe3hwqVhQ+i/0fptk+b7bUMcJRBZCYl/0mcrBrvCZMv
         pY+vistO8XiyAEqPF3DfJPVq3wMWXhT8exnPBceFeErVMjQj8EsKcd1T8vbfwMj/Jvp5
         lYw2s7mF+T0Pzmlf0smH77rdOS7BCxA3Uz8m67BPe/gWgmcNQXxxQeo6gbS9iDVnFqHl
         Y9RbB1KXChbWAhuIPG4Y2687ka8o7PT+IoOZklD/sU3FPpqz9lWivehCb8mQMDCuYguZ
         TfApLIpEmzVYASwqpZHOPNacnPwQzF/A4fsfEwCRWKhJ7W5eeQ9tm0r8pngLXL6uTvC4
         6LPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784853812; x=1785458612;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W5oCbHR7p8nDpjIFLZ0XnVLrRBfnjEM114XfiUZr23U=;
        b=CQ0xzfL17/2rcDmv4V7agD167obfhkntXJXS9YlS4mQdKd+F9F9gtuiHASYbOs7Aun
         5O+Rq/EwncucuuSD0o36pQ9hV2tqOlDebmEUCmwUOwlKi/rCdJlQ3iIPL0I6FTZpJs43
         nAhdTGUqlJUYqb4nNYMUn8h1AQE9DJtZAk4Z2pE2hrzf09SE7xfJMkBQqvEISankBRCE
         6TZY3SiaJEhrsuavHa+KnyqBaibaZ049HxEA+ckyoYGJd5WHPWdW8uaElR1m/J6thkRH
         E/FWDinqtraPx/Cbifwp2vodfrmpP4evp5EBAikrtF/4Lh02j5F9cYFeJ2XwLhbkv8ah
         MDDg==
X-Gm-Message-State: AOJu0YwFJ9SCjoyAluhwr4UaT2NEbJh0WqKYNnS0LGFwRlEsZ4R89/Iv
	0ptXUNTF2e0zxZztX85OLnvuuJ2dl93AbPyPF8/oYSkYnFp4RczRcmUA4Ambclb0MS4TnDUhK/B
	NR4ABWDb6eOdLME3vEXd2Nw88CM3AdcT4eg1qC+UQYyllkoOcUxkzrH25j7Gv/Y0LClvogw==
X-Gm-Gg: AR+sD13m2lUe/EpilPR1ZIgdpI/1GdSS/M32OiWCicdGWGOQVwcmEtifOxcLlb/BbsA
	xQtcK12MTxOjQhUTiwRvrk1ZX/j5eUZzReSgEgGaGGl+prs9SM7/ZRP9F9eXbGxoDEjbhFxFkqw
	AJ+RyG/4lFG229iSQUIrmwDnQfxjHIMcCku21GN9t9bMnIkzZhYBgZCUeWernebGN9KQxAYkoF6
	oQVxjR+mBcP2BT/rlR5CAmLJ2CoyG4+eYmS8hryW6043u39LrONnIUzs/rjzcnsUY9exP8pnoAV
	+3Y9SItKbRGLFkjTCsr16LocS3yzS3Iggf6Cn+YvhONINDh93uB4mYCYE9RQqY33eGYiRkEP7f4
	Qx8N5zcBvoyWm0Rl83mPVIoVRcoeTii0a8++HX7cJ+q/n3PUTA0cEO6DY6Q==
X-Received: by 2002:a05:6a21:a8d:b0:3bf:ba89:5236 with SMTP id adf61e73a8af0-3c44b065742mr5930602637.33.1784853812344;
        Thu, 23 Jul 2026 17:43:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:a8d:b0:3bf:ba89:5236 with SMTP id adf61e73a8af0-3c44b065742mr5930583637.33.1784853811959;
        Thu, 23 Jul 2026 17:43:31 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e0818e4sm23730568eec.22.2026.07.23.17.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 17:43:31 -0700 (PDT)
Message-ID: <3998e460-bc57-4376-a5a3-0dfc6852d625@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 17:43:30 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath11k: fix txpower in ap mode for 6 Ghz
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260514202750.3040404-1-s.gottschall@dd-wrt.com>
 <2c56c58d-4e04-427b-9309-8895ccddc03a@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <2c56c58d-4e04-427b-9309-8895ccddc03a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAwMyBTYWx0ZWRfX/i2xtmwwYpjD
 XNxML8kd9hJpK5IzxReeIqOYamiGQksz5Wsn/lTq7z4DUBjvlpNFjReiSPwsYMNS2WTHO0Rjxpm
 2sLVF0avMsA9nZWTvPZzRFSNc1NB+ao=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAwMyBTYWx0ZWRfXwBv4STtzYHVz
 yP7LeXDSkBdRo6Qk7wWCcEgfHJfueSsb1kus+Yc4v0Z0PvDlJreL3Rb4FgIPRz8gVw2tJHgpEGc
 0QhhsnHjpQRzlN+gJtDu9nutuNZCBxljBba6grvYfW3/UZrfj+8KYv4brQq3Y4ESaODGNDyRRf/
 xcXL4ajZaxvT/7w5NNWUNZ/QIvKpfmkvWqyb/cQBCJa3C9B8Y2yHzfiRhx3lTeRQ1KAl69lHmbd
 FzzSV5t7zbJh4EzQfifhvHDb/pRbmLpuSpuFmKTOkMA5TzWYBZ/Pk51kRdv/2mg5lnT6NI5Sjiu
 4r5i6H0BpY07ZDMeQve8VHN8J+olbJmCUe1e/QurcA3kmC3Cylx+zAVWC3XdQ/rQJBeB917iS+u
 vGEvLHD4HCs2HYr/WS+HFkKT44bhOegOaur6gIOSS4A1Uafn5H1mgdyFEBbk3nb1PnGE4/xrbt1
 9lGNwEah/Uj+mXWPTYg==
X-Authority-Analysis: v=2.4 cv=Z9Dc2nRA c=1 sm=1 tr=0 ts=6a62b535 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=epNStaLaolvpL0WOnR0A:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: B0vdmAxkYOjiMX0m_8EtTiPxg8gXoc0-
X-Proofpoint-ORIG-GUID: B0vdmAxkYOjiMX0m_8EtTiPxg8gXoc0-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240003

On 7/19/2026 11:31 PM, Baochen Qiang wrote:
> On 5/15/2026 4:27 AM, Sebastian Gottschall wrote:
>> fixes: 74ef2d05ede63fd6416aa635aa8972dff901325f
>> (wifi: ath11k: use WMI_VDEV_SET_TPC_POWER_CMDID when EXT_TPC_REG_SUPPORT for 6 GHz)
> 
> checkpatch errors on this. Three problems: (1) it must be Fixes: (capital F), not fixes:;
> (2) the SHA should be truncated to 12 chars with the title in parentheses on the same
> line, not split across two lines with the full 40-char SHA; (3) the tag belongs in the
> trailer block just above Signed-off-by, not buried in the body separated by a blank line.
> Correct form:
> 
> Fixes: 74ef2d05ede6 ("wifi: ath11k: use WMI_VDEV_SET_TPC_POWER_CMDID when
> EXT_TPC_REG_SUPPORT for 6 GHz")

I bet Baochen's e-mail client split this when it shouldn't have.

Should be:
Fixes: 74ef2d05ede6 ("wifi: ath11k: use WMI_VDEV_SET_TPC_POWER_CMDID when EXT_TPC_REG_SUPPORT for 6 GHz")

(The "Toggle Line Wrap" plugin for Thunderbird is invaluable)

/jeff
