Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8E03A1A29
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 05:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791523514; cv=none; b=CU8VyNpgyYOZerwobDlWJ+b036c66ajiiOT6F7hPc86PXk9yYgKIivTrbTo0+tDU7JD7Mor4k8XaROB57yWpRPXDPKSSimDhChmJImwJRW0EszCNzAHegrKKdjd9CDoSRcUKwCvDQyejJE+nb9W7tAVTxoUWvRfh8lwxvgFrjy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791523514; c=relaxed/simple;
	bh=vCRA6z0+O22kYjszQekiC91pS55Jw7SAcsG5OP6IGfM=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=Ev/Q5FdXDsKUrSxCIfnaVC9nS102BiFbtTzmY7R/tlvi2KPd0HaMkzn8gudiqVo3ZcWnDqMrFWvx/12gM7YQLwGxnT5yB+qBVpa/ivSREJvmpy6GfeMRmmDh2ZkFiN8GlsN/9snwAoaB6vT+h9iHwKV0wERbOfVbTgD7BFIDeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nzd/5pDP; arc=none smtp.client-ip=95.215.58.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nzd/5pDP"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vCRA6z0+O22kYjszQekiC91pS55Jw7SAcsG5OP6IGfM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791523509; v=1; x=1792128309;
 b=Nzd/5pDPuEi6LqXo1wEnFblKG/5k6PcQwBujtc03o16mrVleKXIFzuyxkWJ6TCQJ0b3BJ3et
 kKIbUfrHfEAcO1MT7mvPLEZQg5TP3hGaB6tayX5/JPGLsT7fvqSSjcmEoYWk2mHw/yr0vp0WMh/
 8fGZvathspHQa7GDZcW7aWYk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9c1baac040b1d3e5;
	Fri, 09 Oct 2026 05:25:08 +0000
X-Mizu-Trace-ID: 9c1baac040b1d3e5
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 09 Oct 2026 05:25:08 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <dd752e68eeb275bd2f7c616d9ddb08bd76d81ef7@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: rtw88: sdio: copy RX status after updating the
 frequency
To: "Hungyu Lin" <dennylin0707@gmail.com>, pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 phhuang@realtek.com, rtl8821cerfe2@gmail.com, johannes.berg@intel.com,
 u.kleine-koenig@baylibre.com
In-Reply-To: <20261009014941.29137-1-dennylin0707@gmail.com>
References: <20261009014941.29137-1-dennylin0707@gmail.com>

October 9, 2026 at 3:49 AM, "Hungyu Lin" <dennylin0707@gmail.com> wrote:


>=20
>=20rtw_sdio_rx_skb() copies rx_status to the skb before calling
> rtw_update_rx_freq_for_invalid(). If the frequency is corrected, the sk=
b
> still carries the old value when it is passed to mac80211.
>=20
>=20Move the copy after the frequency update, as the PCI and USB RX paths
> already do.
>=20
>=20Fixes: 53ed4b25a79a ("wifi: rtw88: 8822c: Parse channel from IE to co=
rrect invalid hardware reports")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
> Built the rtw88 directory on arm64 with GCC 13.3.0 and W=3D1, with
> RTW88_8723BS, RTW88_SDIO, RTW88_PCI and RTW88_USB enabled.
>=20
>=20A userspace test of the old and new receive function, with helper cal=
ls
> stubbed, confirmed that the corrected frequency reaches skb->cb.
> No hardware testing.
>=20
>=20 drivers/net/wireless/realtek/rtw88/sdio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
>=20diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/=
wireless/realtek/rtw88/sdio.c
> index dc2fd0f8f9ff..7c22f0ba5329 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -1332,8 +1332,6 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwde=
v, struct sk_buff *skb,
>  u32 pkt_offset, struct rtw_rx_pkt_stat *pkt_stat,
>  struct ieee80211_rx_status *rx_status)
>  {
> - *IEEE80211_SKB_RXCB(skb) =3D *rx_status;
> -
>  if (pkt_stat->is_c2h) {
>  skb_put(skb, pkt_stat->pkt_len + pkt_offset);
>  rtw_fw_c2h_cmd_rx_irqsafe(rtwdev, pkt_offset, skb);
> @@ -1346,6 +1344,7 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwde=
v, struct sk_buff *skb,
>  rtw_update_rx_freq_for_invalid(rtwdev, skb, rx_status, pkt_stat);
>  rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
>=20=20
>=20+ *IEEE80211_SKB_RXCB(skb) =3D *rx_status;
>  ieee80211_rx_irqsafe(rtwdev->hw, skb);
>  }
>=20=20
>=20
> base-commit: 83de3a16c7b37064a59305040ba9b0f93b832794
> --=20
>=202.43.0
>

Looks good to me, I also found a preexisting issue while reviewing so
I'm sending a patch for that today.

Either way,

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
