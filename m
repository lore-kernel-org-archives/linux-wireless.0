Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2801730F81A
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792112854; cv=none; b=GF39CH2r7sT3oXnL9zMX/cHAUPk7nN0EA0xD7G18WAI74Q3+QMHbtHdo65+vduVvuJtoufH8BIq/mq2PFUgJMAtkcffS/gS+cx/l54OZQtUuckaJE4q+/E7DhNlSaRQmsOvNGwxLN3r0qG18TxDL0XYufzLcGl46V0AROaHyy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792112854; c=relaxed/simple;
	bh=bQ+rmTFzrrgsqV5HhTdCioLFTujVoaaUbE2TfekZgVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scogSp/6wqjnWt0JXZrx+K5JGxE6ELWCPINWMeKgTpez5G662xrDrH8sG/OI5jl/z3hGD5sPHIpWIcE2bKmQs00Ty9j+KO7s2caCMV+mJ+nVQGMH9+Ftd32UcJPeG6WxjwnC0sURRWmZW9uCu6pJfmPLuHUbu7hc8jgNGdVaOHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dTYrczBO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XVJp6440; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dTYrczBO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XVJp6440"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FI3fhB3902225
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T9t2E1tG+/yq96vLRIrCHKLd20qHLgPkf+0SwH6Uv5s=; b=dTYrczBOAQ74XM8C
	8cSZK0fVUOzmRm63L/+AdluXZf42ZyAOOmbHc6HWiTzpw+WvCveKJ1e3fWwDUQ/k
	8t4NueRakGpjunQoAEpyCS2y+/G8dmsRatJM7QwQqSRLjxjtONS5Ve1cTExm+29e
	1hYJ2N4Vx1VvVj9ZhSPGO4jKhVDcxUyhzSXyAjvzjHzHlUoZfPOfKVDIppCynokS
	2lf6k7o9ABxhHP/j9JLjlmswBrXii13QCQ+byDRx0h1WG+iADumu2gQEcgxKmhRD
	xeso0geZ+uppVtBLnDy3aq1GbLK8jog8x5i8NKTKI4fr6t77m+39Ig5JShfvWXDV
	gd37fg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3sesd6u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 01:07:31 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0d568830so11940377eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 18:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792112851; x=1792717651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9t2E1tG+/yq96vLRIrCHKLd20qHLgPkf+0SwH6Uv5s=;
        b=XVJp6440MdpURisv0z1UzopuZnRhzaz66bxBLWkU2cTZlPz6nu89ghtI69NCIn7ACv
         XcBK1MLIM+FIbwJ184oPMWj4yyYb/H75X4txHWogNeufumxdyMB3M6z0Ki076VzoeAl3
         WNP3hfSeoz6WdCN7hh5aG4f1y9HIBhMPawNZ7KP7TAfpx0VMdDghP5SULKyoXtEmDqKo
         ZMCZNdp7bN5NMKM8jlILDNcp5D86N2HK6zAzi9LzaUK+hAUXQduH8mCUcTMgAvT+L1yc
         MIufZgt0iDEYD8TmHOHUlJpLiua7mb/qTqVdoqyFnkoBuu1bZBb4/f1hjQ7BZnhwDXRv
         19tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792112851; x=1792717651;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9t2E1tG+/yq96vLRIrCHKLd20qHLgPkf+0SwH6Uv5s=;
        b=gum973wrnLRxKYRd3gd1V3czc1XkJjZbZY68BIMYq42wa5nRUY8/adg/MOmfGDeWzY
         XF+auC9ev53QvRYxbYVsYiDY9VcynsNiGyd1UKb/BJP++wm9JzSh3TfjUzas8f3gyCGI
         IPzfAxW94SxbxNpUWachfJ/H4CzsJQafq54wErN119zWuqOjmAgLV67IszqBmg0tvUuY
         iT/p6f+HxXdZrFU6CihJQzH1vPW+M5GvzTL8IlrzDBEvTWsqRu/A/Jkgd3Igs5nVdLMz
         N3y5LS4V6zl5RsLhqE1FFDZZ+Eke/b1MwHzCT4SDa65DxkEcUqXc4h3Ovr9D0De6Ekbk
         cE2g==
X-Gm-Message-State: AFq9FYKjFAGQ2u8oR9PR2/GG76AM3KXj7llscGr3z0oPXvM/EueUr5sM
	ILRtKqDoRGWuiHWIrQsMipxH2M1L+71LrnkjTcbb7jrdjQ3uZAAnudbc7QqsmimI+pkWgoGawmg
	hIc7dlGJeKODYaSczSDlBNfAq62L7CGei3yYkaF6OIEWWAwdmtgNX7X5imFA+mN6sMXjXUw==
X-Gm-Gg: AYBFou31sB3eGbgYtR3Ltq9U6hqCxVB2PmqAmlFvPljFmWM45YC04CvsCVIL7HT8sbI
	UgyOL5Q3bylBLYKRrphhNjol8/6sU/Xyw0OaLQKrG1KvKz9XGUqwmWJIphzgpaOlJW/28P9+9eq
	/b1MCriza8427q5Rj3Gn3TFw2wH8m9YZNxfLULG0isgp6NWNshEY6hzhO+hO8FvelO3ncTlZEQG
	4LYHSZpkX5LZgYtNuDu0+RVKGU7Rqd+PrIPqI9bM2LawxFzbEV3j3s9hkSBQqUjCu7d2AxtqIUx
	tqnO4nlY0b/At6FyIEEidvm8GsuwvcIe87dRSX4HPQylJI2ct5QOWGLkimNk7dIX8FY7rh1VRUj
	9brAu/pMiMkQAZreC8qtAt6Mgicna8N5xMVlbuAnXZYiQoEl5zh7l3MG+tw==
X-Received: by 2002:a05:693c:88c7:10b0:359:2729:1797 with SMTP id 5a478bee46e88-35927292f58mr21499970eec.30.1792112850714;
        Thu, 15 Oct 2026 18:07:30 -0700 (PDT)
X-Received: by 2002:a05:693c:88c7:10b0:359:2729:1797 with SMTP id 5a478bee46e88-35927292f58mr21499932eec.30.1792112850011;
        Thu, 15 Oct 2026 18:07:30 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3607ee0e5e6sm1618856eec.1.2026.10.15.18.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 18:07:28 -0700 (PDT)
Message-ID: <ceaf2db8-3796-40c2-830e-998af8c88b0f@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 18:07:27 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: yR9PhbuHj8jCeNsVPo66rEup6OVHNVkv
X-Proofpoint-GUID: yR9PhbuHj8jCeNsVPo66rEup6OVHNVkv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAwNCBTYWx0ZWRfXxIyXWoxBIj5d
 RnwlGYE6ca7bA3RqFmxtGLTe8k6GtQlJHdJyplp67/RN4jdoOUVbUb5vvdUXz6UlMs5zDvYMwpY
 Qn4AwzcvXH56iNKMUAkLe8FyP8R7flw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAwNCBTYWx0ZWRfX3YC/09eth1sI
 uzBmSMnxlbGleWDVK6pAy9lihAMfKPR79RWuLDQBYDn9Seqy1VVGu/cdPbyeizql+O2rjvD1EiW
 mhqfaEez7mSK0pYK5R5WGo1J3zSOyEBZ/TJlLSxMYzThHHOwOy3cCGAsBKEfsHFkIO7LNe35jXp
 XDZJBjL9YEUjUEHo0Z7IDUPFrzqnAptCwmEXy6Vr4wqX8e3dbJPtEr0zn5Z9nFX7jyFBV6QzSwG
 PVzORvoo2fabtlQ0rMFeT5OtphK9Ul+w8PbQbi75dUjkNpfmCByOqtdXUd0X2fLRYESgW0q6LEL
 dQXgXCqbu5RJ9Di8nXbYOkPOiW0JfypJi+TMVSjRsBdHyBObEIMdx9JpbNR3vC/3vSkyRXv9bdq
 2b+rom7TQgSizU4a9Jb9lraDgAf+G9BRazWytYI2PGPp8Y3gGJEKsIphBHcuc1PSqmIDR1oo3dI
 7u6RBECv3839D3GNMyA==
X-Authority-Analysis: v=2.4 cv=Se1i5fRu c=1 sm=1 tr=0 ts=6ad178d3 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=5Td3zqSP5pV7lwFrebEA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160004

On 9/25/2026 5:26 AM, Kang Yang wrote:
> @@ -8175,6 +8175,9 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
>  		atomic_set(&ar->fail_cont_count, 0);
>  		atomic_set(&ar->pending_recovery, 0);
>  
> +		/* Stop the self-rearming monitor after recovery succeeds. */
> +		cancel_delayed_work(&ar->recovery_check_work);

My review agent thinks this should be cancel_delayed_work_sync():
Confirmed safe: ath10k_core_recovery_check_work() never acquires conf_mutex
(neither does ath10k_core_enter_wedged()), so calling
cancel_delayed_work_sync() from inside ath10k_reconfig_complete() which holds
conf_mutex cannot deadlock.

The real problem with the non-_sync variant: if the work is currently running
when cancel_delayed_work() is called (which returns 0 and does nothing), the
work may call queue_delayed_work() to re-arm itself before checking
pending_recovery == 0. That re-arm succeeds and the work fires again
unnecessarily. cancel_delayed_work_sync() waits for the running instance to
finish and prevents the spurious re-arm.

> +
>  		if (ar->hw_params.hw_restart_disconnect) {
>  			list_for_each_entry(arvif, &ar->arvifs, list) {
>  				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
> 

