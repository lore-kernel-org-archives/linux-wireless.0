Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EAE3AA4F9;
	Mon, 12 Oct 2026 06:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791788264; cv=none; b=t/OnH5rH8cIWsdFEx5ldRNwbDaXwNEf7KqXweuiHP1nX1HmwlV+eSU8brjsdJ0Uyk+eEUNB1D/OqdykretkePShIb0R09QMqXIfKzvv8YXh3Wv58lh710SCTNdGNfGZh98xwBomPmXeSXNwmNILgIaHHvHVFHRac5KCYxBmVFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791788264; c=relaxed/simple;
	bh=2//hsG2ASG+SOjFfmqUmO0IJZscTecI7U34WvEQD3tA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bjl5uCaIXCEbpvdHakmvGc1p8BfiRIxoiuXhrfo6iL+Z1tH258yfs5xSBf9ozdFSqXnSZyeJlicjr8+Dg6q8cdVflyDZNm5g62KHBnKITvgqk14AjlzZ9CCUfuXf59PUu6cvjYdi8EFnbzKak772wJnuffZMZb9HX22EYbxs3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=c9g5WtiP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="c9g5WtiP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C6vaurF3601906, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791788256; bh=ITAwO6bSVBBorf+/fgp6dadtAlpocmVzUtr68bnFlPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=c9g5WtiPlxkPlCgSenzTRJQhH3XA5ntQe6YzpFaIoOmpjpXEjEFOGZL5fjOaoj27C
	 Z/zQmEmvn9lSfAklCsHuaSotEmRV2MKvAqPIVNRQ+HyiqKUIuyn0JI/pSaWSxg02bQ
	 xp31rAmIqA/vA0GBELgC2cPjhUxz50Df56+o/Klf2/JiP4kRzPXxY7PjOgH/Ud/fnH
	 XnwDuYjAnYNIA1s1twzFOgI/siJWNqoBkcGdHg1eGHDYDSee3MNmc+9Px9RkogRHOn
	 hShl6OlGdxRRe+sRxZ8Y1Wiwu0yuJo9LzKOANl4l1FREm9BTgy7yVqH15LQaDs+2Gy
	 W11bL+0fIUVuA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C6vaurF3601906
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 14:57:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 14:57:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 14:57:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 14:57:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the
 rings are reset
Thread-Topic: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when
 the rings are reset
Thread-Index: AQHdWO4MPV0dG/pKrEyzZWvhd4YBNrb5eb7A
Date: Mon, 12 Oct 2026 06:57:44 +0000
Message-ID: <02b86ed0d0814f009cb5ca83bae343c7@realtek.com>
References: <20261010193136.294816-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261010193136.294816-1-abdurrahmankaradag19@gmail.com>
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> When a TX ring fills, rtw_pci_tx_write() stops the mac80211 queue and
> records that in ring->queue_stopped, which is cleared only by the
> completion loop in rtw_pci_tx_isr(). Resetting the rings rewinds the
> indices, so nothing that was in flight can complete and run that loop,
> and the queue stays stopped over a ring that is now empty.
> ieee80211_restart_hw() does not release that stop either, because
> ieee80211_reconfig() wakes only IEEE80211_QUEUE_STOP_REASON_SUSPEND.

The main reason why we need this patch is ieee80211_restart_hw(), so
please point out this in subject.=20

>=20
> Release those queues where the reset happens. The stop side is the one
> that matters: rtw_fw_recovery() reaches rtw_pci_dma_release() through
> rtw_enter_ips() before it calls ieee80211_restart_hw(), so that is
> where a queue stopped before the crash is still stopped. By the time
> rtw_pci_setup() runs the flag is already clear.
>=20
> Wake all the queues, but only if at least one ring had filled. This
> cannot tell one DRIVER stop from another: rtw_pci_io_err_detected() and
> the hardware scan paths in fw.c stop every queue with the same
> IEEE80211_QUEUE_STOP_REASON_DRIVER, which mac80211 keeps as a single
> non-refcounted slot per queue. Gating on ring->queue_stopped at least
> keeps the resets that stopped nothing out of it.
>=20
> On an RTL8821CE, a BE ring held until rtw_pci_tx_write() stopped its
> queue did not come back from the restart. The ring itself was reset -
> 0x3a8 read 0x00000000 and REG_TXPAUSE was clear again - but BE's
> mac80211 stop reason still read 0x1 three minutes later and TX never
> resumed. With this patch it reads 0x0 and TX resumes within 2 s. The
> ring was filled by writing REG_TXPAUSE 0x0f from debugfs under load,
> and rtw_fw_recovery() was called from a debug build.

This isn't related to this patch, but it is still digging, so no need.

As I see, the commit message can be very simple -- wake up queues for
ieee80211_restart_hw() case.

(For the analysis in another mail, I'll read it later.)

>=20
> Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
> ---
> v2:
>  - wake with ieee80211_wake_queues() instead of recording and replaying
>    per-ring queue mappings (Ping-Ke Shih)
>  - drop the Fixes tag: the bug only bites once a recovery path exists,
>    which the blamed commit predates (Ping-Ke Shih)
>  - cut the commit message down to why and how (Ping-Ke Shih)
>  - say which of the two reset call sites fires during recovery, and
>    that the measured stall was induced from debugfs
>  - patch 2 of the v1 series is dropped rather than resent, while the
>    cause of the stall is still open
>=20
> v1: https://lore.kernel.org/linux-wireless/20261002231013.11792-1-abdurra=
hmankaradag19@gmail.com/
>=20
>  drivers/net/wireless/realtek/rtw88/pci.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index 66d2e5f..4d3524e 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -475,7 +475,29 @@ static void rtw_pci_reset_buf_desc(struct rtw_dev *r=
twdev)
>=20
>  static void rtw_pci_reset_trx_ring(struct rtw_dev *rtwdev)

I'm thinking if here is too early to wake up queues. Should we do this in
rtw_reconfig_complete()?

Or we check flag RTW_FLAG_RESTARTING of rtwdev->flags to wake up queues.
This will be clear why we need to wake up. The comment isn't necessary
by the way.

>  {
> +       struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> +       enum rtw_tx_queue_type queue;
> +       bool wake =3D false;
> +
>         rtw_pci_reset_buf_desc(rtwdev);
> +
> +       /*
> +        * The indices are back at zero, so nothing that was in flight ca=
n
> +        * complete and reach the wake in rtw_pci_tx_isr(); a queue stopp=
ed
> +        * when its ring filled would stay stopped for good. Only wake wh=
en
> +        * that happened: the stop reason is shared with the AER and scan
> +        * paths, which wake the queues again themselves.
> +        */
> +       for (queue =3D 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
> +               if (!rtwpci->tx_rings[queue].queue_stopped)
> +                       continue;
> +
> +               rtwpci->tx_rings[queue].queue_stopped =3D false;
> +               wake =3D true;
> +       }
> +
> +       if (wake)
> +               ieee80211_wake_queues(rtwdev->hw);
>  }
>=20
>  static void rtw_pci_enable_interrupt(struct rtw_dev *rtwdev,
> --
> 2.55.0
>=20
> base-commit: 83de3a16c7b37064a59305040ba9b0f93b832794
