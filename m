Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792481784;
	b=J9ChfJakJPeUgqQ7K/3Co/VJTXbvT6hly2GlrkTyetL/rLcRYCVvpYxhubTdOpzZ+ihn
	 9mIyfARAaRlGW5ld5u6rS/UdIBWHmfK/zigXJKHb5KvCmKxA1iHUjzWMRnw/l0hRzXYKC
	 qjACxA006Vll5Xcz/qHN4w1gECsDUHqyteycz9vfnHqT6PbTi5prNvWAmTYJtxxff14py
	 PR/zJPH2b+fV+NvMWPuqQ4pxEo2WMpNnoXndfD6eKI3FQFbfunRwM56a5TdD0ipRXwsS5
	 849YlSbqodmofdgrwzyVY0boNjg8/C05U2byHchqnnvu33f/GKZcioiHSVUmC8jmixw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792481784;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=yMH+ndSWYxYloRSPpzwOpflCVqRuyoTp0ZLRh56w/Fo=;
	b=LiE6G+rlXtqA9ALjhYPwtzKEIhVvYe8qrEYsCgmUZsBSwMh2R4zKJPjxMNvrJ+vroB/H
	 +MU66B+BJqMARsSqznLNXSNuA/RwDMZUPLFI+yF+kE9VBju/aK4pi3MCYRwSkIUeRo0Dt
	 LRePGgMCaorHLAE3yPE/VtwNmSJDA9lQ5+a6+kPZc6fcSDFn6Ny1kfQEzYwPo9UcrLSq1
	 NQZk0aqy9vpZJDsRbNNIB70ka6QwlxPxLEUMaWhD3WvT8XJ/4uK3XH5HDyQLFWJ+Mq7ER
	 nXltlXcph7OkrBsg33X2ZvLzl4o4zXVbdgNQQiEHLpfkjBSCtqMiSJwEC6oEwjCngow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aAEmOq4m;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FNA8OPeJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BEB606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99BEB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aAEmOq4m;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FNA8OPeJ
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K0t6VY1210952
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yMH+ndSWYxYloRSPpzwOpflCVqRuyoTp0ZLRh56w/Fo=; b=aAEmOq4mEO4rW5Bq
	jzmfpiBmMRINj7W6KferrgSDmvbZu6+O12bCcggMzp53KY5OZruintVp95jtZ9M4
	t5QKH7wfY4DNb7F4XKdD6mT58YnDO51Q3CKr8EJfTPkreMEOgxVI1C0rKtxNlEnK
	iiBIFkr1s5fU03pbAXn0iAAv1asodpoO4PZdafq3PkWs7H527QPyGKjxUq0TUbVz
	8kBccvHITyTrIbkHp1HqzmfrBiRLRGcq+zpzRdgFubWXI0erAFpFd9x+RDpLjFbf
	7eNZXwUq8X6LNVMfUjk2n7J4lTmGktboO9oJlD/QvhOT4vTF+4p4meszSJZzXIyA
	5JXtVg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5p1dpc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:36:22 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91256a7b7b3so49162696d6.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792481782; cv=none;
        d=google.com; s=arc-20260327;
        b=n6VTODkKuaAbO9ytRSQhRzKjjivRkZl9CpMFlcAbZhlabVOMBucbRUrDFeTNmTf2KD
         MZdA0KV8XrTIxZ+VhDHeSU7JitRngyv//g7PirBzI9s2solapBmGuUb6KHCOKTMETEwJ
         eQZu8qubIT5VXnhelcvUwB3O05QtgotkOuVK2snYZt3ti4uQm4RJqceKp359OIeZht+K
         +fngMiFrtgHdEqCIFbhIVXv53I2ebBpeorc1tW1EC8CMaPIvhZmTATZzwQte2kbtuV9O
         oZpeKRX9IS1UlzGv/iKkWY62a/zRezOZC6gJbnvv2PmwcMhJolNe10pHzNKkw9VeoS5j
         Nf7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yMH+ndSWYxYloRSPpzwOpflCVqRuyoTp0ZLRh56w/Fo=;
        fh=hmFtJngGXF7is6u2zMQK28WtJHp9NtKpJdq5gmlfVJo=;
        b=IEj5dfAP/PEY/hU8q9f6C/z5PKKITqaIeyKbEwvtQBOr18JJ1GZ861+rZIRPW4g1zJ
         133pkEx5AJw2g/IycNmXOP/VOBggAtDzKZBkRNYGJSoI7TxWt5yOAQZAXYNUa0EN+aKP
         /t1rl1/M2QXyRSNGvJWj6SmrKfklD+whhuROdDVkUY/Lyx/Kw44aA7ghdqCATDDos8CI
         qCQ1hl8uD27lACSpNSp9oYma1XltJgmiRVpu6DrxBaO9fnxZnYSRnGjG9a3wNLGLBOn/
         vr6RIPCpGQ2YxjPQGBJpiq//Bt64UjnDTQKPFOFaERyE5ssVXZw58Pkf55kYWqaxOyqw
         CM4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792481782; x=1793086582; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yMH+ndSWYxYloRSPpzwOpflCVqRuyoTp0ZLRh56w/Fo=;
        b=FNA8OPeJqIAX5Nfq/AXYFOTOQJfHBJdC0t636wcCq/AiyvlI5AuyIC9IJTInn5BfIJ
         DH9l+YE/kPx/5dbvB6etzn2Hu7SFBIYt2r6gpdLnj45TJR4vKcYsSRtCRoM592/J+9dL
         yJI5EHTWJAybiMqAUsMGRhEB/Jk+gl6+QjrS1IgxafvTrWSda89I074+HHMQtyHTiI3Q
         IvAE/8RatSRvKgJ0sqWDenD9BLBYq/vKzhfyr2pIy0DuND3Edpa4oDtCp+7vjguhPZjU
         h2VwUhvfnbqDPxKNNj8E4t0ztQrLQXdHdugikqHe/QcLOLBeGnjibYRFe4FySpwAX7tT
         Cv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792481782; x=1793086582;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yMH+ndSWYxYloRSPpzwOpflCVqRuyoTp0ZLRh56w/Fo=;
        b=dnSN3irMeduu33PS9h15nDCy9spnzztnAWfficZAmDOphNLo+rVK3bhL/O824gQ5Ic
         WoPta/vbbnE2hwwyYZmzHlaIrd088MLXm17Rfbw3qfbfqShx8f4AHhAA83IZgSdrs/1N
         BMXciBQpkjpMILBdwXHJBvm823r25Pb7OYNxPhH7H7U4LkceP9Jn0lgZgC4Hp3qHcfJf
         nDHpkMlg+UTEatt5HkLUUuc+YCB/S/JBVUO/F1vuA7EdcOnOHP6vuuxQVk9cch34WIKs
         h5rFi39zgb2pJFCsvOdMVmMzLtjSWzC4QB5cvoGwjKbxY0g9Yk8inkQ8/TZ7HNU70lr/
         Gu6A==
X-Forwarded-Encrypted: i=1; AKwUvBxNiBhuVVv4Hm7gzCfBZj/8Giv1InVoM9TbYMge1v58mTDIFbMART2Ty1o2tNoib2WWvXcpNfUdqBv6noijNQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYK9wTSEYMugVgBlf1t4KrizkgT5k0mZuPByYKTVbEBiWEvAhRBw
	8VYdz7i3C3ejioORc1x15WSMPTJgY3xWYMtmcPzhohVfvfzfGfxr6HwEy5xuvBd7erjJir7QYc6
	avQWClC/WL2BNIeljr33tn0mmkOLWjFzPHvWXjndUiQXpss9JP0RBgl2y9mAW5e5LfJCrf9cYV1
	+P9fi6l++iYG5nNbA7fZHy6wlj4SThqtmmvjw+1vdOK9AB
X-Gm-Gg: AYBFou11x43JlilED4+1tt+wvRseV6z4hKXrD20V7U+rqPkqk2c5MxK+2K9HokcLien
	FKrC1xeHfrjYXJck/US36GCNmMhHlCr7fgXVXiP3s9khG6bHNwTr67/V5wkyyrZFS2EQ9HK3ueL
	TiGINtCpPqSR05/mP18VUy6ym8YlkrKDUeTpkBufBqfminaoBy0KZ58p3Zcfhc6F8L4bHrrebLk
	obUO0d3NfIcMvToXss69fh7x9TxKGuxV/3ZsP2jRTkSN36s9neQ5+/4sA01DwbwMDeAsJ02ugs=
X-Received: by 2002:a05:620a:394c:b0:93e:c12c:4416 with SMTP id af79cd13be357-93f29df8910mr1636930685a.82.1792481781928;
        Tue, 20 Oct 2026 00:36:21 -0700 (PDT)
X-Received: by 2002:a05:620a:394c:b0:93e:c12c:4416 with SMTP id
 af79cd13be357-93f29df8910mr1636929085a.82.1792481781390; Tue, 20 Oct 2026
 00:36:21 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com> <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 09:36:09 +0200
X-Gm-Features: AclHuK8ruwll37nLGnEXSBOSywPZkonQuKTFoOC5C70Qf_HAlsUxmdKYvpBNrgU
Message-ID: <CAFEp6-1t7s9zX5GMyiZ_PP09Zz1qRZ_tRRTmo2m_vBqOBj-Mhw@mail.gmail.com>
Subject: Re: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
To: Kang Yang <kang.yang@oss.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: L1-IqH7SzLm4AbVpeJHxPTcnVgbwr8EN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAzMCBTYWx0ZWRfXwPFEG6BzzqC8
 DAr6jqDEVYK2A4c2cXY8SGpm+RtczSdfurYI2i3XKRXtqfLGLrJ3wnVokOIphfuKz5Oh3dbTaf2
 zzO7LZHoXnUsresCxJabQh1T48CShxE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAzMCBTYWx0ZWRfXwpvDxLSBQJ4L
 NL4Oe3J+xj4Zi2wrJM00s+7R4Msynll21gmXqcrNfGgxZX7dHDW/scW4YsyajNfr1tFYrM7NAER
 QDPHnZvXzvOTNVxq5XX+N0H3I+GWgybVxiyS0pJaHGvlxhNIIYBjAYpRrQF7h8bGkmdtnU07IsB
 4xCzvWT+U2jpert6qk2VJH5mfBeHRibXrQuH6yJeGF1mgie4VZWc4/WGrUcSVeERBNZ6XQBbu7y
 w4it9oa3NtHJ1X+j7q9NnqL5dZdpoUMGcUUdD6/cWDyb2S0g9Q7Ymzv7CmoShq4BG+PEOQ1rLQ3
 rF0Dd5cmzie1Dr239YvdRWXp+6HXADywVjw6RYKIdA7TxZZqjEydUyn+xQVhgUSXUZceeZUy3jy
 I7viszY1sK5Pnjeyfi6Ose1Z2pF6/nChwvJoB3SthTFbyY+p1lGVDyFP3WpcgRTqJNHI3EDXIQw
 O7m0Whcf9EFQp4PHsoA==
X-Proofpoint-GUID: L1-IqH7SzLm4AbVpeJHxPTcnVgbwr8EN
X-Authority-Analysis: v=2.4 cv=crUOAF4i c=1 sm=1 tr=0 ts=6ad719f7 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8 a=3J7okp31mlcxl4oyp0oA:9
 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610200030

On Fri, Sep 25, 2026 at 2:27=E2=80=AFPM Kang Yang <kang.yang@oss.qualcomm.c=
om> wrote:
>
> Recovery timeout enforcement currently advances only when
> new recovery triggers arrive.
>
> In practice, the interval between triggers is not bounded.
> Additional timeout handling, workqueue congestion, or other
> recovery-related activities may delay subsequent triggers,
> causing the effective recovery timeout to extend well beyond
> the intended ATH10K_RECOVERY_DEADLINE_HZ limit.
>
> If recovery becomes stuck and no further trigger is generated,
> deadline enforcement may stop progressing entirely.
>
> Convert recovery_check_work() into self-rearming delayed_work
> so timeout monitoring follows its own timeline while recovery
> is in progress, independent of future recovery triggers.
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Are you using b4 (or ./scripts/get_maintainer.pl) for this series? It
looks like a lot of relevant To: and Cc: recipients are missing, which
makes it harder to get proper review coverage.

>
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 20 ++++++++++++++------
>  drivers/net/wireless/ath/ath10k/core.h |  2 +-
>  drivers/net/wireless/ath/ath10k/mac.c  |  5 ++++-
>  3 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 29ca34a643ed..93dc7332c759 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2522,7 +2522,8 @@ static void ath10k_core_enter_wedged(struct ath10k =
*ar)
>
>  static void ath10k_core_recovery_check_work(struct work_struct *work)
>  {
> -       struct ath10k *ar =3D container_of(work, struct ath10k, recovery_=
check_work);
> +       struct ath10k *ar =3D container_of(work, struct ath10k,
> +                                        recovery_check_work.work);
>         unsigned long recovery_start =3D READ_ONCE(ar->recovery_start_jif=
fies);
>         int fail_count;
>
> @@ -2536,8 +2537,11 @@ static void ath10k_core_recovery_check_work(struct=
 work_struct *work)
>         if (!atomic_read(&ar->pending_recovery))
>                 return;
>
> -       if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT=
_HZ))
> +       if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT=
_HZ)) {
> +               queue_delayed_work(ar->workqueue_aux, &ar->recovery_check=
_work,
> +                                  ATH10K_RECOVERY_TIMEOUT_HZ);
>                 return;
> +       }
>
>         /* Record the continuous recovery fail count when recovery is lat=
e. */
>         fail_count =3D atomic_inc_return(&ar->fail_cont_count);
> @@ -2547,7 +2551,12 @@ static void ath10k_core_recovery_check_work(struct=
 work_struct *work)
>                 ath10k_err(ar, "recovery timeout %ums, fail count %d, shu=
tting down driver!",
>                            jiffies_to_msecs(jiffies - recovery_start), fa=
il_count);
>                 ath10k_core_enter_wedged(ar);
> +               return;
>         }
> +
> +       /* Keep checking on our own even if no further trigger arrives. *=
/
> +       queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
> +                          ATH10K_RECOVERY_TIMEOUT_HZ);
>  }
>
>  void ath10k_core_start_recovery(struct ath10k *ar)
> @@ -2574,9 +2583,8 @@ void ath10k_core_start_recovery(struct ath10k *ar)
>         atomic_set(&ar->fail_cont_count, 0);
>         WRITE_ONCE(ar->recovery_start_jiffies, jiffies);
>         queue_work(ar->workqueue, &ar->restart_work);
> -
> -       /* Start monitoring after publishing the recovery timestamp. */
> -       queue_work(ar->workqueue_aux, &ar->recovery_check_work);
> +       queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
> +                          ATH10K_RECOVERY_TIMEOUT_HZ);
>  }
>  EXPORT_SYMBOL(ath10k_core_start_recovery);
>
> @@ -3758,7 +3766,7 @@ struct ath10k *ath10k_core_create(size_t priv_size,=
 struct device *dev,
>
>         INIT_WORK(&ar->register_work, ath10k_core_register_work);
>         INIT_WORK(&ar->restart_work, ath10k_core_restart);
> -       INIT_WORK(&ar->recovery_check_work, ath10k_core_recovery_check_wo=
rk);
> +       INIT_DELAYED_WORK(&ar->recovery_check_work, ath10k_core_recovery_=
check_work);
>         INIT_WORK(&ar->set_coverage_class_work,
>                   ath10k_core_set_coverage_class_work);
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index 0319da3ec022..a1ded2cba103 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -1213,7 +1213,7 @@ struct ath10k {
>
>         struct work_struct register_work;
>         struct work_struct restart_work;
> -       struct work_struct recovery_check_work;
> +       struct delayed_work recovery_check_work;
>         struct work_struct bundle_tx_work;
>         struct work_struct tx_complete_work;
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 8e604697d6c2..d10126351fce 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5427,7 +5427,7 @@ static void ath10k_stop(struct ieee80211_hw *hw, bo=
ol suspend)
>         cancel_work_sync(&ar->set_coverage_class_work);
>         cancel_delayed_work_sync(&ar->scan.timeout);
>         cancel_work_sync(&ar->restart_work);
> -       cancel_work_sync(&ar->recovery_check_work);
> +       cancel_delayed_work_sync(&ar->recovery_check_work);
>  }
>
>  static int ath10k_config_ps(struct ath10k *ar)
> @@ -8175,6 +8175,9 @@ static void ath10k_reconfig_complete(struct ieee802=
11_hw *hw,
>                 atomic_set(&ar->fail_cont_count, 0);
>                 atomic_set(&ar->pending_recovery, 0);
>
> +               /* Stop the self-rearming monitor after recovery succeeds=
. */
> +               cancel_delayed_work(&ar->recovery_check_work);
> +
>                 if (ar->hw_params.hw_restart_disconnect) {
>                         list_for_each_entry(arvif, &ar->arvifs, list) {
>                                 if (arvif->is_up && arvif->vdev_type =3D=
=3D WMI_VDEV_TYPE_STA)
>
> --
> 2.34.1
>
>
