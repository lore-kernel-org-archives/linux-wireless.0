Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54015 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab2DYSy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 14:54:59 -0400
Received: by bkuw12 with SMTP id w12so354306bku.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 11:54:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Subject: Re: carl9170 - monitor mode TP drop
Date: Wed, 25 Apr 2012 20:54:54 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com> <201204251928.21559.chunkeey@googlemail.com> <CAFED-j=_kPNmj-OyhFAdi_LM+rqbW6JLHC64BzdTKPyQ3iAMYg@mail.gmail.com>
In-Reply-To: <CAFED-j=_kPNmj-OyhFAdi_LM+rqbW6JLHC64BzdTKPyQ3iAMYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201204252054.54123.chunkeey@googlemail.com> (sfid-20120425_205525_953880_AF63FED4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 25, 2012 08:24:23 PM Janusz Dziedzic wrote:
> W dniu 25 kwietnia 2012 19:28 u¿ytkownik Christian Lamparter
> <chunkeey@googlemail.com> napisa³:
> > On Wednesday, April 25, 2012 07:28:18 AM Janusz Dziedzic wrote:
> > You see without the BIT set, the hardware won't sent any ACKs
> > (Not even those which are directed at this interface - which of
> > course is also bad, or even worse?) and with the BIT set (and if
> > the HW is in Sniffer Mode) then the hardware acks every frames,
> > even if they are for a different stations.
> > So your fix might break someone else's setup.
> >
> 
> As I understand, some time ago we had wpa_supplicant AP (GO) mode
> as a two interfaces: AP + MONITOR.
> But now MONITOR is not used.
> Do you know other setup?
I think you are refering to the "cooked" monitor interface, which is
just a monitor interface that gives you frames that mac80211 has
not used internally [mac80211: Add cooked monitor mode support].

In fact, most monitors are purly virtual interfaces, unless the
device only has one interface and it is set into monitor mode.
[So, if you don't want to deal with the RX_CTRL_ACK_IN_SNIFFER
bit all you need to do is: add a monitor interface (rather than
set the current interface into this mode) on your STA2 "client" 
<http://linuxwireless.org/en/users/Documentation/iw#Adding_interfaces_with_iw>

Note: This is actually the prefered, because you can use the "normal"
station interface to connect to the web and listen to the air with
the virtual monitor interface on the same device at the same time!]

> So, maybe firmware should ACK  frames with correct destination address
> only (if AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER)?
> Or that is not possible because of HW limitation?
The ACK mechanism (as well as most of the MAC) is done by the hardware
because of the critical timing [and lack of free space]. 

Regards,
	Chr
