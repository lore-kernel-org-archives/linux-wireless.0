Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0232AABC;
	Mon,  5 Oct 2026 06:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791180572; cv=none; b=mstiJR1Z6s8JmVnMdSDNWXHy/JQRKoCkcdGY7bXf0gXQ6kHOTqN8c6gzcydq4x71uMap0QMD1c+bn7bhyJZNLrLj6Rqn7y1AncCFDXjyUY0Gu/T4rYcJHvaxppr3AMqBkUeTjiJsQvi3STsJzXuYr5J4banmd2X9BpTLpx9Up0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791180572; c=relaxed/simple;
	bh=vk6lNI7VixkIK7cAQGZoFWK3teLzEHYwnfjWkrfvXUs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZjF7ujUSTSEO1egcHonNGhI0XINa0PU033vm8RSH2L05kNwcsGpxQsArje64xmxI3wHIzJ8BtqGMReh55Pqyq342skTqj6KCST6sulIlpXj/UP5vkY6BiPj+43l/PkdngxiniD1ug/DKr3c7AjvdFgtjmov7335LJwMF+PCqB0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rL6tdfTT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rL6tdfTT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69569MS301706630, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791180562; bh=vk6lNI7VixkIK7cAQGZoFWK3teLzEHYwnfjWkrfvXUs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=rL6tdfTT3BEejKmnSzQ+O/yymYPdVDcDCQClBzRYXcdBey+YqJbhu+Ydf3G/YOlK+
	 I2UwePQXgZkf0CW54CQrqrb6f9Hw2ZrHpIP7R8nRUnp2z7WjtEzMzhk8oYI+NmtEYr
	 w+7qnbNYX3v8exhmRm67BqmswUMFteXKWfB9T5/XbN0X8PtxtwOKF25iWjnvq1w/4z
	 7qgXO/3GRDlnnMshnzhl5ZqyjjZChtvZ9QsmuRepyBNhH3ZUb+OyURQ25sZOZii1/z
	 iYmVOzSvxsVWgXjYziUaxtRdR3ibNa8VIxtJyQrhX67Hdxq6mQb/y1omk0hbgu72J5
	 bDAiasGfi4Jpg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69569MS301706630
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 14:09:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 14:09:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 14:09:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 14:09:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v7 5/6] wifi: rtw88: 8723bs: add the RTL8723BS
 SDIO bind
Thread-Topic: [PATCH rtw-next v7 5/6] wifi: rtw88: 8723bs: add the RTL8723BS
 SDIO bind
Thread-Index: AQHdUkEf5hvEkBgiiUKMH5AzYg9sXLbue4Ag
Date: Mon, 5 Oct 2026 06:09:22 +0000
Message-ID: <04fdae8aaf524c85bb4a878c3e5bf368@realtek.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-6-luka.gejak@linux.dev>
In-Reply-To: <20261002073845.31486-6-luka.gejak@linux.dev>
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
> Add the SDIO module for the RTL8723BS, the SDIO variant of the
> RTL8723B. It binds the Realtek SDIO device ids to the shared rtw88 SDIO
> probe and points it at the RTL8723B chip information.
>=20
> The device id table carries the same six ids the staging rtl8723bs
> driver binds to this chip, so the staging driver can be dropped without
> losing hardware support. I only have the 0xb723 variant to test with.
> The other five are included for parity with staging, which has carried
> them for years, rather than being left behind.
>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


