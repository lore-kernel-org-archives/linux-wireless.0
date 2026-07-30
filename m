Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C83EDAC9;
	Thu, 30 Jul 2026 09:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403074; cv=none; b=N6MqpWEf1Ri6OfN/NByGBOjPFriqLxvj7GPtsFw67mhaOFikAoFNKnvI4NFRFfiWG0xVRoKXMBEp2oqZl4MX3JvfsL/FIVMa3tEH0ufX7XzbKd+5RkF4TtsIwTwqKgGIly2/r6F7BrMix5GjhtG4WPoqfyiyhYqiA8YMXdZCaUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403074; c=relaxed/simple;
	bh=eAH0XsPFyWHBxIkhF7dj2GITd/pTe/YgTsJDxRUdS9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dVy96EjcuiNxS5R29sb/pamfhJnEP81DpBWidXhY6mLgmnax/XoR3XbmrNvDjw2mqz2X8Df9ZS7leRdtD50pln5jS4cBqRAcCIpvXV6MuvZ1+XGStZRC2Ff8fj2neWV23ISrdGvMc46/Hb0p96G1LJHBt3+PuanI8DEsm0nhiqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XGYn9Zf6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XGYn9Zf6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U9HfuU61073629, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785403061; bh=eAH0XsPFyWHBxIkhF7dj2GITd/pTe/YgTsJDxRUdS9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=XGYn9Zf6PvFtvEj7/Rq3LL9f67UkrwLeJbvgKqylEW2/ZSGtwemGQAf0Wig2A2Ed7
	 Z8uyewCNSHiLsasTBSrCALwaRWu0nJML/X4EvOHhQ7/8pTLU/nDkyiaH70UwTZ/H50
	 /995um+Eok+P3qsYRv8vkCQVJdj/ow63dXauY01h+FhV/IpXK+IL8A0fVjjDLTGfke
	 UmM6ZBaHSdTM0KCbg0n5gczRrX20KjmQqk687bluqArLza5CqTlOOOvvcO0iiLHAq6
	 1t3INE/gEM1yr1iBXjZmzVjkoGl+3BfEZTiPj5ukT7jplIho+Lw2G6f5DG57cn0OJA
	 OdJLSzKL6wezA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U9HfuU61073629
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 Jul 2026 17:17:41 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 17:17:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 17:17:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 30 Jul 2026 17:17:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Topic: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and
 SDIO helper
Thread-Index: AQHdHEb43bJAs6El90WByPxHzpdzD7aA9VHggAQ6pICAAJ8VQA==
Date: Thu, 30 Jul 2026 09:17:41 +0000
Message-ID: <6c2d5972971f48548a58dc3fba890793@realtek.com>
References: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
 <20260730074504.19725-1-luka.gejak@linux.dev>
In-Reply-To: <20260730074504.19725-1-luka.gejak@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> it would be four callbacks (free page check, page
> accounting, output queue wait, transfer sizing) and I did not want to
> introduce that structure without asking first.

If these are called from sdio.c, just check chip ID in sdio.c.=20
If they are used by common flow like coex.c, I prefer to implement them=20
by chip_ops.=20

Ping-ke

