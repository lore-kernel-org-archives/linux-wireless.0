Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F066435E930
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821548; cv=none; b=t0kFWEXqiswWzVKHx3eQRThUGDuCD/sZtuCx/HGItmm+0N/3FfCSvTzPI0eHileaC9Bq75Yu1VVhVbpqvT1/rHqHWf0YsgiNNc9LBq0sISWuF4ZeEH4xt7wznQhPwthoObaO5ZRHqnVBJm5Ha9jP3mbD+VghGGC/ZORIlGvTR/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821548; c=relaxed/simple;
	bh=wBWGsK9bEpRbxO2ksJLOtD52YlexuYgyYNYyuxJ2yhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=od151cYOr2xTXvAB9upgPU0DqSPSkzl3/m9sGv5F/2sbWkX3tH3ssSZIAKPEssG1aig+wslE98jVRnxWyN1CnDFJSltQ1rOaBk1h5CRgPR0ps8pd9kgR6Nc0MFNBAkYZ7TCTcZBo2lQr9P2XaO3XfhrgbF6F6B+9rHuw+4blCPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PYTD+Mf+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F8wvpS+V; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PYTD+Mf+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F8wvpS+V"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NCvn9K011770
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 15:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yGldtjWtoAZeUpRF2fyi1CaIWl9IkMdaVdhUWFMLlss=; b=PYTD+Mf+iZ44FGoK
	sNuX3WUdDjSOWKz7lPNfYBA7LSF9nH4CqRPWhacMOK7NLhkEG4qOhTd23TXRS8BQ
	YgrtiKqxrTR5W4911vetFMvU1pdwu/T8lE3o7T3+qfE5PaJ3xNzw/nPl07JZeInF
	UbPG6kZmpbjtvNRPMhbFTk1PmN67Z2KUSQw/2T9rIi3ErZ5q4Nvo74lzvziKh1Ya
	R9cNGvGeRx+FzuEg25/HvkztppnQeeHu3JMwt3pjp19xMyVF7WFyzo911tN+/85n
	HkGIeewCa5EBcYRoHfLAqs/GOKQjqbW8brtl7aSq6E93vp/ym8Tj2ZSdONaYYcVr
	hQPDqA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkayhayxf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 15:45:44 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso1487706a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 08:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784821543; x=1785426343; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yGldtjWtoAZeUpRF2fyi1CaIWl9IkMdaVdhUWFMLlss=;
        b=F8wvpS+VHK5ZoZbdRc2maAo59penHZ2m69yMkCd49kdxOYHQ9IOGhjZHoRYe0lt44o
         EpP4hzSxN4Ik1ihrsOJzjiWhYHAbK9EMQRfCRNfyAbGsEsRqxQP34iGJ406I/bq1O5Dk
         +vtXMck8JK8zo+EAJWtVDQQbHfKBGvGiG3l9V3PILa3Uj+w906OHiSeT0xTGxB6ojm8f
         c8F0MAMR2bAcNNtKeyA+q42BOfBOiNZm6ba8ivbE9CvCxUiqM4/Iu+gCKqy/usbWcTtn
         siiFjU3ooIsAXxp5UwMza2+uThQgdiYHctMbIpwElY+1cA2ndjjOJWVTCWPlVoK14l1G
         PmrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784821543; x=1785426343;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yGldtjWtoAZeUpRF2fyi1CaIWl9IkMdaVdhUWFMLlss=;
        b=LYVcEqGYJHWG26q5ZZtcozc4et5TJhMSllmvkfm4QMHOIY7jlXkyD94v+NbGkIdbIk
         vRTXwYdsSQuP5El5ToHSBsKli6nI/FVnnOO5wGXwKWPsZIAAibW/scdsi9pnD5wiOdMT
         TQTuv9/9T4tymIYWpe7XgiCJVL5ViPQ8McQj2LjnfRKk5TAQlP41+hQ8jc1kbZsLyuc7
         wy9/bvu4cejNQHmFbas6MXk+dsGUuuWzVhj/0LP1f+CxdpmS2foCFdMoCxoTfDp9s6mO
         NCgwcRukBb5qukZ1/SycH2Y2cn9xat82rYIjaS9eGRJZajgid/U6Ygkrebu9UUvAebbc
         JFQg==
X-Gm-Message-State: AOJu0YzMD+oYHNy6wY0nlmXNVBYCsltutIg8JAArNsm7ACCv6JcGyaAg
	4jDUZ3/aW0Zg7z2bNBo+ysWJTA3HExmXihKN1F+uWE7vmmZMGrLyjIzdj6u/NpXj+YBVIbrffLu
	uW69/jhKgEbnPkabxq/9Klr7Vnb4JbzMeIBUY1C8EarZgdQCF9iW765mfJZThTeYaEL43Zg==
X-Gm-Gg: AR+sD10rryvHy7GBYCtiHUJCTvkxYef8dM2G8eE+ZNywMiL3dnkoKX4wYIrug8o+LE4
	u5+/X0L6ge++57g9aMDdgqIj5tCBCbRULpBbxeBA37k+u+lR+CZ7ttIr2bTqJ1sZIwDCfYMfeeY
	BdqOURGChTPacMLLohVXrY9nNZ1bL4RMUAZpvBtUHrkCiGCYe8H8qGcwbUPFNcEMkuPruOFn3Yt
	RIJejxyaF62WxuYO7cg8sqB8xKqYSpYfyaRESaRkhWfZevbFBDz5MbTEVbVKc8Cf2bVBBB0/wGY
	4/JcbVKfk1KzLVhvfWpGqw6TlBAVa7e9O3ArBSxLs6NZqAjt5Ovw6SC7ccMPrh6zSMqgp2SZxNI
	zHNJ80rE4eGx82A4OTfLS6TamMrleZKjgW40/jaaP+kB0RpAqfR6IdAxweA==
X-Received: by 2002:a17:90b:33c1:b0:38e:92e5:48f5 with SMTP id 98e67ed59e1d1-38ec6565e61mr3564613a91.24.1784821542676;
        Thu, 23 Jul 2026 08:45:42 -0700 (PDT)
X-Received: by 2002:a17:90b:33c1:b0:38e:92e5:48f5 with SMTP id 98e67ed59e1d1-38ec6565e61mr3564581a91.24.1784821542180;
        Thu, 23 Jul 2026 08:45:42 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130262d2sm15329291c88.7.2026.07.23.08.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 08:45:41 -0700 (PDT)
Message-ID: <21084de4-cdf5-4a99-9e0c-da4db067e4f9@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 08:45:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2 1/8] wifi: ath12k: fix out-of-bounds
 clear_bit in ath12k_mac_dp_peer_cleanup()
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
 <20260720-ath12k-fw-allocated-ml-peer-id-v2-1-630632758a80@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-1-630632758a80@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=HZgkiCE8 c=1 sm=1 tr=0 ts=6a623728 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=Qi-GXyMJ-ei9_mG92UcA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: yv64AaC7Mk_F6oWC2tJLX9QXoiFtPJRV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE1NSBTYWx0ZWRfX1hGwTvHsBWtP
 HkllnQL3uXMzgQdk6sxLSUzsWjimxrgV9cfjNQVtXAYYx8U+ZRzFnP9ElMwV1KQJZd4y1lVV+8U
 DMJhQAh1AXFsZU6V1GSkDm8p7ZvoGJ4LVBvjU1YeDZyvzMy90mbzY/gMiz8+PH2cccp0/SnLqyr
 qNdK/w7vZwHrsx8b3meOTmIdXtw2Swos5vab3X6E9vbjVBAjaUfS7vslDgeAsr+OgVbxfuEOGoI
 Eb4v8VHTocTYr7TMSFXa9lYA/CYANBKHaS5zD3U3M7tyvORtm2cKe1B0fsogazPZTVLbVA8ToBZ
 eoQDbRHvteAYvKyMDZwgtfKpD4XYIfvCLmmEePhPybaUCYXjPcik7d61btcsXc7OVyw3uJqwzXW
 bgRb4FGLwZWFjtTqHxAVdrruX7UHO1YcqPCHhtpr5ig99A+Q/nNVbMhaYQttNOBK3VWq5Io34mQ
 cjB5+KZWSEyy2n7yEwg==
X-Proofpoint-GUID: yv64AaC7Mk_F6oWC2tJLX9QXoiFtPJRV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE1NSBTYWx0ZWRfX3WdlP1cekR2n
 F5+Yx5OtP3XCoolKUa4CSqdjg4UDIF2OnGpjtpp3QJDjTmtIzkRNoltHAGddeZaXxcsWkBl11Jd
 5hfLoPBiPt5d5svwitbb7ln0r7ZC2P0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607230155

On 7/19/2026 11:43 PM, Baochen Qiang wrote:
> ath12k_mac_dp_peer_cleanup() clears the ML peer ID slot on the
> free_ml_peer_id_map bitmap by indexing it with dp_peer->peer_id. That is
> wrong: dp_peer->peer_id for an MLO peer always carries the
> ATH12K_PEER_ML_ID_VALID bit (BIT(13)), so clear_bit() is invoked with
> index >= 0x2000, which is far outside the bitmap of ATH12K_MAX_MLO_PEERS
> (256) bits and corrupts memory adjacent to ah->free_ml_peer_id_map. The
> intended bitmap entry also never gets cleared, so subsequent
> ath12k_peer_ml_alloc() calls eventually run out of IDs.
> 
> The ID without the VALID bit is what ath12k_peer_ml_alloc() returned and
> is stored in ahsta->ml_peer_id. Use that instead.
> 
> While there, also reset ahsta->ml_peer_id to ATH12K_MLO_PEER_ID_INVALID so
> the bitmap and ahsta->ml_peer_id stay in sync;

nit s/;/./

> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> 
> Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 490c134c1f29..b7eba8ea981b 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -1283,8 +1283,11 @@ void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
>  	spin_lock_bh(&dp_hw->peer_lock);
>  	list_for_each_entry_safe(dp_peer, tmp, &dp_hw->dp_peers_list, list) {
>  		if (dp_peer->is_mlo) {
> +			struct ath12k_sta *ahsta = ath12k_sta_to_ahsta(dp_peer->sta);
> +
>  			rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
> -			clear_bit(dp_peer->peer_id, ah->free_ml_peer_id_map);
> +			clear_bit(ahsta->ml_peer_id, ah->free_ml_peer_id_map);
> +			ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;

so this now matches the code at the end of ath12k_mac_ml_station_remove() and
in the cleanup section of ath12k_mac_op_sta_state(), so perhaps that should be
refactored into a helper function in the future

>  		}
>  
>  		list_move(&dp_peer->list, &peers);
> 

