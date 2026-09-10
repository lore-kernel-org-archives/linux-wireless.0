Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C002B413781
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027469; cv=pass; b=d4Hm2evMyVzN65cvk3aK1MehTyP65n31YUbEUtkEl65iElodsqWKVD56dJcQULjjgGhsHQ7T8tkdufcXEJQ9Dw1ieI2rWgn0e9QpUZh3IgPRCcC2ObwCHjpZTIWMtYmiJwXunkLZJcS7Rbs6FALNSj7HOrvqES2bM67S6E5G5pA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027469; c=relaxed/simple;
	bh=n2cIAllNT0nJjeJo4jRL99c9rKBr+TN+8nn6Te2jgdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TIodJJXzcdQ1xcS4+CawLgPdFAelMY56SdUOHxpF7Mp12iPs8C3Y7SyCEBwuhKxBEkgDO+ap7mVwroZDid5fCR2KcOqTSQHny3D5EGZcS+P9Jv3NlOhQSECysklSH7y4ui+xTADa06Zqq9EqWHu/9VWp5hRQZkG0umMLLxaERT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bG+GLMjQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iE0p+so6; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bG+GLMjQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iE0p+so6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A7fQEh642349
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:04:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aVp2PxzSnF7Gv7LzU63KU8e1fXCgBNRP5Ip5W98UZ/I=; b=bG+GLMjQI0EG20Hy
	Tov2ZyBuFIc9E3tY1Pv/8/9ZNF+VOsf9hC6x9i7VzXMpqnLAmwpiUc6L7l6Zs1Oi
	x0yObXVDkt7gg+zCGeWa30cBk3HhN85gpyrAIppbEP8Jou7Eb0yWC8X7fHcErZMn
	r8lVqfgdnjUN+Uk7NNpG9V4XQTuIYx0CTodGSr6hFzagLxqIavdlNc+Z1YQLuwnb
	ZrRzZZNP4rF0+cfAEeQV58PTROM3De6R9nK1pZ8TjAHHxYmPSbRKInStQznQM4sg
	B2zrksKN7CU03Btos/pwAxw0HTji65tNaBKSQeGrEiaVZQkNNFd4fqqwVnjYisJM
	9EyOQg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrcjr2qr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:04:23 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-936e393061dso903876485a.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 01:04:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789027463; cv=none;
        d=google.com; s=arc-20260327;
        b=UBoQ2UIbBjfpTwHFEMsNObap96GGlPt2kWnmgGShJ6XeVoCfDI0mbJA9ublb18zhab
         wL0sHFJfZQGh6KxpV+q3aqkDJNWErIrfYGuZszaxAuYtxUlhMp2KN9lwj9DuLYMhctUG
         U8NFG7mYPjegSEQij07kLW+rwri4tfrwy3BerV3NX+xHRzg33EGNp3v06GmhV96Y6UsI
         NZPH3wFyJY1ATJS1AxNTWfXFFIQZEH1LQvpjzSOmcDKqD+ep38eca1ds2EEhG57laxa+
         s44pZ03UF4rNwX1XLfrZ7Q8qKzhw2oraTosHhwO49kNjgyxHAYSE9yWKqsjBQ9ZV7ab+
         ZHmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aVp2PxzSnF7Gv7LzU63KU8e1fXCgBNRP5Ip5W98UZ/I=;
        fh=joi6FNuQUE/z4ERbAs4PUEU9G/C/K7gCEuLUOThVQt0=;
        b=lIjXW8JLVRxe25ZJVFyD58btUHhCkKJkxle3gm38NTnbjlw/44AjfMAGsyhvXvGWET
         UV3KImTLuxfFtmkpbqeUgiqpcJ9Tnc3Qn+befJfuG7ibiE//xvwTfkZ2udP7jkYZchZT
         H1ghD8fc2EmfHol5JEOUtEfKge4EO8dJtHd4I2Hxct2njkYSNXaJkdrSNWzJAi8yDvZj
         viqLyQr5+AaevcmCBnNxfx74D3Cr92Xuy9WRiOo2hQyjlOPzeuDDMj9eFUBvCFaaN+QK
         GSPztzL059Zt9tJnr3W4QYC0cuE7wPyY/3ZQuij/NLq+lmKrQXuGjFn7InpjC5EDOsIr
         m9QQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789027463; x=1789632263; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aVp2PxzSnF7Gv7LzU63KU8e1fXCgBNRP5Ip5W98UZ/I=;
        b=iE0p+so6wiIQg0R8Q6dZ5GXpgRnsdE9jrkLUlWbXPGsHtky7EwCjRnJIySDxGgiOvl
         2PCg5cfssqs150iZlErXEtWKr9e2OjaTDWx84/jdenkAx1W5NvHaHJQDaypX5rKrkXYw
         rVirDIfSvyY8l735STRiHVwRhkjvOhEQ08fIuAyN+WUBr7goU0wUL3J0f0Bn6qVc6hjy
         HK1+x8Lc8vSBEWRedqSV5GsSznSqORdaBCdBXB75OPv2ZDXl3ifXlGqBmsoCeelx+g/b
         EOAdv0t1vFzoqlpE9LGhQHPnANEepo5XzTzE+Szgo3SyycOLr7j271O+9FJJkAv2AiLc
         AjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027463; x=1789632263;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aVp2PxzSnF7Gv7LzU63KU8e1fXCgBNRP5Ip5W98UZ/I=;
        b=KI2CGtWkY1EMRly3QmgnRQn4wOIoppMUnEijkmvuZt3g+QQnhu/ReOEizaS7Ci+Ak+
         e5aNIoEEAiukGblWQVkxThEvI4vPJ6LB4x9247/cUHQ57DWwbFtHkRSEJJyiNXleuQNJ
         xpbhvMfcid/EG27kcsv4C+qntypBce1xGkiwVHw2GTdedeB7zCX+NkqLjbrAVBGnlQEA
         hSl08SgZtk1aaHPjwSdRuZZpN/Ae9WA2MYKLjIEnUALKOwBfUKjD/1u83FmOvj3DvNKC
         wTiPEhR/6X1jTezF3bu/0ctZSvMKBN/+SK8PXxPkJReowcSjhfX1NYZXMOYxoRYUC4li
         FqYg==
X-Forwarded-Encrypted: i=1; AKwUvBy4RQnmjpX1gv3Fdn1qopodNBKHpvEaZK9abOR51OKPMXawbnoC+PSAD8/lhBPB26wDMni8JZhfuAlsZa3R/Q==@vger.kernel.org
X-Gm-Message-State: AFuF++me17gmWfGDtE9svRjm76a+3FvUpXab5vcyC5iVtSAhAzxzDIT4
	smhHgqPkVMGuYP3/bAGivIL8r4p4DtFQ/NVoO+XQTXjgEey9EeVM3tLlEkdDPRM5wt67LHEFYhM
	U2npm7nrt2Yjdx71EnsTUUE7gTh+OR2KMYY7dI2WfEDHrRVNWV3uSuH0nQj0/BRVKCZKlcMe5Qc
	yp/ukZkBPvq6BKYDeVLLNMW3sdtyxmweKwBUsX+OzoRBpb
X-Gm-Gg: AYBFou3TOjD4+myjJq7oRwdRrAalPg15eoNH2xzIEwo79FBVEdSkhZIfGZrmMBUTLOo
	GvtNfEuPZOgXQ7B02UGvE5yD9Eb64Xc1DUtSuV8oPIkzW8rv3Oiwoi+SBzJNsBTWruW+TYpWWKI
	xVRqfDGpY0fgkOYGVvenbCQj2vPhWVjfw57Ein5Ho4UJzO//6qO0KfIqTZW5wC24tduK8c2FS/6
	DZ79ADO8U07AePnOtrGli+ZNESh6YpGVkERoANmb+jTGk44B+vGy9RC2ROqiKzoIJaxpZmSJ+SF
X-Received: by 2002:a05:620a:1599:b0:914:e3dd:17ea with SMTP id af79cd13be357-93980370680mr3042396085a.12.1789027463134;
        Thu, 10 Sep 2026 01:04:23 -0700 (PDT)
X-Received: by 2002:a05:620a:1599:b0:914:e3dd:17ea with SMTP id
 af79cd13be357-93980370680mr3042393285a.12.1789027462644; Thu, 10 Sep 2026
 01:04:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910020907.3353-1-fanwu01@zju.edu.cn>
In-Reply-To: <20260910020907.3353-1-fanwu01@zju.edu.cn>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 10:04:11 +0200
X-Gm-Features: AcwNN1XDyuOipdnNBvvPi8Yo7bvNwffrtxCGR79cxsQpnJD-rHw3MyeoNLhKK6w
Message-ID: <CAFEp6-1Mza3_1BQOORT9KsYF1ExOnMeDY9rb2gSvQmzeMn2vAQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: wcn36xx: Fix potential use-after-free in TX ack
 timer teardown
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Song Li <songl@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA4OCBTYWx0ZWRfX6m5PNF/lvrw+
 vkyMu+qyR0X2h+FIeXRGvKbptkVxd1e9tF+/XwH4pnFufRRCpVMmycjyYhWlNs/zaM5cReOn1z5
 GeXlwT3SrPfzqL5S4lHieXTPCl8HrAA=
X-Proofpoint-GUID: SD5ZIKNsrZRfM_qxkKw_kHBZFy-GeWIh
X-Authority-Analysis: v=2.4 cv=aef0Dhot c=1 sm=1 tr=0 ts=6aa26487 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=OIB5ShivEfEboS5j5kIA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA4OCBTYWx0ZWRfX8D6wXd03AJX+
 NI8euIqTmQh59c8qWnvLxSbJRkY/mK/M646lD5ju+CoNuAuZuLsKgo4ADAhDzCSUSWDIrN5A35A
 CZjf7xh0AaIM8UkewGOJe5Y4L4v8MvBMKUGoIqOM1Q2i7DCp94OuiatG8cGGkBAtdqm7jG2sb07
 bQnQunj+j1kUDszrJJRI0PtzOq2wqrYtqNjmoEyprvgnolT2MfLIcgEppiK/RhewUbHD5cSOQlQ
 HU/imBnONVwj7jPQFgxLQ9HMlpEofHmIGwMkY8LLQRxC7Q7e94mydbujpHCZsXUOff1HTvMLDCT
 5un1DnOlf6tPlNKjU9KaoheMNNRouyzHJRZZcxVIwB545k/V8yaAg8YQAe3rknyBspFsr+Oojf/
 XkwmnZb83RKvbacQKkWp64eWGwnEanteA0faExmbL8t+ipVuUF1FI8VNS/R79FKkYc5NgbYFgqn
 r8MN02/irZzgPKIAM4w==
X-Proofpoint-ORIG-GUID: SD5ZIKNsrZRfM_qxkKw_kHBZFy-GeWIh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100088

On Thu, Sep 10, 2026 at 4:10=E2=80=AFAM Fan Wu <fanwu01@zju.edu.cn> wrote:
>
> wcn36xx_dxe_deinit() tears down the TX ack timer with timer_delete(),
> which only dequeues the timer and does not wait for a callback that is
> already executing; the preceding free_irq() calls synchronize the
> interrupt handlers only. The callback, wcn36xx_dxe_tx_timer(), can
> therefore be running past the teardown and use the wcn freed along
> with the ieee80211_hw in wcn36xx_remove(): it takes wcn->dxe_lock,
> reads wcn->tx_ack_skb and passes wcn->hw to
> ieee80211_tx_status_irqsafe().
>
> Fix this by using timer_shutdown_sync(), which waits for a running
> callback and also prevents the timer from being rearmed again. The
> timer is set up again by wcn36xx_dxe_init() on the next start, so the
> start/stop cycle is unaffected.
>
> This issue was found by an in-house static analysis tool.
>
> Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6
> Co-developed-by: Song Li <songl@zju.edu.cn>
> Signed-off-by: Song Li <songl@zju.edu.cn>
> Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireles=
s/ath/wcn36xx/dxe.c
> index 44020ec26..801f1218e 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -1055,7 +1055,7 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
>
>         free_irq(wcn->tx_irq, wcn);
>         free_irq(wcn->rx_irq, wcn);
> -       timer_delete(&wcn->tx_ack_timer);
> +       timer_shutdown_sync(&wcn->tx_ack_timer);
>
>         if (wcn->tx_ack_skb) {
>                 ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
>
