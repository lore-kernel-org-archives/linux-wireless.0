Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793584074;
	b=S8EE98TlaYHbGiYmnQodjwRWd5v/ah+O1Cdgq2ciiGNvnXUusKntetTTtWBC1yVvxvCK
	 YlJBhaLl1Ns67wNPe0uHzr8C4D+UWG0YSiiSYKJgfGN345wO5f1QI7eqs1OFA+r+eR+8s
	 RjWAcYFHggch8GWMx9KSaA76Ir/Dh5zT5ubE2zclL1OnT44HlObOH+eMvnB/tVHSpPHGS
	 q0Cr18JLsC9Ektt/HR2mCBFXW3vBjfZR/r96ZNnxFTq+8HmAto6r8fG/LhHKCbEpZXyrC
	 Dq/9fMx2bh7+l1nfyCbLpYhNuseEOySFFuiKog49Fg7fMEN6nRHbWadCkblDMrrxgtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793584074;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=WvJcFINWzwp3JGPxOyys14YLISpX1jdIxUrb+1jNhNU=;
	b=pMUbOzfQ0Ckf6oENb0UxUno2Xsf6qzgwqK1fmJQHBUsD9XvglF4UVrYveo7NKdQyqzbq
	 FytA5XxKcLUfa/i/PENeVecXI2M89W1KwHN12i3t/jW6MvN5vP4oGIX94jlpp+hr8hg/E
	 7Wci8oznreH1A9V2L6dl1RLECr89vbG+LnghTuhDJO443W/DzVVT+PS28krq2dBwo6tGo
	 d89kHt57UTeX2FmURB1Do6GZSI1t3JuTRZTNPdsJscwoM/XiW+YYB10KowkFsgCWDCKgR
	 xb/rIu9WtSC6mo2X91FbgkHkofU/gcXYh6NBduxKdslx/XKC/gU4BeUz9M2onB5r9Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lUnlm5+N;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KsHis3dB;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F11606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 01:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1F11606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lUnlm5+N;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KsHis3dB
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A20KKBl1733535
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 01:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WvJcFINWzwp3JGPxOyys14YLISpX1jdIxUrb+1jNhNU=; b=lUnlm5+NpdxN3VxY
	y9Y7oTeh5rFxBtCvf9M9x9/DHj1L+1esLeR8xTovaKm8xuf/cGW60QWHrkYX84oZ
	3wnxcvSQxYLDDqQRla4JYmrcCibGy/f/Letd5hI9TkYBfrscoqCBPdzqAFavMciM
	jrzjQ4Ym0zxUOaPCYUxrNOaJnuIq2SbiQududdutoKGok++cCcfPvZlqSBeLqp07
	1xqxLc6ftsvgBKX6H82p8fqFIXc3Hm9iYItYgF7uEhGo2Ji88C5X2E7LGS9odG0S
	SZ/dkweykqPtpyX+Ys13ra0WfoAwt3++rKb5jSQWsotnflYF6SWRScYIHITlatlb
	PE1vog==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn93emjea-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 01:47:52 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ac7a4ba546so2664560a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 17:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793584072; x=1794188872; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WvJcFINWzwp3JGPxOyys14YLISpX1jdIxUrb+1jNhNU=;
        b=KsHis3dBjuGQN2wFaox+S6WOgGRpXV/KyYNNhhR4kD5IRJrqiyyPWyEZOppHt25E7P
         7vltLkKKTW6rgnH6vAO8Rdrnm0pWCHXf5kTyiO9BcS7svbeAzlxZ1fP/sbhR3z8iXFH5
         TdoV3b6orQuftvfoesBNd8ScWW0AWE2CB4yEvm98EGRgZCYzk3eS3mNhK9FAf/CIoaR3
         ZZxZjQpKzdv5Ac02AXm4JBfDnGJuLUMVQfpSsYX+fRJHPY9JrZUMVpZ1LfPkUNwLKa2G
         0irUTQivbB9Pql9c63I8HqdwM7D1lUpXav3g1e+LPibS/nPAGftfzRRy8t5w0RCtkA7R
         Pd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793584072; x=1794188872;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WvJcFINWzwp3JGPxOyys14YLISpX1jdIxUrb+1jNhNU=;
        b=N/s1QyIzjXRqJQg2mLAobrF26m8anor1/BJO7oDHbttZoULVK63p1DdNM1OMtPOWpH
         A0Clp3rH6ODSR/nTrGMOasYS1Jrk4tW8xMjkOQy5n6ubclEjWok5xgBpAnyR+jhlK92Q
         EXfXkf5NGdWbJKffZ2S/YwqKIwEVWT8wb01mcBSfniCp9B50HSg6CBJL/Va7vpA+uHFt
         92TzgqHRAK/DhoFe/h+FCKnBKkPHocvURjPXinZ885SVx47YdPI01cp5N18LOvkxYjDR
         fFxO1bDSaiQ9ZIjM8xvceziOF37ivUuJcHGZ/ViUIwfUa+ubWhUU4p85s9GJqEIdzpaT
         9Pkw==
X-Gm-Message-State: APuU4Z+7Kfyy1ROzrX6L3oUVvAnmYN+p+WwYWUTtyrMWJwVTFx/aOQeE
	r2rwBDOZH//TFAflXnjxuuSEZRzKknMQuF7KBNBFUzJ2Dnrv/DhqoZG/sE63I9MQ4aGxk3iV/uQ
	KM/1DzVDVstR/XRp+qdmzk16JsWcm1lxOBtnwURPVhw8p6Evc+JnJehENvVaGOuEkVd2dVdTPaL
	qafw==
X-Gm-Gg: AYBFou291fYf1rijlpZoIk8M1A0HhgBlUP1BqZRjDkFTIYYpRHcdFCRAkyv7vEtG+1F
	Qu+JaQeko7wB7fuTXEg/wlbevIdjIan6s5VV60i0h7quL/7kwYBA7EpqElSPLOtNtRNUI2zho2K
	d6c+ImYBV7Kdp1DxdGS3S/zHEdZk7lhGrZZSh6emE+OoiL8RhgFVJgyWbt/3rmnpmTO99h/R5ag
	8wRpCImTwBW5VDiIFihPKUr1bhP2rgazXUpwvmJxBP4oeXih6MBkpfEoI2Kv+UU4iTKafOg0vdU
	KeasYXGUb1paIlMRrb4LoHo4MnDVr+s32lPa16O2746xGYmm5UxWHdbeh2c5bQxl40eB06Ddj4s
	mzkFPaiDtuQuW7Gkl5KMs+L0I59SER2N7ZWhHS4+gXIvlDQ2vdMaTFWuAPyxdYoEIAzpnh1pj/k
	qwCnI=
X-Received: by 2002:a17:90b:5347:b0:3ab:be66:ddd3 with SMTP id 98e67ed59e1d1-3ae897994b7mr4718504a91.32.1793584071836;
        Sun, 01 Nov 2026 17:47:51 -0800 (PST)
X-Received: by 2002:a17:90b:5347:b0:3ab:be66:ddd3 with SMTP id 98e67ed59e1d1-3ae897994b7mr4718498a91.32.1793584071262;
        Sun, 01 Nov 2026 17:47:51 -0800 (PST)
Received: from [10.239.104.253] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm16200269a91.9.2026.11.01.17.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 17:47:50 -0800 (PST)
Message-ID: <692a240a-3995-47bc-8360-136610fb6a89@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 09:47:47 +0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: move arsta grouping from
 rhashtable to per-radio hashtable
To: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>
References: <20261021173318.1935569-1-maharaja.kennadyrajan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261021173318.1935569-1-maharaja.kennadyrajan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAwNiBTYWx0ZWRfX82q96/FSqkZN
 7lhts+31Kr45STdAb9A/jMBDWMr6GC9AlE5+/E4uYLZAH9l52dtjHb20w4Y21G/SidEaXFv+0G6
 8bSZiURtAqqz0L4U5iYXU5yUEUMwEyNqkOzj9nmu4R+NNpoAAmZmBZnOPpRNLZ84dzGcRXvqmnl
 hnsT+Hi3fL3/UfmxegBZWPbXFHD/mGtMI754ddoIpzlO2X7DGO8Mz+lNB3tZDVesiJqp2RKBanZ
 AOZr+SQhmuU375lh4xMObkLoUTNM2CgLciX8hbwLriBa7v6iaINe6+doBjmZe1oHnWKnpXSLWPw
 +nPz26VkDV5X+80wKp6ZH75dFdDYIjVWbTrXcgtryeLiE/PzxlqpRfppecm0xNTqUzYY/jwYvqy
 Wkq05gtys+y9TaE6l32MPtsqEvVFHCEKsYZfQMAZ/xJEDYvDHGlZ92zh3Xbjux36Ri6w+1IvXcF
 KskExNVaPXlkb17b9nQ==
X-Authority-Analysis: v=2.4 cv=FciiV5+6 c=1 sm=1 tr=0 ts=6ae7ebc8 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=DFEwwh57fLMD9Ncyh9UA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: _KPJcH7sl-n4aBxU5Q5AUo9Oo5P_7zMy
X-Proofpoint-GUID: _KPJcH7sl-n4aBxU5Q5AUo9Oo5P_7zMy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAwNiBTYWx0ZWRfX9p3/I+3ruXm3
 d54dXPXBU1weheIujQpaMdfPGuVUNzXziuh20S7IVvHEBOSMxDK7O4V2LIPFBXxnbchXcQ+tN0p
 wvokubhXonqc/Au1oylRqQYMOuxbess=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020006



On 10/22/2026 1:33 AM, Maharaja Kennadyrajan wrote:
> From: Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>
> 
> The link-station lookup table is a single rhashtable at the ath12k_base
> level, keyed only by station address. Rhashtable does not allow duplicate
> keys, so the same address cannot be represented on two radios at once;
> a roam or split-PHY overlap where an address briefly exists on more than
> one radio is instead handled by deleting the previous radio's entry
> before inserting the new one. Because the table is keyed only by address
> and shared device-wide, a lookup also cannot be scoped to a specific
> radio: during that overlap window, or due to stale remnants, the single
> entry present for an address can belong to a different radio than the
> one being looked up, silently attaching the wrong radio's data to the
> wrong arsta.
> 
> Move the lookup table down to the ath12k (per-radio) level, and switch its
> backing structure from rhashtable to hlist, which is simpler to walk in
> full for the iteration that some code paths already need. Each radio now
> owns its own table, so a lookup is inherently scoped to that radio, and
> the same address can occupy an entry on two different radios at once
> without any delete-then-insert workaround.
> 
> Update ath12k_peer_sta_kickout_event(), ath12k_wmi_tlv_fw_stats_data_parse()
> and ath12k_wmi_tlv_rssi_chain_parse() to use the new per-radio arsta lookup
> helpers accordingly.
> 
> The datapath's link-peer table (struct ath12k_dp_link_peer, in dp_peer.c) has
> the same device-level rhashtable design and delete-then-insert workaround; it
> is unaffected by this change and remains out of scope here.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Nagarajan Maran <nagarajan.maran@oss.qualcomm.com>
> Co-developed-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
> Signed-off-by: Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/core.c |   9 --
>  drivers/net/wireless/ath/ath12k/core.h |  21 ++--
>  drivers/net/wireless/ath/ath12k/mac.c  | 122 ++++++++++-----------
>  drivers/net/wireless/ath/ath12k/peer.c | 144 +++++++++++--------------
>  drivers/net/wireless/ath/ath12k/peer.h |  11 +-
>  drivers/net/wireless/ath/ath12k/wmi.c  | 112 ++++++++++++-------
>  6 files changed, 213 insertions(+), 206 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index 25987bc58556..2309ccae5338 100644
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -716,8 +716,6 @@ void ath12k_core_to_group_ref_put(struct ath12k_base *ab)
>  
>  static void ath12k_core_stop(struct ath12k_base *ab)
>  {
> -	ath12k_link_sta_rhash_tbl_destroy(ab);
> -
>  	ath12k_core_to_group_ref_put(ab);
>  
>  	if (!test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)) {
> @@ -1016,12 +1014,6 @@ static int ath12k_core_start(struct ath12k_base *ab)
>  	/* Indicate the core start in the appropriate group */
>  	ath12k_core_to_group_ref_get(ab);
>  
> -	ret = ath12k_link_sta_rhash_tbl_init(ab);
> -	if (ret) {
> -		ath12k_warn(ab, "failed to init peer addr rhash table %d\n", ret);
> -		goto err_reo_cleanup;
> -	}
> -
>  	return 0;
>  
>  err_reo_cleanup:
> @@ -1425,7 +1417,6 @@ static int ath12k_core_reconfigure_on_crash(struct ath12k_base *ab)
>  	int ret, total_vdev;
>  
>  	mutex_lock(&ab->core_lock);
> -	ath12k_link_sta_rhash_tbl_destroy(ab);
>  	ath12k_thermal_unregister(ab);
>  	ath12k_dp_pdev_free(ab);
>  	ath12k_ce_cleanup_pipes(ab);
> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
> index 99d71dab7c04..bde3b4985023 100644
> --- a/drivers/net/wireless/ath/ath12k/core.h
> +++ b/drivers/net/wireless/ath/ath12k/core.h
> @@ -17,7 +17,7 @@
>  #include <linux/of_reserved_mem.h>
>  #include <linux/average.h>
>  #include <linux/of.h>
> -#include <linux/rhashtable.h>
> +#include <linux/hashtable.h>
>  #include "qmi.h"
>  #include "htc.h"
>  #include "wmi.h"
> @@ -510,8 +510,8 @@ struct ath12k_link_sta {
>  	 /* for firmware use only */
>  	u8 link_idx;
>  
> -	/* peer addr based rhashtable list pointer */
> -	struct rhash_head rhash_addr;
> +	/* node for ar->arsta_hlist, the peer addr keyed hash table */
> +	struct hlist_node hash_node;
>  };
>  
>  struct ath12k_sta {
> @@ -658,11 +658,21 @@ struct ath12k {
>  	/* protects the radio specific data like debug stats, ppdu_stats_info stats,
>  	 * vdev_stop_status info, scan data, ath12k_sta info, ath12k_link_vif info,
>  	 * channel context data, test mode data, regd_channel_update_queue,
> -	 * peer_delete_waits.
> +	 * peer_delete_waits, arsta hash table (arsta_hlist/arsta_hash_bits).
>  	 */
>  	spinlock_t data_lock;
>  
>  	struct list_head arvifs;
> +
> +	/* per-radio hash buckets for station address lookup */
> +	struct hlist_head *arsta_hlist;
> +
> +	/*
> +	 * Number of bits used to size arsta_hlist (arsta_hlist has
> +	 * BIT(arsta_hash_bits) buckets).
> +	 */
> +	u8 arsta_hash_bits;
> +
>  	/* should never be NULL; needed for regular htt rx */
>  	struct ieee80211_channel *rx_channel;
>  
> @@ -1149,9 +1159,6 @@ struct ath12k_base {
>  	 */
>  	const struct ieee80211_ops *ath12k_ops;
>  
> -	struct rhashtable *rhead_sta_addr;
> -	struct rhashtable_params rhash_sta_addr_param;
> -
>  	/* must be last */
>  	u8 drv_priv[] __aligned(sizeof(void *));
>  };
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 01f8c6572f65..d21b0b50853e 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -1185,35 +1185,6 @@ static int ath12k_mac_set_kickout(struct ath12k_link_vif *arvif)
>  	return 0;
>  }
>  
> -static void ath12k_mac_link_sta_rhash_cleanup(void *data, struct ieee80211_sta *sta)
> -{
> -	u8 link_id;
> -	unsigned long links_map;
> -	struct ath12k_sta *ahsta;
> -	struct ath12k *ar = data;
> -	struct ath12k_link_sta *arsta;
> -	struct ath12k_link_vif *arvif;
> -	struct ath12k_base *ab = ar->ab;
> -
> -	ahsta = ath12k_sta_to_ahsta(sta);
> -	links_map = ahsta->links_map;
> -
> -	rcu_read_lock();
> -	for_each_set_bit(link_id, &links_map, IEEE80211_MLD_MAX_NUM_LINKS) {
> -		arsta = rcu_dereference(ahsta->link[link_id]);
> -		if (!arsta)
> -			continue;
> -		arvif = arsta->arvif;
> -		if (!(arvif->ar == ar))
> -			continue;
> -
> -		spin_lock_bh(&ab->base_lock);
> -		ath12k_link_sta_rhash_delete(ab, arsta);
> -		spin_unlock_bh(&ab->base_lock);
> -	}
> -	rcu_read_unlock();
> -}
> -
>  void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
>  {
>  	struct ath12k_dp_link_peer *peer, *tmp;
> @@ -1262,9 +1233,10 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
>  	ar->num_peers = 0;
>  	ar->num_stations = 0;
>  
> -	/* Cleanup rhash table maintained for arsta by iterating over sta */
> -	ieee80211_iterate_stations_mtx(ar->ah->hw, ath12k_mac_link_sta_rhash_cleanup,
> -				       ar);
> +	/* Cleanup address hash maintained for arsta on this radio */
> +	spin_lock_bh(&ar->data_lock);
> +	ath12k_link_sta_hlist_flush(ar);
> +	spin_unlock_bh(&ar->data_lock);
>  
>  	/* Delete all the self dp_peers on asserted radio */
>  	list_for_each_entry_safe_reverse(arvif, tmp_vif, &ar->arvifs, list) {
> @@ -7101,7 +7073,6 @@ static int ath12k_mac_station_remove(struct ath12k *ar,
>  	struct ieee80211_sta *sta = ath12k_ahsta_to_sta(arsta->ahsta);
>  	struct ath12k_vif *ahvif = arvif->ahvif;
>  	int ret = 0;
> -	struct ath12k_link_sta *temp_arsta;
>  
>  	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
>  
> @@ -7130,14 +7101,9 @@ static int ath12k_mac_station_remove(struct ath12k *ar,
>  
>  	ath12k_mac_station_post_remove(ar, arvif, arsta);
>  
> -	spin_lock_bh(&ar->ab->base_lock);
> -
> -	/* To handle roaming and split phy scenario */
> -	temp_arsta = ath12k_link_sta_find_by_addr(ar->ab, arsta->addr);
> -	if (temp_arsta && temp_arsta->arvif->ar == ar)
> -		ath12k_link_sta_rhash_delete(ar->ab, arsta);
> -
> -	spin_unlock_bh(&ar->ab->base_lock);
> +	spin_lock_bh(&ar->data_lock);
> +	ath12k_link_sta_hlist_delete(ar, arsta);
> +	spin_unlock_bh(&ar->data_lock);
>  
>  	if (sta->valid_links)
>  		ath12k_mac_free_unassign_link_sta(ahvif->ah,
> @@ -7155,7 +7121,6 @@ static int ath12k_mac_station_add(struct ath12k *ar,
>  	struct ieee80211_sta *sta = ath12k_ahsta_to_sta(arsta->ahsta);
>  	struct ath12k_wmi_peer_create_arg peer_param = {};
>  	int ret;
> -	struct ath12k_link_sta *temp_arsta;
>  
>  	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
>  
> @@ -7166,22 +7131,11 @@ static int ath12k_mac_station_add(struct ath12k *ar,
>  		goto exit;
>  	}
>  
> -	spin_lock_bh(&ab->base_lock);
> -
> -	/*
> -	 * In case of Split PHY and roaming scenario, pdev idx
> -	 * might differ but both the pdev will share same rhash
> -	 * table. In that case update the rhash table if link_sta is
> -	 * already present
> -	 */
> -	temp_arsta = ath12k_link_sta_find_by_addr(ab, arsta->addr);
> -	if (temp_arsta && temp_arsta->arvif->ar != ar)
> -		ath12k_link_sta_rhash_delete(ab, temp_arsta);
> -
> -	ret = ath12k_link_sta_rhash_add(ab, arsta);
> -	spin_unlock_bh(&ab->base_lock);
> +	spin_lock_bh(&ar->data_lock);
> +	ret = ath12k_link_sta_hlist_add(ar, arsta);
> +	spin_unlock_bh(&ar->data_lock);
>  	if (ret) {
> -		ath12k_warn(ab, "Failed to add arsta: %pM to hash table, ret: %d",
> +		ath12k_warn(ab, "failed to add %pM to hash table %d\n",

it is warning, so you can have colons before error code:

"failed to add %pM to hash table: %d\n"


with that fixed:

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
