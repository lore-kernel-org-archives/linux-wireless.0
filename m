Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284526FA60;
	Fri, 14 Aug 2026 03:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786679713; cv=none; b=KEXq5A/AHh2MFwkmzCIbJ4YFYpdrEk82MZAaHusM3yCCoi7XJn4d4b9nX9Mrhd5KF/mKYoH58p3WJYelju/EzU/1Y4LrmfyUN9MZLk+Cv50+4OA7TMUYt0LMcprf49JvrScCaM1JoCwCT6BeRhHAz1lubtKMUg0Uh0SX8EDBwIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786679713; c=relaxed/simple;
	bh=zCaf5VtPHoo43dFQZPCYOKQ89RiW4slDnNGoYkUsjLs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIDhCKYQNYZrtZ6O+6jzmIGmUzWcpkFspqr0uTFBXncxNf2DngZNqC71PZ6IFRDka2Q31MmbLfpFMKDITbjTnapA6o1HnmKgSwnQIyysULbmfRsiJ12fopqM3nTRjEsuxNm0unEnSBL0pzBya38TJ6O5crMR3Hj69rW9piNE+c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pm4hoVRJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pm4hoVRJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E3t12q9917002, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786679701; bh=FTedUS80l6lqK19bGa+w1e+eWr6XNPedFc6NS7slH1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=pm4hoVRJACugFDHfcvLhNXXi+8QbvkbCln0WBwZ2tnu6FQNhv2//B+/u2X+Ao/cmW
	 l/T8qofmDDVtRkFx+zBSaf1ckLpbe1L36Lvkgydb+j/mFMOv4buXj4FR+z/e/sTZ7w
	 k45Ra+NJqE0Rf6i6Ek/gZj88dlmxts0+q5tATZngfP4NP/Nwi90WcMo//bp6pdgd8c
	 zS+Okju02h/M1OgI1mKIFP2mw4dHf+G1D0Ohc5oT3wUBvXx8em6+ReFfBGsIXTVcBc
	 /rj2xi8iJYx6ywqjI2pOFBGLiKSzf8Rr0WOhwPyWOcODgXAtGdJYwDX+NPCwsqXj6C
	 ev1BhsA/aArgA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E3t12q9917002
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 11:55:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 11:55:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 11:55:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v2] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Topic: [PATCH rtw-next v2] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Index: AQHdK2zi7yYmmS2eUEG9D6TCElwRkbac6ZiQ
Date: Fri, 14 Aug 2026 03:55:02 +0000
Message-ID: <50a9890ab9004e55bc58a56e157f2099@realtek.com>
References: <20260813214407.2438670-1-mehmet.fide@gmail.com>
In-Reply-To: <20260813214407.2438670-1-mehmet.fide@gmail.com>
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
> In AP mode every broadcast and multicast data frame is routed to
> TX_DESC_QSEL_HIGH, the after-DTIM queue, whether or not anybody is
> asleep. The firmware drains that queue at beacon pace, a dozen or so
> frames per second measured on RTL8822BU, while one associated client's
> mDNS/SSDP chatter alone exceeds that. The excess accumulates inside
> the chip until the shared TX page pool is exhausted (measured: 14 of
> 1803 pages left). From that point every host-sourced frame queues
> behind the backlog: authentication responses reach the air seconds
> after the client has given up, so no station can associate anymore,
> and the beacon reserved-page download fails the BCN_VALID poll
> ("error beacon valid") because it needs pages from the same pool. The
> AP keeps beaconing, so the failure looks like a silent RX stall and
> only a reboot recovers.
>=20
> mac80211 already decides when after-DTIM delivery is needed: it sets
> IEEE80211_TX_CTL_SEND_AFTER_DTIM on bmc frames only while at least one
> station is actually dozing. Honor that instead of routing
> unconditionally: flagged frames keep going through the high queue with
> the MORE_DATA and HGQMD handling introduced by commit 076f786a0ae1
> ("wifi: rtw88: Fix AP mode incorrect DTIM behavior"), everything else
> leaves at line rate through the AC queues. This partially reverts the
> usb.c hunk of that commit, whose unconditional routing is what lets
> the backlog build up.
>=20
> On a bench AP (USB2, 20 MHz, WPA2, hostapd, a Windows client driven
> through disconnect/reconnect cycles): reconnects fail 0/5 on RTL8822BU
> and 0/3 on RTL8821CU before this change, and pass 10/10 and 5/5 with
> it, with the page pool staying healthy and no beacon errors logged.
>=20
> Fixes: 076f786a0ae1 ("wifi: rtw88: Fix AP mode incorrect DTIM behavior")

As you said in v1, this is to fix different problem. Is it too strong to
point it as a Fixes?

> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> ---
> The flagged path is the code 076f786a0ae1 added and is unchanged by
> this patch; I did not have a client entering powersave on this bench
> to exercise it explicitly and will follow up with that measurement.
>=20
>  drivers/net/wireless/realtek/rtw88/usb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wirel=
ess/realtek/rtw88/usb.c
> index 64e1c3420..c0990c125 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -559,6 +559,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtw=
dev, u8 *buf, u32 size)
>=20
>  static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
>  {
> +       struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);

In reverse X'mas order.

>         struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
>         __le16 fc =3D hdr->frame_control;
>         u8 qsel;


