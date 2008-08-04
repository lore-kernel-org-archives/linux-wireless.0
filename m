Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbYHDX05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 19:26:57 -0400
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
In-Reply-To: <48978C25.601@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 19:28:34 -0400
Message-Id: <1217892514.17793.39.camel@localhost.localdomain> (sfid-20080805_012713_525272_0E34E140)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 00:09 +0100, Dave wrote:
> Pavel Roskin wrote:
> >> It is almost checkpatch
> >> clean - the single warning looks like a false positive to me.
> > 
> > If you mean orinoco_ioctl_getnick(), that's a false positive.
> 
> Actually I meant the DECLARE_DEFAULT_PDA macro in hermes_dld.c:
> 
> dkilroy@borken /usr/src/wireless-testing $ git diff HEAD~20 | scripts/checkpatch.pl -
> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> #933: FILE: drivers/net/wireless/hermes_dld.c:570:
> +#define DEFINE_DEFAULT_PDR(pid, length, data)				\
> +static const struct {							\
> +	__le16 len;							\
> +	__le16 id;							\
> +	u8 val[length];							\
> +} __attribute__ ((packed)) default_pdr_data_##pid = {			\
> +	__constant_cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
> +				sizeof(__le16)) - 1),			\
> +	__constant_cpu_to_le16(pid),					\
> +	data								\
> +}
> 
> > However,
> > sparse finds two issues on x86_64, both due to sizeof() returning
> > size_t, which is wider than int.
> > 
> > Here's the fix.  Please integrate it into the patches that introduce the
> > code.
> 
> Will do. I obviously need to upgrade my version of sparse, since it isn't complaining to me :(
> 
> >> To use WPA, you will need an Agere firmware image. You can get the
> >> necessary file at
> >> <http://marc.info/?l=orinoco-devel&m=121078835610877>
> > I tested it on my WPA2 AP and could not associate:
> 
> I'm not familiar with the difference between WPA/WPA2. Is that expected to work?

Depends; if it's WPA2/RSN + AES-CCMP, then most likely not, because I'm
pretty sure the cards won't have onboard AES crypto acceleration
hardware.  Most cards built before WPA2/RSN was standardized don't have
the horsepower to do AES in firmware purely in software either.

But you might be able to get away with WPA2/RSN + TKIP if the AP allows
this configuration.  In that configuration, the only difference between
WPA and WPA2/RSN would be the information element IDs, really.  But if
the firmware itself doesn't say it supports WPA on whatever website it
came from, then likely the card won't do WPA2/RSN either.

In fact, you already did the right thing by _NOT_ adding
IW_ENC_CAPA_WPA2 and IW_ENC_CAPA_CIPHER_CCMP in the GIWRANGE handler.
Thus, you have not signaled that WPA2 is supported by the driver, and
thus Pavel should not have expected it to work in the first place :)

Dan

> > # wpa_supplicant -c /etc/wpa_supplicant/wpa_main.conf -D wext -i eth1
> > CTRL-EVENT-SCAN-RESULTS 
> > Trying to associate with 00:19:5b:56:fc:73 (SSID='mike' freq=2437 MHz)
> > ioctl[SIOCSIWFREQ]: Device or resource busy
> > ioctl[SIOCSIWAP]: Operation not supported
> > Association request to the driver failed
> 
> The 'Device or resource busy' definitely looks wrong. We only return -EBUSY here if the device was in infrastructure mode or during initialisation/reset.
> 
> The SIOCSIWAP response is expected if you have wpa_supplicant configured with ap_scan=1 (I think). The driver isn't able to tell the firmware which bssid to associate with - instead after the SIOCSIWENCODEEXT the driver selects a bssid belonging to the specified ssid. Setting ap_scan=2 should avoid the SIOCSIWAP and it should work better.
> 
> > And that's from the kernel log:
> > 
> > [185185.284523] eth1: Hardware identity 0001:0004:0005:0000
> > [185185.284686] eth1: Station identity  001f:0002:0009:002a
> > [185185.284722] eth1: Firmware determined as Lucent/Agere 9.42
> > [185185.284758] eth1: Ad-hoc demo mode supported
> > [185185.284793] eth1: IEEE standard IBSS ad-hoc mode supported
> > [185185.284829] eth1: WEP supported, 104-bit key
> > [185185.284872] eth1: WPA-PSK supported
> > [185185.285010] eth1: MAC address 00:02:2d:8b:56:87
> > [185185.285153] eth1: Station name "HERMES I"
> > [185185.285811] eth1: ready
> > [185185.287298] eth1: orinoco_cs at 0.0, irq 18, io 0x1100-0x113f
> > [185213.396202] eth1: New link status: Connected (0001)
> > [185214.469964] eth1: Ext scan results too large (272 bytes). Truncating
> > results to 270 bytes.
> > [185214.575811] eth1: Lucent/Agere firmware doesn't support manual
> > roaming
> > [185219.617236] eth1: Ext scan results too large (272 bytes). Truncating
> > results to 270 bytes.
> 
> The truncation of scan results in this case is expected and is due to the IEs being reported by your access point (previously I dropped the scan result completely). I'm hoping the last two bytes aren't significant. The results from my AP (and hopefully most others) are shorter and are not truncated.
> 
> Regards,
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

