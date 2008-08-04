Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26534 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYHDD5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 23:57:14 -0400
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
From: Pavel Roskin <proski@gnu.org>
To: kilroyd@googlemail.com
Cc: linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
In-Reply-To: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 23:57:12 -0400
Message-Id: <1217822232.10989.13.camel@dv> (sfid-20080804_055740_691108_8CAD80DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-08-02 at 11:14 +0100, kilroyd@googlemail.com wrote:
> This patch series enables WPA on Agere based orinoco devices.
>
> Patchset overview
> 1-2: General scanning updates
> 3-9: Agere firmware download to RAM
> 10-12: Update orinoco to work with new firmware
> 13-19: WPA functionality
> 
> This patchset is against wireless-testing (master-2008-07-16), is
> sparse clean (UP), and should be bisectable. It is almost checkpatch
> clean - the single warning looks like a false positive to me.

If you mean orinoco_ioctl_getnick(), that's a false positive.  However,
sparse finds two issues on x86_64, both due to sizeof() returning
size_t, which is wider than int.

Here's the fix.  Please integrate it into the patches that introduce the
code.

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index dca725c..3ab7822 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -479,7 +479,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 	/* Read current plug data */
 	err = hermes_read_pda(hw, pda, fw->pda_addr,
-			      min(fw->pda_size, sizeof(pda)), 0);
+			      min_t(int, fw->pda_size, sizeof(pda)), 0);
 	printk(KERN_DEBUG "%s: Read PDA returned %d\n", dev->name, err);
 	if (err)
 		return err;
@@ -2140,7 +2140,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		else if (len > sizeof(*bss)) {
 			printk(KERN_WARNING
 			       "%s: Ext scan results too large (%d bytes). "
-			       "Truncating results to %d bytes.\n",
+			       "Truncating results to %zd bytes.\n",
 			       dev->name, len, sizeof(*bss));
 			len = sizeof(*bss);
 		} else if (len < (offsetof(struct agere_ext_scan_info,

> To use WPA, you will need an Agere firmware image. You can get the
> necessary file at
> <http://marc.info/?l=orinoco-devel&m=121078835610877>, just extract
> and rename orinoco.fw to agere_sta_fw.bin and place it in
> /lib/firmware (or distro equivalent). Alternatively you can try
> extract firmware from a Windows driver using the program in
> <http://marc.info/?l=orinoco-devel&m=120846933719051>.

I tested it on my WPA2 AP and could not associate:

# wpa_supplicant -c /etc/wpa_supplicant/wpa_main.conf -D wext -i eth1
CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 00:19:5b:56:fc:73 (SSID='mike' freq=2437 MHz)
ioctl[SIOCSIWFREQ]: Device or resource busy
ioctl[SIOCSIWAP]: Operation not supported
Association request to the driver failed

And that's from the kernel log:

[185185.284523] eth1: Hardware identity 0001:0004:0005:0000
[185185.284686] eth1: Station identity  001f:0002:0009:002a
[185185.284722] eth1: Firmware determined as Lucent/Agere 9.42
[185185.284758] eth1: Ad-hoc demo mode supported
[185185.284793] eth1: IEEE standard IBSS ad-hoc mode supported
[185185.284829] eth1: WEP supported, 104-bit key
[185185.284872] eth1: WPA-PSK supported
[185185.285010] eth1: MAC address 00:02:2d:8b:56:87
[185185.285153] eth1: Station name "HERMES I"
[185185.285811] eth1: ready
[185185.287298] eth1: orinoco_cs at 0.0, irq 18, io 0x1100-0x113f
[185213.396202] eth1: New link status: Connected (0001)
[185214.469964] eth1: Ext scan results too large (272 bytes). Truncating
results to 270 bytes.
[185214.575811] eth1: Lucent/Agere firmware doesn't support manual
roaming
[185219.617236] eth1: Ext scan results too large (272 bytes). Truncating
results to 270 bytes.
[185219.619871] eth1: Ext scan results too large (272 bytes). Truncating
results to 270 bytes.

-- 
Regards,
Pavel Roskin
