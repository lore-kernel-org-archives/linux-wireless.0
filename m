Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbbJ2PQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 11:16:46 -0400
Message-ID: <1446131804.15968.3.camel@redhat.com> (sfid-20151029_161650_215133_7C1829A3)
Subject: Re: mwifiex problem: incompatible network settings
From: Dan Williams <dcbw@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Julien Cubizolles <j.cubizolles@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Date: Thu, 29 Oct 2015 10:16:44 -0500
In-Reply-To: <b2db7a93638f44b683aef052ca442c5c@SC-EXCH04.marvell.com>
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
	 <87twpd8fk4.fsf@free.fr> <1445972115005.99995@marvell.com>
	 <87a8r4ugth.fsf@free.fr> <1446043853.24757.51.camel@redhat.com>
	 <87vb9qsmg1.fsf@free.fr>
	 <b2db7a93638f44b683aef052ca442c5c@SC-EXCH04.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-29 at 12:27 +0000, Amitkumar Karwar wrote:
> Hi Julien,
> 
> > From: Julien Cubizolles [mailto:j.cubizolles@free.fr]
> > Sent: Thursday, October 29, 2015 3:09 AM
> > To: Dan Williams
> > Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org
> > Subject: Re: mwifiex problem: incompatible network settings
> > 
> > Dan Williams <dcbw@redhat.com> writes:
> > 
> > > He actually meant the wpa_supplicant configuration file, not the
> > > supplicant's dbus config file.  But when driven by NetworkManager,
> > > there is no supplicant configuration file.
> > 
> > Sorry about that.
> > 
> > > Instead, you can find out what config NM is pushing to the supplicant
> > > by checking the NetworkManager logs, where NM will log lines like:
> > 
> > Here are the relevant entries from the syslog file:
> > 
> > I included the failed attempt to connect to the WPA protected network
> > named "southcentral" and the successful one to a non protected one named
> > "FreeWifi".
> > 
> 
> Thanks for the logs. I compared your network manager log with the one on my setup. Both are same. Basically network manager log doesn't show security info (WPA/WPA2, encryption mode etc). So we can't rely on that.

NetworkManager leaves the 'protos' field empty, which allows the
supplicant to choose the correct WPA/WPA2 mode depending on driver
support.  What you see in the NM logs is exactly what gets pushed to the
supplicant in the network block.  So if you don't see "proto" or
"pairwise" or "group" in the NM logs, then it doesn't get pushed to the
supplicant, and the supplicant uses its default behavior, which should
be:

proto=WPA RSN
pairwise=CCMP TKIP
group=CCMP TKIP WEP104 WEP40

Dan

