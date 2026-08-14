Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263B63F787E;
	Fri, 14 Aug 2026 07:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786691767; cv=none; b=P3Q5EHpfXyLJIQAGauVk5XmarlTLDrqydHAS0SIb5gIeHPY3JXgGqpMUfAx7tibSSk8rYZAzkkvw8kPvGJlpHOtgavMucfK2W+OmCelavbSOHmltFvH64Xhcn/Or52tUk28l/sXbF8LXK4vNnYrribV10DezUvJEiOG1lGDgmoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786691767; c=relaxed/simple;
	bh=QQppTWXtC2uDl+i0fA+WpcSUefneuqQWWt/bwNeV9yE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ol6CY5mBa8esZFoVGoj0DSuK5wZ3u3mB6Ih3N4KK8990UbLYT2osGT22JpNcxBt20Xi7yYCzSKMOZbeOAYARnNBPi546fGUSxoXUaIOjzwDty3zj9uZbGKZZqRu7GzY0K8usXpBsOb8MIF1StvpjUPA+WGVKey8fTgb7P7M2tmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qLigrhpm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qLigrhpm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E7FoloE1059115, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786691750; bh=QQppTWXtC2uDl+i0fA+WpcSUefneuqQWWt/bwNeV9yE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=qLigrhpmML7LCXgL2Z6Zlyje/Vbz86855UrT+nUKID1WuZjxCgegpT3ePLNOI8/+a
	 APRf5UnwK+o+dfL7/OSShOpKl5HKYxDG8MrFtNUCNKq2WtGcApX7/4xg63Mb8Ia0An
	 //3aoiecXlMUZ9qMmvcEikUBMefYCt35DOgs68Z/+QRx4iO6ZNB/fAblYY1V1vn6g9
	 mTz/hf6hqiC+1nPWCq65LmhOrgZ60o8QPgs0ZAygNUdSFwI2YlOuXabIq6kKNwrOKD
	 srdQSyqOrF1YM/z7Q6B0T+5K3s66GYyPGlGYNIdtgxV0ryI2j65EdyFuMPWodJ8x60
	 vyzHIMMuJGK8w==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E7FoloE1059115
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:15:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:15:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:15:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 15:15:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 3/7] wifi: rtw88: tx: extend the TX report purge
 timeout to RTL8723BS
Thread-Topic: [PATCH v4 3/7] wifi: rtw88: tx: extend the TX report purge
 timeout to RTL8723BS
Thread-Index: AQHdKXGnGNHlxQl6E0aylFc7HbAFa7adJntQ
Date: Fri, 14 Aug 2026 07:15:50 +0000
Message-ID: <d90ed84c1b114dea86af5b0065087a5a@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-4-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-4-luka.gejak@linux.dev>
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
> Commit c80788f7c5ae ("wifi: rtw88: increase TX report timeout to fix
> race condition") raised the purge timeout to 2500 ms for the RTL8723DU,
> because the firmware can stay off channel during background scans for
> longer than the 500 ms default, which delays the TX reports and lets the
> purge timer drop the tracking skbs. The host stack then reads the missing
> status as loss and collapses TCP throughput.
>=20
> The RTL8723BS runs the same vendor firmware over a slower SDIO host and
> hits the same race. Testers on ARM SDIO boards see "failed to get tx
> report from firmware" under load, with the same throughput collapse.
> Extend the 2500 ms timeout to the RTL8723BS.
>=20
> Reported-by: Peter Robinson <pbrobinson@gmail.com>
> Closes:
> https://lore.kernel.org/all/CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHb=
KF+TdQ@mail.gmail.com/
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


