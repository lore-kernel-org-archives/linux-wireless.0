Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0976A47886A
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785515724; cv=none; b=uWQmopepfa+c+2OZIG+jOwp6k+y8eo/SGb1L227Wc1uYK4sSXEw57Z6pXKQN1oQf++MyOahAlx0WqurfAN4WT5TBZ40N2iM9oSnje3Gqfi0SDbXNsXsWZtZoqGe4YZQy6eyBsj4B1fqhTUDuJDHZIXEPKwj8bnGT5e5CC/wSqmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785515724; c=relaxed/simple;
	bh=nNAkbp29yClP1wprvxrRU/g+reZEOE8hA9+zxQfSTss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AvvYXJDXJa9Xdp7GG2Ov9wKXMhqopXXbPiPqevYTSIJHiTKCumlSnWsh2ZyuwvR3jCryXUrLZAjxPjv1QOD5Acpy/lxCMBAG6YQs9bQMal6sVWae6nFmbHAa45qLNd8eBG0H9Do187zBerHDpygSf4lM3fC8GnGvebAeQt8SxY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FRMo8kJI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a/aj2V5O; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FRMo8kJI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a/aj2V5O"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFOFCN071026
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bj4ThZlfGpcMS5lmLNKuG9A/AzJYlnnmZrEyxllyxiA=; b=FRMo8kJIKyGD58dY
	Zupc8D83xEDj77c4O8xnfqJvSRJdKkrAXh0xkdJXanwYihzZ/wcuxqXoW4bYAZnC
	/neeb2iDEtqgjMfqdI5hOEqbQeli8/+96jCoc0xWm/5Jw8yh/1MvyQDYP+P04AKa
	uegM1JEJqQyBbjbrxMJeKj4GbfobBDBkom3IgrwFR9HT1Pkv1i0eX8j6JiBLmhzJ
	nDae/Q3AJf1efi+5QlHJXMUCr5TdPnp45H0WGOGqYzyhj23GeqxxHJpnwVyIFt63
	ct63yzLHCkG2eap7AyDgKbICiPefUGJGl1oKA0N0i7GoO0etLU7Au2PuqREnqpho
	StML3A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frtyqhb4h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:35:21 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so21945595ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785515721; x=1786120521; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bj4ThZlfGpcMS5lmLNKuG9A/AzJYlnnmZrEyxllyxiA=;
        b=a/aj2V5Ohad3Ef0xONg4KDcK2xAWYbXcfpNlNovr2cKHDKku4G0Gq/7G4fkr04zxPe
         L9622LPiqDMP2pKo2+UaxhSaM+yjHTb58UskaR2N/MAHv2egoaDKptvm3OK0z371adSE
         b9NN+dcz+uEBkFGHUS8QwLuDCSq5P9pLArRD315MXJyTkVr3BMpCFfiRoeLwT1ni4WzW
         nmx8hXINa4agVq793lPHQ83mhXyQi/AWctt0m+J5U1DnCq7BhpWHSo/FPI7DKwzQjbJE
         7nJIkAMWeyezVZfUxV+uD8HB/cj+JVcVSl307b8QIgx2qOoGTqiYUhIrif1TmJ0U3Wlm
         0hsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785515721; x=1786120521;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bj4ThZlfGpcMS5lmLNKuG9A/AzJYlnnmZrEyxllyxiA=;
        b=ShYPYpwr2gSUfW+KeMF0gNH6jEUl2EHHcm/5S1/8qrsitSD41kMxfqGOknfdoRDwrT
         mTAr5RyndPSFbBcUOXDDYSnVJIG1w2gTRP6Dv75nww6ZDZTKiBC3dUw6/UqnfL0ccyhK
         skDDqbfqfoXqVV+MITYT4TzfI4Wxfqzc5tvmjPpODqqq1RYBJc+Gdf6NCk2L5ivLwU6X
         eTmdDxK8fbqrxuLk4f5CZh6gK6BhLZiXGrPrszUry7HxM2+g+ZoJvhgcs66W9HI9/Mt5
         +cxGzFxcY+mx/16OmIRXdC6IP6rjqy8l2NC+C1ZJmlyRi/7ACL0l3PWrWDMSNfL+VnAD
         wWgA==
X-Gm-Message-State: AOJu0YyFx+6nzNAhmfW7WDKqujo3p7IsGodfUJXlDRJrPGU3nWsMU1Ti
	8Xk0yb5umLYMXTGVtm69HImtwFbZJJxtkgm+/F4BVhEfaC+THEEfbJEHzRc0pgfTUN/g4qNL03j
	6ZIB0h3LFd6/f6x1IPogSx5KwGjxhW4GVLhcelK7H6plhZlflNNJRcm1HUXr36ryAFPVzGuCshd
	b+4A==
X-Gm-Gg: AR+sD12YOe45jgrxiKjcIgXU6keic9wkm+iX+WG/dl8UxiDOjyV4SlT+KE5nxHTigUZ
	g+8gYRdCxnSm3A57LctGPuX6/Gy2noJHGroI84pk9mI0RsEuBsaXkF6/YEr+rLn316YcTL3wvkK
	RqPfHvfmiwP2YRa2F6QFYc+EoOmDsn7HNVkABCDLHLoLQ8ROYY/ID+fRfiLx5fkZX35gsOmEUYP
	KE5tBX3zKljLIcY2GDwk5WqvJdSfS8oChidSg0xgMjhNQYgCO0UZjJ2C2OyUJz6rlh/zhXQINdA
	LTQglZSI7V99NsBfxS5m4gxSVgADOlRtei30BqSYhXh1xqp0UgJphJ9c1XYQFQS6Z+jvQp3qFML
	tbxsNNB93nWQh+1rQFsL8v2E+VueMM4J+jFgOBIIXzuw4zXC01UxTuIiZv2nm
X-Received: by 2002:a05:6a21:4e02:b0:3b4:c9d5:cd5b with SMTP id adf61e73a8af0-3c92a53ef40mr463645637.13.1785515720570;
        Fri, 31 Jul 2026 09:35:20 -0700 (PDT)
X-Received: by 2002:a05:6a21:4e02:b0:3b4:c9d5:cd5b with SMTP id adf61e73a8af0-3c92a53ef40mr463612637.13.1785515719982;
        Fri, 31 Jul 2026 09:35:19 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e18d9c6sm7855451eec.30.2026.07.31.09.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 09:35:18 -0700 (PDT)
Message-ID: <272a4819-d966-4be9-a533-eceb7ae0a552@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 09:35:17 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: reset ar->num_station on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140306.133718-1-nico.escande@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140306.133718-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyNiBTYWx0ZWRfX2TWucrIY8geO
 dvPQRpl+M0FaIoB5a3+S+be5z3toZAmCPgaX8YdHzUWqDIcTIHwF91ONUN/FboZ75r63LP1YizM
 E4/qNsHFC9QjHcaf5NEcCENQ5hr/B72jhl/xLVMFI7/DhYCE1ukhL2/3OazKzk243mKDD3iGL7d
 mOfwDgHySPjXGZNbkOI3eT45MWE/1b+ops7V0wHWPbqUm9sCFAtppjmW8LKqJXz3IVdJX5+vwgJ
 uP+p+ICJZdyKZCgdmq2KedWECS3hCQJhuLAGnZ0TepwiaeaZFAd3jFKal5eEog9MjnLWRqn6n2o
 h0XF7FXK719Itl0IOa8MRCz2ZdJ3iG+4DxJ7oniA89D4nBfv81ynRtazq08p6Qp2gZyS45yFWeR
 Z1z0TzWgM5pSEqCbqTN1mzjt0/k30qa+NpiWqkXuBskdLuVSdy9uUTspxLLI9k7aHkOJNwpPzIS
 dEYbdzIq21O31Dd6UCg==
X-Proofpoint-ORIG-GUID: kcs-OnHHP5p_M0KoQdA87fQYbgeBPDTA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyNiBTYWx0ZWRfX3eaIwIqs/+IC
 pNsy95eXE8Ip211HJQlIILRwrqfZBBmUXcs87B2+nRkX4im7BboCHN/YL+6S88/TrB422qdPkEt
 9DVkeWKh9cy6jMa21pi2Dv8+GYwhxLc=
X-Authority-Analysis: v=2.4 cv=YaGNIQRf c=1 sm=1 tr=0 ts=6a6ccec9 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=rlskuJYU9gRkOBZwSjMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: kcs-OnHHP5p_M0KoQdA87fQYbgeBPDTA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310126

On 7/30/2026 7:03 AM, Nicolas Escande wrote:
> When (multiple) hw restart occurs, we end up in a situation where we
> cannot accept new stations / mesh peers. This seems to be the
> 'num_stations' in 'struct ath11k' that did not get reset properly in
> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
> that did not get reset so let's clear it too.
> 
> This avaoids problems like those:
> 
> 	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
> 	[1248828.088029] Modules linked in: ath11k_pci XXX [last unloaded: ath11k_pci]
> 	[1248828.088053] CPU: 0 UID: 0 PID: 12281 Comm: kworker/0:0 Tainted: G        W          XXX
> 	[1248828.088058] Tainted: [W]=WARN
> 	[1248828.088059] Hardware name: XXX (DT)
> 	[1248828.088060] Workqueue: events_freezable ieee80211_restart_work
> 	[1248828.088064] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> 	[1248828.088068] pc : ieee80211_reconfig_stations+0x98/0xc0
> 	[1248828.088070] lr : ieee80211_reconfig_stations+0x94/0xc0
> 	[1248828.088073] sp : ffffff800025bc10
> 	[1248828.088074] x29: ffffff800025bc10 x28: 0000000000000001 x27: ffffff8027b19640
> 	[1248828.088078] x26: ffffff802a5619c8 x25: ffffff8027b199f0 x24: ffffff8027b19880
> 	[1248828.088082] x23: ffffff802a560e40 x22: ffffff8027b18880 x21: ffffff802a560800
> 	[1248828.088087] x20: 0000000000000001 x19: ffffff8027c71000 x18: ffffffffffffffff
> 	[1248828.088091] x17: 128c0801a9c37469 x16: 766e692d32464545 x15: ffffffffffffffff
> 	[1248828.088095] x14: 000000000000001f x13: 00000000000000b1 x12: 0000000000000001
> 	[1248828.088099] x11: ffffffc081061518 x10: ffffff800025baf0 x9 : ffffffc0808097f8
> 	[1248828.088103] x8 : 00000000ffffffd0 x7 : 0000000000000000 x6 : 000000000000003f
> 	[1248828.088107] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffffff8011ef2e80
> 	[1248828.088110] x2 : 0000000000000000 x1 : ffffff8011ef2e80 x0 : 00000000ffffff97
> 	[1248828.088115] Call trace:
> 	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
> 	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
> 	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
> 	[1248828.088127]  process_one_work+0x178/0x3c0
> 	[1248828.088130]  worker_thread+0x280/0x440
> 	[1248828.088133]  kthread+0xe0/0xf8
> 	[1248828.088137]  ret_from_fork+0x10/0x20
> 	[1248828.088141] ---[ end trace 0000000000000000 ]---
> 	[1248828.090658] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 0
> 	[1248828.090667] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 3
> 	[1248828.090670] mesh1: HW problem - can not stop rx aggregation for 72:fc:8f:a8:f1:ed tid 4
> 	[1248828.090689] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 0
> 	[1248828.090694] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 1
> 	[1248828.090697] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 5
> 	[1248828.090700] wlan2: HW problem - can not stop rx aggregation for 78:64:c0:26:8e:69 tid 6
> 	[1248828.090704] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 0
> 	[1248828.090707] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 1
> 	[1248828.090710] wlan2: HW problem - can not stop rx aggregation for be:3b:3d:84:3a:00 tid 6
> 	[1248836.686596] ath11k_warn: 39 callbacks suppressed
> 	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: e8:51:9e:d6:93:22 for VDEV: 1
> 	[1248941.120126] ath11k_pci 0000:04:00.0: failed to flush sta transmit queue, data pkts pending 2
> 	[1248941.120186] ath11k_pci 0000:04:00.0: failed to clear all peer keys for vdev 2: -2
> 	[1248941.120190] ath11k_pci 0000:04:00.0: Failed to disassociate station: 92:14:23:65:57:fc
> 	[1248941.120196] ath11k_pci 0000:04:00.0: failed to lookup peer 92:14:23:65:57:fc on vdev 2
> 	[1248941.120200] ath11k_pci 0000:04:00.0: failed to find peer vdev_id 2 addr 92:14:23:65:57:fc in delete
> 	[1248941.120204] ath11k_pci 0000:04:00.0: Failed to delete peer: 92:14:23:65:57:fc for VDEV: 2
> 	[1248941.120207] ath11k_pci 0000:04:00.0: Failed to remove station: 92:14:23:65:57:fc for VDEV: 2
> 	[1248941.121319] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
> 	[1248941.121326] ath11k_pci 0000:04:00.0: Failed to add station: 92:14:23:65:57:fc for VDEV: 2
> 	[1248941.123036] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)

In addition to Baochen's comments please review the guidelines on trimming
backtraces at:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#backtraces-in-commit-messages

