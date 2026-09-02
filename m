Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF21314D1A;
	Wed,  2 Sep 2026 03:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788318701; cv=none; b=uXFxxRfpm4l7QxShgBbqoUrZWj0hbLdJG417fJBlo7yoeFUtuBv365GypIIl9zwpDTO7YNpM0dw1Z7JfdEh4jMyj0x4yzGMUjAsOaibR62ww967V+riMzvf60hCij/VF+bYDlU/ZVvRbxW14kOZK0XOAkEWZb0xGpbOFFKg6bBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788318701; c=relaxed/simple;
	bh=jtSkEWaiv+81DPIQGS9p28gI244T5O6QzjH2iSlwgi0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=WZrQkXAjFzRwUZV27O8Qc9nYPuP9mrR2yxdq9v3AVkwERl2ruLCZ/7E3SvCg978l8Hv3IBRxK5WJjpes9WJdu2CoXsj0nvTjyV7l1weZxzGCD6ZW60vjX8pkJH/MAzba6llRo6M+CFhtAzNJZPCAVlCWNfgoN+OZLhELUe8JHrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uYkWm7+H; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uYkWm7+H"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6823BWfI42274139, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788318693; bh=aiEng/mnt6rQzAUZpwgdHJvsxotzEHAmGtn/B25uVrY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=uYkWm7+HEbOYGenzQrp06kx3lBmZDnl0F57PXPoAdDIMM0eveg8Leo5jdaPSJ+8Be
	 H7uSjrAliu3roovYNpxGHEQahmwG5eV95I3erZJwL3rkcM29Ta2b16A+wtg7aRtHyG
	 IC73rHkLC8gdz6rEL/dEH/awGCg5CHdRud53WxyAT5GGv4tucNg50uVJeWJ2iDw+oN
	 VgGnT8FVtp99UeJuPr6FbWUSZToGe/z8lFUOiTsgALBjkh4nNbFiNzGufx0lRqsI0e
	 LVizlVEWBgKgPrZqFT8yauroaIdCbyj1n6yIrGdzJCkvcoVwliVPhPNjIbPY+1312l
	 ytSEsWMEn/BAg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6823BWfI42274139
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 11:11:33 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:11:33 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 11:11:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rahul Kumar Rai <learn.rahul.rai@gmail.com>, Ping-Ke Shih
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Rahul
 Kumar Rai <learn.rahul.rai@gmail.com>
Subject: Re: [PATCH] wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506IH
In-Reply-To: <20260823-fa506ih-rtw88-quirk-v1-1-ef0984d59e72@gmail.com>
References: <20260823-fa506ih-rtw88-quirk-v1-1-ef0984d59e72@gmail.com>
Message-ID: <5f1c2935-2e27-4ab0-ab9f-9a7de15c8718@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 11:11:28 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rahul Kumar Rai <learn.rahul.rai@gmail.com> wrote:

> From: Rahul Kumar Rai <learn.rahul.rai@gmail.com>
> 
> The RTL8822CE on the ASUS TUF Gaming A15 FA506IH fails to return from
> PCIe low-power states across system suspend. The device is inaccessible
> on the way back to D0, so the MAC power-on sequence and the firmware
> handshake that follow it fail, and the driver gives up. Wi-Fi stays
> unavailable until the machine is powered off completely:
> 
>   rtw88_8822ce 0000:03:00.0: Unable to change power state from D3cold to D0, device inaccessible
>   rtw88_8822ce 0000:03:00.0: failed to poll offset=0x5 mask=0x2 value=0x0
>   rtw88_8822ce 0000:03:00.0: mac power on failed
>   rtw88_8822ce 0000:03:00.0: probe with driver rtw88_8822ce failed with error -114
> 
> Reads of the ASPM link-configuration register over DBI also time out
> around the same transitions.
> 
> This is not a one-off. It has been recurring on this machine for a long
> time. The kernel logs still on disk begin at 2026-07-20 and already
> contain six failed D-state transitions and three probe failures of this
> kind, and the problem was present well before that window.
> 
> This is the same platform ASPM inter-operability problem already handled
> for other machines through rtw_pci_quirks[], including the closely
> related ASUS TUF Gaming A15 FA506II. The FA506IH reports a different DMI
> board name, so that entry does not match. Disabling PCI ASPM and deep
> power save stops the failure on this model as well.
> 
>   DMI_SYS_VENDOR = ASUSTeK COMPUTER INC.
>   DMI_BOARD_NAME = FA506IH
> 
> Signed-off-by: Rahul Kumar Rai <learn.rahul.rai@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

c5a8c4936dc5 wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506IH

---
https://github.com/pkshih/rtw.git

