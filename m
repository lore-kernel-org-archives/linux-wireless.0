Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAFC274641;
	Mon,  5 Oct 2026 03:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791172696; cv=none; b=eriOoqG1fuzB9sRZzG/H+JcECtFsKJQZSCVDa1Bxclr0lL/d2ISaCXZsYs1viJ86cKyuB09HCKseZlelK8Xj/ejSAPHOCl9dr6OtSJJGoMi0puuoOkrRxMzZlmMYRUgcnRadV/sYbvwSFABgRPLcqxjb5NmdVVlpeJvGq2ZEJDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791172696; c=relaxed/simple;
	bh=RDbvOO/Z9e0tNUlYsfRHBQj/leHP8tAvHDfmMWvf/KE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WGFzc0SkhizUvFXJekEhJjdKi4x+i3Imjk6cme3w5UfzYoeuZe/+ePavs9shGvqjCfRRRTSqtgLPUSPPSI+h1O1g+ANOvh6dmAqMOFLe1nRrSNWn6rcufGD6Eef08sOb7v1mzvjrI4SwSX5ff8tAyiizb3h8dN+e0ILgIquPS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=P39oTow+; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="P39oTow+"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6953w5ZA11640180, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791172685; bh=RDbvOO/Z9e0tNUlYsfRHBQj/leHP8tAvHDfmMWvf/KE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=P39oTow+E431x5dGUJw2jBsqeFM5N96asA5wVrUZwAnWYRhefjiCOu7RW+vQBnn4G
	 co0Y5QZ4ZFsSmRDKeGEbZlGlu+pW19OSwHWnBRGeCnPihlQrLtO702BdXbIRRgdNkq
	 Xe/PVWza2csLdz3r+R2X9domoe7cy2ojFOkm/Y4ObPVFHgHuiUkWzBgR5XeNyyzEc5
	 mrD8FriJhjWpeTkirmTuv7QaDJho1YWZ1vj+d1eDBsUU+WfIYEKYihlYA/st63u5UH
	 o9kj4/kfxuCPC2Ha8eGp5EwWDdxWLMpZIjwvjA22oBCFGvhR35F8SlYYknbjwEMTaJ
	 wPN0nP4UbLtyw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6953w5ZA11640180
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 11:58:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 11:58:06 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 11:58:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 3/6] wifi: rtw88: 8723b: add the RTL8723B BB,
 RF and AGC tables
Thread-Topic: [PATCH rtw-next v7 3/6] wifi: rtw88: 8723b: add the RTL8723B BB,
 RF and AGC tables
Thread-Index: AQHdUkEcc/TxDIRkHUWrNtDFPiUrdrbuVtVQ
Date: Mon, 5 Oct 2026 03:58:05 +0000
Message-ID: <04a51a2d497d43958fe26fc195b56cbe@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-4-luka.gejak@linux.dev>
In-Reply-To: <20261002073845.31486-4-luka.gejak@linux.dev>
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
> Add the MAC register table and the baseband, RF and AGC parameter tables
> for the RTL8723B, and the transmit power limit and power by rate tables,
> in the layout the shared rtw88 phy code expects.
>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



