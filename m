Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4990 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab0FXGPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 02:15:40 -0400
Message-ID: <4C22F80A.8000008@gmail.com>
Date: Thu, 24 Jun 2010 08:15:38 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2500usb: fallback to SW encryption for TKIP+AES
References: <201006221238.32745.linux@rainbow-software.org> <4C211076.9060804@gmail.com> <201006222346.06150.linux@rainbow-software.org> <201006231257.17684.linux@rainbow-software.org>
In-Reply-To: <201006231257.17684.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/10 12:57, Ondrej Zary wrote:
> On Tuesday 22 June 2010, Ondrej Zary wrote:
>> On Tuesday 22 June 2010 21:35:18 Gertjan van Wingerde wrote:
>>> On 06/22/10 12:38, Ondrej Zary wrote:
>>>> Hello,
>>>> I'm (again) trying to solve (debug) a weird problem with Asus WL-167G:
>>>> 0b05:1706 ASUSTek Computer, Inc. WL-167G v1 802.11g Adapter [Ralink
>>>> RT2500USB]
>>>>
>>>> The problem only appears when HW encryption is enabled and connecting
>>>> to an AP configured as WPA2 TKIP+AES.
>>>>
>>>> HW encryption works when the AP is configured as TKIP-only or AES-only.
>>>> It also works when AP is configured as TKIP+AES but wpa_supplicant is
>>>> forced to use TKIP as pairwise cipher (pairwise=TKIP)
>>>>
>>>> SW encryption works always.
>>>>
>>>> The problem is that no packets are transmitted. I can't see DHCP
>>>> broadcasts on other machine using tcpdump. But when I run tcpdump on
>>>> the rt2500usb, I see broadcasts from the other machine, so receive
>>>> seems to work fine.
>>>>
>>>> Added some printk()s to the driver, 6 packets from unsuccessful DHCP:
>>>> [  371.760073] rt2500usb_write_tx_desc: key_idx=0
>>>> [  371.852062] rt2500usb_write_tx_desc: key_idx=0
>>>> [  371.944054] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.036068] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.128056] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.220053] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.312053] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.404055] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.496101] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.588077] rt2500usb_write_tx_desc: key_idx=0
>>>> [  372.688073] rt2500usb_write_tx_desc: key_idx=0
>>>> [  373.272513] wlan1: authenticate with 00:13:d4:0f:f3:19 (try 1)
>>>> [  373.272552] rt2500usb_write_tx_desc: key_idx=0
>>>> [  373.274533] wlan1: authenticated
>>>> [  373.274564] wlan1: associate with 00:13:d4:0f:f3:19 (try 1)
>>>> [  373.274581] rt2500usb_write_tx_desc: key_idx=0
>>>> [  373.277696] wlan1: RX AssocResp from 00:13:d4:0f:f3:19 (capab=0x411
>>>> status=0 aid=1) [  373.277704] wlan1: associated
>>>> [  373.308247] rt2500usb_write_tx_desc: key_idx=0
>>>> [  373.308392] rt2500usb_write_tx_desc: key_idx=0
>>>> [  373.315999] rt2500usb_write_tx_desc: key_idx=0
>>>> [  373.340306] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  373.340318] rt2500usb_config_key key->hw_key_idx=0 SET_KEY
>>>> hw_key_idx = 0 OK [  373.344521] rt2x00crypto_key_to_cipher: ALG_TKIP
>>>> [  373.344527] rt2500usb_config_key key->hw_key_idx=0 SET_KEY
>>>> hw_key_idx = 1 OK [  373.412083] rt2500usb_write_tx_desc: key_idx=0
>>>> [  375.160233] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  375.160246] rt2x00crypto_tx_overhead=8
>>>> [  375.160254] rt2500usb_write_tx_desc: key_idx=0
>>>> [  375.240078] rt2500usb_write_tx_desc: key_idx=0
>>>> [  381.163494] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  381.163507] rt2x00crypto_tx_overhead=8
>>>> [  381.163515] rt2500usb_write_tx_desc: key_idx=0
>>>> [  381.244066] rt2500usb_write_tx_desc: key_idx=0
>>>> [  388.165180] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  388.165194] rt2x00crypto_tx_overhead=8
>>>> [  388.165201] rt2500usb_write_tx_desc: key_idx=0
>>>> [  388.244069] rt2500usb_write_tx_desc: key_idx=0
>>>> [  399.169468] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  399.169481] rt2x00crypto_tx_overhead=8
>>>> [  399.169489] rt2500usb_write_tx_desc: key_idx=0
>>>> [  399.248067] rt2500usb_write_tx_desc: key_idx=0
>>>> [  404.080428] rt2500usb_write_tx_desc: key_idx=0
>>>> [  404.180066] rt2500usb_write_tx_desc: key_idx=0
>>>> [  410.168836] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  410.168850] rt2x00crypto_tx_overhead=8
>>>> [  410.168858] rt2500usb_write_tx_desc: key_idx=0
>>>> [  410.248068] rt2500usb_write_tx_desc: key_idx=0
>>>> [  414.374545] rt2500usb_write_tx_desc: key_idx=0
>>>> [  414.472061] rt2500usb_write_tx_desc: key_idx=0
>>>> [  422.169686] rt2x00crypto_key_to_cipher: ALG_CCMP
>>>> [  422.169699] rt2x00crypto_tx_overhead=8
>>>> [  422.169706] rt2500usb_write_tx_desc: key_idx=0
>>>> [  422.252069] rt2500usb_write_tx_desc: key_idx=0
>>>>
>>>> Seems that it's trying to use CCMP, which is good. I wonder if the keys
>>>> are properly handled in rt2500usb_config_key. They seem to be uploaded
>>>> to the HW correctly (one at index 0, one at 1) - but can't tell without
>>>> any HW docs.
>>>>
>>>> I did some framedumps before but don't know what to do with them (what
>>>> to look for):
>>>> http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-bad.txt
>>>> http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-good.tx
>>>> t
>>>>
>>>> Anything else I can try?
>>>
>>> Hi Ondrej,
>>>
>>> Did you also test what happens if you configure the AP to be TKIP+AES and
>>> force wpa-supplicant to use AES pairwise key?
>>> If my analysis below is correct then that may work as well.
>>
>> That does not work - it's probably the same case as default options (TKIP
>> group key + AES pairwise key).
>>
>>> If my reading of the rt2570 data sheet is correct, then the rt2570 will
>>> only support one encryption mechanism at the time. That means that it is
>>> not possible to upload 1 TKIP key and 1 AES key at the same time to the
>>> hardware. All the configured keys have to be of the same encryption
>>> algorithm.
>>> Presumably this is why the HW encryption engine fails, as the keys are
>>> set with mixed settings.
>>> Based on that, I don't think that rt2500usb can support this TKIP+AES
>>> setting on wpa-supplicant.
>>
>> If this is true, then the driver should fall back to SW encryption in this
>> case.
> 
> HW crypto in rt2500usb does not seem to support keys with different ciphers,
> which breaks TKIP+AES mode. Fall back to software encryption to fix it.
> 
> This should fix long-standing problems with rt2500usb and WPA, such as:
> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
> https://bugzilla.redhat.com/show_bug.cgi?id=484888
> 
> Also tested that it does not break WEP, TKIP-only and AES-only modes.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Yes, this seems to be the right thing to do.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> 
> diff -urp linux-2.6.35-rc3-orig/drivers/net/wireless/rt2x00/rt2500usb.c linux-2.6.35-rc3/drivers/net/wireless/rt2x00/rt2500usb.c
> --- linux-2.6.35-rc3-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-06-12 04:14:04.000000000 +0200
> +++ linux-2.6.35-rc3/drivers/net/wireless/rt2x00/rt2500usb.c	2010-06-23 12:18:43.000000000 +0200
> @@ -348,6 +348,7 @@ static int rt2500usb_config_key(struct r
>  	int timeout;
>  	u32 mask;
>  	u16 reg;
> +	enum cipher curr_cipher;
>  
>  	if (crypto->cmd == SET_KEY) {
>  		/*
> @@ -358,6 +359,7 @@ static int rt2500usb_config_key(struct r
>  		mask = TXRX_CSR0_KEY_ID.bit_mask;
>  
>  		rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
> +		curr_cipher = rt2x00_get_field16(reg, TXRX_CSR0_ALGORITHM);
>  		reg &= mask;
>  
>  		if (reg && reg == mask)
> @@ -366,6 +368,14 @@ static int rt2500usb_config_key(struct r
>  		reg = rt2x00_get_field16(reg, TXRX_CSR0_KEY_ID);
>  
>  		key->hw_key_idx += reg ? ffz(reg) : 0;
> +		/*
> +		 * Hardware requires that all keys use the same cipher
> +		 * (e.g. TKIP-only, AES-only, but not TKIP+AES).
> +		 * If this is not the first key, compare the cipher with the
> +		 * first one and fall back to SW crypto if not the same.
> +		 */
> +		if (key->hw_key_idx > 0 && crypto->cipher != curr_cipher)
> +			return -EOPNOTSUPP;
>  
>  		/*
>  		 * The encryption key doesn't fit within the CSR cache,
> 
> 

