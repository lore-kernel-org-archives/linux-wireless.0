Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63685 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0CLGgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 01:36:04 -0500
Received: by bwz1 with SMTP id 1so763198bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 22:36:03 -0800 (PST)
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/4] wl1251: fix ELP_CTRL register accesses when using SDIO
References: <1268322297-16667-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 12 Mar 2010 08:36:01 +0200
In-Reply-To: <1268322297-16667-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\, 11 Mar 2010 17\:44\:57 +0200")
Message-ID: <87vdd2cai6.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> For some unknown reason ELP_CTRL can't be accesed using
> sdio_memcpy_* functions (any attemts to do so result in timeouts):
>
>  wl1251: ERROR sdio write failed (-110)
>  wl1251: ERROR sdio read failed (-110)
>  wl1251: WARNING WLAN not ready

Yes, this is needed. A separate SDIO command is needed to wakeup the
chip from sleep.

> To fix this, add special IO functions for ELP_CTRL access that are
> using sdio_readb/sdio_writeb. Similar handling is done in TI
> reference driver from Android code drop.

Also wl1271 should behave similarly in this respect.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> Cc: Bob Copeland <me@bobcopeland.com>

Thanks, looks good.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
