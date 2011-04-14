Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59909 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab1DNOum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 10:50:42 -0400
Received: by qyk7 with SMTP id 7so3407681qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 07:50:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
	<BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com>
	<BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
	<201104131843.57676.chunkeey@googlemail.com>
	<BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
	<BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com>
	<BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
Date: Thu, 14 Apr 2011 16:50:40 +0200
Message-ID: <BANLkTingZRChrOtSPbat6D69_nW=6DpADw@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2011 at 4:40 PM, Damian Lesiuk <lesiuk@gmail.com> wrote:
> uniwersytecka-server ~ # iw wlan0 station dump
> Station 74:f0:6d:33:ea:00 (on wlan0)
>       inactive time:  20 ms
>       rx bytes:       5043668
>       rx packets:     9305
>       tx bytes:       13762256
>       tx packets:     11634
>       signal:         -31 dBm
>       tx bitrate:     65.0 MBit/s MCS 7
>
> So it helped in some way.
> Why that network isn't 300 mbps?

300mbps is only possible in HT40 mode. However, hostapd will disable
HT40 if it detects
an other HT40 AP on an overlapping channel (in your case anything
!=7). This is also
in accordance with 802.11n-2009.

Hostapd will print "40 MHz pri/sec mismatch with BSS ..." in that case.

Furthermore, it seems that the station 74:f0:6d:33:ea:00 isn't capable
of using multiple
spacial streams and thus is limited to MCS7. What client device is this?

Helmut
