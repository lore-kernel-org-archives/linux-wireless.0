Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34238 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932382AbcKPS6y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 13:58:54 -0500
Received: by mail-pg0-f49.google.com with SMTP id x23so79179857pgx.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 10:58:54 -0800 (PST)
Date: Wed, 16 Nov 2016 10:58:51 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Message-ID: <20161116185849.GA115729@google.com> (sfid-20161116_195859_563808_4D9B9626)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-5-git-send-email-akarwar@marvell.com>
 <20161025001405.GE15034@dtor-ws>
 <87d1imudwm.fsf@purkki.adurom.net>
 <20161102204537.GA27786@google.com>
 <271acd7f41694b09be6f4ad82846782a@SC-EXCH04.marvell.com>
 <20161109203710.GA118631@google.com>
 <ceb954280b8344328f305ab91d7c6155@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ceb954280b8344328f305ab91d7c6155@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:07:31PM +0000, Amitkumar Karwar wrote:
> I observed some crash issues while testing with PCIe/SDIO chipsets
> after removing user_rmmod. We are still checking them. I will not
> include user_rmmod removal patch in v3 series. Other pcie_work related
> global variables are removed in v3 series.

Sounds fine to me.

> Card is freed and recreated during mwifiex_sdio_card_reset_work(). It
> is one of the activities in sdio_work. So moving sdio_work inside card
> won't be straight forward.

That SDIO reset code is really crappy anyway, so this deserves some more
attention eventually. For instance, why does PCIe FLR have completely
different code structure? Also, the 'card' should really not be
reallocated every time. But anyway, that's not something to solve
immediately.

Brian
