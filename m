Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECDA17C203
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 03:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791863456; cv=none; b=htl8iXicnkuf6wYsnuFi+tf68sNrV+fiBiLU/ehCZjrdIYgtnh1eSlgYcfQrPrzeBbjR08H8iZiE8OqlEeZwa2cNQhOYlNKquZ/F1M/gh38/I5yBG42dX99f31vANcAbW8yg5dV8jHIiYWJfWxN0swH5flWXergKCwN8bMJOyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791863456; c=relaxed/simple;
	bh=kNLgMjbvYIdz2Q4xSlBaZoStBrTMx/sB4bp6m9JTdf0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pzXSXWDSeeQTJG3kJr7A2n14zoB6tt324IB7zLwKgBBSEO34OXy+vEuoXccUczYMK9lPYTNe0YG4EdSJqpsuf6ORbS+YyOqzEXEglhqqCMMcqFdwTyiKtfRwx0chfrimX6nbMIWcc1uMmGNWlcAQ6HOGXtaJ546JDvYa+C4XGME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZM1aVpoP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZM1aVpoP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69D3ooxgF195478, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791863450; bh=6IWK+F1t07N/tZC7S1k7KgRwoHa6X8NBEC9m7WrJ938=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZM1aVpoPjxcr9xhG+KALaV1ZOaL90kvYpXybM6vuqdwqcv4y/dWODxzEBaKTvyGVH
	 PwvyfYxAsafc52R+iN55sX8Uq5qTlsg87gFZ9sN8cC+ZVtybMEBEJUDaZGNhpQ/OYA
	 7UD8og95JEGWBI80aBxlOLh/vvq3a30OqLZlaHCGUWUpoA0Ukh5+9Pa5BDxly0U2wP
	 d36OJx9HCBTNpU6xu0KxcCyOzA16HNgWgauVdVSlwRuEPYLe5aaWPCYwG2h9spnk8z
	 pQx3S23HyNuzcgbdhz6JrpUyHycS5miudFX7VixNGTdvDZNp0zb1ADbQ0D+R4tHtM4
	 7nh2hlESaK8nA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69D3ooxgF195478
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 11:50:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 13 Oct 2026 11:50:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 13 Oct 2026 11:50:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Mohammed Afifi <i.mafifi17@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v5] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Topic: [PATCH rtw-next v5] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Index: AQHdWsQ2yHARALvtIUiOm+U1iBYtC7b61mZg
Date: Tue, 13 Oct 2026 03:50:50 +0000
Message-ID: <adc49955e3e24177b3e935617d80ed0a@realtek.com>
References: <20261013033737.6761-1-pepe.schlehofer@gmail.com>
In-Reply-To: <20261013033737.6761-1-pepe.schlehofer@gmail.com>
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

Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:
> From: Mohammed Afifi <i.mafifi17@gmail.com>
>=20
> In AP mode the reserved page (which contains the beacon) is downloaded
> to the chip by rtw_fw_write_data_rsvd_page(). That function writes the
> data via rtw_hci_write_data_rsvd_page() and then immediately polls the
> hardware BCN_VALID bit to confirm the firmware accepted the beacon.
>=20
> On USB, rtw_usb_write_data_rsvd_page() ends up in rtw_usb_write_port(),
> which submits the URB with usb_submit_urb() and returns as soon as the
> transfer is queued. The completion callback only frees the skb. As a
> result the BCN_VALID poll can run while the beacon is still in flight
> on the bus, and the poll times out even though the download itself is
> fine.
>=20
> This shows up as:
>=20
>   rtw_8822bu: error beacon valid
>   rtw_8822bu: failed to download drv rsvd page
>=20
> The failure is intermittent because the poll retries sometimes cover
> the transfer time. It occurs in bursts when something triggers repeated
> beacon updates, such as stations associating and disassociating.
>=20
> Fix this by making rtw_usb_write_data() wait for the URB to complete
> when it's called from rtw_usb_write_data_rsvd_page(). The new
> rtw_usb_write_port_sync() waits the same way usb_bulk_msg() does: if
> the URB doesn't complete within 5 seconds, it is killed before the
> function returns, so the completion handler can't run after that.
> usb_bulk_msg() itself is not used because it can't set URB_ZERO_PACKET,
> which rtw_usb_write_port() sets for every bulk out transfer.
>=20
> Only the reserved page path is made synchronous; the normal data TX
> path and the H2C path are left untouched, so throughput is unaffected.
> The chips with a 3081 WCPU also download their firmware through
> rtw_usb_write_data_rsvd_page(), so those chunks are now sent
> synchronously as well.
>=20
> The reserved page download runs in process context under rtwdev->mutex,
> so sleeping there is safe.
>=20
> Closes: https://github.com/lwfinger/rtw88/issues/451
> Signed-off-by: Mohammed Afifi <i.mafifi17@gmail.com>
> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



