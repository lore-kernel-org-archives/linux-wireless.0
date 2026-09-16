Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA4B345731;
	Wed, 16 Sep 2026 05:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789536708; cv=none; b=X1dY8Ly1V2dHqcsBr4WNHZd+ZhRn2CwrGAEaDQ8Koan0PPbYqj0ZWQoRpZoglB3fuaTrGMHOUaxQC6xzSOBGCHcrG1e7WxkBCtkjfe7OlyYbBPPd+gd/OfPyfoHrlp4MNZd1R4/tLRldvYQ59+MGnv+iEX1PdnDMaZjiRLCDxn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789536708; c=relaxed/simple;
	bh=KSCJIhpdUupvjxt04Y9XoOzMQ3gXPzAoi4k0AEtJdLo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=fc+H1ZYkBI4hbopqITT8zUbUMKoTlt1q0XZPl6x/RlJycT/L4BmLUz8/se0bCh2KBzp5UvYh3yNbwuTwF0Vzl3MnIS6c3zKrKup5Iz16Dq3xglalJ6eK1jbk/5NgbmwmuVn/dZH7YG7BkEKON41jYsC+gCSJAQtE+a/GY2ZiWO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=G1GSu4P4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="G1GSu4P4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G5Ut7aA2125395, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789536656; bh=jC7EBGSfeONnG/S3jzR3StuFUR70jHIgoHjq2fzaY04=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=G1GSu4P4BGiNvlgQ9CVB+qyFnl5DV3K8OKxAw2/rBdS+WRILE070MKG/S+tqTXaOt
	 zgrIR8WRNhXL32AWkdssJGqK9Cd/2+B6jWf4MdMtA6Qin2mNZmSDzZixbX2ITXi6/8
	 zNLnJB/leWgnugVFjmSd6W2Egw91EbTZeH1kuMYQCVP+KmGlx18EiGCL+E6sLzf9vt
	 ykB+86boJBTuBJomUIgvtGFxoqNKTKyI1dBSDeTMNauNrR1H98O30/cVw4TRjPr/kv
	 o81csaNyS5r+MztH1oCYHYV04y7cdTSpi+2knBQgSjaRvdPJcS/cWA0jKhmvUlBjDa
	 4EQQ/gbG3bLrg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G5Ut7aA2125395
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 13:30:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 13:30:55 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 13:30:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Cristian Deluxe <me@cristiandeluxe.dev>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] wifi: rtw88: 8703b: complete the card-disable to card-emulation transition
In-Reply-To: <178914109042.64584.1377616159988360897@cristiandeluxe.dev>
References: <178914109042.64584.1681714272474754544@cristiandeluxe.dev> <178914109042.64584.1377616159988360897@cristiandeluxe.dev>
Message-ID: <3eaf2e81-be50-42d7-b8de-eec920d4b8de@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 16 Sep 2026 13:30:55 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Cristian Deluxe <me@cristiandeluxe.dev> wrote:

> On an RTL8723CS the driver cannot power the MAC on after a warm reboot:
> the power-on sequence waits forever for power ready and probe fails.
> 
>   rtw88_8723cs mmc2:0001:1: failed to poll offset=0x6 mask=0x2 value=0x2
>   rtw88_8723cs mmc2:0001:1: mac power on failed
> 
> trans_carddis_to_cardemu_8703b has a single entry, clearing the hardware
> power-down bit. Its sibling trans_carddis_to_cardemu_8723d has six more,
> and 8822b and 8822c carry the same SDIO pair: withdraw the SDIO suspend
> request on local register 0x86 and wait for the interface to leave the
> suspended state, clear the WL suspend bit alongside the power-down bit,
> and take the 12H LDO out of sleep mode. The transition is the reverse of
> trans_cardemu_to_carddis_8703b, which sets 0x23[4] and asks the
> interface to suspend, so with those operations missing neither is ever
> undone.
> 
> The chip then comes back with the WLAN MAC unpowered while the SDIO
> function still enumerates and CMD52 still works, and nothing in the
> sequence wakes it. rtw_mac_pre_system_cfg() does not cover it either: it
> returns early for 8051 wcpu chips, of which this is one.
> 
> It survives a reboot on any board where WL_REG_ON is the only reset the
> host has and the chip's rail is not switchable. On the Denver TAQ-102
> the pwrseq reset line, the BT enable line, the 32.768 kHz clock and
> every switchable PMIC rail were each toggled against a wedged chip and
> none of them cleared it, while the vendor driver recovered it every
> time.
> 
> Take the operations 8723d has and this table lacks. That table's USB-only
> and PCI-only entries are left out: this chip has no such variant.
> 
> Tested on an RTL8723CS over SDIO: recovers a chip left wedged by a
> previous boot, and survives repeated warm reboots and loader-mode flash
> cycles.
> 
> Signed-off-by: Cristian Deluxe <me@cristiandeluxe.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

43f6347e8bbe wifi: rtw88: 8703b: complete the card-disable to card-emulation transition
73e3b1c94c7d wifi: rtw88: 8703b: stop the PCIe DMA write reaching SDIO

---
https://github.com/pkshih/rtw.git

