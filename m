Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2224032D0EE
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790234993; cv=none; b=SuHwH12/7GtM53Hhsq/QDuCZB6IrqRBf77Vaqh3iXsvnM67D0N6/X0LvxPrqBflFWoPXzqVtbAeDQnpT8dNtlJQrgJdWed6GFlzd2PYpVhrvrqHv3IJWLT7jjK1eyOlfwRj0Y9sFGEiUTEr4jJhmdvw093VEe8tnDfwDvkrKW9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790234993; c=relaxed/simple;
	bh=ka41AY5wPkgiv+u2gAmzt1B//hBXJ2by8c+kcAH7Y3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AbRhaMPggc/Pm3xKfUryrTHGvg7YAypGtBoc58PC311e5hkrFG0WoPLx5uCt36eXQjQEilYRQhST2zdlQGmpTU5EI4GOqQZhhHyWIFcIi6+HHmpM1Ha9LaMxeLjNJQ7++82QVkByuBMCDJ9cQFryyIM4egw7hlmdUlWTtryA8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cFmHdydC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B9YcsG95; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cFmHdydC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B9YcsG95"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5e3fc567355
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PZpJd58Xrea1rr2Xd+B0/MS6diNyFofiT/eXYkhyMs8=; b=cFmHdydCAZ9ftuWs
	fMiYEI6fLM/zJ7VOGtX5zHCBlh1ZAwk1nQxZpzkyhNont0eYdJxRkx2nT6DsWnmU
	RuyJOlZKqmEKxA7XLxQYTXIeHn+B4PMjgFje/pf6VgIiughPK4wjgFbeYjqLxRgK
	XL9R2RTV6g8cDi7rgf4t+ufD5G4y5lm9jmtdDtIXWKf6hQQACQ3vCKuVsWSIvenE
	EScptT3qdT/e/zvhyUu2bhf8kM9Z6LroXXrwAH57gWUEUtJh9LhHWSb2iWZ3DkBu
	RKWilnUgB+0M/H5cgmC3Gm+nvJvIRTkPd3oxcnRWZChaw2dv/H7kzq5XWNvRWH3g
	c/uVog==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvvgh8puf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:29:51 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398dcfabbf8so4016758a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 00:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790234990; x=1790839790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PZpJd58Xrea1rr2Xd+B0/MS6diNyFofiT/eXYkhyMs8=;
        b=B9YcsG95DoJJYCfMplHyu5UXisRHhSUU8eEfvkcJp3sNnVDby2INwLVsejo7lMUY3l
         1UI8syVI3yphc+X6m31zdz46kNqEFEr88oqeaxzeUJL+Eg408I/PUKFXlCp0ybU3t9bM
         +Sq3ecOgVZD0gjDLQEdPUzwka93JfNG4UtWN0rbL04hi8ECltusRQmwx3G6dKY5OsTL1
         1/Qc4xuQvhen7jyvM3NxeWcOe8UEReEcZ9pXdRwI0D/M09ynLOxKFXgmm24zXyLKl061
         TjCgR0puZF5DHQBOs0/r8LKDMQhEaOmpAmdXIxpPWc10jVrHCapuaioJxeFWf8kuk9NV
         LmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790234990; x=1790839790;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PZpJd58Xrea1rr2Xd+B0/MS6diNyFofiT/eXYkhyMs8=;
        b=uFZKMQxFkDGW+HURhmWD8Xr+hb8tC5RB/c5T2BgX7WdkF9X42EXjNidCd2z7mdYKqe
         cSIJ2+DKypEDpmpjQXY2qX80hNG5GRRkB8qyuwFS0KoGYKKwTrAMSx7MC8MGkgA7/lAQ
         sKYFXCd0jM96m+DdVNH4SDqDo01zaTvb2bLwLwF/Y/MaUXo2wmL7nbVBnbSj/JiTciPz
         XmaUXkHKIxjQ+xM2P6GfJ8O5NWqM6rfuQ3P70Wpro5H3HN7VnC8FfaTTevCX2UbRF2qr
         KsN4VSqlsoC3UWY/PUn7SympsMmLqzi5xP9YE+XVNVc6RJqJ9ZdPVr3Ns8EVU1K0ND5D
         x2Fw==
X-Forwarded-Encrypted: i=1; AKwUvBzCQ0aW2vSlbBd2fz57ZI0X1DYSfvCYH4Nej0n99kKptJDdL4e8aSGgsOIuVrVML39D90UPGRtmxYrULkR8Ag==@vger.kernel.org
X-Gm-Message-State: AFuF++kCxNuPLdLx66PjfjFFXToITTRX67ad5EPQG8JiLfKu3nZOg//p
	NSTlpqunqj2RnUCUzukfKshhmoNvirdq626d5Ny5ReBV+puKBXS7E5c5lg+I6HKfxvw+FJGmQ/C
	U3iynsZtYDXogbLI51A4Z0c2Mo5CHXmCIBZ7iNew8K/ZDIbuDTtsoEaytGwurfQaNcwqvQw==
X-Gm-Gg: AYBFou24kEbjKNcyXjRJ82rbGLlN6eZ8yI1HrQy7m4dpZVZP8YpLGLwFQbTh3JXEFRx
	PoJEosFwk99RjqE/mVwZTOGKsT9Z9Mm5pTaGbSHlKP95nJOw36V3SAcjBeq+EBJ+32fvnt486To
	rk5d/CpJJX5aWQ8kh/WORKAA3nPp/kf5YOZKtgr9v8KTB9erazJjhsUhbwFt1PjOvT5gynzI5iP
	ow52HhWApqJvWO+93EuyfGvnxKEq3NWNu+UHzXCCozpO/NdMt3PhitBRxx1La36xACnuEM8ZDbl
	DfiFkZx1ny8ROhR40TxRusyZdjY24clRBKonuT8dWd/H4Y+mxnZUqWwn9Yo1Z+sgcQ/lbH924gM
	gWhzzgNZFRXN0s/TMl9asPTeYT33//niualEkWJKcobRKjw3r7+Fw8jKzsc+dib8/mHhHIggE
X-Received: by 2002:a17:90a:1090:b0:3a0:9c23:4d67 with SMTP id 98e67ed59e1d1-3a09c23506bmr802199a91.66.1790234990315;
        Thu, 24 Sep 2026 00:29:50 -0700 (PDT)
X-Received: by 2002:a17:90a:1090:b0:3a0:9c23:4d67 with SMTP id 98e67ed59e1d1-3a09c23506bmr802191a91.66.1790234989718;
        Thu, 24 Sep 2026 00:29:49 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0974ec5c4sm3137575a91.5.2026.09.24.00.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 00:29:49 -0700 (PDT)
Message-ID: <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 15:29:48 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: release peer accounting on peer delete
 timeout
To: Michael Pfeifroth <micpf@westermo.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KYhHIgYD c=1 sm=1 tr=0 ts=6ab4d16f cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=oZ_nePzMtAqFXnzSB4YA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-GUID: vA9sUEXicxmOXmQrVytsp6GggNXhFm8S
X-Proofpoint-ORIG-GUID: vA9sUEXicxmOXmQrVytsp6GggNXhFm8S
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMSBTYWx0ZWRfX0EwhqzXJ1y1p
 dfSuX3z3qlmXsjwBKgCp2sQ9nvaoGD8j8QAGnCw64OFtg+6GbV16DpiRhgMFnngw15dlLc26XzH
 x8Db3S/hXRK/A4qNjD3fzKo1Qo6L44Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMSBTYWx0ZWRfX49P+LohwV+Af
 S9voIcSgN5+uT2S7TC8MAeXnRs423M6zyVvlfyUY5/5/syjAxiEvgp1XQbD/FoKr3YZjMzHv2vg
 W28y/40zXi6LKXv+3RBr6rnSjn9UR8w9RFw6Ng88irxjBy8JDh+GVXVmFCXDNejaklyACB1W2aT
 8xpc9nMdDx/QHRl5d5J/QOvu7qfHjVTdAv/zPl4ytMMrSVzd7K76Bll08nclsovz0r8u/qlHTPv
 Dk+MZYXEgJ2SNqPl3YGRLJZk7U8b+VrvMdo84ZWcQLAkmryaWEv+byOCaOpAOO8rLConYYTD5Xv
 rAqf55v/0OgZjpV2wOhk44iAVyPeLA80ih+3UMfUXgPja9qQlSiS33MXpCDEyBAKLcytNVEV3te
 12EB8yOxY/LcT1WjbQfqdtBYtDyuXkY2lOK5UumxOYucNqScV5Hb4vcYlbrPqUq3J19khmy9xKG
 TT58aNDqvDKcmUmK+dA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240031



On 9/22/2026 8:25 PM, Michael Pfeifroth wrote:
> On some deployments access points intermittently stop accepting new
> station associations after several hours of uptime with frequent
> roaming/reconnects. The kernel logs
> 
>   ath11k_pci ....: failed to create peer due to insufficient peer entry resource in firmware
> 
> and hostapd reports "Could not add STA to kernel driver". A "wifi
> down/up" (radio restart) on the affected radio restores service.
> 
> Despite the message text, this is not a firmware peer-table exhaustion.
> The message is emitted by the driver-side gate in ath11k_peer_create():
> 
> 	if (ar->num_peers > (ar->max_num_peers - 1))
> 
> i.e. the driver's own ar->num_peers accounting has leaked and reached
> the ceiling. It is always preceded by a peer-delete that timed out:
> 
>   ath11k_pci ....: invalid vdev id in peer delete resp ev 1
>   ath11k_pci ....: Timeout in receiving peer delete response
>   ath11k_pci ....: failed to delete peer vdev_id .. addr .. ret -110
> 
> On such a timeout __ath11k_peer_delete() returns early without removing
> the local peer object, and ath11k_peer_delete() consequently skips the
> ar->num_peers-- decrement (it only runs on the success path). The normal
> free happens asynchronously in ath11k_peer_unmap_event(), which never

Hmm, I don't think so. host waits for peer unmap event in ath11k_wait_for_peer_deleted(),
before waiting for peer delete response. Since there is no "failed wait for peer deleted"
log, unmap event is good and ath11k_peer_unmap_event() runs.

> runs when the delete response is lost or misrouted (e.g. because the

what does 'misrouted' mean?

> vdev is already gone by the time the response is processed, hence the

I have never seen it, but yeas it can happen theoretically.

> "invalid vdev id in peer delete resp ev" warning). Each timed-out delete
> therefore leaks one ar->num_peers slot until max_num_peers is reached
> and all further ath11k_peer_create() calls fail.
> 
> Free the local peer on the timeout path and return success so that
> ath11k_peer_delete() releases the num_peers slot. The peer has already
> been removed from the rhash earlier in __ath11k_peer_delete(), so only
> the list removal and free remain, mirroring ath11k_peer_unmap_event().
> A late unmap event will then simply fail to find the peer id and log a
> harmless warning instead of touching freed memory.

As stated above peer unmap is good hence peer is already freed there. The code here frees
peer only when it indeed not freed.

> 
> The problem was reproduced deterministically with a fault-injection

curious what the patch does? does it modify ath11k codebase?

> patch that forces the peer-delete wait to time out: after max_num_peers
> such deletes the AP permanently rejects new stations, and with this
> change it keeps accepting them.
> 
> Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
> ---
>  drivers/net/wireless/ath/ath11k/peer.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
> index b30a906..ed2d7d8 100644
> --- a/drivers/net/wireless/ath/ath11k/peer.c
> +++ b/drivers/net/wireless/ath/ath11k/peer.c
> @@ -341,8 +341,20 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
>  	}
>  
>  	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
> -	if (ret)
> -		return ret;
> +	if (ret) {
> +		/* The firmware delete confirmation was lost; free the local

ath11k now follows networking subsystem comment style and it prefers a '/*' by itself on
the first line.

> +		 * peer here (already removed from the rhash above) so that
> +		 * ath11k_peer_delete() releases the ar->num_peers slot instead
> +		 * of leaking it.

the comment needs rephrase to reflect that peer delete needed only when it not freed yet.
> +		 */
> +		spin_lock_bh(&ab->base_lock);
> +		peer = ath11k_peer_find(ab, vdev_id, addr);
> +		if (peer) {
> +			list_del(&peer->list);
> +			kfree(peer);
> +		}
> +		spin_unlock_bh(&ab->base_lock);
> +	}
>  
>  	return 0;
>  }

