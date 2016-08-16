Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:32861 "EHLO
	mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbcHPRr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 13:47:29 -0400
Received: by mail-ua0-f177.google.com with SMTP id 74so134001427uau.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 10:47:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471057200-58166-2-git-send-email-pgynther@google.com>
References: <1471057200-58166-1-git-send-email-pgynther@google.com> <1471057200-58166-2-git-send-email-pgynther@google.com>
From: Petri Gynther <pgynther@google.com>
Date: Tue, 16 Aug 2016 10:47:18 -0700
Message-ID: <CAGXr9JFSUFr+mhyRnPk0pCeVsde4PUudZW+AZ44mKdT1iEpV6A@mail.gmail.com> (sfid-20160816_194750_695234_66EF8020)
Subject: Re: [PATCH 2/2] mwifiex: fix unaligned read in mwifiex_config_scan()
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, David Miller <davem@davemloft.net>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Petri Gynther <pgynther@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2016 at 8:00 PM, Petri Gynther <pgynther@google.com> wrote:
> $ iwconfig mlan0 essid MySSID
> [   36.930000] Path: /sbin/iwconfig
> [   36.930000] CPU: 0 PID: 203 Comm: iwconfig Not tainted 4.7.0 #2
> [   36.940000] task: 866f83a0 ti: 866a6000 task.ti: 866a6000
> [   36.940000]
> [ECR   ]: 0x00230400 => Misaligned r/w from 0x8677f403
> [   36.960000] [EFA   ]: 0x8677f403
> [   36.960000] [BLINK ]: mwifiex_scan_networks+0x17a/0x198c [mwifiex]
> [   36.960000] [ERET  ]: mwifiex_scan_networks+0x18a/0x198c [mwifiex]
> [   36.980000] [STAT32]: 0x00000206 : K         E2 E1
> [   36.980000] BTA: 0x700736e2   SP: 0x866a7d0c  FP: 0x5faddc84
> [   37.000000] LPS: 0x806a37ec  LPE: 0x806a37fa LPC: 0x00000000
> [   37.000000] r00: 0x8677f401  r01: 0x8668aa08 r02: 0x00000001
> r03: 0x00000000 r04: 0x8668b600 r05: 0x8677f406
> r06: 0x8702b600 r07: 0x00000000 r08: 0x8702b600
> r09: 0x00000000 r10: 0x870b3b00 r11: 0x00000000
> r12: 0x00000000
> [   37.040000]
> [   37.040000] Stack Trace:
> [   37.040000]   mwifiex_scan_networks+0x18a/0x198c [mwifiex]
>
> Root cause:
> mwifiex driver calls is_zero_ether_addr() against byte-aligned address:
>
> drivers/net/wireless/marvell/mwifiex/fw.h:
> struct mwifiex_scan_cmd_config {
>         /*
>          *  BSS mode to be sent in the firmware command
>          */
>         u8 bss_mode;
>
>         /* Specific BSSID used to filter scan results in the firmware */
>         u8 specific_bssid[ETH_ALEN];
>
>         ...
> } __packed;
>
> drivers/net/wireless/marvell/mwifiex/scan.c:
> mwifiex_config_scan(..., struct mwifiex_scan_cmd_config *scan_cfg_out, ...)
>         ...
>         if (adapter->ext_scan &&
>             !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
>             ...
>         }
>
> Since firmware-related struct mwifiex_scan_cmd_config cannot be changed,
> we need to use the new function is_zero_ether_addr_unaligned() here.
>
> This is v2 of the original patch:
> [PATCH] Modify is_zero_ether_addr() to handle byte-aligned addresses
>
> Per Joe's suggestion -- instead of modifying is_zero_ether_addr() --
> add is_zero_ether_addr_unaligned() and use it where needed.
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Joe Perches <joe@perches.com>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Petri Gynther <pgynther@google.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index bc5e52c..d648c88 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -883,7 +883,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>                        sizeof(scan_cfg_out->specific_bssid));
>
>                 if (adapter->ext_scan &&
> -                   !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
> +                   !is_zero_ether_addr_unaligned(
> +                               scan_cfg_out->specific_bssid)) {

Any comments? Is this approach of adding
is_zero_ether_addr_unaligned() fine? We already have similar routine
ether_addr_equal_unaligned().

I don't see much benefit making a local, aligned copy here. It would
have to use memcpy w/ byte operations anyways and then still run
is_zero_ether_addr().

Amitkumar -- Is it possible to modify struct mwifiex_scan_cmd_config
{} and align specific_bssid field to u16 boundary?

>                         bssid_tlv =
>                                 (struct mwifiex_ie_types_bssid_list *)tlv_pos;
>                         bssid_tlv->header.type = cpu_to_le16(TLV_TYPE_BSSID);
> --
> 2.8.0.rc3.226.g39d4020
>
