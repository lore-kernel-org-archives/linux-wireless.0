Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF9A3DDB14;
	Wed, 19 Aug 2026 07:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124758; cv=none; b=O5BVm2s1FL8i6IVnn6a1EQkrymkDn3y1tiknzZstPq2IPIoapS+kya33bIpQ4DM44BwtBP4ew2NJHONZtSwXlt/a5Pg4+01XHyn6JktGw3vZpxEp8i8iykb1YM4e95ovszmX0yaClXDq9Ni14W5Anm1W+0WOwrX/8EDKK4d1phI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124758; c=relaxed/simple;
	bh=1u//92PngrrbmoFgvwkwidI1am4aO5kKg8eXD7prw7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uU1cDjQ81dC18UcvNyy6tKlb7dE7QdJzR8/T2MXDRCCXEgvGZd4XZB+miDqAl10WliawoWbmHuhb0BsfglHVWGKxYakqCP04pDlw8l6vLEykAmIDerdhKW+qkWRaydcGDYvlD/0MZI6ZwU8H2r1OjApJM8xv7YF9RWBbkTv6o5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YB+7xbHS; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YB+7xbHS"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J7VDZE02190587, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787124673; bh=jDWfZ9sEnrHhqKQKr8A1qKXsnHp6ZNqP1G0sAjUlRwM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=YB+7xbHSmP4m6M/Zbu/yJYPjRkW1R6hVlc3eJa4ogUaQvu/oMOwMC5F6FhP/TL07S
	 NvYrKgTdJ8g9BpdtrB5BSeB0d3qactSla9q79exsROYxjC/oRTpUUVPM3PAguA+Ji8
	 mbTGWqAB+7jMdQVhDpz9KQr1FaL7s8Tlo9T+Ep/HKp3Nx+F2mO6X+naPxNmXO7YXrf
	 IQu9y1ynNBHk9GyZp4SsEi/2R/hjgc9fpp3AFoEuR3J/qYPmbu4zMNwWREzZRRzZBh
	 fq8NNot7KePEdjzUyK/tDyXIZCA4R8OGhDoRJkMKHy2oKuaKMdyZDK5MgfmmFLcZVg
	 VESiOBViq1uHQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J7VDZE02190587
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 15:31:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 15:31:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 15:31:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v5 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdK9tF/dBhEaQ+I0uj6E6RhFUyKbaklmjw///h7ICAAIcKgA==
Date: Wed, 19 Aug 2026 07:31:12 +0000
Message-ID: <459e54292cf245e2ae6fd1a46afb6ec7@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
 <20260814105327.6687-7-luka.gejak@linux.dev>
 <257b9af907e84e439ae6a9fd55bf3f09@realtek.com>
 <20260819071932.19596-1-luka.gejak@linux.dev>
In-Reply-To: <20260819071932.19596-1-luka.gejak@linux.dev>
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
> > I'd move this chunk you are adding to a function.
>=20
> Done. The conditions now live in rtw_sdio_8723bs_reschedule_tx(), which
> decides whether the work should run again and says why, so the handler
> loop is just:
>=20
>         ret =3D rtw_sdio_process_tx_queue(rtwdev, queue);
>         if (ret > 0)
>                 break;
>=20
>         if (rtw_sdio_8723bs_reschedule_tx(rtwdev, work_data, queue, ret))
>                 return;
>=20
>         if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
>                 break;

It looks much better. :)

>=20
> While rewriting that I found something I had got wrong in v4 and v5, and
> it is worth pointing out because it was not limited to this chip. Both
> versions had an unconditional
>=20
>         if (ret < 0)
>                 break;

I didn't get this point. I'll review carefully on this part in v6.

>=20
> in that loop. Upstream requeues the frame on a failed transfer and lets
> the loop retry, so that break quietly changed every other SDIO part to
> give up after the first failure. That contradicted the scope claim in my
> own cover letter. It is dropped in v6: the two errors this chip needs to
> retry are handled in the helper before that point, and everything else
> keeps the existing behaviour, so the other parts are untouched again.

Thanks for pointing this.=20

If you have another SDIO chip, such as RTL8723CS, please verify your patche=
s
on another real hardware, because it is not possible to catch all flaws by
reviewer (like me). Using real hardware with a simple throughput test is mo=
re
important.

Ping-Ke

