Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:65397 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1BBWRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 17:17:52 -0500
Received: by pxi15 with SMTP id 15so92622pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 14:17:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D45B7BA.9080402@davizone.at>
References: <4D45A598.20709@davizone.at>
	<4D45B7BA.9080402@davizone.at>
Date: Thu, 3 Feb 2011 00:17:51 +0200
Message-ID: <AANLkTi=g7=0T1navJ5PDNxJQceFBHYFYpsdXWD4wMTCN@mail.gmail.com>
Subject: Re: [PATCH 03/18] wl1251: fix scan behaviour while not associated
From: Grazvydas Ignotas <notasas@gmail.com>
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 9:10 PM, David Gnedt <david.gnedt@davizone.at> wrote:
> With a dissacociated card I often encoutered very long scan delays.
>
> My guess is that it has something to do with the cards DTIM handling and
> another firmware bug mentioned in the TI WLAN driver, which is described as
> the card may never end scanning if the channel is overloaded because it
> can't send probe requests. I think the firmware somehow also tries to
> receive DTIM messages when the BSSID is not set. Therefore most of the time
> it waits for DTIM messages and can't do scanning work.
>
> Anyway we can workaround this misbehaviour by setting the HIGH_PRIORITY
> bit for scans in disassociated state.
>
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> ---
> Sorry for the partly broken patches, I thought I configured my client the
> right way. I tried to stop the mails at my mailserver, but it was mostly
> already too late.
> ---
>  drivers/net/wireless/wl1251/cmd.c  |   12 +++++++++++-
>  drivers/net/wireless/wl1251/cmd.h  |    5 +++++
>  drivers/net/wireless/wl1251/main.c |    1 +
>  3 files changed, 17 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/wl1251/cmd.c b/drivers/net/wireless/wl1251/cmd.c
> index 0ade4bd..4e4987d 100644
> --- a/drivers/net/wireless/wl1251/cmd.c
> +++ b/drivers/net/wireless/wl1251/cmd.c

<snip>

> +       /*
> +        * Use high priority scan when not associated to prevent fw issue
> +        * causing never-ending scans (sometimes 20+ minutes).
> +        * Note: This bug may be caused by the fw's DTIM handling.
> +        */
> +       if (is_zero_ether_addr(wl->bssid))
> +               cmd->params.scan_options |= WL1251_SCAN_OPT_PRIORITY_HIGH;

This seems to cause a build error (missing include?):
drivers/net/wireless/wl1251/cmd.c: In function 'wl1251_cmd_scan':
drivers/net/wireless/wl1251/cmd.c:455: error: implicit declaration of
function 'is_zero_ether_addr'
