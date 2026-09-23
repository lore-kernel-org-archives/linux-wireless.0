Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5929285058
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167805; cv=none; b=VqZVLZBWoXdXFMwbfLZkwVBr4ifKUVSBdH0T3sQ5QnBzxIwyjEINOv3qRF/TxZaraeUPplqIK4nPStPWvhy5/87oSz3x+gq8XhhgMN4jJ+vrh0AeQH+mUL9mScIJQPiDrYiKXn+QrxBfoQsioO0PQWXiNC4B+Bsy1D/Nh8OX3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167805; c=relaxed/simple;
	bh=0PXGenQBMhoVtALNhjHIgS48KlWoNUobuslnHcoyGQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sqw/xtPtAtX61hW3GhWtMpw63xSceDC0DQ9bchyYi8ujg+BbQXm4Iyh3TIld+hC7aRGAXMPdyQcJYparnmKaIiz7VyXkr0ib7MeIs+2N+3YxlAueEsSgKKm8ld4/648ShNV6jZo8In4Vhb5tFkofeEqRZ8ULobF8mmF3Z11UB3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mkbcWNQ2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iC2e2+iW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mkbcWNQ2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iC2e2+iW"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NBbTl12466532
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 12:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RcdwxsPtDevmgdXTISO9Gx8YiyTOdAORxtcWjdkP/rI=; b=mkbcWNQ2Urld4joy
	B1GjCm9ILdjZrN5zn6r3f1JtcngsrJEKKduNKM/y1SCr6zovXUtVP8Pwf9FIvF37
	/PrWikvnjUD7UT/17RUWa76TPiH0bVh73vVroDoubaJMLNqbfFezFxSTrc5u7j8b
	P7Bj487t7C1fxzshavuGH9YsiTsdZEkxrrCvkEzxCtm3RFjnRxEC4B24fOoRhz3/
	yu5/OW1hhDlqNOAUFB2WB3BoF1cagfoo3DO/sRD6H4lCunmUx/xkN9roG2hewtro
	+JoPy0fUJuOQIlUBsq6pGeFnhLBhyl+8PfqISQLxeWFSp6pNmhrzgnzBVMUwSa4M
	a2i4sA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guy2c42jj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 12:50:02 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cfc52ddc55so7874535ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790167801; x=1790772601; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RcdwxsPtDevmgdXTISO9Gx8YiyTOdAORxtcWjdkP/rI=;
        b=iC2e2+iWDNzA+I9jCkyQ8L2+GSmmdUZKPknxDg3tWR9vmwbQsudbqPXG16i/Vx+F+0
         Y4hApNnk/uYJLSvCKFIYS63GtCjZy2EqjsAohDYmYH1ZmMHUhPYe3uXhZ1N1DFhKprhM
         7YkPUzMnX6RYeN4RMW5wYztvJF/rvJRo2zrVhtPBO4BeK80bePWrdrVJxRzQz35gCusO
         rhAKkUs18VpGo2RmgYQJmIDy8raMrZZwb/R7KIhwkxK9Y4EcvopL88u72esFPTJX0iVU
         sg4mJx+2rZw7ZVjT4qFZCQIx4AGezNBHq1cjdfFjefFYZaCcgXfZuTE2bbHttyEewyxE
         7mKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167801; x=1790772601;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RcdwxsPtDevmgdXTISO9Gx8YiyTOdAORxtcWjdkP/rI=;
        b=Y5nd6qTYR1h/4m/KLWs6alQ6vAO9lDpYS+pJfRzf3STGiq6SHIZnEzY9NjBVwIoXqx
         5hbHoKRSyXNXNCfcWTVtV0cxHGUXXnrYVhsOUK99uteijwPei/Mz3yxPhqsbiX6phUmc
         sccfP1HVWZGkIbnQv8GvMz1YmKI+6HDbpJXCRNxcub7CMMgkFyJSr22Zge3DpYEeWXlW
         v/Dd9BFoHW09IVZ0t2MnHQ4xl5zqBeP7oGyCp0u4IpnKtUg3157h4qGCQdnWnqcvby16
         u1vz2ArhJIpkOuenIJPHJfm4uawurkgT5yuhGeA/NWYr/8hkbjVwaVEcgRYvtMGT7vmY
         ayWQ==
X-Gm-Message-State: AFuF++lpHenxYgg8FCosdOq7uatDQ7oZCAO3bLEGRsrJl0YPFqoRvC6z
	UelZQu5Lz72lHIDqugolSPuk61jK9r3OeG80FihTe8z7UrN/EeN0JgnPeBkq9nbLA9unkg7cfSt
	Jr10rvCcOgldXJteCWJm3D+ouqokRmwUPw4fdnrijWG0TBadIheISZJ22mtcRIYEvIGVpn2SgRq
	fvhA==
X-Gm-Gg: AYBFou3Pyevc3h10d4HFOSbk4BL8yBxVWxPlYrdtRInpyHjJYt0cn6tEk2TucebuZVS
	UH89moYpE/lD/Q5Syzxh4pC1K4hRk57jOrmWbcclWT4M/ZHlRuXFmJzXoe06AKFpZg6NKW5bs06
	t+j/NybgdpF22YxCxR8fax53uUc7PuLNgUM/ABNoPvxC8+1aX0tnabWsJCAIeteOkgPXmRRP72l
	rnREF0spTMFRihWnzYtWXQMlZ+Cs2R6tk9Wq5rC/FJmfcOluT4UWyfQzItTag1QxQsGmuxNlSaW
	9J1vqiBwGaKiizYQsIMb7cvV8YTe4CJcy8/zXKQtp60LX8pVXcvPjnRLPTxPm3Yfcw4r7itHYSj
	9bdE7+8fAPdsayQgQwA8m2UafvRrTecs6tIAlBCZm7ZA=
X-Received: by 2002:a17:903:3503:b0:2dd:c053:e0f3 with SMTP id d9443c01a7336-2df69ddf227mr19848305ad.34.1790167801219;
        Wed, 23 Sep 2026 05:50:01 -0700 (PDT)
X-Received: by 2002:a17:903:3503:b0:2dd:c053:e0f3 with SMTP id d9443c01a7336-2df69ddf227mr19847995ad.34.1790167800452;
        Wed, 23 Sep 2026 05:50:00 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a5157sm9976235ad.14.2026.09.23.05.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 05:50:00 -0700 (PDT)
Message-ID: <5f26c2ef-ace1-4afa-b5a9-0468d692367e@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 18:19:56 +0530
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
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: _SxKFeZFvYWaAmzF0iPiU5mrTEwS-FU9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA1MSBTYWx0ZWRfX0nc5OLrHu0uJ
 8i/vzfbScoYsq3I5Ab5QlpZfij9BGnWU+XUv3DY2L+CVNq0o7oIdb6/isjp+XNxzg3y3JvTCkrA
 kW0vjyULpspwqlR7Tc4/L9KB0VLH0jI=
X-Authority-Analysis: v=2.4 cv=Zsh4uN7G c=1 sm=1 tr=0 ts=6ab3cafa cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=eVs2hV3UTgqw7q_ujHoA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: _SxKFeZFvYWaAmzF0iPiU5mrTEwS-FU9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA1MSBTYWx0ZWRfX13rs7HgMn55j
 5Qowxn7YeerytAkSIXFwKObPTsCLa6++Xm8/2TLzgdHeEjA79eTVYrp/u63LxTNtobSW/TBgkD5
 9AoG3MZOSZ44d/g0RUILreEGwxMBXrYlmP8pTAWXo3nfh/GSgfviNqLuK2Sgo2beAZRHhpThV9W
 vlMWqxdBpS9wpEodHnveKynmLX1sTIkFKwYehEFMq2QY4bA5RYU/fBV8+Y78yAB+C7wYTSDyKIu
 klHTnVNK7k9ZDqcNG1Q5JJGR+jeW9ofqpOvV3ZsIPlf0uxbT+EZ6mknPzc+cpMApzeICR2bAbI2
 jj3mb1rwNyMCF7Dk/Ovl3sTagVtXTBbSml2QJzW5UqoLW6LOZNmQNUJwWWhykyc8mIZDvcGEirR
 pYCYbrUvg1P+k6FlGEGcsjfUDP1sWXzj9EWAk5EEvC1ogNc/1+VVDXAmwDCjP2ED2vyLem+TSaV
 LtneX3dLcQxMwK9qlsw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230051

On 8/19/2026 11:02 AM, Pardeep Kaur wrote:
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
>    WBM_ERR_DESC_PARSE -> WBM_ERR_DROP_DESC_PARSE for naming consistency
>    with all other enum values in the same enum (patch 5).
> - Remove extra space before = in wbm_rx_drop[] array initializer (patch 5).
> - Drop ath12k_warn() on unsupported command in the stats reset handler;
>    -EINVAL is the correct user-facing mechanism, consistent with all other
>    .write() handlers in the same file (patch 4).
> - Fix missing colon in "REO sent to stack" section header; all other
>    section headers in the same function use ":\n" (patch 6).
> 
> v3 changes:
> - Remove WARN_ON_ONCE for fw_tx_status out-of-range: the default: branch
>    of the switch already calls ath12k_warn() for unknown htt_status values
>    so adding WARN_ON_ONCE would double-warn (patch 1).
> - Replace copy_from_user() with simple_write_to_buffer() in the stats
>    reset handler to correctly handle split writes and non-zero ppos (patch 4).
> - Drop Fixes: tag from patch 7; cosmetic debugfs fix not needing backport.
> 
> v2 changes:
> - Fix txbuf_na[] indexing: use pool_id instead of ring_id so the counter
>    tracks TX descriptor pool exhaustion per traffic class (patch 3).
> - Fix sent_to_stack[] to use a 2D array [ring_id][device_id] attributed
>    to the ring owner's dp, making it directly comparable with reo_rx[] in
>    the same debugfs file in MLO configurations (patch 6).
> - Fix double-counting of WBM_ERR_DROP_RXDMA_GENERIC: move the increment
>    inside rxdma_err()'s default: branch (patch 5).
> - Remove WBM_ERR_INV_PEER_ID, WBM_ERR_DROP_INV_COOKIE and
>    WBM_ERR_DROP_INV_PUSH_RSN from the drop reason enum; no increment
>    sites in the datapath (patch 5).
> - Remove leading space from "WBM Rx Drop Count" section header (patch 5).
> - Add likely()/WARN_ON_ONCE() bounds check on ring_id for sent_to_stack[]
>    (patch 6).
> - Update commit messages for patches 3 and 6 to reflect corrected
>    semantics.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> ---
> 
> Aniruddha Mishra (2):
>    wifi: ath12k: add WBM RX error drop statistics
>    wifi: ath12k: add WBM SW desc fallback counter
> 
> Hariharan Ramanathan (4):
>    wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
>    wifi: ath12k: add TCL ring TX buffer allocation failure counter
>    wifi: ath12k: add device DP stats reset support via debugfs
>    wifi: ath12k: track per-ring RX sent-to-stack count
> 
> Pardeep Kaur (2):
>    wifi: ath12k: fix out-of-bounds access on TX stats arrays
>    wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
> 
>   drivers/net/wireless/ath/ath12k/debugfs.c     | 78 ++++++++++++++++++-
>   drivers/net/wireless/ath/ath12k/dp.h          | 14 +++-
>   drivers/net/wireless/ath/ath12k/dp_stats.h    | 25 ++++++
>   drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 52 ++++++++++---
>   drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 27 ++++---
>   .../net/wireless/ath/ath12k/wifi7/hal_rx.c    |  5 +-
>   6 files changed, 175 insertions(+), 26 deletions(-)
>   create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565
> --
> 2.34.1
> 
> 

Apart from Jeff's comment on commit text of 4/8

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
