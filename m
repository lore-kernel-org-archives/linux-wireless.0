Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58765 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaLaOYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 09:24:20 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so14867051lbj.23
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2014 06:24:18 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 31 Dec 2014 15:24:18 +0100
Message-ID: <CAJWpbEhm06+nXkFfeMwe5yUb0Pve0y65okp5VMFdXacJQxjm5w@mail.gmail.com> (sfid-20141231_152423_489387_5E7257B5)
Subject: wperf - a test tool for monitor mode frame injection/reception on mac80211
From: Johan Almbladh <ja@anyfi.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working on improving the monitor mode frame injection/reception
functionality in mac80211. For this purpose I have written a small
test tool that can transmit and receive frames in monitor mode. It can
be used to measure throughput and packet loss for Tx and Rx, in AP or
STA mode, with or without encryption.

The source code is on GitHub, https://github.com/anyfi/wperf. There
are also statically-linked binaries for mips and x86:

$ wget https://github.com/anyfi/wperf/releases/download/v1.0.0/wperf-1.0.0-i386
$ wget https://github.com/anyfi/wperf/releases/download/v1.0.0/wperf-1.0.0-mips
$ wget https://github.com/anyfi/wperf/releases/download/v1.0.0/wperf-1.0.0-x86_64
$ file wperf-1.0.0-*
wperf-1.0.0-i386:   ELF 32-bit LSB  executable, Intel 80386, version 1
(SYSV), statically linked, for GNU/Linux 3.7.3, not stripped
wperf-1.0.0-mips:   ELF 32-bit MSB  executable, MIPS, MIPS-I version 1
(SYSV), statically linked, not stripped
wperf-1.0.0-x86_64: ELF 64-bit LSB  executable, x86-64, version 1
(GNU/Linux), statically linked, for GNU/Linux 2.6.24,
BuildID[sha1]=b5ac1e98b0ce1c0665f280762ef6ab05ebfff153, not stripped

$ md5sum wperf-1.0.0-*
b96b5d81518bad8094f37195e7fcae85  wperf-1.0.0-i386
300a5ad881039550b03e682d5eae981d  wperf-1.0.0-mips
a0586dc3ed5c6f32630ae233640c1d57  wperf-1.0.0-x86_64

To transmit frames in monitor mode from an AP:

1) Set up an wireless network in AP mode with mac80211 and hostapd,
and create a monitor interface on the phy

2) Connect a STA to the wireless network

3) Run a wperf UDP server on the STA

    wperf -s

4) Run a wperf client in monitor mode on the AP

    wperf -c <STA IP> --monitor=<monitor ifname> --bssid=<AP BSSID>
--dhost=<STA MAC>


Johan
