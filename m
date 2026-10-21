Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792546480;
	b=p8SGZxlSduO1SebIRPO5uQg3AdEdoSIi53HuarzJgYv83DPlYA411yXlMBHHxMDIDRpa
	 YhOS4gbAdcNOERtTZy/CZv3QDOYKpq7FMS/kXgobOvittjOolvBU5ECzoJBatYr/Wmp5f
	 +0dreHsAQC/ndffkHl39rcBwsBjIQtCqLVCQ2b1/rN6ng4mt1DYjgBdXJbndNbkTt4OdM
	 kLoWGUAtr/1hEHRkrFOR6QLcuVvQibOmbWRJSWsXwHl9PBOuBbCYLvlYsyttovS4C+LyR
	 ebNxXsboBF2mqxkUX6Bj0fEAbQ5CY+GIu+8dLw32WHpWCoZ44QqqcX8ELEhe1tt9pig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792546480;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=ddq2qPIo6wB+QABGdQ7hP+DtISzIJtoJMPvX1kYTDPw=;
	b=WurjXcbqS6z4TPE5OndrImBQEZ7k+dsPnaQclFirKNBn9akNf5iRBLKKRpBbKxPooWY+
	 W4dIiWIxYqolKDoJciK8Qu8lW9CrDn+BcdMsiiw+3ZBdgeB562WdaYmK1LVo6vw/9Ivkr
	 WdewMmcmOd9BtfU/7LdWFDt0z6O4J/KtXempak4Ltuv2GCWV5lDOpZzme20ra4K2l8FfD
	 Lp6q4Src//YrF5QoOqgY6V3tRUDy5QI4p3PSiGRGZaL3zze6bF83H1twJxC4FCBbW1Tjb
	 aBDnGqMB1XRhH8/SbcRb3YaWOtEk+Hjf4WVQDkEkB4gmmYVj4+cGHi9knXJ00AYYkfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="Z/p/oIjI";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0649606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 01:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0649606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Z/p/oIjI
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L1YR8x83557429, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792546467; bh=ddq2qPIo6wB+QABGdQ7hP+DtISzIJtoJMPvX1kYTDPw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Z/p/oIjIozjl+Fk37/uIlcA6CmPAC9TVtirJXI6oM3q2S4j7KTDuqvZhVrYAb3wzl
	 pwIusvPtOw4bajpKL+S/VlGCk0mVOOlebGahUHc6UZjT4jgnGsw6mdXMhXeQzEeXqe
	 aMST9nAEUOMABSPSVUM9c86y/9Jj2E2nrsprM99yKD9PN6QBV+0Gr57eV1SmQ22VJs
	 lrNi6SV/l8Y6EXWYhQ7xeVEQ+jMiefwabs8KZJ6KihZk+d+gATrG00QNKmlW5WUdbM
	 3he0Plp86dlyrlM7j9oPLxc0CuVzPjROCzsSkxK9a5Wtiley0IOeHSNvqw42iXOaJX
	 +nJJj8Au+G0tg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L1YR8x83557429
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 09:34:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 09:34:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 09:34:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw88: sdio: limit the high queue to DTIM
 delivery
Thread-Topic: [PATCH rtw-next] wifi: rtw88: sdio: limit the high queue to DTIM
 delivery
Thread-Index: AQHdYMd23rlOQq1iqUO+R2vp6UyKjbcHMtaw
Date: Wed, 21 Oct 2026 01:34:26 +0000
Message-ID: <08bc181d144544b08ed14d78a4fa5a89@realtek.com>
References: <20261020191542.17207-1-luka.gejak@linux.dev>
In-Reply-To: <20261020191542.17207-1-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> In AP mode every broadcast and multicast (bmc) frame is sent through the
> high queue, which the hardware only drains after a DTIM beacon. Only a
> few frames leave per DTIM, so steady multicast traffic builds a backlog
> that holds the TX pages the other queues need. Unicast traffic then
> stalls for seconds and clients can no longer renew their DHCP lease.
>=20
> USB had the same problem and was fixed by commit c710c7c2e038 ("wifi:
> rtw88: usb: route bmc frames via the high queue only for DTIM delivery")
> and the two commits that followed it. Use the same rule for SDIO. A bmc
> frame goes to the high queue only when mac80211 asks for DTIM delivery
> because a station is dozing, the frame is ARP, EAPOL or DHCP, and the
> budget allows it. All other bmc frames go out on their access category
> queue.

I think it'd be good to add:

Tested on rtl8723bs with atk19 client.

>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>   Tested on rtl8723bs with atk19 client.=20

(mention this in commit message)

> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wire=
less/realtek/rtw88/sdio.c
> index dc2fd0f8f9ff..3cdffac5b5b0 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -6,9 +6,11 @@
>   *   Copyright(c) 2018-2019  Realtek Corporation
>   */
>=20
> +#include <linux/ip.h>

When moving rtw_sdio_bmc_needs_dtim() to tx.h, no need to include this,=20
nor does usb.c.

>  #include <linux/module.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/sdio_func.h>
> +#include <linux/udp.h>
>  #include "main.h"
>  #include "mac.h"
>  #include "debug.h"
> @@ -26,6 +28,8 @@
>  #define RTW_SDIO_TX_FIFO_HIWATER                       16
>  #define RTW_SDIO_TX_FIFO_LOWATER                       8
>  #define RTW_SDIO_TX_RETRY_DELAY                        msecs_to_jiffies(=
1)
> +#define RTW_SDIO_HIQ_REFILL_INTERVAL                   (HZ / 10)
> +#define RTW_SDIO_HIQ_BUDGET_MAX                                16
>=20
>  static bool rtw_sdio_is_bus_addr(u32 addr)
>  {
> @@ -1299,6 +1303,64 @@ static void rtw_sdio_8723bs_wake_tx_queue(struct r=
tw_dev *rtwdev,
>         ieee80211_wake_queue(rtwdev->hw, q_map);
>  }
>=20
> +static bool rtw_sdio_bmc_needs_dtim(struct sk_buff *skb)
> +{
> +       struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +       struct udphdr *udphdr;
> +
> +       if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
> +               return true;
> +
> +       if (skb->protocol =3D=3D htons(ETH_P_ARP))
> +               return true;
> +
> +       if (skb->protocol =3D=3D htons(ETH_P_IP) &&
> +           ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) {
> +               udphdr =3D udp_hdr(skb);
> +
> +               return udphdr->dest =3D=3D htons(67) || udphdr->dest =3D=
=3D htons(68);
> +       }
> +
> +       return false;
> +}

This is totally the same as USB. To share with USB, move it to tx.c=20
as an export function or to tx.h as an inline function.

> +
> +static bool rtw_sdio_hiq_take_budget(struct rtw_sdio *rtwsdio)
> +{
> +       unsigned long flags, elapsed, add;
> +       bool ok;
> +
> +       spin_lock_irqsave(&rtwsdio->hiq_lock, flags);
> +
> +       elapsed =3D jiffies - rtwsdio->hiq_refill;
> +       add =3D elapsed / RTW_SDIO_HIQ_REFILL_INTERVAL;
> +       if (add) {
> +               rtwsdio->hiq_budget =3D min_t(unsigned long,
> +                                           rtwsdio->hiq_budget + add,
> +                                           RTW_SDIO_HIQ_BUDGET_MAX);
> +
> +               /* keep the unfinished part of the interval for the next =
unit */
> +               rtwsdio->hiq_refill =3D jiffies -
> +                                     elapsed % RTW_SDIO_HIQ_REFILL_INTER=
VAL;
> +       }
> +
> +       ok =3D rtwsdio->hiq_budget > 0;
> +       if (ok)
> +               rtwsdio->hiq_budget--;
> +
> +       spin_unlock_irqrestore(&rtwsdio->hiq_lock, flags);
> +
> +       return ok;
> +}

This is also the same as USB. Please consider how to share the logic.


