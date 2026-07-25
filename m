Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98B18A93F
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 19:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785008325; cv=none; b=A7uJ0IQNaMdnBCLgXW5/KGPrVPJhNU1z0Gw+vnX7A1T+03W/vlf6it0VOEgSxL4TSeYIwUsWq2OkQP3OPmOJmV4VzBR4wgZkDLz98ILf1ixqYreKkIsLx68fn9+SPd+TnLXAIocmfx4ma3yxX+C4uwfSzm4+BUGEML63fdbXdO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785008325; c=relaxed/simple;
	bh=1KYzLtK7hXdUn83IP7QMH/rJWnw9J/akpHU8yAEiK8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ktFsZjgqqGBR8VfeCuaMxvVcq/YPAFxuIC+f9wC9sxkHQX1PkpgjMWPYIjxUN9cop0l8c4fTVaBxHwq0fI0YQtI8O965nu0f2GTZM7W6bvKVRLmdQ5eTAcHn4Lzv/vTYeAYZAvjl0Qlwvlzr3xi5rc4qNQ1nAU5LvA5DxmvGSCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RPZBs2RT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QzKGFsiA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RPZBs2RT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QzKGFsiA"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PHprBG2729541
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 19:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GosdS2/QopcTcvN0gpgPMl5jmSClH1CzdjJ+of2R4Bc=; b=RPZBs2RTkxoALmd6
	j6Au4oZIDfSe1Kc8KnZSF+AqjrJZf61osyFXI2QECyHTYK/7C9C9jdwd07ptyL1k
	fzOP7i9YNsO5LM5+PdpaJHRpIBGJbquyva+7syK5JKLjIR3caMpDbbEnGMQsaJfd
	DwUP9fSAqVHQhuNFpe9a6imF5YF7xYfcQG8HqN4vb7Ew+ZrtJNO/qWntubZVmb4Y
	MSndJxEuiHZ3qxYhi4wa6SVks8zsCcusr6Xn944kgFxKKw2WLVHI9zsG4Dpz+wca
	erFg0jpAn6FedSVmpF1bxu9OhGntBUxmFB+34OSpWW+rAIfvUPA3yGqJLnRNFy42
	ZhQzSQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnc3hgsw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 19:38:43 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cab3e9cd922so930738a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 12:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785008323; x=1785613123; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GosdS2/QopcTcvN0gpgPMl5jmSClH1CzdjJ+of2R4Bc=;
        b=QzKGFsiACBCiLjUsXqG59RPzSMOfmk8br2CHmfS5XkoBVFiSHxKkb1tqLRHFRABTAt
         rZN8XNmm3h0QVsribhx4LSW1AAV4sDNtUaVIAsCauK/rDfRPVZDXZZU3tOjTXk8jYRLC
         CM736aky6xQlVrjwYucWj/ub8GlGyxgiuY0tIdj7hTFHBARtTAF7eEDQO3CSthGLoGMr
         OwMEJGqkMON3ZpOYmveqqIl+SwtH757tcks3w2jV0H/P5TdrMGqVgLOKXJQjYBT+EhIh
         Qwes2RuTkcZV9Qq+78EBEyrFc48YYK82s6dMcnRZAB1MhFnDlJlZxf+sPxHlukYjYkcF
         2n/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785008323; x=1785613123;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GosdS2/QopcTcvN0gpgPMl5jmSClH1CzdjJ+of2R4Bc=;
        b=rCrIJJs3YrF2+n2zOOBymgrEXZ7xI8YwlMsnmfI9v/MdbUoN9LriyZrlCCLcV8Lced
         9U2U2dZqCJyOIvngYLJtiMxoCWbKOvMYY0Wlym32oIHXi0qCWYuiDogLp65aNokHOQl5
         z+TFfg4BssM16K3L/lE7bPllHzpCJUTcP3Y20T2YP2LRne7owYjf6Pqf9TNyNDEFOtzq
         Aj94WO0l+OwVQ6cs2C/mQeP1L7bA71PJrqV102o4yQJOJhv1zlMjjz4190Xexk8Wq9ht
         WcGlU/9WbyNIVDWMZ8r+FIJQDY7edWkwk11C5hoziOtlWtDDywEdrQWhg3TfT9fzqhrf
         Hu+w==
X-Gm-Message-State: AOJu0YwUyCc4apn9P0LiTXGvEIjaiEapYPdt33UNEgRazRiXBn/NHCgQ
	OAREVxJN1Iwn5QR9Lbj6Jz6TLBSKaayspY/quz0R3KG1L19gpyF7iW5XuVHxZ1t1BsyLjE/pE7O
	NFPI7y4LwekGdnn9M2EzBzGPaEjiyYXRd0ztcdjhGGVkWp667wiUf/4TCG7ZKApV3G0n4Rg==
X-Gm-Gg: AR+sD133Yt8gu2U+ApmIszt0p3YNP+T+aba5Vc1pTUG6YROIM3oxhkzxsU5yda3+S9j
	Bn/EnGx2aNFRqwnrDBc+pbfhi/YwgWyzZ0nGdzkscQ9V0461AneL5vVUTpHpOFKQ/oAlWr1ut2V
	40c7rbu6EjZUqTT3Ni4QFMPviM2ZOsFAOLby3O7F/GkasnKMFMfWkGsXfvz62R6msGl4/Kfa8IS
	wqJ+zgac5BVgTBMoB7Ddp7LPQR99XRkhynutZoABHqO++4HvCCGjOOPx0c9UAPA4udOApWKopAu
	OiwaYSxtRzDPJ+NVJkb/bGD5MAdzozKNRUvbCRp+lj+a6tNNbEu6U8BUHa0CSHzK0PGTarTOt+3
	hYSsnF0JLcyRMOsU52Wq5oAgA8gzaRpdgiCru6m5bGa2mNOHCCapREQRhgA==
X-Received: by 2002:a05:6a21:a43:b0:3c3:6af4:a658 with SMTP id adf61e73a8af0-3c67dfa3ea2mr2664602637.50.1785008322584;
        Sat, 25 Jul 2026 12:38:42 -0700 (PDT)
X-Received: by 2002:a05:6a21:a43:b0:3c3:6af4:a658 with SMTP id adf61e73a8af0-3c67dfa3ea2mr2664591637.50.1785008322120;
        Sat, 25 Jul 2026 12:38:42 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc549cacsm13537457eec.16.2026.07.25.12.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 12:38:41 -0700 (PDT)
Message-ID: <3d793ba2-09f1-44e4-95c4-1ad877db7b4d@oss.qualcomm.com>
Date: Sat, 25 Jul 2026 12:38:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Guard dp_peer dereference in
 ath12k_mac_peer_cleanup_all()
To: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260722095828.2930377-1-hbijlani@qti.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260722095828.2930377-1-hbijlani@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDE4NyBTYWx0ZWRfX3DZHCcPDryLN
 0BzAe4OSsFfsAOmY3N4sSa8kP6ErREbgMse0VgIlEet/JgeWE2FGTX6SOADYDBJYapTD1+ZEu+N
 OyI44HRm9TURajkR/G+iGraC//pK0iozmusWT4+jtjSOIqNwtDIbCCUm98oPbKUv38SMzsZEemN
 tLCNBzcHeIIeoGGMaSiWBOiyt/gUH69YzXFeeIy9FI98saVnSODvFU43Epao+DZLm6tbt8SIJaE
 Gj/b33pSRrqfYa2MLUTjvNEHcVESWn/zLVP/7IBzx6kE1j2+2FAfsLy+Tg90Oml14/NcA6GxXg1
 CXIcYX4p5AYIojEqnU1Sm5sCpcU2j56W4zX+RmBMxjhwDzZqmi6nmRo1nFavUT6e8qyWz7dtxN/
 MB5hQAvhkpij8UOK0FukabkqGQfjh8BRU6hMhXZQZdzTBUkN7aZgweLdxt5HrhjOC+K0lSTv92C
 lytj4Pc38QZO6RKMyBg==
X-Proofpoint-GUID: VinNNl75gia3_2yGsSNOVhdsFgZwokO_
X-Authority-Analysis: v=2.4 cv=VcfH+lp9 c=1 sm=1 tr=0 ts=6a6510c3 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=YoqGRNaBgx1oBrP2v9QA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDE4NyBTYWx0ZWRfXzqpFVWDGRpby
 Wi8b3mBPdzIvHCjrApLEeukZmZ29OcaW7nHzdZN1DMPZ9DXTPUeM2GNy7lSB7/D3Nw0ejJ8VJ1N
 6M8ozmj0vajJKcddglq+lYGXVMiPyT8=
X-Proofpoint-ORIG-GUID: VinNNl75gia3_2yGsSNOVhdsFgZwokO_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250187

On 7/22/2026 2:58 AM, Harsh Kumar Bijlani wrote:
> From: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
> 
> In ath12k_mac_peer_cleanup_all(), the code iterates over all
> ath12k_dp_link_peer entries in the dp->peers list and performs
> datapath peer cleanup. For each peer, it accesses peer->dp_peer
> to clear the link_peers[] and dp_peers[] RCU pointers.
> 
> However, peer->dp_peer can legitimately be NULL. The
> ath12k_dp_link_peer structure is allocated and added to dp->peers
> during peer creation (ath12k_peer_create()), but the dp_peer
> assignment happens later via ath12k_dp_link_peer_assign(), which
> is called only when a valid dp_peer is found or created. If the
> peer creation sequence is interrupted, for example, due to a
> firmware crash, a race during interface teardown, or a failure
> in the HTT peer-map event processing, then a link peer entry can
> exist in dp->peers with dp_peer still NULL.
> 
> Accessing peer->dp_peer without a NULL check in this path leads
> to a NULL pointer dereference kernel crash during the mac cleanup
> path, which is invoked on radio stop or firmware recovery.
> 
> This is consistent with how the rest of the driver handles this
> field: ath12k_dp_link_peer_unassign(), ath12k_dp_peer_cleanup(),
> and several other paths all guard access to peer->dp_peer with
> an explicit NULL check before dereferencing it.
> 
> Fix this by wrapping the dp_peer dereference block inside a
> NULL check, mirroring the pattern already used in the same
> function for the Rx TID cleanup:
> 
>     if (peer->sta && peer->dp_peer)
>         ath12k_dp_rx_peer_tid_cleanup(ar, peer);
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> 
> Signed-off-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 956414b953ec..18c1c809ae4d 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -1237,10 +1237,12 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
>  
>  		/* cleanup dp peer */
>  		spin_lock_bh(&dp_hw->peer_lock);
> -		dp_peer = peer->dp_peer;
> -		peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
> -		rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
> -		rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
> +		if (peer->dp_peer) {
> +			dp_peer = peer->dp_peer;
> +			peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
> +			rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
> +			rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
> +		}
>  		spin_unlock_bh(&dp_hw->peer_lock);
>  
>  		ath12k_dp_link_peer_rhash_delete(dp, peer);
> 
> base-commit: ca27e3c2284a7a43ba390ed5ce0d68b3c869c0ce

This patch does not apply:
* Applying
20260722_harsh_bijlani_wifi_ath12k_guard_dp_peer_dereference_in_ath12k_mac_peer_cleanup_all.mbx

Applying: wifi: ath12k: Guard dp_peer dereference in ath12k_mac_peer_cleanup_all()
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath12k/mac.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath12k/mac.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath12k/mac.c

It conflicts with
a2fe9dc70f3b ("wifi: ath12k: Fix low MLO RX throughput on WCN7850")

And since that adds the NULL check I think your patch is actually not needed?

/jeff

