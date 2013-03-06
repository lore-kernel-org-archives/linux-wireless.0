Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60960 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3CFFmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 00:42:04 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so6742936wgh.31
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 21:42:02 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 22:42:01 -0700
Message-ID: <CAEk6VBHnWn_KF0TJ_vojuOhWFhR6TncAok+B9mqgGzAdC5DzVg@mail.gmail.com> (sfid-20130306_064209_944472_6FA0A7C6)
Subject: [ath9k] Recent driver versions break compatibility with AR9285 for me
From: Nick Thomas <nhomas@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all!

Summary: In my case, the ath9k driver in kernel 3.7.10 does not work
with the Atheros AR2985, but the 3.2.39 driver does.

I have a Dell Inspiron N5040, which has an Atheros AR9285 wireless
card. lspci -v reports:

12:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network
Adapter (PCI-Express) (rev 01)
        Subsystem: Dell Wireless 1502 802.11bgn Half-size Mini PCIe Card
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at fbe00000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [60] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
        Capabilities: [170] Power Budgeting <?>
        Kernel driver in use: ath9k

When I run the 3.7.10 kernel with the ath9k module loaded, the
wireless does not work, and iwconfig wlan0 reports:

wlan0:          no wireless extensions.

When I run the 3.2.39 kernel, the wireless works, and iwconfig wlan0 reports:

wlan0     IEEE 802.11bgn  ESSID:"HardFatCox"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:22:75:49:42:F7
          Bit Rate=48 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=50/70  Signal level=-60 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:23  Invalid misc:11577   Missed beacon:0

My best guess is that recent driver revisions broke compatibility with
my wireless card.

The non-working sources that I used (the 3.7.10 kernel) were
downloaded from the Gentoo portage repository, which has some patches
applied. I am willing to try a more "official" version of the kernel
(really, any version you guys want me to) if you think it would help
in understanding this. Also let me know if there is anything else I
can do to help.

I am not subscribed to the mailing list; please cc me on any replies.
Thank you for your good work on this project! I am very glad that I
can use my wireless card on Linux.

Nick Thomas
