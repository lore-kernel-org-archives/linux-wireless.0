Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A96347537
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129705; cv=none; b=GbEzdwdQ49vbIQ0XD1eIMU0kztQiFOVQfG/OtdM7Qhg8hgeABF8w5vUd9gE1+NcT9ErmglLTE6EKtEQCwlxmKqjPZIQQA7U5CScEyiO+B2i/nwmh0dIqfz3Jv/Cvgr+bsxxZAP2csHWImfEMlcTf3lzeiD6mkN1qvL4ZI+Zfgzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129705; c=relaxed/simple;
	bh=IzNBzeT5sJGNHJlgxPLLZfWRn00VA0Edxj+ptQNZJZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AXbkPZKz6cmHXbzycj3kTEc0dYTmR61BWG3qEocc5ciaKG1VECSO0uqZhJXBg2u0w30BTI7kWbIopaD5UD4/YoGdHYkY+gysoS1Rnl6bq+h03yUpycaAocfestiConRtdGIQGaab3wBi85Pngiob3jdV12lMLsxs8PznG7R9f/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CQYKOLl3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e8QcuGCp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CQYKOLl3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e8QcuGCp"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1gDQY2176233
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	52Rspb8/zqF+k+WcUxUJBPO6BuLBlYwUBpwGih//88Y=; b=CQYKOLl3K60gTh6R
	XfhEzk8YPaMyisJpFyLkeJZo5NPaxw6sSvdFq1SjrTg1spBCAfbw3n697cNkITzv
	YFR+jzFx5/vh+9Ze1ZoE9Q7rtI/YIDs4rG9JZ5AjETO4JSq5GYS/b120hNJicqp5
	86J11s+3AKzine6z21wSGlsJPdx70PB2Hz3KFBqvU8blpr4AmiXeXWedtYEPkod8
	2wRLKnIDOUzUMjdhrYIgRyK/CP9E0dKbpVC+BtRiXnSLr2HpHZWS/m5BAlkN+ZzT
	8u4pDE1zOvAB1P8wpRkgPkOUcy6jWAykQ2RzIE2uG9FB5Si3zCFHoo27XfdKBTVi
	ZJeJEA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnwevey7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:21:43 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cd01a14e81so33251765ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785129703; x=1785734503; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=52Rspb8/zqF+k+WcUxUJBPO6BuLBlYwUBpwGih//88Y=;
        b=e8QcuGCp5w1okU+3VbcrVuplJLHomBDlJwYmVBshYn5GENtJTV3DEb5rSBNYxRK1pb
         rh3ugSdtXWkYBAhZzvvGtpr+WeyrqwwY4viTUAN9cCaNf+UJqrPWosEMD8kJXBk56+GD
         v8TlSzWzLcUw2JZrnLN3NjbJSZSApDXS5nDv//rVOd+m8/eXmT51hed5GfaZX+RLpVZQ
         l1NKY3NA39TmF5sILJ2WT71S5ZRCihlMRiW/Ibye1lDaEQqwhQON+4JKLwRjHuhV8H9a
         sxNwPmJpTFfyFQ3wtUqwlbBOWMROxHSgM6k4/LdsNf7a4ck39tIKcnXsqLjerr+sW7Bz
         RrZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785129703; x=1785734503;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=52Rspb8/zqF+k+WcUxUJBPO6BuLBlYwUBpwGih//88Y=;
        b=VLZI3Hhf6zvHglX3bvDfY0dtpeG2ikVIfnacUrmN6fEKG/Bd7Y+WLp49bdOeLwfQCb
         TRovZiscfFxok1e6TiaIziYVQCXaCp3bcrNw9tOE/bP1GxeHe/E0mssfDIudFubWEgS3
         wEVFbb8VBHb6klK/Ov3rk4valHK4NO2rPXa5i/BCG37t+OFmCYz266roXB9guxQSrp1F
         VtDtlFyUVGmqFXN1sePzBGPSB8ua42jHkMKewW0vEHDQ8+83gKJi4gO0wGCx0/BvYF9i
         NC6lOEupB4oFlJ8u983CbnxA5xfDZVfSJ1jxpnCGg8XqIjKikYUuj6iWYhAeqDJmBbWg
         6Bxw==
X-Forwarded-Encrypted: i=1; AHgh+RrfGV+2jBDrj5dmrIbe8zUJbe3RNqVLCuPQjz7Khp6N14/AdUj1RGKvxzUM7WI6gIvrtteYCtmyDbj26hjPFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS9mwWlWkPntGK8UugzbLv53Eh0vvwuPtxix6TDrTMpzmgD973
	0Qj+LTogji6xl4lRE7WE53945AwNG66w/6sDlqBwaPQ3VB1PQht8SkfaKLYhpnogDsfHZSSb0aL
	0pWTCrvjSJIytjrS+MVMZwJkSsm8KNh2OCSOt3PXZ3QjXygefQuu/SmDcN11kteFzktgeE2KxpV
	1bpw==
X-Gm-Gg: AR+sD120bdGAFIt7N7BxJoGDFNXii5Ae/XwATd/2vXqavnEZnVTKVt5tjPRjjJrZfIO
	v+C/hCbIlB8UmAniF0W0ZGEDlIk/8tNHF3K97GW6CNxsak5pbAknrUXxeBHBdNGKPaDXs2+iDVJ
	3IBzYXlsOcnx/VAsV9LodK89OICqFQlWwGBBDbsBvbaIc9gW6jGjinQQ5CqWlJ3fKvkOccfe9eD
	18aaCdmzSy4JIBtu+2iJDLQkF8nAplqmh2U/Blyr7Rq1ZCVINmZQdkR5uVOXuKpLwOCzxoFwsIv
	eP7edAjUiRrI1BgrGEsiyjEIgAlIQuYZWoeaZ/JEo+xy5z+2cz3KjpKDM/O7uVdVEIcQt4meXYP
	JQKQi1fuTQ6d2jdP5ROqh9BLGG0QnaL8=
X-Received: by 2002:a17:902:d54f:b0:2ca:6c8:abde with SMTP id d9443c01a7336-2cfde7bd7f9mr64976445ad.18.1785129702635;
        Sun, 26 Jul 2026 22:21:42 -0700 (PDT)
X-Received: by 2002:a17:902:d54f:b0:2ca:6c8:abde with SMTP id d9443c01a7336-2cfde7bd7f9mr64976205ad.18.1785129702254;
        Sun, 26 Jul 2026 22:21:42 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7f4a05sm27942455ad.68.2026.07.26.22.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 22:21:41 -0700 (PDT)
Message-ID: <8f87bb32-b67b-4e9c-9ee6-15d7c18308e7@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 13:21:37 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: validate TLV length in
 process_tpc_stats()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA1MCBTYWx0ZWRfX6WGikq1cHz7z
 w/wL8sHabAkhj1VX8SWW7yGc1nb6k+vNJBikB2RrRUgAle+XqK6d12aqqgn2SYH3OoA3Qvi75fp
 ojPOIz0uHfc8ZQMtKxRDdG3LIbK5AVmIszdIutskWncdKA8Km1zjdRXySaxFJB3G87oBv46awGl
 f2pcJfUN34ESDa0ufTHfnGYtXYLPL8fflwcjahHCLmLDifp2kOJvYbXM3ZmzXLXdnC1mI6f7rQE
 FsKIgMkIkiP4pwjV0TsM23CFiqzC97P+0Ubfdhn+wS2I6glzD56GD06m5mGqndlsaXrvlPXBt7S
 oP6pCLoPk2bYOUDx+3QV9yvVQh0zRvgN0B9AsjfpAMeCnsoXz/sJ6zlpTIX9XGrM+CKOeWIQ5xz
 RZwpK5iGNrHrXoqECab+ymzsruyino5nFqk5MUUH7GckDPa1FlPjUF3udJS0oKAdNw9jx1IqDNI
 1T6Z/xHCtLSYESqxyZQ==
X-Proofpoint-GUID: oLp4nwix6_tJEZdwmog0CiMuGVI42olH
X-Authority-Analysis: v=2.4 cv=S77pBosP c=1 sm=1 tr=0 ts=6a66eae7 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=Gn2NXTlqVLSkllhtcaUA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: oLp4nwix6_tJEZdwmog0CiMuGVI42olH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA1MCBTYWx0ZWRfX2FOPOkGXzmZ2
 tUhLcBY1Fu3EVMZcHqrYE5NaZdg7HlVA65LIl8zX6rJJIdnEF23awEr3Dgh3GbBJ335TZXvorU9
 dW4JiqiTwrzGgQXsp6EHB8UiEeGXReg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270050



On 7/27/2026 7:02 AM, Jeff Johnson wrote:
> The outer skb->len guard only confirms the SKB is large enough
> to hold the full fixed_param struct, but the TLV's own WMI_TLV_LEN
> field is never checked. Firmware advertising a TLV length shorter
> than sizeof(*fixed_param) causes reads of pdev_id and event_count
> beyond the declared TLV payload.
> 
> Add a check that the TLV length is at least sizeof(*fixed_param)
> before casting and dereferencing the pointer.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
