Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EFD43F08E
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784512448; cv=none; b=RaXJ5WrNJhS4Me6QnVG0s+8Ecl76AAR3vr+VyevCAreQNDDdVwm7BS+W51BpGlL5k3G2ZEiusCbTvs2x34m+9e4A8DRt+DnI7HnS5k+fU1zu7CmOo15q2B6cK2+a7/Ee893aMb/4tMb03KgAWjZVIBYSQ3M1ddQXEgEr1ne/ojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784512448; c=relaxed/simple;
	bh=PxssZmcaQy2yyjsXN3Ty+6i7NB05jHq8zjGeCf8lCmc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jBIPlqK455AdglHJTget5DPcVC4A1pvtAflMDHaIyyzTesV55fqj+J95HiySLVC9ibb4xayurUobHkztEhzYPPsOo1fO2Du14aO6VaY11tmgkVoqojT5MU0xlEhK/lFhHLbQkPJgpWUFrKMm0AK4zLoVnig9Mhp0/eRxHgjN6OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MD3fuLFf; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MD3fuLFf"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66K1rwX032110847, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784512438; bh=PxssZmcaQy2yyjsXN3Ty+6i7NB05jHq8zjGeCf8lCmc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MD3fuLFfrseuaeRbsKDcvOQ/uGhbocUTSXd6ArATJDMYToyL2bIJBecKmIPLkgxXq
	 7zX4cdL93s1fXl0Kly49ADqrxTUHaRUVrdcC6voQ6+6b8DCMLKfNmttQsLXjZrSvFK
	 5+Ui0rt20VWpO4WUk5Xk3OosAG1H7i1yBdZveEROJ9UScdYAQIFHpUIOuq7fjG4T01
	 d12norQIPy78wCs1cmys/LD/C+jkheoXJA4xS9/SggoFGSjlaiUZqIYWDWxWi2Q1U0
	 GAvUtimNiZRzUwcMkNUXePaivYKIYAZCznC9Orpd9euugZ59py1KWvqxinxa/eJ3ZT
	 AlDUmKsl8kFsQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66K1rwX032110847
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 20 Jul 2026 09:53:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Jul 2026 09:53:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 20 Jul 2026 09:53:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "straube.linux@gmail.com" <straube.linux@gmail.com>
Subject: RE: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
Thread-Topic: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
Thread-Index: AQHdE7mArI84ceIbn0yTVbdL8mTXELZ1qU/g
Date: Mon, 20 Jul 2026 01:53:57 +0000
Message-ID: <1800080a275f4421b16bd3a028131e8a@realtek.com>
References: <cover.1784047561.git.luka.gejak@linux.dev>
In-Reply-To: <cover.1784047561.git.luka.gejak@linux.dev>
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
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> This RFC adds support for the Realtek RTL8723B 802.11n chipset and its
> RTL8723BS SDIO variant to rtw88. The series is SDIO-only; untested PCIe
> and USB variants are intentionally left for future work.

RTL8723BE and RTL8723BU are supported by rtlwifi and rtl8xxxu respectively.
Though it isn't so good to maintain three interfaces in tree drivers, I'd
keep them as was, unless people can take time to verify them, especially
BT-coexistence.=20

>=20
> The implementation is based on the initial RTL8723B work by Michael
> Straube <straube.linux@gmail.com>.=20

Can you share the link or GitHub?

>=20
> Hardware validation covered repeated scan, authentication, association,
> WPA2 key negotiation, DHCP, bidirectional traffic, reconnects, link
> cycles, module reloads, scans under traffic and a sustained stability
> run.=20

Can you additionally test BT-coexistence? Download or navigate web page
while a Bluetooth is playing music to see if it plays music smoothly?

> The final series also builds cleanly with W=3D1 at every intermediate
> commit. RTL8703B, RTL8723CS/DS and the other rtw88 bus modules continue t=
o
> build.

I did additional sparse/smatch tests which both are fine. Once you send
new version, run them again.


