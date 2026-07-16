Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C495F3D3499
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 10:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199127; cv=none; b=kQT03UqK2BfFfVSd93X708uIcCIcXUtRwDIttPlxKCVqwqdodqMrdDoip19BJxrqHGKAsUGxjWKp9xsrlSRqUvrvJo4+NXcBcj59WUxLRLcmapmj80WhofVGAiaPGgrlLP95fQq6tXQcFbdXpd1faoTaJewp1KifgWDew83XJAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199127; c=relaxed/simple;
	bh=8EVomWdRzQxdLI1/funQaiZSICadkQ3axLPAftbgqgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIZYrRE00K7QP9j10Pf0qlGT+bFJdSEg53PP6nL6/VTNyOZGmZ5NnUuSGNJstoeQEUyaiZ6U5GsLT7jRvnmj3wZefF2zgUkNRsoJO1zZ6tJfucCsIJvANwREhbrq+MFNyZZcCLxLv68VMUAxOVQVjyxLmcI9FaeM+Bh9mCpNgr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CEzffjhj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FJfDqoQL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CEzffjhj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FJfDqoQL"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G9rFGY3489521
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 10:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/haUbnenaAfpccw+mnz2xLOMOiS2FiSNt2s1aPzvdeI=; b=CEzffjhj05ugwIyI
	rWimrVSSDp42vFQLCxaTBswxGwexNX5v7YpxF1h0RJF+OIj9QC9xqgzDXWmSZHON
	Yf8UKG0qa6yBjvI8WjvYOH+WD1ESYoaIeuSEwBSfQwvTIY7dW+5halsBCx9mGkUL
	NsndQ9f827Kr8M9kqvzQwXm1qCSN6nKQjHBrnvXlZs5AbuDeEmLtEA7ZoWJ0fpc3
	hF4BIJx/tS4yUz3OPI02ExfZ55O8wFhseXlK5NCiVAyUK0ZC0zDi7KL2wiBAdTn9
	VtWTW3eFcjqW1DdyKvjNGZJgrG6C5FYF2GyGArD5hATUXfsButLZ7GQige5hHfQK
	Reo5sw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feq3phpbk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 10:52:03 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c890bac374eso16065640a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 03:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784199123; x=1784803923; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/haUbnenaAfpccw+mnz2xLOMOiS2FiSNt2s1aPzvdeI=;
        b=FJfDqoQL56jrsZaUb+C7EZfU0l/CFrf7BZAmq+uQaOkQmFrlKbeEIrgwW7irIs3xqj
         frjURqL3ED3p+Urz3ME03ZZE9mcT3nZTxGbjEyu/1yf5C2yZxn/iOqhijD2AJZO1Rymy
         ez+eNIkeuL/S1aR+3qsF+qIJ4RFzjTPjKXC8+fHDDM8g8zna9j81suGYs6CtrZV3vw2L
         ZKMk/ZY+0iYGVIwbM3enLvCEQTc4J7FLDkk00GAJaf8xTd41TDpnXyxIyH/XYek6ju+u
         d2uA1c/Kvks1pscWjBqBzjcbvZJYOXVZGBmjHXNZTARrmMYY70MFkZK4XgcTuLx9bwRp
         mMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784199123; x=1784803923;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/haUbnenaAfpccw+mnz2xLOMOiS2FiSNt2s1aPzvdeI=;
        b=rQ6dzfgfePr8t3BtJ10/FUXx8prklXs1ejw8EW4wZHf2YkTmw5vaquXaFO6iCLOEZp
         PUvF4sZr+aAGJSqrxyFZv4K/gCAMyTzWhDqBnYBFHnIYJsXuBmdIoCWCeohMqKfZEOtN
         rOhAGlOyYWwY3izRSUb1Il/U0rAkuew5CxJUrQJSlVC4TAu7bsvd0YtIoV007QBDmBjm
         IH7r8bQPtDD9VkULJrI3xJLa5hR62c5QtDF5zEv9Lf2+ov/hKEs2frCBS4bwL9vhx6pD
         0syV5E4fEgNo1X6mTejlRa6wHi9Ld0ryyiQndkPExyRhE1JxgauigbboIxIYjGr7TPPO
         Ojjw==
X-Gm-Message-State: AOJu0YwvJEuYu1KIefLmKFxE2ucuou//iSVQAhqBmolPtUD1BuztPkuk
	iQd6xl7sZQpiT2n7SkVSECfAX2ELMOfIzs8jphay1QyTYepnjvI5YP3XwrMk5e3asrQvUEVIIPI
	XkwuUl/Q+WZe645bPwbKyvKQNlbEekgMZR+6pRpDL++Q5UxMi9kthpCtPXtrE64EqfAFjabXNxN
	pSFw==
X-Gm-Gg: AfdE7cnpyj6rfMvA6zz64HBmFUz9qHHtIn4YWMtJwxG3c5tN3soPO3sHY9ysqpqWPr9
	K8ffhDiFFTj5sbGMnjHK905j0OGBPhbzx05/8xZn6CBOh5ybn2I2Cr8C3+0/hDGGVs5+qcta+Zj
	H6zO3Yj27MyMdKE8tXvdxEL9rE0sNGUK1+D+MeMyBtSWBXCv+tTKz0zhAvUDSMqH0sXz+xFOHf8
	EOEJPp8oM/pURiKrvP4mwmNtWsj67KCiZK4e6Vx6mzwurjcRxTaLKVhYI4rabXfZBJ1x6eAYaoO
	Aknq3CVFcsMNH1zZ0y5b1MnVCj0hjuM4rGnmoOeg1bh7XaaeO8NGnvFvXJeBu4LDwokDGxyPMFg
	+2Tjw7EM1qYk5Iq6rJcxChh5ipzlzEMEceaJ5bJCvOjgz5f62yKJh41FPl2mMYEMBHxyADmd4
X-Received: by 2002:a17:90b:2787:b0:387:df8f:1408 with SMTP id 98e67ed59e1d1-38e2a107e1dmr5587306a91.41.1784199122604;
        Thu, 16 Jul 2026 03:52:02 -0700 (PDT)
X-Received: by 2002:a17:90b:2787:b0:387:df8f:1408 with SMTP id 98e67ed59e1d1-38e2a107e1dmr5587294a91.41.1784199122152;
        Thu, 16 Jul 2026 03:52:02 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e3a0d7bc6sm1105568a91.11.2026.07.16.03.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 03:52:01 -0700 (PDT)
Message-ID: <f9d0a06d-b7b0-4e51-8173-c53104c2a096@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 18:51:58 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ath12k: WCN7850 fw stats permanently wedge after AP channel
 switch (v7.1.3, includes 8f153eb74546)
To: Mike Garuccio <mgaruccio@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org
References: <CACfdPNH1Hgz70gYNRFBupxzjpOyBAVBPdxF+f_OLRUwMwXmXFg@mail.gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CACfdPNH1Hgz70gYNRFBupxzjpOyBAVBPdxF+f_OLRUwMwXmXFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: oYwVpS7qTj-xQZoRpZyk_W6hjdz4vBWe
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDExMCBTYWx0ZWRfXyn0aT8e2Bnde
 De26nv8cuBDSAEMSABHPe+GHYdUeuuT4CSVMkvue4QVkdeW3c/Dpp18RJ9nNfg/yMIora5H6VwG
 i3NrqNZ2scsOcMtx5A0aLBw9YNCafAE=
X-Proofpoint-GUID: oYwVpS7qTj-xQZoRpZyk_W6hjdz4vBWe
X-Authority-Analysis: v=2.4 cv=PN8/P/qC c=1 sm=1 tr=0 ts=6a58b7d3 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=2_3R45MI0XgUL3_lzmwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDExMCBTYWx0ZWRfX8g5Mgjk0Py5B
 CJd2e5422njCNh+d9mH9Ib/QkFDw5JSt7yv9a3dAwqn/Al0/z2hbYqI4HQG5x5XOKBCmLHHp0lI
 00mq5szDj6/POQlhTaWZeHwb5NbnnxYV/5Q+a/SLyc8ZPoh64w6xfCzgfCLESj21QC/K6v5Vudd
 gwD8+vjv36ZBfxN2ruZ7UajlsdNYXqoQl99hvzRT4fLN8gaoiK7dszGjBiALrLeHYui9kySW93A
 dtQ9+m0Y8oMqWIgnd1RBu9JjFRxGLiLFRmwc7s8u7gcVHiuxtMNNZUsxtz5nxhw2BpfLB8m/X7t
 TBI/oQ3abeXp3FR50znbO4JjLlBAt2s89JlU6KdG+7CQ2zWoZeRrVxkR/9HHiITg2XQSPZPaxha
 G0iMpd53rUOyJhD5Ph+PsGAC0cdKS1gFtQ8NfhGtfH3a0fyvAI8VPfCcRbCoIFMSsfhiqN4ijwb
 c9Ro+bE0ECdMpA/NpDw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_04,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160110



On 7/16/2026 11:36 AM, Mike Garuccio wrote:
> Hi,
> 
>   On WCN7850, an AP channel switch (CSA) can permanently wedge the
>   firmware stats path: after the CSA, every WMI_REQUEST_VDEV_STAT
>   request times out with
> 
>     ath12k_wifi7_pci 0000:0d:00.0: time out while waiting for fw stats done
> 
>   repeating on every request until reboot or driver reload. The data
>   path is unaffected (still associated, traffic flows). Because
>   ath12k_mac_op_sta_statistics() falls back to the fw stats path exactly
>   when the cached rssi_comb is 0 (the post-CSA state), every station
>   statistics poll from NetworkManager then blocks ~6s in the driver,
>   producing a continuous stream of these messages (~14k/day) and
>   D-state polling processes.
> 
>   Environment:
>   - WCN7850 hw2.0 PCI, chip_id 0x2 chip_family 0x4 board_id 0xff
>     soc_id 0x40170200
>   - fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10
>     fw_build_id QC_IMAGE_VERSION_STRING=WLAN.HMT.1.1.c7-00108-
>     QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>   - Observed on 7.0.12 and 7.1.3 (distro-built stable kernels,
>     CachyOS). I verified v7.1.3 already contains 8f153eb74546
>     ("wifi: ath12k: use correct pdev id when requesting firmware
>     stats") and 7259b1a0e54c, so the duplicate-reply issue fixed
>     there is not the cause here.
>   - STA mode, single vdev, 5 GHz.
> 
>   Reproducer / correlation: three occurrences over five days, each one
>   starting seconds after a CSA from the AP, e.g.:
> 
>     Jul 14 03:48:01 wpa_supplicant[1403]: wlan0:
> CTRL-EVENT-STARTED-CHANNEL-SWITCH freq=5765 ht_enabled=1 ch_offset=0
> ch_width=20 MHz cf1=5765 cf2=0
>     Jul 14 03:48:02 wpa_supplicant[1403]: wlan0:
> CTRL-EVENT-CHANNEL-SWITCH freq=5765 ht_enabled=1 ch_offset=0
> ch_width=20 MHz cf1=5765 cf2=0
>     Jul 14 03:48:06 kernel: ath12k_wifi7_pci 0000:0d:00.0: time out
> while waiting for fw stats done
>     (then repeats every ~6s for the remaining 4h20m of that boot)
> 
>     Jul 15 00:10:01 wpa_supplicant[1273]: wlan0:
> CTRL-EVENT-STARTED-CHANNEL-SWITCH freq=5765 ht_enabled=1 ch_offset=-1
> ch_width=80 MHz cf1=5775 cf2=0
>     Jul 15 00:10:02 wpa_supplicant[1273]: wlan0:
> CTRL-EVENT-CHANNEL-SWITCH freq=5765 ht_enabled=1 ch_offset=-1
> ch_width=80 MHz cf1=5775 cf2=0
>     Jul 15 00:10:10 kernel: ath12k_wifi7_pci 0000:0d:00.0: time out
> while waiting for fw stats done
>     (then repeats every ~6s for ~23h until I reloaded the module)
> 
>   Boots without a CSA never show a single timeout. Uptime before the
>   CSA doesn't matter (one wedge happened 40 minutes into a boot, one
>   after ~2 days).
> 
>   Additional observations:
>   - It is always "time out while waiting for fw stats done", never
>     "time out while waiting for get fw stats" — i.e. fw_stats_complete
>     still fires, firmware is still sending WMI_UPDATE_STATS_EVENTID.
>   - The WMI pdev temperature path keeps working while wedged.
>   - Recovery: reloading the driver modules recovers immediately.
>     From code reading, nothing in the SSR/restart path resets
>     ar->fw_stats, so firmware recovery would not clear it.
> 
>   Analysis: this looks like ar->fw_stats.num_vdev_recvd getting out of
>   sync. In ath12k_wmi_fw_stats_process():
> 
>     is_end = ((++ar->fw_stats.num_vdev_recvd) == total_vdevs_started);
> 
>   num_vdev_recvd is only zeroed by ath12k_fw_stats_reset(), which
>   callers invoke only on the success path, and ath12k_mac_get_fw_stats()
>   does not reset it at request start. A CSA is executed as a vdev
>   restart; if a stats event is lost/late or arrives while
>   num_started_vdevs is transitioning, the request times out (no reset)
>   or a stray event increments the counter with no consumer. Either way
>   the counter is left non-zero, and since completion requires exact
>   equality and the counter only ever increments, no subsequent request
>   can ever complete — matching the observed permanent wedge on a kernel
>   that already has 8f153eb74546.
> 
>   Happy to test patches — the AP in question does a CSA roughly daily,
>   so I can usually confirm within a day or two.

Hi Mike, great report and analysis. I think the root cause is the unconditional increment
on num_started_vdevs even for the CSA case. In your single-vdev case: after a CSA
ar->num_started_vdevs becomes 2, but firmware still sends one VDEV_STAT event, so
++num_vdev_recvd reaches only 1, is_end never becomes true, and fw_stats_done never completes.

Can you try below diff ?

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index ae874114dc51..83b3c68f328e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11447,7 +11447,9 @@ ath12k_mac_vdev_start_restart(struct ath12k_link_vif *arvif,
                                                   &arvif->reg_tpc_info);
        }

-       ar->num_started_vdevs++;
+       if (!restart)
+               ar->num_started_vdevs++;
+
        ath12k_dbg(ab, ATH12K_DBG_MAC,  "vdev %pM started, vdev_id %d\n",
                   ahvif->vif->addr, arvif->vdev_id);


> 
>   Thanks,
>   Mike Garuccio

