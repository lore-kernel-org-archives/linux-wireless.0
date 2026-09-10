Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A06361952;
	Thu, 10 Sep 2026 01:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789003341; cv=none; b=uxFFQMf3Tz+hQ8Y7c932hscWJ3iU+dhaMllf5y33r0uFW4obZNdk3wAH57xW4m4kJonNj2Rz+biNOm3oCveLTpQ94JXbHXWpsdd50EiMBSrA7i4BCsRHkGXZ6cjdQbP7VvbUPVZh+cP/9thGMVSxN4aZmNHRwxl3z29krvdzL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789003341; c=relaxed/simple;
	bh=CFkpGeqyFjmsOcWirk5bFijVMqefUny2UAQs4H8xGwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cssA9/i3UvLd+GLmZL1kPtBVIBlg1pOCK0kt5st/jl+s+gOO4ymm9Yg10tP6xDZEtTOLKdbFLoiWh14cN4ZQILTNozSPKmVvAyB611AUWDKI7VrP0KiK8gMaGmIPR3K4weacL/wf5MDRcLRKfoAj4mUvAXxJpoFx7VlpiMNDcoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mdoBkQsu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mdoBkQsu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68A1MAbB41083606, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789003330; bh=m0kuYPw8Dok3bWJeiysaxgTn6/j1RoD8D5nxA0Iex0I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mdoBkQsuqsNTHq2r7i6Plfu69lwFBd7KMGQ3UfQIEJq7COY62Kk3W8hpbITWPAXuZ
	 avw/CZhLiwV9lcOZzWj3GqykvqOVXGByD8rglNxlO2SLD6f+fFUAAbXIr5Zlrxd324
	 xBsu1g6kEPSmJ07GXh05LsEvXxIDticu3mUpPOd2TLAjseCzj8qsk08SwTLqChIH+g
	 eTt01bXcSZm75Qtt4RzLfJhD646e2pLoYUbzcuYq1unwp1/hygLCt1oweHigxdwDjT
	 e0lhpWBA/6w1ggOPG9OTXdmzfrOThUr5X849Bw8CcSlfXhRjnNBelfVItIDbrVx45O
	 wLuXy43XCDP0A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68A1MAbB41083606
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 09:22:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 10 Sep 2026 09:22:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 10 Sep 2026 09:22:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v2 1/3] wifi: rtw88: usb: bound what the driver
 feeds the after-DTIM queue
Thread-Topic: [PATCH rtw-next v2 1/3] wifi: rtw88: usb: bound what the driver
 feeds the after-DTIM queue
Thread-Index: AQHdPvxc4zS16LdQpEqBDFx+NFuaa7bHBaQQ
Date: Thu, 10 Sep 2026 01:22:09 +0000
Message-ID: <5b449b3ec9884b12a96fff178cc6b338@realtek.com>
References: <20260907190901.1056945-1-mehmet.fide@gmail.com>
 <20260907190901.1056945-2-mehmet.fide@gmail.com>
In-Reply-To: <20260907190901.1056945-2-mehmet.fide@gmail.com>
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
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
> Frames routed to the high queue are transmitted right after DTIM beacons
> only, inside the ATIM window, while they wait in the shared TX page pool.
> The driver puts no limit on how many it hands over, so as long as one
> station dozes, any sustained broadcast or multicast traffic outruns the
> drain and empties the pool: measured on an RTL8822BU AP with a single
> client in power save and ~40 frames/s of mDNS chatter, the free page
> count at 0x240 goes from 1803 to 16 in about 100 seconds and stays there
> for as long as the traffic lasts. From that point every other transmit
> queues behind the backlog, authentication responses arrive too late for
> anyone to join, and the reserved page download fails ("error beacon
> valid"). The AP keeps beaconing and only a reboot recovers.
>=20
> Feed the high queue through a small budget that refills below the
> measured drain rate (about 3 frames per DTIM, ~15/s at dtim_period 2 on
> the default 2 TU ATIM window); whatever exceeds the budget leaves on its
> access category queue right away. The high queue backlog is now bounded
> by the burst size under any load, so the page pool cannot run dry, at
> the price that a dozing station may miss part of a broadcast storm.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Some minor/nit questions. If you don't change others, just take my
acked-by to v3.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

>=20
>  drivers/net/wireless/realtek/rtw88/usb.c | 41 ++++++++++++++++++++++--
>  drivers/net/wireless/realtek/rtw88/usb.h |  5 +++
>  2 files changed, 43 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wirel=
ess/realtek/rtw88/usb.c
> index c90802919473..5482e44f4a88 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -562,7 +562,37 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rt=
wdev, u8 *buf, u32 size)
>         return rtw_usb_write_data(rtwdev, &pkt_info, buf);
>  }
>=20
> -static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
> +#define RTW_USB_HIQ_REFILL_INTERVAL    (HZ / 10)       /* jiffies per un=
it of budget */

Does it mean a budget per 100ms roughly?

> +#define RTW_USB_HIQ_BUDGET_MAX         16
> +
> +static bool rtw_usb_hiq_take_budget(struct rtw_usb *rtwusb)
> +{
> +       unsigned long flags, elapsed, add;
> +       bool ok;
> +
> +       spin_lock_irqsave(&rtwusb->hiq_lock, flags);
> +
> +       elapsed =3D jiffies - rtwusb->hiq_refill;
> +       add =3D elapsed / RTW_USB_HIQ_REFILL_INTERVAL;
> +       if (add) {
> +               rtwusb->hiq_budget =3D min_t(unsigned long, rtwusb->hiq_b=
udget + add,
> +                                          RTW_USB_HIQ_BUDGET_MAX);
> +               /* The part of the current interval that has not complete=
d yet
> +                * keeps counting toward the next unit
> +                */

First line of comment block should be empty.

> +               rtwusb->hiq_refill =3D jiffies - elapsed % RTW_USB_HIQ_RE=
FILL_INTERVAL;
> +       }

nit: an empty line

> +       ok =3D rtwusb->hiq_budget > 0;
> +       if (ok)
> +               rtwusb->hiq_budget--;
> +
> +       spin_unlock_irqrestore(&rtwusb->hiq_lock, flags);
> +
> +       return ok;
> +}
> +
> +static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
> +                                          struct sk_buff *skb)
>  {
>         struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
>         struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);


