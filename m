Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170A12E3FE
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 03:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788319714; cv=none; b=eCLskbSlY3nov8BE1/XmXflhkhLGnIEMpZox7ziw6fpXheoOr4q7/n/YLV5VvFWmu1jsGRhdPmYnso2pTE3AOKyjwDRY4+zGJy6758q42N3OkBpA04uwMdKA4X7wTTUfeSJlezSMyePYZQ9paCSXxVewgfrYbIFH5ydc6QCDtOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788319714; c=relaxed/simple;
	bh=FZchWikEGV0n5/7RLeZJnDMgcNMN2BidrF66oJE29J4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=IJPahGjWqX4Y1tv7n8cTIbITlFvZ/rWO5k86eJWAEuUTPZ9/rXA4xd58yzoc9KZ1+vcgb08HAX3BqdXwA/rreDOuTy2CEN5lRZCqN30wuruxIipc0se0+Fs/2sLwtW0EDwVoZqc3DRDJaxw+/Ibgb1GiwLLH3E4lAX4usqCY2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=atuLIw4k; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="atuLIw4k"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6823SFFT02279993, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788319695; bh=VJOQYwoVdUAdD935cBVw8XxDD9RZK0Y2JtxjvakLEVc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=atuLIw4kCHNsXt+arNLO0i/tN/RN6MWTAU7iysdGLxYCPbwcubbOe4DJb+JMYX2A7
	 KRLXXLDnFpa9xI85eEBi0W/YuEbOyimOgOALu4y12sfufOdvrKLb3mouMQLUPVxnRX
	 Y9IK2HjYbVS+maoTgUj2D3wViCqbMGJYg0Qto8ZqEu6CGEJzN7TrfUntSIqhgigR3a
	 +CpHa9HlkxEg3I0pfzyCMOqWmCKizAF2ISZPD+HlEz5bHe8YfA6J8YqNftWt+QEqYt
	 4Qy6R4suoiVwfkT2sI7sMt7v8hvnSmGtE14/seQ2xp7DlvXb7q+gE2Kuy8R6/bDPun
	 l2Mgp/1BJ4U/A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6823SFFT02279993
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 11:28:15 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:28:15 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:28:15 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 11:28:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Branislav Klocok <branislav.klocok@orava.sk>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Branislav Klocok
	<branislav.klocok@orava.sk>
Subject: Re: [PATCH] wifi: rtw88: add quirks to disable PCI ASPM and deep LPS for Dell Vostro 15 3530
In-Reply-To: <20260823154228.129848-1-branislav.klocok@orava.sk>
References: <20260823154228.129848-1-branislav.klocok@orava.sk>
Message-ID: <0364a75d-8a1f-49c9-b3e7-7081616783e2@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 2 Sep 2026 11:28:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Branislav Klocok <branislav.klocok@orava.sk> wrote:

> On a Dell Vostro 15 3530 with RTL8821CE [10ec:c821] the driver floods the
> kernel log with
> 
>   rtw88_8821ce 0000:03:00.0: failed to send h2c command
> 
> at roughly 220 messages per minute while the interface is associated. On
> this machine that amounted to 143704 of 167707 journal lines in a single
> day, or 86 percent of everything logged. The association also dropped
> its DHCP lease from time to time.
> 
> Disabling PCI ASPM and deep LPS makes the messages disappear entirely.
> Measured over one continuous hour with the card as the only route out
> and 979 MB received / 341 MB transmitted: zero occurrences, against
> roughly 13000 per hour before the change. The only rtw88 lines left in
> the log for the whole boot are the interface rename, the firmware
> version and "enabling device".
> 
> The measurement was taken with the rtw88_pci.disable_aspm=1 and
> rtw88_core.disable_lps_deep=1 module parameters, which set the same two
> variables that rtw_pci_disable_caps() sets for a quirk entry, so the
> result carries over unchanged.
> 
> DMI on this machine:
> 
>   sys_vendor:   Dell Inc.
>   product_name: Vostro 15 3530
>   product_sku:  0C32
>   board_name:   0RRJRM
>   BIOS:         1.3.0
> 
> Signed-off-by: Branislav Klocok <branislav.klocok@orava.sk>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

ab468ac0156f wifi: rtw88: add quirks to disable PCI ASPM and deep LPS for Dell Vostro 15 3530

---
https://github.com/pkshih/rtw.git

