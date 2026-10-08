Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE053E765A
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457366; cv=none; b=SOEXs+hNnXh/UTEQJa8RmRR8Mo/8eJMmKPYPoZcdK6taFt6SqF2ncsBTyZMSVT+cyb4cBE7+jVV46oDoD0gcShMVNLUbS+uK/G1TWG/zLIA9vy3ApELQsMVlgjFiYjTC1nJ2OUV7Nl6afpv6C4cK64/gCatUuRAtMwfi7XobDCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457366; c=relaxed/simple;
	bh=dO/pgusH/Z26UWYNXK0zqHa1I5a6vsumMkoLMtV6gZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=abU4rYNjAdH6p0YaVQfh4XGPT7LjEwH3w5TglqDAjR644pYNWUG++i43RdQH7GD2qhjmqcOdnZ2lk0NSvJTQVA/95PbauKfYEfz2uNZiu2EP/1ANutao0QTGQA+8k1z0FbPoJY9ycmCc8kJasWwJYyxKX+2cjac38JHT2mSP4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GJd8CGRM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z+6yOpG/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GJd8CGRM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z+6yOpG/"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698AbMvr3129076
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 11:02:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6YHQnEULCZieeaLxdgJmpoPCPlP2is0QYfWrbkAwUvY=; b=GJd8CGRMdgEPoDTA
	LcP5RdfpB7vD55+ZKGi7XWh7XfLoB1+NYKrSHuCRAyjhSULl4WUcjkK17UlXFf2B
	gibqAYi+wkhvphiQKCRIxPkHSZLveoO24La6gemjemAL6mOIghc90zS/VG7hZ92X
	Ru0ER0/CjkXNl7x5t7ZG9JIIPX/n2JVu8lalUAvNZqnnGoltR8M7cOrgqaQSnP4Z
	Gyz1yTNQTKOtz8ubKUsIRv1NEZgCj0rvs9fp5JVbsx8H8mvyibaENEveJo2k7yee
	xvxmYhG4eybbG6E9IGhEYOv/m9r9k+1xKqdN4CUjulNVkakb9cdLOvTCVtff8Pf+
	ilZrUw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe42kqd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 11:02:44 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e80ef3e0a3so7759135ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791457363; x=1792062163; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6YHQnEULCZieeaLxdgJmpoPCPlP2is0QYfWrbkAwUvY=;
        b=Z+6yOpG/VHDLwy6yc4HHvPrYYEBscgc2+vxSa9EnYSzQfWgQr1Ay4cr5B0B1QlBhy6
         suiqVuFuJl7BVOBPbe+PgbyX60Jwh0YyyTVEvWJju2nIvhKULHtHST+iSkifNmr6bdZI
         cVKuZ174nUmhegjdAYUCpJIM5IqX8XrFn3TnyYYoKD7AMkodRxydTZFR/T0cFatTKX2F
         njwZonTxr8k0SEj2dlkPIkaeB3IwaGPckPBVmc6GE8hXKy5NuEJ3Kas0TgR9bc4bubsc
         Q1xVp5GeuvKwe8fLf0Au+HbJoZeqNaDXTTZrqz38V5L9EoOsFQjG/G81FC3WxIV3Iblj
         MkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791457363; x=1792062163;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6YHQnEULCZieeaLxdgJmpoPCPlP2is0QYfWrbkAwUvY=;
        b=Bxh0kz/jfPaHG82YacTO6Kkb17Chh9luN+LSbv8dO1t4OSEGVhD+Tplqg+8agE7Eqd
         s5ugFg/40EdAseFXj2nx5He55r18qNEPUzrctlCSUf0sdONj7AcNimDNr9DAKS3wR03O
         76FUdMARl1OO1o+Z4vM2F/tguRutJLtHjDTXLCiqJN3TlLtxFF6RZKgeS68xy8XUmlgd
         1C0RQboYr98vE6IkxJPo6ybQ1JE78cJr0TH3DhJMlZcH4XWZDlZButo+KAnoS14tWVOP
         he19hLXfe0+DgSaVCqLt63YPWBsDv4znai5vwE5r5bVLNGq+ZGFc9g6FUpAqq7Ugkxag
         Bc8A==
X-Forwarded-Encrypted: i=1; AKwUvBxDfcQVy6X26mUznNZJR5hmHx43tIEmwig973nLsMJuGh77RHMKWV2CczJddB/5rBZ/j5n5kIcr3i9SD8YJ0g==@vger.kernel.org
X-Gm-Message-State: AFq9FYKLYd/l48L5ytV4jkAXTZQ08NY2pcwz7QgyU9+s+hQW3UJAgARP
	1LYHVRTN+BdaW163sdjWISlP7JKWJ4GKfxud86uVcgE4zUGFbqyOip8idKHshLK8HffPRSyUuKw
	LPepsh7WvRNH5MVHvv4pXkRh/BG9TVQkyru5twQeauxLzEPQQGX0wZ6WQRD280d0f4grXvyomtd
	KYS7lX
X-Gm-Gg: AYBFou29YEGVaNf7QrtIPvoXTkNqYrlKNluEknT5tsGuocBh+Ep4wdMCWLI2I/7vVPn
	fpu87v8fYHSVk+HlWFZlYrKfWJUW4xCzEXpSD+kvsK6hXVafS4o/czvr5Ko9JOYxJzb7PH0PxZC
	HAPaGe/Hh6ZqZf9z70y0UOhrK00MMYerHJPItQBiXS5WFT3YsOYDJyYta606Kln5+WkSuZ1VGvb
	es86KXxgjMb8a/8h1Srv49xzgv4+WJMLIoM00n4wLlnDoQoWrudR4YtR08qZssk9F+JGplXUP+f
	yofnxrEFXL+i+OmIaNXDpBJ1PUOJdmLG4ODu4CDcNmPrccMVbfQG11rqIyD8dexjnO59rSlUE4e
	e+uxlom0wziEpb8wXKNBzjIT9HD5oag/vzIS1XU+SA1K35akByfjmhPKMjijGCWujqC4qQlg=
X-Received: by 2002:a17:903:2c8:b0:2dd:c053:9c70 with SMTP id d9443c01a7336-2e6004f2a86mr45269285ad.38.1791457363092;
        Thu, 08 Oct 2026 04:02:43 -0700 (PDT)
X-Received: by 2002:a17:903:2c8:b0:2dd:c053:9c70 with SMTP id d9443c01a7336-2e6004f2a86mr45269055ad.38.1791457362639;
        Thu, 08 Oct 2026 04:02:42 -0700 (PDT)
Received: from [10.133.33.26] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604437bb7sm22753685ad.1.2026.10.08.04.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 04:02:42 -0700 (PDT)
Message-ID: <c3564de9-c228-429e-8e04-3ff65619d1fc@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 19:02:38 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath11k: release peer accounting on peer delete
 timeout
To: Michael Pfeifroth <micpf@westermo.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
 <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
 <arTp/9A0iMNpIhl2@mpf-ESPRIMO-P9012>
 <8bc3eaa1-7233-48db-a41b-ce3f08fbdd15@oss.qualcomm.com>
 <ar0LVqHZF8UlRB0o@mpf-ESPRIMO-P9012>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <ar0LVqHZF8UlRB0o@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 7MdJcJVN9en6wdPAYZK8M5pcxrXS5pV3
X-Authority-Analysis: v=2.4 cv=AbwkjHXG c=1 sm=1 tr=0 ts=6ac77854 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=URxyR80WDTEKk2XSxLwA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MyBTYWx0ZWRfX4OPHM2E3rutL
 BAGjGf5fEu9WgDa6LlX4mO6MRd+59oANq/WTHxES2fdw4rouP+J6PFCHz4ZvmOWIAaAIILQPKKP
 cmQVnJHcs1R2n+whr8LcLJYOSlAYRys=
X-Proofpoint-ORIG-GUID: 7MdJcJVN9en6wdPAYZK8M5pcxrXS5pV3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MyBTYWx0ZWRfX8CxmCRj1A4Ip
 /ZbS0R5CyY3UaY8J5c3rtRMeL4ETI6fU9QyYMN0Sdd937bgc77JD2DhHaGE1ztouMwmj5Ii44Cu
 /jFyTncHuXNufUiSn/lrEaLdkx8MwXb93lo7HYrQRXWujklkQj2JozkoX+JW/mTYIhFw2nop2w8
 PdSC44GbivIzMU8xCgK7d5DySf3RIuKkNHg+GwV0ayq9iEPjSZGW/eD/vymxRGhnksBTLby+ZNl
 Tr8G1pMLVFJxUD3JxfIcmm1cMNu5TUhOgaWbpHyMyn8xJ3nVfVX/7sXNWr/wOhiZAsJRxpqji3F
 l9bUumYciOLNYPVScyh8uwXmA3sukmTgzdlJvPBurhD5gd/BSxKOnvf1ChYT4vb1xDPUm+uZCxl
 1Nj9Vv1IpWPasjg5ZCRpeYbGNTKI33eX3CJcfh76hdnTAkg6/ybkiTks0nIdgcEUPQXqse015zY
 cNAgdClpXWCcHynb7Cg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080043



On 9/30/2026 9:15 PM, Michael Pfeifroth wrote:
> ath11k_peer_delete() only decrements ar->num_peers when
> __ath11k_peer_delete() returns 0. On a peer-delete-confirmation timeout
> __ath11k_peer_delete() returns -ETIMEDOUT, so the decrement is skipped
> and one ar->num_peers slot is leaked. Once enough slots have leaked the
> ar->num_peers > (ar->max_num_peers - 1) gate in ath11k_peer_create()
> rejects every new station with "insufficient peer entry resource in
> firmware", and the AP stops accepting associations until the radio is
> restarted with a wifi down/up.
> 
> This was observed in the field on an AP after hours of uptime with
> frequent roaming and reconnects: clients could no longer associate even
> though the firmware peer table was not actually exhausted, only the
> host-side ar->num_peers accounting had leaked.
> 
> The delete-confirmation timeout itself is otherwise harmless. The host
> first waits for the peer unmap event in ath11k_wait_for_peer_deleted(),
> so by the time the delete-response completion times out the peer has
> already been removed from ab->peers and freed by
> ath11k_peer_unmap_event(). Only the ar->num_peers counter is left
> inconsistent.
> 
> The timeout is reached when the peer unmap event arrives but the peer
> delete response is missed, e.g. because the response event is dropped in
> ath11k_peer_delete_resp_event() on an unresolved vdev id (logged as
> "invalid vdev id in peer delete resp ev"). Do not treat the delete
> confirmation timeout as fatal so that ath11k_peer_delete() releases the
> ar->num_peers slot instead of leaking it.
> 
> Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
> ---
> v3:
>  - Drop the defensive peer list_del()/kfree() branch; it is dead code
>    since the peer is already freed via the unmap event or on recovery
>    (Baochen Qiang), leaving a minimal fix that just ignores the delete
>    timeout.
>  - Reframe the commit message around the field-observed num_peers leak
>    and the resulting station association failures.
> v2:
>  - Correct the root-cause description and switch to netdev comment style.
>  drivers/net/wireless/ath/ath11k/peer.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
> index b30a906..f573a2c 100644
> --- a/drivers/net/wireless/ath/ath11k/peer.c
> +++ b/drivers/net/wireless/ath/ath11k/peer.c
> @@ -340,9 +340,10 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
>  		return ret;
>  	}
>  
> -	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
> -	if (ret)
> -		return ret;
> +	/* Ignore the return value: the peer is already freed, only its
> +	 * ar->num_peers slot would otherwise leak on a delete timeout.
> +	 */
> +	ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);

as stated in the commit message, the purpose is to ease the case where firmware peer table
is not exhausted but host's table is, however the change here is to ignore the return
value by default, regardless of whether firmware peer table has free slots. So what about
ath11k_wait_for_peer_delete_done() timeouts due to firmware peer table exhaustion in fact?

More importantly, host rejects new peer association only after the

ar->num_peers > (ar->max_num_peers - 1)

But if we really hit it, I would suspect something wrong with firmware. So even if we give
it one more chance I don't think we can survive in the end.

>  
>  	return 0;
>  }

