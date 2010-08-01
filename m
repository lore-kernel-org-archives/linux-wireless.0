Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44952 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0HAUeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 16:34:07 -0400
Received: by pvc7 with SMTP id 7so1130636pvc.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 13:34:07 -0700 (PDT)
Message-ID: <4C55DA66.3090507@lwfinger.net>
Date: Sun, 01 Aug 2010 15:34:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Cozatt <olbrannon@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: SMC 2802W -status unsupported
References: <AANLkTinU74hoPQ9tfZp12n_rQQX38OYy2qaETON-qGAu@mail.gmail.com>
In-Reply-To: <AANLkTinU74hoPQ9tfZp12n_rQQX38OYy2qaETON-qGAu@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2010 02:59 PM, David Cozatt wrote:
> ----snip--
> If I understand correctly, the device is working - only the wiki is wrong.
> 
> For my info, what does 'lspci -nnk | grep 2802' show?
> 
> Larry
> 
> ----/snip--
> random david # lspci -nnk | grep 2802
> 	Subsystem: Standard Microsystems Corp [SMC] SMC2802W Wireless PCI
> Adapter [10b8:2802]
> 
> One thing only bothers me not sure of wpa2 enough to know if it
> matters since I don't use the
> wireless-tools to connect but iwconfig reports-
> 
> wlan0     IEEE 802.11bg  ESSID:"Davespace"
>           Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1C:10:9C:32:87
>           Bit Rate=48 Mb/s   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=70/70  Signal level=-1 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> doesn't care? sinde we use wpa? on the enc off?

The encryption is being handled by mac80211, wpa_supplicant, and the device. The
"encryption key:off" should be ignored. The wireless extension tools such as
iwconfig are being phased out and do not always have the best information.

Looking at the driver code, we need the patch below to enable the device:

Index: wireless-testing/drivers/net/wireless/p54/p54pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54pci.c
+++ wireless-testing/drivers/net/wireless/p54/p54pci.c
@@ -43,6 +43,8 @@ static DEFINE_PCI_DEVICE_TABLE(p54p_tabl
        { PCI_DEVICE(0x1260, 0x3886) },
        /* Intersil PRISM Xbow Wireless LAN adapter (Symbol AP-300) */
        { PCI_DEVICE(0x1260, 0xffff) },
+       /* Standard Microsystems Corp SMC2802W Wireless PCI */
+       { PCI_DEVICE(0x10b8, 0x2802) },
        { },
 };


I will do a formal submission of the patch and edit the wiki.

Larry
