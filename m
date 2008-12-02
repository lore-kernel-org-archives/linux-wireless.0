Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n13b.bullet.mail.mud.yahoo.com ([68.142.207.222]:29247 "HELO
	n13b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753225AbYLBDSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 22:18:12 -0500
Date: Mon, 1 Dec 2008 19:11:55 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: Re: ath5k: can't browse at all.
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <63885.52788.qm@web59615.mail.ac4.yahoo.com> (sfid-20081202_041826_868750_DD101C85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Mon, 12/1/08, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:

> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: Re: ath5k: can't browse at all.
> To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> Cc: "Pavel Roskin" <proski@gnu.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Date: Monday, December 1, 2008, 5:11 PM
> On Sun, Nov 30, 2008 at 08:53:36AM -0800, Irwan Siajadi
> wrote:
> > --- On Tue, 11/25/08, Pavel Roskin
> <proski@gnu.org> wrote:
> > 
> > > From: Pavel Roskin <proski@gnu.org>
> > > Subject: Re: ath5k: can't browse at all.
> > > To: "Irwan Siajadi"
> <dev.bahamot@yahoo.com>
> > > Cc: linux-wireless@vger.kernel.org
> > > Date: Tuesday, November 25, 2008, 8:02 PM
> > > On Tue, 2008-11-25 at 09:24 -0800, Irwan Siajadi
> wrote:
> > >
> > > > Further testing shows that if I change from
> WPA2/AES
> > > to WPA/TIKIP, I
> > > > can finally browse. But it's still hit
> and missed,
> > > I need to reload
> > > > the pages once or twice before the pages can
> load
> > > properly.
> > >
> > > Try disabling hardware crypto in the driver:
> > >
> > > rmmod ath5k
> > > modprobe ath5k nohwcrypt=1
> > 
> > Sorry for the late reply, being busy with other
> stuffs.
> > Anyway, disabling hardware cyrpto didn't make any
> changes.
> > 
> > >
> > > In any case, check messages from wpa_supplicant. 
> Maybe
> > > it's
> > > reauthenticating very often.  If you flood ping
> the router
> > > ("ping -f"),
> > > you would probably see growing dots that
> represent lost
> > > packets.
> > 
> > Flood ping the router doesn't have any lost
> packets (although only for a
> > minute or so). And my router's log shows that the
> laptop didn't
> > re-authenticate very often.
> > 
> > I've also compiled vanilla 2.6.26 and 2.6.27 with
> ath5k (compat-wireless).
> > 
> > - 2.6.26.8 + ath5k (compat-wireless-old-2008-11-29,
> files last editted on
> > 2008-09-16):
> > -> ping shows some packets loss.
> > -> can browse any websites.
> 
> Lets focus on >= 2.6.27.
> 
> > 
> > - 2.6.27.7 + ath5k (compat-wireless-2008-11-26):
> > -> ping doesn't have any packet loss.
> > -> can't browse, browser always waiting for the
> response from the server.
> > Monitoring the traffics shows that there are tx
> packets, but there's no rx
> > packets.
> > 
> > Anything else I can try?
> 
> You say you can ping fine but... browsing doesn't
> work?? Maybe a
> firewall issue?
> 
> /etc/init.d/iptables stop
> 
> I agree with Pavel this does not seem like a driver issue.
> Do you have
> your AP configured to disable :80 TCP communication? Can
> you try a simple
> netcat server and netcat client on different ports and also
> on port 80
> just to see if its really firewall/AP configuration.


Firewall on both end (router-ap and laptop) is disabled.
I can't do netcat on the server since it's not a PC box. It's an all in 
one unit (ADSL modem+AP+router). But I did wireshark on the laptop before 
reading your email. And I can see many TCP retransmission while trying to 
browse. If you like I can attach the log and send it to you. 


As comparison, I also do wireshark while using ndiswrapper. I can find TCP 
retransmission while using ndiswrapper, but doesn't really affect browsing 
or large file transfer through SMB.


PS: If you prefer netcat, please tell me, I'll do that and send the log if 
you like.


> 
>   Luis

Irwan.



      

