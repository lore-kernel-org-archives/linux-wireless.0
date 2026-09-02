Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436DB30D41B
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 01:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788314358; cv=none; b=igvcDEereFgfTH+T6dLnDigILaI8tr8Ea4L6t3SSeWX2tQXE3uwopCgGLVOP6Ia//x5E0pRoZYo26H+UEm7RHwe7FnGo6aR0FlWPPZOvw8WkiZx3xgCLItBixHjKko8n5UxYEaeCyuX8Gtla5ddRY+bLSe72kqEyrfKPymxLl7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788314358; c=relaxed/simple;
	bh=AaNZh8xPnXpuLnqR1XxMEKQWyavgl7j+Bu7xnXcNL1M=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=gdgHpaYD2JNbcn7NU3fTCaBz+SA05EF1IefTJSWuqDGFjh4RPVbEkX0SbUNSXtBnQ0n0kMVX318rdWdAXtC4cXmNgA+/Ln3tfRzs+MDJwBFQvu071UUV53Y2XLr/EqhHWAd9mmMFFCOSSc/A7DPiWVH3YN7L8CHVdlwcUjGNPIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kCpz4NC1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kCpz4NC1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6821x47N12232128, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788314344; bh=e9or6bHgj6yY1/Ybe0QA0qwy22Iv64gSVf+lu1ABRAo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=kCpz4NC1g4S0miNWZC9jzXlqrpGu3IqZzhBTbKFAV0lx2sDcx+NcmBRKRlZmNNUDI
	 X229ml+Gu9YD2cAM6EelRKGPetJVyXpYZCFz2kvx3FJOjbMDn+JBp7dZL9MNOS44/Y
	 sfm+jkHtrKF+5Mmyesgky1kV4HwFS3zP9KwAv5s9N3fc/WT2DDenrh7xcO+ATWqwf2
	 +q0TBkxOJYOtU0mx4y3TlcG0WK66u2MIeYJfRdJIZjgUhWa4EIap7tvDxRck+59dSY
	 Q2JZ+JiQ3dno0AkEvJz8GE8f6DjHnIcztWZZajTbpKlvZQ6V3v9UZt9ohHiNmK5C1Q
	 eOhkwVdgAaIog==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6821x47N12232128
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 09:59:04 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 09:59:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 09:58:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Chelsy Ratnawat
	<chelsyratnawat2001@gmail.com>
Subject: Re: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_mask
In-Reply-To: <20260803115826.992789-1-chelsyratnawat2001@gmail.com>
References: <20260803115826.992789-1-chelsyratnawat2001@gmail.com>
Message-ID: <5ef8786a-5d51-4504-9121-bb46cd35bc39@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 2 Sep 2026 09:58:59 +0800
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

de25d015c1bc wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_mask()

---
https://github.com/pkshih/rtw.git

