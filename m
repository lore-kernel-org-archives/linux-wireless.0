Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568023624BF
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 02:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790734479; cv=none; b=lzN9orhHDa8ABAPalWxqRu94nxQMMmiqdvkV17JqwAuLfj1ARxMWPzwN9XnRlZAfA+D3v2o0p8ZiYOOIvn2gL6nUFEpwjUXMTSBDVuGC1JvWtQKOBZRw+Mva+6c+5xn3ZWG8ZXrrBv5aQoG6a55LuVaY8VnhsGHg7rCIWLfRJCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790734479; c=relaxed/simple;
	bh=y3PH0+jrCIiIzrjxHzasu23w4rdZ8eO4oOjOhhygvjs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=JreRfbNZzDsB4HP8d0+SVeMyaf6jNplcMHPR+piN3F/kk6h7+Qcc4wazBtZjrYqcsRl6dL5nVUfl4xVQtChgfiUubVQ+zR6qLYzXzd8ApWEXA5WLK+0KHWkPeB+o4VR2PuLodSRz3iu3kWdEKMZIeiUHoc4im4IPaCDHAnaHggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tOwCVe6u; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tOwCVe6u"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U2EZD801777897, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790734475; bh=5giQPCbz7J0UXh6tHQVmvVPj/Nv0b0ebAoO9kfjAtIM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=tOwCVe6uiZb7nd8OOzws4YC0ixrprOMbOV/oLFwvzUmYF3u6/tLT8bi4yIvLEt5BQ
	 L6PLq0PE+mpKsPDjM9ck1flrbjjdM71IoVX78d4WBPAHUNE5Vk1/KUfHcs/2/p+5G/
	 UeF4r+B5/wNBopIHSMb5rnhH/mTXh3ijgocbvpEHBzStpxdUQ2CtYU2tPUKp3RPFOn
	 ByGBN5DJOzNvpxU30B9txEiAekxPF6zNATEbSrZeH9It9O2UF9ieN7kIRCUeZalU8n
	 6gCgPrvDPvUvPGJwsFhZ3uV8wDL6cR2+c24bLHehYIcKqnw5sgU3O/vJHki6kkuxdC
	 p4rogPCOAS5iA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U2EZD801777897
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 10:14:35 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 10:14:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 10:14:34 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 10:14:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 1/7] wifi: rtw89: coex: log FCX report version mismatch without dropping
In-Reply-To: <20260923071354.50864-2-pkshih@realtek.com>
References: <20260923071354.50864-1-pkshih@realtek.com> <20260923071354.50864-2-pkshih@realtek.com>
Message-ID: <0d5f195e-bbbc-42fa-a19a-4c49f213aac2@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 30 Sep 2026 10:14:34 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ching-Te Ku <ku920601@realtek.com>
> 
> _chk_btc_report() validated the reported firmware struct version only
> for the control report, so a version mismatch on any other report type
> was copied in silently and left no trace, making a ver_defs or firmware
> version error hard to diagnose.
> 
> Read the reported fver, which is the leading field of every report
> struct, and when it differs from the driver-selected version set the
> per-type bit in fver_mismch and emit a debug line. The length-valid
> report is still processed, because the driver must stay compatible with
> every released firmware and a mismatch usually points at a ver_defs
> entry that needs fixing rather than a report that should be discarded.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

7 patch(es) applied to rtw-next branch of rtw.git, thanks.

0266773d404b wifi: rtw89: coex: log FCX report version mismatch without dropping
0104c69ba225 wifi: rtw89: coex: add fbtc_rpt_ctrl v205 report struct and handling
6047d2f7efd0 wifi: rtw89: coex: Add firmware 0.27.130.1 support for RTL8852C
d6c34b67ad5c wifi: rtw89: coex: fix BT scoreboard update for non-C2H paths
5f57e5453946 wifi: rtw89: add instance of IO ops for (un)pack and [um]delay
6d0c77424034 wifi: rtw89: coex: offload 8852C IO writes via firmware CMD pack region
6c095c657b31 wifi: rtw89: coex: batch PTA init with masked IO offload

---
https://github.com/pkshih/rtw.git

