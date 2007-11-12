Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:36604 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759258AbXKLW72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 17:59:28 -0500
Received: by py-out-1112.google.com with SMTP id u77so1560694pyb
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 14:59:26 -0800 (PST)
Message-ID: <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com> (sfid-20071112_225931_921489_FF368EC0)
Date: Mon, 12 Nov 2007 17:59:25 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Florian Lohoff" <flo@rfc822.org>
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071111102315.GC10486@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071111102315.GC10486@paradigm.rfc822.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 11, 2007 5:23 AM, Florian Lohoff <flo@rfc822.org> wrote:
>
> Hi,
> i today tried the in tree rt2x00 driver the first time and it immediatly
> felt a little sluggish. It sometimes feels a little as the driver is
> actually not using interrupts but rather polls at HZ rate or something.
> I can actually see the device generating interrupts in /proc/interrupts
> but still.
>
> Machine is a 2Ghz P4 with an PCI Ralink RT2500:

> While running an "find /" via ssh the output comes in and a second terminal shows this:

That is some pretty nasty latency. You didn't describe the setup for
your test, so I don't really have any insight into this problem. You
might want to check the wireless bitrate using the "iwconfig" command.

If the bitrate is really low, then the network latency problem is
explained. When the bitrate is low, it is much easier for a single
stream to saturate the connection (making for bad latency).

The output of "iwconfig" and "dmesg | grep rt2x00" would really help
in debugging this issue.

-- 
Will Dyson
