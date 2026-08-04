Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B530044DB64
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785850750; cv=none; b=SJGEQpcUJC+KQmpbVmhCCayZMpHuOMiI+bLzm6634EwcDmRxBqIflMhLOSXkgM366I+jmKH4S3ok7TeI9NtJm8l85l954FT28nHXHJG420Ny1gxlA9l2nyBQtDvug2yxBzIUYQTqixNO0xtbONUf87riiQBO9F1KQaseTl2jCzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785850750; c=relaxed/simple;
	bh=cOJTG9i+F6HtP5qSWZBA5GjfZd7j9VlEUqegJKtlBHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KD4Poahj5yX81DfVv/NxcodJ38rNp6PzeImDdfHXOYhmG6x/at9Qf5IMirD3oiFhzr7esFRJBz9fPlIpcpKMPlY5ljeY+M2hzVnMgen6VIOzO3P53gvMB3nHPAYXoTRpjb6WyyT8Rehi/nUTTKPFeMGDwfTKRF8PRqgb8C1NHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l7OUwkHW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ptbzlqyg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l7OUwkHW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ptbzlqyg"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674D31Fk4031621
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 13:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4TEUaNygmrzB3gnLFKtfo+gR0lnPviX93uRsL3l/7NY=; b=l7OUwkHW5zS7f5U1
	501NKk929p1przJNyLJtNTV2V90NIPfHXfYlwMvTNauk4GuRAz5G2BhtiTH4Wr8J
	PM0cL/ygD5UN3rix6ozFRMlRS1J24FG0HHQsa/XwaC9P1pHX2cM4F/CGMK0axDO0
	pMKywFZvI2v4j205y0yLv9WH+e2mX1jz0/v59LM9aGzW/dbnrc1NbtNv7EuaeGJD
	zGlgw3GvprU7Mn5VNo3ECuFJhjxAwPPlKzYqoYnVDJdd4R8KyInQPyMb4JRA9D54
	3i5pD7q+Ei67GCpfmI8tX62j4KRjWwqQJDtE4hkFQx06ktyPBFUDFjo8AIDkDEL7
	7cOF7w==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fugmg0580-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 13:39:07 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-668095be86aso2580172d50.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 06:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785850747; x=1786455547; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4TEUaNygmrzB3gnLFKtfo+gR0lnPviX93uRsL3l/7NY=;
        b=PtbzlqygUJ9W4NiLMKW24XVUIPXVWMIaPeHMvvv9oGE9M5cZL5Cqv67r0SH1pDwXa/
         x7rDV+FIo0joNtlqmZ5s6fVXifGK33UEFRcr8kVfMl1+YnApzHEXicCx6GKWtcxxndge
         b/DmBrGG/YHwUTvKX6eBQcub/9B/5FLLEBLgzGf2SuMoHc3UQWb08CosXlSwPb9ox2ii
         p/UYGQhpyI1AyJAzvkWEm0ZWsCPieL/LeXo4fC5mM3gobEHJT+lxkB/swksREbi1Iuw8
         pINLMSTrSlLpH5f+mlpYNWPmRzDY39fBaTHesipdndRzIVLzhjEpamBZ+2HumROKDcUh
         g6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785850747; x=1786455547;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4TEUaNygmrzB3gnLFKtfo+gR0lnPviX93uRsL3l/7NY=;
        b=AHZFDy9QQ+GJTMD02Ql6mXdqMDexn94yLl6Y0uRsoPswJ4r0VLlXqLBSYCmcHch/9P
         sSHkYb3UBDu8JGKn1TrKYpu4rOhXIWXp03T0n7KdMiMZmc68QBQb/PAMJEHDZcJIO/2C
         q8OzO6AthwZOUfkkOsG/8LvwXkAfhLdEDUyauLCPehiX65e57UNXWJj5VSjN2hrBw23v
         RASZjD3tO9Xfr7rzTsrRDQcf7xd8iPRmwxMnOTzRKSwPgZ87lbq3Naweb6aJnNIk9yr4
         IoT2WU5TTn72VBs9sPpTAqmZGzjcok6FbmqlDXnt8OJaCWiz6OwDTD0IJ/HMbtnXHtue
         sCcA==
X-Forwarded-Encrypted: i=1; AHgh+RoPP188g32qqHUYbBRvsN0EZbb90igdkZYPOKHwGe/KbP43hUESHpfvFGDFfbBNi9fxwpjPHmguJ0rZ2pLSiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlaVZFP1p+sHHCtF2wOPJPTu4iGLWwH9Zo8P0gd1dcWNPZLalh
	LMQlbKc7LzuOxlEmnPYSQi0xel9O0RwywGfmRNzzK8Y4/xASjMVy0AJy31ZeaDFwEY7+KuuCgGO
	ivrgcqb8ulZPqIZWxd/iVBWRP4S9LdfbsX+DiA+VlQ9M5c4MVbLXL73VNHE160GECpR2yiw==
X-Gm-Gg: AR+sD12rI5iCX4LG08xoC0dIUcZK0XZBSjOjXCCOf4bNT19CHPwzqVzszg5Cx5Z4+bY
	gWNpS4l7Z/uReuseKmxh5n1k3U39XdZCc+HLk5yL59O/Bx2W7YQPXNHa4xmrUW9UrfJ6OO9opQU
	qOm3ND5On+1+CVMis4lt8Aiz1rw7/192gZnRz02fyvye1mXYpTuQKm/Oplma9EcDsLAIjk4XO5t
	yOW1R8faSSalapXg5t2DGOqvIRD1kXKhYdZAUMOCIpb+233agptl0AZpbviQTwfnFwO2WmxWv8z
	5rPcsaS+JNikcJUikljLJOnFIbKY9YDGG9vOQlBn8kCu5sjQc+LS18SVixR21dHMDQ0VPYdVx3D
	+xP6VfFhLW1Cjz6CQK3rqh0yrBb5+PFzZmDl3ymKSjw1YsQc+PwOlOg6LF0K9
X-Received: by 2002:a05:690e:4384:b0:668:2c1a:6fbd with SMTP id 956f58d0204a3-6694f1c878dmr12930270d50.41.1785850746984;
        Tue, 04 Aug 2026 06:39:06 -0700 (PDT)
X-Received: by 2002:a05:690e:4384:b0:668:2c1a:6fbd with SMTP id 956f58d0204a3-6694f1c878dmr12930218d50.41.1785850746370;
        Tue, 04 Aug 2026 06:39:06 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6699166c401sm654327d50.18.2026.08.04.06.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 06:39:05 -0700 (PDT)
Message-ID: <ed0a7291-22cc-47ec-8385-04920978eb32@oss.qualcomm.com>
Date: Tue, 4 Aug 2026 06:39:04 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 2/8] wifi: mac80211: change public RX API
 to use link stations
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
References: <20260803123004.281626-10-benjamin@sipsolutions.net>
 <20260803143004.a2323a28062d.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260803143004.a2323a28062d.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDEwOSBTYWx0ZWRfX2BqaQoK3Xwzj
 CSsE/st8Y5fVqRr0HKd6bh2tSb0h/VCiUIqF06R02aIWNiDEKMbpUyiK9k8ZSrivEe0jdBAMbtO
 cg9+KN+im2GmXIdYWb9OamBUAjcIu3Y=
X-Authority-Analysis: v=2.4 cv=F89nsKhN c=1 sm=1 tr=0 ts=6a71eb7b cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=QyXUC8HyAAAA:8 a=zDbWswdZDz-AK0Q_o1QA:9 a=QEXdDO2ut3YA:10
 a=uujmmnXaIg8lM0-o0HFK:22
X-Proofpoint-GUID: K04WM4Wf-UOuKLUb_qMhhXqmaNvsD3re
X-Proofpoint-ORIG-GUID: K04WM4Wf-UOuKLUb_qMhhXqmaNvsD3re
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDEwOSBTYWx0ZWRfX9FzwZYgQhXoF
 z4rF8DEjJTZtEUajlA9P4sLtRnQNtB7/1+ipN5hT60yy3Pzga8Uy0Ilimgr2Ey7QGFXS6bf0Ssy
 raStSK9by99AyMbD7V7cZLCfznkUlVdqqrZnMWNhTEOk8h7uevt+9uUFcN6UmJYXp13GH/YVaun
 zqOzndK5EaEFAbJBLdHF/xKLQkJ8fXNOyh4f1A4vtTFVXm1z2VD3O++BWPIg6D5sCESL78W3ZZL
 bbd2eh9eK2mIbTyPp6n/9Z9zNd/y02ry+7hEnL/A9Yv2z+0OJirdo8B7mT2MbJKOFTjst3ZZS2y
 /GHCxoMwLhD7A+d663IRPRDiJPg9AjwTEK5xgWnm29rOMgOAqOVWSlEujXxjS4QO1mkQvZF37QV
 D9egWp/LcDUAk4NwJ+30JjMIlgcmA7AK9vgPg+TKOPXvq/n+BPqVT2jKEtd0gZwOaHUqR1BgDI6
 MQ+t9HsICjPwCoSzMGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040109

On 8/3/2026 5:30 AM, Benjamin Berg wrote:
> From: Benjamin Berg <benjamin.berg@intel.com>
> 
> If a station is passed then the link ID also needs to be known. As such,
> it is a more natural API to simply pass the link station directly rather
> than pushing the link information into the RX status.
> 
> Furthermore, having the link ID in the RX status is not actually correct
> because the link IDs are VIF specific and there may be multiple VIFs. In
> the case of a station this relationship is clear, but then one may as
> well use the link station.
> 
> This patch only changes the API and emulates the old (incorrect)
> behaviour for now. The mac80211 RX code will be updated in later
> patches.
> 
> Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
> 
> ---
> 
> v2:
>  * Remove now unused variable in rtw89
> 
> v1:
>  * Do not dereference NULL station
> ---
>  drivers/net/wireless/ath/ath11k/dp_rx.c       |  2 +-
>  drivers/net/wireless/ath/ath12k/dp_mon.c      |  2 --
>  drivers/net/wireless/ath/ath12k/dp_rx.c       | 20 +++++++++++++----
>  drivers/net/wireless/ath/ath12k/hw.h          | 20 +++++++++--------
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 20 ++++++++---------
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h | 12 +++++-----
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c    |  6 ++---
>  drivers/net/wireless/ath/ath12k/wmi.c         |  6 -----
>  drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  7 +-----
>  drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |  2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  6 ++---
>  drivers/net/wireless/mediatek/mt76/mac80211.c | 22 +++++++++++--------
>  drivers/net/wireless/realtek/rtw89/core.c     |  7 ------
>  .../wireless/virtual/mac80211_hwsim_main.c    |  3 ---
>  include/net/mac80211.h                        | 16 ++++++++++----
>  net/mac80211/rx.c                             | 20 ++++++++++++-----
>  16 files changed, 91 insertions(+), 80 deletions(-)

btw please use get_maintainer.pl to get a list of all of the affected driver
maintainers and mailing lists and add them as recipients of the next version.

/jeff


