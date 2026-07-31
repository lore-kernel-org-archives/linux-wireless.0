Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCCD3C1D5B
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487710; cv=none; b=eMZIOqbF1iixA8OSqewc1TqFtjt/l8/jhE7iko+PcmvMhLlYtUv8X29Ea2sh28MfmgoiJ2MAMrXFcZZvI2rCT0xGGbeeM9C9dQPm2GCaU7e7cad3gDNfqos9aqYM3Fk3vFDv6NGj2XudPng+1m3qiqgVLDrKEPrtO3IkOy78NLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487710; c=relaxed/simple;
	bh=L6sA/7nCbMvZfrQ6ZKajIU8dpYJVFZyov0ivDHRlx/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s4amo1I4QBB0eTd3vgFjXfzDoK59CyJxPZbbTaHsdRoIkSRGYIBAb/kq+Ksi3PDpv8fUS8eK/s3kIMwP8kESLdGMoxdxEV7PC7t4nzY2lhypc7uHr7HiPfaSd8EODQD4HRrgvC5NvDHkDAvSkWiA3gsR1DJk/zLN1a0JuayTpoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hCLjy0Ln; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YKjzQu3R; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hCLjy0Ln";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YKjzQu3R"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8lPLM2991333
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	i8F2L1rEXRMkWHvZppRIKIF/IIlCRy69zAZcBD+vS5s=; b=hCLjy0LnIkvPUl/i
	UxQTVhe07Mio9UD+M42cCqnhzvuviKU88XIMEe65+QqLkldu8ipXP8993kgB4K1W
	pQFD1b8LbjhfF+a5CUNLMn3OayP+TcVTgDnPxk2bGkuuTVnDD8IuQRHiQebOnAUe
	es/MaYeZF2pmVbOC1t4mssg4D88b4taB3AZ4PIIEiN8kWjygj9YJX8D+sv2WdTFe
	N/Nsy1P/3Hbf7tkZY0caMrwxGWlAgjJ8sB7HOuYFUYr5Ry3G9S8DRXOWjXugZ3M9
	vw89LQoOC0GpIuwzZ2BnmfrQ4nZ9lSfBkMTqTss/2GbLWFFilrdkLUNJu/k/6lYB
	LN5iYA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frrgpg041-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:24 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e3d575d6eso1640422b3a.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785487704; x=1786092504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i8F2L1rEXRMkWHvZppRIKIF/IIlCRy69zAZcBD+vS5s=;
        b=YKjzQu3RD6YQKvGXSPAqFlSkZgQszbaISlx7ov9LOuvIZ9UUsb9r4OI9a3Y2UF5DLE
         WqEyCuoLCtjiFfMjBeAWePWA6pl9yQ8bc96h7hdfRiPzUCtUfqvxZwI6fF7J+927fnTg
         qrdIICccQERccIFdUoZMtVmyozo9CfRCsFo4f8UOxCFuqoB88mlk40Cdi+VuG3Y05MXi
         Bswu6J3tBTZLqGnOyglKQ5QWB5C9z7ZVUOiNVhKvwuHKyTYbureXdzLaozQTt0kHw7M/
         DUuufsL8kZy9leKYVTc1BRgCib5JaLh65zf9GBu6fYqPJJkCvPU+ONxckWcv3ZE7E/jb
         MP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487704; x=1786092504;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8F2L1rEXRMkWHvZppRIKIF/IIlCRy69zAZcBD+vS5s=;
        b=sHZa2Qc7n8tnuQUmWtBlOpdpPpEFbiVCsyrdpsHT9cB50Jt274ppP6gdJ6modXSDEK
         GeAbe4PPCq62/z7DxX/X+nq2n0D0PixX8y+RuASJUoua6Yhb+g8rxsOrLu3qJulaHI9n
         oTxmBSZSEBdLSVk0KaBZZ3JuUS7LN6akkP0DhNL39zJKijOMDfYuiSooc639YwRH/F73
         5WrP+6T4ddwDgYMssPxyfOcDXy/89eQxJCOtYGRhaU5MVplXpdCTyFO7Z+zrL69+MZv7
         /foBiJHO73mv2nXzSuKgxCiIptKxM/Ts8/rXpJY1aJDO5oeRTOKPiiCxWb2RHlqAtxZX
         WJGQ==
X-Forwarded-Encrypted: i=1; AHgh+RoUXF6LJ05f14T2s5GtgDrnoXIVn6e+G2+eeHS8eBwfxIPAnB12zYyBjHHFnuQyYGLM4q4BgbDcqnd7q/cerw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+uX0a2ECEcjW9ZsD03sCDmHZimE8R4HaMOTS6SoZyqIA5Orrc
	ldZA9dxjoiJmsBDMEfyL56TBLpjsjzsWyvOUwnROLD46mk0Za7PHBbUFjZtScyujG6qV26Ibc1f
	e7fThBuck+jeRKEPRASyk9/EVf3GatNDQ/eXbLWqL2Ms98WsOCnjtiQ8A3SBO7hhJZdB4Kg==
X-Gm-Gg: AR+sD10oGeJHNgQTAYHf04NRVRd8OL1Sl/XMVSCtj+UawByCMors23Iy7uLo4qCGr34
	6cpcB4NLMIO8zxdNCpPFoS3wsxqMgEESEu62BJrRGW6KNI/6oFsY1y1hUBH7YAsGQXOem5OATq0
	BL4nyTQntrwbdH6okeGDOXW5XV2b9u3avuANbsn8UGjZF2D/A+pYrTOR/DLYTQoE85Gk1uKwp64
	uLCLpwUvV0D4sirLQ91qcmfqRlag4MIAtU41Ub+eyB8T0znueiblP5aeahMrzRzxVrHnhJwHr9T
	9OviMqk7Q4mGiYJNRdzHFmFiF6FnE6+ZSAqVH0argYaZ7q7jMGIUop9QyY7aJhkOsTDwaJc1mG+
	aMm7fWmgG5tlhidgk8ERMGw4Oyana/qCrQjnmpgqgd1NQVn3hYwgX5ViWnI70khD1xSkVBjP/DA
	==
X-Received: by 2002:a05:6a00:17a5:b0:848:3119:941e with SMTP id d2e1a72fcca58-84ed6edacf2mr1134363b3a.47.1785487703905;
        Fri, 31 Jul 2026 01:48:23 -0700 (PDT)
X-Received: by 2002:a05:6a00:17a5:b0:848:3119:941e with SMTP id d2e1a72fcca58-84ed6edacf2mr1134343b3a.47.1785487703393;
        Fri, 31 Jul 2026 01:48:23 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc51cac8sm156250b3a.56.2026.07.31.01.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:48:23 -0700 (PDT)
Message-ID: <0ed1f684-1b3b-411b-87fa-929dc0f8f7e9@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:48:19 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] wifi: ath12k: fix MLO station firmware crash recovery
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727162748.963275-1-jtornosm@redhat.com>
 <20260727162748.963275-2-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727162748.963275-2-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: EH2-sTNR4gXueKe1oDlVJYckHfXar5oL
X-Authority-Analysis: v=2.4 cv=SK5ykuvH c=1 sm=1 tr=0 ts=6a6c6158 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=20KFwNOVAAAA:8 a=f2E5mhgNlWdv1eDQvuYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX5txOtFbZuwAB
 9f916r++Ndps6ibUcosEQrTCpr3KhjjWGZw4iovwDKNH0xHImo3LsNstyxbu7HUEtZ2n6Jmb3pV
 MKLuVTbQDTiuBDZAMGQzkBzyvdXyPFuq2RfJq3+7N9jo5pzA5sjpaAFygutVaNV6URLiQfJRo4g
 OFovR/PnEwPwnq8TZm/V+zeJo8dv7eacjFjBAagtYLsywcMLbBfST5N0rbzSgjfden0kulhZpBr
 cRPiGj48DQ2WitqAyyRmZakoPkVs6LvoNzmEOqds4wfEMxcWqZMN2+ugxLcNC4yjsYZ+BPNI19l
 zl9VHhEgbC9aPhDqZ1y8MuWSpA0xPEPx2Kf5ExJ9YtuEyVwpusYA2CaKBRPU3R9rk3dvD83PmPF
 7+jlG3R+BvN5vH1zmhs6u/4s878Eo8bdExCaT9ETt4mDvB+uSTHWD0/Dj0rNVzkTR+AfFkekZBd
 1QLy+8hZyU0KEuDGBdA==
X-Proofpoint-ORIG-GUID: EH2-sTNR4gXueKe1oDlVJYckHfXar5oL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX9EO0JEE+pWCe
 zNCTa5U/NjLNkiakMaMZjByaXgj4P4CQflJYHu2BjpyxlrEyj7pDg9geXQAvDowZfaOs3OB7dyc
 XodtZYeKToAptyNhicwZDqHwDNi1mZ8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 impostorscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310063



On 7/28/2026 12:27 AM, Jose Ignacio Tornos Martinez wrote:
> ATH12K_FLAG_RECOVERY is cleared too early in
> ath12k_core_reconfigure_on_crash(), before mac80211 runs
> ieee80211_reconfig(). By the time mac80211 calls back into the driver
> (sta_state, change_vif_links, set_key), the RECOVERY flag is already false,
> so the driver treats recovery callbacks as normal operations.
> 
> This causes several problems during MLO recovery:
> 
> - ath12k_mac_op_sta_state() tries to activate MLO links during the
>   AUTH->ASSOC transition, calling ieee80211_set_active_links()
>   recursively, which triggers a WARNING at net/mac80211/link.c.
> 
> - ath12k_mac_op_change_vif_links() processes link removal during
>   reconfig, causing inconsistent state.
> 
> - ath12k_mac_set_key() fails with "cannot install key for non-existent
>   peer" because peers do not exist yet during reconfig. Keys will be
>   re-established during normal reconnection after
>   ieee80211_hw_restart_disconnect() triggers a fresh association.
> 
> - ath12k_mac_flush() waits for pending TX to complete, but after a
>   firmware crash the TX will never complete, causing a 20 second timeout.
> 
> - ath12k_mac_station_remove() calls ath12k_bss_disassoc() and
>   ath12k_mac_vdev_stop() which send WMI commands to dead firmware,
>   causing timeouts that delay recovery.
> 
> - ath12k_clear_peer_keys() tries to look up and clear peer keys, but
>   peers are already gone after firmware crash.
> 
> - ath12k_dp_rx_ampdu_stop() dereferences per-link station state that
>   may not be valid during crash teardown.
> 
> - ath12k_peer_mlo_link_peers_delete() sends WMI peer delete commands
>   for each MLO link peer. With dead firmware these time out and can
>   trigger cascading resets.
> 
> - HAL srng source ring operations (ath12k_hal_srng_src_num_free,
>   ath12k_hal_srng_src_get_next_entry, ath12k_hal_srng_access_end)
>   may attempt MMIO access to hardware that is no longer responsive
>   if TX paths race with the crash. Guard these to prevent potential
>   hard lockups on unresponsive hardware.
> 
> These issues were observed during sporadic firmware crashes in MLO
> operation. To allow systematic testing and reproduction, the debugfs
> simulate_fw_crash interface was used to trigger controlled firmware
> crashes during active MLO connections with traffic.
> 
> Fix by moving clear_bit(ATH12K_FLAG_RECOVERY) from
> ath12k_core_reconfigure_on_crash() to ath12k_mac_op_reconfig_complete(),
> so the flag stays set through the entire mac80211 reconfig phase. Add
> ATH12K_FLAG_RECOVERY checks in change_vif_links, set_key, and sta_state
> to skip operations that are invalid during recovery. Add
> ATH12K_FLAG_CRASH_FLUSH checks in mac_flush, station_remove,
> clear_peer_keys, dp_rx_ampdu_stop, peer_mlo_link_peers_delete, and the
> HAL srng source ring helpers to return immediately when the firmware is
> dead.
> 
> Tested on WCN7850 with MLO (Wi-Fi 7).
> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
>  drivers/net/wireless/ath/ath12k/core.c  |  2 --
>  drivers/net/wireless/ath/ath12k/dp_rx.c |  3 +++
>  drivers/net/wireless/ath/ath12k/hal.c   | 10 ++++++++++
>  drivers/net/wireless/ath/ath12k/mac.c   | 19 +++++++++++++++++--
>  drivers/net/wireless/ath/ath12k/peer.c  |  6 ++++++
>  5 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index 742d4fd1b598..5c3883b19da1 100644
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -1410,8 +1410,6 @@ static int ath12k_core_reconfigure_on_crash(struct ath12k_base *ab)
>  	if (ret)
>  		goto err_hal_srng_deinit;
>  
> -	clear_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags);
> -
>  	return 0;
>  
>  err_hal_srng_deinit:
> diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
> index 8fa0e90b4531..473855ded8a7 100644
> --- a/drivers/net/wireless/ath/ath12k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
> @@ -751,6 +751,9 @@ int ath12k_dp_rx_ampdu_stop(struct ath12k *ar,
>  
>  	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
>  
> +	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
> +		return 0;
> +
>  	arsta = wiphy_dereference(ath12k_ar_to_hw(ar)->wiphy,
>  				  ahsta->link[link_id]);
>  	if (!arsta)
> diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
> index 071cb5d30931..6d3f4bca46a3 100644
> --- a/drivers/net/wireless/ath/ath12k/hal.c
> +++ b/drivers/net/wireless/ath/ath12k/hal.c
> @@ -376,6 +376,9 @@ int ath12k_hal_srng_src_num_free(struct ath12k_base *ab, struct hal_srng *srng,
>  
>  	lockdep_assert_held(&srng->lock);
>  
> +	if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)))

ath12k_hal_srng_src_num_free(), ath12k_hal_srng_src_get_next_entry(), and
ath12k_hal_srng_access_end() sit on the per-packet TX/RX hot path. Adding an
ATH12K_FLAG_CRASH_FLUSH test in the lowest HAL layer overloads a global flag onto all srng
operations and is a layering violation — the HAL should not know about device-crash semantics.

> +		return 0;
> +
>  	hp = srng->u.src_ring.hp;
>  
>  	if (sync_hw_ptr) {
> @@ -419,6 +422,9 @@ void *ath12k_hal_srng_src_get_next_entry(struct ath12k_base *ab,
>  
>  	lockdep_assert_held(&srng->lock);
>  
> +	if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)))
> +		return NULL;
> +
>  	/* TODO: Using % is expensive, but we have to do this since size of some
>  	 * SRNG rings is not power of 2 (due to descriptor sizes). Need to see
>  	 * if separate function is defined for rings having power of 2 ring size
> @@ -524,6 +530,10 @@ void ath12k_hal_srng_access_end(struct ath12k_base *ab, struct hal_srng *srng)
>  {
>  	lockdep_assert_held(&srng->lock);
>  
> +	if (srng->ring_dir == HAL_SRNG_DIR_SRC &&
> +	    unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)))
> +		return;
> +
>  	if (srng->flags & HAL_SRNG_FLAGS_LMAC_RING) {
>  		/* For LMAC rings, ring pointer updates are done through FW and
>  		 * hence written to a shared memory location that is read by FW
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 51c4df32e716..c559ced9e524 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -4278,6 +4278,9 @@ ath12k_mac_op_change_vif_links(struct ieee80211_hw *hw,
>  
>  	lockdep_assert_wiphy(hw->wiphy);
>  
> +	if (old_links && test_bit(ATH12K_FLAG_RECOVERY, &ah->radio[0].ab->dev_flags))

why it is limited to the first radio?

> +		return -EINVAL;
> +
>  	ath12k_generic_dbg(ATH12K_DBG_MAC,
>  			   "mac vif link changed for MLD %pM old_links 0x%x new_links 0x%x\n",
>  			   vif->addr, old_links, new_links);
> @@ -5956,6 +5959,9 @@ static int ath12k_clear_peer_keys(struct ath12k_link_vif *arvif,
>  
>  	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
>  
> +	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
> +		return 0;
> +
>  	spin_lock_bh(&dp->dp_lock);
>  	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id, addr);
>  	if (!peer || !peer->dp_peer) {
> @@ -6031,6 +6037,8 @@ static int ath12k_mac_set_key(struct ath12k *ar, enum set_key_cmd cmd,
>  		spin_unlock_bh(&dp->dp_lock);
>  
>  		if (cmd == SET_KEY) {
> +			if (test_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags))
> +				return 0;
>  			ath12k_warn(ab, "cannot install key for non-existent peer %pM\n",
>  				    peer_addr);
>  			return -EOPNOTSUPP;
> @@ -7045,7 +7053,8 @@ static int ath12k_mac_station_remove(struct ath12k *ar,
>  
>  	wiphy_work_cancel(ar->ah->hw->wiphy, &arsta->update_wk);
>  
> -	if (ahvif->vdev_type == WMI_VDEV_TYPE_STA) {
> +	if (ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
> +	    !test_bit(ATH12K_FLAG_CRASH_FLUSH, &ar->ab->dev_flags)) {
>  		ath12k_bss_disassoc(ar, arvif);
>  		ret = ath12k_mac_vdev_stop(arvif);
>  		if (ret)
> @@ -7795,7 +7804,8 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
>  	 * about to move to the associated state.
>  	 */
>  	if (ieee80211_vif_is_mld(vif) && vif->type == NL80211_IFTYPE_STATION &&
> -	    old_state == IEEE80211_STA_AUTH && new_state == IEEE80211_STA_ASSOC) {
> +	    old_state == IEEE80211_STA_AUTH && new_state == IEEE80211_STA_ASSOC &&
> +	    !test_bit(ATH12K_FLAG_RECOVERY, &ah->radio[0].ab->dev_flags)) {
>  		/* TODO: for now only do link selection for single device
>  		 * MLO case. Other cases would be handled in the future.
>  		 */
> @@ -12596,6 +12606,9 @@ static int ath12k_mac_flush(struct ath12k *ar)
>  	long time_left;
>  	int ret = 0;
>  
> +	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ar->ab->dev_flags))
> +		return -ESHUTDOWN;
> +
>  	time_left = wait_event_timeout(ar->dp.tx_empty_waitq,
>  				       (atomic_read(&ar->dp.num_tx_pending) == 0),
>  				       ATH12K_FLUSH_TIMEOUT);
> @@ -13494,6 +13507,8 @@ ath12k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
>  	for_each_ar(ah, ar, i) {
>  		ab = ar->ab;
>  
> +		clear_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags);
> +
>  		ath12k_warn(ar->ab, "pdev %d successfully recovered\n",
>  			    ar->pdev->pdev_id);
>  
> diff --git a/drivers/net/wireless/ath/ath12k/peer.c b/drivers/net/wireless/ath/ath12k/peer.c
> index 2681a047d4d5..e96eb78bbc0c 100644
> --- a/drivers/net/wireless/ath/ath12k/peer.c
> +++ b/drivers/net/wireless/ath/ath12k/peer.c
> @@ -297,6 +297,12 @@ int ath12k_peer_mlo_link_peers_delete(struct ath12k_vif *ahvif, struct ath12k_st
>  	if (!sta->mlo)
>  		return -EINVAL;
>  
> +	/* During firmware crash, peers are already gone. Skip WMI peer delete
> +	 * to avoid timeouts that delay recovery and can trigger cascading resets.
> +	 */
> +	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ah->radio[0].ab->dev_flags))
> +		return 0;
> +
>  	/* FW expects delete of all link peers at once before waiting for reception
>  	 * of peer unmap or delete responses
>  	 */

