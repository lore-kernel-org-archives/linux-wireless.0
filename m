Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47F2AE78;
	Tue,  8 Sep 2026 02:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788835852; cv=none; b=Z2SxJ9IIMeTuMSo+J06zMSfzRcFByK9q+0GDOx98jjmOXu0gpLR6068d/In4hIRXF/bk5z7LgpqiP9UDtDe01Tz9hhyqulGh64l/ZyZkkdHu6V5xJJtse0X1/OfcjRE+tv4H32rq5iGbQOwZjECh4CGYEd7BfkbcI2aMSjniY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788835852; c=relaxed/simple;
	bh=/GafB/voq2TTbeWohwTqd7l0hbwhqKA0yhakv4V1wJo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=DA48E+hiEfGmQmV31ePoeB243AUiKaoHu2pKFwcjS3nQrkNN0jWS3f4/zl+OzQnyzvmE+HOWS0NbHTNxOZ+mmxKHq0vA65/6TL31Xs2QFnj1cNuIrkVZpUekuqgPbWT9dXe1JVJoziaI2+z772jKVYgdSYTHb3kC2gTv6JJsQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=owm50j/8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="owm50j/8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6882odvH73423890, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788835840; bh=YGvH//1vvKBwWqkBWAHhKZOqP7GKXQYkA5ZWAQRRqtM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=owm50j/8a7TZH1jN3R1FuwigHXNFnO0oxjyFuYTR7H7HCOINwvWvsd4T7A+6/UvYF
	 UGUsW1Q9fXaqxriaZYXC07rrsbjJxw22+xMOFgUmAL6MvfSjMZ+PG3QW/JBDj4o5+6
	 KGuom/qFe3PH2bSDN7JadX2xPRvfC8XQfPN34fm0KyS3/3GDaBR+88yKRj7AcF/VIp
	 y6gpIZbC9gQ/JCeEcD+oJKkzDYYYcIl0oRFk7SmPFYvorhSF3hPU1/goq0SW97d4PU
	 /gWTdvBfcLNXHj7c9/5R427JWnxyHpgifD/+I/bTWrsN+yheV7zX0az+ispQGlLC1Z
	 WR67n1jBll/Eg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6882odvH73423890
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 8 Sep 2026 10:50:40 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 10:50:39 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 10:50:39 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 10:50:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>, <linux-wireless@vger.kernel.org>
CC: <pkshih@realtek.com>, <linux-kernel@vger.kernel.org>, YuChia-Kan
	<raspberrykan@stu.hqu.edu.cn>
Subject: Re: [PATCH v3] wifi: rtw88: use firmware MAC address as fallback
In-Reply-To: <20260902031408.4155609-1-raspberrykan@stu.hqu.edu.cn>
References: <20260902024622.4149279-1-raspberrykan@stu.hqu.edu.cn> <20260902031408.4155609-1-raspberrykan@stu.hqu.edu.cn>
Message-ID: <d2c88589-09f7-41a5-ae50-c8ea64509d94@RTKEXHMBS04.realtek.com.tw>
Date: Tue, 8 Sep 2026 10:50:34 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

YuChia-Kan <raspberrykan@stu.hqu.edu.cn> wrote:

> Some devices provide the Wi-Fi MAC address through firmware instead of
> storing a valid address in the Wi-Fi chip efuse.
> 
> This is the case on the Xiaomi Mi Box 4, which uses an Amlogic S905L
> SoC and an RTL8723DS Wi-Fi chip. The Wi-Fi MAC address is stored in the
> S905L efuse rather than the RTL8723DS efuse and is provided to the
> device through firmware.
> 
> Try to read the MAC address from firmware before falling back to a
> randomly generated address.
> 
> Signed-off-by: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

e1c844ef72c0 wifi: rtw88: use firmware MAC address as fallback

---
https://github.com/pkshih/rtw.git

