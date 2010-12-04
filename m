Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65445 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0LDBea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 20:34:30 -0500
Received: by iwn6 with SMTP id 6so548102iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 17:34:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291425653-2884-3-git-send-email-lrodriguez@atheros.com>
References: <1291425653-2884-1-git-send-email-lrodriguez@atheros.com> <1291425653-2884-3-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 3 Dec 2010 17:34:08 -0800
Message-ID: <AANLkTimd5ZKCWjDaVQcqx9t=_zoJC+UC5_4nkRQ-Uq8R@mail.gmail.com>
Subject: Re: [PATCH 2/3] ath9k: Fix power save count imbalance on ath_radio_enable()
To: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	pstew@google.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 3, 2010 at 5:20 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Upon a failure we never call ath9k_ps_restore() on ath_radio_enable(),
> this will throw off the sc->ps_usecount. When the sc->ps_usecount
> is > 0 we never put the chip to full sleep. This drains battery,
> and will also make the chip fail upon resume with:
>
> ath: Starting driver with initial channel: 5745 MHz
> ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
>
> This would make the chip useless upon resume.
>
> I cannot prove this can happen but in theory it is so best to
> avoid this race completely and not have users complain about
> a broken device after resume.
>
> Cc: stable@kernel.org
> Cc: Paul Stewart <pstew@google.com>
> Cc: Amod Bodas <amod.bodas@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

John, this one is for you, sorry I failed to send it to you. And
Johannes, sorry, I forgot to remove you from my send script :)

  Luis
