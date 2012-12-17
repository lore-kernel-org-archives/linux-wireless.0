Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59620 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2LQUIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 15:08:20 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so2948614wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 12:08:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok+D8vZE3BBZL5CwkegSpe9Sxi0OSzJmTeO8HA6Om4kcQ@mail.gmail.com>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-VmommX5JZMZtpmyOSzOZ1Y7YtdsizwpAFMzzCrQ3238RkEw@mail.gmail.com>
	<20121205104008.GA29382@pandem0nium>
	<50BF322A.900@openwrt.org>
	<CAJ-Vmok+D8vZE3BBZL5CwkegSpe9Sxi0OSzJmTeO8HA6Om4kcQ@mail.gmail.com>
Date: Mon, 17 Dec 2012 12:08:18 -0800
Message-ID: <CAJ-VmonUp16NsQMcJdZh0Aq6bAq3hRb28P5L5y7P1eP0_4WsKQ@mail.gmail.com> (sfid-20121217_211129_031572_A42A28DF)
Subject: Re: [RFC 3/3] ath9k: add spectral scan feature
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'll repost this, as it seems emailing lists.ath9k.org doesn't seem to work out.

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




Adrian
