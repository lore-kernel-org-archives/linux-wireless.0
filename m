Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158DB3B42C3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485794; cv=none; b=ubxv7IdjY2GTDR6o3Cz1xeSbheOVVD0zn2t9D11nnPEJyq06wvawKxHwho6js+D1VTD2s58Gc7v42vPsG9ISE+f8b21H3WicUfCAnFKAp7m1e7FC7bF2jvL/LisXbhCcaeHbmYR5xcI4kcp+Ee+XL9LtqJiyBqloXg5F51f9Gcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485794; c=relaxed/simple;
	bh=kpANFUzyRHmrHyDZPYfp7w54Xo1u200jNVNuzvKz07c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ey01VdMMyytFAECsZLA8mevI4a7rvzimqd2rbygRuPy3rHOtn3apJ8EPEig6pqhD6gYwkSg8/YTen27u3EQmnAXgoCgkTy41MSInLhy09mMbKxVRR9O5Vr8W5I5Q6OpJGmIuG2pBetVvzKetrwte2bd2evKc7NroRNkaYZsl0pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=azIvyioV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S/jJQjey; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="azIvyioV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S/jJQjey"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V7vfPi3411050
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gwN4m3GZszv7Lk8bq89AA1n4J6jRQ5eRfOtjYkSzynw=; b=azIvyioV22BMdMnZ
	uSu53KqY6KaVNQbchd+zdzT0W7jWelZDKSWIjg2DwPv6j7nXblpUA3O4Hcimh3aZ
	CmanFPq7ql0bm6gydB/BXYmd9tZ4g4kEfWOsXdqvelwMPzOK+n2UNfcme/YRJnPh
	iy0C/5J0IiWEuiTT6cRpHQqOzedSOnKgTj/gj+4NSmijlDzd24EtWQgMTBEz8FQ7
	zMg31bS+eirtgjLVtqZ5UUmXxkpVehllIDlPFKntd9AF42ToPn/CEIBbiGHRQw9B
	+MS8eBa5DmbN+8NV+eWAchHrD5Gm0MouFVo/gz8uCT4kuUlUz0CwmWdezYxVc9Er
	7wXtIg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frq8f86hf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:16:29 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84842381150so1522194b3a.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785485787; x=1786090587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gwN4m3GZszv7Lk8bq89AA1n4J6jRQ5eRfOtjYkSzynw=;
        b=S/jJQjeyezQHJ/iOtorEHdZUL6ng1aFa7nFf9qgU2Fmb2FLatW5ee64y/RCKclxTpv
         oejIvlcenYzWGbqt416RYdS5Ob4K1ybKH8ygExVGNS612kxHNLHGat7KAMBvhqjG9UGn
         OFwknfZMYANfwULPpqTorPKQPu6e7s/cRRPTMDx9auQhyyQTextMDv8hcGUmQY37Sp9a
         4265260T82cwc0lDHNBgxRVF7P2Zgzh+NHWdBl7elZZ1/9RM/Hcw7hi62NuGc6GYz2NT
         iJs3vU+tbtnoCLvWRJH9/PGt+m7AAzcvIjhP7At1jcB9xQdHMJstmCkLCT7WeUqapAnD
         GVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785485787; x=1786090587;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gwN4m3GZszv7Lk8bq89AA1n4J6jRQ5eRfOtjYkSzynw=;
        b=Kz7YQvlmj7HEIGVZRA6QP8mpTCtB7gINpFyHZa+VKixNrvuG6tYO0ov9ZjfzKjV5vp
         U6JiZrXjCc1tfaNyP2m89JMJ+C7pSXkXUkURXO4i1bdNBBA2AYY250qHw5kIEYvaqeH2
         +mQpNREL/OOfphlRYk1+fBYUOHtPiJZzCRob24cN2dFVM2jN9ABZvMtehYJ9tk70jlTH
         spIr4h9vfW5u7IKvvnoyvSc8l+h+JQ3PytVrx4ZudBK6NygNNgnDvbpbtzUVf94WfAOK
         0Fmcu/B3J8C50NIlVFo6tJxR0g3kwgd08/MOK6zhEhQ/ibtKa9j1gSk5VPF+PuZkYC2P
         3UJA==
X-Forwarded-Encrypted: i=1; AHgh+RoSHz5CqS20K7L3ky5wFMYOx+3RfDBRkDeP1BxnDV4dUlglNvS7s9/DPOYtYQCou+RbjtLErFW563diBBZIuw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3Z7zd7XUnOeAzUC7I2Zr4NMX7v5KKPEOrnobspDGqDWQYVf16
	4vThkQu3u5GODQT/RMR7rJnR2nZFOEZqGMXclXuMr6h2KwUHNrA8CIOYW56odFM1HdZaUkHEnGI
	thfduMNxXg5Yku69miThDsDyQYb975i1nqDLJLUywhuiEKTGPypaahSlGGiD2qYRj5Zbb6g==
X-Gm-Gg: AR+sD11tHnVFfV3W2F4h44t/gyiPNEARV52I0cCkMsIde7OrQAqKHt5KepCtf8PpVBc
	sZkSL6aIaB4qsf4fO5sjFFFMlSxETcOgOqD+/xcn3JWNPBh9pCzQakbFTE+SFHRvw7eyvRv3E+a
	4r8VyoCYqPXLP1ciEFbjKe3AQgGGDVI8Nq/jUSHFwFZ0GPOzMGRTauKxsicUKQv+kJl26xq8cm+
	g6EPgn03IwLPJLJ66jdC82rPG0SHNt73muDBxwyhoFempm9FaAUVC0q2pjSRUIursjTr1J16JM3
	sYWSjci1kiJAC7pJFfx9qEME7hWEq7DHT+nC73WvqUqOXLkNP7fS1Z/iRIPCYlgHrzXoJuIYDqO
	fAPsnDN2MtOEEhnMXeYt5T9i0bEEbZElomyfItmZ3PYJwjTOp5+IDjionCzcFmIbfvzj/j4pzeQ
	==
X-Received: by 2002:a05:6a00:4285:b0:847:95a6:eb74 with SMTP id d2e1a72fcca58-84ed6d227e1mr908912b3a.23.1785485787266;
        Fri, 31 Jul 2026 01:16:27 -0700 (PDT)
X-Received: by 2002:a05:6a00:4285:b0:847:95a6:eb74 with SMTP id d2e1a72fcca58-84ed6d227e1mr908888b3a.23.1785485786626;
        Fri, 31 Jul 2026 01:16:26 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe564b3sm140033b3a.14.2026.07.31.01.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:16:26 -0700 (PDT)
Message-ID: <81041a09-bffe-426f-a087-f6e48de93531@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:16:21 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] wifi: ath12k: prevent scan during firmware recovery
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727162748.963275-1-jtornosm@redhat.com>
 <20260727162748.963275-3-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727162748.963275-3-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: DTXMMSyqc9Cat7eZPfb5LG6Ua7AlOtl3
X-Proofpoint-ORIG-GUID: DTXMMSyqc9Cat7eZPfb5LG6Ua7AlOtl3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA1OCBTYWx0ZWRfX2jG21+oGOjRw
 kVXj6LZvqMJ1VkyYodsLh1291nx0bchZa4nR9YNDcFlGsqPMQcUsPX6t8Ou2/Uc24RxRZP6oKJV
 6iUenAMao0TLRqJWquA8vFCTdOzloBg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA1OCBTYWx0ZWRfXwwZ7VqOQ+Ujw
 ehKv6rXRuP2t+MPQUQgitN9fXoyP/gml55LKWUx78l4njVpyjYucnqjn5orz9Ocb45i4hsSB0qs
 +JXO2cnmTBdQ4ESJc20AaanM3IIo9k5ZIeYAA8ptbLHU71Y++T8xS6x9DjgkuO9QsV76ebxXlrw
 jsAXchaq1KPgF4vB23CEnAFteZGt9M4flRwTENAWv0eQchXat2RxTXaP4Jh3ej5Tjp3KDeyj23J
 eMC84DB8yAQqKEC/N4h6/NCbIHjhm5ru3kGV/yYFK7TzG0VO4ck7oXg0DvsVepdycEsaQ8lfISc
 OP9D0nD6gTH11LzSwVVTAz3Le5s9eNBqcDFqg5F4PB/Tkaef1zfe5dG1tqvPnJvXKcxHLl61M7E
 XmIb0O+dJhDx/S2/u/oXiMFMg6m7J0irLFTfWeSlOxIR67p+U81rEi35bFRKhFzyfR+6EqBLy2e
 DwC5La9uZ2i0WpyNoxQ==
X-Authority-Analysis: v=2.4 cv=K8US2SWI c=1 sm=1 tr=0 ts=6a6c59dd cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=20KFwNOVAAAA:8 a=Ck2z4BDfFmx1ngdb9lwA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310058



On 7/28/2026 12:27 AM, Jose Ignacio Tornos Martinez wrote:
> When firmware crashes while wpa_supplicant has an active connection,
> wpa_supplicant may immediately attempt a scan via nl80211 while the
> firmware is still powering on through MHI. ath12k_mac_op_hw_scan()
> proceeds without checking the recovery state, accessing partially
> initialized radio structures which leads to a NULL pointer dereference:

do we know the exact structure/pointer that is causing this issue? just want to know the
details of the crash.

> 
>   BUG: unable to handle page fault for address: 0000000000001508
>   RIP: ath12k_mac_op_hw_scan+0x148/0x2b0 [ath12k]
>   Call Trace:
>    drv_hw_scan+0x88/0x140 [mac80211]
>    __ieee80211_start_scan+0x2bc/0x6b0 [mac80211]
>    nl80211_trigger_scan+0x54a/0x9f0 [cfg80211]
> 
> Fix by checking ATH12K_FLAG_RECOVERY at the start of
> ath12k_mac_op_hw_scan() and returning -EBUSY. mac80211 will retry the
> scan after the recovery completes.
> 
> Tested on WCN7850 with MLO (Wi-Fi 7).
> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index f33976fc1233..924c3c21ca78 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -5707,6 +5707,9 @@ int ath12k_mac_op_hw_scan(struct ieee80211_hw *hw,
>  
>  	lockdep_assert_wiphy(hw->wiphy);
>  
> +	if (test_bit(ATH12K_FLAG_RECOVERY, &ah->radio[0].ab->dev_flags))
> +		return -EBUSY;
> +
>  	chan_list = kzalloc_objs(*chan_list, hw_req->req.n_channels);
>  	if (!chan_list)
>  		return -ENOMEM;

