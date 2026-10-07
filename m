Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E3E347FCD
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 04:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791346759; cv=none; b=l0MwXR46+KGxAx1bPZfTeIQHQ8wBYYjFPWYwf1eShHOQAqVbJApY6Lxz6z9KSyiH+cjVWG1NGYPwdAbCZ3o5QZWDG5jOTZWt7hdoWtD8WAVCSQHVjXuIwiHpSHcNH0eY5me9gJL9KWe3abaGa1poVXu32PiRclg3gzQWd1VgcfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791346759; c=relaxed/simple;
	bh=2TXstH5EiuRr2KtCfta79pierSSoYyi4VmXosY7W3bU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=byXMCbMfX6tVziWLNpf3bB5P346iljg4zijfed4jNreINKWcuKJtsec4XuTxIyiFanHPPMybzbtyuoHh2LYUyrUI3smTQZpOOa7jhargTxelAGwvm5M8QGGdHgPmiVzMIRlZZCLJPcT0PleCMLbUTsqxsRoLrEBTvVwpR5LmtI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=wwE+hwQ2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="wwE+hwQ2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6974JFOt83562474, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791346755; bh=v7XoNaZcgQvEem7ER2hqB/bwCcSrLvoi4eD7pZ6ZIPA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=wwE+hwQ28h/t/w9hrnnM41LB0RbqPFpYck9WHgI6n5cUixDlwdExilq00Zibb+jxZ
	 49hs6/qXD6jx8MAU2bF9hTYXVot/wp9aoS7WH+T1GiHUUQ0sI7XCBIZKoSXdH2LDG/
	 4eEp/7po9Xv/srw0A+u/hFTfoXpJJoTRCrFrcsaF0+UoPwE+xzoMHdO2MEKLp7WuVC
	 DYArWdZdUDhIcqtus0NOMaqEO9lu0DkzwgTq61eAoUxELo2LiCB4r5U6tw6w49Keww
	 GT9hQvXh8NG6XnJS1FDbMh3+SJ+u2Zsj0bLiJDWtmcBkHtPIZAvrdW718OG/95Yxux
	 W+S7aYLki+4/Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6974JFOt83562474
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 12:19:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 12:19:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 12:19:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next 01/15] wifi: rtw89: coex: fix RF band check in _set_rf_trx_para() and its propagation
In-Reply-To: <20261004034520.33695-2-pkshih@realtek.com>
References: <20261004034520.33695-1-pkshih@realtek.com> <20261004034520.33695-2-pkshih@realtek.com>
Message-ID: <fa5509bf-e2f6-4480-a42b-72245c30c324@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 7 Oct 2026 12:19:14 +0800
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
> dm->tdd_bind.rf_band holds a bitmask built from BIT(BTC_BT_B2G) and
> BIT(BTC_BT_B5G), but _set_rf_trx_para() compared it against the raw
> band enum values RTW89_BAND_5G and RTW89_BAND_2G instead of their
> BIT() form. Every other site in this file that reads tdd_bind.rf_band
> wraps the enum with BIT() before comparing.
> 
> Because RTW89_BAND_5G equals 1 and BIT(BTC_BT_B2G) also equals 1, a
> Wi-Fi/Bluetooth coexistence session bound to the 2.4 GHz band was
> misclassified as BTC_WLINK_V0_5G. This incorrectly skipped the RF
> Tx/Rx parameter adjustment for 2.4 GHz STA traffic and kept clearing
> wl_stb_chg to 0, so chip->ops->btc_wl_s1_standby() never re-enabled
> the Wi-Fi standby workaround for the Bluetooth Tx-to-Rx GNT switch on
> RTL8852C, degrading Wi-Fi performance while coexisting with Bluetooth
> on 2.4 GHz.
> 
> Compare rf_band against BIT(RTW89_BAND_5G) and BIT(RTW89_BAND_2G) to
> match its actual bitmask representation.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

15 patch(es) applied to rtw-next branch of rtw.git, thanks.

bf4c84e72fbd wifi: rtw89: coex: fix RF band check in _set_rf_trx_para() and its propagation
fd4d5551eae1 wifi: rtw89: coex: track per-HW-band WL role fields with arrays
fbe6912f1980 wifi: rtw89: coex: show per-HW-band MLO state in WL status dump
806bd61d5139 wifi: rtw89: coex: add outsrc-set-info v7 for BT SPDT state
235a6ff568c3 wifi: rtw89: coex: compute WL/BT cross-talk interference maps
c4b17492a37c wifi: rtw89: coex: add 1SS MIMO-PS decision for dual-BT CIS
a35cf81f6084 wifi: rtw89: coex: add firmware 0.35.119.3 support for RTL8922A/D
8773800337cd wifi: rtw89: coex: raise default BT TX power to 10 dBm
d4a862cf7661 wifi: rtw89: coex: bind the RF band in use while WL is doing RFK
96ad55bfbb65 wifi: rtw89: coex: store BT TX power per device and per RF band
f3207ae57274 wifi: rtw89: coex: set the WL/BT antenna map on shared-antenna chips
236478d51ffc wifi: rtw89: coex: use the right switch-type enum on RTL8922D
c739640e347f wifi: rtw89: phy: Implement API to control BTG to turn on/off BT TX/RX
256725d0ec78 wifi: rtw89: coex: turn BT TX/RX on and off through the BTG control
57dc6b251419 wifi: rtw89: coex: set rf_combination in _update_wl_mlo_info()

---
https://github.com/pkshih/rtw.git

