Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1D735AC10
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043475; cv=none; b=iqUqlBdZb94R4CHDNVgFg10zfFe0rcwKaQ6toxQenx9ofBaGoPMAf85yUM9KwZRMG2bhnUOzBu8fUytmM3gztW9J9WlOG+eK/gH1ry/99/APTY1U5ZtISbQdthbxqpnHCTVJLlj6RCx9NinmpWwqQnNwjr1/toouPeVRq/uyPQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043475; c=relaxed/simple;
	bh=1VByP+HgL4tMgo0fXnPHtZaEKMdZ3+L8eEwWP22mboo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LXu84/eLYXvowj/LUWLlKN6o0r4sv/vXV2DSmnFAacbe0c6+m1cmhPKlMtS/MiQAd7BgMs+fEd6CIiJ5aYLwt59G3TonRucYvrT+w4CJ/ZNjzH0WSifkNrKRczvkkSGEjFkyOiefyp/8CWJVFmmgzYY83uRC2O+/GPeDFn9M584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cGOFA7Oz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ii98hvaR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cGOFA7Oz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ii98hvaR"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ENSJmp587919
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1VByP+HgL4tMgo0fXnPHtZaEKMdZ3+L8eEwWP22mboo=; b=cGOFA7OzkrW5dQ18
	1lt9QomyvLvWouWBXReJz9W7wn+QIIkGxIj9yD7Y478SS6XnH5nJYwmC5J/8itec
	1BcLVJu0rI7VgF5RN6o2Qp3hdo355KjQKCx1QI3VwHdy6zevlgbIZ91NQKv8K4IG
	bRRYKYDOnxTeRsQ83Oz3ynmOtd30jBM/nUO7YMoPKRvtpdtqfYQ7/4/0aXlnaPkH
	NDhH2YWdbe0OEck0mtANQ7tYythDM5rGgObRUw/k2AX1iURk9nWU+oO2LqgOmtPP
	crlxiQ4vCSHd8L3UV1AVQg5/9v+sGUI33GEGzczr1RP9AuJPuAwphnmBkV3+Wthy
	rRaFKA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hakdes5qw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:51:13 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so1047971a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043472; x=1792648272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1VByP+HgL4tMgo0fXnPHtZaEKMdZ3+L8eEwWP22mboo=;
        b=ii98hvaRUjY73eIQbne5ar60K3dbGxqPZiDnuf68k2b6lwCex0wqYVaUOBy6MNbzXT
         I1AkOnKbGBsnLL0fu+/SegXA4FC/QTw0DLunxOljW95kZiwhaVYebvGJf6a4icMCGVM3
         rLrs6tlH/YPi77Bm532VU6RFGssSZmf+C8Vy2CEhgOOIiITOp7mYEfinAMUIlflF3Y0K
         jPWPtFkvJsmPoEIqO3Erzx5fc6kemz0869n/fsKX7x0Ude06p6sFIsXL+nTof7aYCasD
         WYQ+gKCEuoKGmzi2dahr3cfjXY7p33LfvHLP4p8yL/YOmmCTlgydfv1ECO1CsCqOzzdl
         YNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043472; x=1792648272;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1VByP+HgL4tMgo0fXnPHtZaEKMdZ3+L8eEwWP22mboo=;
        b=R+Mlg/J3fRy6dZ42rA51Ny56ZoXCWR1FI+KrfZ2L/70QiDXs0plQHEv3gjze0ltIQY
         IiM/xVTKAM793o2TdUDrH0hpvD0giNV2g6IvgzS4yOpPjjju7Po2QZkBTHeo3xui9o23
         kHaht8A+ATB5oKHghsCnqrdJoNJeCqmBUoWQlMwE8fLcNgk16L+O4buyo7gYugVIZkxb
         F0dtCiq8IH97GXzG572za4S9rBYDB4za1itfHOo7ELrypLRsREP6BxTsgD7TlFfAUsCR
         QRpqrLx5gIppNK8CsquMsWYaJ53PDWgxwSVWxDUvVI0i9pAnaQg6SnYASUaRhIpGSbho
         0cmg==
X-Forwarded-Encrypted: i=1; AKwUvBwaYpOwXhlc2J71F9p5Cw6YUbb3Ij/UxIIn/LqkR0/210R/jMpJieSmlIVe9ZuXPxv5+1JH1Kyfgt/k7UVqgw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJkjQzUi3uYnjhDhnei9HX+7ktSwa3z7ZO2+7UAYYgqkIKTXCH+
	xvF2H0pTED89Lo36JqNPk2RNp50MO4UZnhIAMnXGanTJNMkK7jXz4JLaSifXlKDZ5S90CltJLfz
	oOQnA28d18rFljrCl07jml5FI8DKizcoWHxZBvIRxpRRF9OhmHGpOqsXxEkXZFV/lAENiYw==
X-Gm-Gg: AYBFou1NICDjds14fG4B4oFwBO87Lx6Qkaejh6dFbT/G8MydUSiBbhY0r/0nhiTxMGg
	kgi1gi5svVO8RSUs1r9vL0VO5ogYVwjXUkuJPq0Pr03FDZVHrD0/NG9UKudmkLeqnXs9JZzA4Bc
	UeY/ynCn0GCP/sBTUrtxfzF8Zqd5eCuMylJ/j7gZMNPOTEtcqiwRn/ZdzLCsHgEW+IGvTZ5JOeW
	QyCFwpB9XQYMzEUxRKfDcIiEvetFllyJZIuhxxt1zxff4c5B5rOs8muTE0NWe2QZipapF0nBkjl
	hbClR5qsef3sPOAIuuOODCN4JlFC/CcryHdlfldV6C18U1usxnpgB+tUNLymHAm2LW+GUrPL/c0
	M93p6LUtY9I06NzhHkwos0oR7cvvI2LzlpcBSzErWyoE42ulOdjCi0u6e4R8HlwWdMXsV6Mc=
X-Received: by 2002:a17:90a:d006:b0:3a7:bf13:6007 with SMTP id 98e67ed59e1d1-3ab3a9128c8mr15464776a91.14.1792043472090;
        Wed, 14 Oct 2026 22:51:12 -0700 (PDT)
X-Received: by 2002:a17:90a:d006:b0:3a7:bf13:6007 with SMTP id 98e67ed59e1d1-3ab3a9128c8mr15464767a91.14.1792043471638;
        Wed, 14 Oct 2026 22:51:11 -0700 (PDT)
Received: from [10.133.33.32] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2614738a91.15.2026.10.14.22.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 22:51:11 -0700 (PDT)
Message-ID: <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 13:51:07 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fix MLO station firmware crash
 recovery
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260804175004.1761075-1-jtornosm@redhat.com>
 <20260804175004.1761075-2-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260804175004.1761075-2-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=OdENnRTY c=1 sm=1 tr=0 ts=6ad069d1 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=s5qa2rFyFl07KiwIxvkA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: NQS9tINuZPDymcxtoPY1IfhdTVTMmek6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX/ND/ITpmmmmP
 FEUhYJUUfEQMszkSDW5HETw60KxPMwLZPSjzL8yKElapW5L4uw1XrNFNkp1bOtIMlIZ8OoALNWj
 AOLqYvzWs/FlN5EmOmXRUIOBDxy/CyxTjdsKtP9UYA1g104OGmko3Hj14Elw0gLSe7Xw7885xpT
 sM/csa0tLDpKe6LqSGiGMWAB/7l3eAd+Nkw8SSKiMs/i+iOx7a36r0PH+orG3hrVXZzhi+b/L9b
 HqFO2DbuXdTLuF9mAG3NSyi+Z9vtdLCVNAQh3dlKQwcC06DFhZs4waatnsx0gjlhgPd+ujZQ0sx
 XVDThfpmVwu0KoeRrOeuNkTUiSq1L9EAeb1Kq3Zrh5c6UuHipgpEKrl9uvbhNBsOw21/GiPHuHx
 8Q+wWyj+kXITRRZRVM2++ZkW+e0sm2+5SvB8mfhgpoHMsU0xYJQoCWsAeyoNnsmi84pdSWa8j7M
 yK+ztcla7UVdkIwyszg==
X-Proofpoint-GUID: NQS9tINuZPDymcxtoPY1IfhdTVTMmek6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX3HQZdIoxzS8E
 iJX3idL95iIr3LuXCxHwuSEIvKKogqakLZHlCMJKrYu5il19zsSbpzYRRZjjYYeUX/pNMD+vNvo
 VAXwXrQXUxio5kYiWe8mr7qhZh1e+g4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150023


On 8/5/2026 1:49 AM, Jose Ignacio Tornos Martinez wrote:

[...]

> Fix by moving clear_bit(ATH12K_FLAG_RECOVERY) from
> ath12k_core_reconfigure_on_crash() to ath12k_mac_op_reconfig_complete(),
> so the flag stays set through the entire mac80211 reconfig phase. Add
> ATH12K_FLAG_RECOVERY checks in change_vif_links, set_key, and sta_state
> to skip operations that are invalid during recovery. Add
> ATH12K_FLAG_CRASH_FLUSH checks in mac_flush, station_remove,
> clear_peer_keys, dp_rx_ampdu_stop, and peer_mlo_link_peers_delete to
> return immediately when the firmware is dead.


I don't think patches 1 and 2 are the right approach. Guarding every callback that can run
during recovery with a RECOVERY/CRASH_FLUSH check doesn't scale, whatever callback we
forget today is the next crash report. Besides, such guards don't help those in-flight ops.

The actual problem is that nothing stops mac80211 from issuing control ops while the
ath12k driver is in mid-recovery. I'd rather fix that than keep adding per-op checks.


---

Hi Johannes,

We keep running into this in ath12k and I'd like your opinion before I send anything.

Firmware crash recovery in ath12k (and probably other drivers too) is slow and async: we
detect the crash, then do driver internal state cleanup, then power-cycle + firmware
reload (total ~1.3s) before the driver is usable again, and only then call
ieee80211_restart_hw(). For that whole window mac80211 doesn't know about the crash and
keeps pushing scan, connect, add_key, sta_state etc. into the driver that's tearing its
state down, which gets us NULL derefs rather than clean failures.

The trouble is I can't see a clean driver-only fix. The driver knows the device is gone at
crash-detect, but it has no way to tell mac80211 to hold off until it calls restart_hw().
in_reconfig would do exactly what I want, but it's only raised inside restart_hw(), which
is far too late for a device like this - by the time it goes up we've already taken the ops.

So the driver and mac80211 are out of sync for that window and I don't see a good hook to
close it today. I see two ways out and I'm not sure which you'd prefer:

1. Do the whole recovery inside the restart path, i.e. move the whole thing including
state reset, power cycle and firmware reload into the driver's .start() reached from
ieee80211_reconfig(). Then it all runs with the wiphy lock held and in_reconfig already
set, so the sync is free and no new API is needed. The downside is we'd be holding rtnl
for ~1.3s, which I don't think you'll like.

2. Let the driver raise the barrier early, right after crash is detected, e.g. split
ieee80211_restart_hw() into two parts behind separate APIs: the first stops queues and
sets in_reconfig, the second just queues the restart work. That way ath12k can do the
time-consuming part outside the rtnl lock while staying in sync with mac80211. This would
also need a few op entry points that don't currently check in_reconfig (the scan entry,
for one) to be filled in, otherwise raising it early doesn't actually fence those ops.

Does either of these look right to you, or is there a direction I'm missing?
