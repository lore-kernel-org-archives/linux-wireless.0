Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41032 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeBUW7I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 17:59:08 -0500
Received: by mail-pl0-f67.google.com with SMTP id k8so1785647pli.8
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 14:59:08 -0800 (PST)
Date: Wed, 21 Feb 2018 14:59:05 -0800
From: Brian Norris <briannorris@chromium.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] mwifiex: support sysfs initiated device coredump
Message-ID: <20180221225903.GA42395@rodete-desktop-imager.corp.google.com> (sfid-20180221_235925_530958_429415D3)
References: <1519210220-22437-1-git-send-email-arend.vanspriel@broadcom.com>
 <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 21, 2018 at 11:50:19AM +0100, Arend van Spriel wrote:
> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> it is possible to initiate a device coredump from user-space. This
> patch adds support for it adding the .coredump() driver callback.
> As there is no longer a need to initiate it through debugfs remove
> that code.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +-------------------------
>  drivers/net/wireless/marvell/mwifiex/pcie.c    | 19 ++++++++++++++--
>  drivers/net/wireless/marvell/mwifiex/sdio.c    | 13 +++++++++++
>  drivers/net/wireless/marvell/mwifiex/usb.c     | 14 ++++++++++++
>  4 files changed, 45 insertions(+), 32 deletions(-)

The documentation doesn't really say [1], but is the coredump supposed
to happen synchronously? Because the mwifiex implementation is
asynchronous, whereas it looks like the brcmfmac one is synchronous.

Brian

[1] In fact, the ABI documentation really just describes kernel
internals, rather than documenting any user-facing details, from what I
can tell.
