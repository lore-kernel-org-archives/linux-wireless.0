Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34913 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYLBFga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 00:36:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 21:36:30 -0800
Date: Mon, 1 Dec 2008 13:36:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Irwan Siajadi <dev.bahamot@yahoo.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k: can't browse at all.
Message-ID: <20081201213640.GB6997@tesla> (sfid-20081202_063649_287300_85FA9227)
References: <63885.52788.qm@web59615.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <63885.52788.qm@web59615.mail.ac4.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 07:11:55PM -0800, Irwan Siajadi wrote:
> 
> 
> 
> --- On Mon, 12/1/08, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> 
> > From: Luis R. Rodriguez <lrodriguez@atheros.com>
> > Subject: Re: ath5k: can't browse at all.
> > To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> > Cc: "Pavel Roskin" <proski@gnu.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> > Date: Monday, December 1, 2008, 5:11 PM
> > On Sun, Nov 30, 2008 at 08:53:36AM -0800, Irwan Siajadi
> > wrote:
> > > --- On Tue, 11/25/08, Pavel Roskin
> > <proski@gnu.org> wrote:
> > >
> > > > From: Pavel Roskin <proski@gnu.org>
> > > > Subject: Re: ath5k: can't browse at all.
> > > > To: "Irwan Siajadi"
> > <dev.bahamot@yahoo.com>
> > > > Cc: linux-wireless@vger.kernel.org
> > > > Date: Tuesday, November 25, 2008, 8:02 PM
> > > > On Tue, 2008-11-25 at 09:24 -0800, Irwan Siajadi
> > wrote:
> > > >
> > > > > Further testing shows that if I change from
> > WPA2/AES
> > > > to WPA/TIKIP, I
> > > > > can finally browse. But it's still hit
> > and missed,
> > > > I need to reload
> > > > > the pages once or twice before the pages can
> > load
> > > > properly.
> > > >
> > > > Try disabling hardware crypto in the driver:
> > > >
> > > > rmmod ath5k
> > > > modprobe ath5k nohwcrypt=1
> > >
> > > Sorry for the late reply, being busy with other
> > stuffs.
> > > Anyway, disabling hardware cyrpto didn't make any
> > changes.
> > >
> > > >
> > > > In any case, check messages from wpa_supplicant.
> > Maybe
> > > > it's
> > > > reauthenticating very often.  If you flood ping
> > the router
> > > > ("ping -f"),
> > > > you would probably see growing dots that
> > represent lost
> > > > packets.
> > >
> > > Flood ping the router doesn't have any lost
> > packets (although only for a
> > > minute or so). And my router's log shows that the
> > laptop didn't
> > > re-authenticate very often.
> > >
> > > I've also compiled vanilla 2.6.26 and 2.6.27 with
> > ath5k (compat-wireless).
> > >
> > > - 2.6.26.8 + ath5k (compat-wireless-old-2008-11-29,
> > files last editted on
> > > 2008-09-16):
> > > -> ping shows some packets loss.
> > > -> can browse any websites.
> >
> > Lets focus on >= 2.6.27.
> >
> > >
> > > - 2.6.27.7 + ath5k (compat-wireless-2008-11-26):
> > > -> ping doesn't have any packet loss.
> > > -> can't browse, browser always waiting for the
> > response from the server.
> > > Monitoring the traffics shows that there are tx
> > packets, but there's no rx
> > > packets.
> > >
> > > Anything else I can try?
> >
> > You say you can ping fine but... browsing doesn't
> > work?? Maybe a
> > firewall issue?
> >
> > /etc/init.d/iptables stop
> >
> > I agree with Pavel this does not seem like a driver issue.
> > Do you have
> > your AP configured to disable :80 TCP communication? Can
> > you try a simple
> > netcat server and netcat client on different ports and also
> > on port 80
> > just to see if its really firewall/AP configuration.
> 
> 
> Firewall on both end (router-ap and laptop) is disabled.
> I can't do netcat on the server since it's not a PC box. It's an all in
> one unit (ADSL modem+AP+router). But I did wireshark on the laptop before
> reading your email. And I can see many TCP retransmission while trying to
> browse. If you like I can attach the log and send it to you.
> 
> 
> As comparison, I also do wireshark while using ndiswrapper. I can find TCP
> retransmission while using ndiswrapper, but doesn't really affect browsing
> or large file transfer through SMB.
> 
> 
> PS: If you prefer netcat, please tell me, I'll do that and send the log if
> you like.

I'll prefer a very simple netcat log. Do you understand why we find this so
strange? It may help to debug the issue at hand.

  Luis
