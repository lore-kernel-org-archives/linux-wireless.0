Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EFD3115AE;
	Sun,  6 Sep 2026 03:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788666705; cv=none; b=urfSLa3GPHzgkCD+G3IZAPbqFOpUKaByhW4g3lmVvfvBbdPT/7DeI0IGrNz0+KvavpY7bsZteuZTHqs6NEjIFFKI25GadGf7/E/cHBMEnx3isI52HW8CuB8N8IxrUi33Vl2vm4gOiqZDKGme1QH65S5qARzTbMU3VprL9og2f0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788666705; c=relaxed/simple;
	bh=Nt5PaiDIwTwYf+0t6NVCmJT1Pw75nViElSrBgvhYpyU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jaMIJbT9qwkkQZcRzk+pm1vdX6zCT5zFYHAxvn856Ss7d4pD6An5gmqhP+txveBvNV3LwtIWb3Ea5uoSkqb3ptLSkhPGaS1FUYCG/LF/rk8eIm4CorRHPiKL1gDc0jZGBT1HCRts28cXxd01i2CuD2Bw3/KZV/tANRGOb/h+YeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=m6LaCvN8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="m6LaCvN8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6863pTnnD1629446, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788666689; bh=BDFuq09Zp1yIdLq9SEyvF3YRRkTErAAEj7NLO1duAvI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=m6LaCvN8VEpVeBRwobfMiW1xGpVk2vyDUSLPotjTAuvJxYar9edxIK5zmHeS1q+m7
	 O5utpPSM85mbC/lAkjGGr1EguoRij1TgJA+fhO2V3ffwKQFR8F9tSgZm4dNqEgSICG
	 f6vhv3Kc6z8NJ6BX/K66IwVoPx7nnBZz8l6+34b9ppR1Ni7k82krOzZystl7aY9UBp
	 Aaf3AtlOLRKBeKapvBmdtTKFc1xKpdJQfDgzwAgC85YRPdpkTMJSavXNt3na4mN2+6
	 zbORMdrLo4hnQTZQuiCzpgPdyoTqdqDoWJOcLBidvcxe0b639V/08pXg9PVAPZa+f9
	 s4wxE8G0tg2Ig==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6863pTnnD1629446
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 11:51:29 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 11:51:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 11:51:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 11:51:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next 2/2] wifi: rtw88: usb: only let the frames a
 dozing station needs use the after-DTIM queue
Thread-Topic: [PATCH rtw-next 2/2] wifi: rtw88: usb: only let the frames a
 dozing station needs use the after-DTIM queue
Thread-Index: AQHdOsert5gRS/9NF0+mONf/Vac2Z7bA7gkA
Date: Sun, 6 Sep 2026 03:51:29 +0000
Message-ID: <e0c709bd661044d799c3f04ec7348c4d@realtek.com>
References: <20260902104146.3853102-1-mehmet.fide@gmail.com>
 <20260902104146.3853102-3-mehmet.fide@gmail.com>
In-Reply-To: <20260902104146.3853102-3-mehmet.fide@gmail.com>
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
> With the budget in place the high queue can no longer take the chip
> down, but ordinary chatter still competes with the frames a sleeping
> station actually needs. mac80211 marks every broadcast and multicast
> frame with IEEE80211_TX_CTL_SEND_AFTER_DTIM while a station dozes,
> mDNS and SSDP included, so under normal traffic the budget is spent on
> frames nobody waits for.
>=20
> Do what the vendor driver does with its default "allow special" high
> queue filter: admit only ARP, EAPOL and DHCP to the after-DTIM path,
> the frames a station coming out of power save has to see; everything
> else goes out on its access category queue at line rate. Encrypted
> group frames carry the IV between the header and the SNAP header, so
> the parser accounts for hw_key->iv_len. With the filter in place the
> page pool stays at 1803 through the same 180 second storm, a DHCP
> flood still takes the after-DTIM path (and is then held by the budget),
> and join/ping cycling without power save is unchanged (10/10).
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> ---
>  drivers/net/wireless/realtek/rtw88/usb.c | 42 +++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wirel=
ess/realtek/rtw88/usb.c
> index 80965e5ea778..dd65b304b2c7 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -5,6 +5,9 @@
>  #include <linux/module.h>
>  #include <linux/usb.h>
>  #include <linux/mutex.h>
> +#include <linux/ip.h>
> +#include <linux/udp.h>
> +#include <linux/unaligned.h>

The existing is messed already. But could please put them in increasing
alphabet order? (only apply the part of '#include <linux/*')

>  #include "main.h"
>  #include "debug.h"
>  #include "mac.h"
> @@ -562,6 +565,43 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rt=
wdev, u8 *buf, u32 size)
>         return rtw_usb_write_data(rtwdev, &pkt_info, buf);
>  }
>=20
> +static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)
> +{
> +       struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +       struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
> +       unsigned int hdrlen =3D ieee80211_hdrlen(hdr->frame_control);
> +       unsigned int paylen =3D sizeof(rfc1042_header) + sizeof(__be16);

In reverse X'mas tree order. If you want keep 'struct' and 'unsigned int'
together individually. We can have

	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
	unsigned int paylen =3D sizeof(rfc1042_header) + sizeof(__be16);
	unsigned int hdrlen =3D ieee80211_hdrlen(hdr->frame_control);


> +       const struct udphdr *udp;
> +       const struct iphdr *ip;
> +       const u8 *snap;
> +       __be16 proto;
> +
> +       if (info->control.hw_key)
> +               hdrlen +=3D info->control.hw_key->iv_len;
> +
> +       if (skb->len < hdrlen + paylen)
> +               return false;
> +
> +       snap =3D skb->data + hdrlen;
> +       proto =3D get_unaligned((__be16 *)(snap + sizeof(rfc1042_header))=
);
> +
> +       if (proto =3D=3D htons(ETH_P_ARP) || proto =3D=3D htons(ETH_P_PAE=
))

Can we just 'skb->protocol =3D=3D htons(ETH_P_ARP)' ?

> +               return true;
> +
> +       if (proto !=3D htons(ETH_P_IP) || skb->len < hdrlen + paylen + si=
zeof(*ip))
> +               return false;
> +
> +       ip =3D (const struct iphdr *)(snap + paylen);
> +       if (ip->protocol !=3D IPPROTO_UDP)
> +               return false;
> +
> +       udp =3D (const struct udphdr *)((const u8 *)ip + ip->ihl * 4);
> +       if (skb->len < (unsigned int)((const u8 *)udp - skb->data) + size=
of(*udp))
> +               return false;

udphdr =3D udp_hdr(skb); ?

reference to rtw89_core_tx_btc_spec_pkt_notify().

> +
> +       return udp->dest =3D=3D htons(67) || udp->dest =3D=3D htons(68);
> +}
> +
>  #define RTW_USB_HIQ_RATE       10
>  #define RTW_USB_HIQ_BURST      16
>=20
> @@ -605,7 +645,7 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw=
_usb *rtwusb,
>         else if (is_broadcast_ether_addr(hdr->addr1) ||
>                  is_multicast_ether_addr(hdr->addr1))
>                 qsel =3D (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM)=
 &&
> -                      rtw_usb_hiq_take(rtwusb) ?
> +                      rtw_usb_bmc_needs_dtim(skb) && rtw_usb_hiq_take(rt=
wusb) ?
>                        TX_DESC_QSEL_HIGH : skb->priority;
>         else if (skb_get_queue_mapping(skb) <=3D IEEE80211_AC_BK)
>                 qsel =3D skb->priority;
> --
> 2.54.0

