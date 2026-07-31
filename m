Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0E23368A3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488858; cv=none; b=mB8855wKVtxkRu3Sfw08C0RtHJZQpRjxGdYy1tIXIhPvsxcuw8fbF9hEA8DUHtLyDfhToQctRNwW1dvkm3hcmcpxos2lHZxyvXcoB7nMRb9PDN/DezrULe0sECP34q2AkFSJteU2gu6EkJXxF60qkgt8VJbzwU+SXI7RQEB0s68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488858; c=relaxed/simple;
	bh=Cv6McRZfC0vLqnLss+MAqfDIHQbuPP6xDBF9KkgDCHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FdlmHn+Aua4+eZ1SsMeZ0bpkX4MZK7A2+Ieawd6jKegnXIVw+T633LaiwaQzK2r73bfIXqO3Mdp7EsYjXHC66tG57o9dxhmq2YIVA5F1flplWV8dHYZ2OjqzdX+1QD8SMdGxWdgAfo1s/aWr6KzOUuatN9qH3tl3YWkfmwAJI4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZFER2MqW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e90cxzYo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZFER2MqW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e90cxzYo"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8lPLN2991333
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FKqhQPZyBwZ4oy7X/APXLY0ykWXFwIpRNGZDu5Vj7iw=; b=ZFER2MqW0V669Z9o
	0G/Uf8oyXbDt2XRwQ6DhHWatjPP1fATBHeCrNppbMT1uubhNyM9cD4k5PU1bsA4g
	XwAPBDhFngkGkyDUTepJPPFia5B3PtvJh02WTV1FpYeRORGH/CGlOyJnvgHPpjbx
	5Hvmk3xtc2vXLlmVvxJL8jTOogP1ND++p+npcLSAkztisrP2yhnowvMWNa5ajwin
	24xSqUjpDDS+nfyBr2fTD7+rD065yjD46yP/MOstiG9GWqki6MTKgQbOsS84wPOc
	nlLo6LQpLxAnNl6cKx4qHjkrHUoUqs4OLW484sHESy0NTvus071C0vd0EEdWyU4K
	oSTntw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frrgpg04j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:36 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccd1958e8fso10255445ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785487716; x=1786092516; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FKqhQPZyBwZ4oy7X/APXLY0ykWXFwIpRNGZDu5Vj7iw=;
        b=e90cxzYo2ktoSlWKFQ8O9WbBS3lbQQO0/8wkLc5MKkFYnDA6A7ggP545G3rWHvWCAb
         pkU94Gjv+lboA6IeBQdUYa/5Qm6P3rqCXtRsB3f8RLKJhPwawxJOQDEJ+x3I8ndzXl7r
         mGzRmsJvVnEc+8HIMUxyeQyAe5FsKRg/wnwghsDFTwkADysYEzDl9lc6ulLKP0Cwu99J
         ZsKq/gaykrLJWezWoIeqT6U5KOYTTxp4Tvs+qEAX1LqHHKdO4GBjxA2VvkjaZPedpgwP
         MC4BI9nLONcSfnfoTEkVVSvNf8ffhZn0KgA4LlcjvVHZ/Il3vAjBBdXcR/c2U1FU3TNy
         1NuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487716; x=1786092516;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FKqhQPZyBwZ4oy7X/APXLY0ykWXFwIpRNGZDu5Vj7iw=;
        b=TYacmJVNHo/vyIriioLqEXyYKjAPXR/iC3Wea/JAYjlMMqe9u/ECymcW35H7+eO0hq
         D5Ek24RDz/RW+Ue9SOjYvI3guCt0TCoNjeuSADsaQMovrfRoSopTdbMxWNI3knObf0xh
         eodSxZEgW2ZkmCFnbBFGolh9ybJWb148FiZ1SLUa9Skbtd4qq1oGcbc13ek8dgTqbFfI
         TAJa9+9zMGdskMBk+tMSWTbLhHjBsBK7CQnXLjB2t6XffkBdGszor/F2YXEYYuLGY7b+
         1xVHuuymlcwZTZ7jkyE/QoPj4/lurmjAdZJxynNz6tQKt2y4jelQtDt1nQqoeT8qB3W/
         fOkA==
X-Forwarded-Encrypted: i=1; AHgh+RrQFL0vLV9awQCGr1TXz+9ib20GwbezQfGarnltKyDED9Um7TfdEHJKrMhcTgUXJqIYbLqCbzQlVGr1cUxGrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgWLebrieJYGd3CoquNGvd7zecgJ3Fc/yuHBd3GhzekAQ7mRCM
	eUYCB5jj1ClkCAjr3mri4JPHCe82xEkKU8kbHvlAGkWzBSquueU4WkvMpxEEWlbU8QVW/XP6OiH
	b0XXi+ShZNfeqXIvRPAxJnI3HNy7Pkht82UvnRyvtDwO8EwVlKPk1rzWtcixlsXKe5gL39hWOJU
	e0xQ==
X-Gm-Gg: AR+sD10DTFSTGsKtJ+lBe212T+NIT1d2oStme/3vvYhD8HAatL9w6SXfscO6p1+Qc8n
	rV2Ah79MJdpzOVR12Kow9oqnL1R08uG9F5BkSawMDg/JPl9kRiTzhuPgiivZTyhVXN3GSB3wgfL
	mEgxfh81JdKqr2513SrMKo5WJxy/MDLYz1TtZ/5BR9S+diPmgXO5DfHYUmo0uwFHdJa4Va2+9Dp
	kqYyGkuhCnRv1ZAvLGd9hGe1eRhBL1JfVL2GNvFpG9derXnI+8Cie+IdshfKmrtiXBnuWai/x18
	6WhBXUthI7ueqAVZReAX8aLwJ1OyEDsJjigsM9FebTzOZroP+qWzThJ6qyY5hXE4ZQsnW67UO6F
	Q7G+CnV4XUaXs1s2GrcC4mqVEm3crLpLmx2WOGQz5QEoA5+pQL1UN6dy/V8WjGRyjIpTbuLxczg
	==
X-Received: by 2002:a17:903:191:b0:2ca:bf8e:35fe with SMTP id d9443c01a7336-2d046da5e90mr12155905ad.16.1785487715790;
        Fri, 31 Jul 2026 01:48:35 -0700 (PDT)
X-Received: by 2002:a17:903:191:b0:2ca:bf8e:35fe with SMTP id d9443c01a7336-2d046da5e90mr12155795ad.16.1785487715368;
        Fri, 31 Jul 2026 01:48:35 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm2603905ad.66.2026.07.31.01.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:48:35 -0700 (PDT)
Message-ID: <87f02c36-6257-4713-8d39-370f575ecd1a@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:48:31 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] wifi: ath12k: fix MLO beacon handling using per-link
 addressing
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727162748.963275-1-jtornosm@redhat.com>
 <20260727162748.963275-5-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727162748.963275-5-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: mxfyviCziDUMcIs_5DAkbmWWV-rfSaP0
X-Authority-Analysis: v=2.4 cv=SK5ykuvH c=1 sm=1 tr=0 ts=6a6c6164 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=20KFwNOVAAAA:8 a=wMn7BGEeBF2Z8DAmW_4A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX75AT+kunH/1Q
 jhRecZARtYu2HasFzsuoWlt3DcYTRt0BxAwR0g7Jam68zj0bmfbIDo6HIIpoPySHjLwiE1DVvsU
 QVNkBJYtqCA1CXpqG9okChvQz2WEIzEUk8vM2YzBxGB6yWGiX2+e0AWwZYmMXWoJO3jpXg/eMoM
 ElM95YRzsRjhgLAaMsTL9+BZkz1ISkNhmL0u8NLFdRDzC0bYfvo9ESFdU79svN0FKPjay5hsltA
 qOj0O0BZ2ZR8qqzMGXUrZCrRn4XvNtpOjw6PqEzkqP6roSeo/a3Wql39+kHEKs8Xqg4uUqDTAaf
 Ri1by7FJqcrLFXXWGAEeVC9tdw8ShPgjSRWLtinzNs1k8VHmOpzBy0Xrsl2LTsbHGI9jh7/xDfr
 /m6rhJVl6aUmGmnxO3/jP46uvlvhquBhHTx9UCDagdfDynR7W1wDFXAn2loDmr/GV+3WuSBKzcy
 FEMoXpWA/n3rJWSTt9w==
X-Proofpoint-ORIG-GUID: mxfyviCziDUMcIs_5DAkbmWWV-rfSaP0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX7CCHK6nsLAE9
 XmYfx7GviucmxwjhWdcylx09G4jhipBRJoQxqJkyBpcF0QT+rQ+1gj7bgPpZEu3whvM8KDUxrEI
 IHtcy7jGgx/T+w81jvWoek9gFmU5bKw=
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
> ath12k_mac_handle_beacon_iter() uses ahvif->deflink for both BSSID
> matching and connection_loss_work cancellation. In MLO, deflink is
> only the first link created for the MLD VIF and does not represent
> the other links. This causes two problems:
> 
> 1. Beacon BSSID matching only checks deflink's BSS config
>    (vif->bss_conf.bssid), so beacons received on non-deflink links
>    never match and never cancel connection_loss_work.
> 
> 2. Only deflink's connection_loss_work is cancelled, leaving
>    non-deflink connection_loss_work timers running even when beacons
>    are being received normally.
> 
> When the firmware reports a beacon miss event on any link,
> ath12k_mac_handle_beacon_miss() queues connection_loss_work on that
> link with a 3-second timeout. If a beacon is received before the
> timeout, ath12k_mac_handle_beacon_iter() should cancel it. But the
> deflink-only handling means that for non-deflink MLO links, beacons
> are never matched and connection_loss_work is never cancelled through
> this path.
> 
> Fix by handling non-MLO and MLO cases separately. For non-MLO, keep
> the existing deflink behavior. For MLO, iterate all active links to
> match the beacon BSSID against each link's BSS config. When a match
> is found, cancel connection_loss_work on all links because the
> work callback calls per-VIF ieee80211_connection_loss() regardless
> of which link queued it.

is it legitimate to change mac80211 to support per-link connection loss? if not, better to
move connection_loss_work from ath12k_link_vif to ath12k_vif ?

> 
> Tested on WCN7850 with MLO (Wi-Fi 7).
> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 36 ++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index e36a37852fab..ebc35636b4ef 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -1946,15 +1946,43 @@ static void ath12k_mac_handle_beacon_iter(void *data, u8 *mac,
>  	struct sk_buff *skb = data;
>  	struct ieee80211_mgmt *mgmt = (void *)skb->data;
>  	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(vif);
> -	struct ath12k_link_vif *arvif = &ahvif->deflink;
> +	struct ieee80211_bss_conf *link_conf;
> +	struct ath12k_link_vif *arvif;
> +	unsigned long links;
> +	u8 link_id;
>  
> -	if (vif->type != NL80211_IFTYPE_STATION || !arvif->is_created)
> +	if (vif->type != NL80211_IFTYPE_STATION)
>  		return;
>  
> -	if (!ether_addr_equal(mgmt->bssid, vif->bss_conf.bssid))
> +	if (!ieee80211_vif_is_mld(vif)) {
> +		arvif = &ahvif->deflink;
> +		if (arvif->is_created &&
> +		    ether_addr_equal(mgmt->bssid, vif->bss_conf.bssid))
> +			cancel_delayed_work(&arvif->connection_loss_work);
>  		return;
> +	}
>  
> -	cancel_delayed_work(&arvif->connection_loss_work);
> +	/* For MLO, each link has a different AP BSSID. Check the beacon
> +	 * against all link BSS configs. If any matches, cancel
> +	 * connection_loss_work on all links since it calls per-VIF
> +	 * ieee80211_connection_loss() regardless of which link queued it.
> +	 */
> +	links = ahvif->links_map;
> +	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
> +		link_conf = rcu_dereference(vif->link_conf[link_id]);
> +		if (link_conf &&
> +		    ether_addr_equal(mgmt->bssid, link_conf->bssid))
> +			goto found;
> +	}
> +
> +	return;
> +
> +found:
> +	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
> +		arvif = rcu_dereference(ahvif->link[link_id]);
> +		if (arvif && arvif->is_created)
> +			cancel_delayed_work(&arvif->connection_loss_work);
> +	}
>  }
>  
>  void ath12k_mac_handle_beacon(struct ath12k *ar, struct sk_buff *skb)

