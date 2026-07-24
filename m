Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6F618C2C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 03:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784862186; cv=none; b=MDfVq5UP2q9xkov6C0++kKG4+ouuvOnVbqiu0fV7JzMXAZwN8/nJ2A11Xq6DVf2CwFCzQYfXmR8Nly/9j2d8BHhQDEzxbzO68CQAisGXnFel54IMOaSGz9IXjsSKRtzGgpD7/rdHyyqKHZPjcWtGR4PTAZ9lYvafF4cP5FnSj8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784862186; c=relaxed/simple;
	bh=wm0v6HUXV1B2sBzZvoctPwXrWN6J+sZdF1teNkL/fHI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=ZiyraP8qIDXkTLx8qEZl0RYXxMRNiOkm7q9GjS3nY17heO0BccLG2mZeEknseGQ92HPR+V61ERjDYQXR3gaCPQxr/Iqny4l7psMbAxQQJ/IqzA198fdD8/58Ek5KpwlW1Qj4QwXTIs4rlK6Eh7TDX0qkieeB1W4GmR/SmNFuQrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hHmNKOIj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hHmNKOIj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O332640939163, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784862182; bh=sOBevveL3LUTMCmeyBZytb4XMn47P1n/gfnOx6mRIJ0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=hHmNKOIjkZ8oyEGE4vpy7uDLiwFqdivxP6W8dlis/xkX8+rnYx8AJbogWIIHrGNjR
	 pcO6TWH6eGRrgL4rTfgw2YxmmMezzF7lYcp/Q3nVLaYaL84WroLGQ3VKEfbmcr6HYB
	 FmFLm1c8WpR6zzbk0PxYhCknUkDwhZDVc0awQUQR5r95pbAExcwFvCkvDSdMxeAnAG
	 7qKwRpzeKPlqQhuq+yFsiHKHxx3F4ejgiPXf3icvAWQ28oFgCOp9wKTbZ2SlmjN8Ae
	 Ppb21VlFYhHWkoQWLyZ3TXdGoOCXcKB1BjUb5ApdY0CD0+MHR+tXtM9BJKT9V0rpAf
	 GbX50qwdVdPKA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O332640939163
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 11:03:02 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 11:03:02 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 11:03:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: Re: [PATCH rtw-next 1/9] wifi: rtw89: add LED support to reflect the wireless association status
In-Reply-To: <20260717061910.54466-2-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com> <20260717061910.54466-2-pkshih@realtek.com>
Message-ID: <e0f4a441-aa45-4dd3-a99c-5e56875c3a1e@RTKEXHMBS05.realtek.com.tw>
Date: Fri, 24 Jul 2026 11:03:01 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Johnson Tsai <wenjie.tsai@realtek.com>
> 
> Add a new RTW89_LEDS Kconfig option, along with LED structures to describe
> flexible GPIO mappings for chip common LED definition. Core LED lifecycle
> and registration logic default to the mac80211 association trigger, and
> chips are wired up as the first user with a single-GPIO monochrome LED.
> 
> Usage:
> - Auto-triggered (default):
>   ON when connected, OFF when disconnected
> - Manual override:
>     echo <1|0> > /sys/class/leds/rtw89-phyX/brightness
> 
> Signed-off-by: Johnson Tsai <wenjie.tsai@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

9 patch(es) applied to rtw-next branch of rtw.git, thanks.

d910631ff352 wifi: rtw89: add LED support to reflect the wireless association status
721d90c8509a wifi: rtw89: add multicolor LED support for RTL8852CU valve board
355626a2c232 wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band
e92d5b02b456 wifi: rtw89: rfk: update TXIQK H2C command format to v1
89833570775a wifi: rtw89: 8922d: bypass TXIQK when scan
ce18a0cbc39b wifi: rtw89: wow: extend timeout unit to avoid SER false alarm
238bc3141cde wifi: rtw89: pci: set PCIe maximum TS1 for RTL8922DE
e738d2ac80c9 wifi: rtw89: 8922d: reduce IO in power-on function
b3dc0a37fd3a wifi: rtw89: phy: set CFR to manual mode for some 2GHz channels

---
https://github.com/pkshih/rtw.git

