Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34092417D1
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785288876; cv=none; b=qkJkJbhW7kDrJzOiTPssJKbaUOoagmKxKCYn5D9VSmyC9efP1kaqoSloaCZQZZE6DUJKBZMCEpFmt685VSld1FDeSFVGnnQn22fkZuHRdC/YsIOaT1JeiPaN+NwG3LPCOn/04FMRMwC0U9qtID6DNmkUql6bSRXnbOF6sngPZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785288876; c=relaxed/simple;
	bh=IG22AMtOsd+toEMBXVJfonpHxEYLLh4nWlzmObC7/Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=op3IAnMODC2VnxXqgpZx1bvPcqe98ayr/vOLIhuV4sERyye2PuyOUAttv0yd8PJbPBqmRetNP6kh53ggG1b4mrxFtJP5MvNkUmi3oXE+1FCs3HSbLLm4OW9kC/0aMBxT7eTJYnyv9vw48gW2avD4WuhLb6AsXx3gJ9O5eRJbhQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MbvQLYtq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fKs9wtHa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MbvQLYtq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fKs9wtHa"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T1HQjM449940
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IG22AMtOsd+toEMBXVJfonpHxEYLLh4nWlzmObC7/Vs=; b=MbvQLYtqBHSnrIm8
	s9Q6/13nfsjMDkl3Mv0QwU5L0Qa/snZvLwgsUVRHxarozK0DuuJybofEOZJfJGJC
	c9BFUXkiaMnkqucPCRMZ9xoqFoeiGZghL1nptvG3sh6XjkiMwWrLlrbeztmvloS1
	DsKcKgHncbJ5/+saRl6cNQxgZKmnNjLCeBhw/xhZYV+TuOvK+OtV/r4HEzD65xTl
	6P8d56muzn3BWPLS9ZU4xYZ0UfzfWdemb+xRS0z+Skoserm5mGEEsn9iVs5pFnXT
	TAx9D3gMImxC5U45MlMZAp11Bktj8agPvqWUS9WS5EfZjA3Mu37oPMvOuvJHtaxB
	yQaYpg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpvtvb6yd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:34:33 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so8836745ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785288873; x=1785893673; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IG22AMtOsd+toEMBXVJfonpHxEYLLh4nWlzmObC7/Vs=;
        b=fKs9wtHadOKX/y3insdA8Yponr3krlBuKD6VreRTCYSz4FQTL13KUbqiLFCUHOSHaC
         i6x5pPC/AOnCjDN135X6W80DQKeARJa4i7HsYBU+C63mgzVpIJ/B2kfNi9Vj/Qx+SIuf
         wwvz4Qb6eLdaZjt2rxenwdZdyPYj7HBWMhopBFUeHAh41JzRYeXbBPlo+0put278J7Ua
         kb+AvQtXsSDHg4Puh/05IlQ5leKdIKB+twrtzQS+D5BqUHuYb4wyVQIWvrsjuXxxK/AW
         Hz2mOrpHM1NydawSaLDublF7POWIIhLR/w/OgjOlf00Cq7xJo2zgeSfBeMwbsOLsIffS
         Pyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785288873; x=1785893673;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IG22AMtOsd+toEMBXVJfonpHxEYLLh4nWlzmObC7/Vs=;
        b=C4/TAoRWFXJnB9sYCInTtNtqTfEFd8AY9pydSZYSVpMhB2E/vnax8ft4Td8zMWc1Qe
         xahOhz0JVIma/kj0lW8vLsMoHFtbnACwzJtYrinq5IQOHKCvYd35xbF1QaeQEStEViRp
         cByAELKFaRagGiidN4JPTYh+Q8HEnlBEpcYtSNozqG8aMPGm8AKywZdrdzBvpsf0T9XC
         VNXW8oyCbhhYEdYABkLd2iW9dOLvVcb6BQOnu1capv8jz4Pcdk+TfGTbz1P6btEe7gAw
         k9JL7dy175d3CSvV9SSnUJ1+xKrTKyoKQkpXXixJck/GZ4NCQ8b8Yh8cN8dM9ym5Eye0
         IqOw==
X-Forwarded-Encrypted: i=1; AHgh+RpD2Wo+LUG/KcYWUU33fopJPnpZNtNo5PSVECroxy8dbCcC0uagiHWuLsRfGDK82BzlCTaPEqjPpKD+Uyr1Rg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOktgHvVbGjcfSV7NDURbUQlqZeCZfe6SN46M9UC/R/dr9LfB9
	KJvsl8l6DCMHmhV0U34F909pLD/wVMAOHLcGyon+HTP4uZaYGfbzxqXid7rrbXD7oSHIMo0S0uu
	sIzihI9U+dEu7Oj2OXGJJxzYhjXpKISuIC/c6Ry3r7KytKqysziPtEvO2HKySFyOcZRJLTQ==
X-Gm-Gg: AR+sD12SunF0ZK46pT5guqSUu/VuRNnhFkImmHJnTsOTe3Mq3Lug6wVFHWO1HFY6COl
	tA0YYpEqlq/9KOy+wLKXTmWat1sOUNzaMmSzmPV2aly3zb+HSK1tyxl7JF9DjnJNB+DZ5mBKcG5
	DG1GJ0ZOZTl1qsIgc9AoJTzRL6GX1+R8OSTJCV6yPULzKUTlQrQ31Q1dBIy+Xbm8NpXMZp5ixzo
	LfvJ07gVrjTAKi0oVvfa80LQQ6JzFAQjMapmDAXY80piQGBUANwhvT7nEOgaIipsbk+bDqnBzjl
	U4vifdmKIgueL5rvywhKfbeqCMTbp3+3DOt1gOnjhfv7EWFLYzuhlHUzDBAhceYHzAaorGbwoBQ
	98k/9VOWxyTgXqMaXaY+oqu/8saGth7fH9yGgip5MoNfD0L4GyMtbHx0hlA==
X-Received: by 2002:a17:903:948:b0:2cf:30a9:93fb with SMTP id d9443c01a7336-2d015f0d047mr57703825ad.34.1785288872857;
        Tue, 28 Jul 2026 18:34:32 -0700 (PDT)
X-Received: by 2002:a17:903:948:b0:2cf:30a9:93fb with SMTP id d9443c01a7336-2d015f0d047mr57703605ad.34.1785288872425;
        Tue, 28 Jul 2026 18:34:32 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504927a7bsm3987244eec.0.2026.07.28.18.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 18:34:31 -0700 (PDT)
Message-ID: <64aaccd3-7a96-48b6-9cdc-fede692351a5@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 18:34:30 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: cfg80211: add fw_version device
 attribute for sysfs
To: Rory Little <roryl@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20260728234726.27479-1-roryl@candelatech.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260728234726.27479-1-roryl@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: H1gT0FxZ9inPayqHbv_asCnQAQ7oRU2r
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAwOSBTYWx0ZWRfX7n5wuNnyvi9X
 m/12RMIhl2nGosqzz+pVFmrT9qGgVx+5Key2HkL7a+YF9YbKSv475k67yYVv5O0c8wIfCtrAJFh
 CpK2FvWaVixkZbbQlmCECbs7Us4vBKY=
X-Proofpoint-ORIG-GUID: H1gT0FxZ9inPayqHbv_asCnQAQ7oRU2r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAwOSBTYWx0ZWRfXyxPeTnGzkJ4K
 crDpy62oy20KLozqKKNoL7NP7oJyIZwkEGQ0bt+5v7mASa7Y8st316bQ/QUUAVemrkUV/lOMYoC
 ACNx+X0f5/s0ubhcHtAghf6bYWn+a7V2EINMju6Ae+5MlgAlM45ysEPA4Nwjd8kWe6Y0BgrNq0+
 BY1BaCuW0rp6cMOQEaswT3KRpJwfW4XdLkozdI4hps07Axt1s4UPhd2KSIjxAmd2yAOuZu74C04
 kP+Mh9cz+tHwUERks3h1KhswnBzhcbYPGtnoOULSjR63o2tFCP5SzEHy8uAOGBAxwAgy4S4q4En
 hapaTpNIwV8CNsqXISnUpUyZY2NT0YIKCeHgtOTjLBd2sdNm6+Ll1U3kk0A4H6IYcgUm7YFAK8F
 kRFZSzIGORtUwnHmqlCPOh42tHoRii+/ER6UX3lri+4ThYvs5kWoBc6N7KsdD2qzeWW4oXnQ1XF
 UjsLhcZOjwwsHKF8YPA==
X-Authority-Analysis: v=2.4 cv=dOiWXuZb c=1 sm=1 tr=0 ts=6a6958a9 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=LeIbUFY7_gzg2P0AWrUA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290009

On 7/28/2026 4:47 PM, Rory Little wrote:
> The firmware version is already exposed via ethtool, but is not
> accessible without an attached interface to create a netdev. Expose this
> info in sysfs to allow users to query it without the use of ethtool.

Curious what is the value?

It looks like many drivers, including ath11k and ath12k, do not populate this.

And this attribute is pointless for Wi-Fi 7 drivers supporting MLO with
multiple underlying hardware running different firmware images. I suspect
there are a few wiphy attributes that have this issue.

You'd need to instantiate these attribute on a per-radio basis to properly
handle the new multi-radio wiphy model.

/jeff
