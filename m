Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBCD33F59E;
	Wed, 29 Apr 2026 03:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777432319; cv=none; b=MsptXwQ0Yfbvt1mJTFjpWsfHgTPBFPrfvsljD7aOIH9J3foAXuWvpbXjTnFM/3fSmNVYRH+a+qZLFYPm34VfCX0cCsKlLrI4yLYSOtbXQzp/prS/36//ORo6w49CVdb7FW5uxi4byKIQc9aoJ5aAzSRqn3xpxNbIUpKzSPJJfE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777432319; c=relaxed/simple;
	bh=I+jms95mTe7rHiL3AgzDAMWkTJZsJo+5xlEZYoWGJgY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=DGPOMYrZFarwG41dT/uxWeVQ+sS6nyj1R0N01LWuK858UPIcLYmSsg7zGhgo6WbDpyTcUs9GXUcSVE7/Sc/u0/H7N3vLMivjnguDZPCu5YemZg+tmO8m2ldtKll6qrV2s5sXSYuH4o+nHUMSCou3rGs6GiRRVE7j578WVqX7EOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ACaAgpCX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ACaAgpCX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63T3BdpjE919765, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777432299; bh=o3x00GrdCnYBKMsiUd4678X7Zh3+YEtL2B+GWfulmKo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ACaAgpCX0yjCyABwrs7gXyWX4EqDgvMpo73a3oZayWU2nh0j+BTq5HLs0bGIxd7yw
	 UKyEQ525UX1pzSBfbJZJG7FFB96N2dNOWdS8kAo24+5L642RG5d0kFiYRW6edOtl98
	 W2L9tzFAbJZMPtoQv6lk5b7zu326cPOquie/JoYBYRcyQJUclUSvoySC70r9c+v0jl
	 zWLsj4sdNfSzywwf3sVtSr0AgJO3AOEpexBDEwKxlurtvfyK68DgkWz4J1Jx2J++Ti
	 kNQ0uImBLjwUzZEi20AX0XhenU5NIlBrzhKTgDoOPaFH9tn52iSdDBhsfL8+0Umydn
	 eaTjcgg4UxtIQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 63T3BdpjE919765
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 11:11:39 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 11:11:39 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 29 Apr 2026 11:11:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Louis Kotze <loukot@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rtl8821cerfe2@gmail.com>, <lucid_duck@justthetip.ca>,
        Louis Kotze
	<loukot@gmail.com>
Subject: Re: [PATCH v3] wifi: rtw89: phy: increase RF calibration timeouts for USB transport
In-Reply-To: <20260416045536.817930-1-loukot@gmail.com>
References: <20260416045536.817930-1-loukot@gmail.com>
Message-ID: <ad90a3c5-b628-4782-b6dd-6ffe4ea50764@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 29 Apr 2026 11:11:34 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Louis Kotze <loukot@gmail.com> wrote:

> USB transport adds significant latency to H2C/C2H round-trips used
> by RF calibration. The existing timeout values were designed for PCIe
> and are too tight for USB, causing "failed to wait RF DACK",
> "failed to wait RF TSSI" and similar errors on USB adapters.
> 
> Apply a 4x timeout multiplier when the device uses USB transport.
> The multiplier is applied in rtw89_phy_rfk_report_wait() so all
> calibrations benefit without changing any call sites or PCIe
> timeout values.
> 
> The 4x multiplier was chosen based on measured data from two
> independent testers (RTL8922AU, 6GHz MLO and 2.4/5GHz):
> 
>   Calibration   PCIe timeout   Max measured (USB)   4x timeout
>   PRE_NTFY           5ms              1ms              20ms
>   DACK              58ms             72ms             232ms
>   RX_DCK           128ms            374ms             512ms
>   TSSI normal       20ms             24ms              80ms
>   TSSI scan          6ms             14ms              24ms
>   TXGAPK            54ms             18ms             216ms
>   IQK               84ms             53ms             336ms
>   DPK               34ms             30ms             136ms
> 
> Tested with RTL8922AU on 6GHz MLO (5GHz + 6GHz simultaneous):
> 25 connect/disconnect cycles with zero failures.
> 
> The 4x multiplier was also verified under adverse host conditions
> on 5GHz. 5 cycles per scenario, stress-ng as the load generator,
> max observed time per calibration:
> 
>   Calibration  PCIe  4x   Baseline  CPU stress  Mem stress  Combined
>   PRE_NTFY       5   20     0         0           0           1
>   DACK          58  232    71 (!)    71 (!)      71 (!)      71 (!)
>   RX_DCK       128  512    23        22          22          23
>   IQK           84  336    53        53          53          53
>   DPK           34  136    23        23          26          23
>   TSSI          20   80     6         9          14           9
>   TXGAPK        54  216    16        16          16          16
> 
> Legend: (!) = exceeds PCIe budget but within 4x budget.
> 
> Two observations from that matrix:
> 
> 1. DACK exceeds the stock PCIe budget (58ms) in baseline on 5GHz
>    on this hardware. Without the 4x multiplier, DACK fails
>    -ETIMEDOUT deterministically on every connect, no stress
>    needed. This is the condition the patch addresses.
> 
> 2. Calibration times appear dominated by USB transport round-trip
>    latency rather than host load, though hardware and external
>    component factors may also contribute. DACK stays at 71ms
>    across all four scenarios. Host-side stress has essentially
>    zero effect on observed calibration duration. Bumping the
>    multiplier above 4x would not address a failure mode that
>    this stress matrix produces.
> 
> Reported-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> Link: https://github.com/Lucid-Duck/rtw89-usb3-gap/tree/main/evidence/crash-2026-04-11
> Signed-off-by: Louis Kotze <loukot@gmail.com>
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca> # RTL8922AU (BrosTrend BE6500)
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca> # RTL8852AU (D-Link DWA-X1850 A1)
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca> # RTL8852AU (D-Link DWA-X1850 B1)
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca> # RTL8852BU (BrosTrend AX4L)
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca> # RTL8852CU (EDUP AX5400)
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

5055188134c3 wifi: rtw89: phy: increase RF calibration timeouts for USB transport

---
https://github.com/pkshih/rtw.git

