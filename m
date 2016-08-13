Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:36645 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751975AbcHMA2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 20:28:15 -0400
Message-ID: <1471048085.18251.25.camel@perches.com> (sfid-20160813_022842_467058_AB2D60B8)
Subject: Re: [PATCH] Modify is_zero_ether_addr() to handle byte-aligned
 addresses
From: Joe Perches <joe@perches.com>
To: Petri Gynther <pgynther@google.com>, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, davem@davemloft.net, akarwar@marvell.com
Date: Fri, 12 Aug 2016 17:28:05 -0700
In-Reply-To: <1471047330-8153-1-git-send-email-pgynther@google.com>
References: <1471047330-8153-1-git-send-email-pgynther@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-12 at 17:15 -0700, Petri Gynther wrote:
> $ iwconfig mlan0 essid MySSID
> [   36.930000] Path: /sbin/iwconfig
> [   36.930000] CPU: 0 PID: 203 Comm: iwconfig Not tainted 4.7.0 #2
> [   36.940000] task: 866f83a0 ti: 866a6000 task.ti: 866a6000
> [   36.940000]
> [ECR   ]: 0x00230400 => Misaligned r/w from 0x8677f403
> [   36.960000] [EFA   ]: 0x8677f403
> [   36.960000] [BLINK ]: mwifiex_scan_networks+0x17a/0x198c [mwifiex]
> [   36.960000] [ERET  ]: mwifiex_scan_networks+0x18a/0x198c [mwifiex]
> [   36.980000] [STAT32]: 0x00000206 : K         E2 E1
> [   36.980000] BTA: 0x700736e2   SP: 0x866a7d0c  FP: 0x5faddc84
> [   37.000000] LPS: 0x806a37ec  LPE: 0x806a37fa LPC: 0x00000000
> [   37.000000] r00: 0x8677f401  r01: 0x8668aa08 r02: 0x00000001
> r03: 0x00000000 r04: 0x8668b600 r05: 0x8677f406
> r06: 0x8702b600 r07: 0x00000000 r08: 0x8702b600
> r09: 0x00000000 r10: 0x870b3b00 r11: 0x00000000
> r12: 0x00000000
> [   37.040000]
> [   37.040000] Stack Trace:
> [   37.040000]   mwifiex_scan_networks+0x18a/0x198c [mwifiex]
> 
> Root cause:
> mwifiex driver calls is_zero_ether_addr() against byte-aligned address:
> 
> drivers/net/wireless/marvell/mwifiex/fw.h:
> struct mwifiex_scan_cmd_config {
>         /*
>          *  BSS mode to be sent in the firmware command
>          */
>         u8 bss_mode;
> 
>         /* Specific BSSID used to filter scan results in the firmware */
>         u8 specific_bssid[ETH_ALEN];
> 
>         ...
> } __packed;
> 
> drivers/net/wireless/marvell/mwifiex/scan.c:
> mwifiex_config_scan(..., struct mwifiex_scan_cmd_config *scan_cfg_out, ...)
>         ...
>         if (adapter->ext_scan &&
>             !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
>             ...
>         }
> 
> Since firmware-related struct mwifiex_scan_cmd_config cannot be changed,
> modify is_zero_ether_addr() to handle byte-aligned addresses.

Or add is_zero_ether_addr_unaligned and use it here.

> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Joe Perches <joe@perches.com>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Petri Gynther <pgynther@google.com>
> ---
>  include/linux/etherdevice.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 37ff4a6..0cfd243 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -90,11 +90,13 @@ static inline bool is_link_local_ether_addr(const u8 *addr)
>   * @addr: Pointer to a six-byte array containing the Ethernet address
>   *
>   * Return true if the address is all zeroes.
> - *
> - * Please note: addr must be aligned to u16.
>   */
>  static inline bool is_zero_ether_addr(const u8 *addr)
>  {
> +	if ((u32)addr & 0x1)
> +		return (addr[0] | addr[1] | addr[2] | addr[3] | addr[4] |
> +			addr[5]) == 0;
> +

So why skip the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
optimization below?

>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>  	return ((*(const u32 *)addr) | (*(const u16 *)(addr + 4))) == 0;
>  #else

How about adding:

static inline bool is_zero_ether_addr_unaligned(const u8 *addr)
{
#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
	return is_zero_ether_addr(addr);
#else
	return addr[0] | addr[1] | addr[2] | addr[3] | addr[4] | addr[5];
#endif
}

