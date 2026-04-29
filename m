Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF94215F42
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 02:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777431332; cv=none; b=FZOisPqhEMoULRt0LIRGN5EQUVuDpJyTDlPTvM2iqKpjJWpwG0lCZ7IV+s4iA8K1Ux726t3hxtMGm7THAXusJl3bVsaaoGSAwfjmObVpGcXljUGF6+0xbWrzb8qRXDqRei++rWYNF+TopubRj49b2kjv72Ss9L1F4k5uEvzC/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777431332; c=relaxed/simple;
	bh=lH+6WBllpnCmz8XZG73/wBCaczMoA/k3xD9+YAfWNQE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=mVpT96DqRYIWJoy8Ryn2e4O0A3H6Z78Y+f05NdHjLgkt2Bn/Gel5KW2AaP0FEbdLg1TuXGI5qkf8O5Uo+LiIvaJ3NQklhCx84rZbh1qan+ZUjqAcHZMDJ/4OHkXaN6wbg1BKykehm2wN67NpIs7NtSeXALWKLeZH+XV0Z6jAkYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=E2b9az07; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="E2b9az07"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63T2tD661912039, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777431313; bh=gIYrxs40KOIzT3bQnTmOxez7QU5v1r2xTLDpLF7GCtA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=E2b9az076lXDjqc0M7lOX8n5syzSnvAluxuir/kPIs17j9iucb4R7vPk2T49MO2/7
	 0uXj7s+7w+jlJP6d0msm8LHrayS9U3D993G7VbjPdBiw/kDyBgM5vS6bH/uZoUxNOD
	 EnaUqtPbN6C8ZaFq2OwHrNKqbUJ0Zs7GzHAf/bGs8F/XuRoPudpVUtpLcV8rkwuGG/
	 q/an4X+hjJEtY3IeY17drdMN/lF8wshJGc6uq2MzObnua+ewCuRd4nO4qeVcPOBK6I
	 P/FKJi3aFJs7KtBenKjGpRPwJgyl/Q2tKQwVqT/6jhifjU2OIJSgL/goeLfpzWLdch
	 rD6YNXmvRKtWw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 63T2tD661912039
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 10:55:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 10:55:13 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 10:55:13 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 29 Apr 2026 10:55:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, <pkshih@realtek.com>
CC: <colin.i.king@gmail.com>, <johannes.berg@intel.com>, <bhelgaas@google.com>,
        <arnd@arndb.de>, <linux-wireless@vger.kernel.org>,
        Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: Re: [PATCH v2] rtlwifi: rtl8821ae: Remove dead code in rtl8821ae_update_hal_rate_table()
In-Reply-To: <20260407123427.14612-1-chelsyratnawat2001@gmail.com>
References: <20260407123427.14612-1-chelsyratnawat2001@gmail.com>
Message-ID: <5164841d-9ba8-43fa-bb4e-36608118cabe@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 29 Apr 2026 10:55:08 +0800
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
> The error was reported by Coverity Scan.
> 
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

d603f2cfa623 wifi: rtlwifi: rtl8821ae: Remove dead code in rtl8821ae_update_hal_rate_table()

---
https://github.com/pkshih/rtw.git

