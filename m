Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36418 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdHEFvQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 01:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B364144B7@DFRE01.ent.ti.com>
References: <1501490529-3360-1-git-send-email-eyalr@ti.com> <8665E2433BC68541A24DFFCA87B70F5B364144B7@DFRE01.ent.ti.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 5 Aug 2017 15:50:54 +1000
Message-ID: <CAGRGNgVk=W7C8NYUYxrazkYBphQhFeZc96ZxORCLqE1fpW6Z=w@mail.gmail.com> (sfid-20170805_075131_397641_E046ACB2)
Subject: Re: [v4] wlcore: add missing nvs file name info for wilink8
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eyal,

On Mon, Jul 31, 2017 at 6:45 PM, Reizer, Eyal <eyalr@ti.com> wrote:
> The following commits:
> c815fde wlcore: spi: Populate config firmware data
> d776fc8 wlcore: sdio: Populate config firmware data
>
> Populated the nvs entry for wilink6 and wilink7 only while it is
> still needed for wilink8 as well.
> This broke user space backward compatibility when upgrading from older
> kernels, as the alternate mac address would not be read from the nvs that
> is present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin)
> causing mac address change of the wlan interface.
>
> This patch fix this and update the structure field with the same default
> nvs file name that has been used before.
>
> In addition, some distros hold a default wl1271-nvs.bin in the file
> system with a bogus mac address (deadbeef...) that for a wl18xx device
> also overrides the mac address that is stored inside the device.
> Warn users about this bogus mac address and use a random mac instead
>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> ---
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 60aaa85..7ce4221 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5961,6 +5961,22 @@ static void wl12xx_derive_mac_addresses(struct wl1271 *wl, u32 oui, u32 nic)
>         if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr > 0xffffff)
>                 wl1271_warning("NIC part of the MAC address wraps around!");
>
> +       if (oui == 0xdeadbe && nic == 0xef0000) {
> +               wl1271_warning("Detected unconfigured mac address in nvs.\n"
> +                               "Using a random TI mac address instead.\n"
> +                               "in case of using a wl12xx device, your "
> +                               "device performance may not be optimized.\n"
> +                               "Please use the calibrator tool to configure "
> +                               "your device.\n"
> +                               "When using a wl18xx device the nvs file can "
> +                               "be removed as a default mac address is "
> +                               "stored internally.\n");
> +
> +               /* Use TI oui and a random nic */
> +               oui = 0x080028;

Is there (or should there be) a constant for this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
