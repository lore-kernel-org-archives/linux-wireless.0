Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159DC946F
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2024 05:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722404766; cv=none; b=m2fFdGRHg8OqjtHUAMzGIW7rY6nJzKX1HJBwa+vxVv3y+/ar84U8Dc2e6Ga0b7yyXfz1Vq9sSQ3Ute7RZ1TUzyjiGj2WWPSqWnlrTX++BiQduiO3XxI2DoqldsKZ7Gya18y/PpmOVle0VqwVkK+4lKp8237knPF3Mn4wvnqUPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722404766; c=relaxed/simple;
	bh=+DB+WdzfbnlOhbyfSEt6spgx49Tg6g6d0gI1Rm7gBFI=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date; b=Ofk/OfHeQn5ODxtv62lm53J5is9jfwIgImXUXE3iOG93DlZ8pNfkfLuANravs++L5Qc3ulWQHFaH4/QwzpnKS9ejD8ZYdPJpmGuliGxq7VCRNti8DbZRzuYA8zjG5Oi9qZ1GuUXxCm6qKA6X0TcbXByOrnV2IxUclsp/tFIURi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=temperror (0-bit key) header.d=realtek.com header.i=@realtek.com header.b=fQI1zI0t; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=realtek.com header.i=@realtek.com header.b="fQI1zI0t"
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 46V5k1QA12001929, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=realtek.com; s=dkim;
	t=1722404761; bh=+DB+WdzfbnlOhbyfSEt6spgx49Tg6g6d0gI1Rm7gBFI=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date;
	b=fQI1zI0tzYsNpMQNRW9HwtbkUu16fMWgl8T2MiCkcDWi9o+maaDSPDMwR90X51d01
	 QKOvsRlwtVNF0ynZ/6riwSs0RFFsTu5A/Kw5vYnBM3uJCP78QS5Meb5JZQ+hVFKJ98
	 iS77LYpZcvTYWMSMyzIIwmTpJSnt8ZrYfr8XlT0quEY4s8zO2wZ4DohRtEDZDOqxQA
	 aCTyFCC50BQNJj8zShgEcZvZvdRRuxwEYISGH6UMTSOj98kdn8KF+ph/NE+tl0LwwA
	 TXJQLaMKF19VZfJyS386dSlxs3pmDIWptNp272YQczi0AS1tfpBV1pOOm92Sev4Gup
	 mk0RJB+fd1SRg==
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
	by rtits2.realtek.com.tw (8.15.2/3.02/5.92) with ESMTPS id 46V5k1QA12001929
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2024 13:46:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 31 Jul 2024 13:46:02 +0800
Received: from [127.0.1.1] (172.21.69.94) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 31 Jul
 2024 13:46:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: Re: [PATCH 1/2] wifi: rtw88: select WANT_DEV_COREDUMP
In-Reply-To: <20240718070616.42217-1-pkshih@realtek.com>
References: <20240718070616.42217-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <0e23e05c-219c-4141-91d3-1cd17b79fbd2@RTEXMBS04.realtek.com.tw>
Date: Wed, 31 Jul 2024 13:46:01 +0800
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Zong-Zhe Yang <kevin_yang@realtek.com>
> 
> We have invoked device coredump when fw crash.
> Should select WANT_DEV_COREDUMP by ourselves.
> 
> Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

7e989b0c1e33 wifi: rtw88: select WANT_DEV_COREDUMP
d523dc49d13e wifi: rtw89: select WANT_DEV_COREDUMP

---
https://github.com/pkshih/rtw.git

