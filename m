Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:61243 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3GDOc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 10:32:57 -0400
Received: by mail-qe0-f51.google.com with SMTP id a11so770541qen.38
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jul 2013 07:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA2E0674B@SC-VEXCH1.marvell.com>
References: <20130703015653.82651FAAD5@dev.laptop.org>
	<477F20668A386D41ADCC57781B1F70430EA2E0674B@SC-VEXCH1.marvell.com>
Date: Thu, 4 Jul 2013 08:32:56 -0600
Message-ID: <CAMLZHHSSfPnWK957Yd+vrLrsPHtUDW3b4ZxSjMe2SdpaQPk5hQ@mail.gmail.com> (sfid-20130704_163301_364431_2E82B6ED)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 4:39 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Followings are the actions taken for driver unload.
>
>    a) If device is connected, sync deauth command is sent.
>    b) Auto deep sleep is cancelled by sending sync command
>    c) Sync shutdown command is queued and HW_STATUS is changed to reset.
>    d) Now no other command gets queued based on HW_STATUS.
>    e) Wait for shutdown command response and handle it.
>    f) Set surprise_removed flag which blocks SDIO interrupts
>
> As per our design, we don't send any command to firmware after SHUTDOWN command. Also, firmware doesn't send any interrupt after SHUTDOWN command response.

I cannot see how the driver behaviour matches the above description
for when the card is removed as the system is suspended. For example I
cannot see where the SHUTDOWN command gets sent in such cases.

Also, at which point do we wait upon all async commands to complete
before shutting down? I walked through all the driver code in the
codepaths hit when the card is removed as the system is going into
suspend, and I found no such point. (This is why interrupts then
arrive later, because those commands are completing.)

Daniel
