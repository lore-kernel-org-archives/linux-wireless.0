Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE741EB1AA;
	Fri, 17 Jul 2026 02:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256050; cv=none; b=lwUokhC10HDq0iQsXuNMjFZOlZxOmN5CPRj5e3CX4okxvfktLX6+HZHeSjDjUfKn5EQhR22VglHCnL8NWgaab8TMi+5zB7K6F9BdzuqdBmpEIL3i/UTKSEH08cLwf47YzxuqB3zzGtuBdPxaT5WmDg4JQ+ZGO+f5/r6vU+HLL4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256050; c=relaxed/simple;
	bh=g8m1Y6+oqMYLnhtm7OZOJ8dTXVLWbc9Jka2YtLGH9zc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=VnOQq4U9UxwO3lXWrKergP4o0E4LOWCcjvE6pEvu0a7QEO4317T2z7wsLLgVgPM4ttm8PBF1UiDkBcTiZn826H+wenzV4pwHTstkiPyEcjvEfISxoieHGw1HucZ4cMpExdmipPDTCsjTlbMUWFE0T9NTg9Cbet3xBQKJ1cheOpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pUCEza51; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pUCEza51"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H2ehyJ74071120, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784256043; bh=IoDtv29qpU015eNH8kFF8rOJK6d8QZQkro4KDzodAXk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=pUCEza51DsKO1g2wV3637v1BKysbIUXeK+v7sMXHZYsQaiFd8CwFQN8wSH9/RBpPT
	 F0zVZc9mzS7OFiCSTRj07gUsPkuXfC+2/LYLwHu9wv50kAS7xj6qnFYxHVd8CNP1ER
	 vl5yTj0H3tRKUytJ29KJTx2tOeWeR8G++M9WefmYgKpT9q09f10PniD3eoXLCKXTSy
	 Q5RczvX/pB22oBQ4ipWjTeVtvtydGNWqBsvoKk+xOtaRIszUKoufUUN9omspwT0XtT
	 BRx+lRZvswZWh51SvdKMWgGvaCQ8ocfUoMrf1okFYLe+/GZYNPJUg77P0w9FATgLk0
	 fkGLMdutJpaYg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H2ehyJ74071120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 10:40:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 10:40:44 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 10:40:43 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 10:40:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Chelsy
 Ratnawat" <chelsyratnawat2001@gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8192d: remove dead SMPS rate mask code
In-Reply-To: <20260709194315.157030-1-chelsyratnawat2001@gmail.com>
References: <20260709194315.157030-1-chelsyratnawat2001@gmail.com>
Message-ID: <7ca641a2-66d4-44c6-ad44-c7b91c1ee5cd@RTKEXHMBS05.realtek.com.tw>
Date: Fri, 17 Jul 2026 10:40:38 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:

> mimo_ps is initialized to IEEE80211_SMPS_OFF and never modified in
> rtl92d_update_hal_rate_table(). Therefore, the IEEE80211_SMPS_STATIC
> case is unreachable.
> Remove the unused mimo_ps variable and the dead branch.
> 
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

d4157cd3aeab wifi: rtlwifi: rtl8192d: remove dead SMPS rate mask code

---
https://github.com/pkshih/rtw.git

