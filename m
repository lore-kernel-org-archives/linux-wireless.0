Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ADE221F39
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 05:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777440804; cv=none; b=rmdoy8ImLYHN/d1f4sTIdgvchF58AkoXA0vFBXVF5usYJvRadNF9LrEEjX/jK9bIQFM8XvBjg2dSPWeTn+uNIA3YFiCewVSzB+6Yk4nrjw4heERj3Y4wPIFAFRCRMTNSTwMmxfOClTF/hNWgyHIqMM1KNXoALHx1ClPgLvyuQ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777440804; c=relaxed/simple;
	bh=1xRKGe8Y0AImin3kclxXMF0qQvU4B6dFEtktcydWqkY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=Z4doHrFU2vYDp1Ly94mTNlCKa1hQtKjXFne57/LUzPZ6tEjRS5Is1Y4v7XEI1vsoA0Tk2hbkiRfnsYU376d/W28yqrVt8wu07LOj93ldyiaCfGxnM46ATCVCb1UDJhCH2ywksQkmOeLdSvzZqwOMKrZ9eK6Tk6+WG6dNMWDSPm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=npVIEhw2; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="npVIEhw2"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63T5X0psC1013586, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777440780; bh=aNApjnlYpbTfVeJLSmMdHU8YyLW4wFvi1rQJT4H/+vU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=npVIEhw2WlPp5lZTSZaNj+FpJWrgGY56qikEXUEQZWbt7/3nEyQVUXi7IqhjfGXqe
	 iP5fSn6JHrACvNu5WuKb0wG5H+LNz4T0xKc7/888/Dv4Em7kklzDxgCTzQniuHdaqM
	 29mmYmd8PBjoAMUcKiCzCeZLljeWPYhXEG6Bfew9vuLJyye91W/UzSwMUPEScZBVfH
	 aOhEqlCs3KR0jWiUf/gGa4FHL4r2W0YSsowAL6dQhjvZ4Ne88b/WtJmuimXFwEdvs2
	 oIJtLqCtqkTQHvfNxSTwgCghYsX/gzCZHzIEgTkP5ms3jOvE7v8UgqKGNrLYlRjgEs
	 nkAr1Kh3dbwxg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 63T5X0psC1013586
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 13:33:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 13:33:00 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 13:33:00 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 29 Apr 2026 13:33:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Tristan Madani <tristmd@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Johannes Berg
	<johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>,
        Tristan Madani
	<tristan@talencesecurity.com>
Subject: Re: [PATCH v3] wifi: rtw88: fix OOB read from firmware RX descriptor exceeding DMA buffer
In-Reply-To: <20260421111434.3389674-1-tristmd@gmail.com>
References: <20260421111434.3389674-1-tristmd@gmail.com>
Message-ID: <b4b2ce96-fe5f-4a22-a564-6d73e991bc42@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 29 Apr 2026 13:33:00 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Tristan Madani <tristmd@gmail.com> wrote:

> From: Tristan Madani <tristan@talencesecurity.com>
> 
> In rtw_pci_rx_napi(), new_len is computed as the sum of pkt_len (14-bit
> descriptor field, max 16383) and pkt_offset (drv_info_sz + shift, both
> firmware-controlled). The result can exceed RTK_PCI_RX_BUF_SIZE (11478),
> causing an out-of-bounds read from the pre-allocated DMA buffer when
> skb_put_data copies new_len bytes. The USB transport already validates
> this (rtw_usb_rx_data_put checks against RTW_USB_MAX_RECVBUF_SZ); the
> PCIe path does not.
> 
> Add a check that new_len does not exceed the DMA buffer size.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

6e76e9ed273d wifi: rtw88: fix OOB read from firmware RX descriptor exceeding DMA buffer

---
https://github.com/pkshih/rtw.git

