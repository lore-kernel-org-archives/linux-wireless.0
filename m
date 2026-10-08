Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B4C37B023
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 21:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493687; cv=none; b=ovJ8oGF2TG6IC3AQwR5Dta8+XFzkd8b8dYQeXrYlGcs/6wmKu13/NZTIPTc6JZP6gBWNgUjdb2Xw64xJMvqXsB+HxCCB7rzqcmYC/xN2wFenHRqQJOJhDLBHX2YRckWoyNzmhFJ7hY6pNaN3Mw6SWcRSfq3in8brNq4j2x7dGNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493687; c=relaxed/simple;
	bh=hUtzIF+IkTYCOcwgzaK9WBcWIZ9fDmCDt1PiePul6OY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H/N1OnboIA433c2lvykM8YkIqhFtKv9VNKONIaPnVAV+zsGsp6DaHRQluktvKfsD+ZCe3QgjllLBSArpxD1R/S632g8L2Di8dLftLMqec1aqspQYqr43YBbq74SVGR5Q3L/9OWaIV8Im+Yk7V/nns0k8WpaKKhhhzVPSnigRkrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QaJfo9i7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aQYSkXHj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QaJfo9i7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aQYSkXHj"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698KxpAt3151554
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 21:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	366Pu8skYlXsy06X6yxAYEU8GUfGajlaG6xyecmuF1E=; b=QaJfo9i7kzxLPDFp
	jU3cmbBeXuxwHZEeSWWFLLzY3FATHPTkAbDL6YDW/Io20OHVLicLpIiKo3liOlbr
	fwhcf5hJyQbR8roKoVliQZIq4SrRXRZg8pvCNFqIkyipBiS/sYlKW3UwTNcNNeTA
	b4IKzKJBJNJhpAijUvrTFFWbJ3uNQBd3j5frWKuaZRlE5jJDebNupFQNepUkdzBi
	OrwA7UpInSCkEaZvkH09v0bKDPjX5i11F+Jqs2nJQTpRbV273FI9QzbN3AWhkCeg
	VzhvfUuginrR+Z7b7Sa9e15qpCSCEvGQMicosyMxxniR+XPOUobHA3gd7z3ZnTIb
	46h1hA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fxk0nvu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 21:08:05 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3515266f6eeso2872783eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791493685; x=1792098485; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=366Pu8skYlXsy06X6yxAYEU8GUfGajlaG6xyecmuF1E=;
        b=aQYSkXHjvoOvnf6hI/9x13F/K6/wnZnpTgOEGZocnsdDaCLx1DPZApSUJQl3Qrmcs4
         zl9AVXoYFyz0NVvhxqMXGCotZ2GwbrphiP6IsImJVkOVy3A73fkWqT84s7Bzf7a216Hx
         uJyxZ2JiAD0ROYCU+cUY6DO1odcNXx/kspiWMZrbs+LqxwGo1x4r21qceOQ1C81Cl+bQ
         htkQJAJpzXEvLFuNeRbx1uO7HkeYPlxvCHvCW6ezLQYyS6AlGf9rljatJP8tql95obwX
         fJm7mwjbHTVg2RGXM0gB0QUpI7P6UgtE/UIm4I5s6nd4JZKTOV56JkyStaL6WbN52A+I
         aAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493685; x=1792098485;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=366Pu8skYlXsy06X6yxAYEU8GUfGajlaG6xyecmuF1E=;
        b=lgvfltM7mFxqILJJ5mxnSzx4BHLd9/98ZWX+0DeKnIO+ze46mOums9SA1DL3ijG2+0
         fCDuE/rZjPBKFLscJ+L5Emmx/yMCHQFdX89lhsGfEVdzU78ic1z8xPIEB1VO/6poLVGC
         jkh9OM0W16wuKqhxxAt0dUwCaQ1r1N5c1wq2iP1QLUlNbJFldABEC4wL0c5iWRe7CCgj
         3Jxd5T40kk1jPGfbMk0wue90bZQ/BZIVyqgXAS5cZ4Q8uU5/hDUL75JkwZXCTTthOoVG
         7+gCaaZ9QPrjzIAT/mDfkGbfMl3xhi13X8z2Uw8CotdMhmTF0kktbsMTzytK2EPbFfKb
         s3Kg==
X-Gm-Message-State: AFuF++kHhqlQfCUlMVuXYVXZEwhqu8qPETym2qWCbJCo5EYcSBlHgbUH
	79Sp59OZlU5Ap53bZ1NGH69NI6hSrxVMhNVw2xRYf6jX55llWxmZmkbpjo9H6ELTf2bQ4KY+F67
	Eao6bJw1ELvgTC9OtZS1GFaMmIFWT2V1a3o+IFMdexaZHfAMNM4vPvU/q/Tj+igiRKDqnBA==
X-Gm-Gg: AYBFou3tuzmgzVKHLMwc9VVzW/TH0BcNJ8CgiGgf35oxTawDSLl1HicoYP9wB4T/M48
	kqAjSo/T/ACJc8FqYOXLn3GGSSAq2459QuHP05+cLNsS8wNEX2ddLcQeAx37KB2Yq8S8XJWTVcP
	rNtBDxBXNpyN/ySJue7Cl4aHlsRGP4BvltAj5pdjxHSzAjRNeELKy7rXcWMZnUwDtIOLCdGoVqD
	cdu8aDmvTBp9RjiJML75jsAjH9xJ2XvO2M/t6GcfLLzIpKX8gF7jTxrjbdqxWjuYShZtJ+UyeWL
	R0r/LnbF6O3gibiNpdYavJ1KrnGkiN2YIaIR0NwNmzopBnsv0M5NCyZ4HOXaqh8GYpI82huNJvs
	7vmtwaMk+8Fx9QTUmQQcjYg0caKaIncnEOSw83JJ8FsCpcZnfDbPhBOcYcw==
X-Received: by 2002:a05:7023:905:b0:166:847c:f162 with SMTP id a92af1059eb24-166847cf1c7mr3573659c88.45.1791493685038;
        Thu, 08 Oct 2026 14:08:05 -0700 (PDT)
X-Received: by 2002:a05:7023:905:b0:166:847c:f162 with SMTP id a92af1059eb24-166847cf1c7mr3573630c88.45.1791493684361;
        Thu, 08 Oct 2026 14:08:04 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1698de65af7sm926202c88.0.2026.10.08.14.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 14:08:02 -0700 (PDT)
Message-ID: <30531489-8d31-4972-a3ea-8a59b154fd71@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 14:08:00 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/2] wifi: ath12k: Make RXDMA buffer ring size
 configurable per memory profile
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
 <20261007-mpp_ws-v1-1-739b1fb87d24@oss.qualcomm.com>
 <cf9dbfc5-5787-4a69-ad04-153afdec1cb4@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <cf9dbfc5-5787-4a69-ad04-153afdec1cb4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=fKesTpae c=1 sm=1 tr=0 ts=6ac80635 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=LHOLFAxaTfbGgc5nesYA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: FWQ1sC3Rgo3_7cMSx-LRUu0oby6vBIxc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA4NCBTYWx0ZWRfX/RxlmhlLYS58
 T7KQcJ8XJEIVfsrsOYv9jieFOoCBxz0zjLUaXP6mE0avQw9uxpCeatU4K3yxu9M7KCyVUUZzKqN
 Iv2tmAQl/fFHDBzCRuGvcXmIDku846I=
X-Proofpoint-ORIG-GUID: FWQ1sC3Rgo3_7cMSx-LRUu0oby6vBIxc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA4NCBTYWx0ZWRfX7Djziw+lUmn/
 jlTCohLQkAsJOqEJCKOY9jCMYjVPwXLOZsl4k3jcwpQNheBvpZGg0KKTVYhdDXENjUqBWxes9b9
 KBDosti2LEzd7QEgNZq3qCButk3nJC+PpMJO3fr8OEdbNFSsPGHIO/jIjObw8q1YBh1NVj8jM3j
 XBxY7L5zHPOXJLebxkLyZtgfmier6plP4sK1aX94LzSYGi2g2eOXjt9S+24nYOImpqGanqZFVol
 0AbKXTMWPy+ezD4lmGiq5PWX5ljdj88GgPyI+jVDyqN4w11QR6syp1Ac3OIGx67XAYLhTMEPbSZ
 oq+K1xNCLCaPXofCs5sYjaUTzPZZMZyr8fIh2a87ejJUEAR04Vcg7JpbUV/g9/zV2X9qGhXQ/JE
 qWFf2pOIKIM392V8o/OnOqDvEJO29bM4V33XKMl9AiDlpmoaMLlKB4RqYRnYuNlZhGZgWX0fHrq
 1jkFxf6DBRwVNhfzkBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_07,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080084

On 10/8/2026 9:23 AM, Rameshkumar Sundaram wrote:
> On 10/7/2026 2:53 PM, Aaradhana Sahu wrote:
>> Currently, the RXDMA buffer ring size is hardcoded to 4096 and shared
>> across all memory profiles. This prevents individual profiles from tuning
>> the ring size based on their memory and performance requirements.
>>
>> Add the RXDMA buffer ring size to the memory profile configuration and
>> implement ath12k_dp_rxdma_buf_ring_size() static inline function to
>> access the configured value. This allows different memory profiles to
>> select an appropriate ring size based on available system resources.
>>
>> The function follows the pattern established in the previous patch for
> 
> Previous patch? Did you forget to add a reference?
> 
> Or maybe we can just say:
> "The function follows the existing pattern of DP ring size helpers, 
> taking struct ..."
> 
> TBH, I'd prefer to drop this paragraph entirely since it's already 
> apparent from the code.

Concur, I'll drop this paragraph when I pull into 'pending'

> 
> 
>> other DP profile parameters, taking struct ath12k_dp_profile_params
>> pointer as argument.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
>>
>> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
