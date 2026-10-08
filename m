Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFC71A682A;
	Thu,  8 Oct 2026 02:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791427959; cv=none; b=Y5ahD99QmL+SmMElbhK3cAVPUBNcU5ovHXe6CmU3xWXtjKXG1xUT5MiDn/Vpbk16NI4cAB+hNN5h1H2qSLSAm1S45AiLeMrf0H9T0UjqgnvwQM0gX+0MsB7QyoQpt4UAL7jRJ+VHxfNiz/Cwn75SH3TDq5oC5IbrEdQp0gtpZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791427959; c=relaxed/simple;
	bh=8bLtCuWTZTaHbajx38f4l4KtlmbROjlS7K64/gWcLXA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=bRWPBxK8WfoydpKsFE2xuS0f3PtZuqPK1OmINsybNc4MrV2MPytB0zxsfbxc+KB+iRkO25uf2D0Kqa++79Rxr6T4VQDdbrLoECZlFqM7zf9lWvPwyItnFq6OTQS2sCwhhOuMbBFvO5KNXKXZRYJI3POxM73VJ5ZAUkLlDBhKxtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=q1wwg/Ow; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="q1wwg/Ow"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6982qPeX5141467, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791427946; bh=+J/IwGD9e/L7CExHzmjxaYVD/7hdHFA/h5727T/ss+4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=q1wwg/OwTnV85/67R+ZpkKmff7RQVMMPpYEWX2c40gnRcR4AAnkOGv4hMQRAgG4VA
	 QCb4N/0grYCEtnpoyR6Ilx39MQGpn8su5loD3fbrYTE0HmLjICLZo18UFF9ZXMCg5n
	 GsMYgIyQqQfPR4LhZJ8S3jCmYMzg4h80SGmjFyHFlzBePkGOdsRbJ+GqS7ZTtY23OE
	 xOycItS5zBY+q5kMYufiQDaJBO5nfs0JsZa5HGWdd70wFjKpNA/bljFUxus62B6Dgr
	 8xIHZiTUVWbq5vaYXJXRLI91kCwfiVp0E51mSeBHpRFkCAbsJN9ozYiUAQpt7OoxGm
	 vS+7nfuXEncwg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6982qPeX5141467
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 8 Oct 2026 10:52:25 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 10:52:23 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 10:52:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 8 Oct 2026 10:52:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH rtw-next v8 1/7] wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
In-Reply-To: <20261006130701.120460-2-luka.gejak@linux.dev>
References: <20261006130701.120460-1-luka.gejak@linux.dev> <20261006130701.120460-2-luka.gejak@linux.dev>
Message-ID: <8131d809-157d-4a42-9b30-da6c90752cf8@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 8 Oct 2026 10:52:14 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Luka Gejak <luka.gejak@linux.dev> wrote:

> The CCK power detect setter in rtw88xxa.c programs values that are not
> specific to that chip family. The RTL8723B wants the same setter, but
> pulling in the whole rtw88_88xxa module for one helper is not worth it.
> 
> Move it to phy.c as rtw_phy_cck_pd_set(), where the rest of the CCK power
> detect code and the level enum already live. rtw8812a and rtw8821a call
> the core version, so rtw88xxa.c no longer provides it. No logical
> changes have been made at all.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

7 patch(es) applied to rtw-next branch of rtw.git, thanks.

9f596b63010b wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
6501c79b341d wifi: rtw88: 8723b: add the RTL8723B register definitions
a9283c7371a3 wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
6879a85cf4b2 wifi: rtw88: move the shared 8723x definitions to rtw8723x.h
d726c70ce082 wifi: rtw88: 8723b: add the RTL8723B chip driver
269946cba92e wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
b2d251aa7f16 wifi: rtw88: 8723bs: enable building the RTL8723BS driver

---
https://github.com/pkshih/rtw.git

