Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792543102;
	b=sHF6IggKMB3cTUDzOvZbgC7l50W2nv730M8LOnbHYnIvPCD8mI/I1YYHszmr73CBYJds
	 XuqlMCx3oVFYCJJRamhHMysiT+36hg/54HJjr5EnkmhZ5oQcmHo0mqr6kdFx4uRoZdGnv
	 MCoS5JGqxs1xS8Ea6mRqrD0TtcObOK43Nn4jewGEpwprojVZUFQxpKt0QM8TmD0ONfsVS
	 ifogzyhVekoUgm37eHwXv/PX/2xGyEWIi5D8MmpmN3UHfe2+KpLqSA+cvx4uSd7kzFK5z
	 F3aIxsEOwxdeWVjm61DU7wiw6rUW6CEoXmvlnc4r9u/IUHcDSXiDbW+zktEcF49mtjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543102;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=HXFVCDgnjjgxR9X2+oHJiKj4Y5WpimrH/aIfriX4MSw=;
	b=LbZAYir3R7O4tq2tKVaS1dnWEGc0fo7oB00ZDBprCbZ1okcivwdy4+J5CePSPk7h0UKJ
	 SsVhmFCXSQ3Mg38Z/BNXe5C8m1AUDjPTPgIOmNx0afKHFQ+Wvn9wO2vXU3yEZB8ZNCEmQ
	 7E0UOBzUJ/atLC4h8vURqt1L70B1tTSXlYaORYgvJfWpWg3vCCOCLpkwF1OoR4ebdkQJu
	 sMq3DR9Cab03neyuoJh0b74oiqfoXogmcl+gJE6k2Wf+TyF2no6QCp1UPFdHQFsJdcpTd
	 qMc4E/4rD4EZIWIy77e59E5cqrk3jrmTdEgiXoY0gqVXBc4QQ7xn/RFEJ3q1xAbssUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=o73MNKiJ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=V0wPVRHN;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6CF606A322
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 00:38:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB6CF606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=o73MNKiJ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=V0wPVRHN
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KKu9kN1281410
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 00:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HXFVCDgnjjgxR9X2+oHJiKj4Y5WpimrH/aIfriX4MSw=; b=o73MNKiJFJnuycX6
	l2U/FRlMksGAHvhPprSiOBdS/qPPArjE2CJD5qDOh3kVEsCL5dGvtWVXnxCsZMaZ
	hCbQvZ6IPJP1zq2hf8qmIksXNAO6n2UMnlVifIME7QtVmHDJgeQ/uyj1PNL+ZDwN
	MO1S4bRqSOvl6DSHxDua9GtTIscdE7zNixc+oXCFIs2J1e7iSH+GSpKaD8+HlcUp
	q6ClQtwB9tF+r375pX+bo4pUQ7rx6pMhYsxXuAfxgtQaC10fD5a2bV4zKKfuY+rm
	7bynBTr2f1qgJ+VWe6oMs7tI25tM664OS1eH1GLeK8chClc8OcgK1cjAj0MX8yyF
	9VcZkQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4he7hvanua-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 00:38:20 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-147be78cd56so587727c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 17:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792543100; x=1793147900; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HXFVCDgnjjgxR9X2+oHJiKj4Y5WpimrH/aIfriX4MSw=;
        b=V0wPVRHNOO7q54IS/YPtF+iyodsmr9y4mO9OjdgoxLGs2wxbieZUFlCHBNA9ENGyZo
         ZhftugyKM5OM2x1UkoEk/fvhiejXufRmLzaPGPBiLp8QzKxdQLp3VONnPf+CNdsQp8AI
         R7BDt5JOwUFeUQXeGaomd0N/i3VzbRNlZf5l6KKQKhBPwBFcWkXUebvuUVAEN38+hcYP
         +YFh3wqTaQB4saCZSlCS8qOXp4d3N5eRK34/+IylzTqVltBuIsxEqn2TtSAfmAaYXPM8
         W0hbZqOB0ue+Z7KUF6sKOH3w43pF1oT7Vt1/b7U8oiADLpanUvGQmjGTTczthhmfPXs1
         aQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792543100; x=1793147900;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HXFVCDgnjjgxR9X2+oHJiKj4Y5WpimrH/aIfriX4MSw=;
        b=VvwFU6AT7kS349hPVPB1WR6a5UIlUrNDOK/4bE4IvjwLVqCUuV5yA57RDhhPILvwGw
         cL6bwg5I3RGa4OKjTdoy6RuZr+2xAR+Smqr40pVGf6ovIhkXkPbPkbY0IhrJAzNdAGLd
         6suAQ6VxJxdK6tOg+bqoEltCvdlARwN9TNUrmGg1y+GvyP1t6FWhtNUlAj/vCN98b30W
         i0qIQ4rvgumTL3S+eUTQeXzH4NfZwehFALSL/7yNcmCYseT1T7v2SzpMJ/SvwsFulOGy
         VXPQayPQtVgZfM9h6E9Q/r+4nk4jiXVgxmpKRd5h9mRlZKxXEx/CvR9jIqZvC3QicvNa
         xTQw==
X-Gm-Message-State: AFq9FYJ71dZZDYb05bpvDvfK9uy0vcA6iBzGk+GBzah8kQSMBno4YPfw
	zt1syInRDFPw02LtC7XxpubNctXLo8sNSc7QUskQTFJpWJbs9FbVJ+MQ90gW13gUiZ5POUkI/kV
	dlHpMAsSw3XxCc/6+eRB0sGr88vCseHXhBMLXhz4NDtBZYZUDGSycgF9PGLKFoA51IK573Q==
X-Gm-Gg: AYBFou2fOvi5Aa1mgdIk/O6lFVoik8dASPshvwDGxCNBgiDJ+LYRFxWPjapebHVFaz3
	5w37hWNpV2AqxPRu4Jk63w+ZCjdPghEnmjcKdRsi7srQu3eaKIqOhMp21OSBwfoZYXfAgnJ1wEC
	n7/6zsn8FhWGxjoSrvyAb9djAlgCZ5IMSEbI+R0eAVRYG1afQghJPmObzBPlbayxlcAsBoo2D3K
	z3REypyhM+ncpP01e2kndNu6gzGDTGaJSOeL9e/BpCaIGn6+POGrrRtmVnf+1FaiXEVFOuuwjl5
	9mitrGJBIMP2v16VWRg0p6plnwWXycHlHYe0M5jUPKvS2fjIrhHZfWaj4KbhNPBLmuogyytBf3U
	YZd0/5Q8BWZ12Ty1rurj6WwhWVmxZ/vhzg7l999UsepmCeOtm8XvO/lvnbw==
X-Received: by 2002:a05:7023:a5a:b0:143:6080:668f with SMTP id a92af1059eb24-190a6adc7b9mr501684c88.7.1792543099860;
        Tue, 20 Oct 2026 17:38:19 -0700 (PDT)
X-Received: by 2002:a05:7023:a5a:b0:143:6080:668f with SMTP id a92af1059eb24-190a6adc7b9mr501614c88.7.1792543098127;
        Tue, 20 Oct 2026 17:38:18 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903d3ae06fsm1928326c88.19.2026.10.20.17.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 17:38:17 -0700 (PDT)
Message-ID: <1e1238a6-399d-4cb5-a5ab-756ccac64169@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 17:38:16 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath9k: stop WMI event tasklet from rescheduling
 itself on probe failure
To: Deepanshu Kartikey <kartikey406@gmail.com>, toke@toke.dk
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
References: <20261003021147.7461-1-kartikey406@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261003021147.7461-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAwMSBTYWx0ZWRfX3xYABhZtc2K/
 Gg1PNZutq0+JmCQlWniVemz59hroN5QzdekUOfprugdlRWgt53DWmjtyywCMewZltl2wVIgdiIS
 GZtDIwfO3kDKdtFJaCCR0fEijYLBA5DU7B1hSpEaBHoKKRLZT9lSKQDKlhw15lOfxvCsR1ciGW4
 X94W3VxCxNLkgSL4hqkJVjvgRWf6DeAQFCY3aT0xsWqhovfxi9V+V7EqdY5Tntvvx55ko3aqyYY
 9oIWqX0/DdnrNNgWN2yFweXFN2robCILOeLmwLKzxt5QUH3roRfeLHd7ftDFiP/epH7WpIJL5J0
 jFZhO1zfrrXT59x1PiGrrKTYUBN8UNozFfnTAWsErAJYYbA2h9H87ajQ6WGd2rzLZUFx2RimVZa
 fLLMsfIUQjhHb/Viw06xYCMmgfzNYGD51NvBcV7OHDFVxTgjxDbDd3h6zmhYEq8E9H7BJ0fI5ra
 VIn6aPaq4xKh/jjVuBw==
X-Proofpoint-ORIG-GUID: kIjqVuBwTQihr7169uN2CI7HzoVNSbM4
X-Proofpoint-GUID: kIjqVuBwTQihr7169uN2CI7HzoVNSbM4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAwMSBTYWx0ZWRfXymb4LpUouesi
 FWut1VXoy6xcYY5NJN/JfO8PU4EPny0zxBukynMLRjZnLHrp4Avifx1lNmusErEqtPgSyHlttaI
 hLQ1SS7xbYgC3M/wTVafXZyK7EIEtus=
X-Authority-Analysis: v=2.4 cv=NppE4MdJ c=1 sm=1 tr=0 ts=6ad8097c cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=pGLkceISAAAA:8 a=_LGFtKlyWMYaSsMoYZQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=vr4QvYf-bLy2KjpDp97w:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_04,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210001

On 10/2/2026 7:11 PM, Deepanshu Kartikey wrote:
> Since the init guards were consolidated, ath9k_wmi_event_tasklet()
> reschedules itself until priv->initialized is set. If
> ath9k_init_device() fails, initialized is never set, so the tasklet
> keeps rescheduling itself while the probe error path calls
> ath9k_destroy_wmi() and frees struct wmi. tasklet_action_common() then
> touches the freed tasklet, causing a slab-use-after-free.
> 
> Make the tasklet drop its queued events and stop rescheduling once
> wmi->stopped is set, and call tasklet_kill() before freeing wmi in
> ath9k_destroy_wmi(). The probe error path already sets stopped and
> kills the RX URBs first, so the tasklet cannot be re-armed afterwards.
> 
> Fixes: 1af8dc9ca726 ("wifi: ath9k: Clean up device initialisation guards")
> Reported-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e91dc13b1b37759b3d9f
> Tested-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/wmi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
> index 4a08babb6d9d..f8b174b0f209 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -122,6 +122,10 @@ void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
>  
>  void ath9k_destroy_wmi(struct ath9k_htc_priv *priv)
>  {
> +	struct wmi *wmi = priv->wmi;
> +
> +	tasklet_kill(&wmi->wmi_event_tasklet);
> +	skb_queue_purge(&wmi->wmi_event_queue);
>  	kfree(priv->wmi);
>  }
>  
> @@ -148,6 +152,10 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
>  
>  	/* Check if ath9k_init_device() completed. */
>  	if (!smp_load_acquire(&priv->initialized)) {
> +		if (READ_ONCE(wmi->stopped)) {
> +			skb_queue_purge(&wmi->wmi_event_queue);

Can you check my review agent's analysis:

Locking inconsistency in the new tasklet early-exit path** (`wmi.c:156`)
`wmi_event_queue` has two lockguards in this file:
- **producer** (`ath9k_wmi_ctrl_rx`, line 249): holds `wmi->wmi_lock`, uses
`__skb_queue_tail()` (lockless variant)
- **consumer** (tasklet normal path, line 164): holds `wmi->wmi_lock`, uses
`__skb_dequeue()`
- **`ath9k_wmi_event_drain()`** (line 137–139): holds `wmi->wmi_lock`, uses
`__skb_queue_purge()`

The new `skb_queue_purge()` (locking variant) uses `queue->lock`, which is a
**different lock** from `wmi->wmi_lock`. The window between
`ath9k_stop_wmi()` setting `stopped=true` and `ath9k_hif_usb_dealloc_urbs()`
finishing means `ath9k_wmi_ctrl_rx()` could still be enqueuing under
`wmi_lock` while the tasklet purges under `queue->lock` — two different
locks protecting the same queue simultaneously.

It works in practice because `ath9k_wmi_ctrl_rx()` also checks
`unlikely(wmi->stopped)` at entry and bails early, but the locking is
technically unsound. The correct pattern (as used in
`ath9k_wmi_event_drain()`) would be:

```c
if (READ_ONCE(wmi->stopped)) {
    spin_lock_irqsave(&wmi->wmi_lock, flags);
    __skb_queue_purge(&wmi->wmi_event_queue);
    spin_unlock_irqrestore(&wmi->wmi_lock, flags);
    return;
}
```

The `skb_queue_purge()` in `ath9k_destroy_wmi()` (line 128) is called after
`tasklet_kill()` and after `ath9k_hif_usb_dealloc_urbs()`, so no concurrent
producer can run there — that usage is safe.

I always have another agent verify these automated code reviews, and my
verification agent concurred:

Issue #1 — Locking inconsistency at wmi.c:156 — Valid

The review is correct. Confirmed from the live source:

All code that touches wmi_event_queue uses wmi->wmi_lock with the lockless
__skb_* variants:
- producer ath9k_wmi_ctrl_rx (lines 249–252):
spin_lock_irqsave(&wmi->wmi_lock) + __skb_queue_tail()
- consumer tasklet normal path (lines 164–169):
spin_lock_irqsave(&wmi->wmi_lock) + __skb_dequeue()
- drain ath9k_wmi_event_drain (lines 137–139):
spin_lock_irqsave(&wmi->wmi_lock) + __skb_queue_purge()

The new early-exit path (lines 155–157) breaks this pattern by using
skb_queue_purge() (the locking variant, which takes queue->lock — a completely
different lock). The race is real: ath9k_wmi_ctrl_rx's guard at line 238 is a
plain read of wmi->stopped (not even READ_ONCE), so it can miss the
stopped=true write and proceed to enqueue under wmi->wmi_lock while the
tasklet purges under queue->lock. Two unrelated locks protecting the same
queue simultaneously is unsound.

The skb_queue_purge() in the new ath9k_destroy_wmi() (line 128) is fine — it
runs after tasklet_kill() and after URB dealloc, so no concurrent producer
exists there.

Fix: mirror ath9k_wmi_event_drain's pattern in the tasklet early-exit:
if (READ_ONCE(wmi->stopped)) {
    spin_lock_irqsave(&wmi->wmi_lock, flags);
    __skb_queue_purge(&wmi->wmi_event_queue);
    spin_unlock_irqrestore(&wmi->wmi_lock, flags);
    return;
}
Note flags is already declared in the tasklet function (line 150), so no new
variable is needed.

> +			return;
> +		}
>  		tasklet_schedule(t);
>  		return;
>  	}

