Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753363806D0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785379997; cv=none; b=Dj0Rt/+/QxcQYP4ZHXFDUrsMQ0OGsGm/rIHMhj8I/kTQFjBHGkDEczodcEWghBlIDgzuhTTGXOHK21mxWycJeavtnH8wXF4gC1+XDcBck7cjF6hbM8wNDUNwf7Fbp/9Yc91HTBlTELGdCVbPKs6Q2jsPMRJvjO1DCACzk7aOGNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785379997; c=relaxed/simple;
	bh=8ek6a5L2ruYZlBtNC/mKT9PeRoaj47OWF+CJYyEkVNA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=oAb/KYY2yZI7LnK7RBdGaNAOlvK6bn4h/9+w9L58i6hrybN+ejzz9Acvdh1045K//KywMkudpo5POnm+1DxpqwrRj45RrWbGx4Nk8xqHisPXGusxWRaqq/y9gjqI5aWcYyx9Y+h4X35QOl1NVickGCuk92IGuhz9UHZylbiBOXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jG576UhY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jG576UhY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U2r8YI1911671, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785379989; bh=weR2FnaHIRG2fVmaJpBHroRhsGIF/QmiBrLZZGpgQSI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=jG576UhYPtj7alBawFGYDPxHZ2tUW6b0dSaY1AnUy9RGk8U/tb0hV2Av81MdyjfTT
	 lyWHc6lB8Em/s3TEdhIaUuwup4QPa2sb6TwQyxRAOI+q9AfGwkBFjNnXe8Tb7027a8
	 sTfIN1yNBQdVcduPEAtsVcDUZt8d2LOXxNTnadn6GQwfxx/C4FXZ2u9k274oll9cJk
	 Ms0zwnoUFGc+NAGTpV9ZuHYMKqBeXX1ZTbdRFyTwugXgnne7LPwF1/cNC1f3aONEvc
	 FoeCOwkoVZ6b25UpCeR2KvlGHrlSXcOKfC0D63iflnkmAmHLVnZ96v24Znzzm8amVD
	 vHq6JzkEd+brg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U2r8YI1911671
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 10:53:08 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 10:53:08 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 10:53:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next 01/14] wifi: rtw89: coex: Add chip initial info version 11 for RTL8922A/D
In-Reply-To: <20260724135640.3195044-2-pkshih@realtek.com>
References: <20260724135640.3195044-1-pkshih@realtek.com> <20260724135640.3195044-2-pkshih@realtek.com>
Message-ID: <b1cffd78-04bd-4c94-a965-0ba599bcf71c@RTKEXHMBS03.realtek.com.tw>
Date: Thu, 30 Jul 2026 10:53:08 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ching-Te Ku <ku920601@realtek.com>
> 
> The version 11 init info add current RF path control information.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

14 patch(es) applied to rtw-next branch of rtw.git, thanks.

6f24d22a31af wifi: rtw89: coex: Add chip initial info version 11 for RTL8922A/D
04852fcad5a9 wifi: rtw89: coex: Add Wi-Fi MLO info version 2 H2C command
eb70edecee46 wifi: rtw89: coex: Add firmware 0.35.111.X support for RTL8922A/D
86f763e37248 wifi: rtw89: coex: Rearrange _ntfy_role_info info
a76501e1d148 wifi: rtw89: coex: Separate _ntfy_role_info into two function
b01bfd2fc752 wifi: rtw89: coex: Decrease Wi-Fi special packet protect time
5c90259b9748 wifi: rtw89: coex: complete GPIO debug configuration handler
528e5e1d7825 wifi: rtw89: coex: Refine RF calibration notify flow
b23378a56454 wifi: rtw89: coex: Fix log dump format with proper newline
068daf7086fc wifi: rtw89: coex: Add BTC report version 8 support for BT sub-reports
2951ecd83cc4 wifi: rtw89: coex: Add dual Bluetooth debug info dump
ffb7d6a1c62f wifi: rtw89: coex: Fix TDMA v8 handling to unblock BTC report parsing
4406b550ae2d wifi: rtw89: coex: Fix H2C command redundant send & version fall through
6a43bbee78a5 wifi: rtw89: coex: Handle Bluetooth LE-Audio related coexistence feature

---
https://github.com/pkshih/rtw.git

