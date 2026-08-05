Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB590247280
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 05:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785908957; cv=none; b=XK3v1AYcFIdOwdX1TzXwEvWhjL7Inpp/NscKYUYCaoEpLZtQinUbvQc6jud08YAsaurXW9mCQAIBM2ynxG1nv41dZ9WUBiQcYoiEIASWkS9MYoxq3xcJeE4wvPBeGetnli7YBBsXEWnJiCnX3ZcBDWiUHgYl+rbJyCYPZUbIIcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785908957; c=relaxed/simple;
	bh=CCVjZr7XlXelaAJFBFJsEByOxM1k5Z113zQnk7XRyqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TlNZjqHtlI3vyjI3fxyuS4WRZiVhe0cLcYcNr1P52svbd5huwQkapM/RspC9f6LW+EY8T2Qqg/jJ4nds7hocFyFKCLh5yZ4hrUq8C/ViTsiC/HPLBXIRIhMT52tYA1xSQYtRLpnwW0/5vnlSJh/BhzpC9gaXw/a41nPCa3pLvYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Qg8BlATR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Qg8BlATR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6755nARa91642827, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785908950; bh=CCVjZr7XlXelaAJFBFJsEByOxM1k5Z113zQnk7XRyqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Qg8BlATRNRJSg/zzXU4/85Fk9FjX1O1z8kXEJdPc7wDQJDslNd3xLRHr9gLXrQk/n
	 4JBaFBKhdQhhnydrwL8pdtxlZZFUX0cL/RvGQAeVZNKS35noCpsvcWVvfInFpt93O3
	 pmMC2u+yhAUPzTMgrLwPIlsn5CAkDDkHli0/9/B+z4qwbti4hbAQ8s1QBVPVUNKWcQ
	 DMXWT8F7L267uoOeoC1HJs/5OzCgOmaJcqd/JD+/TiqIyl7IiDMaTATfg6FkTDMgYX
	 c7gjEveNREUR46mHgKr3YfyyJPhZpQDzlxhljLud3PDbf/3hfetLUvPwU+61zOBXbW
	 ijvMCewDfwn7Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6755nARa91642827
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 5 Aug 2026 13:49:10 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 5 Aug 2026 13:49:10 +0800
Received: from RTKEXHMBS05.realtek.com.tw ([::1]) by
 RTKEXHMBS05.realtek.com.tw ([fe80::61a9:c619:5327:6ce4%4]) with mapi id
 15.02.2562.017; Wed, 5 Aug 2026 13:49:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in
 rtl92cu_update_hal_rate_mask
Thread-Topic: [PATCH] wifi: rtlwifi: rtl8192cu: Remove logically dead code in
 rtl92cu_update_hal_rate_mask
Thread-Index: AQHdIz9rUbY58lrT4UW8OQdw46ppRraO9TFA
Date: Wed, 5 Aug 2026 05:49:07 +0000
Message-ID: <6feea5e213b749e99a0335485884a586@realtek.com>
References: <20260803115826.992789-1-chelsyratnawat2001@gmail.com>
In-Reply-To: <20260803115826.992789-1-chelsyratnawat2001@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:
> The variable 'mimo_ps' is initialized to IEEE80211_SMPS_OFF and never
> modified throughout the function. This makes the condition checking for
> IEEE80211_SMPS_STATIC always evaluate to false, rendering the entire
> if-branch unreachable dead code.
>=20
> This error was reported by Coverity Scan.

The 'error' seems too strong... I'd change this to warning.

Also add parenthesis to function name of subject -- i.e. rtl92cu_update_hal=
_rate_mask().

(no need to resend)

>=20
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

