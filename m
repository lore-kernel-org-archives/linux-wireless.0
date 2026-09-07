Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3271CAA6C;
	Mon,  7 Sep 2026 01:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788743480; cv=none; b=DMOOLwvHZ8trdjQftCkZ9QmT06qwxPyWLsfYcM2jA6eiZ0ThLhwjflwcRraHeHS9kfy7Kz0WoLYZ1+onHHgNQFrhqvbFeFHFkt623ztTgBapzjIZpdpJnaefH+Z559yy4Th4/6LHEct74nyQt4FgKJi8kfWsCD9G5S1LfO7Lagw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788743480; c=relaxed/simple;
	bh=gp0U4c7Gl86hsDlI1yzVwX/iAoxxd9CbHAcoKLYLdSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PTROvZYP17RRdhoP2cH24yDb+9LvMtVlMZnaNU/NYXQHjq1iRXCl8iTFYuAxEu0qf9HmChB8KFgFJ5OP3o5Ac4cm/WZEIVlDgVlyxCm0ACpPKHZY5FfDkd+/3J7cWTZ3RiBytuGiFKkb+TBWFYSGCWaA+OKqhZA3Onr0Ct+6cMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Oc/NX915; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Oc/NX915"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6871BDacC2362451, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788743474; bh=gp0U4c7Gl86hsDlI1yzVwX/iAoxxd9CbHAcoKLYLdSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Oc/NX915Gu0JoAQQZZm6SORNF2xi3Fu9qP3z/3eoHvUFu19/MArwovCSWEezToM0C
	 QmMvnYLmfxDyvoz1DYnwvKgku3PQhGD20vz98H/UCae4iUcAnU45KvmnM7qcd3DQdb
	 9zVKGo6LC0stKBoXOLOC27Kqcl3weLbcletnTcVhdu4Sxh37vmVd7ShneGurM69k0+
	 JWgCf0ZnptWSNKGdNzLlRrN+8YUhclUONqJSEtZO+cSFmEKySSC7LAJQxIEB32oICZ
	 6KUX5OPgttLmPI9v5P5SVeIH2lDgR2Bss6F2WiUMAD7JwawCFp2+5e6tRi9UawzaLI
	 PoLIjnxSDB/EQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6871BDacC2362451
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 09:11:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 09:11:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 09:11:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v8 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ
 calibration path to signed math
Thread-Topic: [PATCH rtw-next v8 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ
 calibration path to signed math
Thread-Index: AQHdPR4nN3UPBQlEpkWjno9edhMlpbbCUSlg
Date: Mon, 7 Sep 2026 01:11:14 +0000
Message-ID: <8d45ee8562e14d3491c321360689e2ca@realtek.com>
References: <cover.1788601784.git.ulijg308@gmail.com>
 <afafa518cf4f34ff906927eeae488fb25d9aa7bb.1788601784.git.ulijg308@gmail.com>
In-Reply-To: <afafa518cf4f34ff906927eeae488fb25d9aa7bb.1788601784.git.ulijg308@gmail.com>
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

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
> Convert the temporary stack arrays 'iv' and 'qv' from u32 to s32.
> Update all internal function signatures to accept s32 pointers and
> handle signed values natively.
>=20
> Use sign_extend32() combined with FIELD_GET_SIGNED() to properly interpre=
t
> the 10-bit hardware values as signed integers. This allows flattening
> the complex nested unsigned boundary conditions in
> rtw8822c_dac_iq_check() into a simple amplitude boundary check. Ensure
> rtw8822c_dac_iq_offset() properly maps the signed average back to a
> 10-bit unsigned format expected by the hardware registers via GENMASK().
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


