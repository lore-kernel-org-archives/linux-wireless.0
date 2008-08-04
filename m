Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:51067 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYHDXJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 19:09:35 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2784069ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 16:09:34 -0700 (PDT)
Message-ID: <48978C25.601@gmail.com> (sfid-20080805_010942_305245_46DCE8FF)
Date: Tue, 05 Aug 2008 00:09:25 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217822232.10989.13.camel@dv>
In-Reply-To: <1217822232.10989.13.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
>> It is almost checkpatch
>> clean - the single warning looks like a false positive to me.
> 
> If you mean orinoco_ioctl_getnick(), that's a false positive.

Actually I meant the DECLARE_DEFAULT_PDA macro in hermes_dld.c:

dkilroy@borken /usr/src/wireless-testing $ git diff HEAD~20 | scripts/checkpatch.pl -
ERROR: Macros with multiple statements should be enclosed in a do - while loop
#933: FILE: drivers/net/wireless/hermes_dld.c:570:
+#define DEFINE_DEFAULT_PDR(pid, length, data)				\
+static const struct {							\
+	__le16 len;							\
+	__le16 id;							\
+	u8 val[length];							\
+} __attribute__ ((packed)) default_pdr_data_##pid = {			\
+	__constant_cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
+				sizeof(__le16)) - 1),			\
+	__constant_cpu_to_le16(pid),					\
+	data								\
+}

> However,
> sparse finds two issues on x86_64, both due to sizeof() returning
> size_t, which is wider than int.
> 
> Here's the fix.  Please integrate it into the patches that introduce the
> code.

Will do. I obviously need to upgrade my version of sparse, since it isn't complaining to me :(

>> To use WPA, you will need an Agere firmware image. You can get the
>> necessary file at
>> <http://marc.info/?l=orinoco-devel&m=121078835610877>
> I tested it on my WPA2 AP and could not associate:

I'm not familiar with the difference between WPA/WPA2. Is that expected to work?
 
> # wpa_supplicant -c /etc/wpa_supplicant/wpa_main.conf -D wext -i eth1
> CTRL-EVENT-SCAN-RESULTS 
> Trying to associate with 00:19:5b:56:fc:73 (SSID='mike' freq=2437 MHz)
> ioctl[SIOCSIWFREQ]: Device or resource busy
> ioctl[SIOCSIWAP]: Operation not supported
> Association request to the driver failed

The 'Device or resource busy' definitely looks wrong. We only return -EBUSY here if the device was in infrastructure mode or during initialisation/reset.

The SIOCSIWAP response is expected if you have wpa_supplicant configured with ap_scan=1 (I think). The driver isn't able to tell the firmware which bssid to associate with - instead after the SIOCSIWENCODEEXT the driver selects a bssid belonging to the specified ssid. Setting ap_scan=2 should avoid the SIOCSIWAP and it should work better.

> And that's from the kernel log:
> 
> [185185.284523] eth1: Hardware identity 0001:0004:0005:0000
> [185185.284686] eth1: Station identity  001f:0002:0009:002a
> [185185.284722] eth1: Firmware determined as Lucent/Agere 9.42
> [185185.284758] eth1: Ad-hoc demo mode supported
> [185185.284793] eth1: IEEE standard IBSS ad-hoc mode supported
> [185185.284829] eth1: WEP supported, 104-bit key
> [185185.284872] eth1: WPA-PSK supported
> [185185.285010] eth1: MAC address 00:02:2d:8b:56:87
> [185185.285153] eth1: Station name "HERMES I"
> [185185.285811] eth1: ready
> [185185.287298] eth1: orinoco_cs at 0.0, irq 18, io 0x1100-0x113f
> [185213.396202] eth1: New link status: Connected (0001)
> [185214.469964] eth1: Ext scan results too large (272 bytes). Truncating
> results to 270 bytes.
> [185214.575811] eth1: Lucent/Agere firmware doesn't support manual
> roaming
> [185219.617236] eth1: Ext scan results too large (272 bytes). Truncating
> results to 270 bytes.

The truncation of scan results in this case is expected and is due to the IEs being reported by your access point (previously I dropped the scan result completely). I'm hoping the last two bytes aren't significant. The results from my AP (and hopefully most others) are shorter and are not truncated.

Regards,

Dave.
