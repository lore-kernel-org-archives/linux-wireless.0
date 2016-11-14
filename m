Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34879 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbcKNTkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 14:40:53 -0500
Received: by mail-pg0-f42.google.com with SMTP id p66so57319481pga.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 11:40:53 -0800 (PST)
Date: Mon, 14 Nov 2016 11:40:50 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Shengzhen Li <szli@marvell.com>
Subject: Re: [PATCH v3 01/11] mwifiex: check tx_hw_pending before downloading
 sleep confirm
Message-ID: <20161114194049.GA131593@google.com> (sfid-20161114_204058_636693_A21EDC31)
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit, Kalle,

On Fri, Nov 11, 2016 at 06:40:08PM +0530, Amitkumar Karwar wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> We may get SLEEP event from firmware even if TXDone interrupt
> for last Tx packet is still pending. In this case, we may
> end up accessing PCIe memory for handling TXDone after power
> save handshake is completed. This causes kernel crash with
> external abort.
> 
> This patch will only allow downloading sleep confirm
> when no tx done interrupt is pending in the hardware.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Tested-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: address format issues(Brain)
> RESEND v2(Applicable for complete patch series):
>     1) Fixed syntax issue "changelog not placed after the  Sign-offs"
>        pointed by Brian.
>     2) Dropped "[v2,03/12] mwifiex: don't do unbalanced free()'ing in
>        cleanup_if()" patch in this series. It was already sent by Brian
>        separately.
> v3: Same as RESEND v2.
> 
> Hi Kalle,
> 
> There are multiple mwifiex patches under review. I want you consider them
> in following sequence(first being oldest) to avoid conflicts

Thanks for doing this! It's a little confusing about what's outstanding
at the moment (and I think I was just confused on a review a bit ago; I
wasn't 100% sure what it was based on), so this listing helps.

If it helps, I'll put my comments here, since I've reviewed most of
these:

> [v3] mwifiex: report wakeup for wowlan

Reviewed, SGMT.

> mwifiex: add power save parameters in hs_cfg cmd

Didn't review. No comment.

> [2/2] mwifiex: ignore calibration data failure (Note: 1/2 has dropped)

Didn't review. But FWIW, Kalle expressed a preference for full series,
not partial.

> [v6] mwifiex: parse device tree node for PCIe

This one is marked Deferred in patchwork, and I had some comments about
it, since it introduced a double-free issue. I'd prefer it get fixed and
resent, and I expect Kalle is also waiting for this.

> [v2,1/3] mwifiex: Allow mwifiex early access to device structure
> [v2,2/3] mwifiex: Introduce mwifiex_probe_of() to parse common properties
> [v2,3/3] mwifiex: Enable WoWLAN for both sdio and pcie

You sent v3 for the above, and those LGTM (I provided my review). I was
probably also confused because they were based on the above "[v6]
mwifiex: parse device tree node for PCIe", which was not completely
correct.

> mwifiex: don't do unbalanced free()'ing in cleanup_if()
> mwifiex: printk() overflow with 32-byte SSIDs
> mwifiex: fix memory leak in mwifiex_save_hidden_ssid_channels()

I wrote or reviewed the above 3. LGTM.

> [v3,01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
> [v3,02/11] mwifiex: complete blocked power save handshake in main process
> [v3,03/11] mwifiex: resolve races between async FW init (failure) and device removal
> [v3,04/11] mwifiex: remove redundant pdev check in suspend/resume handlers
> [v3,05/11] mwifiex: don't pretend to resume while remove()'ing
> [v3,06/11] mwifiex: resolve suspend() race with async FW init failure
> [v3,07/11] mwifiex: reset card->adapter during device unregister
> [v3,08/11] mwifiex: usb: handle HS failures
> [v3,09/11] mwifiex: sdio: don't check for NULL sdio_func
> [v3,10/11] mwifiex: stop checking for NULL drvata/intfdata
> [v3,11/11] mwifiex: pcie: stop checking for NULL adapter->card

For this entire series, I looked over them again (and I wrote several in
the first place), so for all 11:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 5 +++--
>  drivers/net/wireless/marvell/mwifiex/init.c   | 1 +
>  drivers/net/wireless/marvell/mwifiex/main.h   | 1 +
>  drivers/net/wireless/marvell/mwifiex/pcie.c   | 5 +++++
>  4 files changed, 10 insertions(+), 2 deletions(-)
> 
[...] 
