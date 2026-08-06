Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E8A48AE10
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 17:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035764; cv=none; b=VBYSjknByz5BdcMB7frrXyOelEXbLIN2J5E6r0pne0TSIAVBxCu6RLh+qm9cFiOKCCXJkURWO33b0mNgjuWXaX9cW4kNbGOHlr4g0OXI/rN8AgTLUO/hbRfCitiaA7x0GuLTGAESSc7+emjx22PVuYxJ1TbBWDOJTHz3Afmhr70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035764; c=relaxed/simple;
	bh=P+pDCbz47jrn/xiecAobXyu7Oxv92qYTODILz1LIr2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aih92P2hJF4FqUT3msn4YFJWUvnFKx/VyWxmngT6nO4dpFWsGvTu5rms2b+A39egcVNnrO6TenCwBfMf+IrsdTk/4NCtDTB9nB80Cz7ApRhdPr0LLmyne6FrTfwSqLXyzMnKxrYV4Ac4hWe1gZGD3TatKbTbovzVvuVDWXuCPNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gGx/IwjI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aQNBEs8s; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gGx/IwjI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aQNBEs8s"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676EmRPP1553413
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 17:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	g3VeUVqapi4tcBbZLnOu5VVmOr4Pf79x2ozpolnDEFg=; b=gGx/IwjI7+kscufv
	/+oQKAKVfP7sEHomSZ8PPC7GwYdBa2SdQe8NyrXvbkpuH+gdUKMwuZ5cm3Esxs+C
	Y3ONFrWi1E/sGn8xHPkYkQNaNg78xbyTY2jBdV9cJ1C6RkXBOoVOhnG72PRn3Ete
	PZ3yRbxdvAvMkkeTIVE5YfeD2WBUdxcjTb5qMhYgpZv0WYPtGi7NFvNpTHLjR/Bu
	fvYJsYfXEzpePRU/pylEL1PCTwba/QUXlXnMju3zq+robBbrI8N+AYwrZ/9lea/D
	pEGUUqKB7abRiVqoA9hwi93gGjdSpjj4iePuI11rltKdtZPztZMpn/IhUuxpYTaE
	5lQcGA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvv5b0w7e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 17:02:39 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so3103641a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786035758; x=1786640558; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g3VeUVqapi4tcBbZLnOu5VVmOr4Pf79x2ozpolnDEFg=;
        b=aQNBEs8sSGLL6aWgUCbFLkcXaLLrZn7+KIMX4BLh+K8+f4+0O1kDLLUb6yluUDh5n/
         03fLCoh7wX+AYYFQwx4ufhMSRoVpeNSKshococMhOWJh25YgUNKXycyzNhi9AHyGIYPU
         hQRCkCE9eedQetPONiMABIzHbicUycB41+f4Hn1Zt/CEYt+qx0l9aNas16jxAMbT/9GH
         ruzh2PzmNS8binpQ7pDy9sygmhBWIoVAVXqSpBx1L2QY7U1Vs4wJ85ftK0jSYyqEWF54
         vjiBAfl6m1c8f94iNkmy4Bs0BvQdogXUJEYnJ1m0iZqOtWPvvpktQdID1Ip3+xX3RNXD
         MIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035758; x=1786640558;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g3VeUVqapi4tcBbZLnOu5VVmOr4Pf79x2ozpolnDEFg=;
        b=HsJO1GL0fw3CMWcq2W2VGGCbdq3ah7lhpS+te4eEh3eio2Djt3PmmTMieNNu0M9u8S
         JNOQdK//atsQaMhzvnRGGKLm6G/brNX658OQnGab5PRmi0gQl/SMURwWUr+qolYZn2Bl
         Vx9NQKEBsyI/9KnobGhS12FpovOgrIX9uRXC6NerkXVGPIseqOV0+vexZW5qLWgCs0I9
         CCcE6KiA5twSsyMH/515FG6inhlKzurTL1w1f8I/PPssw7KLfZClATTfQanBcakaY2ld
         wE/Hu6iS3PonWPq1z26/gM5Ll4sVKF7NatTuNpCDGfW/I6oIGEo0CIaQCbUztG7QD7fW
         /qpw==
X-Forwarded-Encrypted: i=1; AHgh+Rrwg6hTOWip5ntJBqlgAVCl1PvDipm5Q9UorA3KTuwC7yX0qt/KsnS2EZ/9I6v+OQ6SPurNz0V2yLtfephmBg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc89q9ODshAFn4eVaFFoB2pZzJ61f00EOjmZlCAOvQIPAonvo2
	ngIkcz6CJDLe9lKascCKY0zXzymrMSU3UTfi3XFopw/vVnjl7W342SPXFUJsPumyilb39VdTFyT
	Xm+NzAVSR1Un48f3Fxvzlox/VSV64Z9ebdzbVetN38kDXiEeP79VBaQt5Cula7VZC+PX8gw==
X-Gm-Gg: AR+sD12wrMB4gfmQZanq7nONULZDZtSRKZyptvsfyS3wlMMV1BHYI26llpCYyVGj5tH
	JeaLyM116jzS9UOD1T6nJkJWvnQuAeOeP/zqtCyHGqzsoXeC9F2PuJXk/lQqKlpl1nja+O2If1Q
	omq9VEALWZ/eXVtk0DaYlTPljhQzkdisFjs5hgWGTHPJHCb9p1Re4QtOGraeuvBPPkstu50xcp6
	elkIv6c6xXpuiScq43B8IzOlo/OrtCgFoUn1eol7apufyWYdr+bLnM2vcy5lPlSCDNNd7FGVH51
	TUfSz2pSESWxVdelDP93urNZp2TsPNWduZkhjBYFuPhP/WsZvjqQmACQXxDYBuanE00kTiWWgNv
	wxaKiYyB1zlZC+yjF0EFDHYN8GmFwPu+jnVAMmA==
X-Received: by 2002:a17:90b:2745:b0:381:3b5d:30f4 with SMTP id 98e67ed59e1d1-3903c535d84mr18192881a91.1.1786035758265;
        Thu, 06 Aug 2026 10:02:38 -0700 (PDT)
X-Received: by 2002:a17:90b:2745:b0:381:3b5d:30f4 with SMTP id 98e67ed59e1d1-3903c535d84mr18192762a91.1.1786035757444;
        Thu, 06 Aug 2026 10:02:37 -0700 (PDT)
Received: from [192.168.1.7] ([122.167.96.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085f2b2fdsm1900333a91.12.2026.08.06.10.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 10:02:37 -0700 (PDT)
Message-ID: <071404cb-3d65-4e12-8396-f86973673278@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 22:32:32 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 8/8] wifi: mac80211: pass error station
 if non-STA transmit was requested
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
References: <20260803123004.281626-10-benjamin@sipsolutions.net>
 <20260803143005.e05860849ef7.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
Content-Language: en-US
From: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
In-Reply-To: <20260803143005.e05860849ef7.I5ffe7bc0d4ccefca5c1e506d5d3d482e13989cda@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEzMyBTYWx0ZWRfXxou9hSVkUK2y
 rRrenrbEpt1atBuI3p/tTHM57MthICIxAT9q9M1ct51ow6CPpF1EJsX0aa+4ZnE9wOi1e4Aan/S
 csKrNtr+JrIyN0Zma6NyjR4aWny9nrnbYRX+sPh8QFUkeUAyEi4h41HjfVTMGEVEW2GC4Uwnxjt
 OhkyB4mH0mPyM3aO5pHZdZ123l2Q4nSqDuHoMorhCPwIPdFbBdJLw6rTCade/tvY7AFLnX3SVDt
 MA1NnYdiZoXlTDH1WCCmWsv2OVcl/2S1vWPgs9nwYDioOXHKnG8EFoQybE5tPRYeG/UZfyHgTvY
 Ctbp7p8WiwPl/3ydf9nEwwNgCJ38/n6IVEa+eo2l6hkJJvWjsXJX6jbZuVLd7ubrQYBsRxo0UaU
 EjmE407DXAwg9u7/cHY1cIC5ZwGVVl7SXn4ud3BXRhgMHDnrnFtPVsb7K1/eAOHYQNaw01jnY00
 1uIMmn8kmTVTL9ejAFg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEzMyBTYWx0ZWRfX7Vgu+t8U7eQ1
 C30iEkkrZPam+0qwkit0mda43YauZFhAZv2LFgG70QxBvNIhOxNV3nQvt8OP/+0UmDttVMLkEBa
 zjzReFXV9reAfvJSugdlYN2geLcIjYw=
X-Proofpoint-GUID: i-Dpcwmcl0ZFbOoM4S2ctrq5hQrWvSoW
X-Authority-Analysis: v=2.4 cv=W4gIkxWk c=1 sm=1 tr=0 ts=6a74be2f cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=T2dgUiDeKQM52uYAgV9W6Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=QyXUC8HyAAAA:8 a=XRTL8D9JhnaTZ-QnUTwA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: i-Dpcwmcl0ZFbOoM4S2ctrq5hQrWvSoW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_01,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060133



On 8/3/2026 6:00 PM, Benjamin Berg wrote:
> From: Benjamin Berg <benjamin.berg@intel.com>
> 
> When cfg80211 requested a transmit without a station, pass an error
> station to ieee80211_tx_skb_tid instead of the correct one.
> 
> Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
> 
> ---
> 
> v1:
>   * Only pass error station if NO_STA flag is set
> ---
>   net/mac80211/offchannel.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
> index 5cec8747b193..653710576831 100644
> --- a/net/mac80211/offchannel.c
> +++ b/net/mac80211/offchannel.c
> @@ -854,8 +854,10 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>   			need_offchan = true;
>   
>   		rcu_read_lock();
> -		sta = sta_info_get_bss(sdata, mgmt->da);
> -		mlo_sta = sta && sta->sta.mlo;
> +		if (!params->no_sta) {
> +			sta = sta_info_get_bss(sdata, mgmt->da);
> +			mlo_sta = sta && sta->sta.mlo;
> +		}
>   
>   		if (!ieee80211_is_action(mgmt->frame_control) ||
>   		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
> @@ -884,7 +886,8 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>   		     local->ops->remain_on_channel &&
>   		     memcmp(sdata->vif.cfg.ap_addr, mgmt->bssid, ETH_ALEN))) {
>   			need_offchan = true;
> -		} else if (sdata->u.mgd.associated &&
> +		} else if (!params->no_sta &&
> +			   sdata->u.mgd.associated &&
>   			   ether_addr_equal(sdata->vif.cfg.ap_addr, mgmt->da)) {
>   			sta = sta_info_get_bss(sdata, mgmt->da);
>   			mlo_sta = sta && sta->sta.mlo;
> @@ -1022,7 +1025,9 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>   	}
>   
>   	if (!need_offchan) {
> -		ieee80211_tx_skb_tid(sdata, skb, NULL, 7, link_id);
> +		ieee80211_tx_skb_tid(sdata, skb,
> +				     params->no_sta ? sta : ERR_PTR(-ENOENT),
While testing this patch, I observed failures in some existing hwsim 
802.1X/EAP/DSCP test cases.

The logic seems odd to me: params->no_sta ? sta : ERR_PTR(-ENOENT)

Since sta_info_get_bss() is skipped when params->no_sta is set, 
shouldn't we pass ERR_PTR(-ENOENT) when params->no_sta is true and sta 
otherwise?
This may be related to the hwsim failures I'm seeing?

> +				     7, link_id);
>   		ret = 0;
>   		goto out_unlock;
>   	}

Thanks,
Ramasamy
