Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675951;
	b=VrXtCOUeclN4stqBx8DC/PNjmwp3hpRh9HZ93BkSQ7NoD8YOfKRmxjcDuESgBYNNina7
	 7uA59bBBRRk3m33Vhck2KbW4k0M8oov+C8kAFawdHcyM81fFPIY6eKWXQRc35pjXLv3Dg
	 4/WIVx2vqMYxEpQg6rqRylAvsWkwEpkyJlvGxyFfH9Vbiz7Q3OKevJtQ1uNSBkuffsSt4
	 u2OUVRNyQZyvaxtctB1z3JYq8c5aL2IJ2QKnTyoApYWK03gHgZx4FreBktNb2WmVLBtjk
	 Ccp40eWtldlPeSWBHENTVowDu364gqDFn0Ci0hjAB2mKqVoAgeDvL9+yJHv4i4QJ4uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675951;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=mIrZ4gErurQRZs6H5cYPANkXIAGhkZwY3DBqBaV+WDk=;
	b=FpN7g4VVS9VJrzN7rwxG4q8v9Y15QpvXTyG1+ovxJFeQxGLma7sAT88Kq5IFJD55YqD8
	 yQwHyJTIs+FMcoG3SANhUH7qd4R5qVLfYAMGqz58te/NRETHMUdXS+EdRlw3IWbCybYlS
	 QIVPnk34N+7Jx0M2WHs9lDCOsbfFfCtKrNiKGJYjWX8zK1KbauPC8mNmABi8BTz+rvKEO
	 HjtunKsrcOmVnCFBooHe6dmYoezj+M6lwz2swgSL98oZforFQ5CuBmP6m2tI9xMIkdfPM
	 dvQmb+5QO/9F0W1c78qwjzQTiCA6kbSn4MHYGtAq3cDbTDTn5Fs+0nOUsMjRZlYEY7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=eimkHsrq;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8C606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDC8C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=eimkHsrq
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33J87l82696689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793675948; bh=mIrZ4gErurQRZs6H5cYPANkXIAGhkZwY3DBqBaV+WDk=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=eimkHsrqYrdtL2i1MIqv4QSCfQEBq9gA5yxuTfDaUSwHm578rD0SAePpxaWVDs/z0
	 QBVSfVnIzCsGcSQ4Zcq+TCUpmWyDGIg0n/64yzn8OAOrPcegJac/bAhl81WVHzbDUK
	 hmlqFVLxNCcSO5NiUYvAiyvra580zzTxMLv2CifwLe+/4ldgE8l7GLbOhY34uGB/bj
	 J4Oeh2fAIaxY70t9RhBRM6jAGXiNlF/bJCfN6Gf9ZBNa9hBY0fcXptnrCWae9qTLZT
	 pSU8LpuaeaAx64tt8GEUv18EozrJrERyG9atXJ+nM8ETx1soIimKI+SFgdkEPCyQcW
	 Pe+JT4EbgpHVw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33J87l82696689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 11:19:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:19:08 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:19:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next] wifi: rtlwifi: correct unit of center_freq as KHZ passing to freq_reg_info()
In-Reply-To: <20261013023221.12024-1-pkshih@realtek.com>
References: <20261013023221.12024-1-pkshih@realtek.com>
Message-ID: <37a1b58d-7872-45f5-b748-577eb9f0ea83@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:19:08 +0800
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

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The unit of argument center_freq of freq_reg_info() should be KHz, but it
> wrongly passes ch->center_freq in unit of MHz to freq_reg_info(). Correct
> the unit.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

58729ada8f5d wifi: rtlwifi: correct unit of center_freq as KHZ passing to freq_reg_info()

---
https://github.com/pkshih/rtw.git

