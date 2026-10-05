Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A963C32B12C;
	Mon,  5 Oct 2026 06:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791180652; cv=none; b=qe0BmHBa3FazC+JkVCGDa0dslkDqvjDQQ/OWTlxw7Y9Cwa2TR3l7Cf0aUpbMtKPbVV6bVgpEDVzKlLzE73WpBBToEifLzLH3LuaaXgWhsqiKOT4qBE1NgFvo2FtqjUdeyd5p/6d3dmhku0jYFyTlwmVmcxpbEKDGbaw/Co5RYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791180652; c=relaxed/simple;
	bh=YxSM/2ngrZYl50VyWS8DoXjLSZDekQ/Nu+JvoMabWto=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LrSjb3IDzk0VTeilVEnXsvT+MbF1WDMSOEcLst/jaqNGm+07g+BrmM9bLP021QkC5Y1IYy3B3o1ybFYHk6XJLDcsduN9jQkoyOtQ85Rm0TiUuiAbW2ZFvgfe7hGmPq8GBgMsXhVCA1XqetWwBR0RLVyi1YEXSk2L2FjhzcKtriY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=p1ji+fHV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="p1ji+fHV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6956AfWuA1706949, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791180642; bh=YxSM/2ngrZYl50VyWS8DoXjLSZDekQ/Nu+JvoMabWto=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=p1ji+fHV/VFXRCkYh9JPMiFfFJAv9TqEAHQkiv6hl6kQaNEZX9jb/KtEL157PstBb
	 JP+DXM6c1xlShFKNL1V87HjWDC3rKIk+ZhwGM/wJOTKkvdG/68HAfyF3J8WKvq4WVb
	 zpAmmqU1b9ELKc2AmUABczIpZqBmmf6XU3u08C28xa88XRuoPInBGw/yYjfxuIoUwl
	 b2SYM1P5kTDB5nrl3O0NtQK7y/BIiHoeLaCd67vSys9ixDTjR9+rYA0XlThyC5dDyv
	 tkec9zkzh352u7K3hAwBVxCmGT6uTDJ+deRQ4CgE4CzUvam0uvzWc/Se5TfdRK7T2S
	 PysfZij7bB+Tg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6956AfWuA1706949
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 14:10:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 14:10:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 14:10:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 6/6] wifi: rtw88: 8723bs: enable building the
 RTL8723BS driver
Thread-Topic: [PATCH rtw-next v7 6/6] wifi: rtw88: 8723bs: enable building the
 RTL8723BS driver
Thread-Index: AQHdUkEfsqFXDH38PEe7B+ss4Ql3H7bue53g
Date: Mon, 5 Oct 2026 06:10:41 +0000
Message-ID: <c5d04ef278754b6a995929a92321a60b@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-7-luka.gejak@linux.dev>
In-Reply-To: <20261002073845.31486-7-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> Now that the chip support, firmware interface, coexistence, power
> management and the SDIO transfer and association paths are all in place,
> add the Kconfig symbols and Makefile rules that build the RTL8723B chip
> module and the RTL8723BS SDIO front end.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Please also carry reviewed-by of Bitterblue to next version.=20


