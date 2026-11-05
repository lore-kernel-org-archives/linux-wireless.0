Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793856129;
	b=F53x/yUd/kseXuATAuPSXYJBhyGstNMvQ+tWnryj32oEd9t0Dk2ir9DjcM4Pn5q89wep
	 i74DKDElH9qVZ66vqFSpJ5zc8B/3JnWVWoWQWIFvz60m1d7O2xmD0wRskQ0RJZhMWSu5o
	 /v/HWsD42K4eio0J4CetnRyLXkCREXcdmS/QjVpmzU83KEXzEof0uLsEVOwM5/SOGg8R9
	 yOqRGoR01HvItRrOOJurKJkyk7frYdjojLQ9XYpUD4MBfROdQ5RNAUo3VxZT7YYRTY9h7
	 3ukwdo2D9apFaPfdJeQijHXPDU7mWm4kLjknNgW3sRtFnb0EadDu+FwSkFuCTPCk/ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793856129;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=LcqTMGULwe+DviPMfKbkj6/gs7geM9NMyKkoVcGPyyc=;
	b=KwTxu2n7J0eY8Lit/M0xjplRMRlpSFOd2x7Z7JlwFb5yBdwtAST8u1QAg0O0HjMQqgu3
	 x5SBJqNibKjC1UPscW9roEbY1zPINB56j2uWZ75lsb+jLs2m9ixorZ2UT3g45yxOr8VSq
	 7+fafn3i1b/wI4SVv+xnH9CKtOsUmbIQe/4AcAlgILu8zqCX8By9DTQ5t5UJcRYJ9o3mw
	 QCEFMJxu1lcC3UROi0UE4Q1/7ZUVouxvtfzhxNGlk+2aFWSuuCW8Exwf3amrVHAPHQinZ
	 6V4HgEs4S8xd+TCUjpp2ZUj7vOOFTL1N/hrE7h8XWvvE9aPn3omDIJj/AAhtE4lrIag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hOPF+ArB;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44948606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 05:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44948606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hOPF+ArB
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A55LwC32479129, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793856118; bh=LcqTMGULwe+DviPMfKbkj6/gs7geM9NMyKkoVcGPyyc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=hOPF+ArBy6T/f6rwMENjf7YYZVse70stth0Nc6TeenNqFJhAbsOJwuuy1UmNAILqK
	 ikF5QtfnoPsVSWuFEGO5c2kIgZPbKov4fkzRCtGBnCFdrnA2fQxPu8yCcBVoYEzKWZ
	 HiB7r1GNDmtSE0KtZjKdXCHP9dopB7KKeOtlPtGmjGgBMm5pcrgUPvk++5K9Q+n2tf
	 gt24q7aWDk5XuG96Hu+5KzjjgvT32WPFVBavusru9e5j0DEkKDHqG/BNqK+UthhjTA
	 8ULW9DFqtuEzjh5On+0C7pPGIYSs+c344SObAwlkt9tGIbhF6KHpI6oc0b30VjGGqq
	 vEXvq3DSJsSxQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A55LwC32479129
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 5 Nov 2026 13:21:58 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:21:56 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:21:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue decision to tx.c
In-Reply-To: <20261021124318.15993-1-luka.gejak@linux.dev>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
Message-ID: <19187a4d-5fb0-46a9-a401-5dd0309e8e8f@RTKEXHMBS04.realtek.com.tw>
Date: Thu, 5 Nov 2026 13:21:51 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Luka Gejak <luka.gejak@linux.dev> wrote:

> USB decides in usb.c which broadcast and multicast (bmc) frames may use
> the high queue. SDIO needs the same decision, so move the helpers to
> tx.c behind a single exported rtw_tx_bmc_use_hiq() and keep the budget
> state in struct rtw_dev.
> 
> No functional change.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw branch of rtw.git, thanks.

0bc4a591d152 wifi: rtw88: move the bmc high queue decision to tx.c
ff4d3699bf38 wifi: rtw88: sdio: limit the high queue to DTIM delivery

---
https://github.com/pkshih/rtw.git

