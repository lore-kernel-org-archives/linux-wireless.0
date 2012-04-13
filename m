Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab2DMUmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 16:42:21 -0400
Received: by pbcun15 with SMTP id un15so4023279pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2012 13:42:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vcl3zlyn.wl%ysato@users.sourceforge.jp>
References: <87vcl3zlyn.wl%ysato@users.sourceforge.jp>
Date: Fri, 13 Apr 2012 13:42:19 -0700
Message-ID: <CAJ-VmombnFXKy9Px2CQ_5EWrsrwTvRnpCcWUoeiphBQtdKfu2A@mail.gmail.com> (sfid-20120413_224226_005359_42858769)
Subject: Re: Please add PCI id
From: Adrian Chadd <adrian@freebsd.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

0xff1b indicates the device wasn't correctly setup post power on.

So I'd try to find out exactly why that is.



Adrian


On 13 April 2012 08:32, Yoshinori Sato <ysato@users.sourceforge.jp> wrote:
> This device works fine of ath5k.
>
> Details bellow
> 05:00.0 0200: 168c:ff1b (rev 01)
> 05:00.0 Ethernet controller: Atheros Communications Inc. Device ff1b (rev 01)
>        Flags: bus master, fast devsel, latency 0, IRQ 19
>        Memory at febf0000 (64-bit, non-prefetchable) [size=64K]
>        Capabilities: <access denied>
>        Kernel driver in use: ath5k
>
> ath5k 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> ath5k 0000:05:00.0: setting latency timer to 64
> ath5k 0000:05:00.0: registered as 'phy0'
> ath: EEPROM regdomain: 0x67
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: 00
> ath: Regpair used: 0x67
> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
>
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
>
> diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
> index eaf79b4..1be418c 100644
> --- a/drivers/net/wireless/ath/ath5k/pci.c
> +++ b/drivers/net/wireless/ath/ath5k/pci.c
> @@ -44,6 +44,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
>        { PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
>        { PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
>        { PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
> +       { PCI_VDEVICE(ATHEROS, 0xff1b) }, /* AR5BXB63 */
>        { 0 }
>  };
>  MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
>
> --
> Yoshinori Sato
> <ysato@users.sourceforge.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
