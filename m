Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593482C11CF
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 01:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645848; cv=none; b=UvCUIK3fzn2SMs9dQ3qDxulLWsf6jl+QYub58NPuYZcyiSCBgW+1hAejx4fIKq0uMpTF0KeV/OcUrfFz4NqQQr7VX4nOHrdr57T3Ni3S22EZBudCD3Ib/Ae1tKPWAjfFLka0F2nht7RG7f0Wo1RxAFFzzWhvDSvLe0imUgxW+jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645848; c=relaxed/simple;
	bh=VfRAxTtJktdrmEJgZpXEVMSJShcDgAoVKTw0ZDSQU2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Yz/aw1i/GdC0lzmVbrFvE8/6jvkxa3cIcCpw852tJAW10o2XFySCq5m/loD/cOSL0XwZo9hr5OCNmLMLTw/y1QBUjFx1V06hiBfRw8KQrMOnvthHwFyfS7HUnCP14Gb2V3c4FEmIGeaI8QakksI4ZVF0fFnpKNMfuxgJ5pFjr4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CU6JPVH1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CU6JPVH1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68T1bNYS1865884, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790645843; bh=VfRAxTtJktdrmEJgZpXEVMSJShcDgAoVKTw0ZDSQU2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=CU6JPVH1W0b86S3423pdCbVPY2/HPxEwQYxHrPXUEONv89FG/CEcqbDgca8ukAGDA
	 vwMZOyN/0a7UEH/7fgdRNxye9Gk819UPA322kXj64uf4GE+/4llFQ2y02QGpymzu0p
	 3Qx3YZ1kd9v0MwYhuHu056FZQuO7hmB+mC5OFgEomPcxPWN1OJoAg0G6zDb6898a+E
	 Zo1iLFkGdoO0APYZ5LYS9ZIoBJgDt3B1P+Cv07KVqgnemFwSfdT4MtDOK3tblzreoq
	 hrs+Y3dQE5MXCnV1A21N7YTmw7Hqk2hifDbTxAtET2ogO5tbpuv24+6u27tqrOtrYJ
	 CAvkaVWLsfy7A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68T1bNYS1865884
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 29 Sep 2026 09:37:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 29 Sep 2026 09:37:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 29 Sep 2026 09:37:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Josef Schlehofer <pepe.schlehofer@gmail.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: TX report with long timeout for
 non-PCIE devices
Thread-Topic: [PATCH rtw-next] wifi: rtw88: TX report with long timeout for
 non-PCIE devices
Thread-Index: AQHdS75bX4VJ1eQQSEiSY1AujWaKO7bky7+Q
Date: Tue, 29 Sep 2026 01:37:22 +0000
Message-ID: <7f8b94f5693d47dc9271774d7f83f91f@realtek.com>
References: <20260924004637.9958-1-pkshih@realtek.com>
In-Reply-To: <20260924004637.9958-1-pkshih@realtek.com>
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

Ping-Ke Shih <pkshih@realtek.com> wrote:
>=20
> Many USB and SDIO devices can't report TX status within 500 ms, and
> extending to 2500 ms as tested USB/SDIO devices can fix the problem [1].
> To avoid adding chip ID one by one, and this change looks harmless.
> Keep PCIE using short timeout, and others use long timeout.
>=20
> [1] https://lore.kernel.org/linux-wireless/20260921165343.8131-1-pepe.sch=
lehofer@gmail.com/
>=20
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Pick Tested-by from [2].

Tested-by: Josef Schlehofer <pepe.schlehofer@gmail.com>

and Cc stable by request. However, it'd be conflict with previous commits.
If so, I'll send a patch after this patch becomes mainland.=20

Cc: stable@vger.kernel.org

[2] https://lore.kernel.org/linux-wireless/91FCAEB4-16A4-411A-A436-0803F89F=
3B7D@gmail.com/


