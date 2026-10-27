Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793094616;
	b=IVJ6M+ETBMCeaday/8TDybCHNX3XjElu9BsvPjPZD6xzgf1SVif1rNL47VKJARHDTrHA
	 Y8akMza0AlVpXrYOulASZRQxbgKtqxVvuQTHpQPa/xGl7BLEmB/WFeLylDufDhJy4t5Me
	 NGCI4CSJvLgbGIRjh3/92m2H5lfXfJT/ID+JUUTi/mLr9zHSzEVPFsELy//EyhODYCMIU
	 rP0LgAknOgUD0lt/BsPPzId/vCnEonBTBHNONL5hTaXSfqh3zheJXwTiZjezUwERmj6bt
	 QSxRVOqirftGg3NUk8LrbDThn8uy1DMcGmmt1JUWZc1anAEAvgw7nrcHTjRpJUs7dTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793094616;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=0nW4GpdOqtVNSH1UuGVj5defGAz9RFA6ehJB/XAZ5+Y=;
	b=tIa9qmZAFKhS3J5SYGpgtPt66asz+ZnljWzNAZa9/YELFUx/xux9QqriwdADO9oZUpqu
	 sDCliYSNKGFFFsDPLBXppRSvB3JAM7KPcbgrEHRcbXyoLrvmoZxfziHqMh2IHD2JaYter
	 RASWKn1Lb1w/eW9sD6HJcUNX8mD08Oj5CoO66ku6VXSPTZKcZNtPZ31TDhGS7CGQOnMG2
	 GJK7HH7rPgBJY8jOtsw9tXBd67nyRHbif2ChO2ZO32OXmq914IR+AitDWCM4KXoBQWdu7
	 HwdyGESNk2WoliwLAq0MHlDrqtR98sfjUQjs7DBaHC24iGjR1C+SG4eSfmIWS4RAptg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mPNXWxHb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OnhSqUbY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412F606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 09:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1412F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mPNXWxHb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OnhSqUbY
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R8fm8f1350062
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 09:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0nW4GpdOqtVNSH1UuGVj5defGAz9RFA6ehJB/XAZ5+Y=; b=mPNXWxHbgmkl0h+z
	jcduYQAk03rWXIyjqqgiBL94lKFBEmBZSBLjLuht/TUsDzoCwGPPCd312b0ZcB6z
	0pqwTdM50pLrGL4OOEtpRyAkola/f/ce0snEH3BCz86EP1vHRMErK/yb5Y7mhaMc
	xzC3RHKmmXUfKFjerAgi1dntt0QnLhi0JffoXwFFitoJLP8J8tSRYm2sQypII11r
	It2rf7mRVFNZujQ8uJBfHY2TMKuBcOy4Xw+IrXCJKnDvNCGYuRPA9at31JxBI3so
	dhYzuWiFRE+TJLZG26h4JumFOaOb8V+85UQaGxAR7S2TtPNO+E9QbAHiAx/muQcj
	h25T3Q==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjqf5rj1s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 09:50:14 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36a137058c5so106747eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 02:50:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793094614; cv=none;
        d=google.com; s=arc-20260327;
        b=W2CTDI5b153rYGzmuKUp8pFQvBZrUaxRG8hLEDM8uTRlKXygpqNoC6rHAYBCQBnJtH
         LQoervFDNtPoZbkYbc8k/NQqSG+KIb9dX1MwaMWCHaiOluY3w4Mz8Fm7rKtMl3Y3C0Ql
         XPgESt7yYu7o/FWMUlc/Wi3Af2loPTwkGvC/OGEl71cFidi2uZoCIYMwYr7Y2ynHn+F2
         PSKZuBxOAEG+vl8dp/mjqhU0bX77P00iVYSX5Kre3GGacOF3GSd6jMhwXTIpve/PptSV
         uGPkBDa+Oe1rypiA8SIMY6CZnFEsZatlr6ep10lBUvzWg0T75fOMPVLfarevbVk2emIa
         1PgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0nW4GpdOqtVNSH1UuGVj5defGAz9RFA6ehJB/XAZ5+Y=;
        fh=5qAD7kzD8EnOf/lj2Dgjj+K5zTYfzu/RP3ep+3Rnt+M=;
        b=W8ukDv/LZWzjH7kYE9n96tVXdS6g9n/IGcoT3cEtHvHDLNAw7nqGo7AcQlyOnkV4Ue
         jkucBqmOXZJEyOMgPXbwVpudc52JKvRhPI+ZOkT36BbXsq4PSQH3znans44IYP+wwbSH
         JuEaQLzx6iLOodyH8TyDFXF1ZscB2iCWY/QtKaDoGirNooSqssUu3L2lejefOKmGg/hr
         9GzWsuUgRouGk+FePyBR5JNabCn74iH3an8wG3qLxXs7haBwcUPuQdoRhxRJVnFMmsRy
         aOJpIoE7vYk1wNopf4N+A/OrwkLzOaUf6VJ/TlrS7xBiiBDjwsO5ZB6BNfx6jVvQvyth
         3LzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793094614; x=1793699414; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0nW4GpdOqtVNSH1UuGVj5defGAz9RFA6ehJB/XAZ5+Y=;
        b=OnhSqUbYqSagrSumGVbMx2IN6+ryGFoiLOxG1oJD5IytRv8XQuwZgsuhmTY6bxHseG
         0F3viqsSxK73fynXPsObSUIqfKIehbLNXeSRpUuTOzONNXKiLS184VufcjURzOZe/ym/
         ULhKhzhfaV5p8t2RNmNZEUNPkmgmnoPyjSZq+wA6d0fu+IIUNJRaXRg8WsMOGFF4YCJI
         +S+uHSPfVl3rCQg/75wuGNH/ND0y88WYKxEu/ptJ+xR/1fKX8ynkGLjzXxsB6nszkuLz
         VS1B70/x893Iwd1pgNgE3LgqJtwd2m0KsOE0P9Y44QXU6KaR6MwWJeQh8K7OcafRcw0x
         MUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793094614; x=1793699414;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0nW4GpdOqtVNSH1UuGVj5defGAz9RFA6ehJB/XAZ5+Y=;
        b=CXlTuLC8eM0eW+1MGS3YIn9irsM5p4ArtnDTkH2B3bPaDomBXeqy5S+xEV36uR9Yr1
         anBKdl0gGGzjMTS6mGpV5g8C+rtjQZl2fxZODYAdmkrv+BVeokGGTF1lRVLJHFf9LnWX
         4DBXhJzgFo7KRzC2yST6+33DgP9RPtxnBqK3DiLskePIAwBYaCSLLsx+0vCkA1Jc8k2O
         JDXnUNkLB8MGYYSpSMm+wAiVUi0qXMMj1tOkH3C41+kC7c9ILvcfAbET0v3aPEKyHM5r
         JoG/HKVZZrWC9PLy7DWV7z7lAPBc3teoE9Ke43J1gA++Wy8XSScqsZJZtBnaD284AT7/
         9FmA==
X-Forwarded-Encrypted: i=1; AKwUvBz6YLnJkipAUM22rBn6OhR2wxC8+oHggoQPEsTKv9W+Siauw/fm1AzmqJGdan5jdnXYdSboizv17Dfbu4AL9w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKOh4bX44WqNcDrPyt0uDyZHMIe5Vd+ZlgFNwC6yIIBY5NFA7Fg
	+litOPDzSl9FhCEyiqBykVQhHJmYyuEkUsDwaAgPja0PbVZQTlGxNjK2TwT5faBf6c3X6ZTocT4
	TBij5ctuhPS1WPMbLDzh+pLzr35pg5DVazEEYEaFLXmxvwlShsMzGQ7twuEksbH1/bne54M5r1H
	zDXtnf3ln0hTonwWrY6NFnVVjv64G4EpH1i8cV49MwHXS+
X-Gm-Gg: AYBFou1+kTF0+La630fyeBTdc0JMoG+O+MGaEAYpiNxSBNQxmTK3jqAFDWeHjSFwYZS
	0XtwtWUUTBC699t+wJXR1yH2r1LTZ3xBrenNE4HneQDr+N6lYXHwbiMMbpTrl+QhoPGzeabcoQY
	pyKLSBh7M1CF/6QgFau61MmeDMzi3tAEw4vWbqq5kqi6/2WSvu3JsMpWSvDEnZu8kLRBCc072ro
	ln6h/cX69MLgC9X2Kc=
X-Received: by 2002:a05:7301:a08:b0:35e:d21c:f33e with SMTP id 5a478bee46e88-369e84373bamr23365601eec.1.1793094613316;
        Tue, 27 Oct 2026 02:50:13 -0700 (PDT)
X-Received: by 2002:a05:7301:a08:b0:35e:d21c:f33e with SMTP id
 5a478bee46e88-369e84373bamr23365547eec.1.1793094612682; Tue, 27 Oct 2026
 02:50:12 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025181955.2089498-1-dencity7@gmail.com>
In-Reply-To: <20261025181955.2089498-1-dencity7@gmail.com>
From: Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 15:20:00 +0530
X-Gm-Features: AclHuK_7kOtD5jQvDk3UaufyQmlwRV_UVM79_HqaTmW-CloxbfLvAvQ2pquvxqM
Message-ID: <CABkEBKZtaWkvxbhnOPBUjbh_iLx-Tyok0PskhduQk4O8qq=NVg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] wifi: ath12k: service all RX rings in an interrupt group
To: John Macias <dencity7@gmail.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Jeff Johnson <jjohnson@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAzOSBTYWx0ZWRfX1Xp+mp8nI0hT
 NYSt1Bbk5JhuX9OzYAxSxDvhgL7RFcMt42CdiV3LFnVK7SeWF3hTyPOPMIK/KBXxOygF7FZ0YUF
 azvZ4oKB2pEPpw5ycR+jaOKuEKek4HY=
X-Proofpoint-ORIG-GUID: LVK6Uuc08oaL1V3WT8E3nZQSxPqMcWP8
X-Proofpoint-GUID: LVK6Uuc08oaL1V3WT8E3nZQSxPqMcWP8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAzOSBTYWx0ZWRfX6u66vdYFeqOH
 Qne0Xx9RWXna7ZFwnaHx16uml0pVHdR1uyipiRsk+bPeu9POSh2H3yVH18oNgGwyKJ+NHIKvw7n
 E4vbQVw07r2nTIqpWGhFEokWSbJ80Lh263OBlMkUnMWt8que4uAcEfzptTYiPwAHnxhGWd0bV9D
 ef9brI0BZJWP5LtjIPYHLIu73tp0tbzMSI/cdkhEZFICUcvFqsbXTcv1zLItQT1xfOCJk+s0trj
 TuDqsexRdQrumuzzMbvQn0dMKpmZ8YVi27Ox8aVrLK6VuALXquX2I/opyRrN3YpiLt31xpbtao4
 prcv5RFphBfg/NQkNPB+pQ7RCujLiF4zYQ996dGQ0m6Q3AHuX5Eun5olJ+DGUt+yXWjIQMryJeP
 4Kt7TWNeJVjuFFhLJZjTX4C1ijXk5EMUWIwBG22NsEIzVhoi8+NLgpyx1hseTdahwkkN3Unc8k/
 ARhe15tP1c+bvxMPP1A==
X-Authority-Analysis: v=2.4 cv=UOFIjyfy c=1 sm=1 tr=0 ts=6ae073d6 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=Ng-7FXKHubOAd_qVELIA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270039

On Sun, Oct 25, 2026 at 11:50=E2=80=AFPM John Macias <dencity7@gmail.com> w=
rote:
>
> ath12k_wifi7_dp_service_srng() services only the highest REO destination
> ring selected by ring_mask->rx[grp_id]. If a group selects more than one
> ring, the other rings in that group are never reaped, and the flows
> hashed to them stall.
>
> Every in-tree ring mask selects one REO ring per group today, so this is
> latent upstream. It is hit by the QCN6432 ring mask from the vendor's
> downstream tree, which puts REO rings 2 and 3 in one group. On a
> GL-BE3600 using that mask, 7 of 16 single-flow TCP downloads stalled or
> failed, and ring 2 reaped no packets at all.
>

Does any current upstream ring-mask configuration trigger this issue,
or is it only present in downstream trees?

> Walking every ring with the full budget is not enough: under load the
> first ring can use the whole budget on every poll and starve the others.
> With that approach ring 2 reaped under 1% of ring 3's packets, and the
> flows on it ran at 0.2-4.4 Mb/s while the others ran at 100-360 Mb/s.
>
> Instead, give each ring in the group an equal share of the budget first,
> then hand any budget left over back to the rings in a second pass. A
> group with a single ring still gets the whole budget in one pass, so
> current hardware behaves as before.
>
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
>
> Assisted-by: LLM
> Signed-off-by: John Macias <dencity7@gmail.com>
> ---
> Changes in v2:
> - Share the budget between the rings of a group. v1 walked the rings
>   with the full budget, which starved the lower ring under load (see
>   below).
> - Rebased on ath-next.
> - Added a Tested-on tag, full name in the sign-off and an Assisted-by
>   tag, as Jeff asked.
> - Link to v1: https://lore.kernel.org/ath12k/CA+KzPsr13czsH=3Dk_UWJqj48C4=
Vsb-diQ-tiCh7W4XW31E8WzHg@mail.gmail.com/
>
> This is still an RFC because I have no WCN hardware, so the WCN side is
> untested. Since every in-tree mask has one ring per group, the change
> should be a no-op there, but I would be grateful if someone with a
> WCN7850 could test it and reply with a Tested-on tag.
>
> Testing. Both radios ran OpenWrt (Linux 6.18, backports 7.2), and only
> the ath12k_wifi7 module was swapped between runs. Rebuilding the
> unmodified sources reproduced the installed modules byte for byte, so
> each test module differed only in this handler. The QCN9274 build also
> carries an unrelated local REO fix, as installed. The QCN6432 is a
> GL-BE3600 using the downstream QCN6432 support (not upstream yet), as a
> 5 GHz client of a GL-BE9300 with QCN9274. iperf3 over that link:
>
>                               before    v1           v2
>   16 single TCP flows done     9/16     16/16        16/16
>   slowest of 8 TCP streams     stall    0.2-4.4      70-83 Mb/s
>   ring 2 vs ring 3 packets     0 vs -   3k-8k vs     about equal
>                                         0.7M-1M
>   QCN9274 RX, 8 TCP streams    1012     1048         1034-1042 Mb/s
>   UDP loss, 8 x 50 Mb/s        -        <=3D 0.02%     0.00%
>
> No warnings or errors appeared in the kernel log on either side. The
> QCN9274 groups are single-ring, so that tag shows no regression rather
> than the fix itself. The hardware runs used a variant that differs only
> in cosmetics (left-- was inside max(), and the comment sat inside the
> loop). The patch as sent builds without warnings with W=3D1 on x86_64.
>
> This work was assisted by an LLM (Claude), which helped analyse the
> handler, write the test scripts and draft this patch. I reviewed the
> change and the test results, and take responsibility for them.
>
>  drivers/net/wireless/ath/ath12k/wifi7/dp.c | 31 +++++++++++++++++-----
>  1 file changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp.c b/drivers/net/wir=
eless/ath/ath12k/wifi7/dp.c
> index 397da016b..67a347362 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
> @@ -27,6 +27,7 @@ static int ath12k_wifi7_dp_service_srng(struct ath12k_d=
p *dp,
>         int tot_work_done =3D 0;
>         enum dp_monitor_mode monitor_mode;
>         u8 ring_mask;
> +       int rx_rings, pass, quota;
>
>         if (dp->hw_params->ring_mask->tx[grp_id]) {
>                 i =3D fls(dp->hw_params->ring_mask->tx[grp_id]) - 1;
> @@ -50,13 +51,29 @@ static int ath12k_wifi7_dp_service_srng(struct ath12k=
_dp *dp,
>                         goto done;
>         }
>
> -       if (dp->hw_params->ring_mask->rx[grp_id]) {
> -               i =3D fls(dp->hw_params->ring_mask->rx[grp_id]) - 1;
> -               work_done =3D ath12k_wifi7_dp_rx_process(dp, i, napi, bud=
get);
> -               budget -=3D work_done;
> -               tot_work_done +=3D work_done;
> -               if (budget <=3D 0)
> -                       goto done;
> +       /* A group may select more than one REO ring. Give each ring an e=
qual
> +        * share of the budget first, so a busy ring cannot starve the ot=
hers,
> +        * then hand any budget left over back to the rings in a second p=
ass.
> +        */
> +       ring_mask =3D dp->hw_params->ring_mask->rx[grp_id];
> +       rx_rings =3D hweight8(ring_mask);
> +       for (pass =3D 0; ring_mask && pass < 2; pass++) {

whether two passes are always sufficient in all kind of scenarios?

> +               u8 mask =3D ring_mask;
> +               int left =3D rx_rings;
> +
> +               while (mask) {
> +                       i =3D fls(mask) - 1;
> +                       mask &=3D ~BIT(i);
> +                       quota =3D pass ? budget : max(budget / left, 1);
> +                       left--;
> +                       work_done =3D ath12k_wifi7_dp_rx_process(dp, i, n=
api, quota);

This will have the performance impact in case of srng->lock taking
multiple times in a single handling.

> +                       budget -=3D work_done;
> +                       tot_work_done +=3D work_done;
> +                       if (budget <=3D 0)
> +                               goto done;
> +               }
> +               if (rx_rings =3D=3D 1)
> +                       break;
>         }
>
>         if (dp->hw_params->ring_mask->rx_mon_status[grp_id]) {
>
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> --
> 2.47.3
>
>

If current upstream configurations don't hit this issue, is this
change needed, or can we avoid the group ring-mask configuration
instead?

--=20
- Tamizh.
