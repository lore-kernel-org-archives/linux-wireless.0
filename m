Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3FF4078C6
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153267; cv=none; b=n27N9vttt6PekIM5DXT/tSLXilfc9bgX8uiZ37eZ9XhKMH7tBxv3lNmwfA77X9hQkCnG065+tAYP2c4UP7YymifgkAEohzIvE51GOGSjBrocmN3EPH+xvkq/Z7qUHHbh3SDRYMDTxnFcb/0vZpErmHgpat01Oaqv71PMV1htSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153267; c=relaxed/simple;
	bh=n64gMTJqatii7950Y8/l+Q7MBXAjojhMh3vZx3HB0Cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o24mv5YnWc2NQtWDg05kS9P+qar+ViLD3od0ixDkTfbhvboShyA8Qyx3XwOXY5V/xDVVJONobBdD8EZWVKosM/tbicIuVjntxJauMAmnYzYI+1bJ9OelzoLhJwX3l3B16RB9B2AQy5YQi0cBBdI3sbzFbbj0sVrqw51VMdhxJyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IaADzWnn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ko6H7NmV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IaADzWnn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ko6H7NmV"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8K2s91388763
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	A8FC/45d6TZh1tgW9Ibyrs38v4cdphYGxoD8UWW+7b8=; b=IaADzWnniHWC/oDJ
	Dzq+UarNHodcKQdIrUMYmsiSiAm2OxsLY6CsWPsn7B/aorW2Uo73vBw12HisEwwR
	mc1SOhdOEJuvvvOeksOXrZbn6w0cPZD+tlnwA7QmZfLFX+SsUPOw5mBFcMNsnnhc
	obe1zXZHDvGz6rFikVegp4KBKP2D04tgfegQ2RxvBRCB/y9Z/lod5w2QQfdVahqU
	7y2WPhDk9HNoWDzh5xfXCkNupC4R/+jLV3iKFjpqbdWM7SiEfNDdrVBzCwrpWflo
	7T+/6wnB9z2O0jesYHpVI2xw+61pLkvl1lqbxt1hD5DdUyP2Pw9gsU5ZPZ74KvIs
	A9EzQw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guyma2xxt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:47:45 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so839423a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 01:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790153264; x=1790758064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A8FC/45d6TZh1tgW9Ibyrs38v4cdphYGxoD8UWW+7b8=;
        b=ko6H7NmVj3uhQLcrTwAcb7vZjXsHAnbG1+XoqsciKpIF690f7LZEid6S2Tk1HdLxHl
         Dr50ymlns53skBwvgYH58XOmYWSt8X/j9sJXPzBr+u2zXUwoIN/nVvOd1Qnq43V9rFTP
         hs9VBZJ4578ubKOPN7PJAkTlcnOvj1a3PiKOmsLaArnnaTcMIdNYx0MCKD0YjscbcN9o
         4FGDMkK33TVoU2EMz5qYZeXHovA31AdhV0Upwof6e9qH+ZOxlyVe8BxE2BpCeCi1wyGv
         Tlyzzjy3e4bY8NDpHzMqhgvoy44Gk5l6nQ0R8zJIqZsoJCRsIaXOyGEejcFqpUYuSxhy
         hKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790153264; x=1790758064;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A8FC/45d6TZh1tgW9Ibyrs38v4cdphYGxoD8UWW+7b8=;
        b=cltVgO3S+O4wxaMb+5+h6bS7sTAVAdUuZKD62xy4kjHPbixLQ3ix5Iia0NVY0EsI9d
         HJP58H8L7ze0XrgKndGi4+LD7hoDlCr96ZX4I0Ga4uIKPGCjfRNgkKYEjqUSpxqLmJ6S
         ZTvtKHDi5vuSy6shsXCLd0LLMjrVNWXjP4aNsGV/sK8BSstVCo8THqdFKwB4y6f6jdid
         GKbjCfQP+rAiUHfAhBcB6Tz0cvQJNgkxqDf+DRPkW4m3aeR6rdXj3CrVhfZzegeKZnCS
         d2VQEjsOt64XC7fdiEL8x0sTxGZ7PpJs74WhwVoQIC7f7ataOEEm8XCNUPU5tun7uEFi
         IDCg==
X-Gm-Message-State: AFuF++nj4wuZqlp6QsjkG2dYZPlJp6I9dI4jcXQUh1YRxoDq/L2tNmtw
	CdtxTH6lra77dfHLvs9nt78JVBHlth6/4b/x9C95ZhLT3cLO3kTGYNPltUHYfL7aybbLsDg57B0
	OnmjXqbYJ7iC60ZmJATmIcXiWDLCffGnoos57eTN1XyqhWINecDImmlpji7AycEqx+SWBhg==
X-Gm-Gg: AYBFou3rz/Nm2B8NBMsiB5Ij9QBGRQGNRvdH8W7KXhhkTDenS7SUmRS9pLmIz4yR1nd
	vhbEuSWcSz3bNmAAvnmB4FTwtMrWk6qIwNdv70DvcMtKUtwl1OaoWi2YZRcsSU3o81Ak0+5sl8S
	y1ddj5UwLlKJ7CqpMyjw+teu74s2wDhGn0KPsAz+jQfMC9QtO56qHx3armXIRKZcny4pHvQtSlx
	7oBpyuBukaNUDcUW0LnUyWS5/wMSxPNO9/WNLsft35Z1wA2HuDr1QFadRQNUw4Kxln6ohmtqCsI
	FMG4QEkrcqcGRBCrKyno0DeaCaBor8A8ivgK/GRUGY5fBYzCuajjWto0KlrFMrv1rOSnDckqUUI
	IZRJAlG88y+RCtlZkoYoEGYor1Rqi/vGbil9j5M1h2FFlWTWi1rTTPCQlfb2mCuHlqhbN8tVHpJ
	q6zJa1S/c=
X-Received: by 2002:a17:90b:1fcf:b0:39d:f06f:79be with SMTP id 98e67ed59e1d1-3a07e5b1921mr1565251a91.15.1790153264260;
        Wed, 23 Sep 2026 01:47:44 -0700 (PDT)
X-Received: by 2002:a17:90b:1fcf:b0:39d:f06f:79be with SMTP id 98e67ed59e1d1-3a07e5b1921mr1565235a91.15.1790153263774;
        Wed, 23 Sep 2026 01:47:43 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a089197169sm1553060a91.8.2026.09.23.01.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 01:47:42 -0700 (PDT)
Message-ID: <5cc7e55c-c7c0-4882-87b1-35bd5a1614cd@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 16:47:43 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4 0/8] wifi: ath12k: extend device DP stats for
 TX and RX observability
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 1VelPqi-qTEtP2Vzvt5_yNjE7HQZBJHo
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAzNCBTYWx0ZWRfXzUuCMzp/iSvW
 JJD2ZeJtcFWUaHinGBEW1046Z/Dm/Lw6zaZ7BbMt+HsGxZY6Fk3mmxcV3+xR3goB+zLFtiLpsXz
 jUiqVCv0hy7X3OQdQVG7huaJEJNspyk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAzNCBTYWx0ZWRfX3yuU+xHrMrzs
 7FjZy0i5rxmV37Yd5KVB5UHRtfk4lMimS7Sex5Gxwnl6DC42KwnmexyBUeL/hMVGRf0HHF9M7O3
 WkL9m90VCmNA50zKZRQIN1o3+6/AeSlrLxiPNSlrDG7MdU6GZuvBMbVispO5VGZUb8fxyzsXQCr
 wLQ7OAjnBTZziSEN8hla27IN7Uw/XbCQslon3HkW/feAeTm0EfZ0naoEiNC0VoNMWAK2QMR2qdv
 5oi0GP0mf2V4K448clyiLFh9tB7FqIkni+TXRWPmF0tB6mphLNrjRQseNifjE2vfp/nJm5z832J
 lrytHY9cOEOsMRZDI8mQPuN3ULvYizPYouzea1E8A4X0ywz+ov8xvL86r7TcceqHmq1f7WygMUi
 +nk5ASWlTrWozBzDk82bBEM8CQtaSYm6t6QWBSW2yiimT0fbao1ZsMlllDgVEQYC47Ax+MH60UN
 w+zQN/iZfVbuMEpucPA==
X-Authority-Analysis: v=2.4 cv=N828hG9B c=1 sm=1 tr=0 ts=6ab39231 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=eVs2hV3UTgqw7q_ujHoA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 1VelPqi-qTEtP2Vzvt5_yNjE7HQZBJHo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230034



On 8/19/2026 1:32 PM, Pardeep Kaur wrote:
> From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> 
> Extend ath12k device DP stats for TX and RX path observability.
> 
> Patch 1 fixes out-of-bounds array access on TX stats arrays
> fw_tx_status[], tx_wbm_rel_source[] and tqm_rel_reason[] by adding
> likely() bounds checks before each increment. The default: case of the
> switch statement that follows already handles unknown values with
> ath12k_warn(), so no WARN_ON_ONCE is added for fw_tx_status to avoid
> double-warning on an out-of-range htt_status value.
> 
> Patch 2 renames the local variable wbm_status to htt_status in
> ath12k_dp_tx_process_htt_tx_complete() to accurately reflect the field
> origin, and simplifies ts.acked to use true directly.
> 
> Patch 3 adds a per-pool TX descriptor allocation failure counter
> txbuf_na[] indexed by pool_id to track which traffic class ran out of
> TX descriptors, and exposes it in device_dp_stats debugfs.
> 
> Patch 4 adds a write handler to device_dp_stats debugfs so that writing
> 'reset' clears all device DP stats counters without reloading the driver.
> Uses simple_write_to_buffer() to correctly handle partial writes and
> non-zero ppos, consistent with ath12k_write_simulate_fw_crash().
> 
> Patch 5 introduces a new dp_stats.h header with the
> ath12k_wbm_err_drop_reason enum, adds per-drop-reason counters in the
> WBM RX error path, and exposes them in device_dp_stats debugfs.
> 
> Patch 6 adds a 2D sent_to_stack[ring_id][device_id] counter to track
> successful MSDU deliveries to the network stack, attributed to the ring
> owner's dp so it is directly comparable with reo_rx[] in the same
> debugfs file in MLO configurations.
> 
> Patch 7 fixes the REO Rx Received debugfs output to use 0-based ring
> indexing and lowercase "ring%d:" consistent with other ring counters.
> 
> Patch 8 adds a dedicated sw_desc_fallback counter to track how often the
> WBM RX error path falls back to SW descriptor retrieval when HW CC is
> not done, distinct from actual packet drops.
> 
> v4 changes:
> - Rename WBM_ERR_GET_SW_DESC -> WBM_ERR_DROP_GET_SW_DESC and
>   WBM_ERR_DESC_PARSE -> WBM_ERR_DROP_DESC_PARSE for naming consistency
>   with all other enum values in the same enum (patch 5).
> - Remove extra space before = in wbm_rx_drop[] array initializer (patch 5).
> - Drop ath12k_warn() on unsupported command in the stats reset handler;
>   -EINVAL is the correct user-facing mechanism, consistent with all other
>   .write() handlers in the same file (patch 4).
> - Fix missing colon in "REO sent to stack" section header; all other
>   section headers in the same function use ":\n" (patch 6).
> 
> v3 changes:
> - Remove WARN_ON_ONCE for fw_tx_status out-of-range: the default: branch
>   of the switch already calls ath12k_warn() for unknown htt_status values
>   so adding WARN_ON_ONCE would double-warn (patch 1).
> - Replace copy_from_user() with simple_write_to_buffer() in the stats
>   reset handler to correctly handle split writes and non-zero ppos (patch 4).
> - Drop Fixes: tag from patch 7; cosmetic debugfs fix not needing backport.
> 
> v2 changes:
> - Fix txbuf_na[] indexing: use pool_id instead of ring_id so the counter
>   tracks TX descriptor pool exhaustion per traffic class (patch 3).
> - Fix sent_to_stack[] to use a 2D array [ring_id][device_id] attributed
>   to the ring owner's dp, making it directly comparable with reo_rx[] in
>   the same debugfs file in MLO configurations (patch 6).
> - Fix double-counting of WBM_ERR_DROP_RXDMA_GENERIC: move the increment
>   inside rxdma_err()'s default: branch (patch 5).
> - Remove WBM_ERR_INV_PEER_ID, WBM_ERR_DROP_INV_COOKIE and
>   WBM_ERR_DROP_INV_PUSH_RSN from the drop reason enum; no increment
>   sites in the datapath (patch 5).
> - Remove leading space from "WBM Rx Drop Count" section header (patch 5).
> - Add likely()/WARN_ON_ONCE() bounds check on ring_id for sent_to_stack[]
>   (patch 6).
> - Update commit messages for patches 3 and 6 to reflect corrected
>   semantics.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> ---
> 
> Aniruddha Mishra (2):
>   wifi: ath12k: add WBM RX error drop statistics
>   wifi: ath12k: add WBM SW desc fallback counter
> 
> Hariharan Ramanathan (4):
>   wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
>   wifi: ath12k: add TCL ring TX buffer allocation failure counter
>   wifi: ath12k: add device DP stats reset support via debugfs
>   wifi: ath12k: track per-ring RX sent-to-stack count
> 
> Pardeep Kaur (2):
>   wifi: ath12k: fix out-of-bounds access on TX stats arrays
>   wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
> 
>  drivers/net/wireless/ath/ath12k/debugfs.c     | 78 ++++++++++++++++++-
>  drivers/net/wireless/ath/ath12k/dp.h          | 14 +++-
>  drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 ++++++
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 52 ++++++++++---
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 27 ++++---
>  .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
>  6 files changed, 175 insertions(+), 26 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565
> --
> 2.34.1
> 
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

