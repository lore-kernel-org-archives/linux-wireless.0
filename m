Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B96D3B71D9;
	Tue,  6 Oct 2026 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791273309; cv=none; b=RPfFyes1zDLqzmtfy5lYUI2fFnCtHKF0vQpEhu4WjOVOSvwZmtlPhBL7AtZVNVoD63z/EkcHjAiIYW16Ew4dwLANAXvHrAgxiolGzQt2e6yiF9p64thMfp9u9koSeIhFj6m5FrgmliRJonP+vpxbcLS6rBmQxIzlcE68/j2h1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791273309; c=relaxed/simple;
	bh=z0tqKrok6FkCdJeZUFOvi57EJoAXeks1dSGJhkh+Aqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j7XlMgjj9heCj+8F/CA0RiSuxgM2r16RopSrB+yabnUU13ctGFrzQmnJNSWORATPLspFEsz05U6dQTjrkmT544Je+znhmQ6d0zd0APQSokvtXpZuTKvKFzokHbaRWhW6AR6JiU9RH5yx+bRbBgd0sbE5jL7E5Sx5FvBZu65jlM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uP6nYJLn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uP6nYJLn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6967ssnK72742414, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791273295; bh=z0tqKrok6FkCdJeZUFOvi57EJoAXeks1dSGJhkh+Aqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=uP6nYJLnV2g77iKv7n9iCyfJUWhreeQ+jfceFhjLwyiNrnqVECx60luQxWE2o8TdP
	 kNofzhCGHzB9LLH3I9QwO+8AYk+h44moOKqR6VegnXAKtb+7TpOV6CiqJJUb1lTPwP
	 ftdH3yAeWsF0LyO53vgXo628eEfvghriWe1YW9i8JMJIPiVCjdxddWDgyhm6QSjaPr
	 oYMKfU3K3SGJepvHHsG8/ee3FF9ti9TEHfJTlDqtTYX9D6VdBePuqDwuYO6y3ifC2Z
	 g8VG8/dTS1N6Kfj+errh7BS78tHbc3NIEOQI+UWNOwg21buHM3TKcqqN/rhD7y3t7d
	 nsRyIg3c9Ul0w==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6967ssnK72742414
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 15:54:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 15:54:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 15:54:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdVNbGRyo/aSSZhk+/tharL8dRjLbvr7cw///uFICAAIevQA==
Date: Tue, 6 Oct 2026 07:54:54 +0000
Message-ID: <3002971ac7824b0b9cafa852e0e81e8b@realtek.com>
References: <151d3d60da614e00b3a94bebd4f4f3a8@realtek.com>
 <20261006074627.372751-1-mehmet.fide@gmail.com>
In-Reply-To: <20261006074627.372751-1-mehmet.fide@gmail.com>
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

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> > Will it be a problem just unconditionally initializing csa work?
>=20
> It was: a hardware restart replays add_interface() with the work still
> armed, and initialising it again would lose the pending timer. With the
> work in rtw_dev the question does not arise any more.

Can we stop the work properly before hardware restart?
I just don't want many flags (conditions).=20

Ping-Ke

