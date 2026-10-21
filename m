Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.196
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792556611;
	b=YolqjoF+CdwFrcxa4hrUba+BSgsCHr3oZoM8kx/a9g2AEXpXa2D9/6U4sayuftMPURNU
	 VVMtnWXyqjsLQPGUiLTZWqXUx/inD6diplVRq+QDXz51UIICzB61ovU6Muzf1myceYhG4
	 UbMCrLjYqLLDVr06M3VJvtkYaC3m/jXZCcxBqL08z7ahw/ZmNpMBimU3clbEvU1EZ8BND
	 l2VLYn/exX7onNKV9xNS2LfhCjYUEkbEEndGgluSiBPAKEKtUI6m2sUH2WKu7JmZ9qPIN
	 jCxE3cfVQ+tbCxz553Kw7K1tlt0cmzu8THlaLwR3V5Lg3aFNHVL52nW/gI5GwEASg/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792556611;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=rS0RYcluK8oZslHe6pLROJa0cPMx4HgOK3QOJL0YrgQ=;
	b=1WNNl2MKKmKYxBeuXL7qyNOg8PqXRKnSFdQhTl7E5nmBwZa4u7m21Xto1OEraR7sjvTG
	 N9zYUzZW3OzfW/u5TX9lTOsu0DaSwkwYvY89yf15Z2PskSZibsrjg76rarXBfDVuYDby0
	 1IkidILLBFiO5E+U7JQER1wVygmHTcYIZZgrmQK3hQwQDFOe9NfdIKkE4gDyD38zECq0e
	 bdmwIm8hrdW7cFlHXe7XuSijvGC9eE01xFsZdPvbdEy5FEiqpd9+623DHzZcpVfJ2Ywxm
	 /YD7Nb+25kzLrCckw1K9n1t7/yzjqHF3qgUxrzkvbz6oR3ZEWyXGPUhY9xhGbYVlpLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wG6E7WFy;
	arc=none smtp.remote-ip=91.218.175.196
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85621606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85621606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wG6E7WFy
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4iN2IJTBHZRYA7unvL0or1qQmmNtHOG3sI1Z82eKS9M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792556608; v=1; x=1793161408;
 b=wG6E7WFyNDolkYqIBbJtAh2YeppKVj0oI1EB/NBeSJZr40vHgSaQPu/9l2bykmLONKIb8J2p
 DjF2/DrSRe4DKQw8oE4aKeEaC5S6WKd/WnOhEFeQOMY9xuMbOmWq0aBKtjvFn/V2esWNkND+xUe
 LyerX/w+Ztwg+DLyjaEU7PB4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fbea60be3746da91;
	Wed, 21 Oct 2026 04:23:28 +0000
X-Mizu-Trace-ID: fbea60be3746da91
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 04:23:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <1afaced93a78c382447af6c0f6cb209ba872e357@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: sdio: limit the high queue to DTIM
 delivery
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <08bc181d144544b08ed14d78a4fa5a89@realtek.com>
References: <20261020191542.17207-1-luka.gejak@linux.dev>
 <08bc181d144544b08ed14d78a4fa5a89@realtek.com>

October 21, 2026 at 3:34 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> In AP mode every broadcast and multicast (bmc) frame is sent throug=
h the
> >  high queue, which the hardware only drains after a DTIM beacon. Only=
 a
> >  few frames leave per DTIM, so steady multicast traffic builds a back=
log
> >  that holds the TX pages the other queues need. Unicast traffic then
> >  stalls for seconds and clients can no longer renew their DHCP lease.
> >=20=20
>=20>  USB had the same problem and was fixed by commit c710c7c2e038 ("wi=
fi:
> >  rtw88: usb: route bmc frames via the high queue only for DTIM delive=
ry")
> >  and the two commits that followed it. Use the same rule for SDIO. A =
bmc
> >  frame goes to the high queue only when mac80211 asks for DTIM delive=
ry
> >  because a station is dozing, the frame is ARP, EAPOL or DHCP, and th=
e
> >  budget allows it. All other bmc frames go out on their access catego=
ry
> >  queue.
> >=20
>=20I think it'd be good to add:
>=20
>=20Tested on rtl8723bs with atk19 client.
>=20

Ok,=20will add.

> >=20
>=20> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> >  ---
> >  Tested on rtl8723bs with atk19 client.
> >=20
>=20(mention this in commit message)
>=20
>=20>=20
>=20> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/ne=
t/wireless/realtek/rtw88/sdio.c
> >  index dc2fd0f8f9ff..3cdffac5b5b0 100644
> >  --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> >  +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> >  @@ -6,9 +6,11 @@
> >  * Copyright(c) 2018-2019 Realtek Corporation
> >  */
> >=20=20
>=20>  +#include <linux/ip.h>
> >=20
>=20When moving rtw_sdio_bmc_needs_dtim() to tx.h, no need to include thi=
s,=20
>=20nor does usb.c.
>=20
>=20>=20
>=20> #include <linux/module.h>
> >  #include <linux/mmc/host.h>
> >  #include <linux/mmc/sdio_func.h>
> >  +#include <linux/udp.h>
> >  #include "main.h"
> >  #include "mac.h"
> >  #include "debug.h"
> >  @@ -26,6 +28,8 @@
> >  #define RTW_SDIO_TX_FIFO_HIWATER 16
> >  #define RTW_SDIO_TX_FIFO_LOWATER 8
> >  #define RTW_SDIO_TX_RETRY_DELAY msecs_to_jiffies(1)
> >  +#define RTW_SDIO_HIQ_REFILL_INTERVAL (HZ / 10)
> >  +#define RTW_SDIO_HIQ_BUDGET_MAX 16
> >=20=20
>=20>  static bool rtw_sdio_is_bus_addr(u32 addr)
> >  {
> >  @@ -1299,6 +1303,64 @@ static void rtw_sdio_8723bs_wake_tx_queue(str=
uct rtw_dev *rtwdev,
> >  ieee80211_wake_queue(rtwdev->hw, q_map);
> >  }
> >=20=20
>=20>  +static bool rtw_sdio_bmc_needs_dtim(struct sk_buff *skb)
> >  +{
> >  + struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> >  + struct udphdr *udphdr;
> >  +
> >  + if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
> >  + return true;
> >  +
> >  + if (skb->protocol =3D=3D htons(ETH_P_ARP))
> >  + return true;
> >  +
> >  + if (skb->protocol =3D=3D htons(ETH_P_IP) &&
> >  + ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) {
> >  + udphdr =3D udp_hdr(skb);
> >  +
> >  + return udphdr->dest =3D=3D htons(67) || udphdr->dest =3D=3D htons(=
68);
> >  + }
> >  +
> >  + return false;
> >  +}
> >=20
>=20This is totally the same as USB. To share with USB, move it to tx.c=
=20
>=20as an export function or to tx.h as an inline function.
>=20

I=20am aware of that, but ai wasn't sure what is preferred approach so I
resorted to changing as little shared code as possible to mitigate the
risk of regression on other drivers. I will make it shared between USB
and SDIO.

> >=20
>=20> +
> >  +static bool rtw_sdio_hiq_take_budget(struct rtw_sdio *rtwsdio)
> >  +{
> >  + unsigned long flags, elapsed, add;
> >  + bool ok;
> >  +
> >  + spin_lock_irqsave(&rtwsdio->hiq_lock, flags);
> >  +
> >  + elapsed =3D jiffies - rtwsdio->hiq_refill;
> >  + add =3D elapsed / RTW_SDIO_HIQ_REFILL_INTERVAL;
> >  + if (add) {
> >  + rtwsdio->hiq_budget =3D min_t(unsigned long,
> >  + rtwsdio->hiq_budget + add,
> >  + RTW_SDIO_HIQ_BUDGET_MAX);
> >  +
> >  + /* keep the unfinished part of the interval for the next unit */
> >  + rtwsdio->hiq_refill =3D jiffies -
> >  + elapsed % RTW_SDIO_HIQ_REFILL_INTERVAL;
> >  + }
> >  +
> >  + ok =3D rtwsdio->hiq_budget > 0;
> >  + if (ok)
> >  + rtwsdio->hiq_budget--;
> >  +
> >  + spin_unlock_irqrestore(&rtwsdio->hiq_lock, flags);
> >  +
> >  + return ok;
> >  +}
> >=20
>=20This is also the same as USB. Please consider how to share the logic.
>

Same as above.

Best regards,
Luka Gejak
