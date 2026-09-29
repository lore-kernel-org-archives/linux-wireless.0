Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742540EB80
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790662748; cv=none; b=rR0pTp+LaqPbi0YM4VfYMRtUuanD0dubIMnW/tJIfURYRJZ3Ir0Le0tuwIFe1NElbNaul7y1lQGDYN7e3jO4HrsDJpRX085l0kYN0r4XujEfeCpVvjWWc5xEwv7DEde+OkVHWQUAnalhdtfSWlGWIDGi+BMzMlz9A8kggNRcEkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790662748; c=relaxed/simple;
	bh=FTf9Vb7KphCpDe4cHzJxthpV76mxOjoPZUu++XaTJe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUfVRzeGRvRhu9fOb75bAwD4Uw6vSjaI0l/GN2GwTVALif+7/WLmqFgqEt4njhUwia3T9Acx3OihHvRUnA/ihkCNlvsKLaj4Tdz40e/O4eWitrahDUzNNE3DHQsMKjKbvo4J+FcHlT7yiAZuAmCi2RU/eMOup1XqxObRgMsN5sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TzGXeELC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fu2TA9cd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TzGXeELC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fu2TA9cd"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68T475Qp3390850
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nsfWSASI7pHCuHAaBzrLs2MOHQ5m4idxUR0nJeO1FRE=; b=TzGXeELCp0T303qK
	jr0zkA7jjpxQGZgHUZ9IKu5RcPMIAI7LMU2+xhgvv+yx/vVmvC6fguDYrQEzyM5D
	Caxq211k6nuQDued1tnj5yDToB/fDireLDjfqxND9wJhG4KL3uHd5sCduXYjOvIc
	137sbECpggMv7i/WTUc/qjHHmBrv+SdiWEk+nVPDSYEc1Fcqz1jSwE+J4B5NxLkZ
	hZkYG9QW/eay2xT3PZOh8gxny72RbFwweWap/9dc0BKfdP6NVJSEVQOATG3JKNv1
	8s7ZPsNJvhJ6CkgnT6Roam9saSkBdNpmnY5kU/EDxqdJJ+3NAuYsGjE5LCyGWpgf
	cVNXxA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h01vkh901-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:19:05 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2df5a65671eso6448935ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 23:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790662744; x=1791267544; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nsfWSASI7pHCuHAaBzrLs2MOHQ5m4idxUR0nJeO1FRE=;
        b=fu2TA9cdHpwfcxmtxr/7NVLN1SKy8v2DgGs/kJp5Nb1HFRCPvw5/DXn7melre97hCj
         XDQ1btX0Cbaw+w8PTolhsKjdttGFwHGvl8crqOaek5ApRPxqExqxPXDPIEC921DO1Vz7
         pt87kHlXf8ohJqvj4rlfoPL5k8cgK33cfvCR22bUfA121UoirW2TklSq3atI/36gH3zF
         Ch6+sBzKDiX9mvLgGf3OlITICWT04E6a+bppzc/n2IV1ViCvPxyrsg14ztKk+ODhrgVo
         vE9txB2IkXAnsqVn5H3QD2HiDqLyX33YStXX+FkYDMOdqlBTBcLBIeW9zPjC4jj3dytQ
         eKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790662744; x=1791267544;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nsfWSASI7pHCuHAaBzrLs2MOHQ5m4idxUR0nJeO1FRE=;
        b=u9jR8dBTY9LF30deY3UaVJODVS69tHiHj6LDmkSpiCJ8mHNBUj8S3LIBISXV12yNmS
         Bj+S9NxnscrxAfDeoeq0kM0vUQCAAceGv9aP2IsF4BecvoH2RPmrtaANyAtym66l7WFs
         SMZPmRXpJMUD84w/eKQGeWtpSF3rbc/QKKtBSXlCyanPhgp9X9UHfOvp+h/bWFkmC1+D
         VtjkS9h6Athog6JYpMs+mqfqqBjndJB/bfSw5Plyki5NpqE3J9oUmchEK44ZjrgVyv9G
         Pb3x/xbKpov6ZwQeX0BAmvjpWKeY9vHCpruavTx++4aUqDvkjpUGTjSpsyL2WBMWi9hm
         S+Xw==
X-Forwarded-Encrypted: i=1; AKwUvBz1frT8L0ACZ+tju2ZhwyMi19Xv8LiIbCxtw6kMDCOOAzMqEX6MB8rFJQqIMfvtcbvdrZ+nYrgJ4u1oUgfaWw==@vger.kernel.org
X-Gm-Message-State: AFq9FYI3MmB32QqwvlpEo7yrCKc5oVUbEYdXimAmierKZ4TsXo83/6X6
	A+dKMJz3FrrTQqYyqt/PBpKvMydV4BR2iWNutEoxHz9OF/Hx8nlsByiirfRz/Po6/i/vIkYOSFW
	gjTdspqhhayzheps+YAvdRrCbLOxDjcyCUcASL0mY48qCUKSYKv6UwknQoIZekGKAVBUrQw==
X-Gm-Gg: AYBFou0/dRq+0qXCZNcJvn+OFdwYVHyRN7DxPgKWa+XyB/cci0uZnc5bH4QcsxXRt+G
	NFYG9JFgnnqT/DzbFBs2zaH3ljiUPTqzY+9iW+rtnBicq2QoXpN4Izn5htcElDM78Oy8C+tyjmq
	jKwRTcJkMjuD5qJOeehgVfnDUjFFTLEEzmqqPH/Gf0aDuQ4A+LQHvX2W4+BxHd3ab+2VBNWHlgz
	B9FGLr2HaZEhSDQ/E4JKcNT3R3sWwCvnALPs74WK1I9p4EIB/wYXk2r8MFZfyL9yJ4ZTUuRHRlp
	9k546/tbdngY77D48dxrHqNGUPax2+P1Jh9e0OGavTU/e+wN1ERo/X9an68+r/3VqF+Vp0oxJUf
	T5Xfe8nKHm0LpTxBmeVPmsuyQxDSu2NS/Ky52iOdhuT6Q32DbYJtTayr6e2mlVr0vVPBrrQE=
X-Received: by 2002:a17:903:4b04:b0:2dd:ad7d:72e1 with SMTP id d9443c01a7336-2e2c497f98bmr9298735ad.24.1790662744368;
        Mon, 28 Sep 2026 23:19:04 -0700 (PDT)
X-Received: by 2002:a17:903:4b04:b0:2dd:ad7d:72e1 with SMTP id d9443c01a7336-2e2c497f98bmr9298555ad.24.1790662743790;
        Mon, 28 Sep 2026 23:19:03 -0700 (PDT)
Received: from [10.133.33.76] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9145b773sm51231545ad.69.2026.09.28.23.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 23:19:03 -0700 (PDT)
Message-ID: <8bc3eaa1-7233-48db-a41b-ce3f08fbdd15@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 14:19:02 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath11k: release peer accounting on peer delete
 timeout
To: Michael Pfeifroth <micpf@westermo.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
 <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
 <arTp/9A0iMNpIhl2@mpf-ESPRIMO-P9012>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <arTp/9A0iMNpIhl2@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDAyNSBTYWx0ZWRfX+n8x1lpCvTyv
 QebTrex0omEc57hsuxhXiNqmkPDwrcI6cZVA0Q2haIom16Yy1dApXLYg18KBvTg14lxVVJbCfQC
 1gIu130ovNC55Cq2dyYZxwjlmLVcJtfvlrXGHEg5jcUGsnWQ74zuIGwRuSQERvducX+LwghKG/Y
 zxz7qcx8aBVVnmz/AufyJ6W1ivWumKIOD/z/CnVhhLs/W/EsqXNhKLknrDdjumqFvjIm25Rt2wv
 kE6shH2GuHxw6pLi5WPORVY4kzkINBIiKu2l8ezTyCfL1jqPlIrzzIVN2D3Dg6PAjkqzjgBzUmu
 EXJam3ucAElogeEZxyQSgWIDqi/HiK67nUaYiHCevz0++w1ii+AGntLLZ3nCab5glwoKV47a7JI
 taw0QB25T3swVBcuJYXrO0CedNzXYgFc/usoHtDB88L7AOqui0TRXZMl1dttOfXL/Z6H4cAPCnz
 NelN5+n2Mp0np0v23qA==
X-Proofpoint-GUID: rWGuN4Ul3vqVuOXoxJ_gfSTfeiWN2pWu
X-Authority-Analysis: v=2.4 cv=VcVir1p9 c=1 sm=1 tr=0 ts=6abb5859 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=aScLlBn_rR9kq3WGfpkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-ORIG-GUID: rWGuN4Ul3vqVuOXoxJ_gfSTfeiWN2pWu
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDAyNSBTYWx0ZWRfX8y/tB2udieoZ
 wcrqg50lG6nNENUJxBIxBNwmNfxbV4W3I9RwHnXt9FmDXLd2j/2yLCjW72VaMRj9Axf8PWzPGYA
 6Ufyd6BP4JxVVpBKyRpxuXJk7mrzVoQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290025



On 9/24/2026 5:14 PM, Michael Pfeifroth wrote:
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
> ath11k_peer_delete() only decrements ar->num_peers when
> __ath11k_peer_delete() returns 0. On a delete timeout
> __ath11k_peer_delete() returns -ETIMEDOUT, so the decrement is skipped
> and one num_peers slot is leaked per event. After max_num_peers such
> timeouts ath11k_peer_create() rejects every new station until the radio
> is restarted.
> 
> In the observed case the peer-unmap event is received normally (there is
> no "failed wait for peer deleted" log), so ath11k_peer_unmap_event() has
> already removed the peer from ab->peers and freed it; only the num_peers
> counter is left wrong. The delete-response completion is missed because
> the response event is dropped in ath11k_peer_delete_resp_event() when
> ath11k_mac_get_ar_by_vdev_id() cannot resolve the vdev ("invalid vdev id
> in peer delete resp ev"), so ar->peer_delete_done is never signalled and
> the second wait in ath11k_wait_for_peer_delete_done() times out.
> 
> Return success from __ath11k_peer_delete() on the timeout path so that
> ath11k_peer_delete() releases the num_peers slot. As a safety net also
> drop the local peer if it is still on the list; that only happens in the
> other timeout case, where ath11k_wait_for_peer_deleted() itself timed out
> and no unmap event removed the peer. The peer has already been removed
> from the rhash earlier in __ath11k_peer_delete(), so only the list
> removal and free remain, mirroring ath11k_peer_unmap_event(). A late
> unmap event would then simply fail to find the peer id and log a harmless
> warning instead of touching freed memory.
> 
> The problem was reproduced deterministically with an out-of-tree debug
> patch that adds module parameters to force
> ath11k_wait_for_peer_delete_done() to return -ETIMEDOUT and to cap
> max_num_peers: after max_num_peers such deletes the AP permanently
> rejects new stations, and with this change it keeps accepting them.

though the last paragraph explicitly says the issue is artificial, most of the commit
message still reads like a real world bug ...

I think it would be better to rephrase as something like 'Theoretically, if peer unmap
event is good but peer delete fails ...'

> 
> Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
> Cc: stable@vger.kernel.org

I don't think it qualifies for stable backport since it is not a real world issue.

> Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
> ---
> v2:
>  - Correct the root-cause description: the peer-unmap event is received
>    normally, so the peer is already freed; only the num_peers counter
>    leaks (Baochen Qiang).
>  - Explain that the missed delete-response completion is due to the event
>    being dropped on an unresolved vdev id, replacing the vague
>    "misrouted" wording.
>  - Rework the code comment and switch to netdev comment style.
>  drivers/net/wireless/ath/ath11k/peer.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
> index b30a906..f93a8da 100644
> --- a/drivers/net/wireless/ath/ath11k/peer.c
> +++ b/drivers/net/wireless/ath/ath11k/peer.c
> @@ -341,8 +341,21 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
>  	}
>  
>  	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
> -	if (ret)
> -		return ret;
> +	if (ret) {
> +		/*
> +		 * The delete timed out. The peer is normally already freed by
> +		 * the unmap event; drop it here only if it is still on the
> +		 * list. Either way return success so that ath11k_peer_delete()
> +		 * releases the num_peers slot instead of leaking it.
> +		 */
> +		spin_lock_bh(&ab->base_lock);
> +		peer = ath11k_peer_find(ab, vdev_id, addr);
> +		if (peer) {
> +			list_del(&peer->list);
> +			kfree(peer);
> +		}
> +		spin_unlock_bh(&ab->base_lock);

except for the firmware crash case, this is exactly what is done in
ath11k_wait_for_peer_deleted(), so if that function succeeds the peer is definitely
removed and freed already, so this is actually dead code.

as for the crash case, all peers are cleaned up in recovery path so we don't need to do
remove/free as well.

> +	}
>  
>  	return 0;
>  }

