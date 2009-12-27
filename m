Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:8083 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZL0I20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2009 03:28:26 -0500
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1251: timeout one too soon in wl1251_boot_run_firmware()
References: <4B3664AF.6090302@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 27 Dec 2009 10:28:21 +0200
In-Reply-To: <4B3664AF.6090302@gmail.com> (Roel Kluin's message of "Sat\, 26 Dec 2009 20\:31\:59 +0100")
Message-ID: <87pr60yg62.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roel Kluin <roel.kluin@gmail.com> writes:

> `loop' reaches INIT_LOOP + 1 after the loop. so if ACX_INTR_INIT_COMPLETE
> occurs in the last iteration the write occurs but also the error out as if a
> timeout occurred. This is probably very unlikely to ever occur.

Thank you for fixing this.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Kalle Valo <kalle.valo@nokia.com>

I think John can take this. As Roel mentioned, this is nothing
critical and, if needed, can wait until 2.6.34.

-- 
Kalle Valo
