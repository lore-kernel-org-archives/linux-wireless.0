Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED053EFD04;
	Tue, 28 Jul 2026 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785242962; cv=none; b=X0+73UqfPI392NkmrRhoaPXuBW2AqUu17SJcvyuzVKmyE8n0eK3IjK4zjVbpWnOajKH5tN2VotOapeHPUDIPCAFgJMInz35BtGK6I7uXGxXUMVugGf1kgAXQ/M3DPn+fZSyjdMPAoq9R/oaMmnl7r+5uKbft5B1aqdJ90Sf/pC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785242962; c=relaxed/simple;
	bh=hc8HYMdrv3LN2GHAKbwlHfYMBI9RnBjjdcUE/t9grww=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RMFVDQnV/0jR6N+GtCqGw/1xDduAuUTJXLkgWfR33nS4ay5botPuh/INHuNs8aofnCl3282rwGCwOY6ml5K/n/P91pv2ozwJQd5kAQn1gYNmb7efCwGkvJ0yzG1S3F09/XpXZCrAJfNQz177VGa9dNKZXost6/dZazt+2Q3C1+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=MZfQ3Jeo; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="MZfQ3Jeo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1785242929; x=1785847729; i=spasswolf@web.de;
	bh=UW7o/A9J07VGYitmgHvVGF2qC5fJYxQwmH4m2PBc4UA=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=MZfQ3JeolFar5HpO2zi0UXB8SPQ/V6fuUznmMlnoDLnzjr/hyhIqv577wnaZZZ+j
	 TQC8BZmQR8jWTEYg2XDz5cqv2bl1nrQjYxayl1oJe9WPHDAwWaFL1oq2GwqA/Smxz
	 18/imalfZGEnwhjKw1kUjRr/xZ6Kt1Nr0ci6tbkoZJh4ijxcorEZ1eY+PZaULg9qN
	 wFRSfFQxO3/5V85tE/neHTdKe1pZBRCRWbWCMuKc5fz4VM9zAMCGxIYPPZTxi4H1+
	 K9csS6sQwZSea6EW8FVwNP7maVCdOpHu9HvCc1YS3mgMNvVT/qN07hTSk2bunyR1r
	 4TGwqxSgptkSdcu5iw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MTvw0-1wOsuh2fv0-00Jzqn; Tue, 28
 Jul 2026 14:48:49 +0200
Message-ID: <ae8f803765f06e0ea1968397338129bdd9766c4f.camel@web.de>
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable()
 in unregister path
From: Bert Karwatzki <spasswolf@web.de>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, 
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang	 <sean.wang@mediatek.com>, Nicolas Cavallari	
 <nicolas.cavallari@green-communications.fr>, linux-kernel@vger.kernel.org, 
	spasswolf@web.de
Date: Tue, 28 Jul 2026 14:48:45 +0200
In-Reply-To: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.56.2-10 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cXriqMZ9RuH1unZUbyy5nHJjGZ/IHOG/5DjevMf+afNqIftfc97
 EdLjcNJGUm0VjUSYFEVsPOU3MAr1GdEmeLUgAgZNqATmZrt/oLmC91tBVvy5I/jSr0MQetz
 feLcg432D0sN9T5vON4v+nKA7cy4xmdQ4fOGqrYZP7O93dEfvWxOMAhDoXLdRiuP6O0DqTI
 khKd3lPEi8zbN6QlWGW9A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yTSbpMdGmWY=;+C0vtjTWPpW7CcG+ZsHeDXMbWPM
 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

Am Dienstag, dem 28.07.2026 um 05:20 +0500 schrieb Mikhail Gavrilov:
> Commit 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
> made mt76_dma_cleanup() disable every RX NAPI instance before deleting
> it.  mt7921e_unregister_device() and mt7925e_unregister_device() already
> disable the very same instances and only afterwards call
> mt792x_dma_cleanup() -> mt76_dma_cleanup(), so each instance is now
> disabled twice.
>=20
> napi_disable() is not idempotent: on return it leaves NAPIF_STATE_SCHED
> and NAPIF_STATE_NPSVC set, so a second call without an intervening
> napi_enable() spins in usleep_range() forever, waiting for bits that
> nobody will clear:
>=20
>   task:modprobe        state:D stack:25720 pid:7954  tgid:7954
>   Call Trace:
>    <TASK>
>    __schedule+0x11b8/0x26d0
>    schedule+0xe7/0x2f0
>    schedule_hrtimeout_range_clock+0x218/0x330
>    usleep_range_state+0x133/0x1b0
>    napi_disable_locked+0x37d/0x5f0
>    napi_disable+0x43/0x80
>    mt76_dma_cleanup+0x2b4/0x860 [mt76]
>    mt7921_pci_remove+0x17f/0x350 [mt7921e]
>    pci_device_remove+0xb6/0x1e0
>    device_release_driver_internal+0x38d/0x540
>    driver_detach+0xd0/0x1b0
>    bus_remove_driver+0x127/0x2d0
>    pci_unregister_driver+0x2a/0x280
>    __do_sys_delete_module+0x36a/0x5b0
>    do_syscall_64+0x11c/0x6d0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
>=20
> mt7921_pci_shutdown() and mt7925_pci_shutdown() reuse the remove path,
> so the same deadlock is hit on every reboot and poweroff.  It is silent:
> the stuck task keeps sleeping and rescheduling, so neither the hung task
> detector nor the lockup detectors fire, and the last line on the console
> is "systemd-shutdown[1]: Rebooting."
>=20
> Drop the driver-side loops and rely on mt76_dma_cleanup() instead.
> mt792x_dma_cleanup() stops and resets the WFDMA engine before calling
> it, so RX is already quiesced when the NAPI instances are disabled
> there.
>=20
> Fixes: 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
> Reported-by: Bert Karwatzki <spasswolf@web.de>
> Closes: https://lore.kernel.org/all/20260724151419.26014-1-spasswolf@web=
.de/
> Suggested-by: Nicolas Cavallari <nicolas.cavallari@green-communications.=
fr>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---
>=20
> I hit the same hang on an ASRock B650I Lightning WiFi with MT7922
> (mt7921e) and bisected it to the same commit.  mt7921e has the same
> duplicated napi_disable() as mt7925e, so this covers both; it is
> Nicolas' suggestion from [1] extended to mt7921e and with the now
> unused 'int i' removed.
> =20
> Tested on 7.2.0-rc5 with KASAN and lockdep enabled, MT7922 / mt7921e.
> Before the patch 'modprobe -r mt7921e' hangs (backtrace above, taken
> with sysrq-w) and the machine never gets past "Rebooting.".  With the
> patch 'modprobe -r mt7921e' and 'modprobe mt7921e' both complete and
> the interface comes back up, reboot and poweroff work again, and no
> __netif_napi_del_locked() or page_pool_disable_direct_recycling()
> warnings are logged.
> =20
> [1] https://lore.kernel.org/all/59c03ab1-ec4a-411b-9b7e-8183ecf3e02b@gre=
en-communications.fr/
>=20
>  drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 3 ---
>  drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 3 ---
>  2 files changed, 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/n=
et/wireless/mediatek/mt76/mt7921/pci.c
> index 7728c5ae6791..65d09d13304f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> @@ -43,7 +43,6 @@ static int mt7921e_init_reset(struct mt792x_dev *dev)
> =20
>  static void mt7921e_unregister_device(struct mt792x_dev *dev)
>  {
> -	int i;
>  	struct mt76_connac_pm *pm =3D &dev->pm;
>  	struct ieee80211_hw *hw =3D mt76_hw(dev);
> =20
> @@ -52,8 +51,6 @@ static void mt7921e_unregister_device(struct mt792x_de=
v *dev)
> =20
>  	cancel_work_sync(&dev->init_work);
>  	mt76_unregister_device(&dev->mt76);
> -	mt76_for_each_q_rx(&dev->mt76, i)
> -		napi_disable(&dev->mt76.napi[i]);
>  	cancel_delayed_work_sync(&pm->ps_work);
>  	cancel_work_sync(&pm->wake_work);
>  	cancel_work_sync(&dev->reset_work);
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/n=
et/wireless/mediatek/mt76/mt7925/pci.c
> index ea64303283ed..eb1bd60e3d9f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> @@ -36,7 +36,6 @@ static int mt7925e_init_reset(struct mt792x_dev *dev)
> =20
>  static void mt7925e_unregister_device(struct mt792x_dev *dev)
>  {
> -	int i;
>  	struct mt76_connac_pm *pm =3D &dev->pm;
>  	struct ieee80211_hw *hw =3D mt76_hw(dev);
> =20
> @@ -45,8 +44,6 @@ static void mt7925e_unregister_device(struct mt792x_de=
v *dev)
> =20
>  	cancel_work_sync(&dev->init_work);
>  	mt76_unregister_device(&dev->mt76);
> -	mt76_for_each_q_rx(&dev->mt76, i)
> -		napi_disable(&dev->mt76.napi[i]);
>  	cancel_delayed_work_sync(&pm->ps_work);
>  	cancel_work_sync(&pm->wake_work);
>  	cancel_work_sync(&dev->reset_work);

I tested this patch applied to next-20260727 with mt7925 and
rebooting works fine again.

Tested-By: Bert Karwatzki <spasswolf@web.de>

Bert Karwatzki
