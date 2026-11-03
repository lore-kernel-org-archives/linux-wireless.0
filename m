Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793685278;
	b=lxRzPgW/WDAOnt18kWXP5G/uMaqIQERManzUEViG8nFgig4UJsNO7/6x2mNpjTWGEabt
	 JzwGjGVncePpTjQYDKYX1ok/ND/nEbNB3bLRCqcKahNcQKPAVF5FXgS5J8r8bir47t861
	 qpzir9gs+rlV2dQ9MdI93SmlgwpVWbhLXQCRjA4M+0iCdeWR0OKMtQ8TgdgmkXPQm/LUs
	 pL7X+J7tbhgHyJwPJ6mqtRUJAA1jG5DFw+5r9P4jyllf9Dro6OpWwCiL6EO3WsPrH+Mpt
	 gbUga0fl4K/1QUreuHIDCTktVz+DDneihrHz1US6Zrki07xTD050c3toUptWDvKrC6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793685278;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=FsxV6gx2jOppxne1N+ffOsujBoqL3LoQjEaNp1iXLQM=;
	b=iXbkzsTGeWItjyahSjcHan+jeG8jaSg7MFiugkK4EbyRq3mKDEc/J8eyIbHr1DviGtHF
	 i9WME0HJ4AJpgmuuUILS115kFp7ns4kcIe0JA7fBH9btO/gz+8Y5GtmhRLmxYUhFYaMqX
	 f0WoTPwXKBREa3deIm433eAdDSOlM2przgoDHYRnCC1xymgx95yxy8/ztU/DXjLckWRwU
	 f/SpWqDLdQbmzzBlY1PrNbDv4I2N2tyb3E4kaITa3Ht+RqxQkmiRWu0GYtJ7o+tbq0Zyx
	 I7LXn0Q7Bmwll5MsEOG0NMxO/WM3HTQcoWIHFkiZ1Pz5IZjlnm9jZQd367tQcWduRjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=tNZkUjGa;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1F8606A324;
	Tue,  3 Nov 2026 05:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C1F8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=tNZkUjGa
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A35sSyD52775820, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793685268; bh=FsxV6gx2jOppxne1N+ffOsujBoqL3LoQjEaNp1iXLQM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=tNZkUjGaePzDeFkBO7HuxUL+ohsfJofNVGPb66RlVXNFyOkcwSHpFeTModU2OMfLq
	 Aa/2AbAsZpGADl4k3bOA4N4Vs8OuyaJRAhnhh0aIp78zcLuRsFTz32fW55Amd6gbaB
	 eI60pkqRMoIWCmpZIOhOi2Wr3ku5nty7YD2lzaSb7EN2vHc3by44V7okbn72i1T20R
	 UgJScIX6lCLLWYu1HlkSNni3vljsZXHhsQyO9qsUslol7BoILjeiwhlW9ktdS7yd3e
	 Ix4qr2u+AjGU+T+Y8rQRUw/F+HXz7YkSJWc8SlMSH27z81SHxXY/4BczEX5bk8RwpD
	 aHP2m9iChP7XQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A35sSyD52775820
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 13:54:28 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:54:26 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 13:54:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kalpesh Solanki <skalpesh942@gmail.com>, <pkshih@realtek.com>,
	<kvalo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kalpesh
 Solanki <skalpesh942@gmail.com>
Subject: Re: [PATCH v2 1/2] wifi: rtw88: pci: Add DMI quirk for HP Laptop 15s-fr5xxx
In-Reply-To: <20261103031434.14449-1-skalpesh942@gmail.com>
References: <20261103031434.14449-1-skalpesh942@gmail.com>
Message-ID: <d428a558-1c47-4942-a522-8509a346eda1@RTKEXHMBS03.realtek.com.tw>
Date: Tue, 3 Nov 2026 13:54:21 +0800
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

Kalpesh Solanki <skalpesh942@gmail.com> wrote:

> On the HP Laptop 15s-fr5xxx with RTL8822CE, PCIe ASPM L1/L1.2 and deep LPS
> cause the card's firmware to fail to resume from low-power states,
> resulting in repeated 'firmware failed to leave lps state' and
> 'failed to send h2c command' errors and stalled network traffic.
> 
> Add a DMI quirk entry for 'HP Laptop 15s-fr5xxx' to disable PCIe ASPM
> and deep LPS, ensuring reliable Wi-Fi operation.
> 
> Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

04c998418722 wifi: rtw88: pci: Add DMI quirk for HP Laptop 15s-fr5xxx
dc16902cad9c wifi: rtw88: ps: Trigger firmware recovery when failing to leave LPS state

---
https://github.com/pkshih/rtw.git

