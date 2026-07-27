Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1423EC6BE;
	Mon, 27 Jul 2026 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144491; cv=none; b=LkwPYmmrHIrPhZa+GdF4hP9SfRo3o7CTZbutyU+xDF9T+S3HJvSAGINNkGFpxfM4VIAuex9fRNFAas87GULXkftfZDLZRwQOLt/1ZVEu6IOijGnLwTGmB8n9bq9q844iQP49VdDvuJyjdBnuNQlrPYbdPrxkYS6MLTFatGP98BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144491; c=relaxed/simple;
	bh=esB0IiWiR6Wgvi1wBA5QlPq46Rp95CdR1ZiHKTfKfls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uQ5E2hc7VvKuQKl6oypaH7BAeRDr+dM+NmPxE1JDN+ceQ+/eqNzL15rEl3+4TkRX4J5fpL9HS3vlmCCOMceFl/+nDfqXC76GEQxAymyHwDUs9xQb7SQ5koRnTb8/U2um4A5P3l6EbCWIde8kbERIMC1uDebjMwN4pWB8LUUrwDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LdqcCBpV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LdqcCBpV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R9Rwc262991529, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785144478; bh=rHcc3S7KJ2GSwIdRLW+pDXm547M9mkbpKAaOAiuNdO0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LdqcCBpVnpNCv3V/NxG7Ig3sUk6B/BAhx/bkCS7Q7p0Ly5R99mmYy1saLv+fJ8bzu
	 a8ZuDPBVL3EsNWrGfWB3GtHSUJJ/SIG0/MxuTUmYFT4FhTzj9+CtkaTpy+BP6gp1k0
	 TVWCvtqkQW0RVnOgekMUH0Fmj+9fuD8xmh10CnT8etMb4qucRqPvMfwsYkpx+s9Jo4
	 0MUvRjeVT2EGl9w9kmmA21wodD1gc8FMd76FVwYLigDtyh7pJHZxBvj1AVMtoT8zr6
	 KAer638D2iVgNHpdUpkSxCCPaKqzbNl9kEocN6qvSfdxR7UOATx8C2cNog5jmtyjYD
	 jWTxdhosHIk0A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R9Rwc262991529
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 17:27:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 17:27:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 17:27:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 10/11] wifi: rtw88: record beacons from the target
 BSSID before authenticating
Thread-Topic: [PATCH v2 10/11] wifi: rtw88: record beacons from the target
 BSSID before authenticating
Thread-Index: AQHdHEb9omaK4tPWsECyYu3mPgnbkbaBGqYw
Date: Mon, 27 Jul 2026 09:27:58 +0000
Message-ID: <e3158b4edeb649839eb8063367a97a06@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-11-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-11-luka.gejak@linux.dev>
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
> The vendor start_clnt_join() does not begin authentication until it has
> seen a beacon or probe response from the target BSSID, and the RTL8723BS
> firmware depends on that ordering: authenticating earlier leaves the
> firmware without the BSS parameters it needs and the exchange times out.

I know vendor driver does wait for a beacon, but I don't think this can
affect connection. Could you confirm this again?

>=20
> Record such frames from the receive path so the join sequence can wait
> for one. The recording is gated on the chip and only active during the
> pre-authentication window, so it costs other chips a single test per
> frame.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 31 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/main.c     |  2 ++
>  drivers/net/wireless/realtek/rtw88/main.h     | 20 ++++++++++++
>  drivers/net/wireless/realtek/rtw88/sdio.c     |  5 +++
>  4 files changed, 58 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index b01b98d24b0a..ff0f4f0bdc7b 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -15,6 +15,37 @@
>  #include "wow.h"
>  #include "sar.h"
>=20
> +/* 8723BS SDIO: record a beacon/probe-resp seen from the target BSSID du=
ring
> + * the pre-auth window so the join sequence (mgd_prepare_tx) can wait fo=
r it,
> + * mirroring the vendor start_clnt_join(). Called from the SDIO RX path.
> + */

comment style.

> +void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
> +                           const struct ieee80211_hdr *hdr, u32 len,
> +                           const struct rtw_rx_pkt_stat *pkt_stat,
> +                           const struct ieee80211_rx_status *rx_status)
> +{
> +       struct rtw_auth_sync *sync =3D &rtwdev->auth_sync;
> +       unsigned long flags;
> +       __le16 fc =3D hdr->frame_control;

reverse X'mas tree=20

> +
> +       if (!rtw_is_8723bs(rtwdev) ||

Might caller ensure this?

> +           test_bit(RTW_FLAG_SCANNING, rtwdev->flags) ||
> +           pkt_stat->crc_err || pkt_stat->icv_err)
> +               return;
> +
> +       if (!ieee80211_is_beacon(fc) && !ieee80211_is_probe_resp(fc))
> +               return;
> +
> +       spin_lock_irqsave(&sync->lock, flags);
> +       if (sync->active && ether_addr_equal(hdr->addr3, sync->bssid)) {
> +               sync->seen =3D true;
> +               sync->seen_count++;
> +               wake_up(&sync->wait);
> +       }
> +       spin_unlock_irqrestore(&sync->lock, flags);
> +}
> +EXPORT_SYMBOL(rtw8723bs_auth_sync_rx);
> +
>  static void rtw_ops_tx(struct ieee80211_hw *hw,
>                        struct ieee80211_tx_control *control,
>                        struct sk_buff *skb)
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wire=
less/realtek/rtw88/main.c
> index cd9254370fcc..16228cae252e 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2174,11 +2174,13 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>=20
>         spin_lock_init(&rtwdev->txq_lock);
>         spin_lock_init(&rtwdev->tx_report.q_lock);
> +       spin_lock_init(&rtwdev->auth_sync.lock);
>=20
>         mutex_init(&rtwdev->mutex);
>         mutex_init(&rtwdev->hal.tx_power_mutex);
>=20
>         init_waitqueue_head(&rtwdev->coex.wait);
> +       init_waitqueue_head(&rtwdev->auth_sync.wait);
>         init_completion(&rtwdev->lps_leave_check);
>         init_completion(&rtwdev->fw_scan_density);
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wire=
less/realtek/rtw88/main.h
> index 8f86f7c12de5..4d3d1d99e305 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -2058,6 +2058,20 @@ struct rtw_hw_scan_info {
>         u8 op_bw;
>  };
>=20
> +/*
> + * Synchronises the pre-auth wait on a beacon or probe response from the
> + * target BSSID before the join sequence continues.
> + */
> +struct rtw_auth_sync {
> +       wait_queue_head_t wait;
> +       /* Protects the fields below. */
> +       spinlock_t lock;

I think you can use wait/completion. Then no need lock.=20

> +       u8 bssid[ETH_ALEN];
> +       bool active;
> +       bool seen;
> +       u32 seen_count;
> +};
> +
>  struct rtw_dev {
>         struct ieee80211_hw *hw;
>         struct device *dev;
> @@ -2134,6 +2148,8 @@ struct rtw_dev {
>         struct completion fw_scan_density;
>         bool ap_active;
>=20
> +       struct rtw_auth_sync auth_sync;
> +
>         bool led_registered;
>         char led_name[32];
>         struct led_classdev led_cdev;
> @@ -2291,4 +2307,8 @@ bool rtw_core_check_sta_active(struct rtw_dev *rtwd=
ev);
>  void rtw_core_enable_beacon(struct rtw_dev *rtwdev, bool enable);
>  void rtw_set_ampdu_factor(struct rtw_dev *rtwdev, struct ieee80211_vif *=
vif,
>                           struct ieee80211_bss_conf *bss_conf);
> +void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
> +                           const struct ieee80211_hdr *hdr, u32 len,
> +                           const struct rtw_rx_pkt_stat *pkt_stat,
> +                           const struct ieee80211_rx_status *rx_status);
>  #endif
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wire=
less/realtek/rtw88/sdio.c
> index 572b791249ed..b294bcc4d828 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -1203,6 +1203,11 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev=
, struct sk_buff *skb,
>         rtw_update_rx_freq_for_invalid(rtwdev, skb, rx_status, pkt_stat);
>         rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
>=20
> +       if (skb->len >=3D sizeof(struct ieee80211_hdr_3addr))
> +               rtw8723bs_auth_sync_rx(rtwdev,
> +                                      (struct ieee80211_hdr *)skb->data,
> +                                      skb->len, pkt_stat, rx_status);
> +
>         ieee80211_rx_irqsafe(rtwdev->hw, skb);
>  }
>=20
> --
> 2.55.0

