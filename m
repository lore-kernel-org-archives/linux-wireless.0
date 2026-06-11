Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB829C328;
	Thu, 11 Jun 2026 14:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781188197; cv=none; b=mHzw3Yv0F0XDBoC7UGd4dU6GNz8DGx/++nz8YIGGCdSA0onh8c3v9HOzqPKYoeyjetQDWdm/5Y6SJsk9MjEsDF7tvW21XZhCFuUqA9VoSNlRH4gYMgPtDL26av1OgWBuJvlQUFLG4lhXj/xXo6oLPudrxTJ+vKVuoaC2IidnL4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781188197; c=relaxed/simple;
	bh=5PLKPAmVaLvUJC4z5tkbTyARHNTEluXPAGsDGR03CFQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eWGuTXjcJ1QrRSkpGWNzK36KOMaxVHD+En8SNrdEF24yoc+Bnd7UTmCmD0UDN+JX/j5MqMdMj5mQ4qC6tLenmMN8+/ahn0ASWKo5OU2d1J82Rn1UvkKrdevUWyIn55rbmnpbnZ2lkTs0Kb3ibqYhevBVopYOPrLFV/ZPs7yLMdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: xiaoblac <teel4res@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, Cheng
 Yongkang <teel4res@gmail.com>,
 syzbot+50122cbc2874b1eb25b0@syzkaller.appspotmail.com
Subject: Re: [PATCH] wifi: ath9k: hif_usb: don't dereference hif_dev after
 re-arming firmware request
In-Reply-To: <20260605153210.20471-1-1020691186@qq.com>
References: <20260605153210.20471-1-1020691186@qq.com>
Date: Thu, 11 Jun 2026 16:29:45 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h5n98812.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

xiaoblac <teel4res@gmail.com> writes:

> From: Cheng Yongkang <teel4res@gmail.com>
>
> ath9k_hif_request_firmware() re-arms an asynchronous firmware load via
> request_firmware_nowait(), passing hif_dev as the completion context, and
> then still dereferences hif_dev:
>
> 	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
> 		 hif_dev->fw_name);
>
> The re-armed callback ath9k_hif_usb_firmware_cb() runs on the "events"
> workqueue and, when the firmware is missing, walks the retry chain into
> ath9k_hif_usb_firmware_fail() -> complete_all(&hif_dev->fw_done). That
> releases the wait_for_completion(&hif_dev->fw_done) in a concurrent
> ath9k_hif_usb_disconnect(), which then kfree()s hif_dev. The trailing
> dev_info() in the frame that re-armed the request can therefore read freed
> memory (hif_dev->udev, the first field of struct hif_device_usb):
>
>   BUG: KASAN: slab-use-after-free in ath9k_hif_request_firmware
>   Read of size 8 ... by task kworker/...
>    ath9k_hif_request_firmware
>    ath9k_hif_usb_firmware_cb           drivers/net/wireless/ath/ath9k/hif=
_usb.c:1247
>    request_firmware_work_func
>   Allocated by ...:
>    ath9k_hif_usb_probe                 drivers/net/wireless/ath/ath9k/hif=
_usb.c
>   Freed by ...:
>    ath9k_hif_usb_disconnect -> kfree   drivers/net/wireless/ath/ath9k/hif=
_usb.c
>
> The fw_done barrier only makes disconnect wait for the firmware chain to
> *terminate*; it does not protect the outer ath9k_hif_request_firmware()
> frame that re-armed the request and keeps touching hif_dev afterwards.
>
> Drop the post-request dev_info(): it is the only use of hif_dev after the
> async request is armed, and it is purely informational (the dev_err() on =
the
> failure path runs only when request_firmware_nowait() did not arm a callb=
ack,
> so hif_dev is still alive there).
>
> This was first reported by syzbot as a single, non-reproduced crash that =
was
> later auto-obsoleted, and was independently rediscovered by the reFuzz fu=
zzer,
> which produced a C reproducer (USB-gadget connect/disconnect of an ath9k_=
htc
> device whose firmware download fails). The vulnerable code is unchanged a=
nd
> still present in v7.1-rc6, where the slab-use-after-free reproduces under=
 KASAN
> once the (sub-microsecond) race window is widened.
>
> Fixes: e904cf6fe230 ("ath9k_htc: introduce support for different fw versi=
ons")
> Reported-by: syzbot+50122cbc2874b1eb25b0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D50122cbc2874b1eb25b0
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>

Thank you for the fix!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
