Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792549853;
	b=vKyDOLIGHcWHyPyBWYYS6+8lKyfuaAXxZe1FX64XRGrcW9GZpOCKb809f97hAubGUg8q
	 pg+FotFN6RJ1Z2AocpRB3zaZsZTr8ndcfdB8rcK2QLi0tVLUnLMNbd8m1LoqphO9gSG1e
	 me1N7O7bH8ZBmbWfEE6HA+MGLfsBxCWa919EhEUjVSgmTIOqsUKvGvQ/eV5dEY74rbzgy
	 6VIUvRF+oUvobtZow1T1eXuN4634Ij54A2qR+J5i1yqXzlcS0TrrU4CzioN4r8guSuvNe
	 jUyHs+5329FPsjnmgjxWlXHEfLg0vdkSb9B7GPmbPW5McF1wXaGKdNvWVVCRS9lPiNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792549853;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=3zCYkVoQjSWVN4y687gqJz4zruPTLeni297ihw/20S8=;
	b=n7XuONLNVm+UXOXDLFryMs7sWTXaKu8JO6VKUCouk+EGsJF87KjfVW93xNyy1qsS3pG9
	 3zZjo5NJZAeOqu0FaLUrpsboriYT0gb2gV7yMiDx/J2AqQIygGWPJLqeWU7taHy6VBCdR
	 l9XWz1kKulcxsuCIFLoXXfUwhE3kWSu/ii8/B6t6cyuWFIlPlrWV7SmMvj6Hba122tp9M
	 p6KAcmQ8iueTKUrnS9/3ifIc247kJPCly9QBnZJBSTQgYP2l28Ck+U5C/uKAXN4qGpmdX
	 u3rsn8dixDJG3aW4N8lGJtPogkMdQSm/siK7mqJ5fiVudq6JqbddzY7P8Bm16/unFJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fhFGAwDm;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED7B606A319;
	Wed, 21 Oct 2026 02:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AED7B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fhFGAwDm
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L2UiLK23631491, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792549844; bh=3zCYkVoQjSWVN4y687gqJz4zruPTLeni297ihw/20S8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=fhFGAwDmb60GEiUqHc/T1vnMLFYylU7RqfSR+DJEoyVsaWcmTd3k+mmMGR2D2sWi+
	 tySMs2qsSlrdN84UsGhd/rCrYKOoD+yLYsktxi4j6ghU9jQ3g+gBIP+1EYO/PSS9IJ
	 g8DMARHmFIKbW0PE/UHTYf2w4c+vfTlag7lP6rMWJgNbsf42kMBC5tKsaX0Tnj3wYG
	 lSFF5Q4q76Nx98slaJJeKwReTEAQDbNJmHV8SkU9wd1TEz54B1pzwckm57fGJK6dJZ
	 xBfRkMAPMX1HGz1c2TqatA5K7d72lrvBdlUaS9GLwNd/wJ6BipW5Uq9/bdX+x7a3p6
	 3yoaFM7He4X9A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L2UiLK23631491
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 10:30:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 10:30:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 10:30:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v7 2/3] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v7 2/3] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdYNQ0MfXI59RhaUiY0tDdZb+i5rcHRnrA
Date: Wed, 21 Oct 2026 02:30:44 +0000
Message-ID: <a12c5e96ff5e4808beb6fb377ade7976@realtek.com>
References: <20261020204712.3252023-1-mehmet.fide@gmail.com>
 <20261020204712.3252023-3-mehmet.fide@gmail.com>
In-Reply-To: <20261020204712.3252023-3-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
> hostapd's CHAN_SWITCH is refused because the driver does not announce
> channel switch support, so an rtw88 AP can only change its channel by
> being torn down and started again.
>=20
> Declare WIPHY_FLAG_HAS_CHANNEL_SWITCH and implement
> channel_switch_beacon: the firmware repeats the beacon held in the
> first reserved page, so while a switch is announced the page is
> downloaded again every beacon interval to advance the countdown, and
> ieee80211_csa_finish() is called once it completes. IBSS shares the
> page and the work.
>=20
> The work is a delayed work of the device and csa_vif names the
> interface, both under the driver mutex. The countdown is cancelled when
> the AP stops, when the interface goes away, on WoWLAN suspend and in
> rtw_core_stop(); the BSS_CHANGED_BEACON replay after a hardware restart
> resumes it. The other page downloads during a countdown, the TIM update,
> the PG backup and the one on association, are skipped until the beacon
> after the switch, since every beacon fetch advances the countdown; the
> next download carries their changes. A scan is refused: it would take
> the AP off the channel its stations count down to.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

