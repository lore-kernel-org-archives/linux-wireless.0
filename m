Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77E3E2AB6;
	Mon,  7 Sep 2026 02:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749051; cv=none; b=NfIO7T1FBYrxkCCG0TLwT+thUUyZRlQaYRk6HjNvR5IkatYRTMuK0SvVuJj0XBqzu5sgg0Rvx1qXgElG1Q4VDWSevq/7BlTcQQIkdmHdDOmV0StUbJQ4UsCSvPlZbKTfj95kqNfEA3u2vjpe5SERTDvj8Ca8Yl6R4HiW4bWijGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749051; c=relaxed/simple;
	bh=BAApXtExzKfi50T/qCqARuvuEZHhZD5nEPIPW0mtUgA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NtbXi5JsswoY1xIe5n9T5UmudNu8l6GsO91M19YXmKPgB/mesZEzjgCnclkCj+kVYhJeSJbRJCYaTWl0YSq7Sax4D6u1VCAZSe1MTmNShrp7ln3acU1ffyPRmSPfFFHt46w20l8fmNdcadbVvz2uI8CRUiPBxn3x7kBQnXHmY9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BbKC8tnH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BbKC8tnH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6872ht7S32417533, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788749035; bh=BAApXtExzKfi50T/qCqARuvuEZHhZD5nEPIPW0mtUgA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=BbKC8tnHrGK+nvq4lvZm09SgFwom6bIpcsbK8b73Ug19G+DmP+Jz0g4XZz6YB0/Id
	 KDtxVBihUe1bcsbBg50ButMV0cA3hXgO7t767OndeWzdzAtcRsxBG0ccE+tFVSVhmG
	 yPBCx/RfkXffGpdSIj2uzivpV4XXEfxu+ZLsFbJ9vCm1EltztvslBKB8uD5bCicBtS
	 cbtKNfS6Etm0YK+/He2+fZGhwRDcXRLWHhqDFzi1LRHRsNqjFnAijh9/VrfLqwo2WU
	 CVeZPh8rskO9i9lAT8KCSwVgERl+98ovU4WInvzhezvyuQ8eKmqEwJ12F2bZJpOhvV
	 Q3/a/8Uhc6Q7A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6872ht7S32417533
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 10:43:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 10:43:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 10:43:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] wifi: rtw88: use firmware MAC address as fallback
Thread-Topic: [PATCH v3] wifi: rtw88: use firmware MAC address as fallback
Thread-Index: AQHdOok1RcarBILzjEGGp2vwQcmTh7bCcElQ
Date: Mon, 7 Sep 2026 02:43:55 +0000
Message-ID: <01fd92db75bd47c182512cacb5fa2ea4@realtek.com>
References: <20260902024622.4149279-1-raspberrykan@stu.hqu.edu.cn>
 <20260902031408.4155609-1-raspberrykan@stu.hqu.edu.cn>
In-Reply-To: <20260902031408.4155609-1-raspberrykan@stu.hqu.edu.cn>
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

YuChia-Kan <raspberrykan@stu.hqu.edu.cn> wrote:
> Some devices provide the Wi-Fi MAC address through firmware instead of
> storing a valid address in the Wi-Fi chip efuse.
>=20
> This is the case on the Xiaomi Mi Box 4, which uses an Amlogic S905L
> SoC and an RTL8723DS Wi-Fi chip. The Wi-Fi MAC address is stored in the
> S905L efuse rather than the RTL8723DS efuse and is provided to the
> device through firmware.
>=20
> Try to read the MAC address from firmware before falling back to a
> randomly generated address.
>=20
> Signed-off-by: YuChia-Kan <raspberrykan@stu.hqu.edu.cn>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



