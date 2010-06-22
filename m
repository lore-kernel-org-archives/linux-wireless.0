Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34304 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777Ab0FVVqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 17:46:16 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: rt2500usb: WPA2 TKIP+AES does not work with HW encryption
Date: Tue, 22 Jun 2010 23:46:04 +0200
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
References: <201006221238.32745.linux@rainbow-software.org> <4C211076.9060804@gmail.com>
In-Reply-To: <4C211076.9060804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201006222346.06150.linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 June 2010 21:35:18 Gertjan van Wingerde wrote:
> On 06/22/10 12:38, Ondrej Zary wrote:
> > Hello,
> > I'm (again) trying to solve (debug) a weird problem with Asus WL-167G:
> > 0b05:1706 ASUSTek Computer, Inc. WL-167G v1 802.11g Adapter [Ralink
> > RT2500USB]
> >
> > The problem only appears when HW encryption is enabled and connecting to
> > an AP configured as WPA2 TKIP+AES.
> >
> > HW encryption works when the AP is configured as TKIP-only or AES-only.
> > It also works when AP is configured as TKIP+AES but wpa_supplicant is
> > forced to use TKIP as pairwise cipher (pairwise=TKIP)
> >
> > SW encryption works always.
> >
> > The problem is that no packets are transmitted. I can't see DHCP
> > broadcasts on other machine using tcpdump. But when I run tcpdump on the
> > rt2500usb, I see broadcasts from the other machine, so receive seems to
> > work fine.
> >
> > Added some printk()s to the driver, 6 packets from unsuccessful DHCP:
> > [  371.760073] rt2500usb_write_tx_desc: key_idx=0
> > [  371.852062] rt2500usb_write_tx_desc: key_idx=0
> > [  371.944054] rt2500usb_write_tx_desc: key_idx=0
> > [  372.036068] rt2500usb_write_tx_desc: key_idx=0
> > [  372.128056] rt2500usb_write_tx_desc: key_idx=0
> > [  372.220053] rt2500usb_write_tx_desc: key_idx=0
> > [  372.312053] rt2500usb_write_tx_desc: key_idx=0
> > [  372.404055] rt2500usb_write_tx_desc: key_idx=0
> > [  372.496101] rt2500usb_write_tx_desc: key_idx=0
> > [  372.588077] rt2500usb_write_tx_desc: key_idx=0
> > [  372.688073] rt2500usb_write_tx_desc: key_idx=0
> > [  373.272513] wlan1: authenticate with 00:13:d4:0f:f3:19 (try 1)
> > [  373.272552] rt2500usb_write_tx_desc: key_idx=0
> > [  373.274533] wlan1: authenticated
> > [  373.274564] wlan1: associate with 00:13:d4:0f:f3:19 (try 1)
> > [  373.274581] rt2500usb_write_tx_desc: key_idx=0
> > [  373.277696] wlan1: RX AssocResp from 00:13:d4:0f:f3:19 (capab=0x411
> > status=0 aid=1) [  373.277704] wlan1: associated
> > [  373.308247] rt2500usb_write_tx_desc: key_idx=0
> > [  373.308392] rt2500usb_write_tx_desc: key_idx=0
> > [  373.315999] rt2500usb_write_tx_desc: key_idx=0
> > [  373.340306] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  373.340318] rt2500usb_config_key key->hw_key_idx=0 SET_KEY hw_key_idx
> > = 0 OK [  373.344521] rt2x00crypto_key_to_cipher: ALG_TKIP
> > [  373.344527] rt2500usb_config_key key->hw_key_idx=0 SET_KEY hw_key_idx
> > = 1 OK [  373.412083] rt2500usb_write_tx_desc: key_idx=0
> > [  375.160233] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  375.160246] rt2x00crypto_tx_overhead=8
> > [  375.160254] rt2500usb_write_tx_desc: key_idx=0
> > [  375.240078] rt2500usb_write_tx_desc: key_idx=0
> > [  381.163494] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  381.163507] rt2x00crypto_tx_overhead=8
> > [  381.163515] rt2500usb_write_tx_desc: key_idx=0
> > [  381.244066] rt2500usb_write_tx_desc: key_idx=0
> > [  388.165180] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  388.165194] rt2x00crypto_tx_overhead=8
> > [  388.165201] rt2500usb_write_tx_desc: key_idx=0
> > [  388.244069] rt2500usb_write_tx_desc: key_idx=0
> > [  399.169468] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  399.169481] rt2x00crypto_tx_overhead=8
> > [  399.169489] rt2500usb_write_tx_desc: key_idx=0
> > [  399.248067] rt2500usb_write_tx_desc: key_idx=0
> > [  404.080428] rt2500usb_write_tx_desc: key_idx=0
> > [  404.180066] rt2500usb_write_tx_desc: key_idx=0
> > [  410.168836] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  410.168850] rt2x00crypto_tx_overhead=8
> > [  410.168858] rt2500usb_write_tx_desc: key_idx=0
> > [  410.248068] rt2500usb_write_tx_desc: key_idx=0
> > [  414.374545] rt2500usb_write_tx_desc: key_idx=0
> > [  414.472061] rt2500usb_write_tx_desc: key_idx=0
> > [  422.169686] rt2x00crypto_key_to_cipher: ALG_CCMP
> > [  422.169699] rt2x00crypto_tx_overhead=8
> > [  422.169706] rt2500usb_write_tx_desc: key_idx=0
> > [  422.252069] rt2500usb_write_tx_desc: key_idx=0
> >
> > Seems that it's trying to use CCMP, which is good. I wonder if the keys
> > are properly handled in rt2500usb_config_key. They seem to be uploaded to
> > the HW correctly (one at index 0, one at 1) - but can't tell without any
> > HW docs.
> >
> > I did some framedumps before but don't know what to do with them (what to
> > look for):
> > http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-bad.txt
> > http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-good.txt
> >
> > Anything else I can try?
>
> Hi Ondrej,
>
> Did you also test what happens if you configure the AP to be TKIP+AES and
> force wpa-supplicant to use AES pairwise key?
> If my analysis below is correct then that may work as well.

That does not work - it's probably the same case as default options (TKIP 
group key + AES pairwise key).

> If my reading of the rt2570 data sheet is correct, then the rt2570 will
> only support one encryption mechanism at the time. That means that it is
> not possible to upload 1 TKIP key and 1 AES key at the same time to the
> hardware. All the configured keys have to be of the same encryption
> algorithm.
> Presumably this is why the HW encryption engine fails, as the keys are set
> with mixed settings.
> Based on that, I don't think that rt2500usb can support this TKIP+AES
> setting on wpa-supplicant.

If this is true, then the driver should fall back to SW encryption in this 
case.

-- 
Ondrej Zary
