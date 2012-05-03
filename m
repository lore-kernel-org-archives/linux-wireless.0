Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38243 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2ECVoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:44:22 -0400
Received: by bkcji2 with SMTP id ji2so1755270bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 14:44:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: carl9170 - monitor mode TP drop
Date: Thu, 3 May 2012 23:44:17 +0200
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com> <201204251928.21559.chunkeey@googlemail.com> <1336031908.3459.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336031908.3459.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201205032344.17313.chunkeey@googlemail.com> (sfid-20120503_234425_767886_900E2D87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, May 03, 2012 09:58:28 AM Johannes Berg wrote:
> On Wed, 2012-04-25 at 19:28 +0200, Christian Lamparter wrote:
> > On Wednesday, April 25, 2012 07:28:18 AM Janusz Dziedzic wrote:
> > > W dniu 23 kwietnia 2012 19:45 użytkownik Christian Lamparter
> > > <chunkeey@googlemail.com> napisał:
> > > >> This is what I can see on STA1:
> > > >> # iperf -c 192.168.254.1 -t 100 -i 5
> > > >> [ 3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
> > > >>
> > > >> =====> here I setup carl monitor on second PC, like this:
> > > >> =====> iw dev wlan0 set type monitor
> > > >> =====> iw dev wlan0 set freq 2437
> > > >> =====> ifconfig wlan0 up
> > > >>
> > > >> [  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
> > > > Well, there's the "AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER = bit (30)"
> > > > in "AR9170_MAC_REG_RX_CONTROL = (0x1c3c40)".
> > > I disabled this in code.
> > > 
> > > -               rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> > > +//             rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> > > 
> > > After that I don't see any TP drop and can see all packets in
> > > wireshark (as expected).
> > > 
> > > Why carl try to ACK rx packets in monitor mode?
> > > Is that a correct behaviour?
> > Well, it depends.
> > 
> > You see without the BIT set, the hardware won't sent any ACKs
> > (Not even those which are directed at this interface - which of
> > course is also bad, or even worse?) and with the BIT set (and if
> > the HW is in Sniffer Mode) then the hardware acks every frames,
> > even if they are for a different stations.
> > So your fix might break someone else's setup.
> 
> You may want to implement the new monitor-mode-vif-to-driver thing in
> mac80211 which tells you when you're in *pure* monitor mode.

"the new monitor-mode-vif-to-driver"?
Do you mean like adding a new IFTYPE flag? Or more like a FIF_* flag
(probably)? for the "pure" monitor/sniffer mode?

Regards,
	Chr
