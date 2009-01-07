Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:18822 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZAGGrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 01:47:00 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2613152yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 22:46:59 -0800 (PST)
Subject: Re: rate instability in wireless stack
From: =?ISO-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Jan 2009 04:46:53 -0200
Message-Id: <1231310813.23835.1.camel@note-tatin> (sfid-20090107_074705_974626_48F6D216)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I've rtl8187 usb wifi card on board (at less is inside my laptop=
)
and
I've some problems with the rate control.

When I use the PID algorithm with 2.6.26-1-686(debian) or 2.6.28 kernel=
s
or
minstrel with 2.6.28 it always goes to 54Mb/s, and it doesn't work. If =
I
run
iwconfig wlan0 rate 11M auto, it starts working. Its a little
"optimistic".

This is the rc_stats output
rate     throughput  ewma prob   this prob  this succ/attempt   success
attempts
  P  1         0.9       99.9      100.0          0(  0)        382
382
     2         1.9       99.9      100.0          0(  0)        222
222
     5.5       5.0       99.9      100.0          0(  0)        222
222
    11         9.5       99.9      100.0          4(  4)      48070
48070
     6         1.4       25.0      100.0          0(  0)          1
1
     9         3.6       43.7      100.0          0(  0)          2
2
 t  12        11.0       99.9      100.0          0(  0)        228
228
    18         4.0       25.0      100.0          0(  0)          1
1
    24         5.3       25.0      100.0          0(  0)          1
1
    36         7.6       25.0      100.0          0(  0)          1
1
    48         9.7       25.0      100.0          0(  0)          1
1
T   54        20.0       99.9      100.0          0(  0)         53
53

Total packet count::    ideal 8384      lookaround 441

All the attemps succeed, this is after I use iwconfig wlan0 rate 11M
auto,
otherwhise I couldn't write this, couse it stays at 54Mb/s and doesn't
works.

Today, january 7, I updated the driver with the compat-wireless tarball=
=2E
Now the
driver just stays in 1Mb/s.

rate     throughput  ewma prob   this prob  this succ/attempt   success
attempts
TtP  1         0.0        0.0        0.0          1(  0)          0
0
     2         0.0        0.0        0.0          0(  0)          0
0
     5.5       0.0        0.0        0.0          0(  0)          0
0
    11         0.0        0.0        0.0          0(  0)          0
0
     6         0.0        0.0        0.0          0(  0)          0
0
     9         0.0        0.0        0.0          0(  0)          0
0
    12         0.0        0.0        0.0          0(  0)          0
0
    18         0.0        0.0        0.0          0(  0)          0
0
    24         0.0        0.0        0.0          0(  0)          0
0
    36         0.0        0.0        0.0          0(  0)          0
0
    48         0.0        0.0        0.0          0(  0)          0
0
    54         0.0        0.0        0.0          0(  0)          0
0

Total packet count::    ideal 3546      lookaround 186

I send this problem to Larry, but since someone posted something simila=
r
I
thought it would be useful.

Mart=C3=ADn
--=20
Mart=C3=ADn Ernesto Barreyro <barreyromartin@gmail.com>

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
