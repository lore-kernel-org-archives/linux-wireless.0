Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qproxy1-pub.mail.unifiedlayer.com ([173.254.64.10]:34123 "HELO
	qproxy1.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750724AbaAOGhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 01:37:09 -0500
Message-ID: <1389767820.2436.45.camel@Wailaba2> (sfid-20140115_073737_177371_11E1EFDE)
Subject: [ISSUE] rtl8192ce appears to interfere with ALSA playback
From: Olivier Langlois <olivier@trillion01.com>
To: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn
Cc: daniel@zonque.org
Date: Wed, 15 Jan 2014 01:37:00 -0500
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have been discussing this problem over the alsa-devel mailing list and
Daniel Mack asked me if I could repost my finding over here.

If I use ALSA for playback while my wifi card is on but not connected to
any AP (it is possibly scanning the air to find APs), I experience what
ALSA calls underruns at regular interval (about every 1-2 seconds).
underruns makes audible short click sounds.

If I connect to a Wifi network or close the Wifi, the crackles and
clicks go away. my explanation of the behavior is that in that specific
state, the rtl8192ce driver is disabling interrupts for too long and
stop my sound device irqs to be timely serviced.

I am currently using kernel 3.12.7 but I had this small problem as far
as I remember. At least since 3.7. This is important as I have noticed
that rtl8192ce did change in 3.12.7

Here is the HW in question:

00:1b.0 Audio device [0403]: Intel Corporation NM10/ICH7 Family High
Definition Audio Controller [8086:27d8] (rev 02)
  Subsystem: Hewlett-Packard Company Device [103c:1584]
  Flags: bus master, fast devsel, latency 0, IRQ 45
  Memory at 96200000 (64-bit, non-prefetchable) [size=16K]
  Capabilities: [50] Power Management version 2
  Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
  Capabilities: [100] Virtual Channel
  Capabilities: [130] Root Complex Link
  Kernel driver in use: snd_hda_intel
  Kernel modules: snd_hda_intel

01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
  Subsystem: Hewlett-Packard Company Device [103c:1629]
  Flags: bus master, fast devsel, latency 0, IRQ 16
  I/O ports at 3000 [size=256]
  Memory at 95000000 (64-bit, non-prefetchable) [size=16K]
  Capabilities: [40] Power Management version 3
  Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
  Capabilities: [70] Express Endpoint, MSI 00
  Capabilities: [100] Advanced Error Reporting
  Capabilities: [140] Virtual Channel
  Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
  Kernel driver in use: rtl8192ce
  Kernel modules: rtl8192ce

How to reproduce:

1. Enable Wifi while not connecting to any AP.
2. lano1106@hpmini ~/Music $ aplay -c1 sine.wav
underrun!!! (at least 1856093977.967 ms long)


