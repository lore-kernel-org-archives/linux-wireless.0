Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39364 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab0FEHEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 03:04:25 -0400
Received: by wyi11 with SMTP id 11so1350862wyi.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 00:04:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275693948-3189-2-git-send-email-notasas@gmail.com>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	<1275693948-3189-2-git-send-email-notasas@gmail.com>
Date: Sat, 5 Jun 2010 10:04:24 +0300
Message-ID: <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Kalle Valo <kvalo@adurom.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 June 2010 02:25, Grazvydas Ignotas <notasas@gmail.com> wrote:
> Reading the ELP_CTRL register with sdio_readb causes problems because
> hardware seems to be performing a write using stuff bits in the request
> (those bits contain write data in write request). This indicates that it
> actually expects RAW (read after write) type of request, so perform that
> when reading ELP_CTRL instead. Also cache last written value so we know
> what to write when doing RAW request.
>
> Because of the above it was not possible to wake the chip from ELP power
> saving mode, PM had to be disabled to have the driver usable in SDIO
> mode. After this patch PM is functional.

Excellent that Power Save is now working SDIO. Thank you very much!

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

> this patch is not suitable for backporting because reqiured SDIO function
> was only merged during the last merge window.

Usually information like this is good to store in the commit log
itself so that it gets properly archived.

Kalle
