Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59212 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0IOQhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:37:15 -0400
Received: by qwh6 with SMTP id 6so288800qwh.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 09:37:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Sep 2010 09:37:14 -0700
Message-ID: <AANLkTinpyAxJMXu0Tkw=eEchTD1s5Xy-9yJs+bft1cKz@mail.gmail.com>
Subject: Intel 5300: MAC is in deep sleep
From: Darren Hart <darren@dvhart.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the following kernel+linuxwireless versions:

- Ubuntu 10.04+latest wireless backports
- 2.6.36-rc4+compat-wireless-2.6.36-rc3-1

My wifi connection drops every few minutes and freezes the desktop for
20 seconds. It then recovers and the following is listed in dmesg:

[ 3257.370882] iwlagn 0000:03:00.0: MAC is in deep sleep!.
CSR_GP_CNTRL = 0x080003D8
[ 3257.410187] iwlagn 0000:03:00.0: MAC is in deep sleep!.
CSR_GP_CNTRL = 0x080003D8
[ 3257.460991] iwlagn 0000:03:00.0: MAC is in deep sleep!.
CSR_GP_CNTRL = 0x080003D8
[ 3257.501898] iwlagn 0000:03:00.0: Master Disable Timed Out, 100 usec

The deep sleep msg is repeated numerous times.

ThinkPad T400:
$ lspci -vv  -s 03:00.0
03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5300
	Subsystem: Intel Corporation Device 1011
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

$ sudo dmidecode | grep -i bios
BIOS Revision: 3.18

-- 
Darren Hart
