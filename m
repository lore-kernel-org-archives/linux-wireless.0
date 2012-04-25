Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60382 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab2DYR2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 13:28:36 -0400
Received: by bkuw12 with SMTP id w12so286580bku.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 10:28:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Subject: Re: carl9170 - monitor mode TP drop
Date: Wed, 25 Apr 2012 19:28:21 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com> <201204231945.05113.chunkeey@googlemail.com> <CAFED-j=4NWR2mjnooQs4V_T23cV9iPAUi65J-FZ7JjC28aZ=Gw@mail.gmail.com>
In-Reply-To: <CAFED-j=4NWR2mjnooQs4V_T23cV9iPAUi65J-FZ7JjC28aZ=Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201204251928.21559.chunkeey@googlemail.com> (sfid-20120425_192840_070867_199F0B3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 25, 2012 07:28:18 AM Janusz Dziedzic wrote:
> W dniu 23 kwietnia 2012 19:45 u¿ytkownik Christian Lamparter
> <chunkeey@googlemail.com> napisa³:
> >> This is what I can see on STA1:
> >> # iperf -c 192.168.254.1 -t 100 -i 5
> >> [ 3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
> >>
> >> =====> here I setup carl monitor on second PC, like this:
> >> =====> iw dev wlan0 set type monitor
> >> =====> iw dev wlan0 set freq 2437
> >> =====> ifconfig wlan0 up
> >>
> >> [  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
> > Well, there's the "AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER = bit (30)"
> > in "AR9170_MAC_REG_RX_CONTROL = (0x1c3c40)".
> I disabled this in code.
> 
> -               rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> +//             rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> 
> After that I don't see any TP drop and can see all packets in
> wireshark (as expected).
> 
> Why carl try to ACK rx packets in monitor mode?
> Is that a correct behaviour?
Well, it depends.

You see without the BIT set, the hardware won't sent any ACKs
(Not even those which are directed at this interface - which of
course is also bad, or even worse?) and with the BIT set (and if
the HW is in Sniffer Mode) then the hardware acks every frames,
even if they are for a different stations.
So your fix might break someone else's setup.

Regards,
	Chr
