Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B296537F738
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643726; cv=none; b=N/SGuhGgOYaoxZHABHDvDK4jbk/RD8zDDM3zNbnpFLGaveLhgl2iZAT0mN5ma8ONWamIIAcihjonX5l5NbNaOa6lteCH7PjObZs3cIaOnng8kCzO1lQVTvRsh9y/wKoZm8Vn5xnOGq7IWcMSaO3Rj/hz6Az5uQgj5quJVGrSaoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643726; c=relaxed/simple;
	bh=usUxW6MjATyEbGVpjuCjv6xir1cAW4UXdSpBftLGbL4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=l4XEglPYqkTwlezXNnMhKazTj0bKHao0kWJ6yUiDJ3LB/1Z+9RlwEQEoaCCs1m3Vh4NXs45FOulwb8MhLE2r3GZSY4OUDQ0YJomW3JZLJgdEV0ueCzN+rGhYb+k1lRt+cypemOAOhP8w0g4lBjTUAreJ+VOa+MZgIY6cEj0kAMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OyRdPm+y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EDlKVnay; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OyRdPm+y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EDlKVnay"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ACV2pN606180
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hcsVVrQTy9+oPzMIs3wmnifLrbzfhME2W7FHzOhUhMw=; b=OyRdPm+y16ElOoNT
	YxVLDNn0CxeULMGVfzgONvVKk2MwRS1h18xKrUH9dQ7FkhnM90G+7fJShgMNDFuV
	inbFcytPbprA+Wzo5ZtG6NqoVz+B2SCq4wNk8aSirz7Kox15AJE9UtYMiwYTpMLo
	MwE2qae9kHPUp0BxnzcDIJ0A8uGyABTXdDC3BmSYuahtoWB/4nxjkhJvTlYhYQvv
	04LOayrENCzXSNvn/MX4uEPbZolfZXKLxWD0LYeAjxkq8XyqmoveUaAIEaFBl6GA
	7YQ95QF5WMpEEMmHbqh02du0EVKN242IteSvkVXu/1hT3BdVtshltHkvaWlYqMgT
	5B8Mcg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7deuh73p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:48:44 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34e676375d9so794272eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 07:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791643723; x=1792248523; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hcsVVrQTy9+oPzMIs3wmnifLrbzfhME2W7FHzOhUhMw=;
        b=EDlKVnayTOAwRj67tWH+JixUE4Z52uiY2wT8d9YmodNkHr7U0KZBbVHgUTwS/O9Tke
         qzeXwfujzhw4Gx9swFg7xgzLQptUncOlp9HFWMQXOGxv104V6QcWxJ8wefBrRUH1DceW
         Vbki77NeMNsyA3IR9SKcsh+50tFT4sb88hMASXOJo//z54ivV9aLj8vustldCJ7dHadW
         2zCZs6in9bpxQasEi4h/yl/lw1woZbCwADUNmQzRqOHww+rgSrTQyImVxrM7ED2dBvag
         F5Gbn/uvu7ShoR5PzV/gLYvcArw775s80rQetgrEpiWgfxShpVcEytYKySe+2nXeuv/7
         eTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791643723; x=1792248523;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hcsVVrQTy9+oPzMIs3wmnifLrbzfhME2W7FHzOhUhMw=;
        b=Re+PalOeCdIE85YiWfD7yXOLZXWmmRo5loWG/ghN0UN9dcLlQaAQmqsi4XF+BxsP6/
         nYMpCER/lvuegEAEvAoYT+7FRDs8Sse8tmGDxU1XAz5e8y1H/g8Rad59TQAAfQU5IYAX
         KqcL4SnfJE11mflWe2feiPStrGQx02s0Rs90i3KKRcclfmOmdQ4hlLBvZbbazvcWOK/A
         aqRfEfY0PacWR1Rbhc9SsUr21af1lFRIMcuHSrIKPj+Y9KOOXzwU7eGxIhiyQ8SlFAYV
         dBkp2xOFQxrz0q1r+idkCADav9Etk3D4rXT1SHOEBGSoupoLsUN5LqsjDRo1D8tDAp1y
         O+mQ==
X-Gm-Message-State: AFq9FYL/3qFaLITKjkgUKuyKOR7HqFWcu7+N5iRWcTP43jrkDUY+XaUd
	UBGZruq/5EtE2nSwQmB4yT0ZngWLqpudSGts/r12iiwWnC7y1NzRCEWWWFNNJTu6gwHi+ieyKQ4
	kN8wHftyj4LgmZb1Wpht9buj610UQmY/Ym8lXz6t0wy6wXj1rrkg8FpMgHk3rRYPSqcJFTQ==
X-Gm-Gg: AYBFou1k4PHH4Qvt0aTSbFhWBfQcwBlomyZ5SaQfry3Ejte3zmcp7tGG5dKCKMrxwqe
	bmCbR/24qSzmqqBJ1JGW6h48cY2o/sWlamW3XFRFwLGYz1fdgd1B9md3igYuJKsD2cu+chAHEfR
	cSb1o2yiPC8KvRfnOkp6LvmNvetNubP/AIL5bMJnwxGINDkBGKQZdcaeNsW4Sc2dbsXwggY/w3/
	zG8PK/w1eKPk8F/yY02AQFn8ns4souYa5oCCJhOEoaGRK4kwGR4O0xQxO4c8Uv1EnwG7OkSdwi/
	yjedzn+V1EYjYHH69ve9rz3exxvnWrAtWB5ecxsPpGEZm+4XQWO8xyBS2BZBwuMECLuLWaQFFes
	QzH79hhNi4Q6kih8qOIUXYgWXumLxT/dU+/hqcuah094xz3NjVh7q7Q==
X-Received: by 2002:a05:693c:821a:b0:357:ee3a:267a with SMTP id 5a478bee46e88-357ee3a2dd9mr3597879eec.2.1791643723177;
        Sat, 10 Oct 2026 07:48:43 -0700 (PDT)
X-Received: by 2002:a05:693c:821a:b0:357:ee3a:267a with SMTP id 5a478bee46e88-357ee3a2dd9mr3597828eec.2.1791643722385;
        Sat, 10 Oct 2026 07:48:42 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca7133asm19713287eec.14.2026.10.10.07.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 07:48:41 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
In-Reply-To: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Configure RXDMA buffer ring
 size per memory profile
Message-Id: <179164372163.2359474.12323997868750930117.b4-ty@oss.qualcomm.com>
Date: Sat, 10 Oct 2026 07:48:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: 4016vjTbGogOBdYXGxxMMgPTuLXbV7ro
X-Authority-Analysis: v=2.4 cv=Aud7T+9P c=1 sm=1 tr=0 ts=6aca504c cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=O8DM5gnZE03VXxh4g-wA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEwMDA1OCBTYWx0ZWRfX2fuyQaulwdwj
 wlPtGW3H9ulx/NQRLYAKee0ysMJZQ4YPb5wPm16IJFco5Sol/rW34GxEudym71aRjPcwdb1o21P
 y4ggiIFCj5ftfSrHPrfwVa1dnDhoZHw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEwMDA1OCBTYWx0ZWRfX5zUK67+24g86
 UnM6b0Ai6YOLEep2RUH3SJlXor4/9VgB2DLyc348/w2bBGewM745LxOkiV8w8sMvtWHkQM88ymp
 mCezCRVkuTpUZrbnqVLhvuWmZuzxBNtc6CewMRBUnbblPH9qFiBaXJP+e57eqGnurhLx+510XG8
 mSGvT9o7+Mzbzl/k8IaBmAK/8Sb0+HsWaqEiQJjg93MuZ8fBQxbA0SlXkuEaj0nyl8eEw6WDzDp
 eLG0TnpR74V7pmGN1fyeUXGGHHp7pWCNfLiCXOutyxF9XnWOVw1sefyA6xCpmEdz0MUtd+r9U6H
 YznUQ0pCbfUQiUTtvrAGsbfqTzXDA332lbR74ka/pTe5VbNuqRSn0O378HefkO/cMlB25zJlqog
 1x/BHQvYgf3CF8+5Il3IFA+5GiUBOb8OVwedoY6wlv9nk//SWqD9lzes27dJYviMC6ezRpwJl1s
 xs7bza1LrgCoti5mmIA==
X-Proofpoint-ORIG-GUID: 4016vjTbGogOBdYXGxxMMgPTuLXbV7ro
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-10_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610100058


On Wed, 07 Oct 2026 14:53:31 +0530, Aaradhana Sahu wrote:
> The RXDMA buffer ring size is currently hardcoded and shared across all
> memory profiles. This makes it difficult to tune the ring size based on
> the requirements of individual profiles.
> 
> This series first makes the RXDMA buffer ring size configurable through
> the memory profile configuration and then increases the ring size for
> the default profile to improve RX traffic handling.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile
      commit: 643f0bf936176c114d5631da7547e991b5d99f10
[2/2] wifi: ath12k: Increase RXDMA buffer ring size for default memory profile
      commit: 15f7603b69a83a0acc7fcc8992ecbea6110f9424

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

