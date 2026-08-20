Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31947F779
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248581; cv=none; b=PkS4ZWCXq1d0lS6JJ8EqX2NGgTtG0XWdTm3Lp1QZtR+TxxxR00iX21uitx6rG9O1r1bkt/Vjc/ittk4y9oBsj+tCSmTeVMYxLlxIk6fPsuADBZOrLj7m3fZuAY0N0I0LaIjReMUffvvbGPFqVYfFQk1PF2PH/cyCdKi1XMi+B9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248581; c=relaxed/simple;
	bh=MBSy0vXXrvlRLW7Nnr6cbS19MYEUw51WnQhxGTtmf70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIJp1LcZjyunctSuM6xpcniPOsNlpQLp2prjV+31MPwqL6hAIWfspShd85XcFtRNEv4sr67nYeYT0uC58V3mPrlylHIcBYinyijBkNQ3BWDHGL6dMjRpMISlGPFoBJSnztghofJuT7ncOTuYPPhbF5zTSFUVe9oaAhUtu6JvRl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VR/Eg9Ty; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DhgFPoej; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VR/Eg9Ty";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DhgFPoej"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KG6oRe777204
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 17:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qGTHQM6yXTCq7iCsg06gYiI/zbE8XuFZp0lB3XIIEd8=; b=VR/Eg9Ty9X+sPHRH
	vlDtUh/9W2Vgu/NdlrP37kJkqWRCh3jbrtERm2JMqAGCaiRsO4LMM1UXja60GjMW
	LmryfAy/XQz9bfqXFZxRLwdu6T8QpuNA5MoIOXniGw9rFU+pG/IA6BB9dKc6ITlQ
	L/vo5Jmev94R3NKBUOcBBckJ16UXNY9FkN2X5VvTYm1YVZZ5G5s3lOs7jOeyy9VO
	2P36Zel3sGU+x8KMxl6Uqp0AtuQ1TVK46hlEG94fY0/nROEMxNyuMdXjnpBvuAyE
	oIFu8dByausdXSafifshJobofGutW2HpsvmQSZUwa3dQK/8tXkhyD11lkI7Y8EGU
	5kSwZw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5vn8awak-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 17:56:19 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc132709c76so193779a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 10:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787248578; x=1787853378; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qGTHQM6yXTCq7iCsg06gYiI/zbE8XuFZp0lB3XIIEd8=;
        b=DhgFPoej6VkdW/497ieHZZ+Jgy9CrUJ730RRNkV/lVtGJK0jjWlqJrIndzhcnUsWed
         mbFiTY5o+/1fwnv6z76608x3nUp+GCl404oXFHB2QmXWZpzMyv3i4WYqjHv5qKf+QOq1
         VFOUQFjT2xw3W4m0nsE9diPXDPIbYNhHGA9rz71uKqU48Ldyzb3np/LvV7tC9i7CdIzP
         sV28pqcB3BJV6rmj77NukpBPHMOQk5vTCc/BSxFY7dNHgDKXcoz6KaZWq2p2RCwnIrU5
         sPazTIsRG52FzKJ08gEh48RUjTR04qQfljdqDFHyOynCmKdi/ojwZp886hYFM/oj1ZyS
         UYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787248578; x=1787853378;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qGTHQM6yXTCq7iCsg06gYiI/zbE8XuFZp0lB3XIIEd8=;
        b=WMPCWAbZFc+tO3ap7N9keElJM0+C/lvItRI9xxRXaiWlGOefa7rExBYVH6iwSzc/sk
         Qd4a3rHVGQaarnMgOII5C41btZx+PPFIXwIDiki8tpRHApA+mmkKDuRkpkOKnTEqZBbl
         uLShlIPtP7WARPY6EpbdK06HI2wmkCLoVWC0epUZoJh2kBU4N0E3bUNPawNXB4WTzONu
         ffW0IviW60pbN0kznlYqEwbNAddFY5gMHh1ODsoxjeUlnFYIJNssXn+4EznoU6X+v9/R
         iXepbYFkK+8O4+Fj5lGOIctgfPjFX+TobCGzas+EUepe/Ejm1/ha7nhsnv/Qz2+mK5TJ
         Q31w==
X-Forwarded-Encrypted: i=1; AHgh+RraNfSlldRzx/stBcdKSwLMMFS6oqXWUwaOvzvVIdM3EGmDMvYGHpSCfakvDW1CI0gHKPA+aXd3FDux8y5t7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYMCMrYNKce8Of8Jh5UgHNFj8WZ7HoM31cFwx1fYuAN75N4RxU
	HLtE2reRCLcjoj8hY+hMNKdqgtlEYkDrKAPy95/B3SPvQxOx78Ti+3D6glOILG32KlUDiXMPktX
	wdkuUbv/ifOUsEmUFHR7WKg6jrRdqFhaR/fw0HT54n1yPEpbnNr8IKsiMa/UzH8v6gvY/RQ==
X-Gm-Gg: AR+sD13KtBF87iPdDzYqZzr3uOqCrQ2BXMbTjqjnk4QSYDkO6pBWouKY8JAb3FHEsEi
	u7JbxR4Xq/Z1n8DSi4hdo9Z5nkj/0mVhJTE2n4Eu5niv3/+XWS8MzgE3BQt2NTJgRlxm7Ap6Y2r
	WbIAAJCD6JXDUowQSaHz9qNv3vGlcIHkUHf5DJd86X3qgw7bkcZS6uZA278bftvjcshJuIzcLud
	UnxL6JXVpvpN8GIexH2Rbb87FPqA0VN2GwKi6ZL2gmKDW8T6xWZnZ3HSiIO1y7XbZVxE2lpi9AI
	myIapo3CQ7bBzUF1il4sN4JwfaWwt51FQ0o9uFcEarISXtgFnoNY/U5LOLApFLB7JmbVD73RE77
	F6ddszIppe50K40GlR5XVuBZ53jeKp2ND6hVmbmobE44cTas0SUW5+kY=
X-Received: by 2002:a05:6a21:600c:b0:3b4:61f:1fec with SMTP id adf61e73a8af0-3cd2fd8e339mr427546637.2.1787248578381;
        Thu, 20 Aug 2026 10:56:18 -0700 (PDT)
X-Received: by 2002:a05:6a21:600c:b0:3b4:61f:1fec with SMTP id adf61e73a8af0-3cd2fd8e339mr427415637.2.1787248577835;
        Thu, 20 Aug 2026 10:56:17 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc15523489fsm2134371a12.5.2026.08.20.10.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 10:56:17 -0700 (PDT)
Message-ID: <1bdf4b7d-2f05-4ae3-8304-60697d2c849d@oss.qualcomm.com>
Date: Thu, 20 Aug 2026 10:56:14 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v3 2/8] wifi: mac80211: change public RX API
 to use link stations
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, Benjamin Berg <benjamin.berg@intel.com>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net>
 <20260819155703.af6d319e6b61.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819155703.af6d319e6b61.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDEzNCBTYWx0ZWRfXxtowgzFDM3uM
 7jlEvEP2YWJnOs4Okmg2S7ipFbsIqryGugTh0ks7BkFa0j8wfWHMbp0VH0eWtcLTfc1t7Df3roS
 3bDR8DV2gspB3iKR+CR7JnmYZS0sRNVxe5KMd3PQCh1VbAbyhto7D2RXYXLVHmdLIX3FprZgEBq
 Dj6vC66pS/3R4ZDKiCyfHeGELNYrvbja/pBFFGdN2gUwurShwQgVjGqtmP3Y0vC1inOnoOqYVbK
 z4vhaDQK+S1SzRUb5PsRo3jz3p/bue6LXf9cDV2B9rMP4ClgGTitmFUqzEkhSQI2L0145IX0+Jj
 7e9/28HXZvr5ShURBD6+gM6zPkdtc37CISjwnKlHqu8zpg32BjeGGbyf7m64MLVy31q1fNhUySI
 4K4yMzy/L8U77C7024xnAqg5flhbrKc5Q4mn281buiGJS9EL4SGVep3Cap3mBg84uHTtX7X5uD+
 Gb2BhS4iamaaL0Rz9qQ==
X-Authority-Analysis: v=2.4 cv=KpJ9H2WN c=1 sm=1 tr=0 ts=6a873fc3 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=hwlI8agmJUGWGRcycR8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDEzNCBTYWx0ZWRfXwcjqJbLbHOHl
 TFMLM4MfcPxqm1L25hiUoAYSPcUFZu4iNtdUuVjkrUv8zp03dloFxlfxUgm4g5uOXRO99t7ltmE
 8NbCQWg0UTVPbDfwgPqCe05V7rTQIVw=
X-Proofpoint-ORIG-GUID: CDyYeTRNonYc9v-aBrLa9G8z5CAQnJN7
X-Proofpoint-GUID: CDyYeTRNonYc9v-aBrLa9G8z5CAQnJN7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-20_01,2026-08-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608200134

On 8/19/2026 6:57 AM, Benjamin Berg wrote:
> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
> index abbe65cbcd89..3da06a55913e 100644
> --- a/drivers/net/wireless/mediatek/mt76/mac80211.c
> +++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
> @@ -1255,7 +1255,7 @@ EXPORT_SYMBOL(mt76_rx_signal);
>  static void
>  mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
>  		struct ieee80211_hw **hw,
> -		struct ieee80211_sta **sta)
> +		struct ieee80211_link_sta **link_sta)
>  {
>  	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
>  	struct ieee80211_hdr *hdr = mt76_skb_get_hdr(skb);
> @@ -1302,11 +1302,15 @@ mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
>  	       sizeof(mstat.chain_signal));
>  
>  	if (mstat.wcid) {
> -		status->link_valid = mstat.wcid->link_valid;
> -		status->link_id = mstat.wcid->link_id;
> +		struct ieee80211_sta *sta = wcid_to_sta(mstat.wcid);
> +
> +		if (mstat.wcid->link_valid)
> +			*link_sta =
> +				rcu_dereference(sta->link[mstat.wcid->link_id]);
> +		else
> +			*link_sta = &sta->deflink;
>  	}
>  
> -	*sta = wcid_to_sta(mstat.wcid);
>  	*hw = mt76_phy_hw(dev, mstat.phy_idx);
>  }
>  
> @@ -1530,7 +1534,7 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
>  void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
>  		      struct napi_struct *napi)
>  {
> -	struct ieee80211_sta *sta;
> +	struct ieee80211_link_sta *link_sta;

My review agent says:
**Issue 1 — mt76: uninitialized `link_sta` pointer on the no-wcid path.**

In `mt76_rx_complete()`, `link_sta` is declared but not initialized to NULL.

Then `mt76_rx_convert()` is called, which only sets `*link_sta` when
`mstat.wcid != NULL`. If `mstat.wcid` is NULL, `link_sta` remains
uninitialized and is then passed to `ieee80211_rx_list()`. This is a use of
an uninitialized pointer. The fix is trivially `= NULL`.

>  	struct ieee80211_hw *hw;
>  	struct sk_buff *skb, *tmp;
>  	LIST_HEAD(list);
> @@ -1541,8 +1545,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
>  
>  		mt76_check_ccmp_pn(skb);
>  		skb_shinfo(skb)->frag_list = NULL;
> -		mt76_rx_convert(dev, skb, &hw, &sta);
> -		ieee80211_rx_list(hw, sta, skb, &list);
> +		mt76_rx_convert(dev, skb, &hw, &link_sta);
> +		ieee80211_rx_list(hw, link_sta, skb, &list);
>  
>  		/* subsequent amsdu frames */
>  		while (nskb) {
> @@ -1550,8 +1554,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
>  			nskb = nskb->next;
>  			skb->next = NULL;
>  
> -			mt76_rx_convert(dev, skb, &hw, &sta);
> -			ieee80211_rx_list(hw, sta, skb, &list);
> +			mt76_rx_convert(dev, skb, &hw, &link_sta);
> +			ieee80211_rx_list(hw, link_sta, skb, &list);
>  		}
>  	}
>  	spin_unlock(&dev->rx_lock);
