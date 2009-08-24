Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:44917 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZHXSKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 14:10:09 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
Date: Mon, 24 Aug 2009 15:10:10 -0300
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200908220038.35564.herton@mandriva.com.br> <3ace41890908221459j70e31c20ufa5ea03973a16e0a@mail.gmail.com> <3ace41890908231238h32b85839qe74bce2852103402@mail.gmail.com>
In-Reply-To: <3ace41890908231238h32b85839qe74bce2852103402@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908241510.10968.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Dom 23 Ago 2009, às 16:38:43, Hin-Tak Leung escreveu:
> On Sat, Aug 22, 2009 at 10:59 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> > On Sat, Aug 22, 2009 at 4:38 AM, Herton Ronaldo
> > Krzesinski<herton@mandriva.com.br> wrote:
> >> This change implements rfkill support for RTL8187B and RTL8187L devices,
> >> using new cfg80211 rfkill API.
> >>
> >> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> >
> > Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> >
> > Neat!
> >
> > I ran a ping to the router while flicking the switch on and off, and
> > have 'ping: sendmsg: Network is unreachable' in the middle. dmesg also
> > shows
> 
> It appears that I wrote prematurely - flicking the switch with the
> patch seems to just do the equivalent of ifconfig down.

Yes, the equivalent of ifconfig down is what cfg80211 rfkill does in this case.

> (before the patch, the switch has no effect). However, NetworkManager
> soon notices the interface going down and ifup it again. So I have
> simply got a 30s to 1 minute disruption in connectivity.

This is strange, may be NetworkManager does something extra and for some reason
manages to wake up the interface again? I thought it would be unable to "if up"
the interface since -ERFKILL should be returned to it when switch is off...

> 
> Is this intentional? I thought it is supposed to actually switch off
> the hardware, or is this how the code supposed to work?
> Maybe some component needs to let NM knows not to reenanble the device.

About taking interface down, thats expected, but I don't know about
NetworkManager, I was expecting it to be unable to "if up" the interface again.

> 
> Hin-Tak
> 

-- 
[]'s
Herton
