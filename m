Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4A333BBCF
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788315168; cv=none; b=U7dH8Ygg99uRH5htNNTMl19wriZ9jFrxFixDAQwwHqy+0ree6yQnHheKA1wPohRcgUEZMjMV+1wagvVxO4CmzmUkZVDcIniaY+TzgXNZlvr8yM3j+UF9EYGkxFIS9NREyZWbSgiGKLotgGV6BxfYiW+urgjQ+Sj6dTvjHwzc4ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788315168; c=relaxed/simple;
	bh=Rws4vFcrZPlcoDecjDi/vtLTtpgr8dNVhhQocaQv7ZU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=kLkeFK7Gi17SYhXSFJCxeedvpDqimzDKezUimoOubIM9F/wcEK4gITImLggliekiQ+7WQa6goMzTKLMyxjHtRlppOxGaVOhQPSpgbZz81j2mja2/ycgAAsCovg8XCKwLXvSvGHZ/+tTs0KMfzRaTvwApbw9cW/GfUOsaqsI7BeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=D39jZfcb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="D39jZfcb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822Cez562240386, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788315161; bh=VvpycyibedExbI6rZT2wvfTfeJWDkjRBvZsGhHhyjpo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=D39jZfcbIwDTAm9pLNIvHSsI7vF82CU/AA6Tndxx2itL26z82f3db3JHrKy7HSJet
	 joNvkY6hNNcWpvNcc2Vha5yGb97Kib5PKRl3XVP2VUHKn1+/c0b0GWXRuvFfpxQ/5j
	 YdJfYLydFZUtRPxPiXIUQBKxP0cP4NvyhzzlAF8QedMFxAvDEcNPVrZGUGQbfkMCb7
	 vKDg/hIVwxouC0BUKWh8FYauSwuW2q8d9n1rd7FDOuQXmeZdzR3me6xubgLednbB0Y
	 LVTwdceqICdMc1zAB7FemrOhXnjEoLfaBuK7wEDX4BTrEh2czflmzjbeOBSyD/NgqJ
	 /yjxe9vWjQqJQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822Cez562240386
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:12:41 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:12:40 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:12:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 10:12:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Chelsy Ratnawat
	<chelsyratnawat2001@gmail.com>
Subject: Re: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_table
In-Reply-To: <20260803131203.998989-1-chelsyratnawat2001@gmail.com>
References: <20260803131203.998989-1-chelsyratnawat2001@gmail.com>
Message-ID: <d9c83035-3c97-487d-9abb-31a1f8f53899@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 10:12:34 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:

> The variable 'mimo_ps' is initialized to IEEE80211_SMPS_OFF and never
> modified throughout the function. This makes the condition checking for
> IEEE80211_SMPS_STATIC always evaluate to false, rendering the entire
> if-branch unreachable dead code.
> 
> This error was reported by Coverity Scan.
> 
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

bf81c3cb25a3 wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_table()

---
https://github.com/pkshih/rtw.git

