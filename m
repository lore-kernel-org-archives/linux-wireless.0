Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9273451CE;
	Wed, 19 Aug 2026 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787101026; cv=none; b=Ptde7UijSUflogLKOXvxSNYSGgqZw+pLKdzySirJBEEBM9wJSk9bodB5G1wEEYYaAOuaC+cMhwMnQFhMBDMKTYQaH55eLYq46rweOLJEZ8lWAyQWGD6TrbPFvHaXvZqvG64gkzdosFK4QAsMAyVqzSzqWu5Z9bGpZV+4LrTmRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787101026; c=relaxed/simple;
	bh=vSGWszQ3CcdV7byttciYsXfLZQ/XwN4KLOO0dsFs+9Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PDygyT7ysLayuTX9vwF/M2zAY1XJv+vsag4LEltKSQYXc5Ip8Y5WSLXIsGc+7ADzq2FRJecZYoOBWa+ji0uVSFCnP7H3T/JvvIAZDmfEd1bPGk24u53zcVtsOxxfhVgwsYSQ4iWWwoTLIhoaf72glIaL3BFfl++CXyAoxPM1HEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CBGt5ZbR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CBGt5ZbR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J0uJvqD1923267, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787100979; bh=vSGWszQ3CcdV7byttciYsXfLZQ/XwN4KLOO0dsFs+9Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=CBGt5ZbRtmSBC4oEatwrGHBoPUVvL0TPdrRrqFfuL4ucRNXlqTCmFrVn21YQU10gL
	 MlHrD4rtfpgI+PhbA1ZuTaXkcmmRMNim235DzYQAr6u2VdBvRDF1d0u3eRHc8Sx8uj
	 oKFrIQbUGRd5e+fLW/J4Ja6gFBynYUNfb/fodpPBNHL/qFfKORW8dD1bwTskWsRCk3
	 ylWq9FVH1LwGZBxwKEjX+Epk906mTaRWNGVvioLukjmrrzsIOkp/S7jAwgl7be9m8n
	 IOOMLboQ+elnFH00jwDlLBtgtIVfPX7FobvTqiYMjU7sSnFzlaJ/K08DdM17kDmyYJ
	 2gNpWGAPD5bfA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J0uJvqD1923267
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 08:56:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:56:20 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:56:20 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 08:56:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 5/6] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Topic: [PATCH v5 5/6] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Index: AQHdK9tCKXmjOIa2fk2i8eJPbzhx2rakk0gg
Date: Wed, 19 Aug 2026 00:56:19 +0000
Message-ID: <c9be9df21b9c41098296e813cbf742d6@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
 <20260814105327.6687-6-luka.gejak@linux.dev>
In-Reply-To: <20260814105327.6687-6-luka.gejak@linux.dev>
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
> Enable the existing RX aggregation setup for this chip and select the
> larger DMA burst count it needs. The RTL8723BS does not raise CPWM1, so
> leave that source out of its interrupt mask, and set the SDIO TX control
> bit the vendor driver uses to have transfers always recognised.
>=20
> The chip was also seen to keep raising the interrupt after resume when
> undefined status bits were written back on acknowledgment, so
> acknowledge only the bits this driver defines. That observation dates
> from bring up and I cannot re-measure it: the test machine only offers
> s2idle and does not reliably return from it, so the resume path is not
> exercised here. The change is scoped to this chip; the other SDIO parts
> keep writing the status word back unchanged.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


