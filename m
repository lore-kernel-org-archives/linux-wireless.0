Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34777 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbZAXRpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 12:45:47 -0500
Message-ID: <497B53B4.5060302@lwfinger.net> (sfid-20090124_184553_887037_EFAF7197)
Date: Sat, 24 Jan 2009 11:45:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix driver to return TX retry info for	RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de> <20090123153144.GA13658@tuxdriver.com> <497B05AF.5050701@hauke-m.de>
In-Reply-To: <497B05AF.5050701@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens wrote:
> I did some more testing with and without the patch. With the patch it
> works when the rate is limited to 11M with pid and with minstrel
> algorithm. Without this limitation it works only with pid.

Of course, when you set a manual rate, the rate-setting method is
immaterial.

> Without this patch it also works with the limiting the rate to 11M with
> both rate control algorithms, but with minstrel it also works without
> limiting the rate.

Without the patch, minstrel is internally limited to 1 Mb/s TX rate.

> Without the patch, without limiting the rate and with minstrel iwconfig
> reports a rate of 1Mb/s, but I get 3Mb/s with wget, properly an other
> bug. With pid the rate goes up to 54Mb/s and it does not work.

The rate reported by iwconfig is for TX. The throughput from wget is
dependent on the TX rate of the AP. This info is useful, but the rates
from wput, or any other transmitting program, are more instructive to
find TX problems.

> With the patch, without limiting the rate and with minstrel iwconfig
> reports a rate of 24Mb/s and it does not work. With pid it starts with
> 1Mb/s and the connection is stable. The rate is changing between 1mb/s,
> 2Mb/s, 5.5Mb/s and 9Mb/s.

Please submit your rc_stats data for the minstrel case.

It is obvious that the RTL8187L does not do as well as other wireless
chips in low S/N conditions. It is also possible that some flavors of
the chips are better than others. In my Netgear WG111v2 with the patch
and using the minstrel algorithm, I get a TX rate between 21 and 22
Mb/s as measured with tcpperf at a distance of 2 m from my AP. The
rate reported by iwconfig is 54 Mb/s. When I move to ~15 m from the
AP, the rate falls off to ~12 Mb/s with iwconfig reporting 24-48 Mb/s.
At 20 m, the connection is essentially unusable - sounds like yours
the iwconfig rate is 24 Mb/s.

We are clearly flying blind here as we do not have a data sheet for
the RTL8187L. I got some help from the Realtek engineer regarding the
retry info, but that is the limit of my info. I do have what I think
is the latest version of the vendor driver, and I will compare the
power setting code with theirs.

The patch definitely helps my device as long as the reported signal
level is above -60 dBm. With lower signals, then it doesn't work very
well. Your device must be in that range.

Larry

