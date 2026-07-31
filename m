Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431C2367D3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487736; cv=none; b=XH+FdES4pBVL8C0Y99Y5umEQD0UAgrI5ZA50WN/oUjFQ4GGoVuirmcELAXwRWqz9E3E3apPoYh36CpT2memakH/eN/6RpPJJFSmyGTpicIhI8BzbV8aR2OFb5qx392/4obIFdoepXGxVVHxGMk7ef+LdoQOKHHEtc/SVPXkVfew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487736; c=relaxed/simple;
	bh=yqVzdwQIdhlxVwRNjZYeO0qa1Ah/nRrtlZwReCGfUGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rihhYT+Xorz/d2cHgD1FYCSDW8hrqgqqZRTCXnOCzxtdDnjxIMmXsDOl1Rl0khE6FtpXxgRN+W5aJB9NbB3JIlixDqvJD20R8XZAhFHLLciL7KedGv+JFcSr2K5nu8zURapMsytYwZrGlsoyFzXpOjG4UfaW8uKZ8uFs2tNbrM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GCupiym0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=b3f2i4jT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GCupiym0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="b3f2i4jT"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8ZKld3292964
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YuohLgv2ewEMxWehRE3OJp4yXClrJcRe5nvz3u5mbkw=; b=GCupiym08Ro3L1vA
	y+aaawzkdT4YtUjsdKw//xK+zyCA1AkSObg0w9XN0wUNmMEWDQP9/oZDf0iJ1Cuy
	Zn4Yx7QtqnUrgR5giYckvAUAQ4NAQoAgrQylpScr/AVP98+iqDOa+XcLo4J1/czG
	kYbLxI6lyXXRnlF1n0/GHQEdcnnqgjoTTBsTLpMs3GvzeqaoO3sRXIY4UUZk73OT
	q7j5niPs8vMk//XFItZKxz9+ltNe3QQU9bNw3yCbCBVVcCmoj5qLEfv6hFt1Bz+E
	pMiJBaE6aXuz2MZ6mYH54QIg2whu3932+YubrUCfNDhSSfqNQgVaBCwkNgedNS7n
	mATsdg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frrayg1q8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:48:53 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc88e22f92so15160615ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785487733; x=1786092533; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YuohLgv2ewEMxWehRE3OJp4yXClrJcRe5nvz3u5mbkw=;
        b=b3f2i4jTV3KtPNhMJUy3MiNao9+gOi36S3ZP123FMbnssCO+Bcsd482Yoz0DFoz5kP
         GRQ/237F2cbjPIO38EwrL/aL9tua3T634BIc9WonevDuQSCHkGIHPUO1VBEcqFZOi5Gw
         UYMfzB0J74vgSG3Y3Uzi/JWrLDp4iwvGHHGispAkrir9wYOmTKaRzlZWE4oiSRwwbZkn
         8CNRBdHij/6zJZhoEWqEJiDZWFsZNZmh7uRMToRmch9mD5Lal0h42l4eXE8k9RyunyxO
         ar6nNO7inCL/XywoYLgEHqGjFgWV+qihpDyWj5MboIwYzg2+e97496sMXq/QVBKzIiCP
         b9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487733; x=1786092533;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YuohLgv2ewEMxWehRE3OJp4yXClrJcRe5nvz3u5mbkw=;
        b=VSz8PiT/aA86FDJz6gxA2yqet3luVpTuqXHkBRk5gm7vZ0fekw2ThXTHx31FVCkLsr
         Q2MmiepolbHG65p0XUxoy3+RMgrYuo4wsJcmQk/2frKI7WurBOwksmXk+5i4n+p+/WmP
         wpq0VmKuP14HHGwZu6ayRMJPeNxMMLsLeUMJkr6gWHRbM83CQWGtG0M2F/rXrXNE/kVz
         hk+qYD3KiBH0epqFleUB9NoxFy4VhGfgGse+F/VwCCv2Wr7V/1RFz36iSDwzbqbE+ag+
         eMwx3YYFIy9RINQicUWbgwX0icryC734Wiq0Zr6HWuRVt6mwqHQm57eLrOzKvg0dthHz
         Jo7w==
X-Forwarded-Encrypted: i=1; AHgh+RqDh0UfXPzswyRI2dE5ePkqmXY5woJzF8lBGhDNU8zEsvw9qk4RnjBRygUjLD4oThZzmf1pTsQD/V6rxZ/7CQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIQQNDLo+QdcDlzEFYCXEYJbiVtC6+9GSjIqzh1eun0QFaQsQL
	m9jS1tiUfyEYaacfbqMT0Ly3I/+n3Z3p5Q6ilzQvyY30Q6oz+PE31Cxqd/aLCTiHjhctIJn0AXT
	+2yjRTUkEs+F291VllR5inHnubbNZDLL9YPHJaRVcFDWlHK8g+gLnmgTq+NQfE7YXwzgcjCCVrV
	sBtA==
X-Gm-Gg: AR+sD125zL5/5lRDlMIz96DlmvNdRigDCQAWZ2KyasME1wztI/GlEbYYiAM3HxH7r4B
	pXuH8Y6jtq5MsjEyYmYYnIGCLVIYjhLim5ZJnIPXoH2q7J9Idec/7oCO+gvLbTmlCqe8WHKaEQe
	Luw831+zP6a1eWXtbd1qIU3A6R+uRvrPhCFDRcWgtDxo1a//rPjdVAFy1eeJegO6koNtO7z6X6N
	cCWQSGBxpyuaf38xfxcuViaCbIvy4cdpi10oGNiskjzkwGEHxrtJ+zQDc2UguhJuWDywqh/X5Oq
	SOEjHZEAwk9JCMfsf0mrlzxvbwloMr5gOkXTmj0Pd65zRSuG3GIKyuMyC4X5KzKGiVXjKW5KwkL
	rDjo2y8Koeqnzn9Gv/xsj0xwk4GWGxhP+S0Nc7VY29Ybt/5u2nU7ZaHex5oYSqLiTJ4b1TGK6sg
	==
X-Received: by 2002:a17:903:2f4c:b0:2be:3850:297e with SMTP id d9443c01a7336-2d046e7db1emr13839465ad.31.1785487732770;
        Fri, 31 Jul 2026 01:48:52 -0700 (PDT)
X-Received: by 2002:a17:903:2f4c:b0:2be:3850:297e with SMTP id d9443c01a7336-2d046e7db1emr13839105ad.31.1785487732202;
        Fri, 31 Jul 2026 01:48:52 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae68cf7sm2700115ad.31.2026.07.31.01.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:48:51 -0700 (PDT)
Message-ID: <1f80cdf0-2ca8-4b28-9192-b42bd61abff1@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 16:48:48 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] wifi: ath12k: skip connection_loss_work for MLO
 beacon miss
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727162748.963275-1-jtornosm@redhat.com>
 <20260727162748.963275-6-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727162748.963275-6-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: z38WuSLrm3FaATyaZfxJG-VS0_OnLE0H
X-Authority-Analysis: v=2.4 cv=Y9fIdBeN c=1 sm=1 tr=0 ts=6a6c6175 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=20KFwNOVAAAA:8 a=Mojy9TJRF7p0t743WAkA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: z38WuSLrm3FaATyaZfxJG-VS0_OnLE0H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX+O7Xci72Wufz
 HR+FCDoy0Mxh+ZYH5HvXGeJo5A5yuG+NGqQsDJeiiz9rjSJta9uACg1v9KuVCS7j2BPznCg8Uk5
 zLhnhlcRf5Vzw/U7Md0RDy3jAa/w7wazY2dO+N5UBGxJGYwpZirGx9Sw2KCvXHotUexpkiRdns1
 PVCZ8a5MHNPW6/96IoWurXwbdoHxSE9JIUUZrwb20o1qxc+9eH6YY8llW6oL/GMgzTJG2WqztRf
 rdIvRLN1q2ls04D4KaZiYPlIwdpzT5JDKMhlbt26fLv/BGTmR1k9o74jOZaOjenX5fCGtUrQWic
 C7utalpLJ3OOjFc31vxyz725rwugprs8VxQS9/1qX85dNFZ3LWst2vrtM7cPoZTd+E2Mx+k1AP+
 KpNwezN2zz1quXQD6p8WGlmT/8rPq9+f5RSbIIG+02SUlmsxQZv4b06lv77f5P60cFjbJs++elW
 Y+0Y0TF+ep6GGuWey5A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MyBTYWx0ZWRfX2IPUVdvQh31b
 YDrmT0hPkGU0gOEUU5LiQ5zXQE02h45Tkf0noizvImdHlLvXZASGbIecZLs2Kc9VUXkI2R/mg04
 zcxLLbO5OXwriK2CGrEzIVu24Zf1+wc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310063



On 7/28/2026 12:27 AM, Jose Ignacio Tornos Martinez wrote:
> When firmware reports a beacon miss, ath12k queues connection_loss_work
> as a 3-second backup timer that forces a full VIF disconnect via
> ieee80211_connection_loss(). This work can only be cancelled when a
> beacon frame arrives through WMI in ath12k_mac_handle_beacon_iter().
> 
> In MLO, this mechanism causes periodic spurious disconnections because
> the firmware does not reliably forward beacon frames to the host via
> WMI, making the cancellation path ineffective. The result is a full
> VIF disconnect every ~16 seconds during normal MLO operation, easily
> reproducible under heavy traffic.
> 
> Skip queueing connection_loss_work for MLO VIFs. The mac80211 AP probe
> triggered by ieee80211_beacon_loss() is sufficient to detect real AP
> unreachability. Other MLO-capable drivers such as mt76 and rtw89
> similarly rely on ieee80211_beacon_loss() without adding a backup
> disconnect timer.
> 
> Tested on WCN7850 with MLO (Wi-Fi 7).
> 
> Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index af09153ad9d9..dfd69822c5ce 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -2008,9 +2008,16 @@ void ath12k_mac_handle_beacon_miss(struct ath12k *ar,
>  	 * (done by mac80211) succeeds but beacons do not resume then it
>  	 * doesn't make sense to continue operation. Queue connection loss work
>  	 * which can be cancelled when beacon is received.
> +	 *
> +	 * Skip for MLO because connection_loss_work disconnects the entire
> +	 * VIF based on a single link's beacon miss, and its cancellation
> +	 * mechanism (beacon reception via WMI) is unreliable. The mac80211
> +	 * probe triggered by ieee80211_beacon_loss() above is sufficient
> +	 * to detect real AP unreachability.
>  	 */
> -	ieee80211_queue_delayed_work(hw, &arvif->connection_loss_work,
> -				     ATH12K_CONNECTION_LOSS_HZ);
> +	if (!ieee80211_vif_is_mld(vif))
> +		ieee80211_queue_delayed_work(hw, &arvif->connection_loss_work,
> +					     ATH12K_CONNECTION_LOSS_HZ);

with this, patch 4/5's MLO branch is never reachable

>  }
>  
>  static void ath12k_mac_vif_sta_connection_loss_work(struct work_struct *work)

