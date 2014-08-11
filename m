Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:46637 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHKIfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 04:35:53 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so8059675wev.26
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 01:35:52 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Aug 2014 16:35:52 +0800
Message-ID: <CAD8Lp47RrOtTKqKQirUwSbfsvqzuStc4TOWc8OXUYBzdjhJ_JA@mail.gmail.com> (sfid-20140811_103556_885636_D02108D9)
Subject: brcmfmac: command request size is determined by expected response size?
From: Daniel Drake <drake@endlessm.com>
To: brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Looking at brcmfmac in Linux 3.16 with a BCM43241 SDIO card, I noticed that
brcmf_construct_reginfo() constructs and submits a really large
(1.5kb) request to the card. However, the actual request seems really
small and trivial (a header, the word "chanspecs" and not much more),
and we end up sending a whole lot of zeroes to fill the 1.5kb
allocation (MEDLEN).

I can understand that the card may wish to send 1.5kb in response, but
does the request itself really need to be the same size?

Thanks
Daniel
