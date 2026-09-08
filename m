Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4773793D3
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 06:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788847427; cv=none; b=EYl3CYT6XIebiWKDkfySG5QtgO03+NrVIvYLEj5yCUzb1dNpOMJH3Tfusv5SL5H+jhGQBJ7U3arV+ncXpeNyO8Uses9Nkz6ykTu7tJ07uZo4XrHyGqG7O0Wmxp1TEYeCsWVK0Y0WNXF138i7uVx9PgUfIpWQO4x5NT6n7YMIaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788847427; c=relaxed/simple;
	bh=gE/PlIR3t5uZ4K48p539NOU3DEhUoM3oY13EQk2vTE4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=enjLhQp5xjOaxpw9PoDQ7Hr5Dw4DDsospKdgbBSclR+BOyiXj/ECoUjAB3M7Kqd3qREZodprSTg21BM+x+nYi+N64OXtDAmFsqU/aE9+ewFBVwbXm36L5Sl2U3mWlX9fvwru4KaRpd0bNtLOr0fBkNWVuUw7y4hob8MUbwIgph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YeIqo4Nr; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YeIqo4Nr"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68863gVX23561259, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788847422; bh=ZZFDeUwcLElAmkMY7ocZyX/utHQX/vr94O93foXtWrc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=YeIqo4NrkYD2msHyyummH46BdWfTj8m1WYLY+dKgDV3mxFe0y4Ff2w/yzvLlXZYjs
	 hUq0NkdCPIm1JFDt7SsAuYWyRkPztGk+KNxdhGuQere9ewDY8qKVId6IGq+ng+ebzm
	 lSGe1oBOVR0MUJQAd7dyusdLtziZ4ZWraQ4bjBmT8F5GvRo4KyND66lMnf048cwOO1
	 zWp/HR8TPUttS93xLqgZmqflLzqRzk4e/pa7WXgtKYN1ArB6g3aEegt0a30jdvd27R
	 dMBhql3Hgivwgni/t9sD07270c0+wqKtkCp8aUOzupy8vs0WIEGx4OsETKLjZA9Nf0
	 6QKX/qm9rKhcQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68863gVX23561259
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 14:03:42 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 14:03:42 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 14:03:42 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 14:03:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next v2 02/14] wifi: rtw89: 8922d: disable VCORE for thermal protection by default
In-Reply-To: <20260902052958.50371-3-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com> <20260902052958.50371-3-pkshih@realtek.com>
Message-ID: <913d90de-826e-498f-bee5-3b52bc41c64a@RTKEXHMBS04.realtek.com.tw>
Date: Tue, 8 Sep 2026 14:03:42 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chih-Wen Hsiao <owen.hsiao@realtek.com>
> 
> To ensure the stability of the thermal protection mechanism,
> the primary approach is to reduce the transmit (TX) duty cycle;
> the option to lower the voltage(VCORE) is disabled by default.
> 
> Signed-off-by: Chih-Wen Hsiao <owen.hsiao@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

13 patch(es) applied to rtw-next branch of rtw.git, thanks.

2b214a3d00f1 wifi: rtw89: 8922d: disable VCORE for thermal protection by default
0ea8f90346e3 wifi: rtw89: allow two station interfaces in SCC
0ab8684c28a5 wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v4
565dd9a7002a wifi: rtw89: 8922d: set BB wrapper settings according to operating channel
941519462c0c wifi: rtw89: 8922d: move conditionally disabled TX shape to common flow
f56de6b1cd66 wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v5
5630d62627dd wifi: rtw89: 8922d: send RFE type to firmware
23497cfa5503 wifi: rtw89: 8922d: bypass RX IQK when scan
55adcae98e64 wifi: rtw89: 8922d: correct selection of CCK rate circuit
f9b6b239d081 wifi: rtw89: chan: introduce helper and refine active list iteration
5678a22cc96f wifi: rtw89: regd: check only active vifs when recalculating 6 GHz power type
8642e72ca1db wifi: rtw89: skip tracking things when entity is paused
e4ffe7d6683e wifi: rtw89: add p2p device declaration

---
https://github.com/pkshih/rtw.git

