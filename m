Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58550 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab3DYAl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 20:41:29 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so1092425wgh.17
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 17:41:27 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 17:41:27 -0700
Message-ID: <CAJ-Vmo=QkCnkF3UCz_N5ZbwTNB1xeuZRqHYJ1W-mYne7h-6k1Q@mail.gmail.com> (sfid-20130425_024134_099550_1FCB19E4)
Subject: Questions about mwl8k hardware and TX aggregation + encryption
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For those of you who don't know, I'm the FreeBSD wifi maintainer and
I'm trying to figure out why I'm seeing what I'm seeing with FreeBSD's
mwl driver.

The summary:

mwl0: <Marvell 88W8363>
mwl0: Rev A5 hardware, v3.6.2.2 firmware

It works fine in 11abgn modes, It works fine doing 11n TX aggregation
with no encryption. But with CCMP encryption enabled, things go
whacked.

Here's some snapshots from the receiving AP (802.11n atheros, FreeBSD)
in wifi promisc mode.

Now, before I bring up TX aggregation, but with CCMP enabled:

01:26:16.795141 2251206829us tsft short preamble wep 6.0 Mb/s 34dBm tx
power antenna 0 5240 MHz 11a ht/40- WEP Encrypted 0us CF +QoS
DA:00:50:43:20:98:94 BSSID:00:03:7f:0b:64:08 SA:00:16:41:a8:1d:5b Data
IV: 13 Pad 20 KeyID 0
        0x0000:  0000 1c00 070c 0400 adb0 2e86 0000 0000
        0x0010:  260c 2200 4001 0400 7814 3011 8842 0000
        0x0020:  0050 4320 9894 0003 7f0b 6408 0016 41a8
        0x0030:  1d5b 2001 0000 dec0 1300 0020 0000 0000
        0x0040:  aaaa 0300 0000 0800 4500 0054 33c6 0000
        0x0050:  4001 3046 0a0b 0143 0a0b 0145 0000 aa92
        0x0060:  5d09 0000 5177 9728 000c 24b5 0809 0a0b
        0x0070:  0c0d 0e0f 1011 1213 1415 1617 1819 1a1b
        0x0080:  1c1d 1e1f 2021 2223 2425 2627 2829 2a2b
        0x0090:  2c2d 2e2f 3031 3233 3435 3637

01:26:17.797218 2252208890us tsft short preamble wep 6.0 Mb/s 34dBm tx
power antenna 0 5240 MHz 11a ht/40- WEP Encrypted 0us CF +QoS
DA:00:50:43:20:98:94 BSSID:00:03:7f:0b:64:08 SA:00:16:41:a8:1d:5b Data
IV: 14 Pad 20 KeyID 0
        0x0000:  0000 1c00 070c 0400 fafa 3d86 0000 0000
        0x0010:  260c 2200 4001 0400 7814 3011 8842 0000
        0x0020:  0050 4320 9894 0003 7f0b 6408 0016 41a8
        0x0030:  1d5b 3001 0000 dec0 1400 0020 0000 0000
        0x0040:  aaaa 0300 0000 0800 4500 0054 33c7 0000
        0x0050:  4001 3045 0a0b 0143 0a0b 0145 0000 a04d
        0x0060:  5d09 0001 5177 9729 000c 2ef8 0809 0a0b
        0x0070:  0c0d 0e0f 1011 1213 1415 1617 1819 1a1b
        0x0080:  1c1d 1e1f 2021 2223 2425 2627 2829 2a2b
        0x0090:  2c2d 2e2f 3031 3233 3435 3637


Here, the CCMP field (8 bytes) is ok.

But, once a BA session is up and established, nothing works. Take a look:


00:51:41.640894 754460956012052480us tsft 0.0 Mb/s 0dB signal 0dB
noise antenna 32 320 MHz [bit 31] WEP Encrypted 2913us CF +QoS
BSSID:00:03:7f:0b:64:08 (oui Unknown) SA:00:50:43:20:98:94 (oui
Unknown) DA:00:16:41:a8:1d:5b (oui Unknown) Data IV:8d8dc0 Pad f KeyID
0
        0x0000:  0000 5400 6708 04c0 0001 0000 0000 0000
        0x0010:  3e62 780a 0000 0000 208f dca0 0100 0000
        0x0020:  4001 0400 7814 3011 7f03 0000 2600 0107
        0x0030:  0000 0000 0000 0000 0000 0000 0000 0000
        0x0040:  0000 0000 353a 3500 3538 3600 ff08 3c01
        0x0050:  8f0c 0000 8841 610b 0003 7f0b 6408 0050
        0x0060:  4320 9894 0016 41a8 1d5b c0f8 0000 c08d
        0x0070:  8d0f 0020 0000 0000 aaaa 0300 0000 0800
        0x0080:  4500 0054 23d0 0000 4001 403c 0a0b 0145
        0x0090:  0a0b 0143 0800 67a8 ed0c 0007 5177 8f0d
        0x00a0:  0008 d7b3 0809 0a0b 0c0d 0e0f 1011 1213
        0x00b0:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
        0x00c0:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
        0x00d0:  3435 3637 b2dd 1a7f 9baf 8372 e52d f609

00:51:42.677385 758912650959650816us tsft 0.0 Mb/s 0dB signal 0dB
noise antenna 32 320 MHz [bit 31] WEP Encrypted 2913us CF +QoS
BSSID:00:03:7f:0b:64:08 (oui Unknown) SA:00:50:43:20:98:94 (oui
Unknown) DA:00:16:41:a8:1d:5b (oui Unknown) Data IV:8e8ed0 Pad f KeyID
0
        0x0000:  0000 5400 6708 04c0 0001 0000 0000 0000
        0x0010:  0933 880a 0000 0000 208f daa0 0100 0000
        0x0020:  4001 0400 7814 3011 7f03 0000 2600 0107
        0x0030:  0000 0000 0000 0000 0000 0000 0000 0000
        0x0040:  0000 0000 3437 3100 3437 3300 ff08 3a01
        0x0050:  8f0c 0000 8841 610b 0003 7f0b 6408 0050
        0x0060:  4320 9894 0016 41a8 1d5b d0f8 0000 d08e
        0x0070:  8e0f 0020 0000 0000 aaaa 0300 0000 0800
        0x0080:  4500 0054 23d1 0000 4001 403b 0a0b 0145
        0x0090:  0a0b 0143 0800 d80c ed0c 0008 5177 8f0e
        0x00a0:  0009 674c 0809 0a0b 0c0d 0e0f 1011 1213
        0x00b0:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
        0x00c0:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
        0x00d0:  3435 3637 d393 4bb5 f6e0 ea98 f128 fe2b

Here, there's extra gunk:

c0f8 0000 c08d in the first;
d0f8 0000 d08e in the second;

.. which shows up.

I've looked over the mwl8k driver and the AP TX path doesn't take the
BA session into account. It just queues frames normally (after tagging
the right qos / tx queue bits.)

So I am stumped as to why there's six extra payload bytes here that
seem to be increasing like a CCMP IV, but don't look like they are.

This is the only major showstopper to having (old) 11n marvell support
in FreeBSD.

I appreciate any assistance you can provide.

Thanks!
