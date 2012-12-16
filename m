Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38758 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2LPEGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 23:06:48 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so5825244vby.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 20:06:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmokcJUBZeOAyjaNefqgtEkdjGFhH3NQEXA38Xe_i2M+wYA@mail.gmail.com>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50CA0F8B.3060905@openwrt.org>
	<20121213220651.GA30855@pandem0nium>
	<50CA5EE9.30606@openwrt.org>
	<CAJ-VmokcJUBZeOAyjaNefqgtEkdjGFhH3NQEXA38Xe_i2M+wYA@mail.gmail.com>
Date: Sat, 15 Dec 2012 20:06:47 -0800
Message-ID: <CAJ-Vmo=qWihSMZ3Jwb9NGU_uXSGYd-Nxya+oT0MQdoT6r0JZFw@mail.gmail.com> (sfid-20121216_050656_238354_7EEA89B6)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The formats are as follows. Please note that if a pulse terminates
during an FFT, the final entry may be truncated. So yes, you may not
always get an integer multiple of the relevant frame length.

Note that you shift each of the readings by max_exp to get a total
reading. max_index and max_magnitude I think are just derived from the
existing dataset; they're just a shortcut for software so it doesn't
have to parse the whole frame looking for the peak.

Static 20 mode:

0  bin -28 magnitude[7:0] = (|i| + |q|) >> max_exp
1  bin -27 magnitude[7:0] = (|i| + |q|) >> max_exp
2 - 53  …
54  bin  26 magnitude[7:0] = (|i| + |q|) >> max_exp
55  bin  27 magnitude[7:0] = (|i| + |q|) >> max_exp
56  [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
57  [7:0]: all bins  max_magnitude[9:2]
58  [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}
59  [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)

Dynamic 20/40 mode:

0  bin -64 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
1  bin -63 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
2 - 125  …
126  bin  62 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
127  bin  63 magnitude[7:0] = (|i| + |q|) >> max_exp  or  power (in dBm)
128  [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
Baseband DFS 2 (Radar) Micro-Architecture
129  [7:0]: lower bins  max_magnitude[9:2]
130  [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
131  [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
132  [7:0]: upper bins  max_magnitude[9:2]
133  [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}
134  [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)

Ok, now for radar it's a tad different. There's a bit that is set if
the signal is above a certain threshold. If so, the bit is set to 1.
There's also a 3 bit magnitude value which is calculated against the
maximum magnitude value (floor(m(i) * 8 / max magnitude.)

This is optimised for digestion by radar code looking to identify
whether a longer pulse is a radar chirp (moving in frequency over
time) or not.

Static 20:

0  [3:0]: bin -28  {bitmap, quantized magnitude[2:0]}
[7:4]: bin -27  {bitmap, quantized magnitude[2:0]}
1  [3:0]: bin -26  {bitmap, quantized magnitude[2:0]}
[7:4]: bin -25  {bitmap, quantized magnitude[2:0]}
2 - 25  …
26  [3:0]: bin  24  {bitmap, quantized magnitude[2:0]}
[7:4]: bin  25  {bitmap, quantized magnitude[2:0]}
27  [3:0]: bin  26  {bitmap, quantized magnitude[2:0]}
[7:4]: bin  27  {bitmap, quantized magnitude[2:0]}
28  [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
29  [7:0]: all bins  max_magnitude[9:2]
30  [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}

Dynamic 20/40:

0  [3:0]: bin -64  {bitmap, quantized magnitude[2:0]}
[7:4]: bin -63  {bitmap, quantized magnitude[2:0]}
1  [3:0]: bin -62  {bitmap, quantized magnitude[2:0]}
[7:4]: bin -61  {bitmap, quantized magnitude[2:0]}
2 - 61  …
62  [3:0]: bin  60  {bitmap, quantized magnitude[2:0]}
[7:4]: bin  61  {bitmap, quantized magnitude[2:0]}
63  [3:0]: bin  62  {bitmap, quantized magnitude[2:0]}
[7:4]: bin  63  {bitmap, quantized magnitude[2:0]}
64  [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
65  [7:0]: lower bins  max_magnitude[9:2]
66  [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
67  [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
68  [7:0]: upper bins  max_magnitude[9:2]
69  [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}

There you are. Please, go forth, write some open source code that
grabs this data and plots it in meaningful ways.



Adrian
