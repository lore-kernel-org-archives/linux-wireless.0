Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D166F3976A4;
	Tue,  8 Sep 2026 06:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788849306; cv=none; b=GsndjhQZ6nY9BePtkvt//6vGoliDAJfAW1oV5gOhFlLlGOUpxnWLcLk0p6WaYa5JIsD2ovLgSjI0goH7LE//nGHiJmopS4VcPZ77uYlwuAQ/oKNJxpWGG8+p3q5tXpSDzAX5cihxplh7u2wSA3WXqyB1XW090FpToPXUfiAAvL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788849306; c=relaxed/simple;
	bh=Xra3qzlJpyBwSbp+URGnljUgK02JVUwtsK2GLYqhw10=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=pp2hcehc6NtIKohf1/cB5KS8tUUdx+i221+++NKErF0C/q1h8vXL9EsfjaddwHF2zPZAxIg4XU0ceE09IT+xSXx8UxKCaWREqWFKoe3dlZGQZHHptmhpSRFJCAHYmmStkGQWih+DsNmgsyZud3lyD/ESF2/QRXYx7BmfB8dtRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Bm8//+24; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Bm8//+24"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6886Z08i83585568, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788849300; bh=kb+8/1/Ba+B4bBT+lG4Qf2ZRPcMhukD9wMWMBgjKUSg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Bm8//+24/Iw6XY94ubJ24ZCfDk9wOvfWZCooi7l+dez2iI2VVU2rM0HP0lghSURHC
	 YvvbrqCFg7CW2eP1fP4kzt0LkDkSE756qp3eKiy+ZEY7sD7tF8vCz4QnxXy+VD98ai
	 M0b+sUrKgjwXkiD0gOysK8kiUGYbhJkDY0zO4RpiABr80dpn+QtqTgW4TYu4qawyUe
	 jTOmiB3OWAp2BiNXKclFbSg6MQSNh20pOpKcHC0Y9t7xCU1w8YujEBue94tsT/RHuv
	 EKU8iZOpik68+Q7u7Nlzc+ZoH7TTHiSsdk6Itbi/nasLhrrP3CZHVXduoh2Ctv29oZ
	 Lu7iRbL5y/Efw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6886Z08i83585568
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 8 Sep 2026 14:35:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 14:34:59 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 14:34:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>, Ping-Ke Shih
	<pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Maxim
 Skokov <skokovmaksimevg@gmail.com>
Subject: Re: [PATCH] wifi: rtw89: fix typos in comments, debug messages and struct field
In-Reply-To: <20260904222548.19732-1-skokovmaksimevg@gmail.com>
References: <20260904222548.19732-1-skokovmaksimevg@gmail.com>
Message-ID: <5b05f8bf-2634-4683-9858-1116a28bef99@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 8 Sep 2026 14:34:54 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Maxim Skokov <skokovmaksimevg@gmail.com> wrote:

> Correct several misspellings found by codespell:
> 
>   moniter   -> monitor     (struct rtw89_btc_wl_role_info_bpos field)
>   serach    -> search      (comment)
>   Unsupport -> Unsupported (error message)
>   nofity    -> notify      (comment)
>   updat     -> update      (debug message)
>   lagacy    -> legacy      (comment)
> 
> The renamed struct field has no users, so no further changes are
> needed. No functional changes.
> 
> Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

f71dd599a981 wifi: rtw89: fix typos in comments, debug messages and struct field

---
https://github.com/pkshih/rtw.git

