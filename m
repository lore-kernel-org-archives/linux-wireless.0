Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8269B31D381
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784260430; cv=none; b=uCpny3QqarjOiJQyGckqlg4cM4Qs7NJtdfUOPxmrAqveyqUpmPgbl8dA1CGqc/gwPwwIEvThT5zgjF2tSPen37jbFFdzj1ft9+2kF9WZlJDLl7IsXtr8XaqAsy5O9tzdNz7Z4ytM44GUeRT/rDDEbjaHuWwcydNMfAt0UPHZw/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784260430; c=relaxed/simple;
	bh=vrSoHs5tYv6X2gYHX446DrXUGNgzUWe1n03fAM9kPoU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=tROmPlM59N8LCjrIAF4nYqAatYO+U6+eZA5saCqz4jIIpdGS6lLy7NbMYRqBKIAKF7CFJ+YX/JjTw/TDb8/noD9TNuFdRUUPJSA5Q1c2MFctxJ/TM8tuOUXWrG+PqzTUU8lnhihK1Fxh1iOTSrOvFX3NNgJV8kADNniGgj9CHmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=be+zFgvI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="be+zFgvI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H3rhvoF4115950, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784260423; bh=M4O7nrMtGtEw8znrDlTbMiglvzOp3rePXQVVl7UM5ho=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=be+zFgvIpwa7L/tiHDA0ctl+PbNvXTmFqNVlc9A3/iH08XaLW4YZxV/oXMPmmHMRJ
	 lydfz3oSFlq2UECvhi6Enfy5Q7va4sMxK9G3a4koVC4ud8Z64BidTcYCwTfMqDTLft
	 EvanmCSgnZ8dD0f4BkigNIhNzLcTMRAEQolHeqEd0LWgcmmU9/OzkH6wsgHdfzEE6l
	 QNZxMhssP7hGNSKfU5nlkfZWZ0AEoeZa7iZz9wo4eU2skzk7nLHEiimA5o2GCHc8Mz
	 FZTQvW9+x6j6NgK6vtis12hpaxxTgjAeiDf+3dMniKPRCrJ/Tvh61Urf9fkuX8k03+
	 SGuVGwze9ONsw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H3rhvoF4115950
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 11:53:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:53:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:53:44 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 11:53:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <leo.li@realtek.com>, <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: fw: use MAC source for IO offload delay command
In-Reply-To: <20260714074811.30124-1-pkshih@realtek.com>
References: <20260714074811.30124-1-pkshih@realtek.com>
Message-ID: <00f23f30-5831-407e-bc42-9caac75d700a@RTKEXHMBS06.realtek.com.tw>
Date: Fri, 17 Jul 2026 11:53:44 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chia-Yuan Li <leo.li@realtek.com>
> 
> The udelay/mdelay helpers set the command source to
> RTW89_FW_CMD_OFLD_SRC_OTHER (4), which does not fit the two-bit field
> RTW89_H2C_CMD_OFLD_W0_SRC (GENMASK(1, 0)). The le32_encode_bits() masks
> it down to 0 (RTW89_FW_CMD_OFLD_SRC_BB), and compiler throws
> __field_overflow() error. Fortunately it still works because firmware
> ignores the source field for a delay command.
> 
> Use RTW89_FW_CMD_OFLD_SRC_MAC as the vendor driver does, and drop the
> unused RTW89_FW_CMD_OFLD_SRC_OTHER enumerator.
> 
> Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Closes: https://github.com/morrownr/rtw89/issues/111
> Fixes: ae3d327515f2 ("wifi: rtw89: add IO offload support via firmware")
> Signed-off-by: Chia-Yuan Li <leo.li@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

730dbda6dc70 wifi: rtw89: fw: use MAC source for IO offload delay command

---
https://github.com/pkshih/rtw.git

