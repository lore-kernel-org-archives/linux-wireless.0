Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1041D4F1;
	Tue,  6 Oct 2026 12:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791290336; cv=none; b=fzCb0DgWKjk1ofjuGI6PtbqbSl0JK+wmmL4izcCsxyAvXFL5u+cQ1DNvHAtUCpP9pFNPgz82Bl326zFYcwWxEAj89jDHJQG9lcreJdcjQHTSkIlOmF/070FyvLWzaIG+KU7L27b9QGhyAC5Ve+KQ60XeXWhwFRWaH1sDf7oGpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791290336; c=relaxed/simple;
	bh=i3Zue9L0U3QnYoExb9bKHR3RA6ghMefAuJkvqnzB6ns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VjAmMlVBu/4PFqHAwIakoIq0eexM2gW9f6KIdHLv7K6K2kUKMS1wghBR0/Mf1fzVwLH2u49vtVU9kPnRnbUqTE6A2R+/lI6w4iL3eGfXXzRrk3gvupU9Wgx34nILXzSnSVMiT0LQkT/qqEcJ4QCsdggZdTo6E/HBC7wAFBO8O/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=F9iFGrIU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="F9iFGrIU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 696CcWuuD2926181, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791290312; bh=i3Zue9L0U3QnYoExb9bKHR3RA6ghMefAuJkvqnzB6ns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=F9iFGrIUlrWpu0yF+pG1jgLLBJfm1gyipslj3FrmesE2RWtcKPYbi4PDTdsbW5w3G
	 AIQjuGM0mxIq+REq19Aamp4ZrrJ9ZYvv7+k2mq0DUWXC5dguCXs5t+gewY7fJPmY5F
	 NPA32YjJvChlGwxmtrPSyvSCgsTtERlkOW5b0b5akqwmRUI8BpXlnPwW0e0p9X7gik
	 FSvpY0YKi3ONDyp+bt+SvXYY4IeiANrIjhWrTuAwRc18eHeORBtw3SjNgunjBE/vuN
	 IJBbjF9qkBHp92tsJDBcfRhRuKliX/wFS0WXbiFz+ovcm+tjzhOeQHiULGVN/2tAmO
	 YRNLTr9DOlcKA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 696CcWuuD2926181
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 20:38:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 20:38:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 20:38:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
     Straube" <straube.linux@gmail.com>, Peter Robinson
	<pbrobinson@gmail.com>, Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
Thread-Topic: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Thread-Index: AQHdUkEe+6mTN1t+pkmrNCm0JOCqYbbudRJA///7x4CAAT4DAP//vViAgACViMD//5Y3AAAEHvmAAANfhgAAFMArtQ==
Date: Tue, 6 Oct 2026 12:38:32 +0000
Message-ID: <6e16f94786e24c89bea429f1370f4e59@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
 <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
 <f23d5ed909c746ad851bd1038966d271@realtek.com>
 <9f11a1ee89aa22a2ce23238b5ac968463f6e79a2@linux.dev>
 <39e05b490d5c6f90ea122e1c9a83ce8bad94e735@linux.dev>,<3abafff88a4607572817675c246ba50ca277b976@linux.dev>
In-Reply-To: <3abafff88a4607572817675c246ba50ca277b976@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
> October 6, 2026 at 11:05, "Luka Gejak" <luka.gejak@linux.dev mailto:luka.=
gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3E > wr=
ote:
>=20
> >
> > October 6, 2026 at 09:07, "Luka Gejak" <luka.gejak@linux.dev mailto:luk=
a.gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3E > =
wrote:
> >
> > Followup: the things I am moving will be exact copy paste, unedited or
> > anything so take that into consideration when reviewing that patch.
>=20
> Or would you rather me fix those style issues? Your choice as I will have=
 both versions ready.
>=20

Not very sure why style you meant?

I assume you meant coding style. Then, fix them.=20

Ping-Ke
